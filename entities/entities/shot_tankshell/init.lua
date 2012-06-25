/* ======================================
	shot_tankshell
	stfu tank shell
   ====================================== */

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.Entity:SetModel( "models/props_junk/propanecanister001a.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetKeyValue("physdamagescale", "9999")
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(false)
	end
	self.DidHit = false
	self.GoofyTiem = CurTime()
	util.SpriteTrail(self.Entity, 0, Color(200,200,200), false, 20, 1, 2, 1/8.5, "trails/smoke.vmt")
	/*
	self.SmokeTrail = ents.Create("env_rockettrail")
	self.SmokeTrail:SetPos(self.Entity:GetPos() + self.Entity:GetForward()*-15)
	self.SmokeTrail:SetAngles(self.Entity:GetAngles())
	self.SmokeTrail:SetParent(self.Entity)
	self.SmokeTrail:Spawn()
	*/
end

function ENT:Think()
	if (ValidEntity(self.Entity:GetOwner())==false) then
		self.Entity:Remove()
	end
	// self.Entity:GetPhysicsObject():SetVelocity(self.Entity:GetUp()*4000)
end

function ENT:PhysicsCollide( data, physobj )
	data.HitNormal = data.HitNormal*-150
	local start = data.HitPos+data.HitNormal
	local endpos = data.HitPos+data.HitNormal*-1
	util.Decal("Scorch",start,endpos)

	// routed the blowing itself up into the physicsupdate function to prevent the "YOU GONNA GET CRASHED" spam of bullshit and lies.
  	self.DidHit = true
	self.Entity:GetPhysicsObject():SetVelocity(Angle(0,0,0))
end 
function ENT:PhysicsUpdate()
	// in case of aparently non-solid things of the tank, well FORCE it to explode.
	local tracedata = {}
		tracedata.startpos = self.Entity:GetPos()
		tracedata.endpos = self.Entity:GetAngles():Up()*20
		tracedata.filter = self.Entity
	trace = util.TraceLine(tracedata)
	if (ValidEntity(trace.Entity)) then
		self.DidHit = true
	end
	if (self.DidHit == true) then
		util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 300, 250 )
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