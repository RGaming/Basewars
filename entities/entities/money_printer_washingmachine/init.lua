-- ============================================
-- =                                          =
-- =          Crate SENT by Mahalis           =
-- =                                          =
-- ============================================

// copy pasta from DURG lab

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel( "models/props_c17/FurnitureWashingmachine001a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetColor(0, 0, 0, 1)
	
	self.Dish2 = ents.Create("prop_dynamic_override")
	self.Dish2:SetModel( "models/props_c17/FurnitureWashingmachine001a.mdl" )
	self.Dish2:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Up())
	self.Dish2:SetAngles(Angle(0,0,0))
	self.Dish2:SetParent(self.Entity)
	self.Dish2:SetSolid(SOLID_NONE)
	self.Dish2:SetMoveType(MOVETYPE_NONE)
	
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	timer.Create( tostring(self.Entity), 25, 0, self.giveMoney, self)
	timer.Create( tostring(self.Entity) .. "fuckafkfags", 1000, 1, self.shutOff, self)
	timer.Create( tostring(self.Entity) .. "notifyoff", 750, 1, self.notifypl, self)
	self.Entity:SetNWBool("sparking",false)
	self.Entity:SetNWInt("damage",200)
	self.Entity:SetNWInt("upgrade", 0)
	local ply = self.Owner
	ply:GetTable().maxPrinter=ply:GetTable().maxPrinter + 1
	self.Inactive = false
	self.NearInact = false
	self.Entity:SetNWInt("power",0)
	self.Payout = {50000, "Washing Machine Printer"}
end

function ENT:giveMoney()
	local ply = self.Owner
	if(ValidEntity(ply) && !self.Inactive && self.Entity:IsPowered()) then
		// ply:AddMoney( 25 );
		
		local trace = { }
		
		trace.start = self.Entity:GetPos()+self.Entity:GetAngles():Up()*15;
		trace.endpos = trace.start + self.Entity:GetAngles():Forward() + self.Entity:GetAngles():Right()
		trace.filter = self.Entity
		
		local tr = util.TraceLine( trace );
		local amount = math.random( 250, 251 )
		if (self.Entity:GetNWInt("upgrade")==2) then
			amount = math.random( 1000, 1010 )
		elseif (self.Entity:GetNWInt("upgrade")==1) then
			amount = math.random( 500, 510 )
		end
		local moneybag = ents.Create( "prop_moneybag" );
		moneybag:SetModel( "models/notes.mdl" );
		moneybag:SetPos( tr.HitPos );
		moneybag:SetAngles(self.Entity:GetAngles())
		moneybag:Spawn();
		moneybag:SetColor(200,255,200,255)
		moneybag:SetMoveType( MOVETYPE_VPHYSICS )		
		moneybag:GetTable().MoneyBag = true;
		moneybag:GetTable().Amount = amount
		
		Notify( ply, 0, 3, "Counterfeit money printer created $" .. amount );
	elseif (self.Inactive) then
		Notify( ply, 4, 3, "A money printer is inactive, press use on it to make it active again." );
	elseif !self.Entity:IsPowered() then
		Notify(ply, 4, 3, "A money printer does not have enough power. Get a power plant.")
	end
end

function ENT:shutOff()
	local ply = self.Owner
	self.Inactive = true
	Notify( ply, 1, 3, "NOTICE: A MONEY PRINTER HAS GONE INACTIVE" );
	Notify( ply, 1, 3, "PRESS USE ON IT TO CONTINUE GETTING MONEY" );
	self.Dish2:SetColor(255,0,0,255)
end
function ENT:notifypl()
	self.NearInact = true
	local ply = self.Owner
	Notify( ply, 4, 3, "NOTICE: A MONEY PRINTER IS ABOUT TO GO INACTIVE" );
	Notify( ply, 4, 3, "PRESS USE ON IT TO PREVENT THIS" );
	self.Dish2:SetColor(255,150,150,255)
end

function ENT:Use(activator,caller)
	local ply = self.Owner
	if (self.NearInact==true && activator==ply && self.Entity:GetNWBool("sparking")==false && ply:CanAfford(40)) then
		ply:AddMoney( -40 )
		self.NearInact = false
		self.Entity:SetNWBool("sparking",true)
		timer.Create( tostring(self.Entity) .. "resupply", 1, 1, self.Reload, self)
		
	end
end

function ENT:Reload()
	Notify(self.Owner, 0, 3, "Counterfeit money printer resupplied")
	timer.Destroy( tostring(self.Entity) .. "fuckafkfags")
	timer.Create( tostring(self.Entity) .. "fuckafkfags", 600, 1, self.shutOff, self)
	timer.Destroy( tostring(self.Entity) .. "notifyoff")
	timer.Create( tostring(self.Entity) .. "notifyoff", 480, 1, self.notifypl, self)
	self.Inactive = false
	self.NearInact = false
	self.Dish2:SetColor(255,255,255,255)
	local drugPos = self.Entity:GetPos()
	self.Entity:SetNWBool("sparking",false)
end
 
function ENT:Think()
	if (ValidEntity(self.Owner)==false) then
		self.Entity:Remove()
	end
end

function ENT:OnRemove( )
	timer.Destroy(tostring(self.Entity)) 
	timer.Destroy(tostring(self.Entity) .. "fuckafkfags")
	timer.Destroy(tostring(self.Entity) .. "notifyoff")
	local ply = self.Owner
	if ValidEntity(ply) then
		ply:GetTable().maxPrinter=ply:GetTable().maxPrinter - 1
	end
end

