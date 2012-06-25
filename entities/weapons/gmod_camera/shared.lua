
// Variables that are used on both client and server

SWEP.Author		= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_camphone.mdl"

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.ShootSound				= "NPC_CScanner.TakePhoto"

SWEP.CameraZoom				= 80
SWEP.Roll					= 0

/*---------------------------------------------------------
   Precache Stuff
---------------------------------------------------------*/
function SWEP:Precache()
	util.PrecacheSound( self.ShootSound )
end

/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()

	self.Owner:SetFOV( 80, 0 )
	self.CameraZoom = 80
	self.Roll = 0
		
end


/*---------------------------------------------------------
   The effect when a weapon is fired successfully
---------------------------------------------------------*/
function SWEP:DoShootEffect()

	self.Weapon:EmitSound( self.ShootSound	)
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
end

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	self:DoShootEffect()
	
	// If we're multiplayer this can be done totally clientside
	if (!SinglePlayer() && SERVER) then return end
	if (CLIENT && !IsFirstTimePredicted()) then return end
	
	self.Owner:ConCommand( "jpeg" )
	
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	// Nothing. See Think for zooming.
	
end

/*---------------------------------------------------------
   
---------------------------------------------------------*/
function SWEP:Think()

	local cmd = self.Owner:GetCurrentCommand()
	
	self.LastThink = self.LastThink or 0
	local fDelta = (CurTime() - self.LastThink)
	self.LastThink = CurTime()

	self:DoZoomThink( cmd, fDelta )
	self:DoRotateThink( cmd, fDelta )

end


/*---------------------------------------------------------
   
---------------------------------------------------------*/
function SWEP:DoZoomThink( cmd, fDelta )

	// Right held down
	if ( !self.Owner:KeyDown( IN_ATTACK2 ) ) then return end
	
	self.CameraZoom = math.Clamp( self.CameraZoom + cmd:GetMouseY() * 3 * fDelta, 0.1, 175 )
	
	self.Owner:SetFOV( self.CameraZoom, 0 )

end

