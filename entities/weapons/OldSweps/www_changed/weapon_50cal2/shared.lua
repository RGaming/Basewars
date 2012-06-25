// copy pasta from counter-strike, with barely any real changes.

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "ar2"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "M249"			
	SWEP.Author				= "HLTV Proxy"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 8
	SWEP.IconLetter			= "z"
	
	SWEP.ViewModelFlip		= false
	
	killicon.AddFont( "weapon_50cal2", "CSKillIcons", SWEP.IconLetter, Color( 100, 100, 100, 255 ) )
	
end


SWEP.Base				= "weapon_cs_base2"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel			= "models/weapons/w_mach_m249para.mdl"

SWEP.Weight				= 6
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_m249.Single" )
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 10 --30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= 100
SWEP.Primary.Delay			= 0.135
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( -4.4, -3, 2 )

function SWEP:PrimaryAttack()
	// para is already so powerful, that were just gonna make the upgrade only do a little bit of good.
	if (self.Weapon:GetNWBool("upgraded")) then
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.11 )
		if self.Owner:GetNWBool("doubletapped") then
			self.Weapon:SetNextPrimaryFire( CurTime() + 0.11*drugeffect_doubletapmod )
		else
			self.Weapon:SetNextPrimaryFire( CurTime() + 0.11 )
		end
	else
		self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
		if self.Owner:GetNWBool("doubletapped") then
			self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay*drugeffect_doubletapmod )
		else
			self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		end
	end
	if ( !self:CanPrimaryAttack() ) then 
	return 
	end
	
	// Play shoot sound
	self.Weapon:EmitSound( self.Primary.Sound )
	
	// Shoot the bullet
	local rcone = self.Primary.Cone
	if (self.Owner:GetNWBool("focused")) then
		rcone = rcone*0.5
	end
	if(self:GetIronsights() == true) then
	self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, rcone )
	else
	self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil + 3, self.Primary.NumShots, rcone + .05 )
	end
	
	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )
	
	// Punch the player's view

	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	
	
	// In singleplayer this doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
end
