--ULX fuckup fix
local meta = FindMetaTable("Player")
function meta:CheckGroup( group_check )
	if not ULib.ucl then return false end
	if not ULib.ucl.groups[ group_check ] then return false end
	local group = self:GetUserGroup()
	if not ULib.ucl.groups[ group ] then return false end
	while group do
		if group == group_check then return true end
		group = ULib.ucl.groupInheritsFrom( group )
	end
	
	return false
end

FPP = FPP or {}

require("datastream")

sql.Begin()
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_BLOCKED('id' INTEGER NOT NULL, 'key' TEXT NOT NULL, 'value' TEXT NOT NULL, PRIMARY KEY('id'));")
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_PHYSGUN('key' TEXT NOT NULL, 'value' INTEGER NOT NULL, PRIMARY KEY('key'));")
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_GRAVGUN('key' TEXT NOT NULL, 'value' INTEGER NOT NULL, PRIMARY KEY('key'));")
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_TOOLGUN('key' TEXT NOT NULL, 'value' INTEGER NOT NULL, PRIMARY KEY('key'));")
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_PLAYERUSE('key' TEXT NOT NULL, 'value' INTEGER NOT NULL, PRIMARY KEY('key'));")
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_ENTITYDAMAGE('key' TEXT NOT NULL, 'value' INTEGER NOT NULL, PRIMARY KEY('key'));")
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_GLOBALSETTINGS('key' TEXT NOT NULL, 'value' INTEGER NOT NULL, PRIMARY KEY('key'));")
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_BLOCKMODELSETTINGS('key' TEXT NOT NULL, 'value' INTEGER NOT NULL, PRIMARY KEY('key'));")
	
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_ANTISPAM('key' TEXT NOT NULL, 'value' INTEGER NOT NULL, PRIMARY KEY('key'));")
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_TOOLRESTRICT('toolname' TEXT NOT NULL, 'adminonly' INTEGER NOT NULL, 'teamrestrict' TEXT NOT NULL, PRIMARY KEY('toolname'));")
	
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_TOOLRESTRICTPERSON('toolname' TEXT NOT NULL, 'steamid' TEXT NOT NULL, 'allow' INTEGER NOT NULL, PRIMARY KEY('steamid', 'toolname'));")
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_GROUPS('groupname' TEXT NOT NULL, 'allowdefault' INTEGER NOT NULL, 'tools' TEXT NOT NULL, PRIMARY KEY('groupname'));")
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_GROUPMEMBERS('steamid' TEXT NOT NULL, 'groupname' TEXT NOT NULL, PRIMARY KEY('steamid'));")
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_BLOCKEDMODELS('model' TEXT NOT NULL PRIMARY KEY);")
sql.Commit()
FPP.Blocked = {}
	FPP.Blocked.Physgun = {}
	FPP.Blocked.Spawning = {}
	FPP.Blocked.Gravgun = {}
	FPP.Blocked.Toolgun = {}
	FPP.Blocked.PlayerUse = {}
	FPP.Blocked.EntityDamage = {}

FPP.BlockedModels = {}

FPP.RestrictedTools = {}
FPP.RestrictedToolsPlayers = {}

FPP.Groups = {}
FPP.GroupMembers = {}

function FPP.Notify(ply, text, bool)
	if ply:EntIndex() == 0 then
		ServerLog(text)
		return
	end
	umsg.Start("FPP_Notify", ply)
		umsg.String(text)
		umsg.Bool(bool)
	umsg.End()
	ply:PrintMessage(HUD_PRINTCONSOLE, text)
end

function FPP.NotifyAll(text, bool)
	umsg.Start("FPP_Notify")
		umsg.String(text)
		umsg.Bool(bool)
	umsg.End()
	for _,ply in pairs(player.GetAll()) do 
		ply:PrintMessage(HUD_PRINTCONSOLE, text)
	end
end

local function FPP_SetSetting(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then FPP.Notify(ply, "You need superadmin privileges in order to be able to use this command", false) return end
	if not args[1] or not args[3] or not FPP.Settings[args[1]] then FPP.Notify(ply, "Argument(s) invalid", false) return end
	if not FPP.Settings[args[1]][args[2]] then FPP.Notify(ply, "Argument invalid",false) return end
	
	FPP.Settings[args[1]][args[2]] = tonumber(args[3])
	RunConsoleCommand("_"..args[1].."_"..args[2], tonumber(args[3]))
	
	local data = sql.QueryValue("SELECT value FROM ".. args[1] .. " WHERE key = "..sql.SQLStr(args[2])..";")
	if not data then
		sql.Query("INSERT INTO ".. args[1] .. " VALUES(" .. sql.SQLStr(args[2]) .. ", " .. args[3] .. ");")
	elseif tonumber(data) ~= args[3] then
		sql.Query("UPDATE ".. args[1] .. " SET value = " .. args[3] .. " WHERE key = " .. sql.SQLStr(args[2]) .. ";")
	end

	FPP.NotifyAll(((ply.Nick and ply:Nick()) or "Console").. " set ".. string.lower(string.gsub(args[1], "FPP_", "")) .. " "..args[2].." to " .. tostring(args[3]), util.tobool(tonumber(args[3])))
end
concommand.Add("FPP_setting", FPP_SetSetting)

local function AddBlocked(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then FPP.Notify(ply, "You need superadmin privileges in order to be able to use this command", false) return end
	if not args[1] or not args[2] or not FPP.Blocked[args[1]] then FPP.Notify(ply, "Argument(s) invalid", false) return end
	if table.HasValue(FPP.Blocked[args[1]], string.lower(args[2])) then return end
	table.insert(FPP.Blocked[args[1]], string.lower(args[2]))
	
	local data = sql.Query("SELECT * FROM FPP_BLOCKED;")
	if type(data) == "table" then
		local found = false
		local highest = 0
		for k,v in pairs(data) do
			if tonumber(v.id) > highest then
				highest = tonumber(v.id)
			end
			if v.key == args[1] and v.value == args[2] then
				found = true
			end
		end
		if not found then
			sql.Query("INSERT INTO FPP_BLOCKED VALUES("..highest + 1 ..", " .. sql.SQLStr(args[1]) .. ", " .. sql.SQLStr(args[2]) .. ");")
		end
	else
		--insert
		sql.Query("INSERT INTO FPP_BLOCKED VALUES(1, " .. sql.SQLStr(args[1]) .. ", " .. sql.SQLStr(args[2]) .. ");")
	end
	
	FPP.NotifyAll(((ply.Nick and ply:Nick()) or "Console").. " added ".. args[2] .. " to the "..args[1] .. " black/whitelist", true)
end
concommand.Add("FPP_AddBlocked", AddBlocked)

local function AddBlockedModel(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then FPP.Notify(ply, "You need superadmin privileges in order to be able to use this command", false) return end
	if not args[1] then FPP.Notify(ply, "Argument(s) invalid", false) return end
	
	local model = string.lower(args[1])
	if table.HasValue(FPP.BlockedModels, model) then FPP.Notify(ply, "This model is already in the black/whitelist", false) return end
	
	table.insert(FPP.BlockedModels, model)
	sql.Query("INSERT INTO FPP_BLOCKEDMODELS VALUES("..sql.SQLStr(model)..");")
	
	FPP.NotifyAll(((ply.Nick and ply:Nick()) or "Console").. " added ".. model .. " to the blocked models black/whitelist", true)
end
concommand.Add("FPP_AddBlockedModel", AddBlockedModel)

local function RemoveBlocked(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then FPP.Notify(ply, "You need superadmin privileges in order to be able to use this command", false) return end
	if not args[1] or not args[2] or not FPP.Blocked[args[1]] then FPP.Notify(ply, "Argument(s) invalid", false) return end
	
	for k,v in pairs(FPP.Blocked[args[1]]) do
		if v == args[2] then
			table.remove(FPP.Blocked[args[1]], k)
		end
	end
	
	local data = sql.Query("SELECT * FROM FPP_BLOCKED;")
	
	if type(data) == "table" then
		for k,v in ipairs(data) do
			if v.key == args[1] and v.value == args[2] then
				sql.Query("DELETE FROM FPP_BLOCKED WHERE key = "..sql.SQLStr(v.key) .. " AND value = "..sql.SQLStr(v.value)..";") 
			end
		end
	end
	
	FPP.NotifyAll(((ply.Nick and ply:Nick()) or "Console").. " removed ".. args[2] .. " from the "..args[1] .. " black/whitelist", false)
end
concommand.Add("FPP_RemoveBlocked", RemoveBlocked)

local function RemoveBlockedModel(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then FPP.Notify(ply, "You need superadmin privileges in order to be able to use this command", false) return end
	if not args[1] then FPP.Notify(ply, "Argument(s) invalid", false) return end
	local model = string.lower(args[1])
	
	for k,v in pairs(FPP.BlockedModels) do
		if v == model then table.remove(FPP.BlockedModels, k) break end
	end
	sql.Query("DELETE FROM FPP_BLOCKEDMODELS WHERE model = "..sql.SQLStr(model)..";")
	FPP.NotifyAll(((ply.Nick and ply:Nick()) or "Console").. " removed ".. model .. " from the blocked models black/whitelist", false)
end
concommand.Add("FPP_RemoveBlockedModel", RemoveBlockedModel)

local function ShareProp(ply, cmd, args)
	if not args[1] or not ValidEntity(Entity(args[1])) or not args[2] then FPP.Notify(ply, "Argument(s) invalid", false) return end
	local ent = Entity(args[1])
	
	if not FPP.PlayerCanTouchEnt(ply, ent, "Toolgun", "FPP_TOOLGUN", true) then --Note: This returns false when it's someone elses shared entity, so that's not a glitch
		FPP.Notify(ply, "You do not have the right to share this entity.", false)
		return
	end
	
	if not ValidEntity(Player(args[2])) then -- This is for sharing prop per utility
		ent[args[2]] = util.tobool(args[3])
	else -- This is for sharing prop per player
		local target = Player(args[2])
		local toggle = util.tobool(args[3])
		if not ent.AllowedPlayers and toggle then -- Make the table if it isn't there
			ent.AllowedPlayers = {target}
		else
			if toggle and not table.HasValue(ent.AllowedPlayers, target) then
				table.insert(ent.AllowedPlayers, target)
				FPP.Notify(target, ply:Nick().. " shared an entity with you!", true)
			elseif not toggle then
				for k,v in pairs(ent.AllowedPlayers) do
					if v == target then
						table.remove(ent.AllowedPlayers, k)
						FPP.Notify(target, ply:Nick().. " unshared an entity with you!", false)
					end
				end
			end
		end
	end
end
concommand.Add("FPP_ShareProp", ShareProp)

local function RetrieveSettings()	
	for k,v in pairs(FPP.Settings) do
		local data = sql.Query("SELECT key, value FROM "..k..";")
		if data then
			local i = 0
			for key, value in pairs(data) do
				FPP.Settings[k][value.key] = tonumber(value.value)
				i = i + 0.05
				timer.Simple(i, RunConsoleCommand, "_"..k.."_"..value.key, tonumber(value.value))
			end
		end
	end	
end
timer.Simple(1, RetrieveSettings)

local function RetrieveBlocked()
	local data = sql.Query("SELECT * FROM FPP_BLOCKED;")
	if type(data) == "table" then
		for k,v in pairs(data) do
			table.insert(FPP.Blocked[v.key], v.value)
		end
	else
		data = sql.Query("CREATE TABLE IF NOT EXISTS FPP_BLOCKED('id' INTEGER NOT NULL, 'key' TEXT NOT NULL, 'value' TEXT NOT NULL, PRIMARY KEY('id'));")
		FPP.Blocked.Physgun = {
			"func_breakable_surf",
			"func_brush",
			"func_door",
			"prop_dynamic",
			"prop_dynamic_override",
			"func_button",
			"prop_door_rotating",
			"spawnpoint",
			"bigbomb",
			"npc_",
			"auto_turret",}
		FPP.Blocked.Spawning = {"func_breakable_surf",
			"player",
			"func_door",
			"prop_door_rotating",
			"drug_", 
			"drug_lab", 
			"food", 
			"gunlab", 
			"letter", 
			"meteor", 
			"microwave", 
			"money_printer", 
			"spawned_shipment", 
			"auto_turret_gun",
			"item_",
			"spawnpoint",
			"bigbomb",
			"auto_turret",
			"spawned_weapon",  
			"spawned_food",
			"spawned_money"}
		FPP.Blocked.Gravgun = {"func_breakable_surf", "vehicle_"}
		FPP.Blocked.Toolgun = {"func_breakable_surf",
			"player",
			"func_door",
			"prop_door_rotating",
			"drug", 
			"drug_lab", 
			"food", 
			"gunlab", 
			"letter", 
			"meteor", 
			"microwave", 
			"money_printer", 
			"spawned_shipment", 
			"spawned_weapon",  
			"spawned_food",
			"spawned_money"}
		FPP.Blocked.PlayerUse = {}
		FPP.Blocked.EntityDamage = {}
		
		local count = 0
		sql.Begin()
		for k,v in pairs(FPP.Blocked) do
			for a,b in pairs(v) do
				count = count + 1
				sql.Query("INSERT INTO FPP_BLOCKED VALUES(".. count ..", " .. sql.SQLStr(k) .. ", " .. sql.SQLStr(b) .. ");")
			end 
		end
		sql.Commit()
	end
end
RetrieveBlocked()


local function RetrieveBlockedModels()
	local Query = sql.Query("SELECT * FROM FPP_BLOCKEDMODELS;")
	for k,v in pairs(Query or {}) do
		table.insert(FPP.BlockedModels, v.model)
	end
end
RetrieveBlockedModels()

local function RetrieveRestrictedTools()
	local data = sql.Query("SELECT * FROM FPP_TOOLRESTRICT;")
	
	if type(data) == "table" then
		for k,v in pairs(data) do
			FPP.RestrictedTools[v.toolname] = {}
			FPP.RestrictedTools[v.toolname]["admin"] = tonumber(v.adminonly)
			
			FPP.RestrictedTools[v.toolname]["team"] = FPP.RestrictedTools[v.toolname]["team"] or {}
			
			if v.teamrestrict ~= "nil" then
				local teamrestrict = string.Explode(";", v.teamrestrict)
				for a, b in pairs(teamrestrict) do
					table.insert(FPP.RestrictedTools[v.toolname]["team"], tonumber(b))
				end
			end
			
		end
	end
	
	local perplayerData = sql.Query("SELECT * FROM FPP_TOOLRESTRICTPERSON;")
	if type(perplayerData) == "table" then
		for k,v in pairs(perplayerData) do
			FPP.RestrictedToolsPlayers[v.toolname] = FPP.RestrictedToolsPlayers[v.toolname] or {}
			local convert = {}
			convert["1"] = true
			convert["0"] = false
			FPP.RestrictedToolsPlayers[v.toolname][v.steamid] = convert[v.allow]
		end
	end
end
RetrieveRestrictedTools()

local function RetrieveGroups()
	local data = sql.Query("SELECT * FROM FPP_GROUPS;")
	if type(data) ~= "table" then 
		sql.Query("INSERT INTO FPP_GROUPS VALUES('default', 1, '');")
		return 
	end -- if there are no groups then there isn't much to load
	for k,v in pairs(data) do
		FPP.Groups[v.groupname] = {}
		FPP.Groups[v.groupname].tools = string.Explode(";", v.tools)
		FPP.Groups[v.groupname].allowdefault = util.tobool(v.allowdefault)
		for num,tool in pairs(FPP.Groups[v.groupname].tools) do
			if tool == "" then
				table.remove(FPP.Groups[v.groupname].tools, num)
			end
		end
	end
	
	local members = sql.Query("SELECT * FROM FPP_GROUPMEMBERS;")
	if type(members) ~= "table" then return end
	for _,v in pairs(members) do
		FPP.GroupMembers[v.steamid] = v.groupname
		if not FPP.Groups[v.groupname] then -- if group does not exist then set to default
			FPP.GroupMembers[v.steamid] = nil
			sql.Query("DELETE FROM FPP_GROUPMEMBERS WHERE steamid = "..sql.SQLStr(v.steamid)..";")
		end
	end
end
RetrieveGroups()

local function SendSettings(ply)
	timer.Simple(10, function(ply)
		local i = 0
		for k,v in pairs(FPP.Settings) do
			for a,b in pairs(v) do
				i = i + FrameTime()*2
				timer.Simple(i, function()
					RunConsoleCommand("_"..k.."_"..a, (b and b + 1) or 0)
					timer.Simple(i, RunConsoleCommand, "_"..k.."_"..a, b or "")
				end)
			end
		end
	end, ply)
end
hook.Add("PlayerInitialSpawn", "FPP_SendSettings", SendSettings)

local function AddGroup(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then FPP.Notify(ply, "You need superadmin privileges in order to be able to use this command", false) return end
	if not args[1] then FPP.Notify(ply, "Invalid argument(s)", false) return end-- Args: 1 = name, optional: 2 = allowdefault
	local name = string.lower(args[1])
	local allowdefault = tonumber(args[2]) or 1
	
	if FPP.Groups[name] then 
		FPP.Notify(ply, "Group already exists", false)
		return
	end
	
	FPP.Groups[name] = {}
	FPP.Groups[name].allowdefault = util.tobool(allowdefault)
	FPP.Groups[name].tools = {}
	
	sql.Query("INSERT INTO FPP_GROUPS VALUES("..sql.SQLStr(name)..", "..sql.SQLStr(allowdefault)..", \"\");")
	FPP.Notify(ply, "Group added succesfully", true)
end
concommand.Add("FPP_AddGroup", AddGroup)

local function RemoveGroup(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then FPP.Notify(ply, "You need superadmin privileges in order to be able to use this command", false) return end
	if not args[1] then FPP.Notify(ply, "Invalid argument(s)", false) return end-- Args: 1 = name
	local name = string.lower(args[1])
	
	if not FPP.Groups[name] then 
		FPP.Notify(ply, "Group does not exists", false)
		return
	end
	
	if name == "default" then
	FPP.Notify(ply, "Can not remove default group", false)
		return
	end
	
	FPP.Groups[name] = nil
	sql.Query("DELETE FROM FPP_GROUPS WHERE groupname = "..sql.SQLStr(name)..";")
	
	for k,v in pairs(FPP.GroupMembers) do
		if v == name then
			FPP.GroupMembers[k] = nil -- Set group to standard if group is removed
		end
	end
	FPP.Notify(ply, "Group removed succesfully", true)
end
concommand.Add("FPP_RemoveGroup", RemoveGroup)

local function GroupChangeAllowDefault(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then FPP.Notify(ply, "You need superadmin privileges in order to be able to use this command", false) return end
	if not args[2] then FPP.Notify(ply, "Invalid argument(s)", false) return end-- Args: 1 = groupname, 2 = new value 1/0
	
	local name = string.lower(args[1])
	local newval = tonumber(args[2])
	
	if not FPP.Groups[name] then 
		FPP.Notify(ply, "Group does not exists", false)
		return
	end
	
	FPP.Groups[name].allowdefault = util.tobool(newval)
	sql.Query("UPDATE FPP_GROUPS SET allowdefault = "..sql.SQLStr(newval).." WHERE groupname = "..sql.SQLStr(name)..";")
	FPP.Notify(ply, "Group status changed succesfully", true)
end
concommand.Add("FPP_ChangeGroupStatus", GroupChangeAllowDefault)

local function GroupAddTool(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then FPP.Notify(ply, "You need superadmin privileges in order to be able to use this command", false) return end
	if not args[2] then FPP.Notify(ply, "Invalid argument(s)", false) return end-- Args: 1 = groupname, 2 = tool
	
	local name = args[1]
	local tool = string.lower(args[2])
	
	if not FPP.Groups[name] then 
		FPP.Notify(ply, "Group does not exists", false)
		return
	end
	
	if table.HasValue(FPP.Groups[name].tools, tool) then
		FPP.Notify(ply, "Tool is already in group!", false)
		return
	end
	
	table.insert(FPP.Groups[name].tools, tool)
	local tools = table.concat(FPP.Groups[name].tools, ";")
	sql.Query("UPDATE FPP_GROUPS SET tools = "..sql.SQLStr(tools).." WHERE groupname = "..sql.SQLStr(name)..";")
	FPP.Notify(ply, "Tool added succesfully", true)
end
concommand.Add("FPP_AddGroupTool", GroupAddTool)

local function GroupRemoveTool(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then FPP.Notify(ply, "You need superadmin privileges in order to be able to use this command", false) return end
	if not args[2] then FPP.Notify(ply, "Invalid argument(s)", false) return end-- Args: 1 = groupname, 2 = tool
	
	local name = args[1]
	local tool = string.lower(args[2])
	
	if not FPP.Groups[name] then 
		FPP.Notify(ply, "Group does not exists", false)
		return
	end
	
	if not table.HasValue(FPP.Groups[name].tools, tool) then
		FPP.Notify(ply, "Tool does not exist in group!", false)
		return
	end
	
	for k,v in pairs(FPP.Groups[name].tools) do
		if v == tool then
			table.remove(FPP.Groups[name].tools, k)
		end
	end
	
	local tools = table.concat(FPP.Groups[name].tools, ";")
	sql.Query("UPDATE FPP_GROUPS SET tools = "..sql.SQLStr(tools).." WHERE groupname = "..sql.SQLStr(name)..";")
	FPP.Notify(ply, "Tool removed succesfully", true)
end
concommand.Add("FPP_RemoveGroupTool", GroupRemoveTool)

local function PlayerSetGroup(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then FPP.Notify(ply, "You need superadmin privileges in order to be able to use this command", false) return end
	if not args[2] then FPP.Notify(ply, "Invalid argument(s)", false) return end-- Args: 1 = player, 2 = group
	
	local name = args[1]
	local group = string.lower(args[2])
	if ValidEntity(Player(name)) then name = Player(name):SteamID()
	elseif not string.find(name, "STEAM") and name ~= "UNKNOWN" then FPP.Notify(ply, "Invalid argument(s)", false) return end
	
	if not FPP.Groups[group] then 
		FPP.Notify(ply, "Group does not exists", false)
		return
	end
	
	if group ~= "default" then
		local member = sql.Query("SELECT * FROM FPP_GROUPMEMBERS WHERE steamid = ".. sql.SQLStr(name) ..";")
		if member then
			sql.Query("UPDATE FPP_GROUPMEMBERS SET groupname = "..sql.SQLStr(group) .. " WHERE steamid = "..sql.SQLStr(name)..";")
		elseif not member then
			sql.Query("INSERT INTO FPP_GROUPMEMBERS VALUES(".. sql.SQLStr(name)..", " .. sql.SQLStr(group) ..");")
		end
		FPP.GroupMembers[name] = group
	else
		FPP.GroupMembers[name] = nil
		sql.Query("DELETE FROM FPP_GROUPMEMBERS WHERE steamid = "..sql.SQLStr(name)..";")
	end
	
	FPP.Notify(ply, "Player group succesfully set", true)
end
concommand.Add("FPP_SetPlayerGroup", PlayerSetGroup)

local function SendGroupData(ply, cmd, args)
	-- Need superadmin so clients can't spam this on server
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then FPP.Notify(ply, "You need superadmin privileges in order to be able to use this command", false) return end
	datastream.StreamToClients(ply, "FPP_Groups", FPP.Groups)
end
concommand.Add("FPP_SendGroups", SendGroupData)

local function SendGroupMemberData(ply, cmd, args)
	-- Need superadmin so clients can't spam this on server
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then FPP.Notify(ply, "You need superadmin privileges in order to be able to use this command", false) return end
	datastream.StreamToClients(ply, "FPP_GroupMembers", FPP.GroupMembers)
end
concommand.Add("FPP_SendGroupMembers", SendGroupMemberData)

local function SendBlocked(ply, cmd, args)
	--I don't need an admin check here since people should be able to find out without having admin
	if not args[1] or not FPP.Blocked[args[1]] then return end
	for k,v in pairs(FPP.Blocked[args[1]]) do
		umsg.Start("FPP_blockedlist", ply)
			umsg.String(args[1])
			umsg.String(v)
		umsg.End()
	end
end
concommand.Add("FPP_sendblocked", SendBlocked)

local function SendBlockedModels(ply, cmd, args)
	--I don't need an admin check here since people should be able to find out without having admin
	for k,v in pairs(FPP.BlockedModels) do
		timer.Simple(k*0.05, function()
			umsg.Start("FPP_BlockedModel", ply)
				umsg.String(v)
			umsg.End()
		end)
	end
end
concommand.Add("FPP_sendblockedmodels", SendBlockedModels)

local function SendRestrictedTools(ply, cmd, args)
	if not args[1] then return end
	umsg.Start("FPP_RestrictedToolList", ply)
		umsg.String(args[1])
		if FPP.RestrictedTools[args[1]] and FPP.RestrictedTools[args[1]].admin then
			umsg.Long(FPP.RestrictedTools[args[1]].admin)
		else
			umsg.Long(0)
		end
		
		local teamrestrict = "nil"
		if FPP.RestrictedTools[args[1]] and FPP.RestrictedTools[args[1]].team then
			teamrestrict = table.concat(FPP.RestrictedTools[args[1]]["team"], ";")
		end
		if teamrestrict == "" then teamrestrict = "nil" end
		umsg.String(teamrestrict)
		
	umsg.End()
end
concommand.Add("FPP_SendRestrictTool", SendRestrictedTools)

--Buddies!
local function SetBuddy(ply, cmd, args)
	if not args[6] then FPP.Notify(ply, "Argument(s) invalid", false) return end
	local buddy = Player(args[1])
	if not ValidEntity(buddy) then FPP.Notify(ply, "Player invalid", false) return end
	
	ply.Buddies = ply.Buddies or {}
	for k,v in pairs(args) do args[k] = tonumber(v) end
	ply.Buddies[buddy] = {physgun = util.tobool(args[2]), gravgun = util.tobool(args[3]), toolgun = util.tobool(args[4]), playeruse = util.tobool(args[5]), entitydamage = util.tobool(args[6])}
end
concommand.Add("FPP_SetBuddy", SetBuddy)

local function CleanupDisconnected(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsAdmin() then FPP.Notify(ply, "You can't clean up", false) return end
	if not args[1] then FPP.Notify(ply, "Invalid argument", false) return end
	if args[1] == "disconnected" then
		for k,v in pairs(ents.GetAll()) do
			if v.Owner and not ValidEntity(v.Owner) then
				v:Remove()
			end
		end
		FPP.NotifyAll(((ply.Nick and ply:Nick()) or "Console") .. " removed all disconnected players' props", true)
		return
	elseif not ValidEntity(Player(args[1])) then FPP.Notify(ply, "Invalid player", false) return 
	end
	
	for k,v in pairs(ents.GetAll()) do
		if v.Owner == Player(args[1]) and not v:IsWeapon() then
			v:Remove()
		end
	end
	FPP.NotifyAll(((ply.Nick and ply:Nick()) or "Console") .. " removed "..Player(args[1]):Nick().. "'s entities", true)
end
concommand.Add("FPP_Cleanup", CleanupDisconnected)

local function SetToolRestrict(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then FPP.Notify(ply, "You can't set tool restrictions", false) return end
	if not args[3] then FPP.Notify(ply, "Invalid argument(s)", false) return end--FPP_restricttool <toolname> <type(admin/team)> <toggle(1/0)>
	local toolname = args[1]
	local RestrictWho = tonumber(args[2]) or args[2]-- "team" or "admin"
	local teamtoggle = tonumber(args[4]) --this argument only exists when restricting a tool for a team
	
	FPP.RestrictedTools[toolname] = FPP.RestrictedTools[toolname] or {}
	
	if RestrictWho == "admin" then
		FPP.RestrictedTools[toolname].admin = args[3] --weapons.Get("gmod_tool").Tool
		
		--Save to database!
		local data = sql.Query("SELECT * FROM FPP_TOOLRESTRICT WHERE toolname = "..sql.SQLStr(toolname)..";")
		if data then
			sql.Query("UPDATE FPP_TOOLRESTRICT SET adminonly = ".. sql.SQLStr(args[3]) .. " WHERE toolname = "..sql.SQLStr(toolname)..";")
		else
			sql.Query("INSERT INTO FPP_TOOLRESTRICT VALUES("..sql.SQLStr(toolname)..", "..sql.SQLStr(args[3])..", "..sql.SQLStr("nil")..");")
		end
	elseif RestrictWho == "team" then
		FPP.RestrictedTools[toolname]["team"] = FPP.RestrictedTools[toolname]["team"] or {}
		if teamtoggle == 0 then
			for k,v in pairs(FPP.RestrictedTools[toolname]["team"]) do
				if v == tonumber(args[3]) then
					table.remove(FPP.RestrictedTools[toolname]["team"], k)
					break
				end
			end
		elseif not table.HasValue(FPP.RestrictedTools[toolname]["team"], tonumber(args[3])) and teamtoggle == 1 then
			table.insert(FPP.RestrictedTools[toolname]["team"], tonumber(args[3]))
		end--Remove from the table if it's in there AND it's 0 otherwise do nothing
		
		local teamrestrict = table.concat(FPP.RestrictedTools[toolname]["team"], ";")
		if teamrestrict == "" then teamrestrict = "nil" end
		local adminonly = FPP.RestrictedTools[toolname].admin or 0
		
		local data = sql.Query("SELECT * FROM FPP_TOOLRESTRICT WHERE toolname = "..sql.SQLStr(toolname)..";")
		if data then
			sql.Query("UPDATE FPP_TOOLRESTRICT SET teamrestrict = " .. sql.SQLStr(teamrestrict).." WHERE toolname = "..sql.SQLStr(toolname)..";")
		else
			sql.Query("INSERT INTO FPP_TOOLRESTRICT VALUES("..sql.SQLStr(toolname)..", "..sql.SQLStr(adminonly)..", "..sql.SQLStr(teamrestrict)..");")
		end
		data = sql.Query("SELECT * FROM FPP_TOOLRESTRICT WHERE toolname = "..sql.SQLStr(toolname)..";")
	end
end
concommand.Add("FPP_restricttool", SetToolRestrict)

local function RestrictToolPerson(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() then return end
	if not args[3] then FPP.Notify(ply, "Invalid argument(s)", false) return end--FPP_restricttoolperson <toolname> <userid> <disallow, allow, remove(0,1,2)>
	local toolname = args[1] 
	local target = Player(tonumber(args[2]))
	local access = tonumber(args[3])
	if not target:IsValid() then FPP.Notify(ply, "Invalid argument(s)", false) return end
	if access < 0 or access > 2 then FPP.Notify(ply, "Invalid argument(s)", false) return end
	
	FPP.RestrictedToolsPlayers[toolname] = FPP.RestrictedToolsPlayers[toolname] or {}
	
	local data = sql.Query("SELECT * FROM FPP_TOOLRESTRICTPERSON WHERE toolname = "..sql.SQLStr(toolname).." AND steamid = "..sql.SQLStr(target:SteamID()) ..";")
	if access == 0 then -- Disallow, even if other people can use it
		FPP.RestrictedToolsPlayers[toolname][target:SteamID()] = false
		if not data then
			sql.Query("INSERT INTO FPP_TOOLRESTRICTPERSON VALUES("..sql.SQLStr(toolname)..", "..sql.SQLStr(target:SteamID())..", 0);")
		else
			sql.Query("UPDATE FPP_TOOLRESTRICTPERSON SET allow = 0 WHERE toolname = "..sql.SQLStr(toolname).." AND steamid = "..sql.SQLStr(target:SteamID())..";")
		end
	elseif access == 1 then -- allow, even if other people can't use it
		FPP.RestrictedToolsPlayers[toolname][target:SteamID()] = true
		if not data then
			sql.Query("INSERT INTO FPP_TOOLRESTRICTPERSON VALUES("..sql.SQLStr(toolname)..", "..sql.SQLStr(target:SteamID())..", 1);")
		else
			sql.Query("UPDATE FPP_TOOLRESTRICTPERSON SET allow = 1 WHERE toolname = "..sql.SQLStr(toolname).." AND steamid = "..sql.SQLStr(target:SteamID())..";")
		end
	elseif access == 2 then -- reset tool status(make him like everyone else)
		FPP.RestrictedToolsPlayers[toolname][target:SteamID()] = nil
		if data then
			sql.Query("DELETE FROM FPP_TOOLRESTRICTPERSON WHERE toolname = "..sql.SQLStr(toolname).." AND steamid = "..sql.SQLStr(target:SteamID())..";")
		end
	end	
end
concommand.Add("FPP_restricttoolplayer", RestrictToolPerson)

local assbackup = ASS_RegisterPlugin or function() end-- Suddenly after witing this code, ASS spamprotection and propprotection broke. I have no clue why. I guess you should use FPP then
function ASS_RegisterPlugin(plugin, ...)
	if plugin.Name == "Sandbox Spam Protection" or plugin.Name == "Sandbox Prop Protection" then
		return
	end
	return assbackup(plugin, ...)
end