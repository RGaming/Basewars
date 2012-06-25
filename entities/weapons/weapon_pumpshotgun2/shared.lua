// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base_shotgun"

SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_M3.Single")
SWEP.Primary.Recoil		= 5
SWEP.Primary.Damage		= 12
SWEP.Primary.NumShots		= 8
SWEP.Primary.Cone			= 0.045
SWEP.Primary.Delay 		= 0.95

SWEP.Primary.ClipSize		= 8					// Size of a clip
SWEP.Primary.DefaultClip	= 8					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Buckshot"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellDelay			= 0.53

SWEP.IronSightsPos 		= Vector (5.7431, -1.6786, 3.3682)
SWEP.IronSightsAng 		= Vector (0.0634, -0.0235, 0)
SWEP.RunArmOffset 		= Vector (-2.6657, 0, 3.5)
SWEP.RunArmAngle 			= Vector (-20.0824, -20.5693, 0)

SWEP.ShotgunReloading		= false
SWEP.ShotgunFinish		= 0.5
SWEP.ShotgunBeginReload		= 0.3

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/m3/m3-1.wav")
end