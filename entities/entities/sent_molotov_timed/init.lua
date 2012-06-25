/* *******************
Molotov Cocktail SENT
	        by
	    Pac_187
******************** */

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/props_junk/garbage_glassbottle003a.mdl")

	util.PrecacheSound( "explode_3" )

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.SpawnTime = CurTime()
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end
	

	local zfire = ents.Create( "env_fire_trail" )
		zfire:SetPos( self.Entity:GetPos() )
		zfire:SetParent( self.Entity )
		zfire:Spawn()
		zfire:Activate()
	
end

function ENT:Think() 

if self.SpawnTime + 5 < CurTime() then
	self:Boom()
end

end

function ENT:Explosion()
 	util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), math.random( 400, 500 ), math.random( 100, 150 ) )
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
    util.Effect( "Molotov_Explosion", effectdata )			 -- Explosion effect
	/*
	local explo = ents.Create( "env_explosion" )
		explo:SetOwner( self.Owner )
		explo:SetPos( self.Entity:GetPos() )
		explo:SetKeyValue( "iMagnitude", "50" )
		explo:SetKeyValue( "iRadiusOverride", "400" )
		explo:Spawn()
		explo:Activate()
		explo:Fire( "Explode", "", 0 )
	*/
	
	local shake = ents.Create( "env_shake" )
		shake:SetOwner( self.Owner )
		shake:SetPos( self.Entity:GetPos() )
		shake:SetKeyValue( "amplitude", "1000" )	-- Power of the shake
		shake:SetKeyValue( "radius", "1000" )	-- Radius of the shake
		shake:SetKeyValue( "duration", "3" )	-- Time of shake
		shake:SetKeyValue( "frequency", "255" )	-- How har should the screenshake be
		shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
		shake:Spawn()
		shake:Activate()
		shake:Fire( "StartShake", "", 0 )
	
	local physExplo = ents.Create( "env_physexplosion" )
	    physExplo:SetOwner( self.Owner )
        physExplo:SetPos( self.Entity:GetPos() )
        physExplo:SetKeyValue( "Magnitude", "500" )	-- Power of the Physicsexplosion
        physExplo:SetKeyValue( "radius", "450" )	-- Radius of the explosion
        physExplo:SetKeyValue( "spawnflags", "19" )
        physExplo:Spawn()
        physExplo:Fire( "Explode", "", 0.02 )
	
	local ar2Explo = ents.Create( "env_ar2explosion" )
		ar2Explo:SetOwner( self.Owner )
		ar2Explo:SetPos( self.Entity:GetPos() )
		ar2Explo:SetKeyValue( "material", "effects/muzzleflash"..math.random( 1, 4 ) )
		ar2Explo:Spawn()
		ar2Explo:Activate()
		ar2Explo:Fire( "Explode", "", 0 )
	

	for i=1, 25 do
		local fire = ents.Create( "env_fire" )
			fire:SetPos( self.Entity:GetPos() + Vector( math.random( -300, 300 ), math.random( -300, 300 ), 0 ) )
			fire:SetKeyValue( "health", math.random( 10, 15 ) )
			fire:SetKeyValue( "firesize", "128" )
			fire:SetKeyValue( "fireattack", "4" )
			fire:SetKeyValue( "damagescale", "2.0" )
			fire:SetKeyValue( "StartDisabled", "0" )
			fire:SetKeyValue( "firetype", "0" )
			fire:SetKeyValue( "spawnflags", "132" )
			fire:Spawn()
			fire:Fire( "StartFire", "", 1.5 )
	end
	
	for i=1, 16 do
		local sparks = ents.Create( "env_spark" )
			sparks:SetPos( self.Entity:GetPos() + Vector( math.random( -150, 150 ), math.random( -150, 150 ), math.random( -150, 200 ) ) )
			sparks:SetKeyValue( "MaxDelay", "0" )
			sparks:SetKeyValue( "Magnitude", "2" )
			sparks:SetKeyValue( "TrailLength", "3" )
			sparks:SetKeyValue( "spawnflags", "0" )
			sparks:Spawn()
			sparks:Fire( "SparkOnce", "", 0 )
	end	
	
	for k, v in pairs ( ents.FindInSphere( self.Entity:GetPos(), 350 ) ) do
		if v:IsValid() and v:IsPlayer() then return end
		v:Ignite( 10, 0 )
	end
	
end

function ENT:Boom()
	self.Entity:EmitSound( "explode_3" )
	self:Explosion()
	self.Entity:Remove()
end


