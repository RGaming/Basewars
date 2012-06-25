

--[[---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------]]--
function EFFECT:Init( data )
	
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	-- Keep the start and end pos - we're going to interpolate between them
	local Pos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	
	local Velocity 	= data:GetNormal()
	local AddVel = Vector(0,0,0)
	if ValidEntity(self.WeaponEnt) && ValidEntity(self.WeaponEnt:GetOwner()) then
		local AddVel = self.WeaponEnt:GetOwner():GetVelocity()*0.5
	end
	local jetlength = data:GetScale()
	
	local maxparticles1 = math.ceil(jetlength/81) + 1
	local maxparticles2 = math.ceil(jetlength/190) + 1

	Pos = Pos + Velocity * 2
	
	local emitter = ParticleEmitter( Pos )
		
		for i=1, maxparticles1 do
		
			local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Velocity * i * math.Rand(1.6,3) )
				local randvel = Velocity + Vector(math.Rand(-0.04,0.04),math.Rand(-0.04,0.04),math.Rand(-0.04,0.04))
				local partvel = randvel * math.Rand( jetlength/0.7, jetlength/0.8 ) + AddVel
				local partime = jetlength/partvel:Length()
				if partime > 0.85 then partime = 0.85 end
				particle:SetVelocity(partvel)
				particle:SetDieTime(partime)
				particle:SetStartAlpha( math.Rand( 100, 150 ) )
				particle:SetStartSize( 1.7 )
				particle:SetEndSize( math.Rand( 72, 96 ) )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( math.Rand( 130, 230 ), math.Rand( 100, 160 ), 120 )
				particle:VelocityDecay( false )
			
		end
		
		for i=0, maxparticles2 do
		
			local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Velocity * i * math.Rand(0.3,0.6))
				particle:SetVelocity(Velocity * math.Rand( 0.42*jetlength/0.3, 0.42*jetlength/0.4 ) + AddVel)
				particle:SetDieTime(math.Rand(0.3,0.4))
				particle:SetStartAlpha( 255 )
				particle:SetStartSize( 0.6*i )
				particle:SetEndSize( math.Rand( 24, 32 ) )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetRollDelta( math.Rand( -0.5, 0.5 ) )
				particle:SetColor( 30, 15, math.Rand( 190, 225 ) )
				particle:VelocityDecay( false )
			
		end
		
		--[[for i=0, 2 do
		
			local particle = emitter:Add("sprites/heatwave", Pos + Velocity * i)

				particle:SetVelocity( Velocity * math.Rand( 800, 900 ) )
				particle:SetDieTime( math.Rand( 0.5, 0.6 ) )
				particle:SetStartAlpha( 250 )
				particle:SetStartSize( 2 )
				particle:SetEndSize( math.Rand( 64, 72 ) )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetRollDelta( math.Rand( -0.5, 0.5 ) )
				particle:SetColor( 255, 255, 255 )
				particle:VelocityDecay( false )
		end]]--

	emitter:Finish()
	
end


--[[---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------]]--
function EFFECT:Think( )

	-- Die instantly
	return false
	
end


--[[---------------------------------------------------------
   Draw the effect
---------------------------------------------------------]]--
function EFFECT:Render()

	-- Do nothing - this effect is only used to spawn the particles in Init
	
end



