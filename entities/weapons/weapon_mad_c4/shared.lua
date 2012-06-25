// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base"

SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.Primary.Sound		= Sound("")
SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 5

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "AlyxGun"

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

SWEP.Blacklist = {}
SWEP.Blacklist["ent_mad_c4"] 	= true

SWEP.Timer				= 30

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

	if (not self:CanPrimaryAttack()) then return end

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
	tr.filter = {self.Owner}
	local trace = util.TraceLine(tr)

	if not trace.Hit then return end

	if not trace.Entity:GetClass()=="func_door" and not trace.Entity:GetClass()=="func_door_rotating" and trace.Entity.Owner!=self.Owner then print("Nope") return end 
	
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	timer.Simple(3, function()
		if (not self.Owner or not self.Owner:Alive() or self.Weapon:GetOwner():GetActiveWeapon():GetClass() ~= "weapon_mad_c4" or not IsFirstTimePredicted()) then return end

		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

		local tr = {}
		tr.start = self.Owner:GetShootPos()
		tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
		tr.filter = {self.Owner}
		local trace = util.TraceLine(tr)

		if not trace.Hit then
			timer.Simple(0.6, function()
				if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
					self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
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
	
		C4 = ents.Create("ent_mad_c4")
		C4:SetPos(trace.HitPos + trace.HitNormal)

		trace.HitNormal.z = -trace.HitNormal.z

		C4:SetAngles(trace.HitNormal:Angle() - Angle(90, 180))

		C4.Owner = self.Owner
		C4.Timer = self.Timer
		C4:Spawn()

		if trace.Entity and trace.Entity:IsValid() and not self.Blacklist[trace.Entity:GetClass()] then
			if not trace.Entity:IsNPC() and not trace.Entity:IsPlayer() and trace.Entity:GetPhysicsObject():IsValid() then
				constraint.Weld(C4, trace.Entity)
			end
		else
			C4:SetMoveType(MOVETYPE_NONE)
		end

		timer.Simple(0.6, function()
			if (not self.Owner:Alive() or self.Weapon:GetOwner():GetActiveWeapon():GetClass() ~= "weapon_mad_c4") or not IsFirstTimePredicted() then return end

			if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
				self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
			else
				self.Weapon:Remove()
				self.Owner:ConCommand("lastinv")
			end
		end)
	end)
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.1)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.1)

	if self.Timer == 30 then
		if (SERVER) then
			self.Owner:PrintMessage(HUD_PRINTTALK, "60 Seconds.")
		end

		self.Timer = 60
		self.Owner:EmitSound("C4.PlantSound")
	elseif self.Timer == 60 then
		if (SERVER) then
			self.Owner:PrintMessage(HUD_PRINTTALK, "120 Seconds.")
		end

		self.Timer = 120
		self.Owner:EmitSound("C4.PlantSound")
	elseif self.Timer == 120 then
		if (SERVER) then
			self.Owner:PrintMessage(HUD_PRINTTALK, "300 Seconds.")
		end

		self.Timer = 300
		self.Owner:EmitSound("C4.PlantSound")
	elseif self.Timer == 300 then
		if (SERVER) then
			self.Owner:PrintMessage(HUD_PRINTTALK, "30 Seconds.")
		end

		self.Timer = 30
		self.Owner:EmitSound("C4.PlantSound")
	end
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

	if self.Weapon:GetNetworkedBool("Suppressor") then
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.DeployDelay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.DeployDelay)
	self.ActionDelay = (CurTime() + self.DeployDelay)

//	self:SetIronsights(false)

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