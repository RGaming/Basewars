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
	
	local ent = ents.Create( "gunvault" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
	
end

function ENT:Initialize()
	self.Entity:SetModel( "models/props/cs_militia/footlocker01_closed.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then 
		phys:SetMass(250)
		phys:Wake()
	end
	self.Entity:SetNWBool("sparking",false)
	self.Entity:SetNWInt("damage",750)
	self.Entity:SetNWInt("upgrade", 0)
	local ply = self.Owner
	ply:GetTable().maxvault=ply:GetTable().maxvault + 1
	self.Locked = true
	self.LastUsed = CurTime()
	self.Guns = {}
	self.Upgrades = {}
end

function ENT:OnTakeDamage(dmg)
	local damage = dmg:GetDamage()
	local attacker=dmg:GetAttacker()
	if !dmg:IsExplosionDamage() && ValidEntity(attacker) && attacker:IsPlayer() && attacker:GetTable().ArmorPiercered then
		damage = damage*drugeffect_armorpiercermod
	end
	self.Entity:SetNWInt("damage",self.Entity:GetNWInt("damage") - damage)
	if(self.Entity:GetNWInt("damage") <= 0) then
		self.Entity:DropAllGuns()
		self.Entity:Destruct()  
		self.Entity:Remove()
	end
end

function ENT:Destruct()

	local vPoint = self.Entity:GetPos()
	local effectdata = EffectData() 
	effectdata:SetStart( vPoint )
	effectdata:SetOrigin( vPoint ) 
	effectdata:SetScale( 1 ) 
	util.Effect( "Explosion", effectdata ) 

end

function ENT:Use(activator,caller)
	if (self.LastUsed+0.5>CurTime()) then
		self.LastUsed = CurTime()
	else
		self.LastUsed = CurTime()
		local ply = self.Owner
		if (activator==ply || !self.Locked || activator:IsAllied(ply)) then
			if (activator==ply || activator:IsAllied(ply)) then
				self.Locked = true
			end
			// to prevent having duplicates of it open.
			umsg.Start( "killgunvaultgui", activator );
				umsg.Short( self.Entity:EntIndex() )
			umsg.End()
			umsg.Start( "gunvaultgui", activator );
				umsg.String( table.concat(self.Guns, ",") )
				umsg.Short( self.Entity:EntIndex() )
				umsg.String( table.concat(self.Upgrades, ",") )
			umsg.End()
		else
			Notify(activator,4,3,"This gun vault is locked! use a lock pick to force it open.")
		end
	end
end

function ENT:Think()
	if (ValidEntity(self.Owner)==false) then
		self.Entity:DropAllGuns()
		self.Entity:Remove()
	end
end

function ENT:DropAllGuns()
	// explode into a shower of all its guns when destroyed. funny as hell if the guy that blew it up gets killed by a gun.
	for i=1, table.Count(self.Guns), 1 do
		self.Entity:DropGun(i, self.Entity, 10, true)
	end
end
function ENT:CanDropGun(gunnum)
	local gunt = self.Guns[gunnum]
	if (gunt!=nil) then return true else return false end
end
function ENT:DropGun(gunnum, ply, hgt, bigdrop)
	local gunt = self.Guns[gunnum]
	if (bigdrop!=true) then
		local gunt = table.remove(self.Guns, tonumber(gunnum))
	end
	local upgrade = util.tobool(self.Upgrades[gunnum])
	if (!bigdrop) then
		local upgrade = util.tobool(table.remove(self.Upgrades, tonumber(gunnum)))
	end
	// i typed in all the gun names without the weapon_ prefix because i forgot i commented it out. well fuck you. im not going through all this to fix it.
	local gun = string.gsub(gunt, "weapon_", "")
	local height = hgt
	// looking back on this, i probably wouldve been better to set some vars, then spawn the gun and apply those, so that to fuck around with it, wouldnt have to go through each statement.
	if (gun=="pipebomb") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/props_lab/pipesystem03b.mdl" );
		weapon:SetNWString("weaponclass", "weapon_pipebomb");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
		weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="tranqgun") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_crossbow.mdl" );
		weapon:SetNWString("weaponclass", "weapon_tranqgun");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetNWBool("upgraded", upgrade)
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="rocketlauncher") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_rocket_launcher.mdl" );
		weapon:SetNWString("weaponclass", "weapon_rocketlauncher");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="50cal2") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_mach_m249para.mdl" );
		weapon:SetNWString("weaponclass", "weapon_50cal2");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="molotov") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/props_junk/garbage_glassbottle003a.mdl" );
		weapon:SetNWString("weaponclass", "weapon_molotov");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="ls_sniper") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_snip_awp.mdl" );
		weapon:SetNWString("weaponclass", "ls_sniper");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="autosnipe") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_snip_g3sg1.mdl" );
		weapon:SetNWString("weaponclass", "weapon_autosnipe");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="ak472") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_rif_ak47.mdl" );
		weapon:SetNWString("weaponclass", "weapon_ak472");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="galil2") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_rif_galil.mdl" );
		weapon:SetNWString("weaponclass", "weapon_galil2");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="pumpshotgun2") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_shot_m3super90.mdl" );
		weapon:SetNWString("weaponclass", "weapon_pumpshotgun2");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="autoshotgun2") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_shot_xm1014.mdl" );
		weapon:SetNWString("weaponclass", "weapon_autoshotgun2");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="mp52") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_smg_mp5.mdl" );
		weapon:SetNWString("weaponclass", "weapon_mp52");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="tmp2") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_smg_tmp.mdl" );
		weapon:SetNWString("weaponclass", "weapon_tmp2");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="m42") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_rif_m4a1.mdl" );
		weapon:SetNWString("weaponclass", "weapon_m42");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="ump452") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_smg_ump45.mdl" );
		weapon:SetNWString("weaponclass", "weapon_ump452");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="mac102") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_smg_mac10.mdl" );
		weapon:SetNWString("weaponclass", "weapon_mac102");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="cse_eq_hegrenade") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_eq_fraggrenade.mdl" );
		weapon:SetNWString("weaponclass", "cse_eq_hegrenade");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="gasgrenade") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_eq_smokegrenade.mdl" );
		weapon:SetNWString("weaponclass", "weapon_gasgrenade");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="cse_eq_flashbang") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_eq_flashbang.mdl" );
		weapon:SetNWString("weaponclass", "cse_eq_flashbang");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="cse_eq_flashbang") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_eq_flashbang.mdl" );
		weapon:SetNWString("weaponclass", "cse_eq_flashbang");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="knife2") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_knife_t.mdl" );
		weapon:SetNWString("weaponclass", "weapon_knife2");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="p2282") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_pist_p228.mdl" );
		weapon:SetNWString("weaponclass", "weapon_p2282");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="aug2") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_rif_aug.mdl" );
		weapon:SetNWString("weaponclass", "weapon_aug2");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="deagle2") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_pist_deagle.mdl" );
		weapon:SetNWString("weaponclass", "weapon_deagle2");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="glock2") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_pist_glock18.mdl" );
		weapon:SetNWString("weaponclass", "weapon_glock2");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="fiveseven2") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_pist_fiveseven.mdl" );
		weapon:SetNWString("weaponclass", "weapon_fiveseven2");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="usp2") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_pist_usp.mdl" );
		weapon:SetNWString("weaponclass", "weapon_usp2");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="elites2") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_pist_elite_dropped.mdl" );
		weapon:SetNWString("weaponclass", "weapon_elites2");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="grenadegun") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_rif_sg552.mdl" );
		weapon:SetNWString("weaponclass", "weapon_grenadegun");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
		weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="worldslayer") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_rocket_launcher.mdl" );
		weapon:SetNWString("weaponclass", "weapon_worldslayer");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="flamethrower") then
			weapon.Ejected = true;
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_smg1.mdl" );
		weapon:SetNWString("weaponclass", "weapon_flamethrower");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif (gun=="turretgun") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_smg1.mdl" );
		weapon:SetNWString("weaponclass", "weapon_turretgun");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="lasergun") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_irifle.mdl" );
		weapon:SetNWString("weaponclass", "weapon_lasergun");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="laserrifle") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_snip_scout.mdl" );
		weapon:SetNWString("weaponclass", "weapon_laserrifle");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="stickgrenade") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/magnusson_device.mdl" );
		weapon:SetNWString("weaponclass", "weapon_stickgrenade");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="stickgrenade") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_c4_planted.mdl" );
		weapon:SetNWString("weaponclass", "weapon_mad_c4");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	elseif (gun=="plasma") then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetModel( "models/weapons/w_irifle.mdl" );
		weapon:SetNWString("weaponclass", "weapon_plasma");
		weapon:SetPos( self.Entity:GetPos()+Vector(0,0,height));
		weapon:SetUpgraded(upgrade)
				weapon.Ejected = true;
		weapon:Spawn();
	end
	if (ply!=nil) then
		if (ply:IsPlayer()) then
			umsg.Start( "killgunvaultgui", ply );
				umsg.Short( self.Entity:EntIndex() )
			umsg.End()
		end
	end
end
function ENT:OnRemove( )
	timer.Destroy(self.Entity) 
	local ply = self.Owner
	if ValidEntity(ply) then
		ply:GetTable().maxvault=ply:GetTable().maxvault - 1
	end
	umsg.Start( "killgunvaultgui");
		umsg.Short( self.Entity:EntIndex() )
	umsg.End()
end

function ENT:Touch(gun)
	if (gun:GetClass()=="spawned_weapon" && gun:GetNWString("weaponclass")!=nil && gun:GetNWString("weaponclass")!="weapon_physgun" && gun:GetNWString("weaponclass")!="" and not gun.Ejected  && table.Count(self.Guns)<10) then
		local wepclass = gun:GetNWString("weaponclass")
		local upgraded = gun:IsUpgraded()
		// put it into a string, so i can concat it.
		if (upgraded) then
			upgraded = "1"
		else
			upgraded = "0"
		end
		table.insert(self.Guns, wepclass)
		table.insert(self.Upgrades, upgraded)
		// its a damn shame that the weapon doesnt actually remove instantly.
		gun:SetNWString("weaponclass", "weapon_physgun")
		gun:Remove()	
	end
end

function ENT:IsLocked()
	return self.Locked
end

function ENT:SetUnLocked()
	self.Locked = false
	return true
end