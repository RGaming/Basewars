
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

	self.Entity:SetModel( "models/props_junk/garbage_glassbottle001a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	self.Entity:SetVar("damage",10)
	self.Time = CurTime()
	timer.Create( tostring(self.Entity), 180, 1, self.Remove, self)
end

function ENT:Use(activator,caller)
	BoozePlayer(caller)
	caller:SetHealth( caller:Health()+math.random(5,15));
	if (caller:Health()>caller:GetMaxHealth()*1.1) then
		caller:SetHealth(caller:GetMaxHealth()*1.1)
	end
	self.Entity:Remove()
end

function ENT:Think()

end

function ENT:OnRemove( )
	timer.Destroy(tostring(self.Entity))
end