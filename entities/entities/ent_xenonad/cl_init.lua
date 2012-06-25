include('shared.lua')

local mat = Material( "basewars/Xenonservers" )
function ENT:Draw()
	
	self:DrawModel()
	self:DestroyShadow()
	cam.Start3D2D( self:GetPos() + vector_up * 80, Angle( 0, self:GetAngles().y, 90 ), .25 )
		surface.SetMaterial( "basewars/xenonservers.tga" )
		surface.DrawTexturedRect( 0, 0, 2048, 512 )
	cam.End3D2D()
	
end