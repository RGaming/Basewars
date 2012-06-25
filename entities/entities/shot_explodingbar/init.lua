/* ======================================
	EXPLODING CROWBAR
   ====================================== */

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 20
	
	local ent = ents.Create( "bigbomb" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
	
end
/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/

function ENT:Initialize()
	self.Entity:SetModel("models/weapons/w_crowbar.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.DidHit=false
end

function ENT:Think()
	if (ValidEntity(self.Entity:GetOwner())==false) then
		self.Entity:Remove()
	end
end

function ENT:HitShit()
	self.Entity:GetPhysicsObject():Wake()
	self.DidHit = true
end
function ENT:Explode()
	util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 384, 250 )
	local effectdata = EffectData()
		effectdata:SetStart(self.Entity:GetPos())
		effectdata:SetOrigin(self.Entity:GetPos())
		effectdata:SetScale(1.5)
	util.Effect("HelicopterMegaBomb", effectdata)
	local effectdata2 = EffectData()
		effectdata2:SetStart(self.Entity:GetPos())
		effectdata2:SetOrigin(self.Entity:GetPos())
		effectdata2:SetScale(1.5)
	util.Effect("Explosion", effectdata2)
	self.Entity:EmitSound(Sound("weapons/explode3.wav"))
	self.Entity:Remove()
end

function ENT:Touch()
	self.DidHit = true
end
function ENT:PhysicsUpdate()
	if (self.DidHit == true) then
		self.Entity:Explode()
	end
end
function ENT:PhysicsCollide( data, physobj )
	self.DidHit = true
end 