
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

function ENT:Initialize()

local ent = self.Entity

	if not self.Flame then 		
		self.Flame = ents.Create("env_fire")
		local fire = self.Flame

		fire:SetKeyValue("StartDisabled","0")
		fire:SetKeyValue("health",math.random(29,31))
		fire:SetKeyValue("firesize",math.random(64,72))
		fire:SetKeyValue("fireattack","1")
		fire:SetKeyValue("ignitionpoint","0.3")
		fire:SetKeyValue("damagescale","35")
		fire:SetKeyValue("spawnflags",2 + 128)
		
		fire:SetPos(ent:GetPos())
		fire:SetOwner(ent:GetOwner())
		fire:Spawn()
		fire:Fire("Enable","","0")
		
		fire:DeleteOnRemove(ent)
	end

	ent:SetMoveType( MOVETYPE_NONE )
	ent:DrawShadow( false )

	-- Note that we need a physics object to make it call triggers
	ent:SetCollisionBounds( Vector( -20, -20, -10 ), Vector( 20, 20, 10 ) )
	ent:PhysicsInitBox( Vector( -20, -20, -10 ), Vector( 20, 20, 10 ) )
	
	local phys = ent:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableCollisions( false )		
	end

	ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	ent:SetTrigger( true )
	ent:SetNotSolid( true )
	
	--remove this ent after a few minutes
	ent:Fire("kill","","256")
	
end

function ENT:StartFire()
	
	local fire = self.Flame
	if not fire then return end
	
	if fire:WaterLevel() > 0 then return end
	
	--Enable our fire
	fire:Fire("StartFire","","0")
	fire:SetName("BurningFire") --So we can regognize that it's burning
	
	--Remove this entity- we don't need it anymore
	self.Entity:Remove()

end

function ENT:OnRemove()

end

function ENT:Touch(entity)

end

function ENT:OnTakeDamage(dmginfo)
	self:StartFire()
end

include('shared.lua')