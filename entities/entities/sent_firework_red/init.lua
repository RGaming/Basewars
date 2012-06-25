AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.StartColor = Color(255, 50, 50)
ENT.EndColor = Color(255, 50, 50)
ENT.LifeTime = 0
ENT.DieTime = 5

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "sent_firework_red" )
		ent:SetPos( SpawnPos )
		ent:SetAngles( Angle(180, 0, 0) )
	ent:Spawn()
	ent:Activate()
	ent.Owner = ply
	
	return ent
	
end
