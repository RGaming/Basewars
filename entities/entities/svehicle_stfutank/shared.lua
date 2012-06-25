 	
ENT.Type 		= "anim"
ENT.Base 		= "base_gmodentity"

ENT.PrintName	= "STFU Tank"
ENT.Author		= "HLTV Proxy"
ENT.Contact		= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:Initialize()
	util.PrecacheSound( "d1_canals.diesel_generator" ) // idle
	util.PrecacheSound( "d1_town.CarTrapMotorLoop" ) // drive
	util.PrecacheSound( "Town.d1_town_04_metal_solid_strain4" ) // gun open
	util.PrecacheSound( "coast.crane_metal_groan" ) // gun reload
	util.PrecacheSound( "Doors.FullClose2" ) // gun close
	
	self.sound_idle = CreateSound(self.Entity, Sound("d1_canals.diesel_generator"))
	self.sound_move = CreateSound(self.Entity, Sound("d1_town.CarTrapMotorLoop"))
	self.sound_open = CreateSound(self.Entity, Sound("Town.d1_town_04_metal_solid_strain4"))
	self.sound_load = CreateSound(self.Entity, Sound("coast.crane_metal_groan"))
	self.sound_lock = CreateSound(self.Entity, Sound("Doors.FullClose2"))
	
	self.Entity:SetModel( "models/props_wasteland/laundry_dryer002.mdl" )
	self.Entity:SetMaterial("models/props_combine/metal_combinebridge001")
	self.Entity:SetAngles(Angle(-90.00,180.00,180.00))
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetNWInt("damage",25000)
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	// we'll hold the 8 armor plates of its' sides in a table.
	self.Plates = {}
	self.Wheels = {}
	// gun parts will only be the parts that actually move up/down as well, not the rotating base of it.
	self.GunParts = {}
	self.Driver = nil
	self.GunAngles = Angle(0,0,0)
	// we use thrust because the wheels quickly become unreliable on uneven terrain.
	// also code copied from gmod_thruster (obviously)
	
	local max = self.Entity:OBBMaxs()
	local min = self.Entity:OBBMins()
	
	self.ThrustOffset 	= Vector( 0, 0, max.z )
	self.ThrustOffsetR 	= Vector( 0, 0, min.z )
	self.TThrustOffset 	= Vector( 0, max.y, 0 )
	self.TThrustOffsetR 	= Vector( 0, min.y, 0 )
	self.force = 950
	// when we set force on this, the number is multiplier instead of force.
	self:SetForceF(0)
	self:SetForceT(0)
	self.GoFoward = 0
	self.GoTurn = 0
	self.Entity:StartMotionController()
	self.LastFired = CurTime()
	self.LoadStage = 3
	self.PlateCount = 8
	
	self.sound_idle:Play()
end