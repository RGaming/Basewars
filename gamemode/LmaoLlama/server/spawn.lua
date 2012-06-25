

local Map = game.GetMap()

local SpawnPositions = {}

SpawnPositions["gm_construct"] = Vector(493, -238,85)
SpawnPositions["gm_flatgrass"] = Vector(608, -41,321)
SpawnPositions["bw_city18"] = Vector(-83, -447,1021)
SpawnPositions["bw_LL_downtown"] = Vector(-1395, -2441, 80)
local SpawnAngles = {}

SpawnAngles["gm_construct"] = Angle(90, 180, 180)
SpawnAngles["gm_flatgrass"] = Angle(90, 180, 180)
SpawnAngles["basewars_city18"] = Angle(-6, 92, 0)
SpawnAngles["basewars_LL_downtown"] = Angle(0, 90, 0)
setpos -1395.423828 -2441.287842 80.031250;setang -2.079997 91.660515 0.000000


function SpawnScoreboard()

	local ent = ents.Create( "LuaScoreboard" )
	ent:SetPos(SpawnPositions[Map])
	ent:SetAngles(SpawnAngles[Map])
 	ent:Spawn() 

end
hook.Add("InitPostEntity", "SpawnScoreboard", SpawnScoreboard)