

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "ar2"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "AK47"			
	SWEP.Author				= "Rickster"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 6
	SWEP.IconLetter			= "b"
	
	killicon.AddFont( "weapon_ak472", "CSKillIcons", SWEP.IconLetter, Color( 100, 100, 100, 255 ) )
	
end


SWEP.Base				= "weapon_cs_base2"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_ak47.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 20 --27.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.ClipSize		= 25
SWEP.Primary.Delay			= 0.105
SWEP.Primary.DefaultClip	= 25
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 6.1, -7, 2.5 )
SWEP.IronSightsAng 		= Vector( 2.8, 0, 0 )

// AK gets that bannana clip for an upgrade.
function SWEP:Upgrade(bool)
	self.Weapon:SetNWBool("upgraded",bool)
	if bool then
		self.Primary.ClipSize = 40
	else
		self.Primary.ClipSize = 25
	end
end

function SWEP:Reload()
	if (self.Weapon:GetNWBool("upgraded") && self.Weapon:Clip1()<40) || (!self.Weapon:GetNWBool("upgraded") && self.Weapon:Clip1()<25) then
		self.Weapon:DefaultReload( ACT_VM_RELOAD );
		self:SetIronsights( false )
		self.Owner:SetFOV(90,.3)
	end
end