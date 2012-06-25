

if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if( CLIENT ) then


	SWEP.DrawAmmo = false;
	if (file.Exists("../materials/weapons/weapon_mad_medic.vmt")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_medic")
end

	SWEP.PrintName = "Lock Pick";
	SWEP.Slot = 5;
	SWEP.SlotPos = 4;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;

end

// Variables that are used on both client and server

SWEP.Author			= "Rickster"
SWEP.Instructions	= "Left click to pick a lock or gun vault"
SWEP.Contact		= ""
SWEP.Purpose		= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel = Model( "models/weapons/v_crowbar.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_crowbar.mdl" )

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.Sound = Sound( "physics/wood/wood_box_impact_hard3.wav" );

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""



/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()

	if( SERVER ) then
	
		self:SetWeaponHoldType( "melee" );
	
	end
util.PrecacheSound("physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav")
util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")
end


/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end


/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + .4)

	local trace = self.Owner:GetEyeTrace()
	local bullet = {}
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 1
		bullet.Damage = 0
	if (ValidEntity(trace.Entity)) then	
		if (trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 and not trace.Entity:IsDoor() && trace.Entity:GetClass()!="gunvault" && trace.Entity:GetClass()!="pillbox" && trace.Entity:GetClass()!="gunvault" && trace.Entity:GetClass()!="sent_keypad") then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav")
			
		elseif (trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 and trace.Entity:IsDoor() and ValidEntity(trace.Entity)) then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav")
			
			if(trace.Entity:GetNWInt("unlockAmount") == nil) then
				trace.Entity:SetNWInt("unlockAmount", 0)
			elseif(trace.Entity:GetNWInt("unlockAmount") < 4) then
				if self.Owner:GetTable().Tooled then
					trace.Entity:SetNWInt("unlockAmount", trace.Entity:GetNWInt("unlockAmount")+2)
				else
					trace.Entity:SetNWInt("unlockAmount", trace.Entity:GetNWInt("unlockAmount")+1)
				end
			else
				trace.Entity:SetNWInt("unlockAmount", 0)
				if SERVER then
					trace.Entity:Fire( "unlock", "", .5 )
					trace.Entity:Fire( "open", "", .6 )
				end
			end
		elseif (trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 and (trace.Entity:GetClass()=="gunvault" || trace.Entity:GetClass()=="pillbox") and ValidEntity(trace.Entity)) then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav")
			
			if(trace.Entity:GetNWInt("unlockAmount") == nil) then
				trace.Entity:SetNWInt("unlockAmount", 0)
			elseif(trace.Entity:GetNWInt("unlockAmount") < 9) then
				if self.Owner:GetTable().Tooled then
					trace.Entity:SetNWInt("unlockAmount", trace.Entity:GetNWInt("unlockAmount")+2)
				else
					trace.Entity:SetNWInt("unlockAmount", trace.Entity:GetNWInt("unlockAmount")+1)
				end
			else
				trace.Entity:SetNWInt("unlockAmount", 0)
				if SERVER then
					Notify(self.Owner, 4, 3, "gun vault/pill box unlocked")
					trace.Entity:SetUnLocked()
				end
			end
		elseif (self.Owner:GetTable().Tooled && trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 and (trace.Entity:GetClass()=="sent_keypad") and ValidEntity(trace.Entity)) then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav")
			
			if(trace.Entity:GetNWInt("unlockAmount") == nil) then
				trace.Entity:SetNWInt("unlockAmount", 0)
			elseif(trace.Entity:GetNWInt("unlockAmount") < 20) then
				if self.Owner:GetTable().Tooled then
					trace.Entity:SetNWInt("unlockAmount", trace.Entity:GetNWInt("unlockAmount")+2)
				else
					trace.Entity:SetNWInt("unlockAmount", trace.Entity:GetNWInt("unlockAmount")+1)
				end
			else
				trace.Entity:SetNWInt("unlockAmount", 0)
				if SERVER then
					local Pass=0
					for k,v in pairs(Keypad.Passwords) do
						if (trace.Entity:EntIndex() == v.Ent) then
							Pass=v.Pass
						end
					end
					Notify(self.Owner, 4, 3, "the code is "..tostring(Pass))
				end
			end
		elseif CLIENT && (trace.Entity:GetClass()=="sent_keypad") then
				self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav")
		end
	else
		self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	end

end

function SWEP:ShouldDropOnDie()
	return true
end