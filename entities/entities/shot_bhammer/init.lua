/* ======================================
	diablo 2 blessed hammer.
	yes, i got THIS bored.
   ====================================== */

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.Entity:SetModel( "models/props_trainstation/trainstation_post001.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetKeyValue("physdamagescale", "9999")
	self.Entity:SetKeyValue("effects", "4")
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self.Entity.CollisionGroup = COLLISION_GROUP_WORLD
	self.Entity:SetMaterial("Models/effects/comball_tape")
	
	self.Hammar = ents.Create("prop_dynamic_override")
	self.Hammar:SetModel("models/props_junk/plasticbucket001a.mdl")
	self.Hammar:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Up()*50)
	self.Hammar:SetAngles(Angle(90,0,0))
	self.Hammar:SetParent(self.Entity)
	self.Hammar:SetSolid(SOLID_NONE)
	self.Hammar:SetMoveType(MOVETYPE_NONE)
	self.Hammar:SetMaterial("Models/effects/comball_tape")
	
	self.Hammar2 = ents.Create("prop_dynamic_override")
	self.Hammar2:SetModel("models/props_junk/plasticbucket001a.mdl")
	self.Hammar2:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Up()*50)
	self.Hammar2:SetAngles(Angle(-90,0,0))
	self.Hammar2:SetParent(self.Entity)
	self.Hammar2:SetSolid(SOLID_NONE)
	self.Hammar2:SetMoveType(MOVETYPE_NONE)
	//self.Hammar2:SetMaterial("models/props_lab/Tank_Glass001")
	self.Hammar2:SetMaterial("Models/effects/comball_tape")
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(false)
	end
	self.DidHit = false
	self.GoofyTiem = CurTime()
	//util.SpriteTrail(self.Entity, 0, Color(200,150,100), false, 16, 1, 2, 1/8.5, "trails/smoke.vmt")
	
	self.Upgraded = false
	self.trueangles = self.Entity:GetAngles()
end

function ENT:Think()
	
	if (ValidEntity(self.Entity:GetOwner())==false || CurTime()-self.GoofyTiem>20) then
		local effectdata = EffectData()
		effectdata:SetStart(self.Entity:GetPos())
		effectdata:SetOrigin(self.Entity:GetPos())
		effectdata:SetScale(1.5)
		util.Effect("cball_bounce", effectdata)
		self.Entity:Fire("kill", "", 0)
		self.Entity:EmitSound(Sound("weapons/explode3.wav"))
		self.Entity:Remove()
	end
	local ang = self.Entity:GetAngles()
	local desang = ang
	desang:RotateAroundAxis(ang:Up(), 20)
	desang:RotateAroundAxis(ang:Right(), 60)
	self.Entity:SetAngles(desang)
	self.trueangles = self.trueangles + Angle(0,30,0)
	self.Entity:GetPhysicsObject():SetVelocity(self.trueangles:Forward()*(150+(CurTime()-self.GoofyTiem)*50))
	local traceshit = {}
		traceshit.start = self.Entity:GetPos()
		traceshit.endpos = self.Entity:GetPos()+self.Entity:GetAngles():Up()*60
		traceshit.filter = { self.Entity, self.Hammar, self.Hammar2, self.Entity:GetOwner() }
	traceshit = util.TraceLine(traceshit)
	if ValidEntity(traceshit.Entity) then
		traceshit.Entity:TakeDamage(80, self.Entity:GetOwner(), self.Entity)
	end
end

function ENT:OnRemove()
end

function ENT:PhysicsCollide( data, physobj )
	data.HitNormal = data.HitNormal*-150
	local start = data.HitPos+data.HitNormal
	local endpos = data.HitPos+data.HitNormal*-1
	util.Decal("Scorch",start,endpos)

	// routed the blowing itself up into the physicsupdate function to prevent the "YOU GONNA GET CRASHED" spam of bullshit and lies.
  	self.DidHit = true
	self.Entity:GetPhysicsObject():SetVelocity(Angle(0,0,0))
end 
function ENT:PhysicsUpdate()
	local traceshit = {}
		traceshit.start = self.Entity:GetPos()
		traceshit.endpos = self.Entity:GetPos()+self.Entity:GetAngles():Up()*60
		traceshit.filter = { self.Entity, self.Hammar, self.Hammar2, self.Entity:GetOwner() }
	traceshit = util.TraceLine(traceshit)
	if ValidEntity(traceshit.Entity) then
		traceshit.Entity:TakeDamage(80, self.Entity:GetOwner(), self.Entity)
	end
	if (self.DidHit == true) then
		local effectdata = EffectData()
		effectdata:SetStart(self.Entity:GetPos())
		effectdata:SetOrigin(self.Entity:GetPos())
		effectdata:SetScale(1.5)
		util.Effect("cball_bounce", effectdata)
		self.Entity:Fire("kill", "", 0)
		self.Entity:EmitSound(Sound("weapons/explode3.wav"))
		self.Entity:Remove()
	end
end

function ENT:Upgrade()
	self.Upgraded = true
end