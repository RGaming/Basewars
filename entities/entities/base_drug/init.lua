
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

	self.Entity:SetModel( "models/props_lab/jar01a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	//self.Entity:SetColor(150, 50, 50, 255)
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	self.Entity:SetVar("damage",20)
	self.Time = CurTime()
end

function ENT:OnTakeDamage(dmg)
	self.Entity:SetVar("damage",self.Entity:GetVar("damage") - dmg:GetDamage())

	if(self.Entity:GetVar("damage") <= 0) then
		local effectdata = EffectData()
			effectdata:SetOrigin( self.Entity:GetPos() )
			effectdata:SetMagnitude( 2 )
			effectdata:SetScale( 2 )
			effectdata:SetRadius( 3 )
		util.Effect( "Sparks", effectdata )
		self.Entity:Remove()
	end
end

function ENT:Use(activator,caller)
	if (caller:GetTable().Roided != true) then
		Roidup(caller)
		self.Entity:Remove()
	end
end

function ENT:Think()

end

function ENT:GetTime()
	return self.Time
end

function ENT:ResetTime()
	self.Time = CurTime()
end