

function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 2
	
	local emitter = ParticleEmitter( Pos )
	
	--big firecloud
		for i=1, 28 do
		
			local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Vector(math.random(-80,80),math.random(-80,80),math.random(0,70)))

				particle:SetVelocity( Vector(math.random(-160,160),math.random(-160,160),math.random(250,300)) )
				particle:SetDieTime( math.Rand( 3.4, 3.7 ) )
				particle:SetStartAlpha( math.Rand( 220, 240 ) )
				particle:SetStartSize( 48 )
				particle:SetEndSize( math.Rand( 160, 192 ) )
				particle:SetRoll( math.Rand( 360, 480 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
				particle:VelocityDecay( false )
			
			end
		
	--small firecloud
		for i=1, 20 do
		
			local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Vector(math.random(-40,40),math.random(-40,40),math.random(-30,20)))

				particle:SetVelocity( Vector(math.random(-120,120),math.random(-120,120),math.random(170,250)) )
				particle:SetDieTime( math.Rand( 3, 3.4 ) )
				particle:SetStartAlpha( math.Rand( 220, 240 ) )
				particle:SetStartSize( 32 )
				particle:SetEndSize( math.Rand( 128, 160 ) )
				particle:SetRoll( math.Rand( 360, 480 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
				particle:VelocityDecay( false )
				
			end
		
	--base explosion
		for i=1, 36 do
		
			local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Vector(math.random(-40,40),math.random(-40,40),math.random(10,70)))

				particle:SetVelocity( Vector(math.random(-300,300),math.random(-300,300),math.random(-20,180)) )
				particle:SetDieTime( math.Rand( 1.8, 2 ) )
				particle:SetStartAlpha( math.Rand( 220, 240 ) )
				particle:SetStartSize( 48 )
				particle:SetEndSize( math.Rand( 128, 160 ) )
				particle:SetRoll( math.Rand( 360,480 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
				particle:VelocityDecay( true )	
				
			end
		
	--smoke puff
		for i=1, 24 do
		
			local particle = emitter:Add( "particles/smokey", Pos + Vector(math.random(-40,40),math.random(-40,40),math.random(-30,10)))

			particle:SetVelocity( Vector(math.random(-280,280),math.random(-280,280),math.random(0,180)) )
			particle:SetDieTime( math.Rand( 1.9, 2.3 ) )
			particle:SetStartAlpha( math.Rand( 60, 80 ) )
			particle:SetStartSize( math.Rand( 32, 48 ) )
			particle:SetEndSize( math.Rand( 192, 256 ) )
			particle:SetRoll( math.Rand( 360, 480 ) )
			particle:SetRollDelta( math.Rand( -1, 1 ) )
			particle:SetColor( 170, 160, 160 )
			particle:VelocityDecay( false )
		
		end
		
	-- big smoke cloud
		for i=1, 24 do
		
			local particle = emitter:Add( "particles/smokey", Pos + Vector(math.random(-40,40),math.random(-40,50),math.random(20,80)))

			particle:SetVelocity( Vector(math.random(-180,180),math.random(-180,180),math.random(260,340)) )
			particle:SetDieTime( math.Rand( 3.5, 3.7 ) )
			particle:SetStartAlpha( math.Rand( 60, 80 ) )
			particle:SetStartSize( math.Rand( 32, 48 ) )
			particle:SetEndSize( math.Rand( 192, 256 ) )
			particle:SetRoll( math.Rand( 480, 540 ) )
			particle:SetRollDelta( math.Rand( -1, 1 ) )
			particle:SetColor( 170, 170, 170 )
			particle:VelocityDecay( false )
			
		end
		
		
		-- small smoke cloud
		for i=1, 18 do
		
			local particle = emitter:Add( "particles/smokey", Pos + Vector(math.random(-40,40),math.random(-40,40),math.random(-30,60)))

			particle:SetVelocity( Vector(math.random(-200,200),math.random(-200,200),math.random(120,200)) )
			particle:SetDieTime( math.Rand( 3.1, 3.4 ) )
			particle:SetStartAlpha( math.Rand( 60, 80 ) )
			particle:SetStartSize( math.Rand( 32, 48 ) )
			particle:SetEndSize( math.Rand( 192, 256 ) )
			particle:SetRoll( math.Rand( 480, 540 ) )
			particle:SetRollDelta( math.Rand( -1, 1 ) )
			particle:SetColor( 170, 170, 170 )
			particle:VelocityDecay( false )
			
		end
			
	emitter:Finish()
	
end


function EFFECT:Think( )
	return false	
end


function EFFECT:Render()
	-- Do nothing - this effect is only used to spawn the particles in Init
end



