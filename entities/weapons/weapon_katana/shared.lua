if( SERVER ) then
AddCSLuaFile( "shared.lua" )
end
resource.AddFile("models/weapons/w_katana.mdl")
resource.AddFile("models/weapons/v_katana.mdl")
resource.AddFile("materials/models/weapons/v_katana/katana_normal.vtf")
resource.AddFile("materials/models/weapons/v_katana/katana.vtf")
resource.AddFile("materials/models/weapons/v_katana/katana.vmt")
resource.AddFile("materials/weapons/weapon_katana.vmt")
resource.AddFile("materials/weapons/weapon_katana.vtf")
resource.AddFile("materials/vgui/entities/weapon_katana.vmt")
resource.AddFile("materials/vgui/entities/weapon_katana.vtf")
resource.AddFile("sound/katana/glass_hit_1.wav")
resource.AddFile("sound/katana/glass_hit_2.wav")
resource.AddFile("sound/katana/glass_hit_3.wav")
resource.AddFile("sound/katana/wood_hit_1.wav")
resource.AddFile("sound/katana/wood_hit_2.wav")
resource.AddFile("sound/katana/wood_hit_3.wav")
resource.AddFile("sound/katana/ground_hit_1.wav")
resource.AddFile("sound/katana/ground_hit_2.wav")
resource.AddFile("sound/katana/ground_hit_3.wav")
resource.AddFile("sound/katana/ground_hit_4.wav")
resource.AddFile("sound/katana/ground_hit_5.wav")
resource.AddFile("sound/katana/metal_hit_1.wav")
resource.AddFile("sound/katana/metal_hit_2.wav")
resource.AddFile("sound/katana/metal_hit_3.wav")
resource.AddFile("sound/katana/metal_hit_4.wav")
resource.AddFile("sound/katana/metal_hit_5.wav")
resource.AddFile("sound/katana/metal_hit_6.wav")
resource.AddFile("sound/katana/metal_hit_7.wav")
resource.AddFile("sound/katana/draw.wav")

if( CLIENT ) then
SWEP.BounceWeaponIcon = false
SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_katana")
killicon.Add("weapon_katana","weapons/weapon_katana",Color(255,255,255))
end

SWEP.PrintName = "Katana"
SWEP.Slot = 1
SWEP.SlotPos = 3
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Author			= "Baddog"
SWEP.Instructions	= "Left click to slash. Right click to bash."
SWEP.Contact		= ""
SWEP.Purpose		= "Cut people up."
SWEP.Category		= "Baddog's Weapons"

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true


SWEP.ViewModel      = "models/weapons/v_katana.mdl"
SWEP.WorldModel   	= "models/weapons/w_katana.mdl"

SWEP.Primary.Delay				= 0.5
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic   		= false
SWEP.Primary.Ammo         		= "none"

SWEP.Secondary.Delay			= 0.4
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic  	 	= false
SWEP.Secondary.Ammo         	= "none"


function SWEP:Initialize()
self:SetWeaponHoldType("sword")
SWoodHit = {
	Sound( "katana/wood_hit_1.wav" ),
	Sound( "katana/wood_hit_2.wav" ),
	Sound( "katana/wood_hit_3.wav" )}
SFleshHit = {
	Sound( "ambient/machines/slicer1.wav" ),
	Sound( "ambient/machines/slicer2.wav" ),
	Sound( "ambient/machines/slicer3.wav" ),
	Sound( "ambient/machines/slicer4.wav" )} 
SGlassHit = {
	Sound( "katana/glass_hit_1.wav" ),
	Sound( "katana/glass_hit_2.wav" ),
	Sound( "katana/glass_hit_3.wav" )}
SMetalHit = {
	Sound( "katana/metal_hit_1.wav" ),
	Sound( "katana/metal_hit_2.wav" ),
	Sound( "katana/metal_hit_3.wav" ),
	Sound( "katana/metal_hit_4.wav" ),
	Sound( "katana/metal_hit_5.wav" ),
	Sound( "katana/metal_hit_6.wav" ),
	Sound( "katana/metal_hit_7.wav" )}
SGroundHit = {
	Sound( "katana/ground_hit_1.wav" ),
	Sound( "katana/ground_hit_2.wav" ),
	Sound( "katana/ground_hit_3.wav" ),
	Sound( "katana/ground_hit_4.wav" ),
	Sound( "katana/ground_hit_5.wav" )}
BWoodHit = {
	Sound( "physics/wood/wood_box_impact_hard1.wav" ),
	Sound( "physics/wood/wood_box_impact_hard2.wav" ),
	Sound( "physics/wood/wood_box_impact_hard3.wav" ),
	Sound( "physics/wood/wood_box_impact_hard4.wav" ),
	Sound( "physics/wood/wood_box_impact_hard5.wav" ),
	Sound( "physics/wood/wood_box_impact_hard6.wav" )}
BFleshHit = {
	Sound( "physics/flesh/flesh_impact_hard1.wav" ),
	Sound( "physics/flesh/flesh_impact_hard2.wav" ),
	Sound( "physics/flesh/flesh_impact_hard3.wav" ),
	Sound( "physics/flesh/flesh_impact_hard4.wav" ),
	Sound( "physics/flesh/flesh_impact_hard5.wav" ),
	Sound( "physics/flesh/flesh_impact_hard6.wav" )}
BGlassHit = {
	Sound( "physics/glass/glass_sheet_impact_hard1.wav" ),
	Sound( "physics/glass/glass_sheet_impact_hard2.wav" ),
	Sound( "physics/glass/glass_sheet_impact_hard3.wav" )}
BRockHit = {
	Sound( "physics/concrete/concrete_impact_hard1.wav" ),
	Sound( "physics/concrete/concrete_impact_hard2.wav" ),
	Sound( "physics/concrete/concrete_impact_hard3.wav" )}
BMetalHit = {
	Sound( "physics/metal/metal_barrel_impact_hard1.wav" ),
	Sound( "physics/metal/metal_barrel_impact_hard2.wav" ),
	Sound( "physics/metal/metal_barrel_impact_hard3.wav" ),
	Sound( "physics/metal/metal_barrel_impact_hard5.wav" ),
	Sound( "physics/metal/metal_barrel_impact_hard6.wav" ),
	Sound( "physics/metal/metal_barrel_impact_hard7.wav" ),
	Sound( "physics/metal/metal_box_impact_hard1.wav" ),
	Sound( "physics/metal/metal_box_impact_hard2.wav" ),
	Sound( "physics/metal/metal_box_impact_hard3.wav" ),
	Sound( "physics/metal/metal_computer_impact_hard1.wav" ),
	Sound( "physics/metal/metal_computer_impact_hard2.wav" ),
	Sound( "physics/metal/metal_computer_impact_hard3.wav" ),
	Sound( "physics/metal/metal_grate_impact_hard1.wav" ),
	Sound( "physics/metal/metal_grate_impact_hard2.wav" ),
	Sound( "physics/metal/metal_grate_impact_hard3.wav" ),
	Sound( "physics/metal/metal_sheet_impact_hard2.wav" ),
	Sound( "physics/metal/metal_sheet_impact_hard6.wav" ),
	Sound( "physics/metal/metal_sheet_impact_hard7.wav" ),
	Sound( "physics/metal/metal_sheet_impact_hard8.wav" ),
	Sound( "physics/metal/metal_solid_impact_hard1.wav" ),
	Sound( "physics/metal/metal_solid_impact_hard4.wav" ),
	Sound( "physics/metal/metal_solid_impact_hard5.wav" )}
BGroundHit = {
	Sound( "physics/surfaces/sand_impact_bullet1.wav" ),
	Sound( "physics/surfaces/sand_impact_bullet2.wav" ),
	Sound( "physics/surfaces/sand_impact_bullet3.wav" ),
	Sound( "physics/surfaces/sand_impact_bullet4.wav" )}
end

function SWEP:Holster()
return true
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire(CurTime() + 0.7)
	self:SetNextSecondaryFire(CurTime() + 0.7)
	self.Weapon:EmitSound("katana/draw.wav")
return true
end

function SWEP:OnRemove()
return true
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	timer.Simple(0.25,self.Bash, self)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	timer.Simple(0.25,self.Slash, self)
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:Slash()
 	local phtr = self.Owner:GetEyeTrace()
	local trace = util.GetPlayerTrace(self.Owner)
 	local tr = util.TraceLine(trace)
	local ph = phtr.Entity:GetPhysicsObject()
	if (self.Owner:GetPos() - tr.HitPos):Length() < 100 then
		if tr.Entity:IsPlayer() or string.find(tr.Entity:GetClass(),"npc") or string.find(tr.Entity:GetClass(),"prop_ragdoll") or tr.MatType == MAT_FLESH or tr.MatType == MAT_ALIENFLESH or tr.MatType == MAT_ANTLION then
			self.Weapon:EmitSound( SFleshHit[math.random(1,#SFleshHit)] )
					bullet = {}
					bullet.Num    = 1
					bullet.Src    = self.Owner:GetShootPos()
					bullet.Dir    = self.Owner:GetAimVector()
					bullet.Spread = Vector(0, 0, 0)
					bullet.Tracer = 0
					bullet.Force  = 20
					bullet.Damage = 40
				self.Owner:FireBullets(bullet) 
		else
			util.Decal("ManhackCut", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
				
				if (tr.MatType == MAT_METAL or tr.MatType == MAT_VENT or tr.MatType == MAT_COMPUTER) then
				self.Weapon:EmitSound(SMetalHit[math.random(1,#SMetalHit)])
				elseif (tr.MatType == MAT_WOOD or tr.MatType == "MAT_FOLIAGE") then
				self.Weapon:EmitSound(SWoodHit[math.random(1,#SWoodHit)])
				elseif (tr.MatType == MAT_GLASS) then
				self.Weapon:EmitSound(SGlassHit[math.random(1,#SGlassHit)])
				elseif (tr.MatType == MAT_DIRT or tr.MatType == MAT_SAND or tr.MatType == MAT_SLOSH or tr.MatType == MAT_TILE or tr.MatType == MAT_PLASTIC or tr.MatType == MAT_CONCRETE) then
				self.Weapon:EmitSound(SGroundHit[math.random(1,#SGroundHit)])
				else 
				self.Weapon:EmitSound(SGroundHit[math.random(1,#SGroundHit)])
				end
			if not tr.HitWorld and not string.find(tr.Entity:GetClass(),"prop_static") then
				if SERVER then ph:ApplyForceCenter(self.Owner:GetAimVector()*5000) 
				tr.Entity:TakeDamage(40, self.Owner, self)
				end
			end
		end
	else
		self.Weapon:EmitSound("Weapon_Knife.Slash")
	end
end

function SWEP:Bash()
 	local phtr = self.Owner:GetEyeTrace()
	local trace = util.GetPlayerTrace(self.Owner)
 	local tr = util.TraceLine(trace)
	local ph = phtr.Entity:GetPhysicsObject()
	if (self.Owner:GetPos() - tr.HitPos):Length() < 100 then
		if tr.Entity:IsPlayer() or string.find(tr.Entity:GetClass(),"npc") or string.find(tr.Entity:GetClass(),"prop_ragdoll") or tr.MatType == MAT_FLESH then
			self.Weapon:EmitSound( BFleshHit[math.random(1,#BFleshHit)] )
			tr.Entity:SetVelocity((phtr.Entity:GetPos() - self.Owner:GetPos()) * 20)
			if SERVER then
			tr.Entity:TakeDamage(10, self.Owner, self)
			end
		else
			if (tr.MatType == MAT_METAL or tr.MatType == MAT_VENT or tr.MatType == MAT_COMPUTER) then
			self.Weapon:EmitSound(BMetalHit[math.random(1,#BMetalHit)])
			elseif (tr.MatType == MAT_WOOD or tr.MatType == "MAT_FOLIAGE") then
			self.Weapon:EmitSound(BWoodHit[math.random(1,#BWoodHit)])
			elseif (tr.MatType == MAT_GLASS) then
			self.Weapon:EmitSound(BGlassHit[math.random(1,#BGlassHit)])
			elseif (tr.MatType == MAT_DIRT or tr.MatType == MAT_SAND or tr.MatType == MAT_SLOSH or tr.MatType == MAT_TILE or tr.MatType == MAT_PLASTIC) then
			self.Weapon:EmitSound(BGroundHit[math.random(1,#BGroundHit)])
			elseif (tr.MatType == MAT_CONCRETE) then
			self.Weapon:EmitSound(BRockHit[math.random(1,#BRockHit)])
			else
			self.Weapon:EmitSound(BGroundHit[math.random(1,#BGroundHit)])
			end	
			if not tr.HitWorld and not string.find(tr.Entity:GetClass(),"prop_static") then
				if SERVER then ph:ApplyForceCenter(self.Owner:GetAimVector()*10000) 
				tr.Entity:TakeDamage(10, self.Owner, self)
				end
			end
		end
	else
		self.Weapon:EmitSound("Weapon_Knife.Slash")
	end
end


local ActIndex = {}
	ActIndex["pistol"] 		= ACT_HL2MP_IDLE_PISTOL
	ActIndex["smg"] 			= ACT_HL2MP_IDLE_SMG1
	ActIndex["grenade"] 		= ACT_HL2MP_IDLE_GRENADE
	ActIndex["ar2"] 			= ACT_HL2MP_IDLE_AR2
	ActIndex["shotgun"] 		= ACT_HL2MP_IDLE_SHOTGUN
	ActIndex["rpg"]	 		= ACT_HL2MP_IDLE_RPG
	ActIndex["physgun"] 		= ACT_HL2MP_IDLE_PHYSGUN
	ActIndex["crossbow"] 		= ACT_HL2MP_IDLE_CROSSBOW
	ActIndex["melee"] 		= ACT_HL2MP_IDLE_MELEE
	ActIndex["slam"] 			= ACT_HL2MP_IDLE_SLAM
	ActIndex["normal"]		= ACT_HL2MP_IDLE
	ActIndex["knife"]			= ACT_HL2MP_IDLE_KNIFE
	ActIndex["sword"]			= ACT_HL2MP_IDLE_MELEE2
	ActIndex["passive"]		= ACT_HL2MP_IDLE_PASSIVE
	ActIndex["fist"]			= ACT_HL2MP_IDLE_FIST

function SWEP:SetWeaponHoldType(t)

	local index = ActIndex[t]
	
	if (index == nil) then
		Msg("SWEP:SetWeaponHoldType - ActIndex[ \""..t.."\" ] isn't set!\n")
		return
	end

self.ActivityTranslate = {}
self.ActivityTranslate [ ACT_MP_STAND_IDLE ]				= index
self.ActivityTranslate [ ACT_MP_WALK ]						= index+1
self.ActivityTranslate [ ACT_MP_RUN ]						= index+2        
self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ]				= index+3
self.ActivityTranslate [ ACT_MP_CROUCHWALK ]				= index+4
self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index+5
self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index+5
self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]				= index+6
self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]				= index+6
self.ActivityTranslate [ ACT_MP_JUMP ]						= index+7
self.ActivityTranslate [ ACT_RANGE_ATTACK1 ]				= index+8
	if t == "normal" then
		self.ActivityTranslate [ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
	if t == "passive" then
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] = ACT_HL2MP_CROUCH_IDLE
	end	
	self:SetupWeaponHoldTypeForAI(t)
end

function SWEP:TranslateActivity(act)

	if (self.Owner:IsNPC()) then
		if (self.ActivityTranslateAI[act]) then
			return self.ActivityTranslateAI[act]
		end

		return -1
	end

	if (self.ActivityTranslate[act] != nil) then
		return self.ActivityTranslate[act]
	end
	
	return -1
end