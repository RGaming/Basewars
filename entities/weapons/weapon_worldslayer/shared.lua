

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "rpg"
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
end

if ( CLIENT ) then

	SWEP.PrintName			= "Worldslayer"			
	SWEP.Author				= "HLTV Proxy"
	SWEP.Instructions	= "Portable Bigbomb. \n This weapon only has one shot."
	SWEP.Contact		= ""
	SWEP.Purpose		= ""
	SWEP.Slot				= 4
	SWEP.SlotPos			= 5
	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	SWEP.IconLetter			= "i"
	
	surface.CreateFont( "HalfLife2", ScreenScale( 60 ), 500, true, true, "HL2SelectIcons" )
	killicon.AddFont( "shot_rocket", "HL2MPTypeDeath", "3", Color( 100, 100, 100, 255 ) )
	
	if (file.Exists("../materials/weapons/weapon_mad_rpg.vmt")) then
		SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_rpg")
	end
end


SWEP.Base				= "weapon_mad_base"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_RPG.Single" )
SWEP.Primary.Recoil			= 15
SWEP.Primary.Damage			= 4107 // ALOT
SWEP.Primary.NumShots		= 5
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 0.15
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 6.1, -14, 2.5 )
SWEP.IronSightsAng 		= Vector( 2.8, 0, 0 )

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	//if ( !self:CanPrimaryAttack() ) then return end

	self.Weapon:EmitSound( self.Primary.Sound )
	if (SERVER) then
		self:FireRocket( self.Primary.Recoil )
	end
	if ( self.Owner:IsNPC() ) then return end

	self.Owner:ViewPunch( Angle( math.Rand(-0.2,0.2) * self.Primary.Recoil, math.Rand(-0.2,0.2) *self.Primary.Recoil, 0 ) )
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	if (SERVER) then
		self.Weapon:Remove()
	end
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
	// self.Owner:GiveAmmo(100, "RPG_Round")
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:FireRocket( recoil )

	local object = ents.Create("worldslayer")
	// grenade_ar2
	if ValidEntity(object) then	
		
		object:SetOwner(self.Owner)
		object.Owner = self.Owner
		object:SetPos(self.Owner:GetShootPos()+self.Owner:EyeAngles():Right()*5)
		object:SetAngles(self.Owner:EyeAngles())
		object:Spawn()
		object:Activate()
		object:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector()*400000)
	end
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
	if ( self.Owner:IsNPC() ) then return end
	
	// CUSTOM RECOIL !
	if ( (SinglePlayer() && SERVER) || ( !SinglePlayer() && CLIENT ) ) then
	
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	
	end

end

/*---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
---------------------------------------------------------*/
function SWEP:Upgrade(bool)
	self.Weapon:SetNWBool("upgraded",bool)
end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:PrintWeaponInfo( x, y, alpha )
	//if ( self.DrawWeaponInfoBox == false ) then return end

	if (self.InfoMarkup == nil ) then
		local str
		local title_color = "<color=230,230,230,255>"
		local text_color = "<color=150,150,150,255>"
		
		str = "<font=HudSelectionText>"
		if ( self.Author != "" ) then str = str .. title_color .. "Author:</color>\t"..text_color..self.Author.."</color>\n" end
		if ( self.Contact != "" ) then str = str .. title_color .. "Contact:</color>\t"..text_color..self.Contact.."</color>\n\n" end
		if ( self.Purpose != "" ) then str = str .. title_color .. "Purpose:</color>\n"..text_color..self.Purpose.."</color>\n\n" end
		if ( self.Instructions != "" ) then str = str .. title_color .. "Instructions:</color>\n"..text_color..self.Instructions.."</color>\n" end
		str = str .. "</font>"
		
		self.InfoMarkup = markup.Parse( str, 250 )
	end
	
	surface.SetDrawColor( 60, 60, 60, alpha )
	surface.SetTexture( self.SpeechBubbleLid )
	
	surface.DrawTexturedRect( x, y - 64 - 5, 128, 64 ) 
	draw.RoundedBox( 8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color( 60, 60, 60, alpha ) )
	
	self.InfoMarkup:Draw( x+5, y+5, nil, nil, alpha )
	
end