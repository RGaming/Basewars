
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local vOffset = data:GetOrigin()
	local Color = data:GetStart()
	local ply = data:GetEntity()
	
	local Low = vOffset + ply:OBBMins()
	local High = vOffset + ply:OBBMaxs()
	
	local NumParticles = 1
	
	local emitter = ParticleEmitter( vOffset, true )
	
		local Pos = Vector( math.Rand(-5,5), math.Rand(-5,5), math.Rand(0,10) )
		
		local particle = emitter:Add( "sprites/light_glow02_add", vOffset + Pos * 8 )
		//sprites/vortex_particle
		if (particle) then
			
			particle:SetVelocity( Pos * 1 )
			
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 2 )
			
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 150 )
			
			local Size = math.Rand( 7, 10 )
			particle:SetStartSize( Size )
			particle:SetEndSize( 3 )
			
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-2, 2) )
			
			particle:SetAirResistance( 400 )
			particle:SetGravity( Vector(0,0,1) )
			
			particle:SetColor( Color.r, Color.g, Color.b )
			
			particle:SetCollide( false )
			
			particle:SetAngleVelocity( Angle( math.random(-1,1), math.random(-1,1), math.random(-1,1) ) ) 
			
			particle:SetBounce( 1 )
			particle:SetLighting( false )
				
		end
		
	emitter:Finish()
	
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
