/* ======================================
	energy shot
	uncharged energy
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
	self.Upgraded = false
end

function ENT:Think()
	if (!ValidEntity(self.Entity:GetOwner())) then
		self.Entity:Remove()
	end
	self.Entity:GetPhysicsObject():SetVelocity(self.Entity:GetForward()*99999)
end

function ENT:OnRemove()
end

function ENT:PhysicsCollide( data, physobj )
	ShockWaveExplosion(data.HitPos,self.Owner,data.HitNormal,22)
	
	local start = data.HitPos+data.HitNormal*-30
	local endpos = data.HitPos+data.HitNormal*30
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
	if trace.Hit then self.DidHit=true end
	if (self.DidHit == true) then
		local ang = self.Entity:GetAngles()
		if (self.Upgraded) then
			util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 60, 40 )
		else 
			util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 60, 30 )
		end
		self.Entity:Fire("kill", "", 0)
		//self.Entity:EmitSound(Sound("weapons/explode3.wav"))
		self.Entity:Remove()
	end
end

function ENT:SetMode(t)
	self.Entity:SetNWInt("mode",t)
end