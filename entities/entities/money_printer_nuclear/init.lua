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
	self.Entity:SetModel("models/props/de_train/Barrel.mdl")

	self.Panel = ents.Create("prop_dynamic_override")
	self.Panel:SetModel( "models/props_lab/crematorcase.mdl" )
	self.Panel:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()+self.Entity:GetAngles():Up()*45)
	self.Panel:SetAngles(Angle(0,0,0))
	self.Panel:SetParent(self.Entity)
	self.Panel:SetSolid(SOLID_NONE)
	self.Panel:SetMoveType(MOVETYPE_NONE)
	self.Panel:SetColor(0,255,85,255)

	self.Panel1 = ents.Create("prop_dynamic_override")
	self.Panel1:SetModel( "models/props_lab/reciever01a.mdl" )
	self.Panel1:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*0+self.Entity:GetAngles():Right()*-15+self.Entity:GetAngles():Up()*15)
	self.Panel1:SetAngles(Angle(0,0,90))
	self.Panel1:SetParent(self.Entity)
	self.Panel1:SetSolid(SOLID_NONE)
	self.Panel1:SetMoveType(MOVETYPE_NONE)
	self.Panel1:SetColor(0,255,85,255)
	self.Panel1:SetMaterial( "models/shiny" )

	self.Panel2 = ents.Create("prop_dynamic_override")
	self.Panel2:SetModel( "models/props_lab/reciever01a.mdl" )
	self.Panel2:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*0+self.Entity:GetAngles():Right()*15+self.Entity:GetAngles():Up()*15)
	self.Panel2:SetAngles(Angle(0,0,90))
	self.Panel2:SetParent(self.Entity)
	self.Panel2:SetSolid(SOLID_NONE)
	self.Panel2:SetMoveType(MOVETYPE_NONE)
	self.Panel2:SetColor(0,255,85,255)
	self.Panel2:SetMaterial( "models/shiny" )

	self.Panel3 = ents.Create("prop_dynamic_override")
	self.Panel3:SetModel( "models/props_lab/reciever01a.mdl" )
	self.Panel3:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*15+self.Entity:GetAngles():Right()*0+self.Entity:GetAngles():Up()*15)
	self.Panel3:SetAngles(Angle(0,90,90))
	self.Panel3:SetParent(self.Entity)
	self.Panel3:SetSolid(SOLID_NONE)
	self.Panel3:SetMoveType(MOVETYPE_NONE)
	self.Panel3:SetColor(0,255,85,255)
	self.Panel3:SetMaterial( "models/shiny" )

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	timer.Create( tostring(self.Entity), 23, 0, self.giveMoney, self)
	timer.Create( tostring(self.Entity) .. "fuckafkfags", 60, 1, self.shutOff, self)
	timer.Create( tostring(self.Entity) .. "notifyoff", 50, 1, self.notifypl, self)
	self.Entity:SetNWBool("sparking",false)
	self.Entity:SetNWInt("damage",1000)
	self.Entity:SetNWInt("upgrade", 0)
	local ply = self.Owner
	ply:GetTable().maxPlatinumPrinter=ply:GetTable().maxPlatinumPrinter + 1
	self.Inactive = false
	self.NearInact = false
	self.Entity:SetNWInt("power",0)
	self.Payout = {10000000, "Printer"}
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
		local amount = math.random( 1000000, 1001000 )
		if (self.Entity:GetNWInt("upgrade")==2) then
			amount = math.random( 2500000, 2501000 )
		elseif (self.Entity:GetNWInt("upgrade")==1) then
			amount = math.random( 1250000, 1250000 )
		end
		local moneybag = ents.Create( "prop_moneybag" );
		moneybag:SetModel( "models/props/cs_assault/Money.mdl" );
		moneybag:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*17+self.Entity:GetAngles():Right()*0+self.Entity:GetAngles():Up()*15)
		moneybag:SetAngles(Angle(0,90,90))
		moneybag:Spawn();
		moneybag:SetColor(200,255,200,255)
			moneybag:SetMoveType( MOVETYPE_VPHYSICS )


		moneybag:GetTable().MoneyBag = true;
		moneybag:GetTable().Amount = amount

		local moneybag2 = ents.Create( "prop_moneybag" );
		moneybag2:SetModel( "models/props/cs_assault/Money.mdl" );
		moneybag2:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*0+self.Entity:GetAngles():Right()*17+self.Entity:GetAngles():Up()*15)
		moneybag2:SetAngles(Angle(0,0,90))
		moneybag2:Spawn();
		moneybag2:SetColor(200,255,200,255)
			moneybag2:SetMoveType( MOVETYPE_VPHYSICS )

		moneybag2:GetTable().MoneyBag = true;
		moneybag2:GetTable().Amount = amount

		local moneybag3 = ents.Create( "prop_moneybag" );
		moneybag3:SetModel( "models/props/cs_assault/Money.mdl" );
		moneybag3:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*0+self.Entity:GetAngles():Right()*-17+self.Entity:GetAngles():Up()*15)
		moneybag3:SetAngles(Angle(0,0,90))
		moneybag3:Spawn();
		moneybag3:SetMoveType( MOVETYPE_VPHYSICS )
		moneybag3:SetColor(200,255,200,255)

		moneybag3:GetTable().MoneyBag = true;
		moneybag3:GetTable().Amount = amount


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
	self.Entity:SetColor(255,0,0,254)
end
function ENT:notifypl()
	self.NearInact = true
	local ply = self.Owner
	Notify( ply, 4, 3, "NOTICE: A MONEY PRINTER IS ABOUT TO GO INACTIVE" );
	Notify( ply, 4, 3, "PRESS USE ON IT TO PREVENT THIS" );
	self.Entity:SetColor(255,150,150,254)
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
	timer.Create( tostring(self.Entity) .. "fuckafkfags", 60, 1, self.shutOff, self)
	timer.Destroy( tostring(self.Entity) .. "notifyoff")
	timer.Create( tostring(self.Entity) .. "notifyoff", 50, 1, self.notifypl, self)
	self.Inactive = false
	self.NearInact = false
	self.Entity:SetColor(229, 228, 226, 254)
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
		ply:GetTable().maxPlatinumPrinter=ply:GetTable().maxPlatinumPrinter - 1
	end
end

