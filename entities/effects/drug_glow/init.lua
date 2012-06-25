
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	self.RingCenter = data:GetOrigin()
	self.RingRadius = data:GetRadius()
	self.Color = data:GetStart()
	self.Spawntime = CurTime()
	self.Angle = math.random(0,360)
	self.Entity:SetRenderBoundsWS( self.RingCenter+Vector(self.RingRadius,self.RingRadius,20), self.RingCenter-Vector(self.RingRadius,self.RingRadius,20) )
end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	if self.Spawntime+.5<CurTime() then
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
	self.Angle=self.Angle+1
	if self.Angle>360 then self.Angle=self.Angle-360 end
	local rad = self.RingRadius*(((self.Spawntime-CurTime())+.5)*2)
	local color = Color(color_s.x,color_s.y,color_s.z,255)
	render.SetMaterial(laser)
	local startpoint = self.RingCenter
	local endpoint = Vector(math.sin(ang)*rad, math.cos(ang)*rad, 0)+self.RingCenter
	render.DrawBeam( startpoint, endpoint, math.random(40,80), 0, 0, color )
end
