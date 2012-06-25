
include('shared.lua')

ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT


function ENT:Initialize()
end


local laser = Material( "Models/effects/comball_tape" )
local sprite = Material("sprites/light_glow02_add")

function ENT:DrawTranslucent( bDontDrawModel )
	local pos = self.Entity:GetPos()
	local ang = self.Entity:GetAngles():Forward()*20
	local uang = self.Entity:GetAngles():Up()*10
	local rang = self.Entity:GetAngles():Right()*10
	local width = 10
	render.SuppressEngineLighting( true )
	
	width = 40
	local color = Color(self.Entity:GetColor())
	if tonumber(color.r)<100 then color.r=100 end
	if tonumber(color.g)<100 then color.g=100 end
	if tonumber(color.b)<100 then color.b=100 end
	
	render.SetMaterial(laser)
	
	render.DrawQuad(pos-ang,pos+rang,pos+uang,pos-rang)
	render.DrawQuad(pos-ang,pos+rang,pos-uang,pos-rang)
	render.DrawQuad(pos+ang,pos+rang,pos+uang,pos-rang)
	render.DrawQuad(pos+ang,pos+rang,pos-uang,pos-rang)
	
	render.SetMaterial(sprite)
	
	render.DrawSprite(pos,30+math.random(0,10),30+math.random(0,10),color)
	render.DrawSprite(pos+Vector(math.random(-10,10),math.random(-10,10),math.random(-10,10)),10+math.random(0,10),10+math.random(0,10),color)
	
	render.SuppressEngineLighting( false )
end

function ENT:Think()
	
end
