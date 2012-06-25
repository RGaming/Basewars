
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
	
	self.Entity:SetRenderBoundsWS( self.Beamstart, self.Beamend )
	self.Spawntime = CurTime()
	
end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	if self.Spawntime+0.01<CurTime() then
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
	render.DrawBeam( self.Beamstart, self.Beamend, math.random(2,20), 0, 0, self.Color )
end
