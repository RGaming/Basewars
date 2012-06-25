

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "smg"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "MP5"			
	SWEP.Author				= "Rickster"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 7
	SWEP.IconLetter			= "x"
	
	killicon.AddFont( "weapon_mp52", "CSKillIcons", SWEP.IconLetter, Color( 100, 100, 100, 255 ) )
	
end


SWEP.Base				= "weapon_cs_base2"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mp5.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_MP5Navy.Single" )
SWEP.Primary.Recoil			= 0.32
SWEP.Primary.Damage			= 17.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0275
SWEP.Primary.ClipSize		= 32
SWEP.Primary.Delay			= 0.09
SWEP.Primary.DefaultClip	= 32
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
// just there to be precached for upgraded mp5
SWEP.Secondary.Sound			= Sound( "Weapon_USP.SilencedShot" )
SWEP.IronSightsPos 		= Vector( 4.7, -4, 2 )

// mp5 upgrade = increased accuracy, lower recoil, silenced

function SWEP:PrimaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	if self.Owner:GetNWBool("doubletapped") then
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay*drugeffect_doubletapmod )
	else
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	end
	
	if ( !self:CanPrimaryAttack() ) then 
	return 
	end
	
	// Play shoot sound
	if (self.Weapon:GetNWBool("upgraded")) then
		self.Weapon:EmitSound( self.Secondary.Sound )
	else
		self.Weapon:EmitSound( self.Primary.Sound )
	end
	
	// Shoot the bullet
	local rcone = self.Primary.Cone
	if (self.Owner:GetNWBool("focused")) then
		rcone = rcone*0.5
	end
	if(self:GetIronsights() == true) then
		if (self.Weapon:GetNWBool("upgraded")) then
			self:CSShootBullet( self.Primary.Damage, 0.22, self.Primary.NumShots, rcone*0.5 )
		else
			self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, rcone )
		end
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