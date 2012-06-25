
local effects_unfreeze = CreateClientConVar( "effects_unfreeze", "1", true, false )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	if ( effects_unfreeze:GetBool() == false ) then return end
	
	local vOffset = data:GetOrigin()
	
	local emitter = ParticleEmitter( vOffset )
	
		local particle = emitter:Add( "effects/freeze_unfreeze", vOffset )
		if (particle) then
			
			particle:SetDieTime( 0.5 )
			
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			
			particle:SetStartSize( 0 )
			particle:SetEndSize( 16 )
		
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
