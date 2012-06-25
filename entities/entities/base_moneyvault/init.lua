
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:OnTakeDamage(dmg)
	local damage = dmg:GetDamage()
	local attacker=dmg:GetAttacker()
	local inflictor=dmg:GetInflictor()
	if !dmg:IsExplosionDamage() && ValidEntity(attacker) && attacker:IsPlayer() && attacker:GetTable().ArmorPiercered then
		damage = damage*drugeffect_armorpiercermod
	end
	if self.Entity:GetNWInt("damage")>0 then
		self.Entity:SetNWInt("damage",self.Entity:GetNWInt("damage") - damage)
		if(self.Entity:GetNWInt("damage") <= 0) then
			self.Entity:Explode() 
			if self.Payout!=nil && attacker:IsPlayer() then
				local pay=self.Payout[1]*.75
				if attacker:IsAdmin() or attacker:IsUserGroup("donator") then
					pay=self.Payout[1]
				end
				pay=math.ceil(pay)
				attacker:AddMoney(pay)
				Notify(attacker,2,3,"Paid "..tostring(pay).." for destroying a "..self.Payout[2])
			end
			if inflictor:GetClass()!="bigbomb" && inflictor:GetClass()!="env_physexplosion" && self.MakeScraps!=nil then
				self.Entity:MakeScraps()
			end
			self.Entity:Remove()
		
		end
	end
end

function ENT:Explode()

	local vPoint = self.Entity:GetPos()
	local effectdata = EffectData() 
	effectdata:SetStart( vPoint )
	effectdata:SetOrigin( vPoint ) 
	effectdata:SetScale( 1 ) 
	util.Effect( "Explosion", effectdata )
end