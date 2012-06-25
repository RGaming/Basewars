

function EFFECT:Init( data )
	
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	-- Keep the start and end pos - we're going to interpolate between them
	local Pos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	
	local Velocity 	= data:GetNormal()
	if ValidEntity(self.WeaponEnt) && ValidEntity(self.WeaponEnt:GetOwner()) then
		local AddVel = self.WeaponEnt:GetOwner():GetVelocity()*0.85
	end
	local jetlength = data:GetScale()
	
	local maxparticles1 = math.ceil(jetlength/71) + 1
	local maxparticles2 = math.ceil(jetlength/190)

	Pos = Pos + Velocity * 2
	
	local emitter = ParticleEmitter( Pos )
		
		for i=4, maxparticles1 do
		
			local particle = emitter:Add( "particles/smokey", Pos + Velocity * i * math.Rand(1.5,2.6) )
				local partvel = Velocity * math.Rand( jetlength/0.5, jetlength/0.6 ) + AddVel
				local partime = jetlength/partvel:Length()
				if partime > 0.85 then partime = 0.85 end
				particle:SetVelocity(partvel)
				particle:SetDieTime(partime)
				particle:SetStartAlpha( math.Rand( 10, 20 ) )
				particle:SetStartSize( 2 )
				particle:SetEndSize( math.Rand( 96, 128 ) )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( 145, math.Rand( 160, 200 ), 70 )
				particle:VelocityDecay( false )
			
		end
		
		for i=0, maxparticles2 do
		
			local particle = emitter:Add( "particles/smokey", Pos + Velocity * i * math.Rand(0.35,0.55))
				particle:SetVelocity(Velocity * math.Rand( 0.6*jetlength/0.3, 0.6*jetlength/0.4 ) + AddVel)
				particle:SetDieTime(math.Rand(0.3,0.4))
				particle:SetStartAlpha( 90 )
				particle:SetStartSize( 0.6*i )
				particle:SetEndSize( math.Rand( 24, 48 ) )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetRollDelta( math.Rand( -0.5, 0.5 ) )
				particle:SetColor( 135, math.Rand( 120, 140 ), 60 )
				particle:VelocityDecay( false )
			
		end

	emitter:Finish()
	
end

function EFFECT:Think( )

	-- Die instantly
	return false
	
end

function EFFECT:Render()

	-- Do nothing - this effect is only used to spawn the particles in Init
	
end



