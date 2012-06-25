-- ============================================
-- =                                          =
-- =          Crate SENT by Mahalis           =
-- =                                          =
-- ============================================

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

	self.Entity:SetModel( "models/props/CS_militia/table_shed.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	self.Entity:SetNWInt("damage",100)
	self.Entity:SetNWInt("upgrade", 0)
	local ply = self.Owner
	ply:GetTable().maxsupplytable=ply:GetTable().maxsupplytable + 1
	self.OwnerID = ply:UniqueID()
	self.Inactive = false
	self.unowned = false
	self.Entity:SetNWInt("power",0)
	self.Payout={CfgVars["druglabcost"],"Drug Lab"}
	self.Dontcall3 = false
	self.Dontcall2 = false
	self.Dontcall1 = false

		--self.Entity:GetNWEntity( "upgrade" ) self.Entity:SetNWInt("upgrade", 0)
	self.SnipeShield = ents.Create("prop_dynamic_override")
	self.SnipeShield:SetModel( "models/Items/car_battery01.mdl" )
	self.SnipeShield:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*-10+self.Entity:GetAngles():Right()*-25+self.Entity:GetAngles():Up()*15)
	self.SnipeShield:SetAngles(Angle(0,0,0))
	self.SnipeShield:SetParent(self.Entity)
	self.SnipeShield:SetSolid(SOLID_NONE)
	self.SnipeShield:SetMoveType(MOVETYPE_NONE)
	self.SnipeShield:SetColor(255,255,255,0)
	
	self.SnipeShield2 = ents.Create("prop_dynamic_override")
	self.SnipeShield2:SetModel( "models/Items/car_battery01.mdl" )
	self.SnipeShield2:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*10+self.Entity:GetAngles():Right()*-25+self.Entity:GetAngles():Up()*15)
	self.SnipeShield2:SetAngles(Angle(0,0,0))
	self.SnipeShield2:SetParent(self.Entity)
	self.SnipeShield2:SetSolid(SOLID_NONE)
	self.SnipeShield2:SetMoveType(MOVETYPE_NONE)
	self.SnipeShield2:SetColor(255,255,255,0)
	
	self.SnipeShield3 = ents.Create("prop_dynamic_override")
	self.SnipeShield3:SetModel( "models/Items/car_battery01.mdl" )
	self.SnipeShield3:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*-10+self.Entity:GetAngles():Right()*-5+self.Entity:GetAngles():Up()*15)
	self.SnipeShield3:SetAngles(Angle(0,0,0))
	self.SnipeShield3:SetParent(self.Entity)
	self.SnipeShield3:SetSolid(SOLID_NONE)
	self.SnipeShield3:SetMoveType(MOVETYPE_NONE)
	self.SnipeShield3:SetColor(255,255,255,0)
	
	self.SnipeShield4 = ents.Create("prop_dynamic_override")
	self.SnipeShield4:SetModel( "models/Items/car_battery01.mdl" )
	self.SnipeShield4:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*10+self.Entity:GetAngles():Right()*-5+self.Entity:GetAngles():Up()*15)
	self.SnipeShield4:SetAngles(Angle(0,0,0))
	self.SnipeShield4:SetParent(self.Entity)
	self.SnipeShield4:SetSolid(SOLID_NONE)
	self.SnipeShield4:SetMoveType(MOVETYPE_NONE)
	self.SnipeShield4:SetColor(255,255,255,0)

	-------------Conducter
	self.Armor = ents.Create("prop_dynamic_override")
	self.Armor:SetModel( "models/props_c17/utilityconducter001.mdl" )
	self.Armor:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*10+self.Entity:GetAngles():Right()*-30+self.Entity:GetAngles():Up()*49)
	self.Armor:SetAngles(Angle(0,0,0))
	self.Armor:SetParent(self.Entity)
	self.Armor:SetSolid(SOLID_NONE)
	self.Armor:SetColor(100,100,150,255)
	self.Armor:SetMoveType(MOVETYPE_NONE)
	self.Armor:SetColor(255,255,255,0)
	
	self.Armor2 = ents.Create("prop_dynamic_override")
	self.Armor2:SetModel( "models/props_c17/utilityconducter001.mdl" )
	self.Armor2:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*-10+self.Entity:GetAngles():Right()*-30+self.Entity:GetAngles():Up()*49)
	self.Armor2:SetAngles(Angle(0,0,0))
	self.Armor2:SetParent(self.Entity)
	self.Armor2:SetSolid(SOLID_NONE)
	self.Armor2:SetColor(100,100,150,255)
	self.Armor2:SetMoveType(MOVETYPE_NONE)
	self.Armor2:SetColor(255,255,255,0)
	
	self.Armor3 = ents.Create("prop_dynamic_override")
	self.Armor3:SetModel( "models/props_c17/utilityconducter001.mdl" )
	self.Armor3:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*10+self.Entity:GetAngles():Right()*-10+self.Entity:GetAngles():Up()*49)
	self.Armor3:SetAngles(Angle(0,0,0))
	self.Armor3:SetParent(self.Entity)
	self.Armor3:SetSolid(SOLID_NONE)
	self.Armor3:SetColor(100,100,150,255)
	self.Armor3:SetMoveType(MOVETYPE_NONE)
	self.Armor3:SetColor(255,255,255,0)

	self.Armor4 = ents.Create("prop_dynamic_override")
	self.Armor4:SetModel( "models/props_c17/utilityconducter001.mdl" )
	self.Armor4:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*-10+self.Entity:GetAngles():Right()*-10+self.Entity:GetAngles():Up()*49)
	self.Armor4:SetAngles(Angle(0,0,0))
	self.Armor4:SetParent(self.Entity)
	self.Armor4:SetSolid(SOLID_NONE)
	self.Armor4:SetColor(100,100,150,255)
	self.Armor4:SetMoveType(MOVETYPE_NONE)
	self.Armor4:SetColor(255,255,255,0)

	--models/props/de_tides/Vending_hat.mdl
	

	self.Helmet = ents.Create("prop_dynamic_override")
	self.Helmet:SetModel( "models/props/de_tides/Vending_hat.mdl" )
	self.Helmet:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*-10+self.Entity:GetAngles():Right()*30+self.Entity:GetAngles():Up()*10)
	self.Helmet:SetAngles(Angle(0,270,0))
	self.Helmet:SetParent(self.Entity)
	self.Helmet:SetSolid(SOLID_NONE)
	self.Helmet:SetMoveType(MOVETYPE_NONE)
	self.Helmet:SetColor(255,255,255,0)
	     
	self.Helmet2 = ents.Create("prop_dynamic_override")
	self.Helmet2:SetModel( "models/props/de_tides/Vending_hat.mdl" )
	self.Helmet2:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*10+self.Entity:GetAngles():Right()*30+self.Entity:GetAngles():Up()*10)
	self.Helmet2:SetAngles(Angle(0,270,0))
	self.Helmet2:SetParent(self.Entity)
	self.Helmet2:SetSolid(SOLID_NONE)
	self.Helmet2:SetMoveType(MOVETYPE_NONE)
	self.Helmet2:SetColor(255,255,255,0)
	     
	self.Helmet3 = ents.Create("prop_dynamic_override")
	self.Helmet3:SetModel( "models/props/de_tides/Vending_hat.mdl" )
	self.Helmet3:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*-10+self.Entity:GetAngles():Right()*20+self.Entity:GetAngles():Up()*10)
	self.Helmet3:SetAngles(Angle(0,270,0))
	self.Helmet3:SetParent(self.Entity)
	self.Helmet3:SetSolid(SOLID_NONE)
	self.Helmet3:SetMoveType(MOVETYPE_NONE)
	self.Helmet3:SetColor(255,255,255,0)
	     
	self.Helmet4 = ents.Create("prop_dynamic_override")
	self.Helmet4:SetModel( "models/props/de_tides/Vending_hat.mdl" )
	self.Helmet4:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*10+self.Entity:GetAngles():Right()*20+self.Entity:GetAngles():Up()*10)
	self.Helmet4:SetAngles(Angle(0,270,0))
	self.Helmet4:SetParent(self.Entity)
	self.Helmet4:SetSolid(SOLID_NONE)
	self.Helmet4:SetMoveType(MOVETYPE_NONE)
	self.Helmet4:SetColor(255,255,255,0)
	--toolkit
	
	
	self.toolkit = ents.Create("prop_dynamic_override")
	self.toolkit:SetModel( "models/props_c17/tools_pliers01a.mdl" )
	self.toolkit:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*10+self.Entity:GetAngles():Right()*30+self.Entity:GetAngles():Up()*35)
	self.toolkit:SetAngles(Angle(0,0,0))
	self.toolkit:SetParent(self.Entity)
	self.toolkit:SetSolid(SOLID_NONE)
	self.toolkit:SetColor(100,100,150,255)
	self.toolkit:SetMoveType(MOVETYPE_NONE)
	self.toolkit:SetColor(255,255,255,255)
	
	self.toolkit2 = ents.Create("prop_dynamic_override")
	self.toolkit2:SetModel( "models/props_c17/tools_pliers01a.mdl" )
	self.toolkit2:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*-10+self.Entity:GetAngles():Right()*30+self.Entity:GetAngles():Up()*35)
	self.toolkit2:SetAngles(Angle(0,0,0))
	self.toolkit2:SetParent(self.Entity)
	self.toolkit2:SetSolid(SOLID_NONE)
	self.toolkit2:SetColor(100,100,150,255)
	self.toolkit2:SetMoveType(MOVETYPE_NONE)
	self.toolkit2:SetColor(255,255,255,255)
	
	self.toolkit3 = ents.Create("prop_dynamic_override")
	self.toolkit3:SetModel( "models/props_lab/monitor01b.mdl" )
	self.toolkit3:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*10+self.Entity:GetAngles():Right()*10+self.Entity:GetAngles():Up()*40.5)
	self.toolkit3:SetAngles(Angle(0,0,0))
	self.toolkit3:SetParent(self.Entity)
	self.toolkit3:SetSolid(SOLID_NONE)
	self.toolkit3:SetColor(100,100,150,255)
	self.toolkit3:SetMoveType(MOVETYPE_NONE)
	self.toolkit3:SetColor(255,255,255,255)

	self.toolkit4 = ents.Create("prop_dynamic_override")
	self.toolkit4:SetModel( "models/props_lab/monitor01b.mdl" )
	self.toolkit4:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*-10+self.Entity:GetAngles():Right()*10+self.Entity:GetAngles():Up()*40.5)
	self.toolkit4:SetAngles(Angle(0,0,0))
	self.toolkit4:SetParent(self.Entity)
	self.toolkit4:SetSolid(SOLID_NONE)
	self.toolkit4:SetColor(100,100,150,255)
	self.toolkit4:SetMoveType(MOVETYPE_NONE)
	self.toolkit4:SetColor(255,255,255,255)


end


function ENT:Use(activator,caller)
	upgradenum = self.Entity:GetNWEntity("upgrade")
		if (upgradenum==0) then
			if (caller:GetNWBool("tooled")==false) then
					if( not activator:CanAfford( 50 ) ) then
						return "";
					end
				caller:GetTable().Tooled = true
				caller:SetNWBool("tooled", true)
					activator:AddMoney( -50 )
					Notify( activator, 4, 3, "You bought a Toolkit for 50$." )
			if (caller:GetNWBool("scannered")==false) then
					if( not activator:CanAfford( 250 ) ) then
						return "";
					end
				caller:SetNWBool("scannered", true)
					activator:AddMoney( -250 )
					Notify( activator, 4, 3, "You bought a Scan Blocker for 250$." )
			end
		end
	end
		if (upgradenum==1) then
			if (caller:GetNWBool("helmeted")==false) then
					if( not activator:CanAfford( 250 ) ) then
						return "";
					end
				caller:SetNWBool("helmeted", true)
					activator:AddMoney( -250 )
					Notify( activator, 4, 3, "You bought a Helmet for 50$." )
			end
			if (caller:GetNWBool("tooled")==false) then
					if( not activator:CanAfford( 50 ) ) then
						return "";
					end
				caller:GetTable().Tooled = true
				caller:SetNWBool("tooled", true)
					activator:AddMoney( -50 )
					Notify( activator, 4, 3, "You bought a Toolkit for 50$." )
			end
			if (caller:GetNWBool("scannered")==false) then
					if( not activator:CanAfford( 250 ) ) then
						return "";
					end
				caller:SetNWBool("scannered", true)
					activator:AddMoney( -250 )
					Notify( activator, 4, 3, "You bought a Scan Blocker for 250$." )
			end
		end
		if (upgradenum==2) then
			if (caller:GetNWBool("helmeted")==false) then
					if( not activator:CanAfford( 250 ) ) then
						return "";
					end
				caller:SetNWBool("helmeted", true)
					activator:AddMoney( -250 )
					Notify( activator, 4, 3, "You bought a Helmet for 250$." )
			end
			if (caller:GetNWBool("tooled")==false) then
					if( not activator:CanAfford( 50 ) ) then
						return "";
					end
				caller:GetTable().Tooled = true
				caller:SetNWBool("tooled", true)
					activator:AddMoney( -50 )
					Notify( activator, 4, 3, "You bought a Toolkit for 50$." )
			end
			if (caller:Armor()<100) then
					if( not activator:CanAfford( 700 ) ) then
						return "";
					end
				caller:SetArmor(100)
					activator:AddMoney( -700 )
					Notify( activator, 4, 3, "You bought some Armor for 700$." )
			end
			if (caller:GetNWBool("scannered")==false) then
					if( not activator:CanAfford( 250 ) ) then
						return "";
					end
				caller:SetNWBool("scannered", true)
					activator:AddMoney( -250 )
					Notify( activator, 4, 3, "You bought a Scan Blocker for 250$." )
			end
		end
		if (upgradenum==3) then

			if (caller:GetNWBool("helmeted")==false) then
					if( not activator:CanAfford( 250 ) ) then
						return "";
					end
				caller:SetNWBool("helmeted", true)
					activator:AddMoney( -250 )
					Notify( activator, 4, 3, "You bought a Helmet for 250$." )
			end
			if (caller:GetNWBool("shielded")==false) then
					if( not activator:CanAfford( 500 ) ) then
						return "";
					end
				caller:GetTable().Shielded = true
				caller:SetNWBool("shielded", true)
					activator:AddMoney( -500 )
					Notify( activator, 4, 3, "You bought a Snipe Shield for 500$." )
			end
			if (caller:GetNWBool("tooled")==false) then
					if( not activator:CanAfford( 50 ) ) then
						return "";
					end
				caller:GetTable().Tooled = true
				caller:SetNWBool("tooled", true)
					activator:AddMoney( -50 )
					Notify( activator, 4, 3, "You bought a Toolkit for 50$." )
			end
			if (caller:Armor()<100) then
					if( not activator:CanAfford( 700 ) ) then
						return "";
					end
				caller:SetArmor(100)
					activator:AddMoney( -700 )
					Notify( activator, 4, 3, "You bought some Armor for 700$." )
			end
			if (caller:GetNWBool("scannered")==false) then
					if( not activator:CanAfford( 250 ) ) then
						return "";
					end
				caller:SetNWBool("scannered", true)
					activator:AddMoney( -250 )
					Notify( activator, 4, 3, "You bought a Scan Blocker for 250$." )
			end
		end
end

 
function ENT:Think()
	upgradenum = self.Entity:GetNWEntity("upgrade")
	
	if (self.Owner==false) then
		self.Entity:Remove()
	end
			if (upgradenum==1) and self.Dontcall1==false then
		self.Dontcall1 = true
		self.Helmet:SetColor(255,255,255,255)
		self.Helmet2:SetColor(255,255,255,255)
		self.Helmet3:SetColor(255,255,255,255)
		self.Helmet4:SetColor(255,255,255,255)
		end
			if (upgradenum==2) and self.Dontcall2==false then
		self.Dontcall2 = true
		self.Armor:SetColor(255,255,255,255)
		self.Armor2:SetColor(255,255,255,255)
		self.Armor3:SetColor(255,255,255,255)
		self.Armor4:SetColor(255,255,255,255)
		end
			if (upgradenum==3) and self.Dontcall3==false then
		self.Dontcall3 = true
		self.SnipeShield:SetColor(255,255,255,255)
		self.SnipeShield2:SetColor(255,255,255,255)
		self.SnipeShield3:SetColor(255,255,255,255)
		self.SnipeShield4:SetColor(255,255,255,255)
		end
	self.Entity:NextThink(CurTime()+0.1)
	return true
end


function ENT:OnRemove( )

	local ply = self.Owner
	if ValidEntity(ply) then
		ply:GetTable().maxsupplytable=ply:GetTable().maxsupplytable - 1
	end
end

