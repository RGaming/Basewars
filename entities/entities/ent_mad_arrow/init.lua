// I took a look on Kogitsune's wiretrap code
// I took the .phy of the crossbow_bolt made by Silver Spirit

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()

	self.Owner = self.Entity:GetOwner()

	if !ValidEntity(self.Owner) then
		self:Remove()
		return
	end

	self.Entity:SetModel("models/crossbow_bolt.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(false)
	
//	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:EnableGravity(false)
		phys:EnableDrag(false) 
		phys:SetMass(2)
        	phys:Wake()
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		phys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
		phys:AddGameFlag(FVPHYSICS_PENETRATING)
	end

	self.Moving = true
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()

	local phys 		= self.Entity:GetPhysicsObject()
	local ang 		= self.Entity:GetForward() * 100000
	local up		= self.Entity:GetUp() * -800

	local force		= ang + up

	phys:ApplyForceCenter(force)

	if (self.Entity.HitWeld) then  
		self.HitWeld = false  
		constraint.Weld(self.Entity.HitEnt, self.Entity, 0, 0, 0, true)  
	end 
end

/*---------------------------------------------------------
   Name: ENT:Impact()
---------------------------------------------------------*/
function ENT:Impact(sent, normal, pos)

	if not ValidEntity(self) then
		return
	end

	local tr, info

	tr = {}
		tr.start = self:GetPos()
		tr.filter = {self, self.Owner}
		tr.endpos = pos
	tr = util.TraceLine(tr)

	if tr.HitSky then self:Remove() return end

	bullet = {}
	bullet.Num    = 1
	bullet.Src    = pos
	bullet.Dir    = normal
	bullet.Spread = Vector(0, 0, 0)
	bullet.Tracer = 0
	bullet.Force  = 0
	bullet.Damage = 0
	self.Entity:FireBullets(bullet)

	if not sent:IsPlayer() and not sent:IsNPC() then
		local effectdata = EffectData()
			effectdata:SetOrigin(pos - normal * 10)
			effectdata:SetEntity(self.Entity)
			effectdata:SetStart(pos)
			effectdata:SetNormal(normal)
		util.Effect("effect_mad_shotgunsmoke", effectdata)
	end

	if ValidEntity(sent) then
		info = DamageInfo()
			info:SetAttacker(self.Owner)
			info:SetInflictor(self)
			info:SetDamageType(DMG_GENERIC | DMG_SHOCK)
			info:SetDamage(100)
			info:SetMaxDamage(100)
			info:SetDamageForce(tr.HitNormal * 10)

		self.Entity:EmitSound("Weapon_Crossbow.BoltHitBody")
		sent:TakeDamageInfo(info)

		self.Entity:Remove()
		return
	end
	
	self.Entity:EmitSound("Weapon_Crossbow.BoltHitWorld")

	// We've hit a prop, so let's weld to it
	// Also embed this in the object for looks

	self:SetPos(pos - normal * 10)
	self:SetAngles(normal:Angle())
	
	if not ValidEntity(sent) then
		self:GetPhysicsObject():EnableMotion(false)
	end

	self.Entity:Fire("kill", "", 10)
end

/*---------------------------------------------------------
   Name: ENT:PhysicsCollide()
---------------------------------------------------------*/
function ENT:PhysicsCollide(data, phys)

	if self.Moving then
		self.Moving = false
		phys:Sleep()
		self.Entity:Impact(data.HitEntity, data.HitNormal, data.HitPos)
	end
end