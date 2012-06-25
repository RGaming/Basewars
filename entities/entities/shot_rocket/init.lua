/* ======================================
	shot_rocket
	rocketlauncher/fighter rocket
   ====================================== */

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.Entity:SetModel( "models/weapons/w_missile_closed.mdl" )
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
	util.SpriteTrail(self.Entity, 0, Color(200,200,200), false, 16, 1, 2, 1/8.5, "trails/smoke.vmt")
	self.SmokeTrail = ents.Create("env_rockettrail")
	self.SmokeTrail:SetPos(self.Entity:GetPos() + self.Entity:GetForward()*-15)
	self.SmokeTrail:SetAngles(self.Entity:GetAngles())
	self.SmokeTrail:SetParent(self.Entity)
	self.SmokeTrail:Spawn()
	self.Upgraded = false
end

function ENT:Think()
	if (ValidEntity(self.Entity:GetOwner())==false) then
		self.Entity:Remove()
	end
	if (self.GoofyTiem < CurTime()-.25) then
		if (self.Upgraded) then
			self.Entity:SetAngles(self.Entity:GetAngles()+Angle(math.random()*2.5-1.25, math.random()*2.5-1.25, 0))
		else
			self.Entity:SetAngles(self.Entity:GetAngles()+Angle(math.random()*4.5-2.25, math.random()*4.5-2.25, 0))
		end
	end
	self.Entity:GetPhysicsObject():SetVelocity(self.Entity:GetForward()*2000)
end

function ENT:OnRemove()
	self.SmokeTrail:Remove()
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
	local trace = {}
		trace.start = self.Entity:GetPos()
		trace.endpos = self.Entity:GetPos()
		trace.filter = {self.Entity, self.Entity:GetOwner()}
	trace = util.TraceLine(trace)
	if (trace.Hit && (ValidEntity(trace.Entity) && trace.Entity:GetClass()!="shot_rocket")) || (trace.Hit && !ValidEntity(trace.Entity)) then self.DidHit=true end
	if (self.DidHit == true) then
		if (self.Upgraded) then
			util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 310, 30 )
			// near direct hit gets more damage in a tiny radius
			util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 100, 25 )
		else 
			util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 275, 25 )
			util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 80, 20 )
		end
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

function ENT:Upgrade()
	self.Upgraded = true
end