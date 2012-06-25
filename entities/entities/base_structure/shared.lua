 	
ENT.Type 		= "anim"
ENT.Base 		= "base_gmodentity"

ENT.PrintName	= "Base Structure"
ENT.Author		= "HLTV Proxy"
ENT.Contact		= ""

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

// used by gamemode for power plant
ENT.Power		= 0
ENT.Structure		= true

function ENT:Initialize()

	self.Entity:SetNWInt("power", 0)
end

function ENT:IsPowered()
	if self.Entity:GetNWInt("power")>=self.Power then return true else return false end
end