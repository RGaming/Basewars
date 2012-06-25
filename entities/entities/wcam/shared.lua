--SpiderMod Webcrawling entity shared code
--Author: ancientevil
--Contact: facepunch.com
--Date: 26 April 2009
--Notes: This is the main part of the wallcrawling code.  It is encapsulated in an entity which is spawned with each player

--basic entity declarations
ENT.Base = "base_gmodentity"
ENT.Type = "anim"

--debugging flag
--set true to print debugging information to screen
local DebugWC = false

--the physics box (collisions, bounding)
--for the invisible wall crawling entity
--a 2x2 cube centred at the origin
local CrawlBoxMin = Vector(-1, -1, -1)
local CrawlBoxMax = Vector(1, 1, 1)

--initialize (speaks for itself really)
function ENT:Initialize()
  self.Entity:SetNWBool("WCActive",false)
  self.Entity:SetMoveType(MOVETYPE_CUSTOM)
  self.Entity:SetModel( "models/props_junk/sawblade001a.mdl" ) --the debugging model (not shown ordinarily)
  self.Entity:PhysicsInitBox(CrawlBoxMin, CrawlBoxMax) --give it the physical box that we decide on
  self.Entity:SetMoveType( MOVETYPE_VPHYSICS ) -- we will decide how it moves too
  self.Entity:SetSolid( SOLID_VPHYSICS ) --it can be solid for a few seconds...
  self.Entity:DrawShadow(false) --don't draw the shadow - it will only say ERROR

  local phys = self.Entity:GetPhysicsObject()
  if (phys:IsValid()) then
    phys:Wake() --wake up the physics object so we can turn off collisions and gravity
    phys:EnableCollisions(false)
    phys:EnableGravity(false)
  else
    print("Error: NonValid WCam PhysObj")
  end
end

--the on/off status check method - returns true if we are wall crawling
function ENT:IsActivated()
  return self.Entity:GetNWBool("WCActive")
end

--toggles wall crawling on/off
function ENT:Toggle()
  if self.Entity:IsActivated() then
    self.Entity:FinishWallCrawling()
  else
    self.Entity:InitWallCrawling()
  end
end

--return true if the requested use of wallcrawl is valid
--that is, this will return true if the surface we hit USE on
--meets the criteria for a crawlable wall
function ENT:IsValidCrawlSpace(ply)
  --a wall crawl is only valid if a trace from the player's eyes....

  local trace = ply:GetEyeTrace() --what we really want is a trace that shoots out in multiple flat directions but this will do for now
  
  --1. hits the world ent
  if trace.HitNonWorld then
    if DebugWC then    
      print('Hit non world')
    end
    return false
  end

  --2. the world ent face is less than 82 units away (standard USE distance: http://developer.valvesoftware.com/wiki/Dimensions)
  if trace.StartPos:Distance(trace.HitPos) > 82 then
    if DebugWC then 
      print('Too far away')
      print(trace.StartPos:Distance(trace.HitPos))
    end
    return false
  end

  --3. the hit normal is greater than x degrees on the Z axis (no point in crawling the floor (45 degrees or so, taken from above))
  if trace.HitNormal:DotProduct(Vector(0,0,1)) > 0.3 then
    if DebugWC then
      print('You can walk this')
      print(trace.HitNormal)
    end
    return false
  end

  return trace
end

--returns the inverted wall normal vector
--i.e. a vector that moves towards the wall front on
function ENT:GetInvWallNormal()
  return self.Entity:GetNWVector("wallinvnormal")
end

--returns the wall angle respective to the rest of the map
function ENT:GetWallAngle()
  return self.Entity:GetNWAngle("wall")
end

--start wall crawling (queue dramatic music)
function ENT:InitWallCrawling()
  local ply = self.Entity:GetOwner() --get the player
  local walltrace = self.Entity:IsValidCrawlSpace(ply) --get the wall trace (if valid)
  --if this isn't a valid wall to crawl on (e.g. USE pressed on an object or in the middle of nowhere)
  --we just return false - i.e. do nothing, and make sure the wall crawling flag is off
  if not walltrace then
    self.Entity:SetNWBool("WCActive", false)
    return false
  end
  --stop the wcam from spinning if it is spinning from some dangerously placed C4 blast or other :)
  self.Entity:GetPhysicsObject():EnableMotion(false)
  self.Entity:GetPhysicsObject():EnableMotion(true)
  --remove any weblines
  --we want to be able to swing and grab on to a wall
  if (ply:GetActiveWeapon():GetTable().WebIsAttached) then
    ply:GetActiveWeapon():GetTable():RemoveWeb()
  end    
  if SERVER then
    ply:SetMoveType(MOVETYPE_NONE)      --catch the player in the wall cam entity
    ply:SetLocalVelocity(Vector(0,0,0)) --stop the player dead still so that a release wont mean death
  end
  local wallpos = walltrace.HitPos --be the wall danny (this is where the trace hit the wall)
  self.Entity:SetPos(ply:GetShootPos()) --first move the wc entity to our head (that's shoot pos)
  --get the angle and normal of the wallcrawling surface and
  --store them for later
  local wallinvnormal = walltrace.HitNormal * -1
  self.Entity:SetNWVector("wallinvnormal", wallinvnormal)
  self.Entity:SetNWAngle("wall", wallinvnormal:Angle())

  --rotate the wc entity to align with the wall in
  --both orientation and angle
  local newangle = self.Entity:GetWallAngle()
  --make the player move with us
  ply:SetParent(self.Entity) 
  newangle:RotateAroundAxis(newangle:Forward(), newangle.y)
  newangle:RotateAroundAxis(newangle:Right(), 90) 
  --if in debug mode print out the wall normal (there are still some things to improve)
  if DebugWC then
    ply:PrintMessage(HUD_PRINTCENTER, tostring(walltrace.HitNormal))
  end
  self.Entity:SetAngles(newangle)
  --now we move the entity (and player, as a child locked to it) right onto the wall
  --later on in the physics update section, the player moves away from the wall a bit
  self.Entity:SetPos(wallpos) 

  --start the motion controller for the entity and wake up the physics object
  --this allows us to start controlling the entity (and ourselves, connected to it)
  --with the direction keys and mouse
  if SERVER then
    self.Entity:StartMotionController()
    self.Entity:GetPhysicsObject():Wake()
  end
  --make the player look at where they were looking before they activated the crawl
  --we need to do this because we are changing the orientation of the player
  --for now, this just means straight at the building - it is more intuitive
  --ply:SnapEyeAngles(Angle(0,0,0))
  --EDIT: this needs a little more work - for now it is being disabled
  --in future this will work as intended

  --finally, we set the active flag.  We are now wall crawling!
  self.Entity:SetNWBool("WCActive", true)
  return true
end

--finish wall crawling - turn off, disengage etc
function ENT:FinishWallCrawling()
  --only do this if we ARE wallcrawling
  --this line avoids error lines if we try and turn off that which is
  --not on (like when we jump or shoot a web line)
  if (not self.Entity:IsActivated()) then return false end
  --if there is any left over velocity, apply it to the player
  --this allows us to run up a wall and disengage *just* before the edge,
  --keeping our momentum and using it to hop up on top of the wall
  local phys = self.Entity:GetPhysicsObject()
  local savedvel = Vector(0,0,0)
  if (phys) and (phys != NULL) then
    savedvel = phys:GetVelocity()
  end --we will use the saved velocity at the end of this routine
  local ply = self.Entity:GetOwner() --get the player
  --make the player look at whatever he/she was looking at before we
  --finished the wall crawl - this is important for both continuity and
  --wall-based web shooting - this effectively rolls the player over and 
  --finishes up with them looking where they were looking before (but now
  --they are straight up and down)
  local trace = ply:GetEyeTrace() --what were we looking at just before finishing up?
  if SERVER then
    ply:SetScriptedVehicle(NULL)   --not needed but will leave until retesting
    ply:SetClientsideVehicle(NULL) --ditto
    ply:SetMoveType(MOVETYPE_WALK)   --player can move again
    self.Entity:StopMotionController() --stop the motion controller that gives us wc control
  end
  ply:SetParent(NULL) --player moves of own volition, not tied to the wc entity 
  --make the player look at what they were looking at when we cancelled the crawl
  local ang = (trace.HitPos - ply:GetShootPos()):Angle()
  if SERVER then
    ply:SnapEyeAngles(ang)
  end
  --apply the remaining velocity (earlier) to the player to maintain momentum
  ply:SetVelocity(savedvel)
  --finally, set the flag to inactive.  We are now NOT wallcrawling
  self.Entity:SetNWBool("WCActive", false)
end

--given an aim vector and whether we are moving forward or backwards (the only current directions
--available in a wall crawl), this returns true if we are not about to crawl off an edge AND if
--we are also not about to crawl into something else
function ENT:GetCrawlOk(direction)
  --we need a sneek peek of what is x units ahead or behind of this vector
  --so we take the pos of the ent and add x units in the desired direction
  --then look towards the building to see if we still hit the same surface level
  --we also need to stop if we hit anything in a forward direction

  --the "peek" pos is the position from which we will look downward (towards the surface)
  --to see if we are still crawling on the same wall - at the moment, this is hard coded to
  --10 units ahead or behind the player wc entity depending on aim vector and thrust direction
  --(fwd/bkwd)
  local peekpos = Vector(0,0,0)
  peekpos = self.Entity:GetPos() - self.Entity:GetInvWallNormal(); --peekpos is one unit off the wall...
  local movedir = Vector(0,0,0)
  movedir = direction * 10
  peekpos = peekpos + movedir; -- and 10 units fwd/bkwd... now we can look "down" and see if all is well
  --trace from the peek pos to the surface (2 units in length)
  local tracedata = {}
  tracedata.start = peekpos
  tracedata.endpos = peekpos + (self.Entity:GetInvWallNormal() * 2)
  tracedata.filter = {self.Entity, self.Entity:GetOwner().Entity} --be sure to filter out ourselves and the wc ent
  local trace = {}
  trace = util.TraceLine(tracedata)
  --send network debugging variables (debug only)
  if DebugWC then
    print('MovDir:'..tostring(movedir))
    print('MyPos:'..tostring(self.Entity:GetPos()))
    self.Entity:SetNWVector("sensor1_start", trace.StartPos)
    self.Entity:SetNWVector("sensor1_end", tracedata.endpos)
    self.Entity:SetNWVector("sensor1_hit", trace.HitPos)
  end
  if (tracedata.endpos == trace.HitPos) then
    --if we get to the end of the trace without hitting something then
    --we are about to crawl off our flat surface.  Deny this crawl movement
    return false
  else
    --so far so good - we are not about to crawl off the edge... but
    --are we about to crawl into a solid wall?
    --we need to trace forwards in "direction" - if we hit anything x units out we stop
    local tracedata2 = {}
    tracedata2.start = self.Entity:GetOwner():GetShootPos();
    tracedata2.endpos = tracedata2.start + (movedir * 7.3) --73 units is the height of a player (and movedir is already 10 units long in the appropriate direction)
    tracedata2.filter = {self.Entity, self.Entity:GetOwner().Entity}
    local trace2 = util.TraceLine(tracedata2)
    if (tracedata2.endpos == trace2.HitPos) then
      --finally, we are clear to crawl this way if we don't hit anything in our path
      return true
    else
      --bugger - we have hit something - stop crawling
      return false
    end
  end
end

--returns the direction (vector) that we should be crawling in
--this has been painstakingly calculated to be a combination
--of normals and entity rotation as well as the aim vector (your eyes).
--In short, you crawl where you look and you don't walk through walls
function ENT:GetCrawlDirection(crawlKey)
  local ply = self.Entity:GetOwner()
  local newvec = self.Entity:GetUp()  
  local aimrot = ply:GetAimVector()
  newvec = newvec:Cross(aimrot) --this is the normal to both yaw of the aim vector and the outward vector from the building's surface normal, so it will point 90 degrees 
                                  --left of where we want to go when we want to go forwards (but if we want to move sideways, it's perfect
  if (crawlKey == IN_FORWARD) or (crawlKey == IN_BACK) then
    local leftangle = newvec:Angle() -- this is the angle representing our new vector, we want to rotate it 90 degrees around our outward vector
    leftangle:RotateAroundAxis(self.Entity:GetUp(), -90) --now this represents the angles where we want to go
  
    newvec = leftangle:Forward() --we take the forward direction - this is our desired crawl vector
  end

  newvec = newvec:GetNormalized()  

  if (crawlKey == IN_BACK) or (crawlKey == IN_MOVERIGHT) then
    --when we are crawling away from our forwards or right vector, multiply by -1
    newvec = newvec * -1
  end

  return newvec
end

--based on the keys the user is holding and the direction they are looking
--this returns the vector representing which direction we should move in
function ENT:GetCrawlVector()
  local fwdDirection = Vector(0,0,0)
  local rightDirection = Vector(0,0,0)
  local ply = self.Entity:GetOwner()

  --forward/backward movement
 
  if (ply:KeyDown(IN_FORWARD)) then    fwdDirection = self.Entity:GetCrawlDirection(IN_FORWARD)
  elseif (ply:KeyDown(IN_BACK)) then
    fwdDirection = self.Entity:GetCrawlDirection(IN_BACK)
  end

  --left/right movement (strafe)

  if (ply:KeyDown(IN_MOVELEFT)) then
    rightDirection = self.Entity:GetCrawlDirection(IN_MOVELEFT)  
  elseif (ply:KeyDown(IN_MOVERIGHT)) then
    rightDirection = self.Entity:GetCrawlDirection(IN_MOVERIGHT)
  end

  --combine the two directions (forward, right) to create a new one
  return (fwdDirection + rightDirection):GetNormalized()
end

--respond to key commands to crawl up and down the wall
function ENT:PhysicsSimulate(phys, deltatime)
  local forceLinear = Vector(0,0,0)
  local forceAngle = Vector(0,0,0)
  local newDirection = Vector(0,0,0)
  local notAtEdge = true
  if self.Entity:IsActivated() then
    --if we are in wallcrawl mode then
    --get the direction to crawl and the thrust (fwd, backwd)
    --and whether or not it is ok to crawl in that direction
 
    newDirection = self.Entity:GetCrawlVector()
   
    --final setting of the forcelinear
    notAtEdge = self.Entity:GetCrawlOk(newDirection)
    forceLinear = newDirection * 30000 * deltatime
  end
  
  --additional top speed for sprinters
  local additionalmax = 0

  --if you hold sprint, your run will accelerate twice as
  --fast as normal and you will be able to have a top speed
  --200 units higher than if you were not sprinting
  if self.Entity:GetOwner():KeyDown(IN_SPEED) then
    forceLinear = forceLinear * 2
    additionalmax = 200
  end

  --if we hit the edge then we *immediately* get jolted to a halt
  if not notAtEdge then
    forceLinear = Vector(0,0,0)
    phys:SetVelocity(forceLinear)
  end
  
  --don't accelerate if travelling at top speed
  --we have to cap Spidey's top speed somewhere
  --additional top speed is available when sprinting
  if (phys:GetVelocity():Length() > (1000 + additionalmax)) then
    forceLinear = Vector(0,0,0)
  end

  --return the force as global acceleration (no angular force)
  return forceAngle, forceLinear, SIM_GLOBAL_ACCELERATION
end

--returns true if the user sitting at the keyboard has at least one directional
--button pressed of the W,S,A,D range
function ENT:WSADing()
  local ply = self.Entity:GetOwner()
  return ply:KeyDown(IN_FORWARD) 
      or ply:KeyDown(IN_BACK)
      or ply:KeyDown(IN_MOVELEFT)
      or ply:KeyDown(IN_MOVERIGHT)
end

--called very frequently - this is like a think() for the physics object
--in this we fix side-sliding issues and others
function ENT:PhysicsUpdate(phys)
  local ply = self.Entity:GetOwner()

  --if we change direction while running/crawling up a wall, kill all thrust
  --and re-apply it in the new direction.  This stops us from side-sliding like
  --a car with racing slicks on
  local newDirection = self.Entity:GetCrawlVector()

  if (self.Entity.LastDirection != newDirection) then 
    local savevel = phys:GetVelocity()
    local vellen = savevel:Length()
    --prevents hyperspeed by tapping fwd/back or left/right (still not perfect though)
    if (self.Entity.LastDirection == (newDirection * -1)) then
      vellen = vellen / 3
    end
    phys:SetVelocityInstantaneous(newDirection * vellen)
  end
  self.Entity.LastDirection = newDirection

  --letting go of all WSAD always causes the player to stop on the spot
  if not self.Entity:WSADing() then
    phys:SetVelocity(Vector(0,0,0)) --no keys at the moment - slam on the brakes!
  end
  
  --move the player to a sensible distance from the wall crawling entity
  --this is required so that the bounding box does not catch on the crawl surface
  --at a later stage we will reduce this distance
  if self.Entity:IsActivated() then
    ply:SetPos(self.Entity:GetPos() + (self.Entity:GetNWVector("wallinvnormal") * -73)) --73 is the height of a player
  end
end  
