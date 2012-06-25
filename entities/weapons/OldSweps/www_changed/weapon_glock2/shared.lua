
if ( CLIENT ) then
	SWEP.Author				= "CSE - Night Eagle"
	SWEP.Contact			= ""
	SWEP.Purpose			= ""
	SWEP.Instructions		= ""
	SWEP.PrintName			= "Glock"
	SWEP.Instructions		= "Hold use and right-click to change firemodes."
	SWEP.Slot				= 1
	SWEP.SlotPos			= 6
	SWEP.IconLetter			= "c"
	
	killicon.AddFont("weapon_glock2","CSKillIcons",SWEP.IconLetter,Color(100,100,100,255))
end

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end


SWEP.Base				= "cse_base_bs"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_glock18.mdl"
SWEP.HoldType = "pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_Glock.Single")
SWEP.Primary.Recoil			= 2
SWEP.Primary.Unrecoil		= 6
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay			= 0.06 //Don't use this, use the tables below!
SWEP.Primary.DefaultClip	= 21 //Always set this 1 higher than what you want.
SWEP.Primary.Automatic		= true //Don't use this, use the tables below!
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

// SWEP.Upgraded = true

//Firemode configuration

SWEP.IronSightsPos = Vector(4.34,-2,2.8)
SWEP.IronSightsAng = Vector(.74,0,0)
// a little something for those fucking wiggers.
SWEP.AlternateAng = Vector(.74,0,60)

SWEP.data = {}
SWEP.mode = "semi" //The starting firemode
SWEP.data.newclip = false //Do not change this

SWEP.data.semi = {}
SWEP.data.semi.Delay = .1
SWEP.data.semi.Cone = 0.011
SWEP.data.semi.ConeZoom = 0.008

SWEP.data.burst = {}
SWEP.data.burst.Delay = .34
SWEP.data.burst.Cone = 0.02
SWEP.data.burst.ConeZoom = 0.017
SWEP.data.burst.BurstDelay = .04
SWEP.data.burst.Shots = 3
SWEP.data.burst.Counter = 0
SWEP.data.burst.Timer = 0

SWEP.data.accupgrade = true

//End of configuration

// glock upgrade = zoom and accuracy increase

// upgraded glock has more zoom.
function SWEP:SecondaryAttack()
	if self.Owner:KeyDown(IN_USE) then
		if self.mode == "semi" then
			self.mode = "burst"
		else
			self.mode = "semi"
		end
		self.data[self.mode].Init(self)
		
		if self.mode == "burst" then
			self.Weapon:SetNetworkedInt("csef",2)
		elseif self.mode == "semi" then
			self.Weapon:SetNetworkedInt("csef",3)
		end
	elseif SERVER then
		if self.Owner:GetFOV() == 90 then
			if (self.Weapon:GetNWBool("upgraded")) then
				self.Owner:SetFOV(40,.3)
			else
				self.Owner:SetFOV(self.data.zoomfov,.3)
			end
			self.ironsights = true
		elseif self.Owner:GetFOV() == self.data.zoomfov and self.data.snipefov > 0 then
			self.Owner:SetFOV(self.data.snipefov,.3)
			self.ironsights = false
		else
			self.Owner:SetFOV(90,.3)
			self.ironsights = false
		end
		self:SetIronsights(self.ironsights)
	end
end

local IRONSIGHT_TIME = 0.25

function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
	
		if ( bIron ) then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end
	local Offset	= self.IronSightsPos
	// get the gun off the screen so that the upgrade zoom isnt worthless
	if (self.Weapon:GetNWBool("upgraded")) then
		Offset = Vector(4.34,-2,2)
	end
	if ( self.IronSightsAng ) then
	
		if (self.Owner:Team()==4) then
			ang = ang * 1
			ang:RotateAroundAxis( ang:Right(), 		self.AlternateAng.x * Mul )
			ang:RotateAroundAxis( ang:Up(), 		self.AlternateAng.y * Mul )
			ang:RotateAroundAxis( ang:Forward(), 		self.AlternateAng.z * Mul )
			
		else
			ang = ang * 1
			ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
			ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
			ang:RotateAroundAxis( ang:Forward(), 		self.IronSightsAng.z * Mul )
			
		end
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end
