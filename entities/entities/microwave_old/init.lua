-- ============================================
-- =                                          =
-- =          Crate SENT by Mahalis           =
-- =                                          =
-- ============================================

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

	self.Entity:SetModel( "models/props/cs_office/microwave.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	self.Entity:SetNWBool("sparking",false)
	self.Entity:SetNWInt("damage",300)
	self.Entity:SetNWInt("upgrade", 0)
	local ply = self.Owner
	ply:GetTable().maxMicrowaves=ply:GetTable().maxMicrowaves + 1
	self.Entity:SetNWInt("power",0)
end

function ENT:Use(activator,caller)
	if self.Entity:IsPowered() then
		self.Entity:SetNWEntity( "user", activator )
		self.Entity:SetNWBool("sparking",true)
		timer.Create( tostring(self.Entity) .. "food", 1, 1, self.createFood, self)
	end
end

function ENT:createFood()
	local spos = self.SparkPos
	local ang = self.Entity:GetAngles()
	local foodPos = self.Entity:GetPos()
	food = ents.Create("item_food")
	food:SetPos(self.Entity:GetPos()+ang:Forward()*spos.x+ang:Right()*spos.y+ang:Up()*spos.z)
	food:Spawn()
	local activator = self.Entity:GetNWEntity( "user" )
	self.Entity:SetNWBool("sparking",false)
end
 
function ENT:Think()
	if (ValidEntity(self.Owner)==false) then
		self.Entity:Remove()
	end
end

function ENT:OnRemove( )
	timer.Destroy(tostring(self.Entity).."food") 
	local ply = self.Owner
	if ValidEntity(ply) then
		ply:GetTable().maxMicrowaves=ply:GetTable().maxMicrowaves - 1
	end
end

