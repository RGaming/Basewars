/* ======================================
	bigbomb
	the big bomb
   ====================================== */

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 20
	
	local ent = ents.Create( "bigbomb" )
	
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
	
end
/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
//models/dav0r/tnt/tnt.mdl

function ENT:Initialize()
	self.Entity:SetModel("models/props_c17/oildrum001.mdl")
	self.Entity:SetSkin(1)
	self.BombPanel = ents.Create("prop_dynamic_override")
	self.BombPanel:SetModel( "models/weapons/w_c4_planted.mdl" )
	self.BombPanel:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*10+self.Entity:GetAngles():Up()*25)
	self.BombPanel:SetAngles(Angle(0,90,90))
	self.BombPanel:SetParent(self.Entity)
	self.BombPanel:SetSolid(SOLID_NONE)
	//self.BombPanel:PhysicsInit(SOLID_NONE)
	self.BombPanel:SetMoveType(MOVETYPE_NONE)
	
	self.BombPanel2 = ents.Create("prop_dynamic_override")
	self.BombPanel2:SetModel( "models/dav0r/tnt/tnt.mdl" )
	self.BombPanel2:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*-6+self.Entity:GetAngles():Right()*-12+self.Entity:GetAngles():Up()*15)
	self.BombPanel2:SetAngles(Angle(0,45,0))
	self.BombPanel2:SetParent(self.Entity)
	self.BombPanel2:SetSolid(SOLID_NONE)
	//self.BombPanel2:PhysicsInit(SOLID_NONE)
	self.BombPanel2:SetMoveType(MOVETYPE_NONE)
	
	self.BombPanel3 = ents.Create("prop_dynamic_override")
	self.BombPanel3:SetModel( "models/dav0r/tnt/tnt.mdl" )
	self.BombPanel3:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*-6+self.Entity:GetAngles():Right()*12+self.Entity:GetAngles():Up()*15)
	self.BombPanel3:SetAngles(Angle(0,-45,0))
	self.BombPanel3:SetParent(self.Entity)
	self.BombPanel3:SetSolid(SOLID_NONE)
	//self.BombPanel3:PhysicsInit(SOLID_NONE)
	self.BombPanel3:SetMoveType(MOVETYPE_NONE)
	
	
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.Armed = false
	self.Time = CurTime()
	self.LastUsed = CurTime()
	local ply = self.Owner
	ply:GetTable().maxBigBombs=ply:GetTable().maxBigBombs + 1
	self.Arming = 50
	self.Disarming = 60
	self.Tick = 0
	util.PrecacheSound("weapons/c4/c4_beep1.wav")
	util.PrecacheSound("weapons/c4/c4_disarm.wav")
	util.PrecacheSound("weapons/c4/c4_explode1.wav")
	util.PrecacheSound("weapons/c4/c4_exp_deb1.wav")
	self.Entity:SetNWBool("armed", false)
end

function ENT:Think()
	if (ValidEntity(self.Owner)==false) then
		self.Entity:Remove()
	end
	if (self.Armed==true) then
		if self.LastUsed+3<CurTime() && self.Disarming<60 then
			self.Disarming=self.Disarming+1
			self.Entity:SetColor(self.Disarming*4, self.Disarming*4, self.Disarming*4, 255)
		end
		self.Entity:Beep()
		if (self.Time<CurTime()+5) then
			self.Entity:NextThink(CurTime()+0.125)
		elseif (self.Time<CurTime()+30) then
			self.Entity:NextThink(CurTime()+0.25)
		elseif (self.Time<CurTime()+60) then
			self.Entity:NextThink(CurTime()+0.5)
		else
			self.Entity:NextThink(CurTime()+1)
		end
		return true
	end
end

function ENT:OnRemove()
	timer.Destroy(tostring(self.Entity) .. "goboom")
	timer.Destroy(tostring(self.Entity) .. "checkpropshit")
	timer.Destroy(tostring(self.Entity) .. "checkpropshit2")
	timer.Destroy(tostring(self.Entity) .. "checkblast" )
end

function ENT:PhysicsCollide( data, physobj )
	
end 
function ENT:Touch()
end
function ENT:PhysicsUpdate()
end
function ENT:HitShit()
	self.Entity:GetPhysicsObject():Wake()
	self.DidHit = true
end
function ENT:Beep()
	self.Entity:EmitSound(Sound("weapons/c4/c4_beep1.wav"))
end
function ENT:Explode()
	// shield slayer
	for k,v in pairs(player.GetAll()) do
		if v:IsPlayer() && v:GetPos():Distance(self.Entity:GetPos())<1024 &&v:GetNWBool("shielded")==true then
			v:SetNWBool("shielded", false)
			v:GetTable().Shieldon = false
			Notify(v, 1, 3, "The force of the Big Bomb shattered your shield!")
		end
	end
	util.BlastDamage( self.Entity, self.Owner, self.Entity:GetPos(), 1536, 2000 )
	// thanks to Fatal Muffin for Cinematic Explosions! your effect is made of win.
	local effectdata = EffectData()
		effectdata:SetStart(Vector(0,0,90))
		effectdata:SetOrigin(self.Entity:GetPos())
		effectdata:SetScale(3)
	util.Effect("cinematicexplosion", effectdata)
	self.Entity:EmitSound(Sound("weapons/c4/c4_explode1.wav"))
	self.Entity:EmitSound(Sound("weapons/c4/c4_exp_deb1.wav"))
	
	local owners,props = self.Entity:FindBreakables()
	for k, v in pairs(player.GetAll()) do
		local uid = v:UniqueID()
		local propnum = tonumber(owners[uid])
		if (propnum==nil) then propnum = 0 end
		if (tonumber(propnum)>0) then
			Notify(player.GetByUniqueID(uid), 1, 3, "A bigbomb has destroyed " .. tostring(owners[uid]) .. " of your props!")
			player.GetByUniqueID(uid):PrintMessage(HUD_PRINTTALK, "A bigbomb has destroyed " .. tostring(owners[uid]) .. " of your props!")
		end
	end
	for k, v in pairs(props) do 
		local class = v:GetClass()
		if (class=="prop_physics_multiplayer" || class=="prop_physics_respawnable" || class=="prop_physics" || class=="phys_magnet" || class=="gmod_spawner" || class=="gmod_wheel" || class=="gmod_thruster" || class=="gmod_button" || class=="sent_keypad" || class=="auto_turret") then
			local entowner = player.GetByUniqueID(v:GetVar("PropProtection"))
			if (ValidEntity(entowner)) then
				entowner:GetTable().shitweldcount=entowner:GetTable().shitweldcount+1
				entowner:SetNWBool("shitwelding", true)
				// keep the mingebag that just got bomb raped from spawning anything for the next minute.
				timer.Destroy(tostring(v) .. "unweldamage")
				timer.Create(tostring(v) .. "unweldamage", 60, 1, WeldControl, v, player.GetByUniqueID(v:GetVar("PropProtection")))
			end
			v:Remove()
		end
	end
	// lets make it unique from other bombs, and make this take a giant shit all over where it just exploded.
	for i=0, 15, 1 do
		local bomblet = ents.Create("bigbomb_fragment")
		local randpos = Vector(math.random(-5,5), math.random(-5,5), math.random(0,5))
		bomblet.Owner = self.Owner
		bomblet:SetPos(self.Entity:GetPos()+randpos)
		bomblet:Spawn()
		bomblet:Activate()
		bomblet:GetPhysicsObject():SetVelocity(randpos*65)
	
	end 
	
	// this is only here, to just entirely ruin anything that takes damage that would be within blast, no matter whats in the way
	local pos = self.Entity:GetPos()
	
	local exp = ents.Create("env_physexplosion")
		exp:SetKeyValue("magnitude", 9999)
		exp:GetTable().attacker = self.Owner
		exp:SetKeyValue("radius", 1536)
		exp:SetPos(pos)
	exp:Spawn()
	exp:SetOwner(self.Owner)
	exp:Fire("explode","",0)
	
	
	self.Entity:Remove()
end

function ENT:Use(activator,caller)
	if self.LastUsed>CurTime() then return end
	
	if (self.Armed) then
		if (self.LastUsed+0.3>CurTime() && self.Disarming==60) then
			self.LastUsed = CurTime()+0.1
		else
			self.LastUsed = CurTime()+0.1
			self.Disarming = self.Disarming-1
			if activator:GetTable().Tooled && self.Tick==1 then
				self.Disarming = self.Disarming-1
			end
			if self.Tick==1 then self.Tick=0 else self.Tick=1 end
			self.Entity:SetColor(self.Disarming*4, self.Disarming*4, self.Disarming*4, 255)
			if (self.Disarming%5==0) then
				self.Entity:Beep()
			end
			if (self.Disarming<=0) then
				Notify(activator,1,3, "Bomb defused!")
				Notify(self.Owner,1,3, "Bomb has been defused.")
				self.Entity:EmitSound(Sound("weapons/c4/c4_disarm.wav"))
				self.Entity:Remove()
			end
		end
	else
		if (self.LastUsed+0.3<CurTime()) then
			self.LastUsed = CurTime()-0.1
			self.Arming = 50
		end
		self.LastUsed = CurTime()+0.1
		self.Arming = self.Arming-1
		if (self.Arming%5==0) then
			self.Entity:Beep()
		end
		if (self.Arming<=0) then
			self.Entity:Armbomb(activator)
		end
	end
end

function ENT:Armbomb(planter)
	// make damn sure the owner of the bomb isnt just gonna wall it off to keep people from defusing.
	if (self.Entity:CheckPropFaggotry()==false) then
		// self.Entity:DropToFloor()
		self.Entity:GetPhysicsObject():EnableMotion(false)
		self.Armed = true
		self.Entity:SetNWBool("armed", true)
		self.Time = CurTime()+120
		self.Entity:SetNWFloat("goofytiem",self.Time)
		self.Arming = 50

		local owners,props = self.Entity:FindBreakables()
		for k, v in pairs(player.GetAll()) do
			local uid = v:UniqueID()
			local propnum = tonumber(owners[uid])
			if (propnum==nil) then propnum = 0 end
			if (tonumber(propnum)>0) then
				Notify(player.GetByUniqueID(uid), 1, 3, "A bigbomb has been planted near " .. tostring(owners[uid]) .. " of your props!")
				player.GetByUniqueID(uid):PrintMessage(HUD_PRINTTALK, "A bigbomb has been planted near " .. tostring(owners[uid]) .. " of your props!")
			end
		end
		timer.Create( tostring(self.Entity) .. "checkpropshit", 5, 18, self.PropCheck, self)
		//timer.Create( tostring(self.Entity) .. "checkpropshit2", 30, 5, self.PropCheck, self)
		timer.Create( tostring(self.Entity) .. "checkblast", 89, 1, self.PropCheck, self)
		timer.Create( tostring(self.Entity) .. "checkblast", 119, 1, self.PropCheck, self)
		timer.Create( tostring(self.Entity) .. "goboom", 120, 1, self.Explode, self)
		Notify(planter, 1, 3, "Bomb has been planted.")
	else
		self.Arming = 50
		Notify(self.Owner, 4, 3, "Get your props away from the bomb for it to be usable.")
		Notify(planter, 4, 3, "bomb owner's props are too close.")
	end
end

function ENT:CheckPropFaggotry()
	local propwallingbitch = false
	for k, v in pairs(ents.FindInSphere( self.Entity:GetPos(), 1536) ) do
		if (player.Owner!=false) then
			local entowner = player.GetByUniqueID(v:GetVar("PropProtection"))
			if self.Owner==entowner then
				// were going through all this, so that some mingebag does not plant a bomb,
				// and then block the bomb with a prop to keep people from defusing it.
				propwallingbitch = true
			end
		end
	end
	return propwallingbitch
end

function ENT:PropCheck()
	if (self.Entity:CheckPropFaggotry()==true) then
		Notify(self.Owner,1,3, "Your props are too close, Bomb will automatically disarm.")
		self.Entity:EmitSound(Sound("weapons/c4/c4_disarm.wav"))
		self.Entity:GetPhysicsObject():EnableMotion(true)
		self.Armed = false
		self.Entity:SetNWBool("armed", false)
		self.Time = false
		self.Entity:SetNWFloat("goofytiem","")
	timer.Destroy(tostring(self.Entity) .. "goboom")
	timer.Destroy(tostring(self.Entity) .. "checkblast" )
	end
end

function ENT:FindBreakables()
	local owners = {}
	local props = ents.FindInSphere(self.Entity:GetPos(), 512)
	for k, v in pairs(props) do
		local class = v:GetClass()
		if (class=="prop_physics_multiplayer" || class=="prop_physics_respawnable" || class=="prop_ragdoll"  || class=="prop_physics" || class=="phys_magnet" || class=="gmod_spawner" || class=="gmod_wheel" || class=="gmod_thruster" || class=="gmod_button" || class=="auto_turret") then
			local ownerid = v:GetVar("PropProtection")
			if (ownerid!=nil && ownerid!=false) then
				if (owners[ownerid]==nil) then
					owners[ownerid]=0
				end
				owners[ownerid] = owners[ownerid]+1
			end
		end
	end
	return owners,props
end

function ENT:OnRemove()
	local ply = self.Owner
	if ValidEntity(ply) then
		ply:GetTable().maxBigBombs=ply:GetTable().maxBigBombs - 1
	end
end

function ENT:UpdateTransmitState() 
	return TRANSMIT_ALWAYS
end