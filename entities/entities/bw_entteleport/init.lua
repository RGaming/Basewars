-- ============================================
-- =                                          =
-- =          Crate SENT by Mahalis           =
-- =                                          =
-- ============================================

// copy pasta from DURG lab

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 20
	
	local ent = ents.Create( "drugfactory" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
	
end

function ENT:Initialize()
	self.Entity:SetModel( "models/props_junk/MetalBucket01a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then 
		//phys:SetMass(1000)
		phys:Wake()
	end
	self.Entity:SetNWBool("sparking",false)
	self.Entity:SetNWInt("damage",250)
	self.Entity:SetNWInt("upgrade", 0)
	local ply = self.Owner
	ply:GetTable().maxmoneyvault=ply:GetTable().maxmoneyvault + 1
	self.LastUsed = CurTime()
	self.Entity:SetNWInt("power",0)
	self.scrap = false
	self.LastUsed = CurTime()
	
end

function ENT:Use(activator,caller)
end

function ENT:Think()
end

function ENT:DropDrug()
end

function ENT:DropSuperDrug()
end

function ENT:EjectMoney()
end

function ENT:OnRemove( )
	self.Entity:EjectMoney()
	timer.Destroy(self.Entity) 
	local ply = self.Owner
	if ValidEntity(ply) then
		ply:GetTable().maxmoneyvault=ply:GetTable().maxmoneyvault- 1
	end
end

function ENT:Touch(ent)
		if (ent:GetClass()=="prop_moneybag" && ent:GetClass()=="") then
			ent:Remove()	
			self.Money = ent:GetTable().Amount
		end
end

function ENT:MakeScraps()
end

function ENT:CanRefine(mode,ply)
end

function ENT:SetMode(mode)
end