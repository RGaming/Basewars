-- ============================================
-- =                                          =
-- =          Crate SENT by Mahalis           =
-- =                                          =
-- ============================================

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	// hey, if you can think of a better model, then go right ahead.
	self.Entity:SetModel( "models/props/de_inferno/wine_barrel.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	timer.Create( tostring(self.Entity), 60, 0, self.giveMoney, self)
	timer.Create( tostring(self.Entity) .. "fuckafkfags", 1800, 1, self.shutOff, self)
	timer.Create( tostring(self.Entity) .. "notifyoff", 1680, 1, self.notifypl, self)
	self.Entity:SetNWBool("sparking",false)
	self.Entity:SetNWInt("damage",100)
	self.Entity:SetNWInt("upgrade", 0)
	local ply = self.Owner
	ply:GetTable().maxStill=ply:GetTable().maxStill + 1
	self.Inactive = false
	self.Entity:SetNWInt("power",0)
	self.Payout={CfgVars["stillcost"],"Still"}
end

function ENT:giveMoney()
	local ply = self.Owner
	if(ply:Alive() && !self.Inactive) then
		if (self.Entity:GetNWInt("upgrade")==2) then
			ply:AddMoney( 25 );
			Notify( ply, 2, 3, "Paid $25 for making moonshine." );
		elseif(self.Entity:GetNWInt("upgrade")==1) then
			ply:AddMoney( 15 );
			Notify( ply, 2, 3, "Paid $15 for making moonshine." );
		else
			ply:AddMoney( 10 );
			Notify( ply, 2, 3, "Paid $10 for making moonshine." );
		end
	elseif (self.Inactive) then
		Notify( ply, 4, 3, "A still is inactive, press use on it to make it active again." );
	end
end

function ENT:shutOff()
	local ply = self.Owner
	self.Inactive = true
	Notify( ply, 1, 3, "NOTICE: A STILL HAS GONE INACTIVE" );
	Notify( ply, 1, 3, "PRESS USE ON IT TO CONTINUE GETTING MONEY" );
	self.Entity:SetColor(255,0,0,255)
end
function ENT:notifypl()
	local ply = self.Owner
	Notify( ply, 4, 3, "NOTICE: A STILL IS ABOUT TO GO INACTIVE" );
	Notify( ply, 4, 3, "PRESS USE ON IT TO PREVENT THIS" );
	self.Entity:SetColor(255,150,150,255)
end

function ENT:Use(activator,caller)
	self.Entity:SetNWBool("sparking",true)
	timer.Create( tostring(self.Entity) .. "drug", 30, 1, self.createDrug, self)
	timer.Destroy( tostring(self.Entity) .. "fuckafkfags")
	timer.Create( tostring(self.Entity) .. "fuckafkfags", 1800, 1, self.shutOff, self)
	timer.Destroy( tostring(self.Entity) .. "notifyoff")
	timer.Create( tostring(self.Entity) .. "notifyoff", 1680, 1, self.notifypl, self)
	self.Inactive = false
	self.Entity:SetColor(255,255,255,255)
end

function ENT:createDrug()
	local ang = self.Entity:GetAngles()
	local spos = self.SparkPos
	drug = ents.Create("item_booze")
	drug:SetPos(self.Entity:GetPos()+ang:Forward()*spos.x+ang:Right()*spos.y+ang:Up()*spos.z)
	drug:Spawn()
	self.Entity:SetNWBool("sparking",false)
end
 
function ENT:Think()
	if (ValidEntity(self.Owner)==false) then
		self.Entity:Remove()
	end
	self.Entity:NextThink(CurTime()+0.1)
	return true
end

function ENT:OnRemove( )
	timer.Destroy(tostring(self.Entity)) 
	timer.Destroy(tostring(self.Entity) .. "drug")
	timer.Destroy(tostring(self.Entity) .. "fuckafkfags")
	timer.Destroy(tostring(self.Entity) .. "notifyoff")
	local ply = self.Owner
	if ValidEntity(ply) then
		ply:GetTable().maxStill=ply:GetTable().maxStill - 1
	end
end

