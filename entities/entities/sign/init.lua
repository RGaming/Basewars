/* ======================================
	sign
	A sign that has text drawn in the air,
         or something.
   ====================================== */

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')


function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 42
	
	local ent = ents.Create( "sign" )
	ent:SetPos( SpawnPos )
	ent:SetNWString("text","Holy shit, I am bored.")
	ent:Spawn()
	ent:Activate()
	return ent
	
end

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.Entity:SetModel( "models/props_junk/plasticbucket001a.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		//phys:EnableGravity(false)
	end
	self.DidHit = false
	self.GoofyTiem = CurTime()
	self.Upgraded = false
	local ply = self.Owner
	ply:GetTable().maxsign=ply:GetTable().maxsign + 1
	self.Damage = 300
end

function ENT:Think()
	if (!ValidEntity(self.Owner)) then
		self.Entity:Remove()
	end
end

function ENT:OnRemove()
	local ply = self.Owner
	if ValidEntity(ply) then
		ply:GetTable().maxsign=ply:GetTable().maxsign - 1
	end
end

function ENT:SetMode(t)
	self.Entity:SetNWInt("mode",t)
end

function ENT:OnTakeDamage(dmg)
	local damage = dmg:GetDamage()
	local attacker=dmg:GetAttacker()
	local inflictor=dmg:GetInflictor()
	if !dmg:IsExplosionDamage() && ValidEntity(attacker) && attacker:IsPlayer() && attacker:GetTable().ArmorPiercered then
		damage = damage*drugeffect_armorpiercermod
	end
	if self.Damage>0 then
		self.Damage = self.Damage - damage
		if(self.Damage <= 0) then
			self.Entity:Remove()
		end
	end
end