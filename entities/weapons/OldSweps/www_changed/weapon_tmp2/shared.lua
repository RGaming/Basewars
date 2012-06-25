

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "pistol"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "TMP"			
	SWEP.Author				= "HLTV Proxy"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 9
	SWEP.IconLetter			= "d"
	
	killicon.AddFont( "weapon_tmp2", "CSKillIcons", SWEP.IconLetter, Color( 100, 100, 100, 255 ) )
	
end


SWEP.Base				= "weapon_cs_base2"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_tmp.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_TMP.Single" )
SWEP.Primary.Recoil			= .1
SWEP.Primary.Damage			= 7
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= .03--0.1
SWEP.Primary.ClipSize		= 35
SWEP.Primary.Delay			= 0.04
SWEP.Primary.DefaultClip	= 35
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector(4.799,-3,2.95)
SWEP.IronSightsAng 		= Vector(-1,.25,-5.75)

// upgraded tmp = faster rate of fire
function SWEP:PrimaryAttack()

	if (self.Weapon:GetNWBool("upgraded")) then
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.035 )
		if self.Owner:GetNWBool("doubletapped") then
			self.Weapon:SetNextPrimaryFire( CurTime() + 0.035*drugeffect_doubletapmod )
		else
			self.Weapon:SetNextPrimaryFire( CurTime() + 0.035 )
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
	self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, rcone )
	
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

// ironsights look like ass.
function SWEP:SecondaryAttack()
end