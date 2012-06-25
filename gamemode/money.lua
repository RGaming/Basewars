if ( !sql.TableExists( "rpdmmoney" ) ) then
	
	sql.Query( "CREATE TABLE IF NOT EXISTS rpdmmoney (Money TEXT, SteamID TEXT)" )
end

local sql		=	sql
local Format	=	Format
local SQLStr	=	SQLStr

local meta = FindMetaTable( "Player" )

local function FormatID( str )
	
	return str:lower():gsub( ":", "_" )
end

function UpdateMoney( self, value )
	
	umsg.Start( "MoneyChange", self )
		
		umsg.Short( 0 )
		umsg.Long( value )
		
	umsg.End( )
end

function SetMoney( self )
	local id
	
	id = self:SteamID()
	id = FormatID( id )
	
	if ( tonumber( self.Money ) ~= nil ) then
		local str = Format( "UPDATE rpdmmoney SET Money = %s WHERE SteamID = %s", self.Money, SQLStr( id ) )
		
		sql.Query( str )
	end
end

function GetMoney( self )
	local id, money
	
	id = self:SteamID()
	id = FormatID( id )
	
	money = sql.QueryValue( Format( "SELECT Money FROM rpdmmoney WHERE SteamID = %s", SQLStr( id ) ) )
	money = tonumber( money ) || sql.Query( Format( "INSERT INTO rpdmmoney (SteamID, Money) VALUES (%s, 5000)", SQLStr( id ) ) ) || 5000
	
	self.Money = math.min( math.ceil( money ), 2147483647 )
	
	UpdateMoney( self, self.Money )
end

// aliases for nigtits
setMoney = SetMoney
getMoney = GetMoney

/*function getMoney(player)
	
	local IDSteam = string.lower(string.gsub(player:SteamID(), ":", ""))
	
	local money = sql.QueryValue("SELECT Money FROM rpdmmoney WHERE SteamID='"..IDSteam.."'")
	//PrintTable(table)

	local plmoney = 25000
	if money != nil then
		plmoney = math.ceil(tonumber(money))
	else
		Msg("Adding new user: " ..IDSteam.."\n")
		sql.Query("INSERT INTO rpdmmoney (Money, SteamID) VALUES ('"..IDSteam.."', 5000)")
	end
	player:GetTable().Money = plmoney
	// if its more than a long, just basically say A LOT
	if (player:GetTable().Money>10000000000000) then
		plmoney = 10000000000000
	end
	umsg.Start("MoneyChange", player)
		umsg.Short(0)
		umsg.Long(plmoney)
	umsg.End()
end*/

/*function setMoney(player, amount)
	local IDSteam = string.lower(string.gsub(player:SteamID(), ":", ""))
	//player:GetTable().Money = player:GetTable().Money+amount
	if tonumber(player:GetTable().Money)!=nil then
		sql.Query("UPDATE rpdmmoney SET Money = ".. tostring(player:GetTable().Money .. "WHERE SteamID='"..IDSteam.."'"))
	end
end*/