include('shared.lua')

function ENT:Draw( )
  

	self.Entity:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = Angle( 0, 0, 0) -- self:GetAngles()
	
	local upgrade = self.Entity:GetNWInt("upgrade")
	local owner = self.Owner
	owner = (ValidEntity(owner) and owner:Nick()) or "Unknown"
	
--	if ply:GetNWEntity( "drawmoneytitle" ) == true then
	
	surface.SetFont("HUDNumber5")
	local TextWidth = surface.GetTextSize("Spawn Point")
--	local TextWidth2 = surface.GetTextSize(owner) 
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	local TextAng = Ang
---TextAng, LocalPlayer():GetPos():Distance(self:GetPos()) / 500
	
	TextAng:RotateAroundAxis(TextAng:Right(), CurTime() * -180)
	local ply = LocalPlayer
	cam.Start3D2D(Pos + Ang:Right() * -75, TextAng, 0.2)
--		draw.WordBox(.7, -TextWidth*0.5, -30, "Spawn Point", "HUDNumber5", Color(0, 0, 0, 155), Color(255,255,255,255))
--		draw.WordBox(LocalPlayer():GetPos():Distance(self:GetPos())/2, -TextWidth3*0.5, 60, "Stable Meth Lab", "HUDNumber5", Color(0, 0, 0, 100), Color(255,255,255,255))
--		draw.WordBox(.7, -TextWidth2*0.5, 18, owner, "HUDNumber5", Color(0, 0, 0, 155), Color(255,255,255,255))
	cam.End3D2D()
end