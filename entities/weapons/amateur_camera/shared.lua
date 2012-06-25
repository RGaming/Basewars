if SERVER then
    --Make sure clients download this script.
    AddCSLuaFile("shared.lua")
end

SWEP.ViewModelFlip = false
SWEP.Category = "Cameras";
SWEP.Author = "Patrick Hunt [HunteR4708]";
SWEP.Contact = "Rawr!!";
SWEP.Purpose = "CAMERA!!!11";
SWEP.Instructions = "Just get it in your fucking hands and record something!";
SWEP.PrintName = "Amateur Camera";
SWEP.Slot = 5;
SWEP.SlotPos = 3;
SWEP.DrawCrosshair = false;
SWEP.DrawAmmo = false;
SWEP.ViewModel = "";
SWEP.WorldModel = "models/camera/camera.mdl";
SWEP.ViewModelFOV = 70;
SWEP.ReloadSound = "";
SWEP.HoldType = "rpg";
SWEP.Spawnable = true;
SWEP.AdminSpawnable = true;
SWEP.Weight = 5;
SWEP.AutoSwitchTo = false;
SWEP.AutoSwitchFrom = true;
SWEP.FiresUnderwater = true;

SWEP.Primary.Tracer = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "none";
SWEP.Primary.NumberofShots = 1;
SWEP.Primary.Delay = -1.0;
SWEP.Primary.TakeAmmo = 0;

SWEP.Secondary.Tracer = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Delay = -1.0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.TakeAmmo = 0;
SWEP.Secondary.Model = "";

function SWEP:Initialize()
		self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	self.Owner:ConCommand( "say Action!" )
end

function SWEP:SecondaryAttack()
	//This Camera has 3 zoom levels.
	if(ScopeLevel == 0) then
 
		if(SERVER) then
			self.Owner:SetFOV( 45, 0.4 )
 end

		ScopeLevel = 1
		//This is zoom level 1.
 
	else if(ScopeLevel == 1) then
 
		if(SERVER) then
			self.Owner:SetFOV( 25, 0.4 )
 end

		ScopeLevel = 2
		//This is zoom level 2.
 
	else
		//If the user is zoomed in all the way, reset their view.
		if(SERVER) then
			self.Owner:SetFOV( 0, 0.45 )
 end

		ScopeLevel = 0
		//There is no zoom.
 
	end
	end
 
end

function SWEP:Think()
	self.Owner:ViewPunch( Angle( math.Rand(-0.15,0.15), math.Rand(-0.15,0.15), math.Rand(-0.15,0.15)  ) )

	if self.Owner:KeyDown(IN_FORWARD) then
	self.Owner:ViewPunch( Angle( math.Rand(0,0.1), math.Rand(-0.4,0.4), 0 ) )
	if self.Owner:KeyDown(IN_SPEED) then
	self.Owner:ViewPunch( Angle( math.Rand(0,0.3), math.Rand(-0.4,0.4), math.Rand(-0.4,0.4) ) )
	end
	end

	if self.Owner:KeyDown(IN_MOVELEFT) then
	self.Owner:ViewPunch( Angle( math.Rand(0,0.1), math.Rand(-0.4,0.4), 0 ) )
	if self.Owner:KeyDown(IN_SPEED) then
	self.Owner:ViewPunch( Angle( math.Rand(0,0.3), math.Rand(-0.4,0.4), math.Rand(-0.4,0.4) ) )
	end
	end

	if self.Owner:KeyDown(IN_MOVERIGHT) then
	self.Owner:ViewPunch( Angle( math.Rand(0,0.1), math.Rand(-0.4,0.4), 0 ) )
	if self.Owner:KeyDown(IN_SPEED) then
	self.Owner:ViewPunch( Angle( math.Rand(0,0.3), math.Rand(-0.4,0.4), math.Rand(-0.4,0.4) ) )
	end
	end

	if self.Owner:KeyDown(IN_MOVELEFT) then
	self.Owner:ViewPunch( Angle( math.Rand(-0.4,0.4), math.Rand(-0.4,0.4), 0 ) )
	if self.Owner:KeyDown(IN_SPEED) then
	self.Owner:ViewPunch( Angle( math.Rand(-0.5,0.5), math.Rand(-0.4,0.4), math.Rand(-0.4,0.4) ) )
	end
	end

	local cmd = self.Owner:GetCurrentCommand()
	
	self.LastThink = self.LastThink or 0
	local fDelta = (CurTime() - self.LastThink)
	self.LastThink = CurTime()

end

function SWEP:Reload()
if(SERVER) then
			self.Owner:SetFOV( 0, 0.3 )
		end
end

function SWEP:Deploy()
end

function SWEP:DoZoomThink( cmd, fDelta )
	if ( !self.Owner:KeyDown( IN_ATTACK2 ) ) then return end
	self.CameraZoom = math.Clamp( self.CameraZoom + cmd:GetMouseY() * 3 * fDelta, 0.1, 175 )
	self.Owner:SetFOV( self.CameraZoom, 0 )
end

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

	self.Owner:SetEyeAngles( Angle( angles.Pitch, angles.Yaw, 0 ) )
	
	self.LastAngles = angles
	
	if ( self.Roll != 0 ) then
		angles.Roll = self.Roll
	end
	
	return origin, angles, fov
	
end

function SWEP:HUDShouldDraw( name )

	if (name == "CHudWeaponSelection") then return true end
	
	return false;
	
end

function SWEP:Holster()
return true
end

function SWEP:OnRemove()
return true
end

function SWEP:OnRestore()
end

function SWEP:Precache()
end

function SWEP:OwnerChanged()
end
