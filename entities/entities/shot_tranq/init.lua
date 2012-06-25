/* ======================================
	shot_tranq
	tranquilizer dart
   ====================================== */

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.Entity:SetModel( "models/props_c17/trappropeller_lever.mdl" )
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
	self.lolHitPos = Vector(0,0,0)
	self.Fuckit = false
	util.SpriteTrail(self.Entity, 0, Color(50,100,10), false, 3, 1, 0.1, 1/8.5, "trails/smoke.vmt")
	self.Entity:GetPhysicsObject():SetVelocity(self.Entity:GetRight()*50000)
	util.PrecacheSound("weapons/crossbow/bolt_skewer1.wav")
	//self.Poison = false
end

function ENT:Think()
	if (ValidEntity(self.Entity:GetOwner())==false) then
		self.Entity:Remove()
	end
end

function ENT:OnRemove()
	//self.SmokeTrail:Remove()
	timer.Destroy(tostring(self.Entity) .. "clear")
end

function ENT:PhysicsCollide( data, physobj )
	if !self.DidHit then
		self.Entity:GetPhysicsObject():EnableMotion(false)
		self.Entity:SetKeyValue("solid", "0")
		self.lolHitPos = data.HitPos
		// routed the blowing itself up into the physicsupdate function to prevent the "YOU GONNA GET CRASHED" spam of bullshit and lies.
  		self.DidHit = true
		self.Entity:GetPhysicsObject():SetVelocity(Angle(0,0,0))
		timer.Create(tostring(self.Entity) .. "clear", 20, 1, function() self.Entity:Remove() end, self)
		// nested if statements, to escape the errors.
		self.Entity:EmitSound("weapons/crossbow/bolt_skewer1.wav")
		if (data.HitEntity!=nil) then
			if (ValidEntity(data.HitEntity)) then
				self.Fuckit=true
				if (data.HitEntity:IsPlayer()) then
					StunPlayer(data.HitEntity, 35)
					// because kills from non-lethal weapons are teh sex.
					data.HitEntity:TakeDamage(10, self.Entity:GetOwner(), self.Entity)
					// poison them if its from an upgraded dart gun
					if (self.Poison) then
						PoisonPlayer(data.HitEntity, 30, self.Entity:GetOwner(), self.Entity:GetOwner():GetWeapon("weapon_tranqgun"))
					end
				else
					// make it still be effective against NPCs (and vehicles)
					data.HitEntity:TakeDamage(30, self.Entity:GetOwner(), self.Entity)
				end
			end
		end
	end
end 
function ENT:PhysicsUpdate()
	local trace = {}
		trace.start = self.Entity:GetPos()
		trace.endpos = self.Entity:GetPos()
		trace.filter = {self.Entity, self.Entity:GetOwner()}
	trace = util.TraceLine(trace)
	if trace.Hit then self.Fuckit=true end
	if (self.DidHit == true) then
		self.Entity:SetPos(self.lolHitPos)
	end
	if (self.Fuckit == true ) then
		self.Entity:Remove()
	end
end

function ENT:Poisonous()
	self.Poison = true
end