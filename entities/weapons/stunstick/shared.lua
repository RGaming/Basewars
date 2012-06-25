

if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if( CLIENT ) then

	SWEP.PrintName = "Stunstick";
	SWEP.Slot = 0;
	SWEP.SlotPos = 7;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	surface.CreateFont( "HalfLife2", ScreenScale( 60 ), 500, true, true, "HL2SelectIcons" )
	killicon.AddFont( "stunstick", "HL2MPTypeDeath", "!", Color( 100, 100, 100, 255 ) )
end

// Variables that are used on both client and server

SWEP.Author			= "Rickster"
SWEP.Instructions	= "Left click to stun more, with less damage\n Right click to beat the crap out of them, with less stun effect"
SWEP.Contact		= ""
SWEP.Purpose		= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.AnimPrefix		= "stunstick"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.NextStrike = 0;
  
SWEP.ViewModel = Model( "models/weapons/v_stunstick.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_stunbaton.mdl" );
  
SWEP.Sound = Sound( "weapons/stunstick/stunstick_swing1.wav" );
  
SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= 0				// Default number of bullets in a clip
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
	
	self.Hit = { 
	Sound( "weapons/stunstick/stunstick_impact1.wav" ),
  	Sound( "weapons/stunstick/stunstick_impact2.wav" ) };
	
	self.FleshHit = {
  	Sound( "weapons/stunstick/stunstick_fleshhit1.wav" ),
  	Sound( "weapons/stunstick/stunstick_fleshhit2.wav" ) };

end


/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end

function SWEP:DoFlash( ply )

	umsg.Start( "StunStickFlash", ply ); umsg.End();

end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
  function SWEP:PrimaryAttack()
  
  	if( CurTime() < self.NextStrike ) then return; end
 	self.Owner:LagCompensation( true )
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	self.Weapon:EmitSound( self.Sound );
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );

	self.NextStrike = ( CurTime() + .3 );
	self.Owner:LagCompensation( false )
	if( CLIENT ) then return; end

 	local trace = self.Owner:GetEyeTrace();

 	if( not ValidEntity(trace.Entity) ) then
 		return;
	end
	
	if( self.Owner:EyePos():Distance( trace.Entity:GetPos() ) > 130 ) then
		return;
	end
	
	if( SERVER ) then 
	
		trace.Entity:TakeDamage(25, self.Owner, self.Weapon)
		
		if( not trace.Entity:IsDoor() ) then
			trace.Entity:SetVelocity( ( trace.Entity:GetPos() - self.Owner:GetPos() ) * 7 ); 
		end
		
		if( trace.Entity:IsPlayer() ) then
			local stunamount = 50
			trace.Entity:ViewPunch( Angle( stunamount*((math.random()*4)-2), stunamount*((math.random()*4)-2), stunamount*((math.random()*2)-1) ) )
			StunPlayer(trace.Entity, stunamount)
			timer.Simple( .3, self.DoFlash, self, trace.Entity );
			self.Owner:EmitSound( self.FleshHit[math.random(1,#self.FleshHit)] );
		else
			self.Owner:EmitSound( self.Hit[math.random(1,#self.Hit)] );
		end
		
	end
 

  end
 
  /*---------------------------------------------------------
  SecondaryAttack
  ---------------------------------------------------------*/
  function SWEP:SecondaryAttack()
 
  	if( CurTime() < self.NextStrike ) then return; end
  
  	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	self.Weapon:EmitSound( self.Sound );
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );

	self.NextStrike = ( CurTime() + 1 );
	
	if( CLIENT ) then return; end

 	local trace = self.Owner:GetEyeTrace();
	
 	if( not ValidEntity(trace.Entity) ) then
 		return;
	end
	
	if( self.Owner:EyePos():Distance( trace.Entity:GetPos() ) > 100 ) then
		return;
	end
	
	if( SERVER ) then 
		trace.Entity:TakeDamage(60, self.Owner, self.Weapon)
		if( not trace.Entity:IsDoor() ) then
			trace.Entity:SetVelocity( ( trace.Entity:GetPos() - self.Owner:GetPos() ) * 7 ); 
		end
		
		if( trace.Entity:IsPlayer() ) then
			local stunamount = 15
			trace.Entity:ViewPunch( Angle( stunamount*((math.random()*4)-2), stunamount*((math.random()*4)-2), stunamount*((math.random()*2)-1) ) )
			StunPlayer(trace.Entity, stunamount)
			timer.Simple( .3, self.DoFlash, self, trace.Entity );
			self.Owner:EmitSound( self.FleshHit[math.random(1,#self.FleshHit)] );
		else
			self.Owner:EmitSound( self.Hit[math.random(1,#self.Hit)] );
		end
		
	end
 
  end 

function SWEP:ShouldDropOnDie()
	return true
end