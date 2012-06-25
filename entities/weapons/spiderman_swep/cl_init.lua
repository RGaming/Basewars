
include('shared.lua')


function SWEP:CustomAmmoDisplay()

	self.AmmoDisplay = self.AmmoDisplay or {}
	//attempt to remove ammo display
	self.AmmoDisplay.Draw = false
	
	self.AmmoDisplay.PrimaryClip 	= 1
	self.AmmoDisplay.PrimaryAmmo 	= -1
	self.AmmoDisplay.SecondaryAmmo 	= -1
	
	return self.AmmoDisplay

end

function SWEP:SetWeaponHoldType( t )
	// Just a fake function so we can define 
	// weapon holds in shared files without errors
end