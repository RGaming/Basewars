

local hud_deathnotice_time = CreateConVar( "hud_deathnotice_time", "6", FCVAR_REPLICATED )

// These are our kill icons
local Color_Icon = Color( 255, 80, 0, 255 ) 
local NPC_Color = Color( 250, 50, 50, 255 ) 

surface.CreateFont( "csd", ScreenScale( 20 ), 500, true, true, "Upgradedeath" )
surface.CreateFont( "HalfLife2", ScreenScale(32), 500, true, true, "Beamsymbol" );

killicon.AddFont( "prop_physics", 		"HL2MPTypeDeath", 	"9", 	Color_Icon )
killicon.AddFont( "weapon_smg1", 		"HL2MPTypeDeath", 	"/",	Color_Icon )
killicon.AddFont( "weapon_357", 		"HL2MPTypeDeath", 	".", 	Color_Icon )
killicon.AddFont( "weapon_ar2", 		"HL2MPTypeDeath", 	"2", 	Color_Icon )
killicon.AddFont( "crossbow_bolt", 		"HL2MPTypeDeath", 	"1", 	Color_Icon )
killicon.AddFont( "weapon_shotgun", 		"HL2MPTypeDeath", 	"0", 	Color_Icon )
killicon.AddFont( "rpg_missile", 		"HL2MPTypeDeath", 	"3", 	Color_Icon )
killicon.AddFont( "npc_grenade_frag", 		"HL2MPTypeDeath", 	"4", 	Color_Icon )
killicon.AddFont( "weapon_pistol", 		"HL2MPTypeDeath", 	"-", 	Color_Icon )
killicon.AddFont( "prop_combine_ball", 		"HL2MPTypeDeath", 	"8", 	Color_Icon )
killicon.AddFont( "grenade_ar2", 		"HL2MPTypeDeath", 	"7", 	Color_Icon )
killicon.AddFont( "weapon_stunstick", 		"HL2MPTypeDeath", 	"!", 	Color_Icon )
killicon.AddFont( "weapon_slam", 		"HL2MPTypeDeath", 	"*", 	Color_Icon )
killicon.AddFont( "weapon_crowbar", 		"HL2MPTypeDeath", 	"6", 	Color_Icon )
killicon.AddFont( "player",			"CSKillIcons",		"H",	Color_Icon )
killicon.AddFont( "*upgrade",			"Upgradedeath",		"K",	Color(200,200,200,255) )
killicon.AddFont( "*headshot",			"CSKillIcons",		"D",	Color(100,100,100,255) )
killicon.AddFont( "*beamdot",			"Beamsymbol",		"Z",	Color(200,100,0,255) )
local Deaths = {}

local function PlayerIDOrNameToString( var )

	if ( type( var ) == "string" ) then 
		if ( var == "" ) then return "" end
		return "#"..var 
	end
	
	local ply = Entity( var )
	
	if (ply == NULL) then return "NULL!" end
	
	return ply:Name()
	
end


local function RecvPlrKilledByPlr( message )

	local victim 	= message:ReadEntity();
	local inflictor	= message:ReadEntity();
	local attacker 	= message:ReadEntity();
	local class	= message:ReadString();
	local headshot = message:ReadBool()
	GAMEMODE:AddDeathNotice2( attacker:Name(), attacker:Team(), class, victim:Name(), victim:Team(), inflictor, headshot )

end
	
usermessage.Hook( "PlrKilledPlr", RecvPlrKilledByPlr )


local function RecvPlrKilledSelf( message )
	local victim 	= message:ReadEntity();	
	local inflictor = message:ReadEntity();	
	local class	= message:ReadString();
	local headshot = message:ReadBool()
	
	GAMEMODE:AddDeathNotice2( nil, -1, class, victim:Name(), victim:Team(), inflictor, headshot )

end
	
usermessage.Hook( "PlrKilledSelf", RecvPlrKilledSelf )


local function RecvPlrKilled( message )
	local victim 	= message:ReadEntity();
	local inflictor	= message:ReadEntity();
	local attacker 	= "#" .. message:ReadString();
	local class	= message:ReadString();
	local headshot = message:ReadBool()
			
	GAMEMODE:AddDeathNotice2( attacker, -1, class, victim:Name(), victim:Team(), inflictor, headshot )

end
	
usermessage.Hook( "PlrKilled", RecvPlrKilled )

local function RecvPlrKilledNPC( message )
	local victim 	= "#" .. message:ReadString();
	local inflictor	= message:ReadEntity();
	local attacker 	= message:ReadEntity();
	local class	= message:ReadString();
	
	GAMEMODE:AddDeathNotice2( attacker:Name(), attacker:Team(), class, victim, -1, inflictor, false )

end
	
usermessage.Hook( "PlrKilledNPC", RecvPlrKilledNPC )


local function RecvNPCKillNPC( message )
	local victim 	= "#" .. message:ReadString();
	local inflictor	= message:ReadEntity();
	local attacker 	= "#" .. message:ReadString();
	local class	= message:ReadString();
	GAMEMODE:AddDeathNotice2( attacker, -1, class, victim, -1, inflictor, false )

end
	
usermessage.Hook( "NPCKillNPC", RecvNPCKillNPC )




/*---------------------------------------------------------
   Name: gamemode:AddDeathNotice( Victim, Attacker, Weapon )
   Desc: Adds an death notice entry
---------------------------------------------------------*/
function GM:AddDeathNotice2( Victim, team1, Inflictor, Attacker, team2, inflictorent, headshot)

	local Death = {}
	Death.victim 	= 	Victim
	Death.attacker	=	Attacker
	Death.time		=	CurTime()
	
	Death.left		= 	Victim
	Death.right		= 	Attacker
	Death.icon		=	Inflictor
	if ValidEntity(inflictorent) then
		Death.upgrade		=	tobool(inflictorent:GetNWBool("upgraded"))
	else
		Death.upgrade		=	false
	end
	if Inflictor=="weapon_laserrifle" then
		Death.beamtype		=	"C"
	elseif Inflictor=="weapon_lasergun" then
		Death.beamtype		=	"L"
	elseif Inflictor=="shot_energy" then
		Death.beamtype		=	"P"
	else
		Death.beamtype		=	nil
	end
	if headshot then
		Death.headshot = true
	end
	if ( team1 == -1 ) then Death.color1 = table.Copy( NPC_Color )
	else Death.color1 = table.Copy( team.GetColor( team1 ) ) end
		
	if ( team2 == -1 ) then Death.color2 = table.Copy( NPC_Color ) 
	else Death.color2 = table.Copy( team.GetColor( team2 ) ) end
	
	if (Death.left == Death.right) then
		Death.left = nil
	end
	table.insert( Deaths, Death )

end

local function DrawDeath( x, y, death, hud_deathnotice_time )

	local w, h = killicon.GetSize( death.icon )
	local w2 = 0
	local h2 = 0
	if death.headshot then
		w2, h2 = killicon.GetSize("*headshot")
	end
	
	local fadeout = ( death.time + hud_deathnotice_time ) - CurTime()
	
	local alpha = math.Clamp( fadeout * 255, 0, 255 )
	death.color1.a = alpha
	death.color2.a = alpha
	
	// Draw Icon
	if death.beamtype!=nil then
		killicon.Draw(x+(w/2.5)-3,y-16,"*beamdot", alpha)
		draw.SimpleText( death.beamtype, 	"DefaultSmall", x+(w/2)-5, y+2, 		Color(0,0,0,alpha), 	TEXT_ALIGN_RIGHT )
	end
	killicon.Draw( x, y, death.icon, alpha )
	if death.upgrade then
		killicon.Draw(x+(w/1.75),y+8,"*upgrade", alpha)
	end
	if death.headshot then
		killicon.Draw(x+w,y,"*headshot", alpha)
	end
	// Draw KILLER
	if (death.left) then
		draw.SimpleText( death.left, 	"ChatFont", x - (w/2) + (w2*0.5) - 16, y, 		death.color1, 	TEXT_ALIGN_RIGHT )
	end
	
	// Draw VICTIM
	draw.SimpleText( death.right, 		"ChatFont", x + (w/2) + w2 + 16, y, 		death.color2, 	TEXT_ALIGN_LEFT )
	
	return (y + h*0.70)

end


function GM:DrawDeathNotice( x, y )

	local hud_deathnotice_time = hud_deathnotice_time:GetFloat()

	x = x * ScrW()
	y = y * ScrH()
	
	// Draw
	for k, Death in pairs( Deaths ) do

		if (Death.time + hud_deathnotice_time > CurTime()) then
	
			if (Death.lerp) then
				x = x * 0.3 + Death.lerp.x * 0.7
				y = y * 0.3 + Death.lerp.y * 0.7
			end
			
			Death.lerp = Death.lerp or {}
			Death.lerp.x = x
			Death.lerp.y = y
		
			y = DrawDeath( x, y, Death, hud_deathnotice_time )
		
		end
		
	end
	
	// We want to maintain the order of the table so instead of removing
	// expired entries one by one we will just clear the entire table
	// once everything is expired.
	for k, Death in pairs( Deaths ) do
		if (Death.time + hud_deathnotice_time > CurTime()) then
			return
		end
	end
	
	Deaths = {}

end