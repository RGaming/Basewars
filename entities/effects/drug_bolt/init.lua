
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	self.Center = data:GetOrigin()
	//self.RingRadius = data:GetRadius()
	self.Color = data:GetStart()
	self.Spawntime = CurTime()
	self.Angle = data:GetNormal()
	self.Entity:SetRenderBoundsWS( self.Center+Vector(40,40,40), self.Center-Vector(40,40,40) )
end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	if self.Spawntime+.25<CurTime() then
		return false
	else
		return true
	end
	return true
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
local laser = Material("trails/laser")
function EFFECT:Render()
	local color_s = self.Color
	local ang = self.Angle
	local dist = 30
	local color = Color(color_s.x,color_s.y,color_s.z,40)
	render.SetMaterial(laser)
	local startpoint = self.Center
	
	render.StartBeam(3)
	render.AddBeam( startpoint, math.random(10,30), 0, color )
	local nextpoint = (ang*math.random(1,dist)*-1)+Vector(math.random(0,10)-5, math.random(0,10)-5, math.random(0,10)-5)+self.Center
	render.AddBeam( nextpoint, math.random(10,30), 0, color )
	local nextpoint = (ang*math.random(1,dist)*-1)+Vector(math.random(0,10)-5, math.random(0,10)-5, math.random(0,10)-5)+self.Center
	render.AddBeam( nextpoint, math.random(10,30), 0, color )
	render.EndBeam()
end
