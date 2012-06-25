// RÆPed version of cse grenade

//ENT.Base = "base_entity"
ENT.Type = "anim"

ENT.PrintName		= "Pipe Bomb"
ENT.Author			= "HLTV Proxy"
ENT.Contact			= ""
ENT.Purpose			= nil
ENT.Instructions	= nil


/*---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------*/
function ENT:OnRemove()
end

function ENT:PhysicsUpdate()
end

function ENT:PhysicsCollide(data,phys)
	if data.Speed > 50 then
		self.Entity:EmitSound(Sound("HEGrenade.Bounce"))
	end
	
	local impulse = -data.Speed * data.HitNormal * .2 + (data.OurOldVelocity * -.4)
	phys:ApplyForceCenter(impulse)
end
