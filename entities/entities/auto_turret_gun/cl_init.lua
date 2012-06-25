
include('shared.lua')

ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT.Initialize()
	killicon.AddFont("auto_turret_gun","CSKillIcons","C",Color(100,100,100,255))
end