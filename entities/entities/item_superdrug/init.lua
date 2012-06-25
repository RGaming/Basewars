
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 20
	
	local ent = ents.Create( "item_superdrug" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
	
end

function ENT:Initialize()

	self.Entity:SetModel( "models/props_lab/jar01a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	self.Time = CurTime()
end

function ENT:Use(activator,caller)
	caller:SetNWBool("superdrug", true)
	if (caller:GetTable().Regened != true) then
		Regenup(caller, CfgVars["superduration"])
	end
	if (caller:GetTable().Roided != true) then
		Roidup(caller, CfgVars["superduration"])
	end
	if (caller:GetTable().Amp != true) then
		Ampup(caller, CfgVars["superduration"])
	end
	if (caller:GetTable().PainKillered != true) then
		PainKillerup(caller, CfgVars["superduration"])
	end
	if (caller:GetTable().Mirror != true) then
		Mirrorup(caller, CfgVars["superduration"])
	end
	if (caller:GetTable().Focus != true) then
		Focusup(caller, CfgVars["superduration"])
	end
	// lol.
	if (caller:GetTable().Antidoted != true) then
		Antidoteup(caller, CfgVars["superduration"])
	end
	caller:SetNWBool("superdrug", false)
	self.Entity:Remove()
end

function ENT:Think()
end

// it takes so much in the game to create a single one, lets not have it just be destroyed so easily
function ENT:OnTakeDamage(dmg)
end