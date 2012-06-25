
/*---------------------------------------------------------
   Name: Make the table if it doesn't exist
---------------------------------------------------------*/
if ( !sql.TableExists( "ratings" ) ) then

	sql.Query( "CREATE TABLE IF NOT EXISTS ratings ( id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, target INTEGER, rater INTEGER, rating INTEGER );" )
	sql.Query( "CREATE INDEX IDX_RATINGS_TARGET ON ratings ( target DESC )" )
	Msg("SQL: Created ratings table!\n")
	
end


/*---------------------------------------------------------
   Name: ValidRatings - only these ratings are valid!
---------------------------------------------------------*/
local ValidRatings = { "hatedbymingebags", "smile", "love", "artistic", "star", "builder" }

local function GetRatingID( name )

	for k, v in pairs( ValidRatings ) do
		if ( name == v ) then return k end
	end
	
	return false

end


/*---------------------------------------------------------
   Name: Update the player's networkvars based on the DB
---------------------------------------------------------*/
local function UpdatePlayerRatings( ply )

	local result = sql.Query( "SELECT rating, count(*) as cnt FROM ratings WHERE target = "..ply:UniqueID().." GROUP BY rating " )
	
	if ( !result ) then return end
	
	for id, row in pairs( result ) do
	
		ply:SetNetworkedInt( "Rating."..ValidRatings[ tonumber( row['rating'] ) ], tonumber( row['cnt'] ) )
	
	end

end
	
/*---------------------------------------------------------
   Name: CCRateUser
---------------------------------------------------------*/
local function CCRateUser( player, command, arguments )

	local Rater 	= player
	local Target 	= Entity( tonumber( arguments[1] ) )
	local Rating	= arguments[2]
	
	// Don't rate non players
	if ( !Target:IsPlayer() ) then return end
	
	// Don't rate self
	if ( Rater == Target ) then return end
	
	local RatingID = GetRatingID( Rating )
	local RaterID = Rater:UniqueID()
	local TargetID = Target:UniqueID()
	
	// Rating isn't valid
	if (!RatingID) then return end
	
	// When was the last time this player rated this player
	// Only let them rate each other evre 60 seconds
	Target.RatingTimers = Target.RatingTimers or {}
	if ( Target.RatingTimers[ RaterID ] && Target.RatingTimers[ RaterID ] > CurTime() - 60 ) then
	
		Rater:ChatPrint( "Please wait before rating ".. Target:Nick() .." again.\n" );
		return
		
	end
	
	Target.RatingTimers[ RaterID ] = CurTime()
	
	// Tell the target that they have been rated (but don't tell them who to add to the fun and bitching)
	Target:ChatPrint( Rater:GetName() .." has given you the rating ".. tostring(arguments[2]) ..".\n" );
		
	// Let the rater know that their vote was counted
	Rater:ChatPrint( "Rated ".. Target:Nick() .."!\n" );
	
	sql.Query( "INSERT INTO ratings ( target, rater, rating ) VALUES ( "..TargetID..", "..RaterID..", "..RatingID.." )" )

	// We changed something so update the networked vars
	UpdatePlayerRatings( Target )
	
end

concommand.Add( "rateuser", CCRateUser )


/*---------------------------------------------------------
   When the player joins the server we 
   need to restore the NetworkedInt's
---------------------------------------------------------*/
local function PlayerRatingsRestore( ply )

	UpdatePlayerRatings( ply )

end
hook.Add( "PlayerInitialSpawn", "PlayerRatingsRestore", PlayerRatingsRestore )

