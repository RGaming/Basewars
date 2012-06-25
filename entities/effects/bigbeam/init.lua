
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	self.Beamstart = data:GetOrigin()
	self.Beamend = data:GetStart()
	local color = data:GetAngle()
	self.Color = Color(color.p,color.y,color.r,255)
	if tonumber(self.Color.r)<100 then self.Color.r=100 end
	if tonumber(self.Color.g)<100 then self.Color.g=100 end
	if tonumber(self.Color.b)<100 then self.Color.b=100 end
	
	self.Spawntime = CurTime()
	self.BeamFragments = math.floor(self.Beamstart:Distance(self.Beamend)/24)
	// HAY GUISE! LETS CRASH THE PLAYER WHEN A REALLY LONG BEAM DRAWS MILLIONS OF SECTIONS!
	// no, lets fix it instead.
	if self.BeamFragments>64 then self.BeamFragments = 64 end
	self.Dir = self.Beamend-self.Beamstart
	self.Entity:SetRenderBoundsWS( self.Beamstart, self.Beamend )
end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	if self.Spawntime+0.004<CurTime() then
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
	render.SetMaterial(laser)
	render.DrawBeam( self.Beamstart, self.Beamend, math.random(80,110), 0, 0, self.Color )
	render.StartBeam(self.BeamFragments)
	render.AddBeam( self.Beamstart, 20, 0, self.Color )
	local tmp = self.Beamend-self.Beamstart
	local bang = tmp:Angle()
	local rang = bang:Right()*15
	local uang = bang:Up()*15
	local ang = 0
	for i=1, self.BeamFragments-2 do
		ang = ang+.2617993878
		local point = self.Beamstart+((self.Dir/self.BeamFragments)*i)+math.sin(ang)*rang+math.cos(ang)*uang
		
		render.AddBeam(point,30,0,self.Color)
	end
	render.AddBeam( self.Beamend, 40, 0, self.Color )
	render.EndBeam()
end
