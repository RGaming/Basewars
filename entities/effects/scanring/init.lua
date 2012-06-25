
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	self.RingCenter = data:GetOrigin()
	self.MaxRingRadius = data:GetRadius()
	
	WorldSound( "buttons/button17.wav", self.RingCenter, 140, 160 )
	
	self.Spawntime = CurTime()
	self.RingRadius = 0
	self.RingRadius2 = -self.MaxRingRadius*.35
	self.RingRadius3 = -self.MaxRingRadius*.65
	self.Entity:SetRenderBoundsWS( self.RingCenter+Vector(self.MaxRingRadius,self.MaxRingRadius,20), self.RingCenter-Vector(self.MaxRingRadius,self.MaxRingRadius,-20) )
end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	if self.RingRadius3>=self.MaxRingRadius then
		return false
	else
		return true
	end
	return true
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
local laser = Material('cable/physbeam')
local width = 20
function EFFECT:Render()
	self.RingRadius = self.RingRadius+FrameTime()*(self.MaxRingRadius*.5)
	local ang = 0
	local rad = self.RingRadius
	render.SetMaterial(laser)
	render.StartBeam(25)
	local startpoint = Vector(math.sin(ang)*rad, math.cos(ang)*rad, 0)+self.RingCenter
	render.AddBeam(startpoint,width,0,Color(255,255,255,255))
	for i=1, 23 do
		ang = .2617993878*i
		local drawpoint = Vector(math.sin(ang)*rad, math.cos(ang)*rad, 0)+self.RingCenter
		render.AddBeam(drawpoint,width,0,Color(255,255,255,255))
	end
	render.AddBeam(startpoint,width,0,Color(255,255,255,255))
	render.EndBeam()
	
	self.RingRadius2 = self.RingRadius2+FrameTime()*(self.MaxRingRadius*.5)
	if self.RingRadius2>0 then
		local ang = 0
		local rad = self.RingRadius2
		render.SetMaterial(laser)
		render.StartBeam(25)
		local startpoint = Vector(math.sin(ang)*rad, math.cos(ang)*rad, 0)+self.RingCenter
		render.AddBeam(startpoint,width,0,Color(255,255,255,255))
		for i=1, 23 do
			ang = .2617993878*i
			local drawpoint = Vector(math.sin(ang)*rad, math.cos(ang)*rad, 0)+self.RingCenter
			render.AddBeam(drawpoint,width,0,Color(255,255,255,255))
		end
		render.AddBeam(startpoint,width,0,Color(255,255,255,255))
		render.EndBeam()
	end
	
	self.RingRadius3 = self.RingRadius3+FrameTime()*(self.MaxRingRadius*.5)
	if self.RingRadius3>0 then
		local ang = 0
		local rad = self.RingRadius3
		render.SetMaterial(laser)
		render.StartBeam(25)
		local startpoint = Vector(math.sin(ang)*rad, math.cos(ang)*rad, 0)+self.RingCenter
		render.AddBeam(startpoint,width,0,Color(255,255,255,255))
		for i=1, 23 do
			ang = .2617993878*i
			local drawpoint = Vector(math.sin(ang)*rad, math.cos(ang)*rad, 0)+self.RingCenter
			render.AddBeam(drawpoint,width,0,Color(255,255,255,255))
		end
		render.AddBeam(startpoint,width,0,Color(255,255,255,255))
		render.EndBeam()
	end
end
