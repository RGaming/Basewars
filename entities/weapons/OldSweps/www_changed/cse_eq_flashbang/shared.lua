
if (SERVER) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if (CLIENT) then
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 82
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= true
	
	SWEP.ViewModelFlip		= false
	
	surface.CreateFont( "csd", ScreenScale( 30 ), 500, true, true, "CSKillIcons" )
	surface.CreateFont( "csd", ScreenScale( 60 ), 500, true, true, "CSSelectIcons" )
end

if ( CLIENT ) then
	SWEP.Author				= "CSE - Night Eagle"
	SWEP.Contact			= ""
	SWEP.Purpose			= ""
	SWEP.Instructions		= ""
	SWEP.PrintName			= "Stun Grenade"
	SWEP.Instructions		= ""
	SWEP.Slot				= 4
	SWEP.SlotPos			= 7
	SWEP.IconLetter			= "P"
	
	SWEP.ViewModelFlip		= true
	
	killicon.AddFont("cse_ent_flashgrenade","CSKillIcons",SWEP.IconLetter,Color(100,100,100,255)) //FLASHBANG KILLS ARE THE SEX
end

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_flashbang.mdl"
SWEP.HoldType			= "grenade"

SWEP.Primary.Sound			= Sound("Default.PullPin_Grenade")
SWEP.Primary.Recoil			= 0
SWEP.Primary.Unrecoil		= 0
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 1

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 3
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "AR2AltFire"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Next = CurTime()
SWEP.Primed = 0

function SWEP:Reload()
	return false
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	self.Next = CurTime()
	self.Primed = 0
	return true
end

function SWEP:ShootEffects()
	self.Weapon:SendWeaponAnim( ACT_VM_THROW ) 		// View model animation
	//self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
end


function SWEP:PrimaryAttack()
	if self.Next < CurTime() and self.Primed == 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self.Next = CurTime() + self.Primary.Delay
		
		self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
		self.Primed = 1
		//self.Weapon:EmitSound(self.Primary.Sound)
	end
end

function SWEP:Think()
	if self.Next < CurTime() then
		if self.Primed == 1 and not self.Owner:KeyDown(IN_ATTACK) then
			self.Weapon:SendWeaponAnim(ACT_VM_THROW)
			self.Primed = 2
			self.Next = CurTime() + .3
		elseif self.Primed == 2 then
			self.Primed = 0
			self.Next = CurTime() + self.Primary.Delay
			
			if SERVER then
				local ent = ents.Create("cse_ent_flashgrenade")
				ent:SetOwner(self.Owner)
				ent.Owner = self.Owner
				ent:SetPos(self.Owner:GetShootPos())
				ent:SetAngles(Angle(1,0,0))
				if (self.Weapon:GetNWBool("upgraded") && SERVER) then
					ent:SetNWBool("upgraded", true)
				end
				ent:Spawn()
				
				local phys = ent:GetPhysicsObject()
				phys:SetVelocity(self.Owner:GetAimVector() * 1000)
				phys:AddAngleVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(-1000,1000)))
				
				self.Owner:RemoveAmmo(1,self.Primary.Ammo)
				
				if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
					self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
				end
			end
		end
	end
end


function SWEP:PrintWeaponInfo( x, y, alpha )
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	
	// try to fool them into thinking they're playing a Tony Hawks game
	//draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-14, 14), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	//draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-9, 9), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	
	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
end

function SWEP:ShouldDropOnDie()
	return true
end






