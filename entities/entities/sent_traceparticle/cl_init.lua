
include('shared.lua')


function ENT:Initialize()

	self.Color = Color(255,255,255,255)

end


function ENT:Draw()

	--To draw, or not to draw?
	local dodraw = dodraw or self.Entity:GetNetworkedBool("dodraw")
	if not dodraw then return false end
	
	--We need to get all of our networked vars and store them as locals to prevent lagness.
	local issprite = issprite or self.Entity:GetNetworkedBool("issprite")
	local doblur = doblur or self.Entity:GetNetworkedBool("doblur")
	local model = model or self.Entity:GetNetworkedString("model")
	local color = color or Color( self.Entity:GetNetworkedInt("rcolor",255), self.Entity:GetNetworkedInt("gcolor",255), self.Entity:GetNetworkedInt("bcolor",255), self.Entity:GetNetworkedInt("acolor",255) )
	local collisionsize = collisionsize or self.Entity:GetNetworkedFloat("collisionsize")*2
	
	
	if issprite then
	
		local pos = self.Entity:GetPos()
		local vel = self.Entity:GetVelocity()
		render.SetMaterial(Material(model))

		if doblur then
			local lcolor = render.GetLightColor( pos ) * 2
			lcolor.x = color.r * mathx.Clamp( lcolor.x, 0, 1 )
			lcolor.y = color.g * mathx.Clamp( lcolor.y, 0, 1 )
			lcolor.z = color.b * mathx.Clamp( lcolor.z, 0, 1 )
			
			--Fake motion blur
			for i = 1, 7 do
				local col = Color( lcolor.x, lcolor.y, lcolor.z, 200 / i )
				render.DrawSprite( pos + vel*(i*-0.004), collisionsize, collisionsize, col )
			end
		end
		
		render.DrawSprite(pos, collisionsize, collisionsize, color)

	else
	
		self.Entity:DrawModel() 
		
	end

	self.Entity:DrawShadow(false)
	
end

