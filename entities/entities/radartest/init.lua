// copypasta from microwave.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')


function ENT:Initialize()
	self:SetModel("models/LmaoLlama/radar.mdl")
	self.Radar = ents.Create("prop_dynamic_override")
	self.Radar:SetModel( "models/LmaoLlama/radar.mdl" )
	self.Radar:SetPos(self.Entity:GetPos())
	self.Radar:SetAngles(Angle(0,0,0))
	self.Radar:SetParent(self)
	self.Radar:SetSolid(SOLID_VPHYSICS)
	self.Radar:SetMoveType(MOVETYPE_VPHYSICS)

end
