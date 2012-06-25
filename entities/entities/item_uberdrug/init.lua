
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
	
	Regenup(caller, CfgVars["uberduration"])
	Roidup(caller, CfgVars["uberduration"])
	Ampup(caller, CfgVars["uberduration"])
	PainKillerup(caller, CfgVars["uberduration"])
	Mirrorup(caller, CfgVars["uberduration"])
	
	Focusup(caller, CfgVars["uberduration"])
	MagicBulletup(caller, CfgVars["uberduration"])
	Adrenalineup(caller, CfgVars["uberduration"])
	DoubleJumpup(caller, CfgVars["uberduration"])
	Leechup(caller, CfgVars["uberduration"])
	
	ShockWaveup(caller, CfgVars["uberduration"])
	DoubleTapup(caller, CfgVars["uberduration"])
	Knockbackup(caller, CfgVars["uberduration"])
	ArmorPiercerup(caller, CfgVars["uberduration"])
	Antidoteup(caller, CfgVars["uberduration"])
	
	caller:SetNWBool("superdrug", false)
	self.Entity:Remove()
end

function ENT:Think()
end

// it takes so much in the game to create a single one, lets not have it just be destroyed so easily
function ENT:OnTakeDamage(dmg)
end