

--Initializes the effect. The data is a table of data 
--which was passed from the server.
function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 6

	local emitter = ParticleEmitter( Pos )
	
	--firecloud
		for i=1, 16 do
		
			local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Vector(math.random(-20,20),math.random(-20,20),math.random(-30,50)))

				particle:SetVelocity( Vector(math.random(-30,30),math.random(-30,30),math.random(90,120)) )
				particle:SetDieTime( math.Rand( 1.6, 1.8 ) )
				particle:SetStartAlpha( math.Rand( 200, 240 ) )
				particle:SetStartSize( 16 )
				particle:SetEndSize( math.Rand( 48, 64 ) )
				particle:SetRoll( math.Rand( 360, 480 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
				particle:VelocityDecay( false )
				
			end
		
	--smoke cloud
		for i=1, 18 do
		
		local particle = emitter:Add( "particles/smokey", Pos + Vector(math.random(-25,25),math.random(-25,25),math.random(-30,70)))

			particle:SetVelocity( Vector(math.random(-30,30),math.random(-30,30),math.random(35,50)) )
			particle:SetDieTime( math.Rand( 2.4, 2.9 ) )
			particle:SetStartAlpha( math.Rand( 160, 200 ) )
			particle:SetStartSize( 24 )
			particle:SetEndSize( math.Rand( 32, 48 ) )
			particle:SetRoll( math.Rand( 360, 480 ) )
			particle:SetRollDelta( math.Rand( -1, 1 ) )
			particle:SetColor( 20, 20, 20 )
			particle:VelocityDecay( false )
			
		end
			
	emitter:Finish()
	
end

--THINK
-- Returning false makes the entity die
function EFFECT:Think( )
	-- Die instantly
	return false	
end

-- Draw the effect
function EFFECT:Render()
	-- Do nothing - this effect is only used to spawn the particles in Init	
end



