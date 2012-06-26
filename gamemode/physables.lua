
local nograv = {
"shot_beanbag",
"shot_tankshell",
"shot_rocket",
"shot_tranq",
"auto_turret_gun",
"shot_glround",
"svehicle_part_nophysics",
"svehicle_part",
"shot_glround",
"worldslayer",
"shot_energy"
}

// not local so that it can be used in all the rest of the game.
physgunables = {
"gmod_cameraprop",
"gmod_rtcameraprop",
"gmod_balloon",
"gmod_button",
"gmod_lamp",
"gmod_light",
"gmod_anchor",
"func_physbox",
"prop_physics",
"prop_physics_multiplayer",
"spawned_weapon",
"microwave",
"drug_lab",
"gunlab",
"dispenser",
"phys_magnet",
"m_crate",
"prop_ragdoll",
"gmod_thruster",
"gmod_wheel",
"item_drug",
"item_steroid",
"item_painkiller",
"item_magicbullet",
"item_antidote",
"item_amp",
"item_helmet",
"item_random",
"item_buyhealth",
"item_superdrug",
"item_booze",
"item_scanner",
"item_toolkit",
"item_regen",
"item_reflect",
"item_focus",
"item_snipeshield",
"item_armor",
"item_food",
"item_leech",
"item_shockwave",
"item_doubletap",
"item_uberdrug",
"item_knockback",
"item_doublejump",
"item_armorpiercer",
"item_superdrugoffense",
"item_superdrugdefense",
"item_superdrugweapmod",
"pillbox",
"drugfactory",
"powerplant",
"weedplant",
"meth_lab",
"prop_effect",
"money_printer",
"still",
"gunvault",
"radartower",
"gunfactory",
"bigbomb",
"keypad",
"sign"
}

function ccWithdrawGun( ply, cmd, args )
	// in case of jackasses trying to exploit the game, or any other wierd shit that could happen.
	if (args[1]==nil || args[2] == nil) then 
		return 
	end
	gnum = tonumber(args[2])
	if (!ents.GetByIndex(args[1]):IsValid() || gnum>10 || gnum<1) then 
		return 
	end
	local vault = ents.GetByIndex(args[1])
	if (vault:GetClass()!="gunvault" || ply:GetPos():Distance(vault:GetPos())>200) then return end
	if (vault:IsLocked() && ply!=vault.Owner && !ply:IsAllied(vault.Owner)) then return end
	if (vault:CanDropGun(gnum)) then
		vault:DropGun(gnum, ply, 25, false)
	else
		Notify(ply,4,3, "This gun does not exist!")
		umsg.Start( "killgunvaultgui", ply );
			umsg.Short( args[1] )
		umsg.End()
	end	
end
concommand.Add( "withdrawgun", ccWithdrawGun );

function ccWithdrawItem( ply, cmd, args )
	// in case of jackasses trying to exploit the game, or any other wierd shit that could happen.
	if (args[1]==nil || args[2] == nil) then 
		return 
	end
	gnum = tonumber(args[2])
	if (!ents.GetByIndex(args[1]):IsValid() || gnum>20 || gnum<1) then 
		return 
	end
	local vault = ents.GetByIndex(args[1])
	if (vault:GetClass()!="pillbox" || ply:GetPos():Distance(vault:GetPos())>200) then return end
	if (vault:IsLocked() && ply!=vault.Owner && !ply:IsAllied(vault.Owner)) then return end
	if (vault:CanDropGun(gnum)) then
		vault:DropGun(gnum, ply, 35, false)
	else
		Notify(ply,4,3, "This item does not exist!")
		umsg.Start( "killpillboxgui", ply );
			umsg.Short( args[1] )
		umsg.End()
	end	
end
concommand.Add( "withdrawitem", ccWithdrawItem );

function ccSetWeapon( ply, cmd, args )
	if (args[1]==nil || args[2] == nil) then 
		return 
	end
    
    local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 150;
	trace.filter = ply;
    
	guntype = tostring(args[2])
	local tr = util.TraceLine( trace );
	if (!ValidEntity(tr.Entity)) then
		return 
	end
	local targent = tr.Entity
    if !ValidEntity(ents.GetByIndex(args[1])) || (guntype!="laserbeam" && guntype!="laserrifle" && guntype!="grenadegun" && guntype!="plasma" && guntype!="worldslayer" && guntype!="resetbutton") then
		return 
	end
	local vault = ents.GetByIndex(args[1])
    if (targent:GetClass()!="gunfactory" || ply:GetPos():Distance(targent:GetPos())>300) then return end
	if (targent:CanProduce()) then
		targent:StartProduction(ply,guntype)
	else
		if guntype=="resetbutton" then
			Notify(ply, 0, 3,"Only Gun Factory owner can cancel weapon production." );
		else
			Notify( ply, 0, 3, "Cant make weapon." );
		end
		umsg.Start( "killgunfactorygui", ply );
			umsg.Short( args[1] )
		umsg.End()
	end	
end

concommand.Add( "setgunfactoryweapon", ccSetWeapon );

function WeldControl(ent,ply)
	if (ValidEntity(ply)) then
		if ValidEntity(ent) then
			ent:SetNWInt("welddamage", 150)
		end
		ply:GetTable().shitweldcount=ply:GetTable().shitweldcount-1
		if (ply:GetTable().shitweldcount<=0) then
			ply:GetTable().shitweldcount=0
			ply:SetNWBool("shitwelding", false)
		end
	end
end

function ccSetRefineryMode( ply, cmd, args )
	if (args[1]==nil || args[2] == nil) then 
		return 
	end
	mode = tostring(args[2])
	if !ValidEntity(ents.GetByIndex(args[1])) || (mode!="money" && mode!="offense" && mode!="defense" && mode!="weapmod" && mode!="eject" && mode!="uber") then
		return 
	end
	local vault = ents.GetByIndex(args[1])
	if (vault:GetClass()!="drugfactory" || ply:GetPos():Distance(vault:GetPos())>300) then return end
	
	local ref = vault:CanRefine(mode,ply)
	if (ref==true) then
		vault:SetMode(mode)
	else
		Notify(ply,4,3,ref)
	end
	umsg.Start( "killdrugfactorygui", ply );
		umsg.Short( args[1] )
	umsg.End()
end
concommand.Add( "setrefinerymode", ccSetRefineryMode );


local function GetEntOwner(ent)
	if !ValidEntity(ent) then return false end
	local owner = ent
	if ent:GetVar("PropProtection")==nil then return false end
	if ValidEntity(player.GetByUniqueID(ent:GetVar("PropProtection"))) then
		owner = player.GetByUniqueID(ent:GetVar("PropProtection"))
	end
	if owner!=ent then
		return owner
	else
		return false
	end
end

--function NotifyPlayer( ply, msg )
--	if (!timer.IsTimer(ply:SteamID() .. msg)) then
--		timer.Create(ply:SteamID() .. msg, 5, 1, timer.Remove, ply:SteamID() .. msg)
--		ply:PrintMessage( 2, msg );
--		ply:SendLua( "GAMEMODE:AddNotify(\"" .. msg .. "\", " .. 1 .. ", " .. 3 .. ")" );
--	end
--end

local function SetOwner(ent, ply)
	// take no chances, check it here too.
	if (ValidEntity(ent) && ValidEntity(ply) && ply:IsPlayer()) then
		ent:SetVar("PropProtection", ply:UniqueID() )
		return true
	else
		return false
	end
end

local originalCleanup = cleanup.Add
function cleanup.Add(ply,type,ent)
	if (ValidEntity(ply) && ply:IsPlayer() && ValidEntity(ent)) then
		SetOwner(ent, ply)
	end
	originalCleanup(ply,type,ent)
end

function SpawnedProp(ply, model, ent)
	SetOwner(ent, ply)
end 
 
hook.Add("PlayerSpawnedProp", "playerSpawnedProp", SpawnedProp)