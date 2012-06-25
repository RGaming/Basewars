

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "pistol"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Mac10"			
	SWEP.Author				= "Rickster"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 4
	SWEP.IconLetter			= "l"
	
	killicon.AddFont( "weapon_mac102", "CSKillIcons", SWEP.IconLetter, Color( 100, 100, 100, 255 ) )
	
end


SWEP.Base				= "weapon_cs_base2"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mac10.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_mac10.Single" )
SWEP.Primary.Recoil			= .23
SWEP.Primary.Damage			= 13 --10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ClipSize		= 30--25
SWEP.Primary.Delay			= 0.08
SWEP.Primary.DefaultClip	= 30 --25
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 6.7, -1.95, 3 )
SWEP.IronSightsAng 		= Vector( 0, 5, 5 )

// upgraded mac10 = faster rate of fire
function SWEP:PrimaryAttack()

	if (self.Weapon:GetNWBool("upgraded")) then
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.065 )
		if self.Owner:GetNWBool("doubletapped") then
			self.Weapon:SetNextPrimaryFire( CurTime() + 0.065*drugeffect_doubletapmod )
		else
			self.Weapon:SetNextPrimaryFire( CurTime() + 0.065 )
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
	if self.Owner:IsPlayer() then
		self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	end
	
	// In singleplayer this doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
end