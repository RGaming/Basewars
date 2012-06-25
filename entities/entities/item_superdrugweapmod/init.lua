
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
	if !caller:GetTable().Superdrugoffense && !caller:GetTable().Superdrugdefense && !caller:GetTable().Superdrugweapmod then
		caller:SetNWBool("superdrug", true)
		
		Focusup(caller, CfgVars["superduration"])
		DoubleTapup(caller, CfgVars["superduration"])
		ShockWaveup(caller, CfgVars["superduration"])
		Knockbackup(caller, CfgVars["superduration"])
		MagicBulletup(caller, CfgVars["superduration"])
		Randup(caller,CfgVars["superduration"])
		Superup(caller,CfgVars["superduration"],"weapmod")
		
		caller:SetNWBool("superdrug", false)
		self.Entity:Remove()
	end
end

function ENT:Think()
end

// it takes so much in the game to create a single one, lets not have it just be destroyed so easily
function ENT:OnTakeDamage(dmg)
end