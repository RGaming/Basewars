// shamelessly raped version of the cse elites.

if ( CLIENT ) then
	SWEP.Author				= "HLTV Proxy"
	SWEP.Contact			= ""
	SWEP.Purpose			= ""
	SWEP.Instructions		= ""
	SWEP.PrintName			= "Sentry Turret's gun"
	SWEP.Instructions		= ""
	SWEP.Slot				= 3
	SWEP.SlotPos			= 15
	SWEP.ViewModelFlip		= false
	SWEP.IconLetter			= "a"
	SWEP.DrawCrosshair		= false
	surface.CreateFont( "HalfLife2", ScreenScale( 60 ), 500, true, true, "HL2SelectIcons" )
	killicon.AddFont("weapon_turretgun","HL2MPTypeDeath","/",Color(100,100,100,255))
end

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end


SWEP.Base				= "weapon_mad_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"
SWEP.HoldType = "smg"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_Pistol.Single")
SWEP.Primary.Recoil			= .5
SWEP.Primary.Unrecoil		= 3
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= .01
SWEP.Primary.ClipSize		= 50
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Recoil			= .125
SWEP.Secondary.Ammo			= "none"
// these really apply to primary, but well store these here just because.
SWEP.Secondary.Delay = 1
SWEP.Secondary.BurstDelay = .05
SWEP.Secondary.Cone = 0.010
SWEP.Secondary.Shots = 5
SWEP.Secondary.Counter = 0
SWEP.Secondary.Timer = 0

//Firemode configuration

SWEP.IronSightsPos = Vector(0,0,0)

// turretgun upgrade = armor piercer

function SWEP:SecondaryAttack()
	if ( !self:CanPrimaryAttack() ) then 
		return 
	end
	/*
	if (self.Weapon:GetNWBool("upgraded")) then
		self:PrimaryAttack()
		self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
		
		self.Secondary.Timer = CurTime()
		self.Secondary.Counter = self.Secondary.Shots - 1
	end
	*/
end

// override primary, to make it call shooteffects

function SWEP:PrimaryAttack()

	if ( !self:CanPrimaryAttack() ) then 
		return 
	end
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	if self.Owner:GetNWBool("doubletapped") then
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay*drugeffect_doubletapmod )
	else
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	end
	
	
	// Play shoot sound
	self.Weapon:EmitSound( self.Primary.Sound )
	
	// Shoot the bullet
	local rcone = self.Primary.Cone
	if (self.Owner:GetNWBool("focused")) then
		rcone = rcone*0.5
	end
	local bullet = {}
		bullet.Attacker		= self.Owner
		bullet.Num 		= 1
		bullet.Src 		= self.Owner:GetShootPos()
		bullet.Dir 		= self.Owner:GetAimVector()
		bullet.Spread 		= Vector( self.Primary.Cone, self.Primary.Cone, 0 )
		bullet.Tracer		= 1
		bullet.TracerName 	= "AirboatGunHeavyTracer"
		bullet.Force		= 50
		bullet.Damage		= self.Primary.Damage
		// make it work like the turret does, with its limited distance
		bullet.Callback		= function(attacker,tr,dmginfo)
						local dist = tr.HitPos:Distance(tr.StartPos)
						if dist>1000 then
							dmginfo:ScaleDamage(0)
						end
					end
	self.Weapon:FireBullets(bullet)
	
	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )
	
	// Punch the player's view

	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	
	// In singleplayer this doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	if ( (SinglePlayer() && SERVER) || ( !SinglePlayer() && CLIENT ) ) then
	
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - self.Primary.Recoil
		self.Owner:SetEyeAngles( eyeang )
	
	end
	
end

function SWEP:Think()
	if self.Secondary.Timer + self.Secondary.BurstDelay < CurTime() then
		if self.Secondary.Counter > 0 && self.Weapon:Clip1()>0 then
			self.Secondary.Counter = self.Secondary.Counter - 1
			self.Secondary.Timer = CurTime()
			
			if self:CanPrimaryAttack() then
				self.Weapon:EmitSound(self.Primary.Sound)
				local rcone = self.Secondary.Cone
				if (self.Owner:GetNWBool("focused")) then
					rcone = rcone*0.85
				end
				self:CSShootBullet( self.Primary.Damage, self.Secondary.Recoil, self.Primary.NumShots, rcone )

				self:TakePrimaryAmmo( 1 )
				
			end
		else
			self.Secondary.Counter = 0
		end
	end
end

function SWEP:Upgrade(bool)
	self.Weapon:SetNWBool("upgraded",bool)
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	draw.SimpleText( "a", "HL2SelectIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	
	if (self.Weapon:GetNWBool("upgraded")) then
		draw.SimpleText("K", "CSKillIcons", x + wide-20, y + tall-25, Color(200,200, 200, 255), TEXT_ALIGN_CENTER )
	end
end

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	// so that after reload, gun doesnt fire off 1 or 2 rounds on its own.
	self.Secondary.Counter = 0
end

function SWEP:ShouldDropOnDie()
	return true
end