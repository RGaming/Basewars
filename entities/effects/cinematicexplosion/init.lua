
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
	
function EFFECT:Init( data )
	self.Refract = 0
	self.Size = 8
	self.Entity:SetRenderBounds( Vector()*-512, Vector()*512 )
	
	local vOffset = data:GetOrigin()
	local vNorm = data:GetStart()
	local NumParticles = 8
	WorldSound( "ambient/explosions/explode_9.wav", vOffset, 130, 130 )
	local emitter = ParticleEmitter( vOffset )
	
		shockwave = emitter:Add( "effects/yellowflare", vOffset )
		if (shockwave) then
			
			shockwave:SetLifeTime( 0 )
			shockwave:SetDieTime( 0.15 )
			
			shockwave:SetStartAlpha( 255 )
			shockwave:SetEndAlpha( 0 )
			
			shockwave:SetStartSize( 100 )
			shockwave:SetEndSize( 15000 )
			
			shockwave:SetColor(255,255,255)
			
		end
	
		for i=0, 64 do
			shockwave2 = emitter:Add( "particles/smokey", vOffset )
			if (shockwave2) then
				local Vec = vNorm + VectorRand()
				shockwave2:SetVelocity( Vector(Vec.x, Vec.y, 0) * 1200)
				shockwave2:SetLifeTime( 0 )
				shockwave2:SetDieTime( 0.5 )
				
				shockwave2:SetStartAlpha( 200 )
				shockwave2:SetEndAlpha( 0 )
				
				shockwave2:SetStartSize( 300 )
				shockwave2:SetEndSize( 350 )
				
				shockwave2:SetColor(50,50,50)
				shockwave2:SetAirResistance( 30 )
				
				shockwave2:SetGravity( Vector( 0, 0, 500 ) )
				
				shockwave2:SetCollide( true )
				shockwave2:SetBounce( 0.1 )
			end
		end
		
		for i=0, NumParticles do
		
			particle = emitter:Add( "effects/yellowflare", vOffset )
			if (particle) then
				
				local Vec = vNorm + VectorRand()
				particle:SetVelocity( Vector(Vec.x, Vec.y, math.Rand(0.5,2.2)) * 1200)
				
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 1.2 )
				
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				
				particle:SetStartSize( 30 )
				particle:SetEndSize( 15 )
				
				particle:SetColor(255,255,255)
				
				//particle:SetRoll( math.Rand(0, 360) )
				//particle:SetRollDelta( math.Rand(-200, 200) )
				
				particle:SetAirResistance( 100 )
				
				particle:SetGravity( Vector( 0, 0, -1000 ) )
				
				particle:SetCollide( true )
				particle:SetBounce( 0.5 )
				particle:SetThinkFunction(ParticleThink)
				particle:SetNextThink(CurTime() + 0.1)
			
			end
			
			particle2 = emitter:Add( "particles/smokey", vOffset )
			if (particle2) then
				
				local Vec2 = VectorRand()
				particle2:SetVelocity( Vector(Vec2.x, Vec2.y, math.Rand(0.1,1.5)) * 1200)
				
				particle2:SetLifeTime( 0 )
				particle2:SetDieTime( 6 )
				
				particle2:SetStartAlpha( 250 )
				particle2:SetEndAlpha( 0 )
				
				particle2:SetStartSize( 150 )
				particle2:SetEndSize( 200 )
				
				particle2:SetColor(150,150,140)
				
				//particle2:SetRoll( math.Rand(0, 360) )
				//particle2:SetRollDelta( math.Rand(-200, 200) )
				
				particle2:SetAirResistance( 250 )
				
				particle2:SetGravity( Vector( 100, 100, -80 ) )
				
				particle2:SetLighting( true )
				particle2:SetCollide( true )
				particle2:SetBounce( 0.5 )
			
			end
			
			particle3 = emitter:Add( "effects/fire_cloud2", vOffset )
			if (particle3) then
				
				local Vec3 = VectorRand()
				particle3:SetVelocity( Vector(Vec3.x, Vec3.y, math.Rand(0.1,2)) * 500)
					
				particle3:SetLifeTime( 0 )
				particle3:SetDieTime( 2 )
				
				particle3:SetStartAlpha( 50 )
				particle3:SetEndAlpha( 0 )
					
				particle3:SetStartSize( 150 )
				particle3:SetEndSize( 120 )
				
				particle3:SetColor(150,100,100)		
				
				particle3:SetRoll( math.Rand(0, 360) )
				particle3:SetRollDelta( math.Rand(-2, 2) )
					
				particle3:SetAirResistance( 150 )
				
				particle3:SetGravity( Vector( math.Rand(-200,200), math.Rand(-200,200), math.Rand(350,500) ) )					
				particle3:SetCollide( true )
				particle3:SetBounce( 1 )
				
			end
			
			particle4 = emitter:Add( "particles/smokey", vOffset )
			if (particle4) then
				
				local Vec4 = VectorRand()
				particle4:SetVelocity( Vector(Vec4.x, Vec4.y, math.Rand(0.01,1.3)) * 800)
					
				particle4:SetLifeTime( 0 )
				particle4:SetDieTime( 2 )
				
				particle4:SetStartAlpha( 255 )
				particle4:SetEndAlpha( 0 )
					
				particle4:SetStartSize( 200 )
				particle4:SetEndSize( 120 )
				
				particle4:SetColor(0,0,0)		
				
				particle4:SetRoll( math.Rand(0, 360) )
				particle4:SetRollDelta( math.Rand(-2, 2) )
					
				particle4:SetAirResistance( 150 )
				
				particle4:SetGravity( Vector( math.Rand(-200,200), math.Rand(-200,200), math.Rand(300,500) ) )					
				particle4:SetCollide( true )
				particle4:SetBounce( 1 )
			
			end
			
		end
		
	emitter:Finish()
end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	self.Refract = self.Refract + 2.0 * FrameTime()
	self.Size = 512 * self.Refract^(0.2)
	
	if ( self.Refract >= 1 ) then return false end
	
	return true
end

function ParticleThink( part )

	if part:GetLifeTime() > 0.18 && part:GetLifeTime() < 1 then 
		local vOffset = part:GetPos()	
		local emitter = ParticleEmitter( vOffset )
	
		if emitter == nil then return end
		local particle = emitter:Add( "particles/smokey", vOffset + Vector( math.Rand(-20,20),math.Rand(-20,20),math.Rand(-15,15) ) )
		
		if (particle) then
		
			particle:SetLifeTime( 1 )
			particle:SetDieTime( 5 - part:GetLifeTime() * 2 )
				
			particle:SetStartAlpha( 150 )
			particle:SetEndAlpha( 0 )
				
			particle:SetStartSize( ((100 + math.Rand(0,10)) - (part:GetLifeTime() * 100)) )
			particle:SetEndSize( ((120 + math.Rand(0,10)) - (part:GetLifeTime() * 100)) )
			local Dark = math.Rand(0,230)
			particle:SetColor(230 - Dark,230 - Dark,230 - Dark)
				
			particle:SetRoll( math.Rand(-0.5, 0.5) )
			particle:SetRollDelta( math.Rand(-1, 1) )
				
			particle:SetAirResistance( 250 )
				
			particle:SetGravity( Vector( 200, 200, -100 ) )
				
			particle:SetLighting( true )
			particle:SetCollide( true )
			particle:SetBounce( 0.5 )

		end		
		emitter:Finish()
	end
	
	part:SetNextThink( CurTime() + 0.1 )
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end
