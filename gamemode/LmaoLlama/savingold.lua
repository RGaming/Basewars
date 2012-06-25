--[[
-- LOADING
--]]

function GM:InitPostEntity()
	
	self.BaseClass:InitPostEntity()
	
	--Do stuff you need to do
	
	self:LoadPreviousEntData()
	self:StartSavingEntData()
	
end

local function load_prop_physics( class, mdl, pos, ang, moveable, color, skin, solid, ownerSID )
	local ent = ents.Create( class )
		ent:SetModel( mdl )
		ent:SetPos( pos )
		ent:SetAngles( ang )
		print( color )
		ent:SetColor( color.r, color.g, color.b, color.a )
		ent:SetSkin( skin )
		ent:Spawn()
		ent:Activate()
		ent:SetSolid( solid )
		ent.OwnerID = ownerSID
		local phys = ent:GetPhysicsObject()
		if( IsValid( phys ) ) then
			phys:EnableMotion( moveable )
			--TODO:
			--If needed, drag, gravity, material, collisions
		end
	return true
end

local function load_prop_static( class, mdl, pos, ang, solid, ownerSID )
	local ent = ents.Create( class )
		ent:SetModel( mdl )
		ent:SetPos( pos )
		ent:SetAngles( ang )
		ent:SetSolid( solid )
		ent:Spawn()
		ent:Activate()
		ent.OwnerID = OwnerSID
	return true
end

local function LoadEnt( entData )
	local class = entData[1]
	if( class == "prop_physics" ) then
		return load_prop_physics( unpack(entData) )
	elseif( class == "prop_physics_multiplayer" ) then
		return load_prop_physics( unpack(entData) )
	elseif( class == "prop_static" ) then
		return load_prop_static( unpack(entData) )
	end
	return false
end

function GM:LoadPreviousEntData()
	
	ErrorNoHalt( "-------------------------\n" )
	ErrorNoHalt( "LOADING PREVIOUS ENT DATA\n" )
	ErrorNoHalt( "-------------------------\n" )
	
	if( !file.Exists( "ServerEntData.txt" ) ) then
		ErrorNoHalt( "\tCannot load Previous Entity Data: Does not Exist\n" )
		return
	end
	
	local fileRead = file.Read( "ServerEntData.txt" )
	local entDataTable = glon.decode( fileRead )
	if( !entDataTable ) then
		ErrorNoHalt( "\tENTDATA: Corrupted glon\n" )
		return
	end
	
	for _, entData in pairs( entDataTable ) do
		local success = LoadEnt( entData )
		if( success ) then
			ErrorNoHalt( "Loaded ", entData[1], "\n" )
		else
			ErrorNoHalt( "Error Loading ", entData[1], "\n" )
		end
	end
	
	ErrorNoHalt( "-------------------------\n" )
	ErrorNoHalt( "PREVIOUS ENT DATA LOADED\n" )
	ErrorNoHalt( "SUCCESSFULLY\n" )
	ErrorNoHalt( "-------------------------\n" )
	
end

--[[
-- SAVING
--]]

function GM:StartSavingEntData()
	
	timer.Create( "SaveEntDataTimer", 30, 0, self.SaveEntData, self )
	
end

local function save_prop_physics( ent )
	--class, mdl, pos, ang, moveable, color, skin, solid, ownerSID
	local data = {}
	table.insert( data, ent:GetClass() )
	table.insert( data, ent:GetModel() )
	table.insert( data, ent:GetPos() )
	table.insert( data, ent:GetAngles() )
	local phys = ent:GetPhysicsObject()
	if( IsValid( phys ) ) then
		table.insert( data, phys:IsMoveable() )
	else
		table.insert( data, false )
	end
	table.insert( data, Color( ent:GetColor() ) )
	table.insert( data, ent:GetSkin() )
	table.insert( data, ent:GetSolid() )
	table.insert( data, ent.OwnerID )
	return data
end

local function save_prop_static( ent )
	local data = {}
	table.insert( data, ent:GetClass() )
	table.insert( data, ent:GetModel() )
	table.insert( data, ent:GetPos() )
	table.insert( data, ent:GetAngles() )
	table.insert( data, ent:GetSolid() )
	table.insert( data, ent.OwnerID )
	return data
end

local class_blacklist = {"worldspawn","prop_ragdoll"}
local function SaveEnt( ent )
	
	if( !ent.OwnerID ) then
		return --Only save ents that have owners
	end
	
	local class = ent:GetClass()
	
	if( class == "prop_physics" ) then
		return save_prop_physics( ent )
	elseif( class == "prop_physics_multiplayer" ) then
		return save_prop_physics( ent )
	elseif( class == "prop_static" ) then
		return save_prop_static( ent )
	elseif( table.HasValue( class_blacklist, class ) ) then
		print( "Blacklisted class " .. class)
	else
		print( "unhandled save entity type " .. class )
	end
end

function GM:SaveEntData()
	print( "PROP SAVE WAS SUCCESSFULLY COMPLETE\n" )

	
	local SaveTable = {}
	for _, ent in pairs( ents.GetAll() ) do 
		local data = SaveEnt( ent )
		if( data ) then
			table.insert( SaveTable, data )
		end 
	end
	
	local saveFile = glon.encode( SaveTable )
	if( saveFile ) then
		file.Write( "ServerEntData.txt", saveFile )
	end
	
end