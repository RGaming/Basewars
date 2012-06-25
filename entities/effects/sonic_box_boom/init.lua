function EFFECT:Init(data)

	self.RemoveTime = (CurTime() + 1.5);
	
	local pos = (data:GetOrigin() - Vector(0, 0, 4));
	local em = ParticleEmitter(pos);
	
	local part = em:Add("particles/smokey", pos);
	if (part) then
		part:SetColor(255, 255, 255, 255);
		part:SetVelocity(Vector(0, 0, math.random(120, 140)));
		part:SetDieTime(math.Rand(.175, .35));
		part:SetLifeTime(0);
		part:SetStartSize(math.Rand(8, 12));
		part:SetEndSize(math.Rand(42, 48));
		part:SetStartAlpha(math.random(225, 255));
		part:SetEndAlpha(0);
		part:SetBounce(0);
		part:SetCollide(false);
		part:SetGravity(Vector(0, 0, 16));
		part:SetAirResistance(50);
		part:SetAngleVelocity(Angle(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1)));
		part:SetLighting(false);
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
