
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	self.FWEnt = data:GetEntity()
	local vOffset = data:GetOrigin()
	
	if(vOffset) then WorldSound( "fireworks/firework_launch_"..math.random(1, 2)..".wav", vOffset, 160, 130 ) end
end

	
/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	if(self.FWEnt:IsValid()) then
		local Pos = self.FWEnt:GetPos() - self.FWEnt:GetUp()*-19
		
		if (Pos) then
			if(!self.Emitter) then self.Emitter = ParticleEmitter( Pos , false) end
			
				
			local particle = self.Emitter:Add( "particles/smokey", Pos)
			local particle2 = self.Emitter:Add( "effects/spark", Pos )
			if (particle && particle2) then
			
				particle:SetVelocity( self.FWEnt:GetUp()*math.Rand( 10, 30 ) )
				particle:SetDieTime( 0.5 )
				particle:SetStartAlpha( math.Rand( 50, 80 ) )
				particle:SetStartSize( math.Rand( 2, 5 ) )
				particle:SetEndSize( math.Rand( 5, 8 ) )
				particle:SetRoll( math.Rand( -0.2, 0.2 ) )
				particle:SetColor( 255, 255, 255, 240)
				particle:SetGravity( Vector( 0, 0, -400 ) )
				
				//P2
				   
				particle2:SetVelocity(VectorRand()*50)
				particle2:SetLifeTime( 0.5 )
				particle2:SetDieTime( math.Rand( 0.5, 1 ) )
				particle2:SetStartAlpha( math.Rand( 100, 125 ) )
				particle2:SetEndAlpha( 0 )
				particle2:SetStartSize( 2.5 )
				particle2:SetEndSize( 2 )
				particle2:SetRoll( math.Rand(0, 360) )
				particle2:SetRollDelta( 0 )
			   
				particle2:SetAirResistance( 100 )
				particle2:SetGravity( Vector( 0, 0, -700 ) )
			end
			
		end

	end	
	
	return true
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end