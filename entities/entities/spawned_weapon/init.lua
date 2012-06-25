-- ============================================
-- =                                          =
-- =          Crate SENT by Mahalis           =
-- =                                          =
-- ============================================

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')


function ENT:Initialize()

	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	self.Time = CurTime()
	if (self.Upgrade==nil) then
		self.Upgrade = false
	end
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity.CollisionGroup = COLLISION_GROUP_WEAPON
end


function ENT:Use(activator,caller)
	local class = self.Entity:GetNWString("weaponclass")

	local plweapon = activator:GetWeapon(class)
	if ValidEntity(plweapon) then
		if class!="weapon_worldslayer" then
			activator:GiveAmmo(plweapon:GetTable().Primary.DefaultClip, plweapon:GetPrimaryAmmoType())
		else
			return
		end
	else
		activator:Give(class)
	end
	local weapon = activator:GetWeapon(class)
	if ValidEntity(weapon) && self.Upgrade then
		weapon:Upgrade(true)
	end
	
	if ValidEntity(self.spawner) && activator!=self.spawner then
		Notify(self.spawner,4,3,activator:GetName() .. " picked up your gun factory weapon.")
	end
	self.Entity:Remove()

end

function ENT:GetTime()
	return self.Time
end

function ENT:SetUpgraded(bool)
	self.Upgrade = bool
end

function ENT:IsUpgraded()
	return self.Upgrade
end