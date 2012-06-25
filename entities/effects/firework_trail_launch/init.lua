
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	self.FWEnt = data:GetEntity()
	self.InitTime = CurTime()
	self.FuseTime = data:GetScale()
end

	
/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	if(self.FWEnt:IsValid()) then
	
		if(CurTime() < self.InitTime + self.FuseTime) then
		
			local Pos = self.FWEnt:GetPos() - self.FWEnt:GetUp()*-19
			
			if (Pos) then
				if(!self.Emitter) then self.Emitter = ParticleEmitter( Pos , false) end
				
					
				local particle = self.Emitter:Add( "particles/smokey", Pos)
				if (particle) then
				
					particle:SetVelocity( self.FWEnt:GetUp()*math.Rand( 10, 30 ) )
					particle:SetDieTime( 0.5 )
					particle:SetStartAlpha( math.Rand( 40, 60 ) )
					particle:SetStartSize( math.Rand( 0.5, 3 ) )
					particle:SetEndSize( math.Rand( 3, 5 ) )
					particle:SetRoll( math.Rand( -0.2, 0.2 ) )
					particle:SetColor( 255, 255, 255, 230)
					particle:SetGravity( Vector( 0, 0, -400 ) )
					
				end
				
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