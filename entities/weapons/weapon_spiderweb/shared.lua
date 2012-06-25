--SpiderMod SpiderWeb Weapon shared code
--Author: ancientevil
--Contact: facepunch.com
--Date: 22 March 2009
--Notes: Primary fire while in the air to shoot a web line.  Weblines act like real Spidey weblines in that
--       they do not (much) stretch or pull you in like a grappeling hook.  Instead, they are fixed length
--       constraints that act like the rope constraint in sandbox (at this stage, the line is rendered as a
--       straight line that expands and contracts but this will improve) - except that this one
--       works on YOU.
--         With that in mind, try out all sorts of physics tests, knowing your arms are limitless in strength
--       (that is, they won't be ripped out of their sockets on a fast fall).  You can also charge your jump
--       while swinging and release it at just the right moment to maximise your distance or speed.
--         The Webline will be terminated if you touch the ground at any point or if you release a jump.  Lines
--       over 2,500 units in length will not be fired.  It makes for some panicky moments :)
--       
--Credits: * My brother, for hours of testing... well, play and criticism
--         * Spiderman 2 for PlayStation 2, which this swep is based on.
--         * Facepunch forum helpers

--resources
resource.AddFile("materials/models/weapons/v_hand/v_hand_sheet.vmt")
resource.AddFile("materials/models/weapons/v_hand/v_hand_sheet.vtf")
resource.AddFile("gamemodes/spidermod/content/sound/WebFire1.wav")
resource.AddFile("gamemodes/spidermod/content/sound/WebFire2.wav")
resource.AddFile("gamemodes/spidermod/content/sound/WebFire3.wav")
resource.AddFile("gamemodes/spidermod/content/models/weapons/v_spiderweb.dx80.vtx")
resource.AddFile("gamemodes/spidermod/content/models/weapons/v_spiderweb.dx90.vtx")
resource.AddFile("gamemodes/spidermod/content/models/weapons/v_spiderweb.mdl")
resource.AddFile("gamemodes/spidermod/content/models/weapons/v_spiderweb.sw.vtx")
resource.AddFile("gamemodes/spidermod/content/models/weapons/v_spiderweb.vvd")

--author and swep description
SWEP.Author =	"ancientevil"
SWEP.Contact =	"facepunch.com"
SWEP.Purpose =	"Gives the holder spider-like powers of web slinging."
SWEP.Instructions =	"Click and aim at the place you want to swing from, webhead. Remember to jump first - webs disintegrate when your feet hit the ground or when you jump."

--who can spawn this webpon? anyone can!
SWEP.Spawnable =	true
SWEP.AdminSpawnable =	true

--currently looks just like a pistol
--will model this later on to a spidey hand
SWEP.ViewModel =	"models/weapons/v_spiderweb.mdl"
SWEP.WorldModel =	"models/weapons/w_pistol.mdl"

--primary and secondary clips - none
SWEP.Primary.Clipsize =	-1
SWEP.Primary.DefaultClip =	-1
SWEP.Primary.Automatic =	false
SWEP.Primary.Ammo =	"none"

SWEP.Secondary.Clipsize =	-1
SWEP.Secondary.DefaultClip =	-1
SWEP.Secondary.Automatic =	false
SWEP.Secondary.Ammo =	"none"

--web line specific init variables
SWEP.WebIsAttached = false
SWEP.WebAttachedWorldPos = false
SWEP.WebLength = 0
SWEP.WebConstraint = false
SWEP.SimpleWeb = false

--debug mode flag
local WebDebug = false

--local constants
local MaxWebLength = 2500

--sound files

--web firing sound files (in an array so we can randomise use)
local webFire = {}
webFire[1] = Sound("WebFire1.wav")
webFire[2] = Sound("WebFire2.wav")

--the fail sound is on its own
local webFailFire = Sound("WebFire3.wav")

--debugging routine
function qid(routine)
  if WebDebug then
    if SERVER then
      print("SERVER: "..routine)
    else
      print("CLIENT: "..routine)
    end
  end
end

--returns one of two web firing sounds
function RandomWebFireSound()
  return webFire[math.random(1, 2)]  
end

--yes, we can use this weapon, some init here
function SWEP:Deploy()
  qid("SWEP:Deploy()")
  self.FiringWeb = false --reset our web firing status 
  return true
end 

--returns the distance of the player from the web attachment point
--this helps us make sure it is never greater than the length of the
--original web line
function SWEP:LengthFromWebAttachPoint()
  qid("SWEP:LengthFromWebAttachPoint()")
  local dist = self.Owner:GetPos():Distance(self.WebAttachedWorldPos)
  return dist
end

--returns the velocity of the player AFTER it has been subjected to the
--constraints of the web line - some of this is destined to be rewritten
--to improve the smoothness of the swing
function SWEP:GetConstraintCorrectedPlayerVelocity()
  qid("SWEP:GetConstraintCorrectedPlayerVelocity()")
  local plyVelocity = self.Owner:GetVelocity() -- original player velocity
  local pvLen = plyVelocity:Length() -- the magnitude of the player velocity
  local pvUV = plyVelocity:GetNormalized() -- the direction of the player velocity
  local plyPos = self.Owner:GetPos() -- the player position
  local plyToWebUV = (self.WebAttachedWorldPos - plyPos):GetNormalized() -- the direction from the player to the web-attachment point
  local newUV = (pvUV + plyToWebUV):GetNormalized() -- the new direction of movement (original direction less any movement away from the attachment point)
  qid("Vels ("..self.Owner:GetName().."): "..tostring(plyVelocity)..","..tostring(pvLen)..","..tostring(pvUV)..","..tostring(plyPos)..","..tostring(plyToWebUV)..","..tostring(newUV)..","..tostring(pvLen*newUV))
  return pvLen * newUV -- the new player velocity (new direction * original magnitude)
end

--main routine
function SWEP:Think()
  if SERVER then
    if (self.WebIsAttached) then
      if (self.Owner:OnGround()) then --terminate web line if touching ground
        self:RemoveWeb()
      else
        if (self:LengthFromWebAttachPoint() > self.WebLength) then --stop the player moving outside the radius of the webline from the attachment point
          local constrainedVelocity = self:GetConstraintCorrectedPlayerVelocity()
          self.Owner:SetLocalVelocity(constrainedVelocity)
        end
      end
    end
  end
end

--removes the web entity and disconnects the web line
function SWEP:RemoveWeb()
  qid("SWEP:RemoveWeb()")
  if self.WebIsAttached then
    if SERVER then
      if (self.WebConstraint) then
        self.WebConstraint:Remove()
      end
      if (self.SimpleWeb) then
      	self.SimpleWeb:Remove()
	      self.SimpleWeb = false
      end
    end
    self.WebIsAttached = false
  end
end

--removes any weblines on changing to a new weapon
function SWEP:Holster()
  qid("SWEP:Holster()")
  if SERVER then
    self:RemoveWeb()
  end
  return true
end

--tries to create a valid web trace from the firing position to the entity aimed at
--if successful, will return true - false otherwise
function SWEP:TryWebTrace()
  qid("SWEP:TryWebTrace()")
  local trace = self.Owner:GetEyeTrace() --trace a line from the owner's eye to the colliding entity
  
  --only continue if this is a valid hit
  --which means
  --A: a valid physics object
  --and B: part of the world 
  if (util.IsValidPhysicsObject(trace.Entity, trace.PhysicsBone))
  and (trace.Entity:IsWorld()) then
    self.WebAttachedWorldPos = trace.HitPos --where the web holds the player to (attachment point)
    self.WebLength = self.Owner:GetShootPos():Distance(self.WebAttachedWorldPos) --the length now constraining the player to the attachment 
    --we can also bail here if the object we are trying to swing from is out of our range
    if (self.WebLength <= MaxWebLength) then
      return true --once we pass all areas of testing, this is a valid web trace - so we allow it through
    else
      return false
    end
  else
    return false 
  end

end

--called by the server - plays a different sound if web hits or misses
function SWEP:PlayWebSound(success)
  if (success == "true") then --sent as a string in this case, not a boolean
    --play the web firing sound
    self.Weapon:EmitSound(RandomWebFireSound(), 40.0)  
  else
    --play the web missing sound
    self.Weapon:EmitSound(webFailFire, 40.0)
  end
end

--plays the hold web line animation and resets the next fire
function HoldWebLine(self)
  qid("SWEP:HoldWebLine(self)")
  self.Weapon:SendWeaponAnim(ACT_VM_IDLE_LOWERED) --plays the hold animation
end

--plays the grab web line animation and triggers the hold animation for after it
function GrabWebLine(self)
  qid("SWEP:GrabWebLine(self)")
  self.Weapon:SendWeaponAnim(ACT_VM_HAULBACK) --plays the grab animation
  timer.Create("delayedHold", self.Weapon:SequenceDuration(), 1, HoldWebLine, self) --times the hold animation for straight after it 
end

--ooops - we have missed - this plays the failed webshot animation and resets the next fire
function FailWebLine(self)
  qid("SWEP:FailWebLine(self)")
  self.Weapon:SendWeaponAnim(ACT_VM_SWINGMISS) --plays the failed web shot animation
end

--seperated webline fire routine so it can be delayed while the animation is playing
function FireWebLine(self)
  qid("SWEP:FireWebLine(self)")
  self:RemoveWeb() --remove any existing webline
  if SERVER then
    
     
    if (self:TryWebTrace()) then --try to set up a valid webline    

      --create the web entity (which for the moment is a very simple textured line)
		  if (!self.SimpleWeb) then
			  self.SimpleWeb = ents.Create( "webstrand" )
			  self.SimpleWeb:SetPos( self.Owner:GetShootPos() )
			  self.SimpleWeb:Spawn()
        self.SimpleWeb:GetTable():SetEndPos(self.WebAttachedWorldPos)
		  end
		
      --set owner so we don't collide with our webline
		  self.SimpleWeb:SetParent( self.Owner )
		  self.SimpleWeb:SetOwner( self.Owner )    
      
      --play the web-attached sound on the client
      self.Weapon:CallOnClient("PlayWebSound", "true")

      --give the player a moment to see that the web has connected, then grab it
      timer.Create("delayedGrab", 0.5, 1, GrabWebLine, self)
      
      --finally, this flag is set to start the main routine thinking differently about how we move
      self.WebIsAttached = true    

      --terminate any wallcrawling
      self.Owner:GetNWEntity("wcam"):GetTable():FinishWallCrawling()

    else
      --play the web-fail sound on the client
      self.Weapon:CallOnClient("PlayWebSound", "false")
      --for some reason, we missed our target - play the fail animation after a moment of realisation
      timer.Create("delayedFail", 0.5, 1, FailWebLine, self)
    end

  end
  
  self.FiringWeb = false --reset so we can fire again
end

--assesses whether or not we can fire a web line and returns true or false
function SWEP:CanFireWeb()
  qid("SWEP:CanFireWeb()")
  return (!self.Owner:OnGround()) and (!self.FiringWeb)
end

--"GO WEB!...Flyyy web... up up and AWAY, WEB!"..etc
--fires a webline for you to dangle, sweep and fly across the sky on
function SWEP:PrimaryAttack()
  qid("SWEP:PrimaryAttack()")
  if (self:CanFireWeb()) then
    --set a flag so that we can't fire whilst processing a fire request
    self.FiringWeb = true
    --alternate left and right hands
    self.ViewModelFlip = !self.ViewModelFlip
    --play the web fire animation
    self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    --start a delayed firing sequence to coincide with the animation
    timer.Create("delayedFire", self.Weapon:SequenceDuration() / 2, 1, FireWebLine, self)
  end
end

--there is no secondary fire... yet... but it is pencilled in to have webzip functionality
--and if you have played the PS2 game, you know what that is
function SWEP:SecondaryAttack()
  return false 
end
