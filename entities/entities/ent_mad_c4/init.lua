AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()

	self.Owner = self.Entity.Owner

	if !ValidEntity(self.Owner) then
		self:Remove()
		return
	end

	self.Entity:SetModel("models/weapons/w_c4_planted.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(false)

	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	local phys = self.Entity:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end

	self.Used = false

	self.Defuse	= 0
	self.DefuseDelay = CurTime()

	self:SetDTInt(0, self.Timer)
	self.ThinkTimer = CurTime() + self:GetDTInt(0)
end

/*---------------------------------------------------------
   Name: ENT:Use()
---------------------------------------------------------*/
function ENT:Use(activator, caller)

	self.Used = true
	self.Defuser = activator
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()

	if not self.Used then
		if self.DefuseDelay < CurTime() then
			self.Defuse = math.Clamp(self.Defuse - 0.02, 0, 1)
			self.DefuseDelay = CurTime() + 0.1
		end
	elseif self.Used then
		if self.DefuseDelay < CurTime() then
			self.Defuse = math.Clamp(self.Defuse + 0.02, 0, 1)
			self.DefuseDelay = CurTime() + 0.1
		end
	end

	self.Entity:SetColor(255, 255 * (1 - self.Defuse), 255 * (1 - self.Defuse), 255)

	if self.Defuse >= 1 then
		self.Entity:Remove()
		self:EmitSound("C4.DisarmFinish")
		self.Defuser:PrintMessage(HUD_PRINTTALK, "You've defused the bomb.")
	end

	if self.ThinkTimer < CurTime() then
		self:Explosion()
	end

	self.Used = false
	self.Defuser = nil
end

/*---------------------------------------------------------
   Name: ENT:Explosion()
---------------------------------------------------------*/
function ENT:Explosion()

	local trace = {}
	trace.start = self.Entity:GetPos() + Vector(0, 0, 32)
	trace.endpos = self.Entity:GetPos() - Vector(0, 0, 128)
	trace.Entity = self.Entity
	trace.mask  = 16395
	local Normal = util.TraceLine(trace).HitNormal

	self.Scale = 6
	self.EffectScale = self.Scale ^ 0.65

	local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos())
	util.Effect("HelicopterMegaBomb", effectdata)

	local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos())
		effectdata:SetNormal(Normal)
		effectdata:SetScale(self.EffectScale)
	util.Effect("effect_mad_ignition", effectdata)

	local explo = ents.Create("env_explosion")
		explo:SetOwner(self.Owner)
		explo:SetPos(self.Entity:GetPos())
		explo:SetKeyValue("iMagnitude", "500")
		explo:Spawn()
		explo:Activate()
		explo:Fire("Explode", "", 0)
	
	local shake = ents.Create("env_shake")
		shake:SetOwner(self.Owner)
		shake:SetPos(self.Entity:GetPos())
		shake:SetKeyValue("amplitude", "2000")	// Power of the shake
		shake:SetKeyValue("radius", "1250")		// Radius of the shake
		shake:SetKeyValue("duration", "2.5")	// Time of shake
		shake:SetKeyValue("frequency", "255")	// How har should the screenshake be
		shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)

	local ar2Explo = ents.Create("env_ar2explosion")
		ar2Explo:SetOwner(self.Owner)
		ar2Explo:SetPos(self.Entity:GetPos())
		ar2Explo:Spawn()
		ar2Explo:Activate()
		ar2Explo:Fire("Explode", "", 0)

	self.Entity:EmitSound(Sound("C4.Explode"))

	self.Entity:Remove()

	local en = ents.FindInSphere(self.Entity:GetPos(), 400)
	
end