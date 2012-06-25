

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "grenade"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Molotov Cocktail"
	SWEP.Author				= "Pac_187 / Red Dust"
	SWEP.Slot				= 4
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= true
	SWEP.SlotPos			= 3
    SWEP.Contact 			= "http://pac187.pytalhost.com/"
    SWEP.Purpose 			= "Used to blow things up"
    SWEP.Instructions 		= "Left click to throw it far away \n Right click to roll it a few meters"
		
end

SWEP.ViewModel			= "models/weapons/v_molotov.mdl"
SWEP.WorldModel			= "models/weapons/w_grenade.mdl"
SWEP.ViewModelFOV   	= 90


SWEP.Weight				= 2
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Recoil			= 0
SWEP.Primary.Delay 			= 0
SWEP.Primary.Damage			= 0
SWEP.Primary.ClipSize		= 3
SWEP.Primary.Reload 		= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= 1

SWEP.Secondary.Delay		= 0
SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"


/*-----DO NOT DO ANYTHING UNDER THIS LINE EXCEPTING YOU KNOW WHAT YOU ARE DOING!!! -----*/	

function SWEP:Initialize()
util.PrecacheSound( "WeaponFrag.Throw" )
util.PrecacheModel( "models/props_junk/garbage_glassbottle003a.mdl" )
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
local Player = self.Owner

local Molotov = ents.Create( "sent_molotov" )
	Molotov:SetOwner( Player )
	Molotov:SetPos( Player:GetShootPos() )
--	Molotov:SetAngel( Player:GetAimVector() )
	Molotov:Spawn()

	local mPhys = Molotov:GetPhysicsObject()
	local Force = Player:GetAimVector() * 2500
		
		mPhys:ApplyForceCenter( Force )
		
	self.Weapon:EmitSound( "WeaponFrag.Throw" )
	self.Weapon:SendWeaponAnim( ACT_VM_THROW )
	timer.Simple( 0.3, self.Weapon.SendWeaponAnim, self, ACT_VM_IDLE )
	self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 2 )
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
end

	
function SWEP:Reload()
	return false
end
