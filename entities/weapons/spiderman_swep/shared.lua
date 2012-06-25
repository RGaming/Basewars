SWEP.Author			= "GigaJew and Paranoid*"
SWEP.Contact		= "jaack_harrison@hotmail.co.uk"
SWEP.Purpose		= "Go spidey all over the map lulz"
SWEP.Instructions	= "Left click to throw web"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.PrintName			= "SpiderSwep"			
SWEP.Slot				= 2
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

local sndPowerUp		= Sound("Landing1.wav")
local sndPowerDown		= Sound("StandingFire2.wav")
local sndTooFar			= Sound("Whoosh2.wav")
//local sndShot			= Sound("WebFire3.wav")

function SWEP:Initialize()

	nextshottime = CurTime()
	self:SetWeaponHoldType( "smg" )
	
end

function SWEP:Think()

	if (!self.Owner || self.Owner == NULL) then return end
	
	if ( self.Owner:KeyPressed( IN_ATTACK ) ) then
	
		self:StartAttack()
		
	elseif ( self.Owner:KeyDown( IN_ATTACK ) && inRange ) then
	
		self:UpdateAttack()
		
	elseif ( self.Owner:KeyReleased( IN_ATTACK ) && inRange ) then
	
		self:EndAttack( true )
	
	end
	
	//Changed from KeyDown to prevent random stuck-in-zoom bug.
	if ( self.Owner:KeyPressed( IN_ATTACK2 ) ) then
	
		self:Attack2()
		
	end

end

function SWEP:DoTrace( endpos )
	local trace = {}
		trace.start = self.Owner:GetShootPos()
		trace.endpos = trace.start + (self.Owner:GetAimVector() * 14096) //14096 is length modifier.
		if(endpos) then trace.endpos = (endpos - self.Tr.HitNormal * 7) end
		trace.filter = { self.Owner, self.Weapon }
		
	self.Tr = nil
	self.Tr = util.TraceLine( trace )
end

function SWEP:StartAttack()
    self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK) --plays the shoot animation.
	//Get begining and end poins of trace.
	local gunPos = self.Owner:GetShootPos() //Start of distance trace.
	local disTrace = self.Owner:GetEyeTrace() //Store all results of a trace in disTrace.
	local hitPos = disTrace.HitPos //Stores Hit Position of disTrace.
	
	//Calculate Distance
	//Thanks to rgovostes for this code.
	local x = (gunPos.x - hitPos.x)^2;
	local y = (gunPos.y - hitPos.y)^2;
	local z = (gunPos.z - hitPos.z)^2;
	local distance = math.sqrt(x + y + z);
  self.Weapon:SendWeaponAnim(ACT_VM_HAULBACK) --plays the grab animation
	
	//Only latches if distance is less than distance CVAR
	local distanceCvar = GetConVarNumber("grapple_distance")
	inRange = false
	if distance <= distanceCvar then
		inRange = true
	end
	
	if inRange then
		if (SERVER) then
			
			if (!self.Beam) then //If the beam does not exist, draw the beam.
				//grapple_beam
				self.Beam = ents.Create( "trace1" )
					self.Beam:SetPos( self.Owner:GetShootPos() )
				self.Beam:Spawn()
			end
			
			self.Beam:SetParent( self.Owner )
			self.Beam:SetOwner( self.Owner )
		
		end
		
		self:DoTrace()
		self.speed = 10000 //Rope latch speed. Was 3000.
		self.startTime = CurTime()
		self.endTime = CurTime() + self.speed
		self.dt = -1
		
		if (SERVER && self.Beam) then
			self.Beam:GetTable():SetEndPos( self.Tr.HitPos )
		end
		
		self:UpdateAttack()
		
		self.Weapon:EmitSound( sndPowerDown )
	else
		//Play A Sound
		self.Weapon:EmitSound( sndTooFar )
	end
end

function SWEP:UpdateAttack()
	self.Owner:LagCompensation( true )
	
	if (!endpos) then endpos = self.Tr.HitPos end
	
	if (SERVER && self.Beam) then
		self.Beam:GetTable():SetEndPos( endpos )
	end

	lastpos = endpos
	
	
			if ( self.Tr.Entity:IsValid() ) then
			
					endpos = self.Tr.Entity:GetPos()
					if ( SERVER ) then
					self.Beam:GetTable():SetEndPos( endpos )
					end
			
			end
			
			local vVel = (endpos - self.Owner:GetPos())
			local Distance = endpos:Distance(self.Owner:GetPos())
			
			local et = (self.startTime + (Distance/self.speed))
			if(self.dt != 0) then
				self.dt = (et - CurTime()) / (et - self.startTime)
			end
			if(self.dt < 0) then
				self.Weapon:EmitSound( sndPowerUp )
				self.dt = 0
			end
			
			if(self.dt == 0) then
			zVel = self.Owner:GetVelocity().z
			vVel = vVel:GetNormalized()*(math.Clamp(Distance,0,7))
				if( SERVER ) then
				local gravity = GetConVarNumber("sv_Gravity")
				vVel:Add(Vector(0,0,(gravity/100)*1.5)) //Player speed. DO NOT MESS WITH THIS VALUE!
				if(zVel < 0) then
					vVel:Sub(Vector(0,0,zVel/100))
				end
				self.Owner:SetVelocity(vVel)
				end
			end
	
	endpos = nil
	
	self.Owner:LagCompensation( false )
	
end

function SWEP:EndAttack( shutdownsound )
	
	
	if ( CLIENT ) then return end
	if ( !self.Beam ) then return end
	
	self.Beam:Remove()
	self.Beam = nil
  self.Weapon:SendWeaponAnim(ACT_VM_IDLE_LOWERED) --plays the hold animation
	
end

function SWEP:Attack2() //Zoom.
			
//	self.Weapon:EmitSound( self.Secondary.Sound, 50, 100 )
	if (CLIENT) then return end
		local CF = self.Owner:GetFOV()
		if CF == 90 then
			self.Owner:SetFOV(30,.3)
		elseif CF == 30 then
			self.Owner:SetFOV(90,.3)
//			self.Scope = true
//		elseif CF == 0 then
//			self.Owner:SetFOV(90,.3)
	end
end

function SWEP:Holster()
	self:EndAttack( false )
	return true
end

function SWEP:OnRemove()
	self:EndAttack( false )
	return true
end


function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end