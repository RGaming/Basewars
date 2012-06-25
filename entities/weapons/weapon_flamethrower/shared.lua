if SERVER then
	include('particletrace.lua')
end

local sndAttackLoop = Sound("fire_large")
local sndSprayLoop = Sound("ambient.steam01")
local sndAttackStop = Sound("ambient/_period.wav")
local sndIgnite = Sound("PropaneTank.Burst")

if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
	SWEP.HoldType			= "rpg"

end

if ( CLIENT ) then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 64
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	
	
	SWEP.PrintName			= "Flamethrower"			
	SWEP.Author			= "Teta_Bonita"
	SWEP.Slot			= 4
	SWEP.SlotPos			= 11
	SWEP.IconLetter 		= "a"
	surface.CreateFont( "HalfLife2", ScreenScale( 60 ), 500, true, true, "HL2SelectIcons" )
	killicon.AddFont("weapon_flamethrower","HL2MPTypeDeath","/",Color(200,125,0,255))
	killicon.AddFont("env_fire","HL2MPTypeDeath","C",Color(200,125,0,255))
	
end

SWEP.Author			= "Teta_Bonita"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "Aim at enemy"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/v_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 4
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.05

SWEP.Primary.ClipSize		= 250
SWEP.Primary.DefaultClip	= 250
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "CombineCannon"

SWEP.Secondary.Recoil			= 0
SWEP.Secondary.Damage			= 3
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0.02
SWEP.Secondary.Delay			= 0.05

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.Upgraded = false

// flamethrower upgrade = hotter flame

function SWEP:Initialize()

	if ( SERVER ) then
		self:SetWeaponHoldType( self.HoldType )
	end
	
	self.EmittingSound = false
	
	util.PrecacheModel("models/player/charple01.mdl")

end

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	self:StopSounds()
end

function SWEP:Think()

	if self.Owner:KeyReleased(IN_ATTACK) or self.Owner:KeyReleased(IN_ATTACK2) then
		self:StopSounds()
	end

end

function SWEP:Upgrade(bool)
	self.Weapon:SetNWBool("upgraded",bool)
end

function SWEP:PrimaryAttack()

	local curtime = CurTime()
	local InRange = false

	self.Weapon:SetNextSecondaryFire( curtime + 1 )
	self.Weapon:SetNextPrimaryFire( curtime + self.Primary.Delay )
	
	if not self:CanPrimaryAttack() or self.Owner:WaterLevel() > 1 then 
	self:StopSounds() 
	return end
	
	if not self.EmittingSound then
		self.Weapon:EmitSound(sndAttackLoop)
		self.EmittingSound = true
	end
	
	self:TakePrimaryAmmo(1)
	
	--if SERVER then
		local PlayerVel = self.Owner:GetVelocity()
		local PlayerPos = self.Owner:GetShootPos()
		local PlayerAng = self.Owner:GetAimVector()
		
		local trace = {}
		trace.start = PlayerPos
		trace.endpos = PlayerPos + (PlayerAng*1024)
		trace.filter = self.Owner
		
		local traceRes = util.TraceLine(trace)
		local hitpos = traceRes.HitPos
		
		local vel = 0
		// add their own velocity to it to ensure that people who are running away are burned too.
		if ValidEntity(traceRes.Entity) then
			vel = traceRes.Entity:GetVelocity():Distance(Vector(0,0,0))
		end
		local jetlength = (hitpos - PlayerPos):Length()+vel
		if jetlength > 512 then jetlength = 512 end
		if jetlength < 6 then jetlength = 6 end
		if self.Owner:Alive() then
			local effectdata = EffectData()
			effectdata:SetOrigin( hitpos )
			effectdata:SetEntity( self.Weapon )
			effectdata:SetStart( PlayerPos )
			effectdata:SetNormal( PlayerAng )
			effectdata:SetScale( jetlength )
			effectdata:SetAttachment( 1 )
			util.Effect( "flamepuffs", effectdata )
		end

		if self.DoShoot then

			local ptrace = {}
			ptrace.startpos = PlayerPos + PlayerAng:GetNormalized()*16
			local ang = (traceRes.HitPos - ptrace.startpos):GetNormalized()
			ptrace.func = burndamage
			ptrace.movetype = MOVETYPE_FLY
			ptrace.velocity = ang*728 + 0.5*PlayerVel
			ptrace.model = "none"
			ptrace.filter = {self.Owner}
			ptrace.killtime = (jetlength + 16)/ptrace.velocity:Length()
			ptrace.runonkill = false
			ptrace.collisionsize = 16
			ptrace.worldcollide = true
			ptrace.owner = self.Owner
			ptrace.name = "flameparticle"
			if SERVER then
				ParticleTrace(ptrace)
			end
			self.DoShoot = false
		else
			self.DoShoot = true
		end
	--end
end

function SWEP:SecondaryAttack()
	// unfortunately, spraying too much of this causes server crash. and since theres multiple
	// ways for people to use this to lame, its just getting removed.
	/*
	local curtime = CurTime()

	self.Weapon:SetNextSecondaryFire( curtime + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( curtime + 1 )
	
	if !self:CanSecondaryAttack() || self.Owner:WaterLevel() > 1 || self.Weapon:Clip1()<1 then 
		self:StopSounds() 
	return end
	
	if not self.EmittingSound then
		self.Weapon:EmitSound(sndSprayLoop)
		self.EmittingSound = true
	end
	
	self:TakePrimaryAmmo(1)
	
	local PlayerVel = self.Owner:GetVelocity()
	local PlayerPos = self.Owner:GetShootPos()
	local PlayerAng = self.Owner:GetAimVector()
	
	local trace = {}
	trace.start = PlayerPos
	trace.endpos = PlayerPos + (PlayerAng*4096)
	trace.filter = self.Owner
	
	local traceRes = util.TraceLine(trace)
	local hitpos = traceRes.HitPos
	
	local jetlength = (hitpos - PlayerPos):Length()
	
		if jetlength > 568 then 
		jetlength = 568
		elseif self.DoShoot then
	
		local normal = traceRes.HitNormal

			if traceRes.HitNonWorld then
				local hitent = traceRes.Entity
				local enttype = hitent:GetClass()
				if hitent:IsNPC() or hitent:IsPlayer() or enttype == "prop_physics" or enttype == "prop_vehicle" or hitent:GetTable().Structure then
					local hitenttable = hitent:GetTable()
					hitenttable.FuelLevel = hitenttable.FuelLevel or 0
					hitenttable.FuelLevel = hitenttable.FuelLevel + 1
					util.Decal("BeerSplash", hitpos + normal, hitpos - normal )
				end
			elseif Vector(0,0,1):Dot(normal) > 0.25 then --Garry's idea XD
				if SERVER then
					local fire = ents.Create("sent_firecontroller") --Make an ignitable fire.
					fire:SetPos(hitpos + normal*16)
					// fake owner
					//fire:GetTable().attacker = self.Owner
					fire:SetOwner(self.Owner)
					fire:Spawn()
				end
				util.Decal("BeerSplash", hitpos + normal, hitpos - normal )
			end
			
			if SERVER then
				for key,found in pairs(ents.FindInSphere(hitpos,32)) do
					local foundname = found:GetName()
					
					if found:GetClass() == "entityflame"
					or found:GetName() == "BurningFire"
					or found:GetName() == "flameparticle" then --If we hapen to be blowing napalm near an open flame...
					
					explode(self.Owner,PlayerPos) --Then blow ourselves up.
					self.Owner:TakeDamage(300,self.Owner,self.Weapon)

						for i=1,7 do --Spawn some fires near our charred, lifeless corpse.
							local fire = ents.Create("env_fire")
							local randvec = Vector(math.random(-100,100),math.random(-100,100),0)

							fire:SetKeyValue("StartDisabled","0")
							fire:SetKeyValue("health",math.random(29,31))
							fire:SetKeyValue("firesize",math.random(64,72))
							fire:SetKeyValue("fireattack","2")
							fire:SetKeyValue("ignitionpoint","0")
							fire:SetKeyValue("damagescale","35")
							fire:SetKeyValue("spawnflags",2 + 4 + 128)
							
							fire:SetPos(PlayerPos + randvec)
							fire:SetOwner(self.Owner)
							fire:Spawn()
							fire:Fire("StartFire","","0")
						end
					
					break
					
					end
			
				end
				
			end
			
		self.DoShoot = false
		else
		self.DoShoot = true
		end

	if jetlength < 6 then jetlength = 6 end

	local effectdata = EffectData()
	effectdata:SetEntity( self.Weapon )
	effectdata:SetStart( PlayerPos )
	effectdata:SetNormal( PlayerAng )
	effectdata:SetScale( jetlength )
	effectdata:SetAttachment( 1 )
	util.Effect( "gaspuffs", effectdata )
	*/
end


HumanModels = {

"models/Humans/",
"models/player/",
"models/zombie",
"[Pp]olice.mdl",
"[Ss]oldier",
"[Aa]lyx.mdl",
"[Bb]arney.mdl",
"[Bb]reen.mdl",
"[Ee]li.mdl",
"[Mm]onk.mdl",
"[Kk]leiner.mdl",
"[Mm]ossman.mdl",
"[Oo]dessa.mdl",
"[Gg]man"

}

function IsHumanoid(ent)

	if ent:IsPlayer() then return true end

	local entmodel = ent:GetModel()

	for k,model in pairs(HumanModels) do
		if string.find(entmodel,model) ~= nil then
		return true end
	end
	
	return false
	
end

function explode(ent,pos)

	pos.z = pos.z - 64

	Immolate(ent,pos)
	
	local boom = ents.Create("env_explosion")
	boom:SetKeyValue("iMagnitude","60")
	boom:SetPos(pos)
	boom:SetOwner(ent)
	boom:Spawn()
	
	boom:Fire("Explode","","0")

	local effectdata = EffectData()
	effectdata:SetOrigin( pos )
	util.Effect( "explosion_large", effectdata )
	

end

function Immolate(ent,pos)

	pos = pos or ent:GetPos()


	if SERVER then
		
		if ent:IsPlayer() then
			//ent:Kill()
			BurnPlayer(ent,20,ent,ent:GetWeapon("weapon_flamethrower"))
		else
			ent:SetModel("models/player/charple01.mdl")
			ent:Fire("sethealth","0","0")
		end
	end
	
	local effectdata = EffectData()
	effectdata:SetOrigin( pos )
	util.Effect( "immolate", effectdata )


end

function burndamage(ptres)

	local hitent = ptres.activator
	if hitent:WaterLevel() > 0 then return end

	local ttime = ptres.time
	if ttime == 0 then ttime = 0.1 end --Division by zero is bad! D :
	
	local damage = 5
	local isnpc = hitent:IsNPC()
	if isnpc then damage = damage*2 end
	local radius = math.ceil(256*ttime)
	if radius < 16 then radius = 16 end
	

	local healthpercent = 3
	local enthealth = 1
	local enttable = hitent:GetTable()
	
	if isnpc or hitent:IsPlayer() then
		enthealth = hitent:Health()
		healthpercent = math.ceil(enthealth/5)
	end
	local fuel = enttable.FuelLevel
	if fuel and fuel > 0 then
		ptres.caller:EmitSound(sndIgnite)
		enttable.FuelLevel = 0
		local entpos = hitent:GetPos()
		local boompos = entpos
		boompos.z = boompos.z + hitent:BoundingRadius()/2
		local damagemult = 4*fuel
		local radiusmult = radius + fuel
		
		local effectdata = EffectData()
			effectdata:SetOrigin( entpos )
			effectdata:SetEntity( hitent )
			effectdata:SetStart( entpos )
			effectdata:SetNormal( Vector(0,0,1) )
			effectdata:SetScale( 10 )
		util.Effect( "HelicopterMegaBomb", effectdata )
		
		if damagemult < enthealth then
			if hitent:IsPlayer() then
				BurnPlayer(hitent,fuel,ptres.owner,ptres.owner:GetWeapon("weapon_flamethrower"))
			else
				hitent:Ignite(math.random(4,6),0)
			end
			hitent:TakeDamage(damagemult, ptres.owner, ptres.owner:GetWeapon("weapon_flamethrower"))
		elseif IsHumanoid(hitent) then
			Immolate(hitent,entpos)
		else
			//util.BlastDamage(ptres.owner:GetActiveWeapon(), ptres.owner, boompos, radiusmult, damagemult)
			hitent:TakeDamage(damagemult, ptres.owner, ptres.owner:GetWeapon("weapon_flamethrower"))
		
		end
	else
		local weapon = ptres.owner:GetWeapon("weapon_flamethrower")
		if hitent:IsPlayer() then
			hitent:TakeDamage(damage, ptres.owner, weapon)
			BurnPlayer(hitent,1,ptres.owner,weapon)
		else
			hitent:TakeDamage(damage*2, ptres.owner, weapon)
			if !hitent:GetTable().Structure && math.random(0,10)>8 then
				hitent:Ignite(math.random(4,6),0)
			end
		end
		for k,v in pairs(ents.FindInSphere(hitent:GetPos(),32)) do
			if v:GetClass()=="sent_firecontroller" then
				v:StartFire()
			end
		end
	end
end

function DeFlamitize(ply) 
	ply:GetTable().FuelLevel = 0
	if ply:IsOnFire() then
		ply:Extinguish()
	end
end 
hook.Add( "PlayerDeath", "deflame", DeFlamitize )


function SWEP:StopSounds()
	if self.EmittingSound then
		self.Weapon:StopSound(sndAttackLoop)
		self.Weapon:StopSound(sndSprayLoop)
		self.Weapon:EmitSound(sndAttackStop)
		self.EmittingSound = false
	end	
end


function SWEP:Holster()
	self:StopSounds()
	return true
end

function SWEP:OnRemove()
	self:StopSounds()
	return true
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	draw.SimpleText( "a", "HL2SelectIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	
	if (self.Weapon:GetNWBool("upgraded")) then
		draw.SimpleText("K", "CSKillIcons", x + wide-20, y + tall-25, Color(200,200, 200, 255), TEXT_ALIGN_CENTER )
	end
end
