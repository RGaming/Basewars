// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base"

SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_FlareGun.Single")
SWEP.Primary.Reload 		= Sound("Weapon_Pistol.Reload")
SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 0.5

SWEP.Primary.ClipSize		= 1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Grenade"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "effect_mad_shell_shotgun"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= true
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.IronSightsPos 		= Vector (-6.0266, -1.0035, 3.9003)
SWEP.IronSightsAng 		= Vector (0.5281, -1.3165, 0.8108)
SWEP.RunArmOffset 		= Vector (0.041, 0, 5.6778)
SWEP.RunArmAngle 			= Vector (-17.6901, 0.321, 0)

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/flaregun/fire.wav")
    	util.PrecacheSound("weapons/flaregun/burn.wav")
    	util.PrecacheSound("weapons/pistol/pistol_fire2.wav")
    	util.PrecacheSound("weapons/pistol/pistol_reload1.wav")
end

/*---------------------------------------------------------
   Name: SWEP:Flare()
---------------------------------------------------------*/
SWEP.Force = 100000

function SWEP:Flare()

	if (CLIENT) then return end

	local flare = ents.Create("ent_mad_flare")
		flare:SetOwner(self.Owner)
		
		if !(self.Weapon:GetNetworkedBool("Ironsights")) then
			local pos = self.Owner:GetShootPos()
				pos = pos + self.Owner:GetForward() * 5
				pos = pos + self.Owner:GetRight() * 9
				pos = pos + self.Owner:GetUp() * -7
			flare:SetPos(pos)	
		else
			flare:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector()))
		end
		
		flare:SetAngles(self.Owner:GetAngles())
		flare:Spawn()
		flare:Activate()

	local phys = flare:GetPhysicsObject()
	phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force)
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

	self.ActionDelay = (CurTime() + self.Primary.Delay)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	self.Weapon:SendWeaponAnim(ACT_VM_DRYFIRE) 			// View model animation
	self.Owner:SetAnimation(PLAYER_ATTACK1)				// 3rd Person Animation

	self.Weapon:EmitSound(self.Primary.Sound)

	self:TakePrimaryAmmo(1)

	self:Flare()

	self.Owner:ViewPunch(Angle(math.Rand(-0, -5), math.Rand(0, 0), math.Rand(0, 0)))	

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(self.Owner:GetShootPos())
		effectdata:SetEntity(self.Weapon)
		effectdata:SetStart(self.Owner:GetShootPos())
		effectdata:SetNormal(self.Owner:GetAimVector())
		effectdata:SetAttachment(1)
	util.Effect("effect_mad_shotgunsmoke", effectdata)

	timer.Simple(self.ShellDelay, function()
		if not IsFirstTimePredicted() then return end
		if not self.Owner:IsNPC() and not self.Owner:Alive() then return end

		local effectdata = EffectData()
			effectdata:SetEntity(self.Weapon)
			effectdata:SetNormal(self.Owner:GetAimVector())
			effectdata:SetAttachment(2)
		util.Effect(self.ShellEffect, effectdata)
	end)

	local WeaponModel = self.Weapon:GetOwner():GetActiveWeapon():GetClass()

	if (self.Weapon:Clip1() < 1) then
		timer.Simple(self.Primary.Delay + 0.1, function() 
			if self.Weapon:GetOwner():GetActiveWeapon():GetClass() == WeaponModel and self.Owner:Alive() then
				self:Reload() 
			end
		end)
	end
end

/*---------------------------------------------------------
   Name: SWEP:Reload()
   Desc: Reload is being pressed.
---------------------------------------------------------*/
function SWEP:Reload()

	if (self.ActionDelay > CurTime()) then return end 

	self.Weapon:DefaultReload(ACT_VM_RELOAD) 

	if (self.Weapon:Clip1() < self.Primary.ClipSize) and (self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
		self.Owner:SetFOV( 0, 0.15 )
		self:SetIronsights(false)
		self.Weapon:EmitSound(self.Primary.Reload)
	end
end