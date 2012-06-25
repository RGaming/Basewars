function EFFECT:Init(data)

	self.RemoveTime = (CurTime() + 1.5);
	
	local rnd = (VectorRand() * math.Rand(-20, 20));
	rnd.z = 0;
	local pos = (data:GetOrigin() + Vector(0, 0, 4) + rnd);
	local vel = data:GetStart();
	local num = data:GetAngle();
	local nummin, nummax = num.p, num.y;
	local size = data:GetScale();
	local norm = data:GetNormal();
	local push = data:GetMagnitude();
	local em = ParticleEmitter(pos);
	
	for i = 1, math.random(nummin, nummax) do
		local part = em:Add("particles/smokey", pos);
		local size = math.Rand((size * .5), size);
		if (part) then
			part:SetColor(255, 255, 255, 255);
			local fan = (push * .1);
			part:SetVelocity(((vel * push) + (VectorRand() * (norm.x * .1))));
			part:SetDieTime(math.Rand(.5, 1.5));
			part:SetLifeTime(0);
			part:SetStartSize(size * 5);
			part:SetEndSize((size * 2.5));
			part:SetStartAlpha((math.random(85, 150) - (math.random(75, 80) * (1.01 - size))));
			part:SetEndAlpha(0);
			part:SetBounce(0);
			part:SetCollide(false);
			part:SetGravity(Vector(0, 0, (10 * (nummin * .5))));
			part:SetAirResistance(50);
			part:SetAngleVelocity(Angle(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1)));
			part:SetLighting(false);
		end
	end
	em:Finish();
end

function EFFECT:Think()
	if (CurTime() >= self.RemoveTime) then
		return true;
	end	
end


function EFFECT:Render()
end
