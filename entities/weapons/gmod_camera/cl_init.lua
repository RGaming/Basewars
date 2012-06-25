
include('shared.lua')

SWEP.PrintName			= "#GMOD_Camera"			
SWEP.Slot				= 5
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
SWEP.WepSelectIcon		= surface.GetTextureID( "vgui/gmod_camera" )

// Don't draw the weapon info on the weapon selection thing
function SWEP:DrawHUD() end
function SWEP:PrintWeaponInfo( x, y, alpha ) end


function SWEP:HUDShouldDraw( name )

	// So we can change weapons
	if (name == "CHudWeaponSelection") then return true end
	
	return false;
	
end

/*---------------------------------------------------------
   Name: SWEP:FreezeMovement()
---------------------------------------------------------*/
function SWEP:FreezeMovement()

	if ( self.m_fFreezeMovement ) then
	
		if ( self.m_fFreezeMovement > RealTime() ) then return true end
	
		self.m_fFreezeMovement = nil
	
	end

	// Don't aim if we're holding the right mouse button
	if ( self.Owner:KeyDown( IN_ATTACK2 ) || self.Owner:KeyReleased( IN_ATTACK2 ) ) then return true end
	return false
	
end

/*---------------------------------------------------------
   Name: CalcView
   Allows override of the default view
---------------------------------------------------------*/
function SWEP:CalcView( ply, origin, angles, fov )

	if ( self.Roll != 0 ) then
		angles.Roll = self.Roll
	end

	if (!self.TrackEntity || !self.TrackEntity:IsValid()) then return origin, angles, fov end
	
	local AimPos = self.TrackEntity:GetPos()
	
	self.LastAngles = self.LastAngles or angles
	
	if ( self.TrackOffset ) then
	
		local Distance = AimPos:Distance( self.Owner:GetShootPos() )
	
		AimPos = AimPos + Vector(0,0,1) * self.TrackOffset.y * 256
		AimPos = AimPos + self.LastAngles:Right() * self.TrackOffset.x * 256
	
	end
	
	local AimNormal = AimPos - self.Owner:GetShootPos()
	AimNormal:Normalize()
	
	angles = AimNormal:Angle() //LerpAngle( 0.1, self.LastAngles, AimNormal:Angle() )

	// Setting the eye angles here makes it so the player is actually aiming in this direction
	// Rather than just making their screen render in this direction.
	self.Owner:SetEyeAngles( Angle( angles.Pitch, angles.Yaw, 0 ) )
	
	self.LastAngles = angles
	
	if ( self.Roll != 0 ) then
		angles.Roll = self.Roll
	end
	
	return origin, angles, fov
	
end

/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:DoRotateThink( cmd, fDelta )

	// Think isn't frame rate independant on the client.
	// It gets called more per frame in single player than multiplayer
	// So we will have to make it frame rate independant ourselves

		

	// Right held down
	if ( self.Owner:KeyDown( IN_ATTACK2 ) ) then

		self.Roll = self.Roll + cmd:GetMouseX() * 0.5 * fDelta
		
	end
	
	// Right released
	if ( self.Owner:KeyReleased( IN_ATTACK2 ) ) then

		// This stops the camera suddenly jumping when you release zoom
		self.m_fFreezeMovement = RealTime() + 0.1
		
	end

	// We are tracking an entity. Trace mouse movement for offsetting.
	if ( self.TrackEntity && self.TrackEntity != NULL && !self.Owner:KeyDown( IN_ATTACK2 ) ) then
	
		self.TrackOffset = self.TrackOffset or Vector(0,0,0)
		
		local cmd = self.Owner:GetCurrentCommand()
		self.TrackOffset.x = math.Clamp( self.TrackOffset.x + cmd:GetMouseX() * 0.005 * fDelta, -0.5, 0.5 )
		self.TrackOffset.y = math.Clamp( self.TrackOffset.y - cmd:GetMouseY() * 0.005 * fDelta, -0.5, 0.5 )
	
	end

	// If we're pressing use scan for an entity to track.
	if ( self.Owner:KeyDown( IN_USE ) && !self.TrackEntity ) then
	
		self.TrackEntity = self.Owner:GetEyeTrace().Entity
		if ( self.TrackEntity && !self.TrackEntity:IsValid() ) then
		
			self.TrackEntity = nil
			self.LastAngles = nil
			self.TrackOffset = nil
		
		end
	
	end
	
	// Released use. Stop tracking.
	if ( self.Owner:KeyReleased( IN_USE ) ) then
	
		self.TrackEntity = nil
		self.LastAngles = nil
		self.TrackOffset = nil
	
	end
	
	// Reload isn't called on the client, so fire it off here.
	if ( self.Owner:KeyPressed( IN_RELOAD ) ) then
	
		self:Reload()
	
	end

end

/*---------------------------------------------------------
   Name: TranslateFOV
---------------------------------------------------------*/
function SWEP:TranslateFOV( current_fov )
	
	return self.CameraZoom

end


/*---------------------------------------------------------
   Name: AdjustMouseSensitivity()
   Desc: Allows you to adjust the mouse sensitivity.
---------------------------------------------------------*/
function SWEP:AdjustMouseSensitivity()

	if ( self.Owner:KeyDown( IN_ATTACK2 )  ) then return 1 end

	return 1 * ( self.CameraZoom / 80 )
	
end
