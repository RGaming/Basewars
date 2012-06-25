
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	local vOffset = data:GetOrigin()
	local NumParticles = 256
	local Force = 1000
	local StartColor = data:GetStart()
	local EndColor = data:GetAngle()
	local LifeTime = data:GetMagnitude()
	local DieTime = data:GetScale()
	WorldSound( "fireworks/firework_explosion_"..math.random(1, 3)..".wav", vOffset, 160, 130 )
	
	
	
		local Particles = {}
		local emitter = ParticleEmitter( vOffset , false)
	
		for i=0, NumParticles do
		
			local particle = emitter:Add( "sprites/gmdm_pickups/light", vOffset)
			local particle2 = emitter:Add( "sprites/gmdm_pickups/light", vOffset)
			
			if (particle && particle2) then
				
				local vec = VectorRand():GetNormal()*math.Rand(Force - 50, Force + 50)
				
				local life = math.Clamp(math.Rand(LifeTime - 5, LifeTime), 0.1, 50)
				
				particle:SetColor(StartColor.x, StartColor.y, StartColor.z)
				
				particle:SetVelocity( vec )
				
				particle:SetLifeTime( life )
				particle:SetDieTime( DieTime )
				
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 25 )
				
				particle:SetStartSize( 50 )
				particle:SetEndSize( 25 )
				
				particle:SetAirResistance( 50 )
				particle:SetGravity( Vector(0, 0, -200) )
				
				table.insert(Particles, particle)
				
				
				//TRAIL
				
				particle2:SetColor(255, 255, 255)
				
				particle2:SetVelocity(vec*0.99)
				
				particle2:SetLifeTime( life )
				particle2:SetDieTime( DieTime )
				
				particle2:SetStartAlpha( 255 )
				particle2:SetEndAlpha( 25 )
				
				particle2:SetStartSize( 50 )
				particle2:SetEndSize( 25 )
				
				particle2:SetAirResistance( 50 )
				particle2:SetGravity( Vector(0, 0, -200) )
				
			end
			
		end
		
	timer.Simple( 1, ChangeParticleCol, Particles, EndColor.p, EndColor.y, EndColor.r)
	emitter:Finish()

end

function ChangeParticleCol(particles, r, g, b)

	for k, v in pairs(particles) do
	
		v:SetColor(r, g, b)
	
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