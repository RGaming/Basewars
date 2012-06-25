// this was rickster's ak47.

if ( SERVER ) then
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "ar2"
	
end

if ( CLIENT ) then

	SWEP.ViewModelFlip		= false
	SWEP.PrintName			= "Laser Rifle"			
	SWEP.Author				= "HLTV Proxy"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 14
	SWEP.ViewModelFlip		= true

	killicon.AddFont( "weapon_laserrifle", "HL2MPTypeDeath", SWEP.IconLetter, Color( 100, 100, 100, 255 ) )
	
	if (file.Exists("../materials/weapons/weapon_mad_awp.vmt")) then
		SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_awp")
	end
end


SWEP.Base				= "weapon_mad_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.DrawCrosshair 		= true

SWEP.ViewModel			= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_scout.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_Scout.Single" )
SWEP.Primary.Recoil			= 0.00000000001
SWEP.Primary.Damage			= 70
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0001
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 2
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Battery		= 100
SWEP.Primary.Chargerate		= .125
// how long before the trigger is pulled before the shot actually fires
SWEP.Primary.Timetofire		= .5
SWEP.Primary.Charginmahlazer	= false
SWEP.Primary.Lastfired		= CurTime()

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


SWEP.IronSightsPos 		= Vector( 0, 0, 0 )
SWEP.IronSightsAng 		= Vector( 0, 0, 0 )
//SWEP.IronSightsPos 		= Vector( -2.7, -8, 2.225 )
//SWEP.IronSightsAng 		= Vector( 0, -4, 0 )

// laser rifle upgrade = less battery used per shot

function SWEP:Upgrade(bool)
	self.Weapon:SetNWBool("upgraded",bool)
end

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
	self:SetIronsights( false )
	self.Owner:SetFOV(90,.3)
end

function SWEP:Think()
	if !self.Primary.Charginmahlazer && self.LastCharge<CurTime()-self.Primary.Chargerate && self.Primary.Battery<100 then
		self.Primary.Battery=self.Primary.Battery+1
		self.LastCharge = CurTime()
		//self.Weapon:SetNWInt("battery", self.Primary.Battery)
	end
	if self.Primary.Charginmahlazer && self.Primary.Lastfired<CurTime()-self.Primary.Timetofire then
		local burn = 40
		if self.Weapon:GetNWBool("upgraded") then
			burn = 25
		end
		self.LastCharge = CurTime()
		self.Primary.Charginmahlazer = false
		if ( self.Primary.Battery>=0) then
			self.Weapon:EmitSound( self.Primary.Sound )
			
			self:CSShootBullet( self.Primary.Damage, 0, self.Primary.NumShots, 0 )
			local beamorigin = self.Owner:GetShootPos()+self.Owner:EyeAngles():Right()*5+self.Owner:EyeAngles():Up()*-5
			local beamstart = self.Owner:GetEyeTrace()
			local effectdata = EffectData()
				effectdata:SetStart(beamstart.HitPos)
				effectdata:SetOrigin(beamorigin)
				effectdata:SetAngle(Angle(tonumber(self.Owner:GetInfo("bw_clcolor_r")),tonumber(self.Owner:GetInfo("bw_clcolor_g")),tonumber(self.Owner:GetInfo("bw_clcolor_b"))))
			util.Effect("chargebeam", effectdata)
			
			// add a tiny bit of blast damage
			util.BlastDamage(self.Weapon,self.Owner,beamstart.HitPos, 64, 30)
			
			self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
			
			
			// In singleplayer this doesn't get called on the client, so we use a networked float
			// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
			// send the float.
			if ( (SinglePlayer() && SERVER) || CLIENT ) then
				self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
			end
		end
	end
end

function SWEP:PrimaryAttack()

	
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.LastCharge = CurTime()+self.Primary.Chargerate*3
	local burn = 40
	if self.Weapon:GetNWBool("upgraded") then
		burn = 20
	end
	if ( self.Primary.Battery<burn || self.Primary.Charginmahlazer ) then 
		return 
	end
	self.Primary.Charginmahlazer = true
	self.Primary.Battery=self.Primary.Battery-burn
	self.Primary.Lastfired = CurTime()
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
end

function SWEP:Initialize()

	if ( SERVER ) then
		self:SetWeaponHoldType( self.HoldType )
	end
	
	self.Weapon:SetNetworkedBool( "Ironsights", false )
	//self.Weapon:SetNWInt("Battery", self.Primary.Battery)
	self.LastCharge = CurTime()
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
	bullet.Force	= 60									// Amount of force to give to phys objects
	bullet.Damage	= dmg
	bullet.Attacker = self.Owner
	self.Weapon:FireBullets( bullet )
	self.Weapon:SendWeaponAnim( ACT_VM_ATTACK1 ) 		// View model animation
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
