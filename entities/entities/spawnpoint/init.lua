// copy pasta sent from ohlol
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

    self.Entity:SetModel( "models/props_trainstation/trainstation_clock001.mdl")
    self.Entity:PhysicsInit(SOLID_VPHYSICS)
    self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
    self.Entity:SetSolid(SOLID_VPHYSICS)
    self.Entity:SetAngles(Angle(-90, 0, 0))
    local ply = self.Owner
    local phys = self.Entity:GetPhysicsObject()
	phys:EnableMotion(false)
    if(phys:IsValid()) then phys:Wake() end
    self.Entity:SetNWInt("damage",100)
    local spawnpointp = true
    ply:GetTable().maxspawn = ply:GetTable().maxspawn + 1
    ply:GetTable().Spawnpoint = self.Entity
	self.Entity:SetNWInt("power",0)
end

function ENT:Think( )
	if (ValidEntity(self.Owner)!=true) then
		self.Entity:Remove()
	end
end

function ENT:OnRemove( ) 
	local ply = self.Owner
	if ValidEntity(ply) then
		ply:GetTable().maxspawn = ply:GetTable().maxspawn - 1
	end
end