include('shared.lua')
function SWEP:DrawHUD()
	
	local charge = self.Primary.Battery
	
	draw.DrawText( "CHARGE: " .. tostring(charge) .. "%", "Trebuchet24", ScrW()-140, ScrH()-40, Color(255, 255, 255, 255 ), 0 );
	
end