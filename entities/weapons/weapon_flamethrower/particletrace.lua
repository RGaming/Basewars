--Particle Trace v 0.9b
--By Teta_Bonita


function ParticleTrace(partrace)
if ( SERVER ) then

	--these paramaters are essential.  If we don't have them, we can't do the trace.
	if not partrace.func
	or not partrace.startpos
	or not (partrace.ang or partrace.velocity)
	then return end
	

	--these paramaters are important, but do not nesissarily need to be specified by the user.
	partrace.speed 			= 	partrace.speed 			or 1024
	partrace.ang 			= 	partrace.ang  			or partrace.velocity:GetNormalized() or Vector(0,0,0)
	partrace.owner			= 	partrace.owner 			or 0
	partrace.name			= 	partrace.name 			or ""
	partrace.collisionsize 	= 	partrace.collisionsize 	or 1
	partrace.worldcollide	=	partrace.worldcollide	or true
	partrace.mask			= 	partrace.mask 			or 3
	partrace.killtime 		= 	partrace.killtime 		or 12
	partrace.runonkill 		= 	partrace.runonkill  	or false
	partrace.movetype 		= 	partrace.movetype 		or MOVETYPE_FLY
	partrace.model 			= 	partrace.model 			or "none"
	partrace.color 			= 	partrace.color  		or Color(255,255,255,255)
	partrace.doblur			= 	partrace.doblur	 		or false
	partrace.filter			=	partrace.filter			or {}
	--partrace.initfunc

	--these paramaters should never be defined by the user.
	partrace.starttime = CurTime()
	partrace.lasthit = 0
	partrace.dodraw = false
	partrace.issprite = false
	
	partrace.entid = ents.Create( "sent_traceparticle" ) --Create a trace particle entity.

		if partrace.model == "none" then --no model was specified.
			// more TF2 type collisions.
			partrace.entid:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl") --filler model, it won't be seen.
			partrace.entid:DrawShadow(false)
		elseif string.find(partrace.model,".mdl") ~= nil then --If the model specified is a 3d model...
			partrace.entid:SetModel(partrace.model)
			partrace.dodraw = true --tell the ent to draw itself.
		else --Then it's a sprite!
			partrace.entid:SetModel("models/Items/combine_rifle_ammo01.mdl") --filler model, it won't be seen.
			partrace.dodraw = true
			partrace.issprite = true
			partrace.model = string.gsub(string.gsub(string.gsub(partrace.model, ".vmt", ""), ".vtf", ""), ".spr", "")	--Idiot proof!
		end
		
	--Add the particle ent to the filter
	table.insert(partrace.filter,partrace.entid)
	
	--Particle speeds greater than 8192 cause source breakage. D :
	if partrace.speed > 8192 then partrace.speed = 8192 end

	--These variables need to be sent to the entity we just created, so we can just send the entire table over.
	partrace.entid:SetVar("tracedata",partrace)

	--We need to tell where to spawn and move our particle and stuff like that.
	partrace.entid:SetPos(partrace.startpos)
	partrace.entid:SetAngles(partrace.ang:Angle())
	partrace.entid:Spawn()
	partrace.entid:SetOwner(partrace.owner)
	partrace.entid:SetName(partrace.name)

	--Specify mass and gravity and apply velocity to the particle.
	local physobj = partrace.entid:GetPhysicsObject()
	if partrace.velocity then
		partrace.ang = partrace.velocity:GetNormalized()
	else
		partrace.velocity = partrace.ang*partrace.speed
	end
	physobj:SetMass(1e-9) --An extremely small mass makes all physics interactions negligible.
	physobj:EnableGravity(partrace.gravity)
	physobj:SetVelocity(partrace.velocity)
	partrace.entid:SetVelocity(partrace.velocity)
	
	--If it is defined, run a special function on the particle itself (for parenting effects, etc.)
	if partrace.initfunc then
	partrace.initfunc(partrace.entid)
	end
	
end

end
