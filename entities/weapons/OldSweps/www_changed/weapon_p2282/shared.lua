
if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "pistol"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "p228"			
	SWEP.Author				= "Rickster"

	SWEP.Slot				= 1
	SWEP.SlotPos			= 4
	SWEP.IconLetter			= "y"
	
	killicon.AddFont( "weapon_p2282", "CSKillIcons", SWEP.IconLetter, Color( 100, 100, 100, 255 ) )

end

SWEP.Base				= "weapon_cs_base2"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_p228.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_p228.Single" )
SWEP.Primary.Recoil			= 0.8
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos = Vector(4.76,-2,2.955)
SWEP.IronSightsAng = Vector(-.6,0,0)

SWEP.Upgraded = false
// gonna leave it as being from normal cs base even though im sure it was an error, and just override the draw function to include upgrades.

// p228 upgrade = bigger clip and accuracy boost
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	
	if (self.Weapon:GetNWBool("upgraded")) then
		draw.SimpleText("K", "CSKillIcons", x + wide-20, y + tall-25, Color(200,200, 200, 255), TEXT_ALIGN_CENTER )
	end
end

// upgraded p228 = clip extension and slight accuracy increase

function SWEP:Upgrade(bool)
	self.Weapon:SetNWBool("upgraded",bool)
	if bool then
		self.Primary.ClipSize = 16
	else
		self.Primary.ClipSize = 12
	end
end

function SWEP:Reload()
	if (self.Weapon:GetNWBool("upgraded") && self.Weapon:Clip1()<16) || (!self.Weapon:GetNWBool("upgraded") && self.Weapon:Clip1()<12) then
		self.Weapon:DefaultReload( ACT_VM_RELOAD );
		self:SetIronsights( false )
		self.Owner:SetFOV(self.ViewModelFOV,.3)
	end
end

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
	self.Weapon:EmitSound( self.Primary.Sound )
	local rcone = self.Primary.Cone
	if (self.Owner:GetNWBool("focused")) then
		rcone = rcone*0.5
	end
	if (self.Weapon:GetNWBool("upgraded")) then
		self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, 0.03 )
	else
		self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, rcone )
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

function SWEP:ShouldDropOnDie()
	return true
end