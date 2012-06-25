include('shared.lua')

language.Add("ent_mad_grenade", "Grenade")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()

	self.OneTime = true
end

/*---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------*/
function ENT:Draw()

	self.Entity:DrawModel()
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()

	if self.Entity:WaterLevel() > 2 then return end

	if (self.Entity:GetDTBool(0)) then
		local light = DynamicLight(self:EntIndex())
		if (light) then
			light.Pos = self:GetPos()
			light.r = 255
			light.g = 115
			light.b = 40
			light.Brightness = 1
			light.Decay = math.random(500, 800) * 5
			light.Size = math.random(500, 800)
			light.DieTime = CurTime() + 1
		end
	end

	if (self.Entity:GetDTBool(0) and self.OneTime) then
		self:Smoke()
		self.OneTime = false
	end
end

/*---------------------------------------------------------
   Name: ENT:Smoke()
---------------------------------------------------------*/
function ENT:Smoke()

	local vPos = Vector(math.Rand(-5, 5), math.Rand(-5, 5), 0)
	local vOffset = self.Entity:LocalToWorld(Vector(0, 0, self.Entity:OBBMins().z))

	local emitter = ParticleEmitter(vOffset)
	
	for i = 1, 700 do 
		timer.Simple(i / 100, function()
			if not self.Entity or self.Entity:WaterLevel() > 2 then return end

			local vPos = Vector(math.Rand(-5, 5), math.Rand(-5, 5), 0)
			local vOffset = self.Entity:LocalToWorld(Vector(0, 0, self.Entity:OBBMins().z))

			local smoke = emitter:Add("particle/particle_smokegrenade", vOffset) // + vPos)
			smoke:SetVelocity(VectorRand() * 200)
			smoke:SetGravity(Vector(math.Rand(-10, 10), math.Rand(-10, 10), math.Rand(50, 150)))
			smoke:SetDieTime(5)
			smoke:SetStartAlpha(255)
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(0)
			smoke:SetEndSize(math.Rand(50, 200))
			smoke:SetRoll(math.Rand(-180, 180))
			smoke:SetRollDelta(math.Rand(-0.2,0.2))
			smoke:SetColor(25, 25, 25)
			smoke:SetAirResistance(math.Rand(25, 100))
			smoke:SetBounce(0.5)
			smoke:SetCollide(true)
		end)
	end

	emitter:Finish()
end

/*---------------------------------------------------------
   Name: ENT:IsTranslucent()
---------------------------------------------------------*/
function ENT:IsTranslucent()

	return true
end


