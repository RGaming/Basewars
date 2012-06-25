AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

//local lasthit = 0

local calculatedata = function(data,hitent)
	
	local lasthit = data.lasthit
	local collisionsize = data.collisionsize
	local speed = data.speed
	local curtime = CurTime()
	local filter = data.filter
	local ent = data.entid
	local entpos = ent:GetPos()
	local particleang = ent:GetVelocity():GetNormalized()

	--Don't do anything if this hit occured too soon after the last one.
	if lasthit < curtime then
		data.lasthit = curtime + 7*collisionsize/speed
	else return end
	if hitent == Entity(0) then 
		hitent = ent
	else
		--Run a filter on entities we don't want to get. 
		if filter ~= {} then
			for k,v in pairs(filter) do
				if hitent == v then 
				return 
				end
			end
		end
	end
	
	--Start up a trace.  This is were we get most of our data from.
	local trace = {}
	local offsetvec = particleang*collisionsize
	
	trace.startpos = entpos - offsetvec*1.2
	trace.endpos = entpos + offsetvec*3
	trace.filter = filter
	trace.mask = data.mask
	
	local traceRes = util.TraceLine(trace)
		if not traceRes.Hit then --try again!
			for i=1,5 do 
			trace.startpos = entpos - particleang*(collisionsize + 3*i)
			trace.endpos = entpos + particleang*(collisionsize + 18*i)
			traceRes = util.TraceLine(trace)
			if traceRes.Hit then break end
			end
		end
		
	--Add stuff to our trace result
	traceRes.StartPos = data.startpos
	traceRes.particlepos = entpos
	traceRes.caller = ent
	traceRes.owner = data.owner
	traceRes.activator = hitent
	traceRes.tracedata = data
	traceRes.time = curtime - data.starttime
	
	--Run our function
	data.func(traceRes)

end


function ENT:Initialize()

	--We need to get the tracedata, or default to an error.
	local partent = self.Entity
	self.tracedata = partent:GetVar("tracedata",{couldnotfindtable = true})
	local data = self.tracedata --hurrr local variables are faster
	
	if data.couldnotfindtable then return end --If we don't have the tracedata table, we can't do anything.
	
	--Initiate phyiscs properties
	partent:SetMoveType(data.movetype)
	partent:PhysicsInitSphere(data.collisionsize, "default_silent")
	partent:SetCollisionBounds(Vector()*data.collisionsize*-1, Vector()*data.collisionsize)
	
	local phys = partent:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	partent:SetTrigger(true)
	partent:SetNotSolid(true)
	partent:SetCollisionGroup(data.mask)

	if data.worldcollide then
		partent:SetMoveType(data.movetype) --I don't know why this works, but it does.
	end
	
	--Kill the particle if it has been around for too long.
	if data.runonkill then
		timer.Create(tostring(self.Entity), data.killtime, 1, calculatedata, data, Entity(0) )
	else
		partent:Fire("kill", "", data.killtime )
	end
	
	
	/*
	--Send information needed to draw the entity to the clients
	partent:SetNetworkedString("model",data.model)
	partent:SetNetworkedBool("dodraw",data.dodraw)
	partent:SetNetworkedBool("doblur",data.doblur)
	partent:SetNetworkedBool("issprite",data.issprite)
	partent:SetNetworkedFloat("collisionsize",data.collisionsize)
	partent:SetNetworkedInt("rcolor",data.color.r)
	partent:SetNetworkedInt("bcolor",data.color.b)
	partent:SetNetworkedInt("gcolor",data.color.g)
	partent:SetNetworkedInt("acolor",data.color.a)
	*/
end


function ENT:PhysicsCollide(physdata, physobj)

end

function ENT:Touch(hitEnt)
	
	calculatedata(self.tracedata,hitEnt)

end 

function ENT:OnRemove()
	timer.Destroy(tostring(self.Entity))
end



function ENT:OnTakeDamage(dmginfo)

end


function ENT:Use(activator, caller)
	
end

include( 'shared.lua' )


