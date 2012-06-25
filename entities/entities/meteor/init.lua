AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Size = math.random(0,2)
	if self.Size==2 then
		self.Entity:SetModel("models/props/cs_militia/militiarock02.mdl")
	elseif self.Size==1 then
		self.Entity:SetModel("models/props/cs_militia/militiarock05.mdl")
	else
		self.Entity:SetModel( "models/props_junk/Rock001a.mdl" )
	end
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:Ignite(20,0)

	local phys = self.Entity:GetPhysicsObject()
	phys:EnableMotion(true) 
	phys:SetMass( 1000 )
	phys:EnableGravity( false)
	phys:Wake()
	self.DidHit = false
	self.SpawnTime = CurTime()
end

function ENT:SetTarget(ent)
 
	local foundSky = util.IsInWorld( ent:GetPos() )
	local zPos = ent:GetPos().z
	for a = 1, 50, 1 do
		zPos = zPos + 300
		foundSky = util.IsInWorld(Vector(ent:GetPos( ).x ,ent:GetPos( ).y ,zPos))
		if(foundSky == false) then
			zPos = zPos - 420
			break
		end
	end
	
	local spawnpos = Vector(ent:GetPos( ).x + math.random( -4000,4000 ),ent:GetPos( ).y + math.random( -4000,4000 ), zPos)
	for i=1,20,1 do
		if !util.IsInWorld(spawnpos) then
			spawnpos = Vector(ent:GetPos( ).x + math.random( -4000,4000 ),ent:GetPos( ).y + math.random( -4000,4000 ), zPos)
			local trace = {}
				trace.start = spawnpos
				trace.endpos = spawnpos+Vector(0,0,4096)
				trace.filter = {self.Entity, ent}
				trace.mask = COLLISION_GROUP_PLAYER
			tracer = util.TraceLine(trace)
			if tracer.HitSky || !tracer.Hit then
				break
			end
		end
		if i==20 && !util.IsInWorld(spawnpos) then
			spawnpos = Vector(ent:GetPos( ).x,ent:GetPos( ).y, zPos)
			local trace = {}
				trace.start = spawnpos
				trace.endpos = spawnpos+Vector(0,0,4096)
				trace.filter = {self.Entity, ent}
				trace.mask = COLLISION_GROUP_PLAYER
			tracer = util.TraceLine(trace)
			if tracer.HitSky || !tracer.Hit then
				break
			else
				// if it cant find a valid point by now, then just fuck the whole thing.
				self.Entity:Remove()
			end
		end
	end
	
	self.Entity:SetPos(Vector(ent:GetPos( ).x + math.random( -4000,4000 ),ent:GetPos( ).y + math.random( -4000,4000 ), zPos))
	local speed = 999999999999
	local VNormal = (Vector(ent:GetPos().x + math.random( -500,500 ),ent:GetPos().y + math.random( -500,500 ),ent:GetPos().z) - self.Entity:GetPos()):GetNormal()
	self.TargetPos = VNormal*speed
	self.Entity:GetPhysicsObject():ApplyForceCenter(VNormal * speed)

end

function ENT:Destruct()

	util.BlastDamage( self.Entity, self.Entity, self.Entity:GetPos(), 384, 150) 
	
	local vPoint = self.Entity:GetPos()
	local effectdata = EffectData() 
		effectdata:SetStart( vPoint )
		effectdata:SetOrigin( vPoint ) 
		effectdata:SetScale( 10 ) 
	util.Effect( "Explosion", effectdata ) 
	
	for i=1,5,1 do
		// using random x and y would put it in a random pos within a square, which looks wierd.
		local ang = math.random(0,360)
		local dist = math.random(1,256)
		local xpos = (math.sin(ang)*dist)+self.Entity:GetPos().x
		local ypos = (math.cos(ang)*dist)+self.Entity:GetPos().y
		local zpos = self.Entity:GetPos().z+200
		local trace = {}
			trace.start = Vector(xpos,ypos,zpos)
			trace.endpos = Vector(xpos,ypos,zpos-2048)
			trace.filter = self.Entity
			trace.mask = COLLISION_GROUP_PLAYER
		tracer = util.TraceLine(trace)
		if util.IsInWorld(trace.start) && tracer.Hit && !tracer.HitSky then
			local fire = ents.Create("env_fire")
			fire:SetPos(self.Entity:GetPos())
			fire:SetPos(Vector(xpos,ypos,tracer.HitPos.z))
			fire:SetKeyValue("spawnflags", "184")
			fire:SetKeyValue("firesize", tostring(math.random(40,90)))
			fire:SetKeyValue("damagescale", "3")
			fire:SetKeyValue("health", tostring(math.random(15,20)))
			fire:SetKeyValue("fireattack", tostring(math.Rand(0,2)+.5))
			fire:Spawn()
			fire:Fire("StartFire")
		end
	end
end

function ENT:BigBang()

	util.BlastDamage( self.Entity, self.Entity, self.Entity:GetPos(), 512, 250) 
	
	for i=1,5,1 do
		local ang = math.random(0,360)
		local dist = math.random(1,512)
		local xpos = (math.sin(ang)*dist)+self.Entity:GetPos().x
		local ypos = (math.cos(ang)*dist)+self.Entity:GetPos().y
		local zpos = self.Entity:GetPos().z+math.random(0,128)
		
		local vPoint2 = Vector(xpos,ypos,zpos)
		local effectdata = EffectData() 
			effectdata:SetStart( vPoint2 )
			effectdata:SetOrigin( vPoint2 ) 
			effectdata:SetScale( 10 ) 
		util.Effect( "Explosion", effectdata ) 
		
		local effectdata = EffectData() 
			effectdata:SetStart( vPoint2 )
			effectdata:SetOrigin( vPoint2 ) 
			effectdata:SetScale( 10 ) 
		util.Effect( "HelicopterMegaBomb", effectdata ) 
	end
	for i=1,10,1 do
		// using random x and y would put it in a random pos within a square, which looks wierd.
		local ang = math.random(0,360)
		local dist = math.random(1,512)
		local xpos = (math.sin(ang)*dist)+self.Entity:GetPos().x
		local ypos = (math.cos(ang)*dist)+self.Entity:GetPos().y
		local zpos = self.Entity:GetPos().z+200
		local trace = {}
			trace.start = Vector(xpos,ypos,zpos)
			trace.endpos = Vector(xpos,ypos,zpos-2048)
			trace.filter = self.Entity
			trace.mask = COLLISION_GROUP_PLAYER
		tracer = util.TraceLine(trace)
		if util.IsInWorld(trace.start) && tracer.Hit && !tracer.HitSky then
			local fire = ents.Create("env_fire")
			fire:SetPos(self.Entity:GetPos())
			fire:SetPos(Vector(xpos,ypos,tracer.HitPos.z))
			fire:SetKeyValue("spawnflags", "184")
			fire:SetKeyValue("firesize", tostring(math.random(70,150)))
			fire:SetKeyValue("damagescale", "5")
			fire:SetKeyValue("health", tostring(math.random(15,20)))
			fire:SetKeyValue("fireattack", tostring(math.Rand(0,2)+.5))
			fire:Spawn()
			fire:Fire("StartFire")
		end
	end
end

function ENT:Destruct2()
	
	util.BlastDamage( self.Entity, self.Entity, self.Entity:GetPos(), 200, 60)
	
	local vPoint = self.Entity:GetPos()
	local effectdata = EffectData() 
		effectdata:SetStart( vPoint )
		effectdata:SetOrigin( vPoint ) 
		effectdata:SetScale( 10 ) 
	util.Effect( "Explosion", effectdata ) 

end

function ENT:PhysicsCollide( data, physobj )
	self.DidHit = true
end
function ENT:PhysicsUpdate()
	self.Entity:GetPhysicsObject():SetVelocity(self.TargetPos * 6000)
	if self.DidHit then
		if CurTime()-self.SpawnTime<2 then
			self.Entity:Destruct2()
		elseif self.Size==2 then
			self.Entity:BigBang()
		elseif self.Size==1 then
			self.Entity:Destruct()
		else
			self.Entity:Destruct2()
		end
		self.Entity:Remove()
	end
end
function ENT:Think()
	
end
