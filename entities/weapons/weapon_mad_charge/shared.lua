// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base"

SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_slam.mdl"
SWEP.WorldModel			= "models/weapons/w_slam.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound		= Sound("")
SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 5

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Thumper"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"				// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= true
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.RunArmOffset 		= Vector (-0.5928, 0, 6.3399)
SWEP.RunArmAngle 			= Vector (-19.4462, -2.5193, 0)

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

	util.PrecacheSound("weapons/c4/c4_disarm.wav")
	util.PrecacheSound("weapons/c4/c4_explode1.wav")
	util.PrecacheSound("weapons/c4/c4_click.wav")
	util.PrecacheSound("weapons/c4/c4_plant.wav")
	util.PrecacheSound("weapons/c4/c4_beep1.wav")
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack1 has been pressed.
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	// Holst/Deploy your fucking weapon
	if (not self.Owner:IsNPC() and self.Owner:KeyDown(IN_USE)) then
		bHolsted = !self.Weapon:GetDTBool(0)
		self:SetHolsted(bHolsted)

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)

		self:SetIronsights(false)

		return
	end

/*
	if self.Weapon:GetNWBool("Planted") then
		self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DETONATE)

		self.Weapon:EmitSound("Streetwar.d3_c17_10b_mine_mode")

		for k, ent in pairs(ents.GetAll()) do  
			if ent:GetClass() == "ent_mad_charge" and ent.Owner == self.Owner then
				timer.Simple(1, function() ent:Explosion() ent:Remove() end)
				self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DETONATE)
			end
		end

		self.Weapon:SetNextPrimaryFire(CurTime() + 2)
		self.Weapon:SetNextSecondaryFire(CurTime() + 2)

		self.Weapon:SetNWBool("Planted", false)

		timer.Simple(0.5, function()
			self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_HOLSTER)
		end)

		timer.Simple(1, function()
			if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
				self:Deploy()
			else
				self.Weapon:Remove()
				self.Owner:ConCommand("lastinv")
			end
		end)

		return
	end
*/

	if (not self:CanPrimaryAttack()) then return end

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
	tr.filter = {self.Owner}
	local trace = util.TraceLine(tr)

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)

	if not trace.Hit or trace.Entity:GetClass() ~= "prop_door_rotating" or trace.HitWorld then
		if (SERVER) then
			self.Owner:PrintMessage(HUD_PRINTTALK, "Explosive charge can only be installed on doors!")
		end 

		return 
	end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	self.Weapon:SendWeaponAnim(ACT_SLAM_TRIPMINE_ATTACH)

	timer.Simple(0.5, function()
		if (not self.Owner:Alive() or self.Weapon:GetOwner():GetActiveWeapon():GetClass() ~= "weapon_mad_charge" or not IsFirstTimePredicted()) then return end

		self.Weapon:SendWeaponAnim(ACT_SLAM_TRIPMINE_ATTACH2)

		local tr = {}
		tr.start = self.Owner:GetShootPos()
		tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
		tr.filter = {self.Owner}
		local trace = util.TraceLine(tr)

		if not trace.Hit or trace.Entity:GetClass() ~= "prop_door_rotating" or trace.HitWorld then
			timer.Simple(0.6, function()
				if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
					self:Deploy()
				else
					self.Weapon:Remove()
					self.Owner:ConCommand("lastinv")
				end
			end)

			return 
		end

		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:TakePrimaryAmmo(1)

		if (CLIENT) then return end
	
		Charge = ents.Create("ent_mad_charge")
		Charge:SetPos(trace.HitPos + trace.HitNormal)

		trace.HitNormal.z = -trace.HitNormal.z

		Charge:SetAngles(trace.HitNormal:Angle() - Angle(270, 180, 180))

		Charge.Owner = self.Owner
		Charge:Spawn()

		if trace.Entity and trace.Entity:IsValid() and trace.Entity:GetClass() == "prop_door_rotating" then
			if not trace.Entity:IsNPC() and not trace.Entity:IsPlayer() and trace.Entity:GetPhysicsObject():IsValid() then
				constraint.Weld(Charge, trace.Entity)
			end
		else
			Charge:SetMoveType(MOVETYPE_NONE)
		end

		timer.Simple(0.6, function()
			if (not self.Owner:Alive() or self.Weapon:GetOwner():GetActiveWeapon():GetClass() ~= "weapon_mad_charge") or not IsFirstTimePredicted() then return end
//			self.Weapon:SetNWBool("Planted", true)
			self:Deploy()
		end)
	end)
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end

/*---------------------------------------------------------
   Name: SWEP:CanPrimaryAttack()
   Desc: Helper function for checking for no ammo.
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()

	if (self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) or (self.Owner:WaterLevel() > 2) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		return false
	end

	if (not self.Owner:IsNPC()) and (self.Owner:KeyDown(IN_SPEED)) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		return false
	end

	return true
end

/*---------------------------------------------------------
   Name: SWEP:Deploy()
   Desc: Whip it out.
---------------------------------------------------------*/
function SWEP:Deploy()

//	if self.Weapon:GetNWBool("Planted") then
//		self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DRAW)
//	else
		self.Weapon:SendWeaponAnim(ACT_SLAM_TRIPMINE_DRAW)
//	end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.DeployDelay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.DeployDelay)
	self.ActionDelay = (CurTime() + self.DeployDelay)

	return true
end

/*---------------------------------------------------------
   Name: SWEP:Holster()
---------------------------------------------------------*/
function SWEP:Holster()

	if (CLIENT) and self.Ghost:IsValid() then
		self.Ghost:SetColor(255, 255, 255, 0)
	end

	return true
end

/*---------------------------------------------------------
   Name: SWEP:OnRemove()
   Desc: Called just before entity is deleted.
---------------------------------------------------------*/
function SWEP:OnRemove()

	if (CLIENT) and self.Ghost:IsValid() then
		self.Ghost:SetColor(255, 255, 255, 0)
	end

	return true
end