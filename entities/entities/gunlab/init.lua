-- ============================================
-- =                                          =
-- =          Crate SENT by Mahalis           =
-- =                                          =
-- ============================================

// gun lab has been changed to give upgrades instead of shitty guns.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

	self.Entity:SetModel( "models/props_c17/furnitureboiler001a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	self.Entity:SetNWBool("sparking",false)
	// to make it hard for random mingebags to blow it up before being killed by its owner
	self.Entity:SetNWInt("damage",150)
	self.Entity:SetNWInt("upgrade", 0)
	local ply = self.Owner
	ply:GetTable().maxgunlabs=ply:GetTable().maxgunlabs + 1
	self.Ready = true
	self.Entity:SetNWInt("power",0)
	self.scrap = false
end

function ENT:Use( activator )
	self.Entity:SetNWEntity( "user", activator )
	timer.Create( tostring(self.Entity) .. "spawned_weapon", 0.5, 1, self.createGun, self)
	if (!self.Ready) then return end
	local gun = activator:GetActiveWeapon()
	if !ValidEntity(gun) then return end
	if (gun:GetNWBool("upgraded")) then
		Notify(activator, 4, 3, "This weapon is already upgraded!")
		self.Ready = false
		return
	end
	local weapon = gun:GetClass()
	local upgradecost = 0
	local canupgrade = false
	local upgradestring = ""
	if (weapon=="weapon_p2282") then
		if (CfgVars["p228cost"]>0) then
			upgradecost = CfgVars["p228cost"]/2
		end
		canupgrade = true
		upgradestring = "clip extended and accuracy increased."
	elseif (weapon=="weapon_deagle2") then
		if (CfgVars["deaglecost"]>0) then
			upgradecost = CfgVars["deaglecost"]/2
		end
		canupgrade = true
		upgradestring = "Sight zoom and accuracy increased"
	elseif (weapon=="weapon_glock2") then
		if (CfgVars["glockcost"]>0) then
			upgradecost = CfgVars["glockcost"]/2
		end
		canupgrade = true
		upgradestring = "Sight zoom and accuracy increased"
	elseif (weapon=="weapon_fiveseven2") then
		if (CfgVars["fivesevencost"]>0) then
			upgradecost = CfgVars["fivesevencost"]/2
		end
		canupgrade = true
		upgradestring = "fully automatic"
	elseif (weapon=="weapon_usp2") then
		if (CfgVars["uspcost"]>0) then
			upgradecost = CfgVars["uspcost"]/2
		end
		canupgrade = true
		upgradestring = "silencer enabled and increased rate of fire"
	elseif (weapon=="weapon_elites2") then
		if (CfgVars["elitescost"]>0) then
			upgradecost = CfgVars["elitescost"]/2
		end
		canupgrade = true
		upgradestring = "double fire"
	elseif (weapon=="weapon_mac102") then
		if (CfgVars["mac10cost"]>0) then
			upgradecost = CfgVars["mac10cost"]/20
		end
		canupgrade = true
		upgradestring = "hotter flame"
	elseif (weapon=="weapon_tmp2") then
		if (CfgVars["tmpcost"]>0) then
			upgradecost = CfgVars["tmpcost"]/20
		end
		canupgrade = true
		upgradestring = "shoot faster"
	elseif (weapon=="weapon_flamethrower") then
		if (CfgVars["flamethrowercost"]>0) then
			upgradecost = CfgVars["flamethrowercost"]/20
		end
		canupgrade = true
		upgradestring = "hotter flame"
	elseif (weapon=="weapon_ump452") then
		if (CfgVars["umpcost"]>0) then
			upgradecost = CfgVars["umpcost"]/20
		end
		canupgrade = true
		upgradestring = "right click to fire a burst"
	elseif (weapon=="weapon_m42") then
		if (CfgVars["m16cost"]>0) then
			upgradecost = CfgVars["m16cost"]/20
		end
		canupgrade = true
		upgradestring = "silencer and full auto enabled, accuracy increased"
	elseif (weapon=="weapon_mp52") then
		if (CfgVars["mp5cost"]>0) then
			upgradecost = CfgVars["mp5cost"]/20
		end
		canupgrade = true
		upgradestring = "silencer and lower recoil"
	elseif (weapon=="weapon_pumpshotgun2") then
		if (CfgVars["shotguncost"]>0) then
			upgradecost = CfgVars["shotguncost"]/20
		end
		canupgrade = true
		upgradestring = "lower spread"
	elseif (weapon=="weapon_autoshotgun2") then
		if (CfgVars["autoshotguncost"]>0) then
			upgradecost = CfgVars["autoshotguncost"]/20
		end
		canupgrade = true
		upgradestring = "faster reload"
	elseif (weapon=="weapon_autosnipe") then
		if (CfgVars["autosnipecost"]>0) then
			upgradecost = CfgVars["autosnipecost"]/20
		end
		canupgrade = true
		upgradestring = "increased damage"
	elseif (weapon=="weapon_galil2") then
		if (CfgVars["galilcost"]>0) then
			upgradecost = CfgVars["galilcost"]/20
		end
		canupgrade = true
		upgradestring = "lower recoil"
	elseif (weapon=="weapon_rocketlauncher") then
		if (CfgVars["rpgcost"]>0) then
			upgradecost = CfgVars["rpgcost"]/20
		end
		canupgrade = true
		upgradestring = "increased damage and accuracy"
	elseif (weapon=="weapon_ak472") then
		if (CfgVars["ak47cost"]>0) then
			upgradecost = CfgVars["ak47cost"]/20
		end
		canupgrade = true
		upgradestring = "bigger clip"
	elseif (weapon=="weapon_aug2") then
		if (CfgVars["augcost"]>0) then
			upgradecost = CfgVars["augcost"]/20
		end
		canupgrade = true
		upgradestring = "bigger clip"
	elseif (weapon=="ls_sniper") then
		if (CfgVars["snipercost"]>0) then
			upgradecost = CfgVars["snipercost"]/20
		end
		canupgrade = true
		upgradestring = "increased damage"
	elseif (weapon=="weapon_50cal2") then
		if (CfgVars["paracost"]>0) then
			upgradecost = CfgVars["paracost"]/20
		end
		canupgrade = true
		upgradestring = "increased rate of fire"
	elseif (weapon=="weapon_knife2") then
		if (CfgVars["knifecost"]>0) then
			upgradecost = CfgVars["knifecost"]/2
		end
		canupgrade = true
		upgradestring = "Poison knife, no deploy sound"
	elseif (weapon=="weapon_tranqgun") then
		if (CfgVars["dartguncost"]>0) then
			upgradecost = CfgVars["dartguncost"]/2
		end
		canupgrade = true
		upgradestring = "poison darts"
	elseif (weapon=="weapon_grenadegun") then
		upgradecost = 225
		canupgrade = true
		upgradestring = "longer distance shots"
	elseif (weapon=="weapon_lasergun") then
		upgradecost = 150
		canupgrade = true
		upgradestring = "more battery"
	elseif (weapon=="weapon_laserrifle") then
		upgradecost = 150
		canupgrade = true
		upgradestring = "more battery"
	else
		Notify(activator, 4, 3, "This weapon cannot be upgraded!")
	end
	self.Ready = false
	if (canupgrade && activator:CanAfford(upgradecost)) then
		activator:AddMoney(-upgradecost)
		activator:UpgradeGun(weapon, true)
		Notify(activator, 0, 3, "Upgrade has been applied to your weapon for $" .. upgradecost)
		if (upgradestring!= "") then
			Notify(activator, 3, 4, upgradestring)
		end
		if (upgradecost>0) then
			local owner = self.Owner
			if ValidEntity(owner) && activator!=owner then
				owner:AddMoney(math.ceil(upgradecost/2))
				Notify(owner, 2, 3, "Paid $" .. math.ceil(upgradecost/2) .. " for selling a gun upgrade.")
			end
		end
		self.Entity:SetNWBool("sparking",true)
	end
end

function ENT:createGun()
	self.Entity:SetNWBool("sparking",false)
	self.Ready = true
end

function ENT:Think()
	if (ValidEntity(self.Owner)==false) then
		self.Entity:Remove()
	end
end

function ENT:OnRemove( )
	timer.Destroy(tostring(self.Entity))
	local ply = self.Owner
	if ValidEntity(ply) then
		ply:GetTable().maxgunlabs=ply:GetTable().maxgunlabs - 1
	end
end

function ENT:MakeScraps()
--	if !self.scrap then
--		self.scrap = false
--		local value = CfgVars["gunlabcost"]/8
--		if value<5 then value = 5 end
--		for i=0, 5, 1 do
--			local scrapm = ents.Create("scrapmetal")
--			scrapm:SetModel( "models/gibs/metal_gib" .. math.random(1,5) .. ".mdl" );
--			local randpos = Vector(math.random(-5,5), math.random(-5,5), math.random(0,5))
--			scrapm:SetPos(self.Entity:GetPos()+randpos)
--			scrapm:Spawn()
--			scrapm:GetTable().ScrapMetal = true
--			scrapm:GetTable().Amount = math.random(3,value)
--			scrapm:Activate()
--			scrapm:GetPhysicsObject():SetVelocity(randpos*35)
--			
--			timer.Create( "scraptimer" ..i, 10, 1, function(removeme)
--				removeme:Remove()
--			end, scrapm )
--
--			
--		end 
--	end
end