-- ============================================
-- =                                          =
-- =          Crate SENT by Mahalis           =
-- =                                          =
-- ============================================

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	
	self.Entity:SetModel("models/props_silo/processor.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetColor(0, 0, 0, 1)
	
	self.Dish2 = ents.Create("prop_dynamic_override")
	self.Dish2:SetModel( "models/props_silo/processor.mdl" )
	self.Dish2:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Up())
	self.Dish2:SetAngles(Angle(0,0,0))
	self.Dish2:SetParent(self.Entity)
	self.Dish2:SetSolid(SOLID_NONE)
	self.Dish2:SetMoveType(MOVETYPE_NONE)
	
	self.Box = ents.Create("prop_dynamic_override")
	self.Box:SetModel( "models/props_junk/PlasticCrate01a.mdl" )
	self.Box:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*-43+self.Entity:GetAngles():Right()+self.Entity:GetAngles():Up()*12)
	self.Box:SetAngles(Angle(0,90,0))
	self.Box:SetParent(self.Entity)
	self.Box:SetSolid(SOLID_CUSTOM)
	self.Box:SetMoveType(MOVETYPE_NONE)
	
	self.Box = ents.Create("prop_dynamic_override")
	self.Box:SetModel( "models/props_junk/PlasticCrate01a.mdl" )
	self.Box:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()+self.Entity:GetAngles():Right()*43+self.Entity:GetAngles():Up()*12)
	self.Box:SetAngles(Angle(0,0,0))
	self.Box:SetParent(self.Entity)
	self.Box:SetSolid(SOLID_CUSTOM)
	self.Box:SetMoveType(MOVETYPE_NONE)

	self.Box = ents.Create("prop_dynamic_override")
	self.Box:SetModel( "models/props_junk/PlasticCrate01a.mdl" )
	self.Box:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()+self.Entity:GetAngles():Right()*-43+self.Entity:GetAngles():Up()*12)
	self.Box:SetAngles(Angle(0,0,0))
	self.Box:SetParent(self.Entity)
	self.Box:SetSolid(SOLID_CUSTOM)
	self.Box:SetMoveType(MOVETYPE_NONE)
	
	self.Box3 = ents.Create("prop_dynamic_override")
	self.Box3:SetModel( "models/props_junk/PlasticCrate01a.mdl" )
	self.Box3:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*43+self.Entity:GetAngles():Right()+self.Entity:GetAngles():Up()*12)
	self.Box3:SetAngles(Angle(0,90,0))
	self.Box3:SetParent(self.Entity)
	self.Box3:SetSolid(SOLID_CUSTOM)
	self.Box3:SetMoveType(MOVETYPE_NONE)
	
	
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	timer.Create( tostring(self.Entity), 50, 0, self.giveMoney, self)
	timer.Create( tostring(self.Entity) .. "fuckafkfags", 1200, 1, self.shutOff, self)
	timer.Create( tostring(self.Entity) .. "notifyoff", 1080, 1, self.notifypl, self)
	self.Entity:SetNWInt("damage",250)
	self.Entity:SetNWInt("upgrade", 0)
	local ply = self.Owner
	ply:GetTable().maxstablemethlab=ply:GetTable().maxstablemethlab + 1
	self.Inactive = false
	self.Entity:SetNWInt("power",0)
	self.drugmaking = false
	self.Payout = {15000,"Meth Lab"}
	self.Playsound = false
end


function ENT:giveMoney()
	local ply = self.Owner
	local explodechance = 0.05
	if self.drugmaking then
	end
		if(ply:Alive() && !self.Inactive) then
			if (self.Entity:GetNWInt("upgrade")==2) then
				ply:AddMoney( 500 );
				Notify( ply, 2, 3, "Paid $500 for selling drugs." );
			elseif(self.Entity:GetNWInt("upgrade")==1) then
				ply:AddMoney( 250 );
				Notify( ply, 2, 3, "Paid $250 for selling drugs." );
			else
				ply:AddMoney( 100 );
				Notify( ply, 2, 3, "Paid $100 for selling drugs." );
			end
		elseif (self.Inactive) then
			Notify( ply, 4, 3, "A meth lab is inactive, press use on it to make it active again." );
		end
	end

function ENT:shutOff()
	local ply = self.Owner
	self.Inactive = true
	Notify( ply, 1, 3, "NOTICE: A METH LAB HAS GONE INACTIVE" );
	Notify( ply, 1, 3, "PRESS USE ON IT TO KEEP GETTING MONEY" );
	self.Dish2:SetColor(255,0,0,255)
end
function ENT:notifypl()
	local ply = self.Owner
	Notify( ply, 4, 3, "NOTICE: A METH LAB IS ABOUT TO GO INACTIVE" );
	Notify( ply, 4, 3, "PRESS USE ON IT TO PREVENT THIS" );
	self.Dish2:SetColor(255,150,150,255)
end

function ENT:Use(activator,caller)
	self.Playsound = true
		if self.Playsound and self.drugmaking then
		--	self.Playsound = false
		end
	self.drugmaking = true
	timer.Create( tostring(self.Entity) .. "drug", 200, 1, self.createDrug, self)
	timer.Destroy( tostring(self.Entity) .. "fuckafkfags")
	timer.Create( tostring(self.Entity) .. "fuckafkfags", 1200, 1, self.shutOff, self)
	timer.Destroy( tostring(self.Entity) .. "notifyoff")
	timer.Create( tostring(self.Entity) .. "notifyoff", 1080, 1, self.notifypl, self)
	self.Inactive = false
	self.Dish2:SetColor(255,255,255,255)
end

function ENT:createDrug()
	local spos=self.SparkPos
	local spos2=self.SparkPos2
	local spos3=self.SparkPos3
	local spos4=self.SparkPos4
	local ang=self.Entity:GetAngles()
	self.drugmaking = false
	self.Playsound = false
	local drugPos = self.Entity:GetPos()

	drug = ents.Create("item_random")
	drug:SetPos(self.Entity:GetPos()+ang:Forward()*spos.x+ang:Right()*spos.y+ang:Up()*spos.z)
	drug:Spawn()
	self.Entity:SetNWBool("sparking",false)

	drug2 = ents.Create("item_random")
	drug2:SetPos(self.Entity:GetPos()+ang:Forward()*spos2.x+ang:Right()*spos2.y+ang:Up()*spos2.z)
	drug2:Spawn()
	
	drug3 = ents.Create("item_random")
	drug3:SetPos(self.Entity:GetPos()+ang:Forward()*spos3.x+ang:Right()*spos3.y+ang:Up()*spos3.z)
	drug3:Spawn()
	
	drug4 = ents.Create("item_random")
	drug4:SetPos(self.Entity:GetPos()+ang:Forward()*spos4.x+ang:Right()*spos4.y+ang:Up()*spos4.z)
	drug4:Spawn()

end
 
function ENT:Think()
	if self.Playsound then
		if self.drugmaking then
			self:EmitSound("ambient/levels/labs/machine_moving_loop4.wav", 50, 100)
			else
			self:StopSound("ambient/levels/labs/machine_moving_loop4.wav")
			end
		end
	if (ValidEntity(self.Owner)==false) then
		self.Entity:Remove()
	end
	self.Entity:NextThink(CurTime()+0.1)
	return true
end

function ENT:OnRemove( )
	self:StopSound("ambient/levels/labs/machine_moving_loop4.wav")
	timer.Destroy(tostring(self.Entity)) 
	timer.Destroy(tostring(self.Entity) .. "drug")
	timer.Destroy(tostring(self.Entity) .. "fuckafkfags")
	timer.Destroy(tostring(self.Entity) .. "notifyoff")
	self.Playsound = false
	local ply = self.Owner
	if ValidEntity(ply) then
		ply:GetTable().maxstablemethlab=ply:GetTable().maxstablemethlab - 1
	end
end

