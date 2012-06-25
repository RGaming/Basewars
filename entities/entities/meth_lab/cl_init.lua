include('shared.lua')
include('shared.lua')

function ENT.Initialize()
	killicon.AddFont("meth_lab","CSKillIcons","C",Color(100,50,50,255))
end

function ENT:Draw( )
  

	self.Entity:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = Angle( 0, 0, 0) -- self:GetAngles()
	
	local upgrade = self.Entity:GetNWInt("upgrade")
	local owner = self.Owner
	owner = (ValidEntity(owner) and owner:Nick()) or "Unknown"
	
--	if ply:GetNWEntity( "drawmoneytitle" ) == true then
	
	surface.SetFont("HUDNumber5")
	local TextWidth = surface.GetTextSize("Unstable Meth Lab")
	local TextWidth2 = surface.GetTextSize("Level:"..upgrade)
	local TextWidth3 = surface.GetTextSize(owner) 
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	local TextAng = Ang
---TextAng, LocalPlayer():GetPos():Distance(self:GetPos()) / 500
	
	TextAng:RotateAroundAxis(TextAng:Right(), CurTime() * -180)
	local ply = LocalPlayer
	cam.Start3D2D(Pos + Ang:Right() * -130, TextAng, 0.15)
		draw.WordBox(.7, -TextWidth*0.5, -30, "Unstable Meth Lab", "HUDNumber5", Color(0, 0, 0, 155), Color(255,255,255,255))
--		draw.WordBox(LocalPlayer():GetPos():Distance(self:GetPos())/2, -TextWidth3*0.5, 60, "Stable Meth Lab", "HUDNumber5", Color(0, 0, 0, 100), Color(255,255,255,255))
		draw.WordBox(.7, -TextWidth2*0.5, 18, "Level:"..upgrade, "HUDNumber5", Color(0, 0, 0, 155), Color(255,255,255,255))
		draw.WordBox(.7, -TextWidth3*0.5, 70, owner, "HUDNumber5", Color(0, 0, 0, 155), Color(255,255,255,255))
	cam.End3D2D()
end