-- ============================================
-- =                                          =
-- =          Crate SENT by Mahalis           =
-- =                                          =
-- ============================================

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

	self.Entity:SetModel( "models/props_vehicles/generatortrailer01.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	self.Entity:SetNWInt("damage",300)
	self.Entity:SetNWInt("upgrade", 0)
	local ply = self.Owner
	ply:GetTable().maxgenerator=ply:GetTable().maxgenerator + 1
	self.Inactive = false
	self.Powdist=1024
	self.Entity:SetNWEntity("socket1",nil)
	self.Entity:SetNWEntity("socket2",nil)
	self.Entity:SetNWEntity("socket3",nil)
	self.Entity:SetNWEntity("socket4",nil)
	self.Entity:SetNWEntity("socket5",nil)
	self.scrap = false
	timer.Create( tostring(self.Entity), 60, 0, self.giveMoney, self)
	timer.Create( tostring(self.Entity) .. "fuckafkfags", 1200, 1, self.shutOff, self)
	timer.Create( tostring(self.Entity) .. "notifyoff", 1080, 1, self.notifypl, self)
end

function ENT:giveMoney()
	local ply = self.Owner
	if(ValidEntity(ply) && !self.Inactive) then
		if ply:CanAfford(5) then
			ply:AddMoney( -5 );
			Notify( ply, 2, 3, "$5 spent to keep Generator running." );
		else
			Notify( ply, 4, 3, "Generator has shut off from lack of money" )
			self.Entity:shutOff()
			timer.Destroy( tostring(self.Entity) .. "fuckafkfags")
			timer.Destroy( tostring(self.Entity) .. "notifyoff")
		end
	elseif (self.Inactive) then
		Notify( ply, 4, 3, "A Generator is inactive, press use on it to make it active again." );
	end
end

function ENT:shutOff()
	local ply = self.Owner
	self.Inactive = true
	Notify( ply, 1, 3, "NOTICE: A GENERATOR HAS GONE INACTIVE" );
	Notify( ply, 1, 3, "PRESS USE ON IT TO MAKE IT WORK AGAIN" );
	self.Entity:SetColor(255,0,0,255)
end
function ENT:notifypl()
	local ply = self.Owner
	Notify( ply, 4, 3, "NOTICE: A GENERATOR IS ABOUT TO GO INACTIVE" );
	Notify( ply, 4, 3, "PRESS USE ON IT TO KEEP IT WORKING" );
	self.Entity:SetColor(255,150,150,255)
end

function ENT:Use(activator,caller)
	if activator:CanAfford(5) && activator==self.Owner then
		timer.Destroy( tostring(self.Entity) .. "fuckafkfags")
		timer.Create( tostring(self.Entity) .. "fuckafkfags", 1200, 1, self.shutOff, self)
		timer.Destroy( tostring(self.Entity) .. "notifyoff")
		timer.Create( tostring(self.Entity) .. "notifyoff", 1080, 1, self.notifypl, self)
		self.Inactive = false
		self.Entity:SetColor(255,255,255,255)
	end
end

function ENT:createDrug()
	local drugPos = self.Entity:GetPos()
	drug = ents.Create("item_drug")
	drug:SetPos(Vector(drugPos.x,drugPos.y,drugPos.z + 10))
	drug:Spawn()
	self.Entity:SetNWBool("sparking",false)
end
 
function ENT:Think()
	if (ValidEntity(self.Owner)==false) then
		self.Entity:Remove()
	end
	self.Entity:UpdateSockets()
	self.Entity:NextThink(CurTime()+1)
	return true
end

function ENT:OnRemove( )
	self.Entity:UnSocket()
	timer.Destroy(tostring(self.Entity)) 
	timer.Destroy(tostring(self.Entity) .. "fuckafkfags")
	timer.Destroy(tostring(self.Entity) .. "notifyoff")
	local ply = self.Owner
	if ValidEntity(ply) then
		ply:GetTable().maxgenerator=ply:GetTable().maxgenerator - 1
	end
end

function ENT:UpdateSockets()
	if self.Inactive then
		self.Entity:UnSocket()
		for i=1,5,1 do
			self.Entity:SetNWEntity("socket"..tostring(i),ents.GetByIndex(0))
		end
	else
		for i=1,5,1 do
			if !ValidEntity(self.Entity:GetNWEntity("socket"..tostring(i))) then
				local newstructure = self.Entity:FindStructure()
				if ValidEntity(newstructure) then
					self.Entity:SetNWEntity("socket"..tostring(i), newstructure)
					newstructure:SetNWInt("power", newstructure:GetNWInt("power")+1)
				end
			end
		end
		for i=1,5,1 do
			if ValidEntity(self.Entity:GetNWEntity("socket"..tostring(i))) && self.Entity:GetNWEntity("socket"..tostring(i)):GetPos():Distance(self.Entity:GetPos())>self.Powdist then
				self.Entity:GetNWEntity("socket"..tostring(i)):SetNWInt("power", self.Entity:GetNWEntity("socket"..tostring(i)):GetNWInt("power")-1)
				// since it doesnt want to send a nil, or itself, well just "ground it out" so to speak.
				self.Entity:SetNWEntity("socket"..tostring(i),ents.GetByIndex(0))
			end
		end
	end
end

function ENT:FindStructure()
	for k, v in pairs( ents.FindInSphere(self.Entity:GetPos(), self.Powdist)) do
		if v:GetTable().Structure && v:GetNWInt("power")<v:GetTable().Power && v:GetPos():Distance(self.Entity:GetPos())<=self.Powdist then
			return v
		end
	end
	return nil
end


function ENT:MakeScraps()
end

function ENT:UnSocket()
	for i=1,5,1 do
		if ValidEntity(self.Entity:GetNWEntity("socket"..tostring(i))) then
			self.Entity:GetNWEntity("socket"..tostring(i)):SetNWInt("power", self.Entity:GetNWEntity("socket"..tostring(i)):GetNWInt("power")-1)
		end
	end
end