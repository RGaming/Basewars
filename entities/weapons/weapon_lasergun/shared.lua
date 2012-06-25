// this was rickster's ak47.

if ( SERVER ) then
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "ar2"
	
end

if ( CLIENT ) then

	SWEP.ViewModelFlip		= false
	SWEP.PrintName			= "Laser Gun"			
	SWEP.Author				= "HLTV Proxy"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 14
	SWEP.IconLetter			= ","
	SWEP.ViewModelFlip		= true

	killicon.AddFont( "weapon_laserrifle", "HL2MPTypeDeath", SWEP.IconLetter, Color( 100, 100, 100, 255 ) )
	
end


SWEP.Base				= "weapon_mad_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_irifle.mdl"
SWEP.WorldModel			= "models/weapons/w_irifle.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_AR2.Single" )
SWEP.Primary.Recoil			= 0.00000000001
SWEP.Primary.Damage			= 2
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0001
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 0.005
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Battery		= 100
SWEP.Primary.Chargerate		= .1

SWEP.Secondary.Sound			= Sound( "Weapon_AR2.Single" )
SWEP.Secondary.Recoil			= 1
SWEP.Secondary.Damage			= 40
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0.0001
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.Delay			= 1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo			= "none"


SWEP.IronSightsPos 		= Vector( -2.7, -8, 2.225 )
SWEP.IronSightsAng 		= Vector( 0, -4, 0 )

// laser upgrade = more charge

function SWEP:Upgrade(bool)
	self.Weapon:SetNWBool("upgraded",bool)
end

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
	self:SetIronsights( false )
	self.Owner:SetFOV(90,.3)
end

function SWEP:Think()
	if self.LastCharge<CurTime()-self.Primary.Chargerate && self.Primary.Battery<100 then
		self.Primary.Battery=self.Primary.Battery+1
		self.LastCharge = CurTime()
	end
end

function SWEP:PrimaryAttack()

	
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.LastCharge = CurTime()+self.Primary.Chargerate*3
	if ( self.Primary.Battery<=0 ) then 
		return 
	end
	
	// Play shoot sound
	//self.Weapon:EmitSound( self.Primary.Sound )
	
	self:CSShootBullet( self.Primary.Damage, 0, self.Primary.NumShots, 0 )
	local beamorigin = self.Owner:GetShootPos()+self.Owner:EyeAngles():Right()*5+self.Owner:EyeAngles():Up()*-5
	local beamstart = self.Owner:GetEyeTrace()
	local effectdata = EffectData()
		effectdata:SetStart(beamstart.HitPos)
		effectdata:SetOrigin(beamorigin)
		effectdata:SetAngle(Angle(tonumber(self.Owner:GetInfo("bw_clcolor_r")),tonumber(self.Owner:GetInfo("bw_clcolor_g")),tonumber(self.Owner:GetInfo("bw_clcolor_b"))))
	util.Effect("laserbeam", effectdata)
	
	// Remove 1 bullet from our clip
	if self.Weapon:GetNWBool("upgraded") then
		if self.Halfcharge then
			self.Primary.Battery=self.Primary.Battery-1
		end
		self.Halfcharge = !self.Halfcharge
	else
		self.Primary.Battery=self.Primary.Battery-1
	end
	// Punch the player's view

	//self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	
	
	// In singleplayer this doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
end

function SWEP:Initialize()

	if ( SERVER ) then
		self:SetWeaponHoldType( self.HoldType )
	end
	
	self.Weapon:SetNetworkedBool( "Ironsights", false )
	self.LastCharge = CurTime()
	self.Halfcharge = false
end

function SWEP:CSShootBullet( dmg, recoil, numbul, cone )

	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01

	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
	bullet.Spread 	= Vector( cone, cone, 0 )			// Aim Cone
	bullet.Tracer	= 4									// Show a tracer on every x bullets 
	bullet.Force	= 5									// Amount of force to give to phys objects
	bullet.Damage	= dmg
	bullet.Attacker = self.Owner
	self.Weapon:FireBullets( bullet )
	self.Weapon:SendWeaponAnim( ACT_VM_RELOAD ) 		// View model animation
	//self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
	// CUSTOM RECOIL !
	if ( (SinglePlayer() && SERVER) || ( !SinglePlayer() && CLIENT ) ) then
	
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	
	end

end

function SWEP:GetViewModelPosition( pos, ang )
	local Mul = 1.0
	local Offset	= self.IronSightsPos
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
	
end

function SWEP:SecondaryAttack()
	
end