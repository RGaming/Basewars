/* ======================================
	SVehicle_STFUTank
	by HLTV Proxy
   ====================================== */

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 20
	// i am fucking sick of backing up into invisible shit thats not really there.
	SpawnPos = SpawnPos + Vector(0,0,50)
	local ent = ents.Create( "svehicle_stfutank" )
	ent:SetPos( SpawnPos + Vector(0,0,80.94))
	ent:SetAngles(Angle(-90, 0, 0))
	ent:Spawn()
	
	local Pod = ents.Create( "prop_vehicle_prisoner_pod" )
	Pod:SetModel("models/vehicles/prisoner_pod.mdl")
	Pod:SetPos( SpawnPos + Vector(102.15,-1.15,52.51) )
	Pod:SetAngles(Angle(0,0,0))
	Pod:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	Pod.Core = ent
	Pod:Spawn()
	ent.Pod = Pod
	
	local Body = ents.Create( "svehicle_part_nophysics" )
	Body:SetModel("models/props_wasteland/laundry_dryer002.mdl")
	Body:SetPos( SpawnPos + Vector(105,-1,80.94) )
	Body:SetAngles(Angle(-90.00,0.00,180.00))
	Body:SetMaterial("models/props_combine/metal_combinebridge001")
	Body.Core = ent
	Body:Spawn()
	ent.Body = Body
	
	local mounttop = ents.Create( "svehicle_part_nosolid" )
	mounttop:SetModel("models/props_c17/lockers001a.mdl")
	mounttop:SetPos( SpawnPos + Vector(24.65,-0.16,124.75) )
	mounttop:SetAngles(Angle(-90.00,0.00,180.00))
	mounttop:SetMaterial("models/props_c17/metalladder002")
	mounttop:SetParent(ent)
	mounttop.Core = ent
	mounttop:Spawn()
	ent.Gunmounttop = mounttop
	
	local mountback = ents.Create( "svehicle_part_nosolid" )
	mountback:SetModel("models/props_c17/lockers001a.mdl")
	mountback:SetPos( SpawnPos + Vector(-11.35,-0.16,108.75) )
	mountback:SetAngles(Angle(-90.00,-180.00,180.00))
	mountback:SetMaterial("models/props_c17/metalladder002")
	mountback:SetParent(ent)
	mountback.Core = ent
	mountback:Spawn()
	ent.Gunmountback = mountback
	
	local mountfront = ents.Create( "svehicle_part_nosolid" )
	mountfront:SetModel("models/props_c17/lockers001a.mdl")
	mountfront:SetPos( SpawnPos + Vector(48.65,-0.16,108.755) )
	mountfront:SetAngles(Angle(-90.00,00.00,180.00))
	mountfront:SetMaterial("models/props_c17/metalladder002")
	mountfront:SetParent(ent)
	mountfront.Core = ent
	mountfront:Spawn()
	ent.Gunmountfront = mountfront
	
	// cant parent these to the tank, because then they wont be able to be shot.
	
	/*
	2 3
	4 6
	5 7
	1 8
	*/
	local plate1 = ents.Create( "svehicle_part_nophysics" )
	plate1:SetModel("models/props_c17/lockers001a.mdl")
	plate1:SetPos( SpawnPos + Vector(-33.82,59.47,93.08) )
	plate1:SetAngles(Angle(-67.50,-180.00,180.00))
	plate1:SetMaterial("models/props_c17/metalladder002")
	plate1.Core = ent
	plate1:Plate()
	plate1:Spawn()
	ent.Plates[1] = plate1
	
	local plate2 = ents.Create( "svehicle_part_nophysics" )
	plate2:SetModel("models/props_c17/lockers001a.mdl")
	plate2:SetPos( SpawnPos + Vector(146.18,59.47,93.08) )
	plate2:SetAngles(Angle(-67.50,-0.00,180.00))
	plate2:SetMaterial("models/props_c17/metalladder002")
	plate2.Core = ent
	plate2:Plate()
	plate2:Spawn()
	ent.Plates[2] = plate2
	
	local plate3 = ents.Create( "svehicle_part_nophysics" )
	plate3:SetModel("models/props_c17/lockers001a.mdl")
	plate3:SetPos( SpawnPos + Vector(146.18,-60.53,93.08) )
	plate3:SetAngles(Angle(-67.50,0.00,180.00))
	plate3:SetMaterial("models/props_c17/metalladder002")
	plate3.Core = ent
	plate3:Plate()
	plate3:Spawn()
	ent.Plates[3] = plate3
	
	local plate4 = ents.Create( "svehicle_part_nophysics" )
	plate4:SetModel("models/props_c17/lockers001a.mdl")
	plate4:SetPos( SpawnPos + Vector(86.59,59.52,104.72) )
	plate4:SetAngles(Angle(90.00,180.00,180.00))
	plate4:SetMaterial("models/props_c17/metalladder002")
	plate4.Core = ent
	plate4:Plate()
	plate4:Spawn()
	ent.Plates[4] = plate4
	
	local plate5 = ents.Create( "svehicle_part_nophysics" )
	plate5:SetModel("models/props_c17/lockers001a.mdl")
	plate5:SetPos( SpawnPos + Vector(26.59,59.52,104.72) )
	plate5:SetAngles(Angle(90.00,0.00,180.00))
	plate5:SetMaterial("models/props_c17/metalladder002")
	plate5.Core = ent
	plate5:Plate()
	plate5:Spawn()
	ent.Plates[5] = plate5
	
	local plate6 = ents.Create( "svehicle_part_nophysics" )
	plate6:SetModel("models/props_c17/lockers001a.mdl")
	plate6:SetPos( SpawnPos + Vector(86.59,-60.48,104.72) )
	plate6:SetAngles(Angle(90.00,-180.00,180.00))
	plate6:SetMaterial("models/props_c17/metalladder002")
	plate6.Core = ent
	plate6:Plate()
	plate6:Spawn()
	ent.Plates[6] = plate6
	
	local plate7 = ents.Create( "svehicle_part_nophysics" )
	plate7:SetModel("models/props_c17/lockers001a.mdl")
	plate7:SetPos( SpawnPos + Vector(26.59,-60.48,104.72) )
	plate7:SetAngles(Angle(90.00,0.00,180.00))
	plate7:SetMaterial("models/props_c17/metalladder002")
	plate7.Core = ent
	plate7:Plate()
	plate7:Spawn()
	ent.Plates[7] = plate7
	
	local plate8 = ents.Create( "svehicle_part_nophysics" )
	plate8:SetModel("models/props_c17/lockers001a.mdl")
	plate8:SetPos( SpawnPos + Vector(-33.82,-60.53,93.08) )
	plate8:SetAngles(Angle(-67.50,180.00,180.00))
	plate8:SetMaterial("models/props_c17/metalladder002")
	plate8.Core = ent
	plate8:Plate()
	plate8:Spawn()
	ent.Plates[8] = plate8
	
	local Engine = ents.Create( "svehicle_part_nophysics" )
	Engine:SetModel("models/props_wasteland/prison_sink001b.mdl")
	Engine:SetPos( SpawnPos + Vector(-57,-8,78.56) )
	Engine:SetAngles(Angle(90,0,0))
	Engine:SetMaterial("models/props_c17/oil_drum001f")
	Engine.Core = ent
	Engine:Engine()
	Engine:Spawn()
	ent.Engine = Engine
	
	local Weight = ents.Create( "svehicle_part" )
	Weight:SetModel("models/props_wasteland/medbridge_post01.mdl")
	Weight:SetPos( SpawnPos + Vector(12,0,64) )
	Weight:SetAngles(Angle(90,0,0))
	local phys = Weight:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(25000)
	end
	Weight.Core = ent
	Weight:Spawn()
	ent.Weight = Weight
	
	local Wheel1 = ents.Create( "svehicle_part_nosolid" )
	Wheel1:SetModel("models/props_vehicles/apc_tire001.mdl")
	Wheel1:SetPos( SpawnPos + Vector(78.9887,61.2506,53.7188) )
	Wheel1:SetAngles(Angle(0,90,90))
	local phys = Wheel1:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(500)
	end
	Wheel1:SetParent(ent)
	Wheel1.Core = ent
	Wheel1:Spawn()
	Wheel1:TankWheel()
	ent.Wheels[1] = Wheel1
	
	local Wheel2 = ents.Create( "svehicle_part" )
	Wheel2:SetModel("models/props_vehicles/apc_tire001.mdl")
	Wheel2:SetPos( SpawnPos + Vector(-28.7188,-61.2813,53.2813) )
	Wheel2:SetAngles(Angle(0,-90,90))
	local phys = Wheel2:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(500)
	end
	Wheel2.Core = ent
	Wheel2:Spawn()
	Wheel2:TankWheel()
	ent.Wheels[2] = Wheel2
	
	local Wheel3 = ents.Create( "svehicle_part_nosolid" )
	Wheel3:SetModel("models/props_vehicles/apc_tire001.mdl")
	Wheel3:SetPos( SpawnPos + Vector(25.1612,-61.2813,53.2813) )
	Wheel3:SetAngles(Angle(0,-90,90))
	local phys = Wheel3:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(500)
	end
	Wheel3:SetParent(ent)
	Wheel3.Core = ent
	Wheel3:Spawn()
	Wheel3:TankWheel()
	ent.Wheels[3] = Wheel3
	
	local Wheel4 = ents.Create( "svehicle_part_nosolid" )
	Wheel4:SetModel("models/props_vehicles/apc_tire001.mdl")
	Wheel4:SetPos( SpawnPos + Vector(79.6312,-61.2813,53.2813) )
	Wheel4:SetAngles(Angle(0,-90,90))
	local phys = Wheel4:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(500)
	end
	Wheel4:SetParent(ent)
	Wheel4.Core = ent
	Wheel4:Spawn()
	Wheel4:TankWheel()
	ent.Wheels[4] = Wheel4
	
	local Wheel5 = ents.Create( "svehicle_part" )
	Wheel5:SetModel("models/props_vehicles/apc_tire001.mdl")
	Wheel5:SetPos( SpawnPos + Vector(133.231,-61.2813,53.2813) )
	Wheel5:SetAngles(Angle(0,-90,90))
	local phys = Wheel5:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(500)
	end
	Wheel5.Core = ent
	Wheel5:Spawn()
	Wheel5:TankWheel()
	ent.Wheels[5] = Wheel5
	
	local Wheel6 = ents.Create( "svehicle_part" )
	Wheel6:SetModel("models/props_vehicles/apc_tire001.mdl")
	Wheel6:SetPos( SpawnPos + Vector(131.719,61.2506,53.7188) )
	Wheel6:SetAngles(Angle(0,90,90))
	local phys = Wheel6:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(500)
	end
	Wheel6.Core = ent
	Wheel6:Spawn()
	Wheel6:TankWheel()
	ent.Wheels[6] = Wheel6
	
	local Wheel7 = ents.Create( "svehicle_part" )
	Wheel7:SetModel("models/props_vehicles/apc_tire001.mdl")
	Wheel7:SetPos( SpawnPos + Vector(-28.8813,61.2506,53.7188) )
	Wheel7:SetAngles(Angle(0,90,90))
	local phys = Wheel7:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(500)
	end
	Wheel7.Core = ent
	Wheel7:Spawn()
	Wheel7:TankWheel()
	ent.Wheels[7] = Wheel7
	
	local Wheel8 = ents.Create( "svehicle_part_nosolid" )
	Wheel8:SetModel("models/props_vehicles/apc_tire001.mdl")
	Wheel8:SetPos( SpawnPos + Vector(24.4787,61.2506,53.71888) )
	Wheel8:SetAngles(Angle(0,90,90))
	local phys = Wheel8:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(500)
	end
	Wheel8:SetParent(ent)
	Wheel8.Core = ent
	Wheel8:Spawn()
	Wheel8:TankWheel()
	ent.Wheels[8] = Wheel8
	
	// ok now its time to assemble the gun!
	
	local GunBase = ents.Create( "svehicle_part_nophysics" )
	GunBase:SetModel("models/props_junk/sawblade001a.mdl")
	GunBase:SetPos( SpawnPos + Vector(24.65,0,142) )
	GunBase:SetAngles(Angle(0,0,0))
	GunBase:SetMaterial("models/props_c17/metalladder002")
	GunBase:SetParent(ent)
	GunBase.Core = ent
	GunBase:Spawn()
	ent.GunBase = GunBase
	
	local GunBaseOld = ents.Create( "svehicle_part_nosolid" )
	GunBaseOld:SetModel("models/props_c17/Lockers001a.mdl")
	GunBaseOld:SetPos( SpawnPos + Vector(24.65,0,142) )
	GunBaseOld:SetAngles(Angle(-90,180,0))
	GunBaseOld:SetMaterial("models/props_c17/metalladder002")
	GunBaseOld:SetParent(GunBase)
	GunBaseOld.Core = ent
	GunBaseOld:Spawn()
	ent.GunBaseOld = GunBaseOld
	
	local GunPivot1 = ents.Create( "svehicle_part_nosolid" )
	GunPivot1:SetModel("models/props_c17/pulleywheels_large01.mdl")
	GunPivot1:SetPos( SpawnPos + Vector(22,-22.2813,161.2322) )
	GunPivot1:SetAngles(Angle(0,90,0))
	GunPivot1:SetParent(GunBase)
	GunPivot1.Core = ent
	GunPivot1:Spawn()
	ent.GunPivot1 = GunPivot1
	
	local GunPivot2 = ents.Create( "svehicle_part_nosolid" )
	GunPivot2:SetModel("models/props_c17/pulleywheels_large01.mdl")
	GunPivot2:SetPos( SpawnPos + Vector(22,22,161) )
	GunPivot2:SetAngles(Angle(0,-90,0))
	GunPivot2:SetParent(GunBase)
	GunPivot2.Core = ent
	GunPivot2:Spawn()
	ent.GunPivot2 = GunPivot2
	
	local GunCore = ents.Create( "svehicle_part_nophysics" )
	GunCore:SetModel("models/combine_helicopter/helicopter_bomb01.mdl")
	GunCore:SetPos( SpawnPos + Vector(22,0,161) )
	GunCore:SetAngles(Angle(0,0,0))
	GunCore:SetMaterial("models/props_combine/combinethumper002")
	GunCore:SetParent(ent)
	GunCore.Core = ent
	GunCore:Spawn()
	ent.GunCore = GunCore
	
	local GunCoreOld = ents.Create( "svehicle_part_nosolid" )
	GunCoreOld:SetModel("models/props_lab/kennel.mdl")
	GunCoreOld:SetPos( SpawnPos + Vector(13.5538,-0.63,137.16) )
	GunCoreOld:SetAngles(Angle(0,180,0))
	GunCoreOld:SetMaterial("models/props_combine/combinethumper002")
	GunCoreOld:SetParent(GunCore)
	GunCoreOld.Core = ent
	GunCoreOld:Spawn()
	ent.GunCoreOld = GunCoreOld
	
	local GunCenter = ents.Create( "svehicle_part_nosolid" )
	GunCenter:SetModel("models/props_c17/oildrum001.mdl")
	GunCenter:SetPos( SpawnPos + Vector(22,21.7188,162.232) )
	GunCenter:SetAngles(Angle(0,0,90))
	GunCenter:SetMaterial("models/props_c17/metalladder002")
	GunCenter:SetParent(GunCore)
	GunCenter.Core = ent
	GunCenter:Spawn()
	ent.GunParts[1] = GunCenter
	
	local GunBacking = ents.Create( "svehicle_part_nophysics" )
	GunBacking:SetModel("models/props_c17/concrete_barrier001a.mdl")
	GunBacking:SetPos( SpawnPos + Vector(-17.5462,0.09,134.34) )
	GunBacking:SetAngles(Angle(10,0,0))
	GunBacking:SetMaterial("models/props_combine/metal_combinebridge001")
	GunBacking:SetParent(GunCore)
	GunBacking.Core = ent
	GunBacking:Spawn()
	ent.GunParts[2] = GunBacking
	
	local GunBarrel1 = ents.Create( "svehicle_part_nosolid" )
	GunBarrel1:SetModel("models/props_c17/FurnitureBoiler001a.mdl")
	GunBarrel1:SetPos( SpawnPos + Vector(31.7138,6,156.59) )
	GunBarrel1:SetAngles(Angle(-90,0,0))
	GunBarrel1:SetMaterial("models/props_c17/metalladder001")
	GunBarrel1:SetParent(GunCore)
	GunBarrel1.Core = ent
	GunBarrel1:Spawn()
	ent.GunParts[3] = GunBarrel1
	
	local GunBarrel2 = ents.Create( "svehicle_part_nosolid" )
	GunBarrel2:SetModel("models/props_c17/FurnitureBoiler001a.mdl")
	GunBarrel2:SetPos( SpawnPos + Vector(121.214,-6.5,156.59) )
	GunBarrel2:SetAngles(Angle(-90,180,0))
	GunBarrel2:SetMaterial("models/props_c17/metalladder001")
	GunBarrel2:SetParent(GunCore)
	GunBarrel2.Core = ent
	GunBarrel2:Spawn()
	ent.GunParts[4] = GunBarrel2
	
	local GunTip1 = ents.Create( "svehicle_part_nosolid" )
	GunTip1:SetModel("models/props_vehicles/tire001c_car.mdl")
	GunTip1:SetPos( SpawnPos + Vector(162.784,-0.56,157.71) )
	GunTip1:SetAngles(Angle(0,0,0))
	GunTip1:SetMaterial("models/props_c17/metalladder001")
	GunTip1:SetParent(GunCore)
	GunTip1.Core = ent
	GunTip1:Spawn()
	ent.GunParts[5] = GunTip1
	
	local GunTip2 = ents.Create( "svehicle_part_nosolid" )
	GunTip2:SetModel("models/props_vehicles/tire001c_car.mdl")
	GunTip2:SetPos( SpawnPos + Vector(169.784,-0.56,157.71) )
	GunTip2:SetAngles(Angle(0,0,0))
	GunTip2:SetMaterial("models/props_c17/metalladder001")
	GunTip2:SetParent(GunCore)
	GunTip2.Core = ent
	GunTip2:Spawn()
	ent.GunParts[6] = GunTip2
	
	local GunTip3 = ents.Create( "svehicle_part_nosolid" )
	GunTip3:SetModel("models/props_vehicles/tire001c_car.mdl")
	GunTip3:SetPos( SpawnPos + Vector(176.784,-0.56,157.71) )
	GunTip3:SetAngles(Angle(0,0,0))
	GunTip3:SetMaterial("models/props_c17/metalladder001")
	GunTip3:SetParent(GunCore)
	GunTip3.Core = ent
	GunTip3:Spawn()
	ent.GunParts[7] = GunTip3
	
	local GunTip4 = ents.Create( "svehicle_part_nosolid" )
	GunTip4:SetModel("models/props_vehicles/tire001c_car.mdl")
	GunTip4:SetPos( SpawnPos + Vector(183.784,-0.56,157.71) )
	GunTip4:SetAngles(Angle(0,0,0))
	GunTip4:SetMaterial("models/props_c17/metalladder001")
	GunTip4:SetParent(GunCore)
	GunTip4.Core = ent
	GunTip4:Spawn()
	ent.GunParts[8] = GunTip4
	
	local GunTip5 = ents.Create( "svehicle_part_nosolid" )
	GunTip5:SetModel("models/props_vehicles/tire001c_car.mdl")
	GunTip5:SetPos( SpawnPos + Vector(190.784,-0.56,157.71) )
	GunTip5:SetAngles(Angle(0,0,0))
	GunTip5:SetMaterial("models/props_c17/metalladder001")
	GunTip5:SetParent(GunCore)
	GunTip5.Core = ent
	GunTip5:Spawn()
	ent.GunParts[9] = GunTip5
	
	local GunCamera = ents.Create( "svehicle_part_nosolid" )
	GunCamera:SetModel("models/props_combine/combine_emitter01.mdl")
	GunCamera:SetPos( SpawnPos + Vector(24,0,168) )
	GunCamera:SetAngles(Angle(0,0,0))
	GunCamera:SetParent(GunCore)
	GunCamera.Core = ent
	GunCamera:Spawn()
	ent.GunParts[9] = GunTip5
	
	// effects.
	
	local fire1 = ents.Create( "env_fire" )
	fire1:SetKeyValue("spawnflags", "48")
	fire1:SetKeyValue("health", "60")
	fire1:SetKeyValue("firesize", "78")
	fire1:SetKeyValue("fireattack", "3")
	fire1:SetKeyValue("ignitionpoint", "999999")
	fire1:SetKeyValue("damagescale", "13")
	fire1:SetPos(SpawnPos + Vector(-48,16,104))
	fire1:SetParent(ent)
	fire1:Spawn()
	ent.Fire3 = fire1
	
	local fire2 = ents.Create( "env_fire" )
	fire2:SetKeyValue("spawnflags", "48")
	fire2:SetKeyValue("health", "60")
	fire2:SetKeyValue("firesize", "78")
	fire2:SetKeyValue("fireattack", "3")
	fire2:SetKeyValue("ignitionpoint", "999999")
	fire2:SetKeyValue("damagescale", "13")
	fire2:SetPos(SpawnPos + Vector(-64,0,80))
	fire2:SetParent(ent)
	fire2:Spawn()
	ent.Fire4 = fire2
	
	local fire3 = ents.Create( "env_fire" )
	fire3:SetKeyValue("spawnflags", "48")
	fire3:SetKeyValue("health", "60")
	fire3:SetKeyValue("firesize", "78")
	fire3:SetKeyValue("fireattack", "3")
	fire3:SetKeyValue("ignitionpoint", "999999")
	fire3:SetKeyValue("damagescale", "13")
	fire3:SetPos(SpawnPos + Vector(-48,-24,88))
	fire3:SetParent(ent)
	fire3:Spawn()
	ent.Fire5 = fire3
	
	local fire4 = ents.Create( "env_fire" )
	fire4:SetKeyValue("spawnflags", "48")
	fire4:SetKeyValue("health", "50")
	fire4:SetKeyValue("firesize", "50")
	fire4:SetKeyValue("fireattack", "4")
	fire4:SetKeyValue("ignitionpoint", "999999")
	fire4:SetKeyValue("damagescale", "1")
	fire4:SetPos(SpawnPos + Vector(48,-32,128))
	fire4:SetParent(ent)
	fire4:Spawn()
	ent.Fire1 = fire4
	
	local fire5 = ents.Create( "env_fire" )
	fire5:SetKeyValue("spawnflags", "48")
	fire5:SetKeyValue("health", "50")
	fire5:SetKeyValue("firesize", "50")
	fire5:SetKeyValue("fireattack", "4")
	fire5:SetKeyValue("ignitionpoint", "999999")
	fire5:SetKeyValue("damagescale", "1")
	fire5:SetPos(SpawnPos + Vector(0,8,184))
	fire5:SetParent(ent)
	fire5:Spawn()
	ent.Fire2 = fire5
	
	local smoke = ents.Create( "env_smokestack" )
	smoke:SetKeyValue("InitialState", "0")
	smoke:SetKeyValue("BaseSpread", "20")
	smoke:SetKeyValue("SpreadSpeed", "20")
	smoke:SetKeyValue("Speed", "30")
	smoke:SetKeyValue("StartSize", "20")
	smoke:SetKeyValue("EndSize", "50")
	smoke:SetKeyValue("Rate", "19")
	smoke:SetKeyValue("SmokeMaterial", "particle/SmokeStack.vmt")
	smoke:SetKeyValue("rendercolor", "82 73 65")
	smoke:SetKeyValue("renderamt", "230")
	smoke:SetPos(SpawnPos + Vector(-48, 0, 80))
	smoke:SetParent(ent)
	smoke:Spawn()
	ent.Smoke = smoke
	
	// over a million nocollides.
	
	constraint.Weld( ent, Weight, 0, 0, 0, 0 )
	constraint.Weld( ent, Pod, 0, 0, 0, 0 )
	constraint.Weld( Pod, Weight, 0, 0, 0, 0 )
	
	// stick the wheels on, along the correct fucking axis. axis has no control of its axis. kinda ironic actually.
	//constraint.AdvBallsocket( ent, Wheel1, 0, 0, ent:WorldToLocal(SpawnPos + Vector(78.9887,61.2506,53.7188)), ent:WorldToLocal(SpawnPos + Vector(78.9887,61.2506,53.7188)), 0, 0, 0, -180, 0, 0, 180, 0, 500, 0, 0, 0, 1)
	constraint.AdvBallsocket( ent, Wheel2, 0, 0, ent:WorldToLocal(SpawnPos + Vector(-28.7188,-61.2813,53.2813)), ent:WorldToLocal(SpawnPos + Vector(-28.7188,-61.2813,53.2813)), 0, 0, 0, -180, 0, 0, 180, 0, 500, 0, 0, 0, 1)
	//constraint.AdvBallsocket( ent, Wheel3, 0, 0, ent:WorldToLocal(SpawnPos + Vector(25.1612,-61.2813,53.2813)), ent:WorldToLocal(SpawnPos + Vector(25.1612,-61.2813,53.2813)), 0, 0, 0, -180, 0, 0, 180, 0, 500, 0, 0, 0, 1)
	//constraint.AdvBallsocket( ent, Wheel4, 0, 0, ent:WorldToLocal(SpawnPos + Vector(79.6312,-61.2813,53.2813)), ent:WorldToLocal(SpawnPos + Vector(79.6312,-61.2813,53.2813)), 0, 0, 0, -180, 0, 0, 180, 0, 500, 0, 0, 0, 1)
	constraint.AdvBallsocket( ent, Wheel5, 0, 0, ent:WorldToLocal(SpawnPos + Vector(133.231,-61.2813,53.2813)), ent:WorldToLocal(SpawnPos + Vector(133.231,-61.2813,53.2813)), 0, 0, 0, -180, 0, 0, 180, 0, 500, 0, 0, 0, 1)
	constraint.AdvBallsocket( ent, Wheel6, 0, 0, ent:WorldToLocal(SpawnPos + Vector(131.719,61.2506,53.7188)), ent:WorldToLocal(SpawnPos + Vector(131.719,61.2506,53.7188)), 0, 0, 0, -180, 0, 0, 180, 0, 500, 0, 0, 0, 1)
	constraint.AdvBallsocket( ent, Wheel7, 0, 0, ent:WorldToLocal(SpawnPos + Vector(-28.8813,61.2506,53.7188)), ent:WorldToLocal(SpawnPos + Vector(-28.8813,61.2506,53.7188)), 0, 0, 0, -180, 0, 0, 180, 0, 500, 0, 0, 0, 1)
	//constraint.AdvBallsocket( ent, Wheel8, 0, 0, ent:WorldToLocal(SpawnPos + Vector(24.4787,61.2506,53.71888)), ent:WorldToLocal(SpawnPos + Vector(24.4787,61.2506,53.71888)), 0, 0, 0, -180, 0, 0, 180, 0, 500, 0, 0, 0, 1)
	// and make sure the wheels dont have a physics fight with each other.
	for i=1, 8, 1 do 
		constraint.NoCollide(ent.Plates[i], Pod, 0, 0)
		constraint.NoCollide(ent.Plates[i], Weight, 0, 0)
		constraint.NoCollide(ent.Plates[i], ent, 0, 0)
		constraint.NoCollide(ent.Plates[i], Body, 0, 0)
		for q=1, 8, 1 do
			constraint.NoCollide(ent.Plates[i], ent.Wheels[q], 0, 0)
			// sadly i realize this will be 48 constraints. at least its not gonna do non-sensical shit like nocolliding it to self.
			// i look back and consider 48 alot. yes, it is. but now i have to make a shitty hacky workaround, and it gets much much worse. each plate, has to have a fuckton of nocollides to the wheels. yes, very fail.
			// so far we are at over 9000 nocollide constraints. damn i hope people dont get snapshot overflow from this
			if (i!=q) then
				constraint.NoCollide(ent.Wheels[i], ent.Wheels[q], 0, 0)
			end
		end
	end
	
	constraint.NoCollide( ent, Engine, 0, 0)
	constraint.NoCollide( ent, Weight, 0, 0)
	constraint.NoCollide( ent, Pod, 0, 0)
	constraint.NoCollide( Pod, Weight, 0, 0)
	constraint.NoCollide( Body, ent, 0, 0)
	constraint.NoCollide( Body, Pod, 0, 0)
	constraint.NoCollide( Body, Weight, 0, 0)
	ent:Activate()
	Pod:Activate()
	
	ent:SetNWEntity("GunCore", GunCore)
	ent:SetNWEntity("Plate1", plate1)
	ent:SetNWEntity("Plate2", plate2)
	ent:SetNWEntity("Plate3", plate3)
	ent:SetNWEntity("Plate4", plate4)
	ent:SetNWEntity("Plate5", plate5)
	ent:SetNWEntity("Plate6", plate6)
	ent:SetNWEntity("Plate7", plate7)
	ent:SetNWEntity("Plate8", plate8)
	ent:SetNWEntity("Engine", Engine)
	
	return ent
	
end
/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/


/*---------------------------------------------------------
   Name: OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage(dmg)
	self.Entity:SetNWInt("damage",self.Entity:GetNWInt("damage") - dmg:GetDamage())
	if(self.Entity:GetNWInt("damage") <= 0) then
		self.Entity:Explode()
		self.Entity:Remove()
		
	end
end

function ENT:Explode()
	local effectdata = EffectData() 
	effectdata:SetStart( self.Entity:GetPos() )
	effectdata:SetOrigin( self.Entity:GetPos() ) 
	effectdata:SetScale( 1 ) 
	util.Effect( "Explosion", effectdata ) 
end

function ENT:Think()
	if (ValidEntity(self.Pod) && ValidEntity(self.Pod:GetDriver()) && self.Pod:GetDriver():IsPlayer()) then
		// so the tank can actually move around after not being driven for a bit
		local phys = self.Entity:GetPhysicsObject()
		phys:Wake()
		local ply = self.Pod:GetDriver()
		if (self.Entity:GetNWEntity("Driver")!=ply) then
			self.Entity:SetNWEntity("Driver", ply)
		end
		self.Driver = ply
		if (self.PlateCount>2) then
			if ply:KeyDown(IN_FORWARD) then
				self.sound_move:Play()
				self.GoForward = 1
				self:SetForceF(1)
			elseif ply:KeyDown(IN_BACK) then
				self.sound_move:Play()
				self.GoForward = -1
				self:SetForceF(-1)
			else
				self.sound_move:Stop()
				self.GoForward = 0
				self:SetForceF(0)
			end
			if ply:KeyDown(IN_MOVELEFT) then
				self.GoTurn = 1
				self:SetForceT(1)
			elseif ply:KeyDown(IN_MOVERIGHT) then
				self.GoTurn = -1
				self:SetForceT(-1)
			else
				self.GoTurn = 0
				self:SetForceT(0)
			end
		else
			self.GoForward = 0
			self:SetForceF(0)
			self.GoTurn = 0
			self:SetForceT(0)
		end
		if (ValidEntity(self.GunCore)) then
			local tankangles = self.Entity:GetAngles()
			tankangles:RotateAroundAxis(tankangles:Right(), -90)
			tankangles:RotateAroundAxis(tankangles:Forward(), -tankangles.r)
			
			local aimangles = ply:EyeAngles()
			self.GunAngles = aimangles
			local baseangles = Angle(aimangles.p, aimangles.y, aimangles.r)
			local gunangles = Angle(aimangles.p, aimangles.y, aimangles.r)
			
			local tempaimangles = aimangles
			tempaimangles:RotateAroundAxis(tempaimangles:Forward(), -tempaimangles.r)
			baseangles:RotateAroundAxis(aimangles:Right(), tempaimangles.p-(tankangles.p))
			
			self.GunBase:SetAngles(baseangles)
			self.GunCore:SetAngles(gunangles)
			if ply:KeyDown(IN_ATTACK) && self.LastFired+5<CurTime() then
				self.Entity:FireShell()
				self.LastFired = CurTime()
				self.LoadStage = 0
			end
		end
	else
		if (self.Entity:GetNWEntity("Driver")!=self.Entity) then
			self.Entity:SetNWEntity("Driver", self.Entity)
		end
		self.GoForward = 0
		self:SetForceF(0)
		self.GoTurn = 0
		self:SetForceT(0)
	end
	if (ValidEntity(self.GunCore)) then
		if self.LastFired+1<CurTime() && self.LoadStage==0 then
			self.LoadStage=1
			self.GunCore:EmitSound(Sound("Town.d1_town_04_metal_solid_strain4"))
		elseif self.LastFired+2.5<CurTime() && self.LoadStage==1  then
			self.LoadStage=2
			self.GunCore:EmitSound(Sound("coast.crane_metal_groan"))
		elseif self.LastFired+4<CurTime() && self.LoadStage==2  then
			self.LoadStage=3
			self.GunCore:EmitSound(Sound("Doors.FullClose2"))
		end
	end
end

function ENT:Use(ply, caller)
	if ValidEntity(self.Pod) then
		ply:EnterVehicle(self.Pod)
	end
end

function ENT:GetPod()
	if (ValidEntity(self.Pod)) then
		return self.Pod
	else
		return false
	end
end

function ENT:OnRemove()
	timer.Destroy(tostring(self.Entity).."RemoveSelf")
	timer.Destroy(tostring(self.Entity).."Explodeeffect")
	timer.Destroy(tostring(self.Entity).."Pusheffect")
	self.sound_idle:Stop()
	self.sound_move:Stop()
	self.sound_open:Stop()
	self.sound_load:Stop()
	self.sound_lock:Stop()
	
	if ValidEntity(self.Engine) then
		self.Engine:Remove()
	end
	if ValidEntity(self.Body) then
		self.Body:Remove()
	end
	if ValidEntity(self.Weight) then
		self.Weight:Remove()
	end
	if ValidEntity(self.Pod) then
		self.Pod:Remove()
	end
	for i=1, 8, 1 do
		if ValidEntity(self.Plates[i]) then
			self.Plates[i]:Remove()
		end
		if ValidEntity(self.Wheels[i]) then
			self.Wheels[i]:Remove()
		end
	end
end

function ENT:SetForceF(mul)
	local phys = self.Entity:GetPhysicsObject()
	self.ForceAngle		= self.ThrustOffset:GetNormalized() * -1
	local ThrusterWorldPos = phys:LocalToWorld( self.ThrustOffset )
	local ThrusterWorldForce = phys:LocalToWorldVector( self.ThrustOffset * -1 )
	ThrusterWorldForce = ThrusterWorldForce * self.force * mul * 50
	self.ForceLinear, self.ForceAngle = phys:CalculateVelocityOffset( ThrusterWorldForce, ThrusterWorldPos );
	self.ForceLinear = phys:WorldToLocalVector( self.ForceLinear )
end

function ENT:SetForceT(mul)
	local phys = self.Entity:GetPhysicsObject()
	self.TForceAngle = self.TThrustOffset:GetNormalized() * -1
	local ThrusterWorldPos = phys:LocalToWorld( self.TThrustOffset )
	local ThrusterWorldForce = phys:LocalToWorldVector( self.TThrustOffset * -1 )
	ThrusterWorldForce = ThrusterWorldForce * self.force * (mul*1.6) * 50
	self.TForceLinear, self.TForceAngle = phys:CalculateVelocityOffset( ThrusterWorldForce, ThrusterWorldPos );
	self.TForceLinear = phys:WorldToLocalVector( self.TForceLinear )
end

function ENT:PhysicsSimulate( phys, deltatime )

	if (self.GoForward==0 && self.GoTurn==0) then return SIM_NOTHING end
	
	local ForceAngle, ForceLinear = self.ForceAngle+self.TForceAngle, self.ForceLinear+self.TForceLinear

	return ForceAngle, ForceLinear, SIM_LOCAL_ACCELERATION
	
end

function ENT:FireShell()
	local gunoffset = self.GunCore:GetForward()*200.784+self.GunCore:GetRight()*-0.56+self.GunCore:GetUp()*70.77
	local object = ents.Create("shot_tankshell")
	local firingangle = self.GunCore:GetAngles()
	firingangle:RotateAroundAxis(firingangle:Right(), -90)
	if ValidEntity(object) then	
		
		object:SetOwner(self.Driver)
		object:SetPos(gunoffset+self.Entity:GetPos())
		object:SetAngles(firingangle)
		object:Spawn()
		object:GetPhysicsObject():SetVelocity(object:GetAngles():Up()*10000)
	end
	local effectdata = EffectData()
		effectdata:SetStart(self.Entity:GetPos()+gunoffset)
		effectdata:SetOrigin(self.Entity:GetPos()+gunoffset)
		effectdata:SetScale(1.5)
	util.Effect("Explosion", effectdata)
	self.Weight:GetPhysicsObject():SetVelocity(self.GunCore:GetAngles():Forward()*-400)
end

function ENT:PlateDied(ent, attacker)
	self.PlateCount = self.PlateCount-1
	if (self.PlateCount==6) then
		self.Entity:Explode()
	elseif (self.PlateCount==5) then
		self.Fire1:Fire("StartFire")
	elseif (self.PlateCount==4) then
		self.Entity:Explode()
	elseif (self.PlateCount==3) then
		self.Fire2:Fire("StartFire")
	elseif (self.PlateCount==2) then
		self.sound_move:Stop()
		self.Entity:Explode()
	elseif (self.PlateCount==1) then
		self.Entity:Explode()
		self.Fire2:Remove()
		self.Fire3:Fire("StartFire")
		self.Fire4:Fire("StartFire")
		self.Fire5:Fire("StartFire")
		self.Smoke:Fire("TurnOn")
		self.Smoke:Fire("TurnOff","",10)
		self.GunCore:Remove()
		self.GunBase:Remove()
	elseif (self.PlateCount==0) then
		self.Entity:BlowRightTheFuckUp(attacker)
	end
end

function ENT:EngineDied(attacker)
	self.PlateCount = 0
	self.Entity:BlowRightTheFuckUp(attacker)
end

function ENT:BlowRightTheFuckUp(destroyer)
	self.sound_idle:Stop()
	if ValidEntity(self.Pod) then
		local driver = self.Pod:GetDriver()
		if ValidEntity(driver) then
			// kill their ass.
			driver:TakeDamage(1000000, destroyer, self.Entity)
		end
	end
	self.Entity:Explode()
	timer.Create(tostring(self.Entity).."Explodeeffect", 0.15, math.random(3,5), self.Explode, self) 
	for i=1,8,1 do
		if (ValidEntity(self.Wheels[i])) then
			constraint.RemoveConstraints(self.Wheels[i], "AdvBallsocket")
		end
	end
	timer.Create(tostring(self.Entity).."Pusheffect", 0.1, 1, self.PushWheels, self) 
	if (ValidEntity(self.Pod)) then
		self.Pod:Fire("kill","",0.1)
	end
	if (ValidEntity(self.GunBase)) then
		self.GunBase:Remove()
	end
	if (ValidEntity(self.GunCore)) then
		self.GunCore:Remove()
	end
	self.Fire1:Fire("StartFire")
	self.Fire3:Fire("StartFire")
	self.Fire4:Fire("StartFire")
	self.Fire5:Fire("StartFire")
	self.Smoke:Fire("TurnOn")
	self.Smoke:Fire("TurnOff","",60)
	timer.Create(tostring(self.Entity).."RemoveSelf", 120, 1, self.Remove, self)
end

function ENT:PushWheels()
	local entpos = self.Entity:GetPos()
	for i=1,8,1 do
		if (ValidEntity(self.Wheels[i])) then
			local forceang = self.Wheels[i]:GetPos()-entpos
			self.Wheels[i]:GetPhysicsObject():SetVelocity(forceang:Angle():Forward()*200)
		end
	end
end

function ENT:Explode()
	local blastpos = self.Entity:GetPos()+Vector(math.random(-80,80),math.random(-80,80),math.random(-20,70))
	local effectdata = EffectData()
		effectdata:SetStart(blastpos)
		effectdata:SetOrigin(blastpos)
		effectdata:SetScale(1.5)
	util.Effect("HelicopterMegaBomb", effectdata)
	local effectdata = EffectData()
		effectdata:SetStart(blastpos)
		effectdata:SetOrigin(blastpos)
		effectdata:SetScale(1.5)
	util.Effect("Explosion", effectdata)
end
// cheap hacky work-around for the fact that in gmod10, parented objects are nonsolid to bullets.
// i bet this will be somewhat laggy, but its still better than the other option of making them actual physics objects, and mass welding it.
function ENT:PhysicsUpdate(phys)
	// ALL of the entities moved this way will be acts of laggotry
	// and their offset from the original numbers is 0,0,-80.94, to keep it based around its body.
	local tankangles = self.Entity:GetAngles()
	tankangles:RotateAroundAxis(tankangles:Right(),-90)
	
	// every step of the way, we have to put tankangles inside of Angle() because it wants to rotate the original for no damn reason.
	
	if (ValidEntity(self.Plates[1])) then
		local plate1offset = tankangles:Forward()*-33.82+tankangles:Right()*-59.47+tankangles:Up()*12.14
		local plate1angles = Angle(tankangles.p, tankangles.y, tankangles.r)
		plate1angles:RotateAroundAxis(plate1angles:Right(), -67.5)
		plate1angles:RotateAroundAxis(plate1angles:Up(), 180)
		plate1angles:RotateAroundAxis(plate1angles:Forward(), -180)
		self.Plates[1]:SetPos(plate1offset+self.Entity:GetPos())
		self.Plates[1]:SetAngles(plate1angles)
	end
	
	if (ValidEntity(self.Plates[2])) then
		local plate2offset = tankangles:Forward()*146.18+tankangles:Right()*-59.47+tankangles:Up()*12.14
		local plate2angles = Angle(tankangles.p, tankangles.y, tankangles.r)
		plate2angles:RotateAroundAxis(plate2angles:Right(), 67.5)
		plate2angles:RotateAroundAxis(plate2angles:Forward(), 180)
		self.Plates[2]:SetPos(plate2offset+self.Entity:GetPos())
		self.Plates[2]:SetAngles(plate2angles)
	end
	
	if (ValidEntity(self.Plates[3])) then
		local plate3offset = tankangles:Forward()*146.18+tankangles:Right()*60.53+tankangles:Up()*12.14
		local plate3angles = Angle(tankangles.p, tankangles.y, tankangles.r)
		plate3angles:RotateAroundAxis(plate3angles:Right(), 67.5)
		plate3angles:RotateAroundAxis(plate3angles:Forward(), -180)
		self.Plates[3]:SetPos(plate3offset+self.Entity:GetPos())
		self.Plates[3]:SetAngles(plate3angles)
	end
	
	if (ValidEntity(self.Plates[4])) then
		local plate4offset = tankangles:Forward()*86.59+tankangles:Right()*-59.52+tankangles:Up()*23.78
		local plate4angles = Angle(tankangles.p, tankangles.y, tankangles.r)
		plate4angles:RotateAroundAxis(plate4angles:Right(), 90)
		plate4angles:RotateAroundAxis(plate4angles:Up(), 180)
		plate4angles:RotateAroundAxis(plate4angles:Forward(), 180)
		self.Plates[4]:SetPos(plate4offset+self.Entity:GetPos())
		self.Plates[4]:SetAngles(plate4angles)
	end
	
	if (ValidEntity(self.Plates[5])) then
		local plate5offset = tankangles:Forward()*26.59+tankangles:Right()*-59.52+tankangles:Up()*23.78
		local plate5angles = Angle(tankangles.p, tankangles.y, tankangles.r)
		plate5angles:RotateAroundAxis(plate5angles:Right(), 90)
		plate5angles:RotateAroundAxis(plate5angles:Up(), 180)
		self.Plates[5]:SetPos(plate5offset+self.Entity:GetPos())
		self.Plates[5]:SetAngles(plate5angles)
	end
	
	if (ValidEntity(self.Plates[6])) then
		local plate6offset = tankangles:Forward()*86.59+tankangles:Right()*60.48+tankangles:Up()*23.78
		local plate6angles = Angle(tankangles.p, tankangles.y, tankangles.r)
		plate6angles:RotateAroundAxis(plate6angles:Right(), 90)
		plate6angles:RotateAroundAxis(plate6angles:Up(), 180)
		plate6angles:RotateAroundAxis(plate6angles:Forward(), -180)
		self.Plates[6]:SetPos(plate6offset+self.Entity:GetPos())
		self.Plates[6]:SetAngles(plate6angles)
	end
	
	if (ValidEntity(self.Plates[7])) then
		local plate7offset = tankangles:Forward()*26.59+tankangles:Right()*60.48+tankangles:Up()*23.78
		local plate7angles = Angle(tankangles.p, tankangles.y, tankangles.r)
		plate7angles:RotateAroundAxis(plate7angles:Right(), 90)
		//plate7angles:RotateAroundAxis(plate7angles:Forward(), 180)
		plate7angles:RotateAroundAxis(plate7angles:Up(), 180)
		self.Plates[7]:SetPos(plate7offset+self.Entity:GetPos())
		self.Plates[7]:SetAngles(plate7angles)
	end
	
	if (ValidEntity(self.Plates[8])) then
		local plate8offset = tankangles:Forward()*-33.82+tankangles:Right()*60.53+tankangles:Up()*12.14
		local plate8angles = Angle(tankangles.p, tankangles.y, tankangles.r)
		plate8angles:RotateAroundAxis(plate8angles:Right(), -67.5)
		plate8angles:RotateAroundAxis(plate8angles:Up(), 180)
		plate8angles:RotateAroundAxis(plate8angles:Forward(), 180)
		self.Plates[8]:SetPos(plate8offset+self.Entity:GetPos())
		self.Plates[8]:SetAngles(plate8angles)
	end
	
	// front body of the tank.
	//Body:SetPos( SpawnPos + Vector(105,-1,80.94) )
	//Body:SetAngles(Angle(-90.00,0.00,180.00))
	if (ValidEntity(self.Body)) then
		local bodyoffset = tankangles:Forward()*105+tankangles:Right()*1
		local bodyangles = Angle(tankangles.p, tankangles.y, tankangles.r)
		bodyangles:RotateAroundAxis(bodyangles:Right(), 90)
		bodyangles:RotateAroundAxis(bodyangles:Forward(), 180)
		self.Body:SetPos(bodyoffset+self.Entity:GetPos())
		self.Body:SetAngles(bodyangles)
	end
	
	// the weak point of the tank, the engine. blowing this up kills it much faster than killing each of the armor plates.
	
	if (ValidEntity(self.Engine)) then
		local engineoffset = tankangles:Forward()*-57+tankangles:Right()*8+tankangles:Up()*-2.38
		local engineangles = Angle(tankangles.p, tankangles.y, tankangles.r)
		engineangles:RotateAroundAxis(engineangles:Right(), -90)
		self.Engine:SetPos(engineoffset+self.Entity:GetPos())
		self.Engine:SetAngles(engineangles)
	end
end
