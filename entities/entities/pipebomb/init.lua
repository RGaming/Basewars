// shamelessly raped cse grenade

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()

	self.Entity:SetModel("models/props_lab/pipesystem03b.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( false )
	
	// Don't collide with the player
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end
	// because pipe bombs are unreliable
	self.timer = CurTime() + 2 + math.random()
	self.solidify = CurTime() + 1
end

function ENT:Think()
	if (ValidEntity(self.Owner)==false) then
		self.Entity:Remove()
	end
	// so that the player who threw it doesnt collide with it the second they throw it.
	if (self.solidify<CurTime()) then
		self.SetOwner(self.Entity)
	end
	// not only have it be unreliable, but its easy to avoid.
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos()+self.Entity:GetAngles():Right()*8)
		effectdata:SetMagnitude( 1 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 1 )
	util.Effect( "Sparks", effectdata )
	util.Effect( "Sparks", effectdata )
	util.Effect( "Sparks", effectdata )
	if self.timer < CurTime() then
		util.BlastDamage( self.Entity, self.Owner, self.Entity:GetPos(), 320, 70 )
	
		local effectdata = EffectData()
			effectdata:SetStart(self.Entity:GetPos())
			effectdata:SetOrigin(self.Entity:GetPos())
			effectdata:SetScale(1)
		util.Effect("HelicopterMegaBomb", effectdata)
		
		local effectdata2 = EffectData()
			effectdata2:SetStart(self.Entity:GetPos())
			effectdata2:SetOrigin(self.Entity:GetPos())
			effectdata2:SetScale(1)
		util.Effect("Explosion", effectdata2)
	
		self.Entity:EmitSound(Sound("weapons/hegrenade/explode"..math.random(3,5)..".wav"))
		self.Entity:Remove()
	end
end

/*---------------------------------------------------------
   Name: OnTakeDamage
   Desc: Entity takes damage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )

/*
	Msg( tostring(dmginfo) .. "\n" )
	Msg( "Inflictor:\t" .. tostring(dmginfo:GetInflictor()) .. "\n" )
	Msg( "Attacker:\t" .. tostring(dmginfo:GetAttacker()) .. "\n" )
	Msg( "Damage:\t" .. tostring(dmginfo:GetDamage()) .. "\n" )
	Msg( "Base Damage:\t" .. tostring(dmginfo:GetBaseDamage()) .. "\n" )
	Msg( "Force:\t" .. tostring(dmginfo:GetDamageForce()) .. "\n" )
	Msg( "Position:\t" .. tostring(dmginfo:GetDamagePosition()) .. "\n" )
	Msg( "Reported Pos:\t" .. tostring(dmginfo:GetReportedPosition()) .. "\n" )	// ??
*/

end


/*---------------------------------------------------------
   Name: Use
---------------------------------------------------------*/
function ENT:Use( activator, caller, type, value )
end


/*---------------------------------------------------------
   Name: StartTouch
---------------------------------------------------------*/
function ENT:StartTouch( entity )
end


/*---------------------------------------------------------
   Name: EndTouch
---------------------------------------------------------*/
function ENT:EndTouch( entity )
end


/*---------------------------------------------------------
   Name: Touch
---------------------------------------------------------*/
function ENT:Touch( entity )
end
