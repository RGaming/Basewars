// shamelessly raped version of the cse elites.

if ( CLIENT ) then
	SWEP.Author				= "HLTV Proxy"
	SWEP.Contact			= ""
	SWEP.Purpose			= ""
	SWEP.Instructions		= ""
	SWEP.PrintName			= "Elites"
	SWEP.Instructions		= ""
	SWEP.Slot				= 1
	SWEP.SlotPos			= 9
	SWEP.IconLetter			= "s"
	SWEP.DrawCrosshair		= false
	
	killicon.AddFont("weapon_elites2","CSKillIcons",SWEP.IconLetter,Color(100,100,100,255))
end

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end


SWEP.Base				= "weapon_cs_base2"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_elite.mdl"
SWEP.HoldType = "pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_ELITE.Single")
SWEP.Primary.Recoil			= .08
SWEP.Primary.Unrecoil		= 1
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= .055
SWEP.Primary.ClipSize		= 32
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 32
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

//Firemode configuration

// upgrade = double fire
SWEP.IronSightsPos = Vector(0,0,0)

function SWEP:ShootEffects()
	if self.left then
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	
	self.left = not self.left
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

end

// fuck the iron sights, on a weapon that it wouldnt really apply to.
function SWEP:SecondaryAttack()
end

// override primary, to make it call shooteffects

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
	local rcone = self.Primary.Cone
	if (self.Owner:GetNWBool("focused")) then
		rcone = rcone*0.5
	end
	if (self.Weapon:GetNWBool("upgraded") && self.Weapon:Clip1()>1) then
		self.Weapon:EmitSound( self.Primary.Sound )
		timer.Create(tostring(self.Weapon) .. "dbl", 0.027, 1, function() self.Weapon:DoubleTap() end)
		
		self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, 2, rcone )
		self:TakePrimaryAmmo( 2 )
	else
		self.Weapon:EmitSound( self.Primary.Sound )
		self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, rcone )
		self:TakePrimaryAmmo( 1 )
	end
	// Punch the player's view
	if self.Owner:IsPlayer() then
		self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	end
	self:ShootEffects()
	
	// In singleplayer this doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
end


// in b4 drug effect of same name

function SWEP:DoubleTap()
	
	self.Weapon:EmitSound( self.Primary.Sound )
	// have to make the initial shot do both bullets, since doing this here for some odd reason makes the shot not be random.
	//self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, 0.03 )
	//self:TakePrimaryAmmo( 1 )
	// Punch the player's view

	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	
	self:ShootEffects()
	
	// In singleplayer this doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
end