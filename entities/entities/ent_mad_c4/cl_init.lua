include("shared.lua")

language.Add("ent_mad_c4", "Explosive C4")

/*---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------*/
function ENT:Draw()

	self.Entity:DrawModel()

	local FixAngles = self.Entity:GetAngles()
	local FixRotation = Vector(0, 270, 0)

	FixAngles:RotateAroundAxis(FixAngles:Right(), FixRotation.x)
	FixAngles:RotateAroundAxis(FixAngles:Up(), FixRotation.y)
	FixAngles:RotateAroundAxis(FixAngles:Forward(), FixRotation.z)

 	local TargetPos = self.Entity:GetPos() + (self.Entity:GetUp() * 9)

	local m, s = self:FormatTime(self.C4CountDown)

	self.Text = string.format("%02d", m) .. ":" .. string.format("%02d", s)

	cam.Start3D2D(TargetPos, FixAngles, 0.15)
		draw.SimpleText(self.Text, "Default", 31, -22, Color(255, 0, 0, 255), 1, 1)
	cam.End3D2D() 
end

/*---------------------------------------------------------
   Name: ENT:FormatTime()
---------------------------------------------------------*/
function ENT:FormatTime(seconds)

	local m = seconds % 604800 % 86400 % 3600 / 60
	local s = seconds % 604800 % 86400 % 3600 % 60

	return math.floor(m), math.floor(s)
end