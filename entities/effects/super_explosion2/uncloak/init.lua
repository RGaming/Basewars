-- simple unloack effect :/

--Initializes the effect. The data is a table of data 
--which was passed from the server.
function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 6

	local emitter = ParticleEmitter( Pos )
	
		for i=1,math.random(15,25) do
		
			local particle = emitter:Add( "particles/smokey", Pos + Vector(0,0,math.random(0,100)))

				particle:SetVelocity(Vector(math.random(-30,30),math.random(-30,30), math.random(-5, 50)))
				particle:SetDieTime(math.Rand( 2.5, 5 ))
				particle:SetStartAlpha(150)
				particle:SetStartSize( math.random(15, 40) )
				particle:SetEndSize( math.random(40, 55) )
				particle:SetRoll( math.Rand( 360, 480 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( 255, 255, 255 )
				particle:VelocityDecay( false )
			end

	emitter:Finish()
		end


function EFFECT:Think( )
	return true	
end

-- Draw the effect
function EFFECT:Render()
	-- Do nothing - this effect is only used to spawn the particles in Init	
end



