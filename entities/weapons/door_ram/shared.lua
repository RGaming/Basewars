

if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if( CLIENT ) then

	SWEP.PrintName = "Battering Ram";
	SWEP.Slot = 5;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;

end

// Variables that are used on both client and server

SWEP.Author			= "Rickster"
SWEP.Instructions	= "Left click to break open doors"
SWEP.Contact		= ""
SWEP.Purpose		= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel = Model( "models/weapons/v_rpg.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_rocket_launcher.mdl" )
SWEP.AnimPrefix		= "rpg"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.Sound = Sound( "physics/wood/wood_box_impact_hard3.wav" );

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""



/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()

	if( SERVER ) then
	
		self:SetWeaponHoldType( "rpg" );
	
	end

end


/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end


/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	
	if( CLIENT ) then return; end

 	local trace = self.Owner:GetEyeTrace();

 	if( not trace.Entity:IsValid() or not trace.Entity:IsDoor() or self.Owner:EyePos():Distance( trace.Entity:GetPos() ) > 45 ) then
 		return;
	end
	
	self.Owner:EmitSound( self.Sound );
	
	trace.Entity:Fire( "unlock", "", .5 )
	trace.Entity:Fire( "open", "", .6 )
	
	self.Owner:ViewPunch( Angle( -10, math.random( -5, 5 ), 0 ) );
	self.Weapon:SetNextPrimaryFire( CurTime() + 2.5 );
	
end

function SWEP:ShouldDropOnDie()
	return true
end