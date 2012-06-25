

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "ar2"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Aug"			
	SWEP.Author				= "HLTV Proxy"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 10
	SWEP.IconLetter			= "e"
	
	killicon.AddFont( "weapon_aug2", "CSKillIcons", SWEP.IconLetter, Color( 100, 100, 100, 255 ) )
	
end


SWEP.Base				= "weapon_cs_base2"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_aug.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_aug.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_AUG.Single" )
SWEP.Primary.Recoil			= 0.6
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0075
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay			= 0.15
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 0, 0, -15 )

// aug gets a bigger clip on upgrade

function SWEP:Upgrade(bool)
	self.Weapon:SetNWBool("upgraded",bool)
	if bool then
		self.Primary.ClipSize = 45
	else
		self.Primary.ClipSize = 20
	end
end

function SWEP:Reload()
	if (self.Weapon:GetNWBool("upgraded") && self.Weapon:Clip1()<35) || (!self.Weapon:GetNWBool("upgraded") && self.Weapon:Clip1()<15) then
		self.Weapon:DefaultReload( ACT_VM_RELOAD );
		self:SetIronsights( false )
		self.Owner:SetNetworkedInt( "ScopeLevel", 0 )
		self.Owner:SetFOV(self.ViewModelFOV,.3)
	end
end

function SWEP:SecondaryAttack()

	if ( !self.IronSightsPos ) then return end
	if ( self.NextSecondaryAttack > CurTime() ) then return end
	
	self.NextSecondaryAttack = CurTime() + 0.3
	
	if( self.Owner:GetNetworkedInt( "ScopeLevel" ) == nil ) then
		self.Owner:SetNetworkedInt( "ScopeLevel", 0 )
	end
	
	if(self.Owner:GetNetworkedInt( "ScopeLevel" ) == 0) then
	
		if(SERVER) then
			self.Owner:SetFOV( 40, 0 )
		end	
		
		self.Owner:SetNetworkedInt( "ScopeLevel", 1 )
		self:SetIronsights( true )
		
	else
		if(SERVER) then
			self.Owner:SetFOV( 0, 0 )
		end		
		
		self.Owner:SetNetworkedInt( "ScopeLevel", 0 )
		self:SetIronsights( false )
		
	end
	
end

function SWEP:DrawHUD()

	if( LocalPlayer():GetNetworkedInt( "ScopeLevel" ) > 0 && self.Weapon:GetClass()!="weapon_tranqgun") then
			--Width hairs
			draw.RoundedBox( 1, ScrW() / 2 - 54, ScrH() / 2, 50, 1, Color(0,0,0,255) )
			draw.RoundedBox( 1, ScrW() / 2 + 4, ScrH() / 2, 50, 1, Color(0,0,0,255) )
			
			draw.RoundedBox( 1, ScrW() / 2, ScrH() / 2 - 54, 1, 50, Color(0,0,0,255) )
			draw.RoundedBox( 1, ScrW() / 2, ScrH() / 2 + 4, 1, 50, Color(0,0,0,255) )
			
			draw.RoundedBox( 1, ScrW() / 2 - 44, ScrH() / 2 - 5, 1, 11, Color(0,0,0,255) )
			draw.RoundedBox( 1, ScrW() / 2 - 34, ScrH() / 2 - 5, 1, 11, Color(0,0,0,255) )
			draw.RoundedBox( 1, ScrW() / 2 - 24, ScrH() / 2 - 5, 1, 11, Color(0,0,0,255) )
			draw.RoundedBox( 1, ScrW() / 2 - 14, ScrH() / 2 - 5, 1, 11, Color(0,0,0,255) )
			
			draw.RoundedBox( 1, ScrW() / 2 + 44, ScrH() / 2 - 5, 1, 11, Color(0,0,0,255) )
			draw.RoundedBox( 1, ScrW() / 2 + 34, ScrH() / 2 - 5, 1, 11, Color(0,0,0,255) )
			draw.RoundedBox( 1, ScrW() / 2 + 24, ScrH() / 2 - 5, 1, 11, Color(0,0,0,255) )
			draw.RoundedBox( 1, ScrW() / 2 + 14, ScrH() / 2 - 5, 1, 11, Color(0,0,0,255) )
			
			draw.RoundedBox( 1, ScrW() / 2 - 5, ScrH() / 2 - 44, 11, 1, Color(0,0,0,255) )
			draw.RoundedBox( 1, ScrW() / 2 - 5, ScrH() / 2 - 34, 11, 1, Color(0,0,0,255) )
			draw.RoundedBox( 1, ScrW() / 2 - 5, ScrH() / 2 - 24, 11, 1, Color(0,0,0,255) )
			draw.RoundedBox( 1, ScrW() / 2 - 5, ScrH() / 2 - 14, 11, 1, Color(0,0,0,255) )
			
			draw.RoundedBox( 1, ScrW() / 2 - 5, ScrH() / 2 + 44, 11, 1, Color(0,0,0,255) )
			draw.RoundedBox( 1, ScrW() / 2 - 5, ScrH() / 2 + 34, 11, 1, Color(0,0,0,255) )
			draw.RoundedBox( 1, ScrW() / 2 - 5, ScrH() / 2 + 24, 11, 1, Color(0,0,0,255) )
			draw.RoundedBox( 1, ScrW() / 2 - 5, ScrH() / 2 + 14, 11, 1, Color(0,0,0,255) )
			
			
			

	end
		
end
function SWEP:Holster()

	if(SERVER) then
		self.Owner:SetFOV( 0, 0 )
	end
	if ValidEntity(self.Owner) then
		self.Owner:SetNetworkedInt( "ScopeLevel", 0 )
		self:SetIronsights( false )
	end
	return true
	
end