

ENT.Type = "anim"
ENT.Base = "base_structure"

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.HealthRing={100,16,1}
ENT.Power		= 0

function ENT:SetOn( _in_ )
	self:SetNetworkedBool( "Enabled", _in_ )
end

function ENT:GetOn()
	return self:GetNetworkedVar( "Enabled", true )
end

