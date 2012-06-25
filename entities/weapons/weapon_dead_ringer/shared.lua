////////////////////
//Dead Ringer Swep//
///////Update///////
//by NECROSSIN///
///////////////////
--Updated: 24 January 2010

----------------------------
--////////////////////////--
local REDUCEDAMAGE = 0.9 
--////////////////////////--
----------------------------

--this SWEP uses models, textures and sounds from TF2, so be sure that you have it if you dont want to see an ERROR instead of swep model and etc...

resource.AddFile( "materials/vgui/entities/weapon_dead_ringer.vmt" )
resource.AddFile( "materials/vgui/entities/weapon_dead_ringer.vtf" )


--------------------------------------------------------------------------
if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo			= false
	SWEP.AutoSwitchFrom		= false
	SWEP.HoldType			= "slam"
	
end

--------------------------------------------------------------------------

if ( CLIENT ) then
	SWEP.PrintName			= "Dead Ringer"	
	SWEP.Author				= "NECROSSIN"
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= false
	SWEP.ViewModelFOV			= 55
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes		= false
	SWEP.WepSelectIcon = surface.GetTextureID("backpack/weapons/c_models/c_pocket_watch/parts/c_pocket_watch.vtf") -- texture from TF2
	
	SWEP.Slot				= 1 
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "G"

	surface.CreateFont("coolvertica", 13, 500, true, false, "DRfont")
	util.PrecacheSound( "backpack/weapons/c_models/c_pocket_watch/parts/c_pocket_watch.vtf" ) 

function drawdr()
--here goes the new HUD
if LocalPlayer():GetNWBool("Status") == 1 or LocalPlayer():GetNWBool("Status") == 3 or LocalPlayer():GetNWBool("Status") == 4 then
local background = surface.GetTextureID("HUD/misc_ammo_area_red")
local w,h = surface.GetTextureSize(surface.GetTextureID("HUD/misc_ammo_area_red"))
	surface.SetTexture(background)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(13, ScrH() - h - 150, w*5, h*5 )

local energy = math.max(LocalPlayer():GetNWInt("drcharge"), 0)
draw.RoundedBox(2,44, ScrH() - h - 118, (energy / 8) * 77, 15, Color(255,222,255,255))
surface.SetDrawColor(255,255,255,255)
surface.DrawOutlinedRect(44, ScrH() - h - 118, 77, 15)
draw.DrawText("CLOAK", "DRfont",61, ScrH() - h - 103, Color(255,255,255,255))
end

end
hook.Add("HUDPaint", "drawdr", drawdr)

local function DRReady(um)
surface.PlaySound( "player/recharged.wav" )
end
usermessage.Hook("DRReady", DRReady)
end 

-------------------------------------------------------------------

SWEP.Category				= "Spy"

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= true

SWEP.Purpose        	= "Fake your death!"

SWEP.Instructions   	= "Primary - turn on.\nSecondary - turn off or drop cloak."

SWEP.ViewModel 				= "models/weapons/v_models/v_watch_pocket_spy.mdl"
SWEP.WorldModel 				= "models/weapons/c_models/c_pocket_watch/parts/c_pocket_watch.mdl" 

SWEP.Weight					= 5 
SWEP.AutoSwitchTo				= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Ammo				= ""

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Ammo			= "none" 
------------------------------------------
NPCs = { -- if you have custom NPC-enemies, you can add them here
"npc_zombie",
"npc_fastzombie",
"npc_zombie_torso",
"npc_poisonzombie",
"npc_antlion",
"npc_antlionguard",
"npc_hunter",
"npc_antlion_worker",
"npc_headcrab_black",
"npc_headcrab",
"npc_headcrab_fast",
"npc_combine_s",
"npc_zombine",
"npc_fastzombie_torso",
"npc_rollermine",
"npc_turret_floor",
"npc_cscanner",
"npc_clawscanner",
"npc_manhack",
"npc_tripmine",
"npc_barnacle",
"npc_strider",
"npc_metropolice",
}

-----------------------------------------------------------------------

-- disable dead rnger on spawn
if SERVER then
	function dringerspawn( p )
if p:GetNWBool("Dead") == true then
p:SetNWBool(	"Status",			0)
p:GetViewModel():SetMaterial("")
p:SetMaterial("")
p:SetColor(255,255,255,255)
end
p:SetNWBool(	"Status",			0)
p:SetNWBool(	"Dead",			false)
p:SetNWBool(	"CanAttack",			true)
p:SetNWInt("drcharge", 8 )

	end
	hook.Add( "PlayerSpawn", "DRingerspawn", dringerspawn );
end
-----------------------------------
function SWEP:Initialize()
if SERVER then
	self:SetWeaponHoldType(self.HoldType)
end
end
-----------------------------------
function SWEP:Deploy()
if SERVER then
		self.Owner:DrawWorldModel(false)
		self.Owner:DrawWorldModel(false)

local ent = ents.Create("deadringer")			
ent:SetOwner(self.Owner) 
ent:SetParent(self.Owner)
ent:SetPos(self.Owner:GetPos())
ent:SetColor(self.Owner:GetColor())
ent:SetMaterial(self.Owner:GetMaterial())
ent:Spawn()	
end

self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
if !self.Owner:GetNWBool("Status") == 3 or !self.Owner:GetNWBool("Status") == 4 or !self.Owner:GetNWBool("Status") == 1 then
self.Owner:SetNWBool(	"Status",			2)
end
return true
end
-----------------------------------
function SWEP:Think()
end

function SWEP:Holster()
	local worldmodel = ents.FindInSphere(self.Owner:GetPos(),0.6)
	for k, v in pairs(worldmodel) do 
if v:GetClass() == "deadringer" and v:GetOwner() == self.Owner then
v:Remove()
end
end
return true
end

-----------------------------------
--------View Model material--------
-----------------------------------

if CLIENT then
function drvm()

if LocalPlayer():GetNWBool("Dead") == true then 
LocalPlayer():GetViewModel():SetMaterial( "models/props_c17/fisheyelens")

elseif LocalPlayer():GetNWBool("Dead") == false then
--LocalPlayer():GetViewModel():SetMaterial("")
end
end
hook.Add( "Think", "DRVM", drvm )
end


-----------------------------------------------------------

---------------------------------
---------hooks--------
---------------------------------
if SERVER then

function checkifwehaveourdr(ent, inflictor, attacker, amount, dmginfo)
local getdmg = dmginfo:GetDamage()
local reducedmg = getdmg * REDUCEDAMAGE
	if ent:IsPlayer() then
	local p = ent
	local infl
		if attacker:GetClass() == "trigger_hurt" or attacker:GetClass() == "func_rotating" or attacker:GetClass() == "func_physbox" then
			if p:GetNWBool("CanAttack") == true and p:GetNWBool("Dead") == false and p:GetNWBool("Status") == 1 then
			dmginfo:SetDamage(math.random(5,15))
			p:fakedeath()
			umsg.Start( "PlayerKilled" )
			umsg.Entity( p )
			umsg.String( attacker:GetClass() )
			umsg.String( attacker:GetClass() )
			umsg.End()
			elseif p:GetNWBool("CanAttack") == false and p:GetNWBool("Dead") == true and p:GetNWBool("Status") == 3 then
			dmginfo:SetDamage(math.random(0,1))
			end
		elseif attacker:IsPlayer() then
			if p:GetNWBool("CanAttack") == true and p:GetNWBool("Dead") == false and p:GetNWBool("Status") == 1 then
			dmginfo:SetDamage(getdmg - reducedmg )
			p:fakedeath()
			umsg.Start( "PlayerKilledByPlayer" )
			umsg.Entity( p )
			umsg.String( attacker:GetActiveWeapon():GetClass() )
			umsg.Entity( attacker )
			umsg.End()
			elseif p:GetNWBool("CanAttack") == false and p:GetNWBool("Dead") == true and p:GetNWBool("Status") == 3 then
			dmginfo:SetDamage(getdmg - reducedmg )
			end
		elseif attacker:IsNPC() then
			if p:GetNWBool("CanAttack") == true and p:GetNWBool("Dead") == false and p:GetNWBool("Status") == 1 then
			dmginfo:SetDamage(getdmg - reducedmg )
			p:fakedeath()
			-- if npc has weapon (eg: metrocop with stunstick) then inflictor = npc's weapon
			if ValidEntity(attacker:GetActiveWeapon()) then
			infl = attacker:GetActiveWeapon():GetClass()
			-- else  (eg: zombie or hunter) then inflictor = attacker
			else
			infl = attacker:GetClass()
			end
			umsg.Start( "PlayerKilled" )
			umsg.Entity( p )
			umsg.String( infl )
			umsg.String( attacker:GetClass() )
			umsg.End()
			elseif p:GetNWBool("CanAttack") == false and p:GetNWBool("Dead") == true and p:GetNWBool("Status") == 3 then
			dmginfo:SetDamage(getdmg - reducedmg )
			end
		else
			if p:GetNWBool("CanAttack") == true and p:GetNWBool("Dead") == false and p:GetNWBool("Status") == 1 then
			dmginfo:SetDamage(getdmg - reducedmg )
			p:fakedeath()
			umsg.Start( "PlayerKilled" )
			umsg.Entity( p )
			umsg.String( attacker:GetClass() )
			umsg.String( attacker:GetClass() )
			umsg.End()
			elseif p:GetNWBool("CanAttack") == false and p:GetNWBool("Dead") == true and p:GetNWBool("Status") == 3 then
			dmginfo:SetDamage(getdmg - reducedmg )
			end
		end
	end
end
hook.Add("EntityTakeDamage", "CheckIfWeHaveDeadRinger", checkifwehaveourdr)
end
if SERVER then
function disablefakecorpseondeath(p, attacker)
if p:IsValid() and p:GetNWBool("CanAttack") == false and p:GetNWBool("Dead") == true and p:GetNWBool("Status") == 3 then
p:uncloak()
end
end
hook.Add("DoPlayerDeath", "RemoveFakeCorpse", disablefakecorpseondeath)

-- here goes the dead ringer charge/regenerating system
function drthink()
	for _, p in pairs(player.GetAll()) do
		if p:IsValid() and p:GetNWBool("Dead") == false and p:GetNWBool("Status") == 4 then
			if p:GetNWInt("drcharge") < 8 then
			p.drtimer = p.drtimer or CurTime() + 2
				if CurTime() > p.drtimer then
				p.drtimer = CurTime() + 2
				p:SetNWInt("drcharge", p:GetNWInt("drcharge") + 1)
				end
			elseif 	p:GetNWInt("drcharge") == 8 then
			p:SetNWBool("Status", 1)
			umsg.Start( "DRReady", p )
			umsg.End()
			end
		elseif p:IsValid() and p:GetNWBool("Dead") == true and p:GetNWBool("Status") == 3 then
			for _, v in pairs(p:GetWeapons()) do
			v:SetNextPrimaryFire(CurTime() + 2)
			v:SetNextSecondaryFire(CurTime() + 2)
			end
			p:DrawWorldModel(false)
			for _,npc in pairs(ents.GetAll()) do 
				if npc:IsNPC() then 
					for _,v in pairs(NPCs) do
						if npc:GetClass() == v then
						npc:AddEntityRelationship(p,D_NU,99)
						end
					end
				end
			end
			if p:KeyPressed( IN_ATTACK2 ) then
			p:uncloak()
			p:SetNWInt("drcharge", 2 )
			end
			if p:GetNWInt("drcharge") <= 8 and p:GetNWInt("drcharge") > 0 then
			p.cltimer = p.cltimer or CurTime() + 1
				if CurTime() > p.cltimer then
				p.cltimer = CurTime() + 1
				p:SetNWInt("drcharge", p:GetNWInt("drcharge") - 1)
				end
			elseif p:GetNWInt("drcharge") == 0 then
				p:uncloak()
			end
		end
	end
end
hook.Add( "Think", "DR_ENERGY", drthink )



end

function DRFootsteps( p, vPos, iFoot, strSoundName, fVolume, pFilter )

if p:Alive() and p:IsValid() then

if p:GetNWBool("CanAttack") == false and p:GetNWBool("Dead") == true and p:GetNWBool("Status") == 3 then

if CLIENT then
return true
end
end
end
end

hook.Add("PlayerFootstep","DeadRingerFootsteps",DRFootsteps)


-------------------------------------------------------------------------------

function SWEP:PrimaryAttack()

if self.Owner:GetNWBool("CanAttack") == true and self.Owner:GetNWBool("Dead") == false and self.Owner:GetNWBool("Status") != 4 then

self.Owner:SetNWBool(	"Status",			1)

self.Weapon:EmitSound("buttons/blip1.wav")

else
return
end
end

function SWEP:SecondaryAttack()
if self.Owner:GetNWBool("CanAttack") == true and self.Owner:GetNWBool("Dead") == false and self.Owner:GetNWBool("Status") != 4 then
self.Owner:SetNWBool(	"Status",			2)
self.Weapon:EmitSound("buttons/blip1.wav", 100, 73)
else
return
end
end
-------------------------------------------------------------------------------------


local meta = FindMetaTable( "Player" );

function meta:fakedeath()

self:SetNWBool("Dead", true)
self:SetNWBool("CanAttack", false)
self:SetNWBool("Status", 3)
self:SetColor(255,255,255,0)

---------------------------
--------"corpse"-------
---------------------------
-- this is time to make our corpse

	local pos = self:GetPos()
	local ang = self:GetAngles()
	local mdl = self:GetModel()
	local skn = self:GetSkin()
	local col = self:GetColor()
	local mat = self:GetMaterial()

-- create the ragdoll
local ent = ents.Create("prop_ragdoll")

	ent:SetPos(pos)
	ent:SetAngles(ang - Angle(ang.p,0,0))
	ent:SetModel(mdl)
	ent:SetSkin(skn)
	ent:SetMaterial("")
	ent:SetOwner(self)
	ent:SetCollisionGroup( COLLISION_GROUP_NONE )
	ent:Spawn()	
	ent.Corpse = true


local vel = self:GetVelocity()

	for i = 1, ent:GetPhysicsObjectCount() do
		local bone = ent:GetPhysicsObjectNum(i)
		
		if bone and bone.IsValid and bone:IsValid() then
			local bonepos, boneang = self:GetBonePosition(ent:TranslatePhysBoneToBone(i))
			
			bone:SetPos(bonepos)
			bone:SetAngle(boneang)
			
			bone:AddVelocity(vel*2)
		end
	end

end

-- here goes the uncloak function
function meta:uncloak()

	for _, ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "prop_ragdoll" and ent:GetOwner() == self and ent.Corpse then
		ent:Remove()
		end
	end
	
	for _,npc in pairs(ents.GetAll()) do 
		if npc:IsNPC() then 
			for k,v in pairs(NPCs) do 
				if npc:GetClass() == v then
				npc:AddEntityRelationship(self,D_HT,99) 
				end
			end
		end
	end
	
	self:SetNWBool(	"Dead",			false)
	self:SetNWBool(	"CanAttack",			true)
	self:SetNWBool(	"Status",			4)
	self:GetViewModel():SetMaterial("")
	self:SetMaterial("")
	self:SetColor(255,255,255,255)
	
	self:DrawWorldModel(true)

	self:SetMaterial("")

	self:EmitSound(Sound( "player/spy_uncloak_feigndeath.wav" ))

	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetEntity( self )
	util.Effect( "uncloak", effectdata )

end

function SWEP:OnDrop()
		self:SetColor(255,255,255,0)
end