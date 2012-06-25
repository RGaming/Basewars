/* ======================================
	AUTO_TURRET/gun
	gun attachment
   ====================================== */

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.Entity:SetModel( "models/weapons/w_smg1.mdl" )
	// self.Entity:SetModel( "models/airboatgun.mdl" )
	//self.Entity:PhysicsInit( SOLID_NONE )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	//self.Entity:DrawShadow( false )
	local headshot = ents.Create("info_target")
	self.Aimtarg = headshot
	self.Firing 	= false
	self.NextShot 	= 0
	self.MaxRange = 1000
	self.SawShit = 0
	self.Beeptime = 0
	util.PrecacheSound("buttons/blip2.wav")
	
end

/*---------------------------------------------------------
	Name: FireShot

	Fire a bullet.
---------------------------------------------------------*/

function ENT:FireShot(targ)
	// bullet is just for effect, were gonna railgun this fucker.
	if ( self.NextShot > CurTime() || self.Body:GetNWBool("ison")==false) then return end
	
	self.NextShot = CurTime() + 0.17
	
	// Make a sound if you want to.
	self.Entity:EmitSound( "Weapon_Pistol.Single" )

	// Get the muzzle attachment (this is pretty much always 1)
	local Attachment = self.Entity:GetAttachment( 1 )
	// Msg(Attachment .. "\n")
	// Get the shot angles and stuff.
	local shootOrigin = Attachment.Pos
	local shootAngles = self.Entity:GetAngles()
	local shootDir = shootAngles:Forward()
	if (self.Body:GetNWInt("upgrade")>0) then
		targ:TakeDamage(15, self.Entity:GetOwner(), self.Entity)
	else
		targ:TakeDamage(10, self.Entity:GetOwner(), self.Entity)
	end
	// Shoot a bullet
	local bullet = {}
		bullet.Num 		= 1
		bullet.Src 		= shootOrigin
		bullet.Dir 		= shootDir
		bullet.Spread 		= Vector( 0, 0, 0 )
		bullet.Tracer		= 1
		bullet.TracerName 	= "AirboatGunHeavyTracer"
		bullet.Force		= 50
		bullet.Damage		= 0
		bullet.Attacker 	= self.Entity:GetOwner()		
	self.Entity:FireBullets( bullet )
	
	// Make a muzzle flash
	local effectdata = EffectData()
		effectdata:SetOrigin( shootOrigin )
		effectdata:SetAngle( shootAngles )
		effectdata:SetScale( 1 )
	util.Effect( "MuzzleEffect", effectdata )
	
end

function ENT:Think()
	if (self.Body:IsBuilt()) then
		local nearesttarg = self.Entity
		local Attachment = self.Entity:GetAttachment( 1 )
		local shootOrigin = Attachment.Pos
		for k, v in pairs( ents.FindInSphere(self.Entity:GetPos(), self.MaxRange*1.25)) do
			// if theres a spawn point, DONT FUCKING FIRE
			if (v:GetClass() == "info_player_deathmatch" || v:GetClass() == "info_player_rebel" || v:GetClass() == "info_player_combine" || v:GetClass() == "gmod_player_start" || v:GetClass() == "info_player_start" || v:GetClass() == "info_player_allies" || v:GetClass() == "info_player_axis" || v:GetClass() == "info_player_counterterrorist" || v:GetClass() == "info_player_terrorist") then
				nearesttarg = self.Entity
				return;
			end
			// only shoot at valid targets that could actually get hit, and dont shoot at any player matching any "ally" string
			local isally = false
			if v:IsPlayer() && self.Entity:GetOwner()!=v then
				if self.Entity:GetOwner():IsAllied(v) then
					isally = true
				end
			end
			/*
			if v:IsPlayer() && self.Entity:GetOwner()!=v then
				for l, w in pairs(self.Body:GetTable().AllyTable) do
					if ValidEntity(w) && w==v then
						isally = true
					end
				end
			end
			*/
			/*if ((string.find(string.lower(v:GetName()), string.lower(self.Body:GetNWString("ally"))) != nil && self.Body:GetNWString("ally")!="") || (string.find(string.lower(v:GetNWString("job")), string.lower(self.Body:GetNWString("jobally"))) != nil && self.Body:GetNWString("jobally")!="")) then
				isally = true
			end*/
			local istarget = false
			if ((string.find(string.lower(v:GetName()), string.lower(self.Body:GetNWString("enemytarget"))) != nil && self.Body:GetNWString("enemytarget")!="")) then
				istarget = true
			end
			if ( (((v:GetClass()!="player" || !isally || istarget) && self.Body:GetNWBool("hatetarget")==false) || (v:GetClass()!="player" || (istarget && self.Body:GetNWBool("hatetarget")==true))) && ( (v:GetClass()=="player" && self.Entity:GetOwner()!=v) || (v:IsNPC() && v:GetClass() != "npc_heli_avoidsphere" && v:GetClass() != "npc_template_maker" &&  v:GetClass() != "npc_maker" && v:GetClass() != "npc_vehicledriver" && v:GetClass() != "npc_launcher" && v:GetClass() != "npc_heli_nobomb" && v:GetClass() != "npc_heli_avoidsphere" && v:GetClass() != "npc_heli_avoidbox" && v:GetClass() != "npc_furniture" && v:GetClass() != "npc_enemyfinder" && v:GetClass() != "npc_missiledefense" && v:GetClass() != "npc_bullseye" && v:GetClass() != "npc_apcdriver" && v:GetClass() != "monster_generic" && v:GetClass() != "info_npc_spawn_destination" && v:GetClass() != "generic_actor" && v:GetClass() != "cycler_actor" && v:GetClass() != "npc_antion_template_maker" && v:GetClass() != "npc_cranedriver" && v:GetClass() != "npc_sniper") ) ) then
				
				local tracerun = false
				local traceshit = {}
					traceshit.start = self.Entity:GetPos()
					traceshit.endpos = v:GetPos()
					traceshit.filter = { self.Body, v, self.Entity }
					// traceshit.mask = COLLISION_GROUP_PLAYER
				traceshit = util.TraceLine(traceshit)
				if (ValidEntity(traceshit.Entity) && !traceshit.HitWorld) then
					if (traceshit.Entity:GetVar("PropProtection")!=false) then
						local entowner = player.GetByUniqueID(traceshit.Entity:GetVar("PropProtection"))
						if (entowner==v) then tracerun=true end
					elseif (traceshit.Fraction==1) then tracerun=true end
				elseif (!traceshit.HitWorld) then tracerun = true end
				
				local tracehrun = false
				local traceshith = {}
					traceshith.start = self.Entity:GetPos()
					traceshith.endpos = v:GetPos()+Vector(0, 0, 30)
					traceshith.filter = { self.Body, v, self.Entity }
					// traceshith.mask = COLLISION_GROUP_PLAYER
				traceshith = util.TraceLine(traceshith)
				if (ValidEntity(traceshith.Entity) && !traceshith.HitWorld) then
					if (traceshith.Entity:GetVar("PropProtection")!=false) then
						local entowner = player.GetByUniqueID(traceshith.Entity:GetVar("PropProtection"))
						if (entowner==v) then tracehrun=true end
					elseif (traceshith.Fraction==1) then tracehrun=true end
				elseif (!traceshith.HitWorld) then  tracehrun = true end
				
				local tracebrun = false
				local traceshitb = {}
					traceshitb.start = self.Body:GetPos()+Vector(0,0,5)
					traceshitb.endpos = v:GetPos()
					traceshitb.filter = { self.Body, v, self.Entity }
					// traceshitb.mask = COLLISION_GROUP_PLAYER
				traceshitb = util.TraceLine(traceshitb)
				if (ValidEntity(traceshitb.Entity) && !traceshitb.HitWorld) then
					if (traceshitb.Entity:GetVar("PropProtection")!=false) then
						local entowner = player.GetByUniqueID(traceshitb.Entity:GetVar("PropProtection"))
						if (entowner==v) then tracebrun=true end
					elseif (traceshitb.Fraction==1) then tracebrun=true end
				elseif (!traceshitb.HitWorld) then  tracebrun = true end
				
				local tracebhrun = false
				local traceshitbh = {}
					traceshitbh.start = self.Body:GetPos()+Vector(0,0,5)
					traceshitbh.endpos = v:GetPos()+Vector(0, 0, 30)
					traceshitbh.filter = { self.Body, v, self.Entity }
					// traceshitbh.mask = COLLISION_GROUP_PLAYER
				traceshitbh = util.TraceLine(traceshitbh)
				if (ValidEntity(traceshitbh.Entity) && !traceshitbh.HitWorld) then
					if (traceshitbh.Entity:GetVar("PropProtection")!=false) then
						local entowner = player.GetByUniqueID(traceshitbh.Entity:GetVar("PropProtection"))
						if (entowner==v) then tracebhrun=true end
					elseif (traceshitbh.Fraction==1) then tracebhrun=true end
				elseif (!traceshitbh.HitWorld) then  tracebhrun = true end
				
					local tracewrun = false
				local traceshitw = {}
					traceshitw.start = self.Entity:GetPos()
					traceshitw.endpos = v:GetPos()
					traceshitw.filter = { self.Body, v, self.Entity }
					traceshitw.mask = COLLISION_GROUP_PLAYER
				traceshitw = util.TraceLine(traceshitw)
				if (!traceshitw.HitWorld) then
					tracewrun=true
				end
				
				local tracewhrun = false
				local traceshitwh = {}
					traceshitwh.start = self.Entity:GetPos()
					traceshitwh.endpos = v:GetPos()
					traceshitwh.filter = { self.Body, v, self.Entity }
					traceshitwh.mask = COLLISION_GROUP_PLAYER
				traceshitwh = util.TraceLine(traceshitwh)
				if (!traceshitwh.HitWorld) then
					tracewhrun=true
				end
				
				// if the targeted jackass tries to block the turret, shoot them anyway, otherwise dont.
				if ( ( self.Entity:GetPos():Distance(v:GetPos()) < self.Entity:GetPos():Distance(nearesttarg:GetPos()) && (tracerun==true || tracehrun==true) && (tracebrun==true || tracebhrun==true)  && (tracewrun==true || tracewhrun==true) && v:Health()>0) || nearesttarg == self.Entity && (tracerun==true || tracehrun==true) && (tracebrun==true || tracebhrun==true)  && (tracewrun==true || tracewhrun==true) && v:Health()>0) then
					nearesttarg = v
				end
			end
		end
		// the very thing the turret is trying to kill.
		if (nearesttarg==self.Entity) then
			self.SawShit = 0
		else
			local enemy = nearesttarg
			if( self.Firing ) then
				if (self.SawShit>=2) then
					self:FireShot(nearesttarg)
				else
					self.SawShit = self.SawShit + 1
					self.Entity:EmitSound(Sound("buttons/blip2.wav"))
				end
			end
			local pos = self.Entity:GetPos()
			local targpos = enemy:GetPos()
			local targdist = pos:Distance(targpos)
			local targ = enemy
			if (targdist<self.MaxRange) then
				local targhead = 10
				if (targ:GetClass() == "player" || targ:GetClass() == "npc_zombie" || targ:GetClass() == "npc_vortigaunt" || targ:GetClass() == "npc_stalker" || targ:GetClass() == "npc_poisonzombie" || targ:GetClass() == "npc_mossman" || targ:GetClass() == "npc_monk" || targ:GetClass() == "npc_metropolice" || targ:GetClass() == "npc_kleiner" || targ:GetClass() == "npc_gman" || targ:GetClass() == "npc_eli" || targ:GetClass() == "npc_dog" || targ:GetClass() == "npc_combine_s" || targ:GetClass() == "npc_citizen" || targ:GetClass() == "npc_breen" || targ:GetClass() == "npc_barney" || targ:GetClass() == "npc_antlionguard" || targ:GetClass() == "npc_alyx") then
					targhead = 40
				else
					if (targ:GetClass() == "npc_antion" || targ:GetClass() == "npc_fastzombie" ) then
						targhead = 30
					end
					if (targ:GetClass() == "npc_strider") then
						targhead = 80
					end
				end
				self.Aimtarg:SetPos(targ:GetPos() + Vector(0,0,targhead) )
				self.Entity:PointAtEntity(self.Aimtarg)
				if (self.SawShit>=2 || (self.SawShit>=1 && self.Body:GetNWInt("upgrade")==2)) then
					self:FireShot(nearesttarg)
				else
					self.SawShit = self.SawShit+1
					self.Entity:EmitSound(Sound("buttons/blip2.wav"))
				end
			end
		end
		// just a friendly tick every 20 seconds, just to let everyone know its there and active
		if (self.Beeptime>=60) then
			self.Beeptime = 0
			self.Entity:EmitSound(Sound("buttons/blip2.wav"))
		elseif (self.Body:GetNWBool("ison")) then
			self.Beeptime = self.Beeptime + 1
		end
	else
		self.Entity:PointAtEntity(self.Body)
	end
	if self.Body:IsPowered() then
		self.Entity:NextThink(CurTime()+0.34)
	else
		// underpowered turrets only fire/scans once every 2 seconds.
		self.Entity:NextThink(CurTime()+2)
	end
	return true
end
function ENT:OnRemove()
	self.Aimtarg:Remove()
end

function ENT:OnTakeDamage(dmg)
	self.Body:SetNWInt("damage",self.Body:GetNWInt("damage") - dmg:GetDamage())
	if(self.Body:GetNWInt("damage") <= 0) then
		self.Body:Explode()  
		self.Body:Remove()
		
	end
end