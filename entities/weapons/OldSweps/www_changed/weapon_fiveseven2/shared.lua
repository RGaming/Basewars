

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "pistol"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "FiveSeven"			
	SWEP.Author				= "Rickster"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 7
	SWEP.IconLetter			= "u"
	
	killicon.AddFont( "weapon_fiveseven2", "CSKillIcons", SWEP.IconLetter, Color( 100, 100, 100, 255 ) )
	
end


SWEP.Base				= "weapon_cs_base2"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_fiveseven.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_FiveSeven.Single" )
SWEP.Primary.Recoil			= .5
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ClipSize		= 21
SWEP.Primary.Delay			= 0.07
SWEP.Primary.DefaultClip	= 21
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 4.5, -4, 3 )

// fiveseven upgrade = automatic pistol

function SWEP:PrimaryAttack()
	if (self.Weapon:GetNWBool("upgraded")) then
		self.Primary.Automatic = true
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.09 )
		if self.Owner:GetNWBool("doubletapped") then
			self.Weapon:SetNextPrimaryFire( CurTime() + 0.09*drugeffect_doubletapmod )
		else
			self.Weapon:SetNextPrimaryFire( CurTime() + 0.09 )
		end
	else
		self.Primary.Automatic = false
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

function SWEP:Upgrade(bool)
	self.Weapon:SetNWBool("upgraded",bool)
	/*if bool then
		self.Primary.Automatic = true
	else
		self.Primary.Automatic = false
	end*/
end