
if ( CLIENT ) then
	SWEP.Author				= "CSE - Night-Eagle"
	SWEP.Contact			= "gmail sedhdi"
	SWEP.Purpose			= ""
	SWEP.Instructions		= ""
	SWEP.PrintName			= "USP"
	SWEP.Instructions		= "Hold use and left-click to attach silencer."
	SWEP.Slot				= 1
	SWEP.SlotPos			= 8
	SWEP.IconLetter			= "a"
	
	killicon.AddFont("weapon_usp2","CSKillIcons",SWEP.IconLetter,Color(100,100,100,255))
end

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end


SWEP.Base				= "cse_base_s"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"
SWEP.HoldType = "pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_USP.Single")
SWEP.Primary.Recoil			= 4
SWEP.Primary.Unrecoil		= 8
SWEP.Primary.Damage			= 17.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.003
SWEP.Primary.ClipSize		= 13
SWEP.Primary.Delay			= 0.06 //Don't use this, use the tables below!
SWEP.Primary.DefaultClip	= 14 //Always set this 1 higher than what you want.
SWEP.Primary.Automatic		= true //Don't use this, use the tables below!
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

//Firemode configuration

SWEP.IronSightsPos = Vector(4.485,-2,2.745)
SWEP.IronSightsAng = Vector(-.2,-.025,0)

SWEP.data = {}
SWEP.mode = "semi" //The starting firemode
SWEP.data.newclip = false //Do not change this



SWEP.data.semi = {}
SWEP.data.semi.Delay = .165
SWEP.data.semi.Cone = 0.013
SWEP.data.semi.ConeZoom = 0.0105
SWEP.data.silenced = false

//End of configuration

function SWEP:Think()
	if SinglePlayer() then self.data.singleplayer(self) end
	if self.data.init then		
		self.Weapon:SetClip1( self.Weapon:Clip1() - 1 )
		self.data.init = nil
	end
	if self.data.newclip then
		if self.data.newclip == 0 then
			self.data.newclip = false
			
			if self:Ammo1() > self.Primary.ClipSize - 1 then
				if self.data.oldclip == 0 then
					self.Weapon:SetClip1( self.Weapon:Clip1() - 1 )
					if SERVER then
						self.Owner:GiveAmmo(1,self.Primary.Ammo,true)
					end
				end
			end
		else
			self.data.newclip = self.data.newclip - 1
		end
	end
	if self.deployed then
		if self.deployed == 0 then
			if self.data.silenced then
				self.Weapon:SendWeaponAnim(ACT_VM_IDLE_SILENCED)
			else
				self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			end
			self.deployed = false
			self.Weapon:SetNextPrimaryFire( CurTime() + .001 )
		else
			self.deployed = self.deployed - 1
		end
	end
end

function SWEP:PrimaryAttack()
	if !self.Owner:KeyDown(IN_USE) then
		if ( !self:CanPrimaryAttack() ) or self.data.newclip or self.data.init then
			if self.data.silenced then
				self.Weapon:DefaultReload(ACT_VM_RELOAD_SILENCED)
			else
				self.Weapon:DefaultReload(ACT_VM_RELOAD)
			end
			return
		end
		
		if CLIENT then
			self.xhair.loss = self.xhair.loss + self.Primary.Recoil
		end
		if self.Weapon:GetNWBool("upgraded") then
			if self.Owner:GetNWBool("doubletapped") then
				self.Weapon:SetNextPrimaryFire( CurTime() + self.data[self.mode].Delay*drugeffect_doubletapmod*.8 )
			else
				self.Weapon:SetNextPrimaryFire( CurTime() + self.data[self.mode].Delay*.8 )
			end
		else
			if self.Owner:GetNWBool("doubletapped") then
				self.Weapon:SetNextPrimaryFire( CurTime() + self.data[self.mode].Delay*drugeffect_doubletapmod )
			else
				self.Weapon:SetNextPrimaryFire( CurTime() + self.data[self.mode].Delay )
			end
		end
		self.Weapon:EmitSound(self.Primary.Sound)
		self:TakePrimaryAmmo( 1 )
		
		self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	
		if self.Owner:GetFOV() == 90 then
			--self:ShootBullet( 1, 1, self.data[self.mode].Cone )
			self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.data[self.mode].Cone )
		else
			--self:ShootBullet( 1, 1, self.data[self.mode].ConeZoom )
			self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.data[self.mode].ConeZoom )
		end
	elseif self.Weapon:GetNWBool("upgraded") then
		if self.data.silenced then
			self.Weapon:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
			self.Primary.Sound			= Sound("Weapon_USP.Single")
			self.data.silenced = false
		else
			self.Weapon:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
			self.Primary.Sound			= Sound("Weapon_USP.SilencedShot")
			self.data.silenced = true
		end
		self.Weapon:SetNextPrimaryFire( CurTime() + 3 )
	end
end

function SWEP:Reload()
	self:SetIronsights(false)
	if SERVER and self.Owner:GetFOV() ~= 90 then
		self.Owner:SetFOV(90,.3)
	end
	
	self.data.oldclip = self.Weapon:Clip1()
	
	if self.data.silenced then
		self.Weapon:DefaultReload(ACT_VM_RELOAD_SILENCED)
	else
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
	end
	self.data.newclip = 1
end

function SWEP:Deploy()
	self:SetIronsights(false)
	self.deployed = 2
	return true
end

function SWEP:ShootEffects()
	if self.data.silenced then
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:MuzzleFlash()
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end
