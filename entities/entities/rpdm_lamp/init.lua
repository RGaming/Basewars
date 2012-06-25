
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local MODEL = Model( "models/props_wasteland/prison_lamp001c.mdl" )

AccessorFunc( ENT, "Texture", "FlashlightTexture" )

ENT:SetFlashlightTexture( "effects/flashlight001" )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()


	local ply = self.Owner
	ply:GetTable().maxlamp=ply:GetTable().maxlamp + 1
	self.User = self.Owner
	self:SetModel( MODEL )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	local phys = self:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:Toggle()
	
end


/*---------------------------------------------------------
   Name: Sets the color of the light
---------------------------------------------------------*/
function ENT:SetLightColor( r, g, b )

	self:SetVar( "lightr", r )
	self:SetVar( "lightg", g )
	self:SetVar( "lightb", b )
	
	self:SetColor( r, g, b, 255 )
	
	self.m_strLightColor = Format( "%i %i %i", r, g, b )
	
	if ( self.flashlight ) then
		self.flashlight:SetKeyValue( "lightcolor", self.m_strLightColor )
	end

end

/*---------------------------------------------------------
   Name: Sets the texture
---------------------------------------------------------*/
function ENT:SetFlashlightTexture( tex )

	self.Texture = tex
	
	if ( self.flashlight ) then
		self.flashlight:Input( "SpotlightTexture", NULL, NULL, self:GetFlashlightTexture() )
	end
	
end

/*---------------------------------------------------------
   Name: OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
end


/*---------------------------------------------------------
   Name: Use
---------------------------------------------------------*/
function ENT:Use( activator, caller )

end

/*---------------------------------------------------------
   Name: Toggle
---------------------------------------------------------*/
function ENT:Toggle()

	if ( self.flashlight ) then
	
		SafeRemoveEntity( self.flashlight )
		self.flashlight = nil
		self:SetOn( false )
		return
	
	end

	self:SetOn( true )
	
	local angForward = self:GetAngles() + Angle( 90, 0, 0 )
	
	self.flashlight = ents.Create( "env_projectedtexture" )
	
		self.flashlight:SetParent( self.Entity )
		
		// The local positions are the offsets from parent..
		self.flashlight:SetLocalPos( Vector( 0, 0, 0 ) )
		self.flashlight:SetLocalAngles( Angle(90,90,90) )
		
		// Looks like only one flashlight can have shadows enabled!
		self.flashlight:SetKeyValue( "enableshadows", 1 )
		self.flashlight:SetKeyValue( "farz", 2048 )
		self.flashlight:SetKeyValue( "nearz", 8 )
		
		//Todo: Make this tweakable?
		self.flashlight:SetKeyValue( "lightfov", 50 )
		
		// Color.. Bright pink if none defined to alert us to error
		self.flashlight:SetKeyValue( "lightcolor", self.m_strLightColor or "255 255 255" )
		
		
	self.flashlight:Spawn()
	
	self.flashlight:Input( "SpotlightTexture", NULL, NULL, self:GetFlashlightTexture() )

end


