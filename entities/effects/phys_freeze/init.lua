
local effects_freeze = CreateClientConVar( "effects_freeze", "1", true, false )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	if ( effects_freeze:GetBool() == false ) then return end
	
	local vOffset = data:GetOrigin()
	
	local emitter = ParticleEmitter( vOffset )
	
		local particle = emitter:Add( "effects/freeze_unfreeze", vOffset )
		if (particle) then
			
			particle:SetDieTime( 0.5 )
			
			particle:SetStartAlpha( 0 )
			particle:SetEndAlpha( 255 )
			
			particle:SetStartSize( 16 )
			particle:SetEndSize( 0 )
		
		end
	
end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	return false
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end
