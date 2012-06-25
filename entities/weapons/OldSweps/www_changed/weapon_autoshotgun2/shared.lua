

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "ar2"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "M1014"			
	SWEP.Author				= "HLTV Proxy"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 8
	SWEP.IconLetter			= "B"
	
	killicon.AddFont( "weapon_autoshotgun2", "CSKillIcons", SWEP.IconLetter, Color( 100, 100, 100, 255 ) )
	
end


SWEP.Base				= "weapon_cs_base2"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_shot_xm1014.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_xm1014.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_XM1014.Single" )
SWEP.Primary.Recoil			= 1.6
SWEP.Primary.Damage			= 12.5
SWEP.Primary.NumShots		= 5
SWEP.Primary.Cone			= 0.09
SWEP.Primary.ClipSize		= 5
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 5.1, -4, 2.15 )
SWEP.IronSightsAng 		= Vector( 0, 0.5, 0 )

// autoshotgun upgrade = faster reload
/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
	
	//if ( CLIENT ) then return end
	
	self:SetIronsights( false )
	
	// Already reloading
	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
	
	// Start reloading if we can
	if ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		
		self.Weapon:SetNetworkedBool( "reloading", true )
		if (self.Weapon:GetNWBool("upgraded")) then
			self.Weapon:SetVar( "reloadtimer", CurTime() + 0.275 )
		else
			self.Weapon:SetVar( "reloadtimer", CurTime() + 0.4 )
		end
		//self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		
	end

end

/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()


	if ( self.Weapon:GetNetworkedBool( "reloading" ) ) then
	
		if ( self.Weapon:GetVar( "reloadtimer" ) < CurTime() ) then
			
			// Finsished reload -
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SetNetworkedBool( "reloading", false )
				return
			end
			
			// Next cycle
			if (self.Weapon:GetNWBool("upgraded")) then
				self.Weapon:SetVar( "reloadtimer", CurTime() + 0.4 )
			else
				self.Weapon:SetVar( "reloadtimer", CurTime() + 0.6 )
			end
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			
			// Add ammo
			self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
			self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
			
			// Finish filling, final pump
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay*2 )
				self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay*2 )
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
			else
					
			end
			
		end
	
	end

end


function SWEP:PrimaryAttack()
	self.Weapon:SetNetworkedBool( "reloading", false )
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
	
	// Shoot the bullet
	if(self:GetIronsights() == true) then
		self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone )
	else
		self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil + 3, self.Primary.NumShots, self.Primary.Cone + .05 )
	end
	
	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )
	
	// Punch the player's view

	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	
	
	// In singleplayer this doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
end