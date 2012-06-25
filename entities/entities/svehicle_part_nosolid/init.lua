/* ======================================
	SVehicle / parts (no solids)
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
	self.Entity:SetSolid( SOLID_NONE )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		//phys:EnableMotion(false)
	end
end

function ENT:Think()
end
function ENT:OnRemove()
end

function ENT:OnTakeDamage(dmg)
end


function ENT:TankWheel()
	local fakewheel = ents.Create( "svehicle_part_nosolid" )
	fakewheel:SetModel("models/props_wasteland/laundry_basket001.mdl")
	fakewheel:SetPos( self.Entity:GetPos() + self.Entity:GetAngles():Forward()*-5)
	fakewheel:SetAngles(self.Entity:GetAngles() + Angle(90,0,90))
	fakewheel:SetParent(self.Entity)
	fakewheel:Spawn()
	self.FakeWheel = fakewheel
end