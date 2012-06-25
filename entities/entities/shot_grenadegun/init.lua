/* ======================================
	shot_grenadegun
	grenadegun round
   ====================================== */

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.Entity:SetModel( "models/items/combine_rifle_ammo01.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetKeyValue("physdamagescale", "9999")
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.DidHit = false
	self.GoofyTiem = CurTime()
	util.SpriteTrail(self.Entity, 0, Color(200,200,200), false, 16, 1, 1.5, 1/8.5, "trails/smoke.vmt")
	self.Entity:GetPhysicsObject():SetVelocity(self.Entity:GetUp()*2000)
	timer.Create( self.Entity .. "blowup", 4, 1, self.HitShit, self)
end

function ENT:Think()
	if (self.GoofyTiem < CurTime()-5) then
		self.DidHit = true
	end
end

function ENT:OnRemove()
	timer.Destroy(self.Entity .. "blowup")
end

function ENT:PhysicsCollide( data, physobj )
	
end 
function ENT:Touch()
	self.DidHit = true
end
function ENT:PhysicsUpdate()
	if (self.DidHit == true) then
		util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 250, 90 )
	
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
	
		self.Entity:Fire("kill", "", 0)
		self.Entity:EmitSound(Sound("weapons/explode3.wav"))
		self.Entity:Remove()
	end
end
function ENT:HitShit()
	self.Entity:GetPhysicsObject():Wake()
	self.DidHit = true
	Msg("!")
end