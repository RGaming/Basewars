if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "smg"	
end
// i just had to change a few things in it. it was TOO powerful.
if ( CLIENT ) then
	SWEP.PrintName			= "Sniper"			
	SWEP.Author				= "Rickster"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 7
	SWEP.IconLetter			= "r"

	killicon.AddFont( "ls_sniper", "CSKillIcons", "r", Color( 200, 200, 200, 255 ) )
end

SWEP.Base				= "ls_snip_base"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_snip_awp.mdl" 
SWEP.WorldModel			= "models/weapons/w_snip_awp.mdl" 

SWEP.Weight				= 3

SWEP.Primary.Sound			= Sound( "Weapon_AWP.Single" ) // "Weapon_M4A1.Silenced"
SWEP.Primary.Damage			= 55
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0001
SWEP.Primary.UnscopedCone	= 0.1
SWEP.Primary.ClipSize		= 5
SWEP.Primary.Delay			= 1.5
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "SniperRound"

SWEP.IronSightsPos 		= Vector( 0, 0, -15 ) -- this is just to make it disappear so it doesn't show up whilst scoped

function SWEP:Upgrade(bool)
	self.Weapon:SetNWBool("upgraded",bool)
end

// sniper upgrade = more damage when scoped

function SWEP:PrimaryAttack()
	
	
	self.Weapon:SetNextSecondaryFire( CurTime() )
	if self.Owner:GetNWBool("doubletapped") then
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay*drugeffect_doubletapmod )
	else
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	end
	
	if ( !self:CanPrimaryAttack() ) then return end
	
	// Play shoot sound
	self.Weapon:EmitSound( self.Primary.Sound )
	local rcone = self.Primary.Cone
	if (self.Owner:GetNWBool("focused")) then
		rcone = rcone*0.5
	end
	local rcone2 = self.Primary.UnscopedCone
	if (self.Owner:GetNWBool("focused")) then
		rcone2 = rcone2*0.5
	end
	// Shoot the bullet
	if( self.Owner:GetNetworkedInt( "ScopeLevel", 0 ) > 0 ) then 
		if (self.Weapon:GetNWBool("upgraded")) then
			self:CSShootBullet( 70, self.Primary.Recoil, self.Primary.NumShots, rcone )
		else
			self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, rcone )
		end
	else
		self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, rcone2 )	
	end
	
	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )
	
	// Punch the player's view
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	
	// In singleplayer this function doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
	--self.Owner:SetNetworkedInt( "ScopeLevel", 0 )
	
	--if(SERVER) then
	--	self.Owner:SetFOV( 0, 0 )
	--end	
	
	--self:SetIronsights( false )
	
end