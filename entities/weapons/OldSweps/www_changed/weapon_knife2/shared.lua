// file is modified lockpick.

if( SERVER ) then

	AddCSLuaFile( "shared.lua" );

end

if( CLIENT ) then

	SWEP.PrintName = "Knife";
	SWEP.Slot = 0;
	SWEP.SlotPos = 6;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;

	killicon.AddFont( "weapon_knife2", "CSKillIcons", "j", Color( 100, 100, 100, 255 ) )
	killicon.AddFont( "#weapon_knife2", "CSKillIcons", "j", Color( 150, 100, 100, 255 ) )
	language.Add("weapon_knife2", "A knife in the spine")

end

// Variables that are used on both client and server

SWEP.Author			= "HLTV Proxy"
SWEP.Instructions	= "Left click to swing\nRight click to stab.\n\n If victim is facing away from you when\nyou stab, you are not shown as the killer,\n and the knife will deal insane damage."
SWEP.Contact		= ""
SWEP.Purpose		= ""

SWEP.ViewModelFOV	= 73
SWEP.ViewModelFlip	= false
SWEP.ViewModel = Model( "models/weapons/v_knife_t.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_knife_t.mdl" )

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Sound = Sound( "weapons/knife/knife_slash1.wav" );

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""

// knife upgrade = no sound when pulled out, also poison

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
	util.PrecacheSound("weapons/knife/knife_deploy1.wav")
	util.PrecacheSound("weapons/knife/knife_hit1.wav")
	util.PrecacheSound("weapons/knife/knife_hit2.wav")
	util.PrecacheSound("weapons/knife/knife_hit3.wav")
	util.PrecacheSound("weapons/knife/knife_hit4.wav")
	util.PrecacheSound("weapons/knife/knife_hitwall1.wav")
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
	util.PrecacheSound("weapons/knife/knife_stab.wav")
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	if !self.Weapon:GetNWBool("upgraded") then
		self.Weapon:EmitSound("weapons/knife/knife_deploy1.wav")
	end	
	return true
end 
/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/

function SWEP:PrimaryAttack()
	self.Owner:LagCompensation( true )
	self.Weapon:SetNextPrimaryFire(CurTime() + .4)
	self.Weapon:SetNextSecondaryFire(CurTime() + .4)
	self.Owner:SetAnimation( PLAYER_ATTACK2 )
	local trace = self.Owner:GetEyeTrace()
	local bullet = {}
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 1
		bullet.Damage = 0
	
	if (trace.HitPos:Distance(self.Owner:GetShootPos()) <= 105) then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		if (ValidEntity(trace.Entity)) then
			// make 100% sure theres no actual bullet damage, while still preserving damage effects
			if !SERVER then
				self.Owner:FireBullets(bullet) 
			end
			if SERVER then
				trace.Entity:TakeDamage(30, self.Owner, self.Weapon)
				if (self.Weapon:GetNWBool("upgraded") && trace.Entity:IsPlayer()) then
					PoisonPlayer(trace.Entity, 15, self.Owner, self.Weapon)
				end
			end
			if (trace.Entity:IsPlayer() || trace.Entity:IsNPC()) then
				self.Weapon:EmitSound("weapons/knife/knife_hit".. math.random(1,4) ..".wav")
			else
				self.Weapon:EmitSound("weapons/knife/knife_hitwall1.wav")
			end
		else
			self.Weapon:EmitSound("weapons/knife/knife_hitwall1.wav")
		end
	else
		self.Weapon:EmitSound("weapons/knife/knife_slash".. math.random(1,2) ..".wav")
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
	self.Owner:LagCompensation( false)
end

// STAB

function SWEP:SecondaryAttack()
	self.Owner:LagCompensation( true )
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	local trace = self.Owner:GetEyeTrace()
	local bullet = {}
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 1
		bullet.Damage = 0
	
	if (trace.HitPos:Distance(self.Owner:GetShootPos()) <= 100) then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		if (ValidEntity(trace.Entity)) then
			// make 100% sure theres no actual bullet damage, while still preserving damage effects
			if !SERVER then
				self.Owner:FireBullets(bullet) 
			end
			if SERVER then
				if (trace.Entity:IsPlayer() || trace.Entity:IsNPC()) then
					local stabpos = trace.Entity:GetPos()-self.Owner:GetPos()
					local stabang = stabpos:Angle()
					local targang = trace.Entity:GetAngles()
					local stabdiff = targang.y-stabang.y
					if stabdiff>180 then stabdiff = stabdiff-360 end
					if stabdiff<-180 then stabdiff = stabdiff+360 end
					if (stabdiff<30 && stabdiff>-30) then
						Notify(self.Owner, 1, 3, "BACKSTAB!")
						if (trace.Entity:IsPlayer()) then
							Notify(trace.Entity, 1, 3, "Stabbed in the back!")
						end
						trace.Entity:TakeDamage(450, self.Weapon, self.Weapon)
					else
						trace.Entity:TakeDamage(60, self.Owner, self.Weapon)
						if (self.Weapon:GetNWBool("upgraded")) then
							PoisonPlayer(trace.Entity, 15, self.Owner, self.Weapon)
						end
					end
				else
					trace.Entity:TakeDamage(60, self.Owner, self.Weapon)
				end
			end
			if (trace.Entity:IsPlayer() || trace.Entity:IsNPC()) then
				self.Weapon:EmitSound("weapons/knife/knife_stab.wav")
			else
				self.Weapon:EmitSound("weapons/knife/knife_hitwall1.wav")
			end
		else
			self.Weapon:EmitSound("weapons/knife/knife_hitwall1.wav")
		end
	else
		self.Weapon:EmitSound("weapons/knife/knife_slash".. math.random(1,2) ..".wav")
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
	self.Owner:LagCompensation( false )
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

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	draw.SimpleText( "j", "CSSelectIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	
	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	if (self.Weapon:GetNWBool("upgraded")) then
		draw.SimpleText("K", "CSKillIcons", x + wide-20, y + tall-25, Color(200,200, 200, 255), TEXT_ALIGN_CENTER )
	end
end

function SWEP:Upgrade(bool)
	self.Weapon:SetNWBool("upgraded",bool)
end

function SWEP:ShouldDropOnDie()
	return true
end