if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "Pistol"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Money Cannon"			
	SWEP.Author				= "Fijet"

	SWEP.Slot				= 5
	SWEP.SlotPos			= 7
	SWEP.ViewModelFOV		= 62
	SWEP.IconLetter			= "x"

end

------------General Swep Info---------------
SWEP.Author   = "Fijet"
SWEP.Contact        = ""
SWEP.Purpose        = ""
SWEP.Instructions   = "Stick Some Combine To The Walls!"
SWEP.Spawnable      = true
SWEP.AdminSpawnable  = true
-----------------------------------------------

------------Models---------------------------
SWEP.ViewModel      = "models/weapons/v_RPG.mdl"
SWEP.WorldModel   = "models/weapons/w_rocket_launcher.mdl"
-----------------------------------------------

-------------Primary Fire Attributes----------------------------------------
SWEP.Primary.Delay			= 0.9 	--In seconds
SWEP.Primary.Recoil			= 0		--Gun Kick
SWEP.Primary.Damage			= 100	--Damage per Bullet
SWEP.Primary.NumShots		= 1		--Number of shots per one fire
SWEP.Primary.Cone			= 0 	--Bullet Spread
SWEP.Primary.ClipSize		= 1	--Use "-1 if there are no clips"
SWEP.Primary.DefaultClip	= -1	--Number of shots in next clip
SWEP.Primary.Automatic   	= false	--Pistol fire (false) or SMG fire (true)
SWEP.Primary.Ammo         	= "none"	--Ammo Type
-------------End Primary Fire Attributes------------------------------------
 
-------------Secondary Fire Attributes-------------------------------------
SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 100
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"
-------------End Secondary Fire Attributes--------------------------------
 
-- function SWEP:Reload() --To do when reloading
-- end 
 
function SWEP:Think() -- Called every frame
end

function SWEP:Initialize()
util.PrecacheSound("physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav")
util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")
end

---------------------------------------------------------------------------

function SWEP:PrimaryAttack()
self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
self.Weapon:SetNextPrimaryFire(CurTime() + 0.01)
self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
if SERVER then
local moneybag = ents.Create("prop_moneybag")
moneybag:SetModel( "models/notes.mdl" );
moneybag:SetAngles(self.Owner:EyeAngles())-- Angle(0,90,0))
moneybag:SetPos(self.Owner:GetShootPos())
moneybag:SetOwner(self.Owner)
moneybag:SetPhysicsAttacker(self.Owner)
moneybag:Spawn();
moneybag:SetColor(200,255,200,255)
moneybag:GetTable().MoneyBag = true;
moneybag:GetTable().Amount = 25000
local phys = moneybag:GetPhysicsObject()
phys:ApplyForceCenter(self.Owner:GetAimVector() * 2000)
phys:AddAngleVelocity(Vector(0,5000,0))
moneybag:Fire("kill", "", 25)
end
end

---------------------------------------------------------------------------

---------------------------------------------------------------------------

function SWEP:SecondaryAttack()
self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
self.Weapon:SetNextSecondaryFire(CurTime() + 0.01)
self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
if SERVER then
local moneybag = ents.Create("prop_moneybag")
moneybag:SetModel( "models/notes.mdl" );
moneybag:SetAngles(self.Owner:EyeAngles())-- Angle(0,90,0))
moneybag:SetPos(self.Owner:GetShootPos())
moneybag:SetOwner(self.Owner)
moneybag:SetPhysicsAttacker(self.Owner)
moneybag:Spawn();
moneybag:SetColor(200,255,200,255)
moneybag:GetTable().MoneyBag = true;
moneybag:GetTable().Amount = 1000000
local phys = moneybag:GetPhysicsObject()
phys:ApplyForceCenter(self.Owner:GetAimVector() * 20000)
phys:AddAngleVelocity(Vector(0,5000,0))
moneybag:Fire("kill", "", 25)
end
end
-------------------------------------------------------------------