/* ======================================
	bigbomb_fragment
	Big Bomb bomblet
   ====================================== */

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.Entity:SetModel( "models/items/battery.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	// self.DidHit = false
	// self.GoofyTiem = CurTime()
	util.SpriteTrail(self.Entity, 0, Color(200,200,200), false, 16, 1, 1.2, 1/8.5, "trails/smoke.vmt")
	// self.Entity:GetPhysicsObject():SetVelocity(self.Entity:GetUp()*2000)
	timer.Create( tostring(self.Entity) .. "blowup", 2.5+math.random(), 1, self.Explode, self)
end

function ENT:Think()
	if (ValidEntity(self.Owner)==false) then
		self.Entity:Remove()
	end
end

function ENT:OnRemove()
	timer.Destroy(tostring(self.Entity) .. "blowup")
end
function ENT:Explode()
	util.BlastDamage( self.Entity, self.Owner, self.Entity:GetPos(), 384, 150 )
	
	local effectdata = EffectData()
		effectdata:SetStart(self.Entity:GetPos())
		effectdata:SetOrigin(self.Entity:GetPos())
		effectdata:SetScale(3)
	util.Effect("HelicopterMegaBomb", effectdata)
	
	local effectdata2 = EffectData()
		effectdata2:SetStart(self.Entity:GetPos())
		effectdata2:SetOrigin(self.Entity:GetPos())
		effectdata2:SetScale(3)
	util.Effect("Explosion", effectdata2)
	
	self.Entity:EmitSound(Sound("weapons/c4/c4_explode1.wav"))
	self.Entity:Remove()
end