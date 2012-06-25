include('shared.lua')

function ENT:Draw( bDontDrawModel )
	self.Entity:DrawModel()
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	
	local owner = self.Owner
	owner = (ValidEntity(owner) and owner:Nick()) or "unknown"
	local upgrade = self.Entity:GetNWInt("upgrade")
	
	surface.SetFont("HUDNumber5")
	local TextWidth = surface.GetTextSize("Silver Money Printer")
	local TextWidth2 = surface.GetTextSize("Level:"..upgrade)
	local TextWidth3 = surface.GetTextSize(owner) 

	Ang:RotateAroundAxis(Ang:Up(), 90)

	local Health = self:GetNWInt("damage") / 2
	local DamageColorScale = Color(0, 159, 107, 155)

		if Health < 50 then 
			DamageColorScale = Color(255, 205, 0, 155)
end
			if Health < 25 then 
			DamageColorScale = Color(180, 0, 0, 100)

end

	cam.Start3D2D(Pos + Ang:Up() * 8.5, Ang, 0.15)
		draw.WordBox(.75, -TextWidth*0.5, -70, "Silver Money Printer", "HUDNumber5", Color(230, 232, 250, 155), Color(255,255,255,255))
		draw.WordBox(.75, -TextWidth2*0.5, -24, "Level:"..upgrade, "HUDNumber5", Color(230, 232, 250, 155), Color(255,255,255,255))
		draw.RoundedBox(5, -TextWidth3*0.5 + 30, 22, math.Clamp(Health,0,100)*2, TextWidth2 * 0.3, DamageColorScale)
	cam.End3D2D()
end

--function ENT:Draw( )
--  
--
--	self.Entity:DrawModel()
--	
--	local Pos = self:GetPos()
--	local Ang = Angle( 0, 0, 0) -- self:GetAngles()
--	
--	local upgrade = self.Entity:GetNWInt("upgrade")
--	local owner = self.Owner
--	owner = (ValidEntity(owner) and owner:Nick()) or "Unknown"
--	
----	if ply:GetNWEntity( "drawmoneytitle" ) == true then
--	
--	surface.SetFont("HUDNumber5")
--	local TextWidth = surface.GetTextSize("Bronze Money Printer")
--	local TextWidth2 = surface.GetTextSize("Level:"..upgrade)
--	local TextWidth3 = surface.GetTextSize(owner) 
--	
--	Ang:RotateAroundAxis(Ang:Forward(), 90)
--	local TextAng = Ang
-----TextAng, LocalPlayer():GetPos():Distance(self:GetPos()) / 500
--	
--	TextAng:RotateAroundAxis(TextAng:Right(), CurTime() * -180)
--	local ply = LocalPlayer
--	cam.Start3D2D(Pos + Ang:Right() * -27, TextAng, 0.15)
--		draw.WordBox(.7, -TextWidth*0.5, -30, "Bronze Money Printer", "HUDNumber5", Color(140, 120, 83, 155), Color(255,255,255,255))
----		draw.WordBox(LocalPlayer():GetPos():Distance(self:GetPos())/2, -TextWidth3*0.5, 60, "Bronze Money Printer", "HUDNumber5", Color(0, 0, 0, 100), Color(255,255,255,255))
--		draw.WordBox(.7, -TextWidth2*0.5, 18, "Level:"..upgrade, "HUDNumber5", Color(140, 120, 83, 155), Color(255,255,255,255))
--		draw.WordBox(.7, -TextWidth3*0.5, 70, owner, "HUDNumber5", Color(140, 120, 83, 155), Color(255,255,255,255))
--	cam.End3D2D()
--end