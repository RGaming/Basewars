/*
	HEY YOU! YOU'RE READING MY CODE.
	LETS TAKE A LITTLE ENGLISH LESSON.
	YOUR = YOUR MOM
	YOU'RE = YOU'RE READING THIS.
	YAR = A PIRATE
	
	:eng101:
*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.StartColor = Color(0, 0, 0)
ENT.EndColor = Color(0, 0, 0)
ENT.LifeTime = 10
ENT.DieTime = 15

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.Entity:SetModel( "models/props_junk/propane_tank001a.mdl" )
	
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	self.Entity:SetUseType(SIMPLE_USE)
	self.Entity:SetAngles( Angle(-180, 0, 0) )
	self.Entity.FuseTime = 2
	
	self.Entity:SetPos( self.Entity:GetPos() + Vector(0, 0, 5) )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake() //Sleep to keep it above the ground a few units, in multiplayer the effects don't show if the point is under ground.
	end
	
	if WireAddon then
		self.Inputs = Wire_CreateInputs( self.Entity, { "Fire", "Start Fuse", "Explode Distance", "Force Explode", "Fuse Time"} )
		self.Outputs = Wire_CreateOutputs(self.Entity, { "Fuse Started", "Launched" })
	end
	
end

/*---------------------------------------------------------
   Name: OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )

	self.Entity:TakePhysicsDamage( dmginfo )

end

function ENT:Launch()

	if(ValidEntity(self.Entity)) then
	
		if(!self.Entity.Fired) then
			
			local phys = self.Entity:GetPhysicsObject()

			if (phys:IsValid()) then
				phys:Wake() //Make sure it's awake. You don't want to miss the show!
			end
			
			local launchtracedata = {}
			launchtracedata.start =	self.Entity:GetPos()
			launchtracedata.endpos = self.Entity:GetUp()*-10000000000000 //Really big number, math.huge not working. (probably shouldn't even use it for this though)
			launchtracedata.filter = self.Entity
			launchtracedata.mask = MASK_PLAYERSOLID_BRUSHONLY
			
			local launchtrace = util.TraceLine(launchtracedata)
	
			if(!self.Entity.OverrideExplodeLength) then
				self.Entity.ExplodeLength = launchtrace.HitPos:Distance(self.Entity:GetPos()) * 0.75
			else
				self.Entity.ExplodeLength = math.Clamp(self.Entity.OverrideExplodeLength, 1, math.huge)
			end
			
			self.Entity.FirePos = self:GetPos()
			self.Entity.Fired = true
			
			
			local firework_ignite_explosion = EffectData()
			firework_ignite_explosion:SetOrigin( self:GetPos() - self:GetUp()*-20 )
			util.Effect( "StunstickImpact", firework_ignite_explosion )	

			local firework_trail = EffectData()
			firework_trail:SetEntity( self )
			firework_trail:SetOrigin( self:GetPos() )
			util.Effect( "firework_trail", firework_trail, true, true )	
			if WireAddon then Wire_TriggerOutput(self.Entity, "Launched", true); end
		end
		
	end
	
end

function ENT:Explode()

	if(ValidEntity(self.Entity)) then

		local firework_explosion = EffectData()
		
		firework_explosion:SetOrigin( self.Entity:GetPos() )
		firework_explosion:SetStart( Vector(self.StartColor.r, self.StartColor.g, self.StartColor.b) )
		firework_explosion:SetAngle( Angle(self.EndColor.r, self.EndColor.g, self.EndColor.b) )
		firework_explosion:SetMagnitude( self.LifeTime )
		firework_explosion:SetScale( self.DieTime )
		
		util.Effect( "firework_explosion", firework_explosion )	
		util.BlastDamage(self.Entity, self.Owner || self.Entity, self:GetPos(), 256, 150)
		
		self.Entity:Remove()
		
	end
	
end

function ENT:StartFuse()

	if(!self.Entity.Fired && !self.Entity.Ignited) then
		
		local firework_ignite = EffectData()
		firework_ignite:SetEntity( self )
		firework_ignite:SetScale( self.FuseTime )
		util.Effect( "firework_trail_launch", firework_ignite, true, true )	
		
		self.Entity.Ignited = true
		
		if WireAddon then Wire_TriggerOutput(self.Entity, "Fuse Started", true); end
		timer.Simple(self.FuseTime, self.Launch, self)
		
	end
	
end

function ENT:PhysicsUpdate(phys)

	if(self.Entity.Fired) then
	
		if(self.Entity:GetPos():Distance(self.Entity.FirePos) > self.Entity.ExplodeLength) then
	
			self.Entity:Explode()
	
		end
		
		phys:AddVelocity(self:GetUp()*-50)
		
	end
	
end

function ENT:PhysicsCollide(data, phys)
	if(self.Entity.Fired) then
	
		if(data.Speed > 100) then
		
			self.Entity:Explode(data.HitNormal)
		
		end
		
	end

end

/*---------------------------------------------------------
   Name: Use
---------------------------------------------------------*/
function ENT:Use( activator, caller )
	
	self.Entity:StartFuse()

end



function ENT:OnRemove()
	if WireAddon then Wire_Remove( self.Entity ); end
end

function ENT:OnRestore()
	if WireAddon then Wire_Restored( self.Entity ); end
end



function ENT:TriggerInput( iname, value )

	if ( iname == "Fire" && util.tobool( value )) then
		self:Launch()
	elseif ( iname == "Start Fuse" && util.tobool( value )) then
		self:StartFuse()
	elseif ( iname == "Explode Distance") then
		self.Entity.OverrideExplodeLength = tonumber(value)
	elseif ( iname == "Force Explode" && util.tobool( value )) then
		self:Explode()
	elseif ( iname == "Fuse Time" && value) then
		self.FuseTime = math.Clamp(value, 0.5, math.huge)
	end

end
