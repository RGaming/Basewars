
include('shared.lua')

ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT


function ENT:Initialize()
end


local laser = Material( "models/props_lab/xencrystal_sheet" )
local sprite = Material("sprites/light_glow02_add")

function ENT:DrawTranslucent( bDontDrawModel )
	
	local ang = self.Entity:GetAngles():Forward()*10
	local uang = self.Entity:GetAngles():Up()*20
	local pos = self.Entity:GetPos()+self.Entity:GetAngles():Up()*5
	local rang = self.Entity:GetAngles():Right()*10
	local width = 10
	
	width = 40
	local color = Color(self.Entity:GetColor())
	if tonumber(color.r)<10 then color.r=10 end
	if tonumber(color.g)<10 then color.g=10 end
	if tonumber(color.b)<10 then color.b=10 end
	
	render.SetMaterial(laser)
	
	render.DrawQuad(pos+uang,pos+rang,pos-ang,pos-rang)
	render.DrawQuad(pos-ang,pos+rang,pos-uang,pos-rang)
	render.DrawQuad(pos+ang,pos+rang,pos+uang,pos-rang)
	render.DrawQuad(pos-uang,pos+rang,pos+ang,pos-rang)
	
	render.SetMaterial(sprite)
	//render.SuppressEngineLighting( true )
	//self.Entity:DrawModel()
	
	
	// from keypad
	local eang = self.Entity:GetAngles()
	local rot = Vector(-90, 90, 0)

	eang:RotateAroundAxis(eang:Right(), rot.x)
	eang:RotateAroundAxis(eang:Up(), rot.y)
	eang:RotateAroundAxis(eang:Forward(), rot.z)
	
	cam.Start3D2D(pos, eang, 1)
		local txt = self.Entity:GetNWString("text")
		surface.SetDrawColor(0,0,0,255)
		surface.SetFont("Trebuchet18")
		local w,h = surface.GetTextSize(txt)
		w=w+16
		surface.DrawRect(-w*.5, -15-h, w, h)
		draw.DrawText(txt, "Trebuchet18", 0, -15-h, color,1)
	cam.End3D2D()
	
	
	
	
	
	//render.SuppressEngineLighting( false )
end

function ENT:Think()
	
end
