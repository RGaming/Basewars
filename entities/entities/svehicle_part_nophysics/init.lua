/* ======================================
	SVehicle / parts (no physics movement)
   ====================================== */

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	// self.Entity:SetNWInt("damage", 5000)
end

function ENT:Think()
	
end
function ENT:OnRemove()
	if ValidEntity(self.Core) && !self.IsEngine && !self.IsPlate then
		//self.Core:Remove()
	end
end

function ENT:OnTakeDamage(dmg)
	if self.IsPlate==true || self.IsEngine==true then
		self.Entity:SetNWInt("damage", self.Entity:GetNWInt("damage")-dmg:GetDamage())
	end
	if self.Entity:GetNWInt("damage")<=0 && (self.IsPlate==true || self.IsEngine==true)then
		self.Entity:Explode()
		if self.IsEngine==true && ValidEntity(self.Core) then
			self.Core:EngineDied(dmg:GetAttacker())
		elseif self.IsPlate==true && ValidEntity(self.Core) then
			self.Core:PlateDied(self.Entity, dmg:GetAttacker())
		end
		self.Entity:Remove()
	end
	// self.Core:SetNWInt("damage",self.Core:GetNWInt("damage") - dmg:GetDamage())
end

function ENT:Explode()
	local effectdata = EffectData() 
		effectdata:SetStart( self.Entity:GetPos() )
		effectdata:SetOrigin( self.Entity:GetPos() ) 
		effectdata:SetScale( 1 ) 
	util.Effect( "Explosion", effectdata ) 
end

function ENT:Plate()
	self.Entity:SetNWInt("damage", 500)
	self.IsPlate = true
end

function ENT:Engine()
	self.Entity:SetNWInt("damage", 1500)
	self.IsEngine = true
end

/*
function ENT:Use(ply, caller)
	if ValidEntity(self.Core:GetPod()) then
		ply:EnterVehicle(self.Core:GetPod())
	end
end
*/

function ENT:TankWheel()
	local fakewheel = ents.Create( "svehicle_part_nosolid" )
	fakewheel:SetModel("models/props_wasteland/laundry_basket001.mdl")
	fakewheel:SetPos( self.Entity:GetPos() + self.Entity:GetAngles():Forward()*-5)
	fakewheel:SetAngles(self.Entity:GetAngles() + Angle(90,0,90))
	fakewheel:SetParent(self.Entity)
	fakewheel:Spawn()
	self.FakeWheel = fakewheel
end