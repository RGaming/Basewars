// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base"

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip		= true
SWEP.ViewModel 			= "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel 			= "models/weapons/w_pist_elite.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_Elite.Single")
SWEP.Primary.Recoil		= 0.5
SWEP.Primary.Damage		= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.016
SWEP.Primary.Delay 		= 0.125

SWEP.Primary.ClipSize		= 30					// Size of a clip
SWEP.Primary.DefaultClip	= 30					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Battery"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "effect_mad_shell_pistol"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= true
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.DualRightSeq			= 5
SWEP.DualLeftSeq			= 2

SWEP.DeployDelay			= 1.25

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/elite/elite-1.wav")
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end

/*---------------------------------------------------------
   Name: SWEP:ShootBullet()
   Desc: A convenience function to shoot bullets.
---------------------------------------------------------*/
SWEP.ShootPos = 0

function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone)

	num_bullets 		= num_bullets or 1
	aimcone 			= aimcone or 0

	local isright = self.Weapon:GetNetworkedBool("RightGun", false)
	local attach = self.Owner:GetViewModel():LookupAttachment("1")

	if (!isright) then
		if (self.Weapon:Clip1() <= 2) then
			attach = self.Owner:GetViewModel():LookupAttachment("2")
			self.Owner:GetViewModel():SetSequence("shoot_leftlast")
		else
			attach = self.Owner:GetViewModel():LookupAttachment("2")
			self.Owner:GetViewModel():SetSequence(self.DualLeftSeq)
		end
	else
		if (self.Weapon:Clip1() < 2) then
			attach = self.Owner:GetViewModel():LookupAttachment("1")
			self.Owner:GetViewModel():SetSequence("shoot_rightlast")
		else
			attach = self.Owner:GetViewModel():LookupAttachment("1")
			self.Owner:GetViewModel():SetSequence(self.DualRightSeq)
		end
	end

	if (self.Weapon:Clip1() < 2) then
		local WeaponModel = self.Weapon:GetOwner():GetActiveWeapon():GetClass()

		timer.Simple(self.Primary.Delay + 0.1, function() 
			if self.Weapon:GetOwner():GetActiveWeapon():GetClass() == WeaponModel and self.Owner:Alive() then
				self:Reload() 
			end
		end)
	end

	local shootpos = self.Owner:GetViewModel():GetAttachment(attach).Pos
	self.ShootPos = attach

	self.Weapon:SetNetworkedBool("RightGun", !isright)

	local bullet = {}
		bullet.Num 		= num_bullets
		bullet.Src 		= self.Owner:GetShootPos()			// Source
		bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
		bullet.Spread 	= Vector(aimcone, aimcone, 0)			// Aim Cone
		bullet.Tracer	= 1							// Show a tracer on every x bullets
		bullet.Force	= damage * 0.5					// Amount of force to give to phys objects
		bullet.Damage	= damage
		bullet.Callback	= function(attacker, tr, dmginfo) 
						if not self.Owner:IsNPC() and self.Owner:GetNetworkedInt("Fuel") > 0 then
							self:ShootFire(attacker, tr, dmginfo) 
						end

						return self:RicochetCallback_Redirect(attacker, tr, dmginfo) 
					  end

	self.Owner:FireBullets(bullet)

	self.Owner:MuzzleFlash()						// Crappy muzzle light
	self.Owner:SetAnimation(PLAYER_ATTACK1)				// 3rd Person Animation

	local effectdata = EffectData()
		effectdata:SetOrigin(shootpos)
		effectdata:SetEntity(self.Weapon)
		effectdata:SetStart(shootpos)
		effectdata:SetNormal(self.Owner:GetAimVector())
		effectdata:SetAttachment(attach)

	if (self.Shotgun) then
		util.Effect("effect_mad_shotgunsmoke", effectdata)
	else
		util.Effect("effect_mad_gunsmoke", effectdata)
	end

	timer.Simple(self.ShellDelay, function()
		if not IsFirstTimePredicted() then return end
		if not self.Owner:IsNPC() and not self.Owner:Alive() then return end

		local effectdata = EffectData()
			effectdata:SetEntity(self.Weapon)
			effectdata:SetNormal(self.Owner:GetAimVector())
			effectdata:SetAttachment(attach)
		util.Effect(self.ShellEffect, effectdata)
	end)

	if (not self.Owner:IsNPC()) and ((SinglePlayer() and SERVER) or (not SinglePlayer() and CLIENT)) then
		local eyeangle 	= self.Owner:EyeAngles()
		eyeangle.pitch 	= eyeangle.pitch - recoil
		self.Owner:SetEyeAngles(eyeangle)
	end
end

/*---------------------------------------------------------
   Name: SWEP:GetTracerOrigin()
   Desc: Allows you to override where the tracer comes from (in first person view)
	   returning anything but a vector indicates that you want the default action.
---------------------------------------------------------*/
local pos

function SWEP:GetTracerOrigin()

	local isright = self.Weapon:GetNetworkedBool("RightGun", true)

	if (!isright) then
		pos = self:GetOwner():GetShootPos() + self:GetOwner():EyeAngles():Right() * -5 + self:GetOwner():EyeAngles():Up() * -3.5
	else
		pos = self:GetOwner():GetShootPos() + self:GetOwner():EyeAngles():Right() * 5 + self:GetOwner():EyeAngles():Up() * -3.5
	end

	return pos
end