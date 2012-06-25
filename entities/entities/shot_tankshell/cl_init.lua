
include('shared.lua')

ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT.Initialize()
	killicon.AddFont("shot_tankshell","HL2MPTypeDeath","7",Color(100,100,100,255))
end