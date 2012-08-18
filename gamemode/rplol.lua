
VoteCopOn = false;

function foodHeal( pl )
	if( GetGlobalInt( "hungermod" ) == 0 ) then
		// LOL at what used to be here.
		pl:SetHealth(pl:Health()+math.random(25,45))
		if (pl:Health()>pl:GetMaxHealth()*1.25) then
			pl:SetHealth(pl:GetMaxHealth()*1.25)
		end
	else
		pl:SetNWInt( "Energy", 100 );
        	umsg.Start( "AteFoodIcon", pl )
		umsg.End()
	end
	return "";
end

function DrugPlayer(pl)
	pl:ConCommand("pp_motionblur 1")
	pl:ConCommand("pp_motionblur_addalpha 0.05")
	pl:ConCommand("pp_motionblur_delay 0.035")
	pl:ConCommand("pp_motionblur_drawalpha 0.75")
	pl:ConCommand("pp_dof 1")
	pl:ConCommand("pp_dof_initlength 9")
	pl:ConCommand("pp_dof_spacing 100")

	local IDSteam = string.gsub(pl:SteamID(), ":", "")


	// lol.
	if (pl:GetTable().Antidoted) then
		timer.Create( IDSteam, 5, 1, UnDrugPlayer, pl)
	else
		timer.Create( IDSteam, 10, 1, UnDrugPlayer, pl)
	end
end

function UnDrugPlayer(pl)
	pl:ConCommand("pp_motionblur 0")
	pl:ConCommand("pp_dof 0")
end

function BoozePlayer(pl)
	pl:ConCommand("pp_motionblur 1")
	pl:ConCommand("pp_motionblur_addalpha 0.05")
	pl:ConCommand("pp_motionblur_delay 0.035")
	pl:ConCommand("pp_motionblur_drawalpha 0.75")
	pl:ConCommand("pp_dof 1")
	pl:ConCommand("pp_dof_initlength 9")
	pl:ConCommand("pp_dof_spacing 100")

	local IDSteam = string.gsub(pl:SteamID(), ":", "")


	// lol.
	if (pl:GetTable().Antidoted) then
		timer.Create( IDSteam, 5, 1, UnBoozePlayer, pl)
	else
		timer.Create( IDSteam, 10, 1, UnBoozePlayer, pl)
	end
end

function UnBoozePlayer(pl)
	pl:ConCommand("pp_motionblur 0")
	pl:ConCommand("pp_dof 0")
end

function dropWeapon( ply )

	local trace = { }

	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;

	local tr = util.TraceLine( trace );
	local ent = ply:GetActiveWeapon()
	if !ValidEntity(ent) then return  ""; end
	local diddrop = true
	local upgrade = ent:GetNWBool("upgraded")
	if(ent:GetClass( ) == "weapon_deagle2") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_pist_deagle.mdl" );
		weapon:SetNWString("weaponclass", "weapon_deagle2");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_fiveseven2") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_pist_fiveseven.mdl" );
		weapon:SetNWString("weaponclass", "weapon_fiveseven2");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_glock2") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_pist_glock18.mdl" );
		weapon:SetNWString("weaponclass", "weapon_glock2");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_ak472") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_rif_ak47.mdl" );
		weapon:SetNWString("weaponclass", "weapon_ak472");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_mp52") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_smg_mp5.mdl" );
		weapon:SetNWString("weaponclass", "weapon_mp52");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_m42") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_rif_m4a1.mdl" );
		weapon:SetNWString("weaponclass", "weapon_m42");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_galil2") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_rif_galil.mdl" );
		weapon:SetNWString("weaponclass", "weapon_galil2");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_aug2") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_rif_aug.mdl" );
		weapon:SetNWString("weaponclass", "weapon_aug2");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_mac102") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_smg_mac10.mdl" );
		weapon:SetNWString("weaponclass", "weapon_mac102");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_ump452") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_smg_ump45.mdl" );
		weapon:SetNWString("weaponclass", "weapon_ump452");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_50cal2") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_mach_m249para.mdl" );
		weapon:SetNWString("weaponclass", "weapon_50cal2");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_pumpshotgun2") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_shot_m3super90.mdl" );
		weapon:SetNWString("weaponclass", "weapon_pumpshotgun2");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_autoshotgun2") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_shot_xm1014.mdl" );
		weapon:SetNWString("weaponclass", "weapon_autoshotgun2");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_tmp2") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_smg_tmp.mdl" );
		weapon:SetNWString("weaponclass", "weapon_tmp2");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "ls_sniper") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_snip_awp.mdl" );
		weapon:SetNWString("weaponclass", "ls_sniper");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_autosnipe") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_snip_g3sg1.mdl" );
		weapon:SetNWString("weaponclass", "weapon_autosnipe");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_turretgun") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_smg1.mdl" );
		weapon:SetNWString("weaponclass", "weapon_turretgun");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_flamethrower") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_smg1.mdl" );
		weapon:SetNWString("weaponclass", "weapon_flamethrower");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_usp2") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_pist_usp.mdl" );
		weapon:SetNWString("weaponclass", "weapon_usp2");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_elites2") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_pist_elite_dropped.mdl" );
		weapon:SetNWString("weaponclass", "weapon_elites2");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_p2282") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_pist_p228.mdl" );
		weapon:SetNWString("weaponclass", "weapon_p2282");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_p902") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_smg_p90.mdl" );
		weapon:SetNWString("weaponclass", "weapon_p902");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_knife2") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_knife_t.mdl" );
		weapon:SetNWString("weaponclass", "weapon_knife2");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_rocketlauncher") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_rocket_launcher.mdl" );
		weapon:SetNWString("weaponclass", "weapon_rocketlauncher");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_tranqgun") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_crossbow.mdl" );
		weapon:SetNWString("weaponclass", "weapon_tranqgun");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_worldslayer") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_rocket_launcher.mdl" );
		weapon:SetNWString("weaponclass", "weapon_worldslayer");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	elseif(ent:GetClass( ) == "weapon_grenadegun") then
		ply:StripWeapon( ent:GetClass( ) )
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_rif_sg552.mdl" );
		weapon:SetNWString("weaponclass", "weapon_grenadegun");
		weapon:SetPos( tr.HitPos );
		weapon:SetUpgraded(upgrade)
		weapon:Spawn();
	else
		// wont include energy weapons as dropable since people will drop it to reload it.
		Notify( ply, 4, 3, "You can only drop Approved Weapons!" );
		diddrop = false
	end
	return "";
end
AddChatCommand( "/drop", dropWeapon );

function scanPlayer( ply, args )
	args = Purify(args)
	if args=="" then return "" end
	if( not ply:CanAfford( CfgVars["scancost"] ) ) then
		Notify( ply, 4, 3, "Cannot afford this" );
		return "";
	end
	if !ValidEntity(ply:GetTable().Tower) then
		Notify(ply,4,3,"You must have a Radar Tower to use this command. say /buyradar")
	else
		local userExists = false
		local tower = ply:GetTable().Tower
		if tower:GetTable().Scans<=0 || !tower:IsPowered() then
			Notify(ply,4,3,"Your radar tower is not charged enough to scan or does not have any power.")
		else
			local target = FindPlayer(args)
			if target:GetNWBool("scannered") then
				Notify(ply,4,3,"This person has an Anti-Scanner!")
				Notify(target,4,3,"Someone Attempted to Scan You! Your Scan Blocker has been removed...")
				target:SetNWBool("scannered", false)
				return "";
			end
			if ValidEntity(target) then
				userExists = true
				tower:GetTable().Scans = tower:GetTable().Scans-1
				umsg.Start("RadarScan")
					umsg.Entity(target)
					umsg.Vector(target:GetPos())
					umsg.Short(target:EntIndex())
				umsg.End()
				local effectdata = EffectData()
					effectdata:SetOrigin(target:GetPos())
					effectdata:SetRadius(512)
				util.Effect("scanring", effectdata)
				ply:AddMoney( CfgVars["scancost"] * -1 );
				Notify( ply, 0, 3, "Scanning..." );
				Notify(target,1,3, ply:GetName() .. " has scanned you")

				if tower:GetNWInt("upgrade")>=1 then
					SpyScan(ply,target,false)
				end
				if tower:GetNWInt("upgrade")>=2 then
					ReconScan(ply,target)
				end
			end

			if(!userExists) then
				Notify( ply, 4, 3, "Player not found." );
			end
		end
	end
	return "";
end
AddChatCommand( "/scan", scanPlayer );

function playerMobhit( ply, args )
	args = Purify(args)
	args = string.Explode(" ", args)

		//local useridExists = false
		//for k, v in pairs(player.GetAll()) do
		local v = FindPlayer(args[1])
		if ValidEntity(v) then
			//if(v:Alive()) then
				//if(v:UserID( ) == tonumber(args[1])) then
					//useridExists = true
					if (tonumber(args[2])==nil) then
						Notify( ply, 4, 3, "say /placehit <amount> <Player>")
					elseif( not ply:CanAfford( tonumber(args[2]) ) ) then
						Notify( ply, 4, 3, "Mob hit must be at least $5000!" );
					elseif ( tonumber(args[2])<5000) then
						Notify( ply, 4, 3, "Mob hit must be at least $5000!")
					else
						ply:AddMoney( tonumber(args[2]) * -1 );
						v:SetNWInt("hitlist", v:GetNWInt("hitlist")+math.Round(tonumber(args[2])/2))
					//	Jackpot = Jackpot+math.Round(tonumber(args[2])/2)
						Notify( ply, 0, 3, "Mob hit set for $" .. math.Round(tonumber(args[2])/2) );
						for a, b in pairs(player.GetAll()) do
							if(b:Alive()) then
								b:PrintMessage( HUD_PRINTCENTER, v:Nick() .. " Has had a mob hit placed on them!" )
							end
						end
				//end
			//end
		end

		/*if(useridExists == false) then
			Notify( ply, 4, 3, "UserId does not exist." );
		end*/
	end
	return "";
end
AddChatCommand( "/placehit", playerMobhit );

function BuyPistol( ply, args )
	args = Purify(args)
    if( args == "" ) then return ""; end
	local trace = { }

	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;

	local tr = util.TraceLine( trace );



	if( args == "deagle" ) then
		if( not ply:CanAfford( CfgVars["deaglecost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["deaglecost"] * -1 );
		Notify( ply, 0, 3, "You bought a deagle!" );
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_pist_deagle.mdl" );
		weapon:SetNWString("weaponclass", "weapon_deagle2");
		weapon:SetPos( tr.HitPos );
		weapon:Spawn();
	elseif( args == "fiveseven" ) then
		if( not ply:CanAfford( CfgVars["fivesevencost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["fivesevencost"] * -1 );
		Notify( ply, 0, 3, "You bought a fiveseven!" );
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_pist_fiveseven.mdl" );
		weapon:SetNWString("weaponclass", "weapon_fiveseven2");
		weapon:SetPos( tr.HitPos );
		weapon:Spawn();
	elseif( args == "glock" ) then
		if( not ply:CanAfford( CfgVars["glockcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["glockcost"] * -1 );
		Notify( ply, 0, 3, "You bought a glock!" );
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_pist_glock18.mdl" );
		weapon:SetNWString("weaponclass", "weapon_glock2");
		weapon:SetPos( tr.HitPos );
		weapon:Spawn();
	elseif( args == "p228" ) then
		if( not ply:CanAfford( CfgVars["p228cost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["p228cost"] * -1 );
		Notify( ply, 0, 3, "You wasted your money on a shitty pistol!" );
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_pist_p228.mdl" );
		weapon:SetNWString("weaponclass", "weapon_p2282");
		weapon:SetPos( tr.HitPos );
		weapon:Spawn();
	elseif( args == "mac10" ) then
		if( not ply:CanAfford( CfgVars["mac10pistcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["mac10pistcost"] * -1 );
		Notify( ply, 0, 3, "You bought a machine pistol!" );
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_smg_mac10.mdl" );
		weapon:SetNWString("weaponclass", "weapon_mac102");
		weapon:SetPos( tr.HitPos );
		weapon:Spawn();
	elseif( args == "tmp" ) then
		if( not ply:CanAfford( CfgVars["tmppistcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["tmppistcost"] * -1 );
		Notify( ply, 0, 3, "You bought a silenced machine pistol!" );
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_smg_tmp.mdl" );
		weapon:SetNWString("weaponclass", "weapon_tmp2");
		weapon:SetPos( tr.HitPos );
		weapon:Spawn();
	elseif( args == "usp" ) then
		if( not ply:CanAfford( CfgVars["uspcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["uspcost"] * -1 );
		Notify( ply, 0, 3, "You bought a USP!" );
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_pist_usp.mdl" );
		weapon:SetNWString("weaponclass", "weapon_usp2");
		weapon:SetPos( tr.HitPos );
		weapon:Spawn();
	elseif( args == "elites" || args == "dualies" || args == "baretta" ) then
		if( not ply:CanAfford( CfgVars["elitescost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["elitescost"] * -1 );
		Notify( ply, 0, 3, "You bought elites!" );
		local weapon = ents.CreateEx( "spawned_weapon" );
		weapon:SetModel( "models/weapons/w_pist_elite_dropped.mdl" );
		weapon:SetNWString("weaponclass", "weapon_elites2");
		weapon:SetPos( tr.HitPos );
		weapon:Spawn();
	else
		Notify( ply, 1, 3, "That's not an available weapon." );
	end
	return "";
end
AddChatCommand( "/buypistol", BuyPistol );

function ccBuyPistol(ply,command,args)
	if ply:GetTable().LastBuy+1.5<CurTime() then
		ply:GetTable().LastBuy=CurTime()
		BuyPistol(ply,tostring(args[1]))
	end
end
concommand.Add("buypistol",ccBuyPistol)

function BuyShipment( ply, args )
	args = Purify(args)
    if( args == "" ) then return ""; end
	local trace = { }

	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	local mult=1
	local tr = util.TraceLine( trace );
-- Mac-10
	if( args == "mac10" || args == "mac" ) then
		if( not ply:CanAfford( 1.5*CfgVars["mac10cost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (1.5*CfgVars["mac10cost"]*mult) * -1 );
		Notify( ply, 0, 3, "You bought a Mac-10s!" );
			local weapon = ents.Create( "spawned_shipment" );
			weapon.WeaponModel = ( "models/weapons/w_smg_mac10.mdl" );
			weapon:SetNWString("weaponclass", "weapon_mac102");
			weapon:SetNWString("Contents", "Mac-10 Shipment");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
-- TMP
	elseif( args == "tmp" || args == "TMP" ) then
		if( not ply:CanAfford( 1.5*CfgVars["tmpcost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (1.5*CfgVars["tmpcost"]*mult) * -1 );
		Notify( ply, 0, 3, "You bought a TMPs!" );
			local weapon = ents.Create( "spawned_shipment" );
			weapon.WeaponModel = ( "models/weapons/w_smg_tmp.mdl" );
			weapon:SetNWString("weaponclass", "weapon_tmp2");
			weapon:SetNWString("Contents", "TMP Shipment");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
-- UMP45
	elseif( args == "ump" || args == "ump45" ) then
		if( not ply:CanAfford( 1.5*CfgVars["umpcost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (1.5*CfgVars["umpcost"]*mult) * -1 );
		Notify( ply, 0, 3, "You bought a ump45s!" );
			local weapon = ents.Create( "spawned_shipment" );
			weapon.WeaponModel = ( "models/weapons/w_smg_ump45.mdl" );
			weapon:SetNWString("weaponclass", "weapon_ump452");
			weapon:SetNWString("Contents", "Ump45 Shipment");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
-- M4A1
	elseif( args == "m4" || args == "m16" ) then
		if( not ply:CanAfford( 1.5*CfgVars["m16cost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (1.5*CfgVars["m16cost"]*mult) * -1 );
		Notify( ply, 0, 3, "You bought a M4s!" );
			local weapon = ents.Create( "spawned_shipment" );
			weapon.WeaponModel = ( "models/weapons/w_rif_m4a1.mdl" );
			weapon:SetNWString("weaponclass", "weapon_m42");
			weapon:SetNWString("Contents", "M4A1 Shipment");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
-- Pump Shotgun
	elseif( args == "shotgun" || args == "pumpshotgun" ) then
		if( not ply:CanAfford( 1.5*CfgVars["shotguncost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (1.5*CfgVars["shotguncost"]*mult) * -1 );
		Notify( ply, 0, 3, "You bought a Pump Shotguns!" );
			local weapon = ents.Create( "spawned_shipment" );
			weapon.WeaponModel = ( "models/weapons/w_shot_m3super90.mdl" );
			weapon:SetNWString("weaponclass", "weapon_pumpshotgun2");
			weapon:SetNWString("Contents", "Pump Shotgun Shipment");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
-- MP5
	elseif( args == "mp5" || args == "mp" ) then
		if( not ply:CanAfford( 1.5*CfgVars["mp5cost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (1.5*CfgVars["mp5cost"]*mult) * -1 );
		Notify( ply, 0, 3, "You bought a MP5s!" );
			local weapon = ents.Create( "spawned_shipment" );
			weapon.WeaponModel = ( "models/weapons/w_smg_mp5.mdl" );
			weapon:SetNWString("weaponclass", "weapon_mp52");
			weapon:SetNWString("Contents", "MP5 Shipment");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
-- MP5
	elseif( args == "mp5" || args == "mp" ) then
		if( not ply:CanAfford( 1.5*CfgVars["mp5cost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (1.5*CfgVars["mp5cost"]*mult) * -1 );
		Notify( ply, 0, 3, "You bought a MP5s!" );
			local weapon = ents.Create( "spawned_shipment" );
			weapon.WeaponModel = ( "models/weapons/w_smg_mp5.mdl" );
			weapon:SetNWString("weaponclass", "weapon_mp52");
			weapon:SetNWString("Contents", "MP5 Shipment");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
-- Galil
	elseif( args == "galil" || args == "gal" ) then
		if( not ply:CanAfford( 1.5*CfgVars["galilcost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (1.5*CfgVars["galilcost"]*mult) * -1 );
		Notify( ply, 0, 3, "You bought a Galils!" );
			local weapon = ents.Create( "spawned_shipment" );
			weapon.WeaponModel = ( "models/weapons/w_rif_galil.mdl" );
			weapon:SetNWString("weaponclass", "weapon_galil2");
			weapon:SetNWString("Contents", "Galil Shipment");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
-- AUG
	elseif( args == "aug" || args == "augy" ) then
		if( not ply:CanAfford( 1.5*CfgVars["augcost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (1.5*CfgVars["augcost"]*mult) * -1 );
		Notify( ply, 0, 3, "You bought a AUGs!" );
			local weapon = ents.Create( "spawned_shipment" );
			weapon.WeaponModel = ( "models/weapons/w_rif_aug.mdl" );
			weapon:SetNWString("weaponclass", "weapon_aug2");
			weapon:SetNWString("Contents", "Aug Shipment");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
-- Ak47
	elseif( args == "ak47" || args == "ak" ) then
		if( not ply:CanAfford( 1.5*CfgVars["ak47cost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (1.5*CfgVars["ak47cost"]*mult) * -1 );
		Notify( ply, 0, 3, "You bought a ak47s!" );
			local weapon = ents.Create( "spawned_shipment" );
			weapon.WeaponModel = ( "models/weapons/w_rif_ak47.mdl" );
			weapon:SetNWString("weaponclass", "weapon_ak472");
			weapon:SetNWString("Contents", "Ak-47 Shipment");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
-- Flamethrower
	elseif( args == "flamethrower" || args == "flame" ) then
		if( not ply:CanAfford( 1.5*CfgVars["flamethrowercost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (1.5*CfgVars["flamethrowercost"]*mult) * -1 );
		Notify( ply, 0, 3, "You bought shipment of FlameThowers!" );
			local weapon = ents.Create( "spawned_shipment" );
			weapon.WeaponModel = ( "models/weapons/w_smg1.mdl" );
			weapon:SetNWString("weaponclass", "weapon_flamethrower");
			weapon:SetNWString("Contents", "Flamethrower Shipment");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
-- Sniper
	elseif( args == "sniper" || args == "awp" ) then
		if( not ply:CanAfford( 1.5*CfgVars["snipercost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (1.5*CfgVars["snipercost"]*mult) * -1 );
		Notify( ply, 0, 3, "You bought shipment of Sniper Rifles!" );
			local weapon = ents.Create( "spawned_shipment" );
			weapon.WeaponModel = ( "models/weapons/w_snip_awp.mdl" );
			weapon:SetNWString("weaponclass", "ls_sniper");
			weapon:SetNWString("Contents", "Sniper Shipment");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
-- Auto Shotgun
	elseif( args == "autoshotgun" || args == "noobcannon" || args=="m1014" || args=="xm1014" || args== "autoshotty") then
		if( not ply:CanAfford( 1.5*CfgVars["autoshotguncost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (1.5*CfgVars["autoshotguncost"]*mult) * -1 );
		Notify( ply, 0, 3, "You bought a shipment of m1014s!" );
			local weapon = ents.Create( "spawned_shipment" );
			weapon.WeaponModel = ( "models/weapons/w_shot_xm1014.mdl" );
			weapon:SetNWString("weaponclass", "weapon_autoshotgun2");
			weapon:SetNWString("Contents", "AutoShotgun Shipment");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
-- Auto Sniper
	elseif( args == "autosniper" || args == "autosnipe" || args == "psg1" || args=="g3" || args=="g3sg1") then
		if( not ply:CanAfford( 1.5*CfgVars["autosnipecost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (1.5*CfgVars["autosnipecost"]*mult) * -1 );
		Notify( ply, 0, 3, "You bought a shipment of Automatic Sniper Rifles!" );
			local weapon = ents.Create( "spawned_shipment" );
			weapon.WeaponModel = ( "models/weapons/w_snip_g3sg1.mdl" );
			weapon:SetNWString("weaponclass", "weapon_autosnipe");
			weapon:SetNWString("Contents", "AutoSniper Shipment");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
	else
		Notify( ply, 4, 3, "That's not an available weapon." );
	end

	return "";
end
AddChatCommand( "/buyshipment", BuyShipment );


function BuyWeapon( ply, args )
	args = Purify(args)
    if( args == "" ) then return ""; end
	local trace = { }

	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	local mult=1
	local tr = util.TraceLine( trace );


	if( args == "ak47" || args == "ak" ) then
		if( not ply:CanAfford( CfgVars["ak47cost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (CfgVars["ak47cost"]*.5) * -1 );
		Notify( ply, 0, 3, "You bought a ak47!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_rif_ak47.mdl" );
			weapon:SetNWString("weaponclass", "weapon_ak472");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "aug") then
		if( not ply:CanAfford( CfgVars["augcost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (CfgVars["augcost"]*.5) * -1 );
		Notify( ply, 0, 3, "You bought a aug!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_rif_aug.mdl" );
			weapon:SetNWString("weaponclass", "weapon_aug2");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "flamethrower") then
		if( not ply:CanAfford( CfgVars["flamethrowercost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (CfgVars["flamethrowercost"]*.5) * -1 );
		Notify( ply, 0, 3, "You bought a flamethrower!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_smg1.mdl" );
			weapon:SetNWString("weaponclass", "weapon_flamethrower");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "galil" ) then
		if( not ply:CanAfford( CfgVars["galilcost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( (CfgVars["galilcost"]*.5) * -1 );
		Notify( ply, 0, 3, "You bought a galil!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_rif_galil.mdl" );
			weapon:SetNWString("weaponclass", "weapon_galil2");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "mp5" || args== "mp5navy" ) then
		if( not ply:CanAfford( CfgVars["mp5cost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["mp5cost"]*.5 * -1 );
		Notify( ply, 0, 3, "You bought a mp5!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_smg_mp5.mdl" );
			weapon:SetNWString("weaponclass", "weapon_mp52");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "tmp") then
		if( not ply:CanAfford( CfgVars["tmpcost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["tmpcost"]*.5 * -1 );
		Notify( ply, 0, 3, "You bought a TMP!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_smg_tmp.mdl" );
			weapon:SetNWString("weaponclass", "weapon_tmp2");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "m16" || args == "m4") then
		if( not ply:CanAfford( CfgVars["m16cost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["m16cost"]*.5 * -1 );
		Notify( ply, 0, 3, "You bought a m4!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_rif_m4a1.mdl" );
			weapon:SetNWString("weaponclass", "weapon_m42");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "mac10" ) then
		if( not ply:CanAfford( CfgVars["mac10cost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["mac10cost"]*.5 * -1 );
		Notify( ply, 0, 3, "You bought a mac10!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_smg_mac10.mdl" );
			weapon:SetNWString("weaponclass", "weapon_mac102");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "ump" || args == "ump45" ) then
		if( not ply:CanAfford( CfgVars["umpcost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["umpcost"]*.5* -1 );
		Notify( ply, 0, 3, "You bought a ump45!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_smg_ump45.mdl" );
			weapon:SetNWString("weaponclass", "weapon_ump452");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "shotgun" || args == "pumpshotgun") then
		if( not ply:CanAfford( CfgVars["shotguncost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["shotguncost"]*.5 * -1 );
		Notify( ply, 0, 3, "You bought a shotgun!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_shot_m3super90.mdl" );
			weapon:SetNWString("weaponclass", "weapon_pumpshotgun2");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "autoshotgun" || args == "noobcannon" || args=="m1014" || args=="xm1014" || args== "autoshotty") then
		if( not ply:CanAfford( CfgVars["autoshotguncost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["autoshotguncost"]*.5 * -1 );
		Notify( ply, 0, 3, "You bought a m1014!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_shot_xm1014.mdl" );
			weapon:SetNWString("weaponclass", "weapon_autoshotgun2");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "sniper" || args == "awp") then
		if( not ply:CanAfford( CfgVars["snipercost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["snipercost"]*.5 * -1 );
		Notify( ply, 0, 3, "You bought a sniper rifle!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_snip_awp.mdl" );
			weapon:SetNWString("weaponclass", "ls_sniper");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "autosniper" || args == "autosnipe" || args == "psg1" || args=="g3" || args=="g3sg1") then
		if( not ply:CanAfford( CfgVars["autosnipecost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["autosnipecost"]*.5 * -1 );
		Notify( ply, 0, 3, "You bought a automatic sniper rifles!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_snip_g3sg1.mdl" );
			weapon:SetNWString("weaponclass", "weapon_autosnipe");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "rpg" || args == "rocketlauncher" ) then
		if( not ply:CanAfford( CfgVars["rpgcost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["rpgcost"]*.5 * -1 );
		Notify( ply, 0, 3, "You bought a rocket launcher!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_rocket_launcher.mdl" );
			weapon:SetNWString("weaponclass", "weapon_rocketlauncher");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "para" || args == "50cal" || args == "hmg" ) then
		if( not ply:CanAfford( CfgVars["paracost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["paracost"]*.5 * -1 );
		Notify( ply, 0, 3, "You bought a Para!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_mach_m249para.mdl" );
			weapon:SetNWString("weaponclass", "weapon_50cal2");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "flashbang" || args == "stungrenade" || args == "stun" || args == "flash" ) then
		// it may say flashbang, but these are stun nades now.
		if( not ply:CanAfford( CfgVars["flashbangcost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["flashbangcost"]*.5 * -1 );
		Notify( ply, 0, 3, "You bought a stun grenade!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_eq_flashbang.mdl" );
			weapon:SetNWString("weaponclass", "cse_eq_flashbang");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

	elseif( args == "gasgrenade" || args == "bastardgas" || args=="teargas" || args=="mustardgas" || args =="gas") then
		if( not ply:CanAfford( CfgVars["gasgrenadecost"]*.5 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["gasgrenadecost"]*.5 * -1 );
		Notify( ply, 0, 3, "You bought a gas grenade!" );

			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_eq_smokegrenade.mdl" );
			weapon:SetNWString("weaponclass", "weapon_gasgrenade");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
			weapon:Spawn();

---------------------------LmaoLlama Shipments Start--------------------------------------------------
--Sticky
	elseif( args == "sticky" || args == "stickygrenade") then
		if( not ply:CanAfford( 2000 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( -2000 );
		Notify( ply, 0, 3, "You bought a shipment of Sticky Grenades!" );
		for i=-1, 1, 1 do
			local weapon = ents.Create( "spawned_weapon" );
			weapon:SetModel( "models/Weapons/w_bugbait.mdl" );
			weapon:SetNWString("weaponclass", "weapon_stickgrenade");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (i*25), tr.HitPos.z));
			weapon:Spawn();
		end
--Inced
	elseif( args == "inced" || args == "incediary") then
		if( not ply:CanAfford( 5000 )) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( -5000 );
		Notify( ply, 0, 3, "You bought a shipment of Inced Grenades!" );
		for i=-1, 1, 1 do
			local weapon = ents.Create( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_eq_flashbang.mdl" );
			weapon:SetNWString("weaponclass", "weapon_incedgrenade");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (i*10), tr.HitPos.z));
			weapon:Spawn();
		end
	elseif( args == "doorcharge" || args == "charge") then
		if( not ply:CanAfford( 500 )) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( -500 );
		Notify( ply, 0, 3, "You bought a shipment of Door Charges!" );
		for i=-1, 1, 1 do
			local weapon = ents.Create( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_slam.mdl" );
			weapon:SetNWString("weaponclass", "weapon_mad_charge");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (i*10), tr.HitPos.z));
			weapon:Spawn();
		end
	--c4
	elseif( args == "c4" || args == "c4charge") then
		if( not ply:CanAfford( 10000 )) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( -10000 );
		Notify( ply, 0, 3, "You bought a C4 Explovise!" );
			local weapon = ents.Create( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_c4.mdl" );
			weapon:SetNWString("weaponclass", "weapon_mad_c4");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z));
			weapon:Spawn();
	--c4
---------------------------LmaoLlamaBaseWarsV2/ments End--------------------------------------------------
	elseif( args == "grenade"  || args == "frag" || args == "fraggrenade" ) then
		if( not ply:CanAfford( CfgVars["grenadecost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["grenadecost"]*mult * -1 );
		Notify( ply, 0, 3, "You bought a shipment of grenades!" );
		for i=-1, 1, 1 do
			local weapon = ents.Create( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_eq_fraggrenade.mdl" );
			weapon:SetNWString("weaponclass", "cse_eq_hegrenade");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (i*10), tr.HitPos.z));
			weapon:Spawn();
		end

	elseif( args == "molotov"  || args == "firebomb") then
		Notify( ply, 0, 3, "Molotovs are disabled!" );
--		if( not ply:CanAfford( CfgVars["molotovcost"]*.5 ) ) then
--			Notify( ply, 4, 3, "Cannot afford this" );
--			return "";
--		end
--		ply:AddMoney( -1000 );
--		Notify( ply, 0, 3, "You bought molotovs!" );
--
--			local weapon = ents.CreateEx( "spawned_weapon" );
--			weapon:SetModel( "models/props_junk/garbage_glassbottle003a.mdl" );
--			weapon:SetNWString("weaponclass", "weapon_molotov");
--			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (10), tr.HitPos.z));
--			weapon:Spawn();
--		end
	else
		Notify( ply, 4, 3, "That's not an available weapon." );
	end

	return "";
end
AddChatCommand( "/buyweapon", BuyWeapon );

function ccBuyWeapon(ply,command,args)
	if ply:GetTable().LastBuy+1.5<CurTime() then
		ply:GetTable().LastBuy=CurTime()
		BuyWeapon(ply,tostring(args[1]))
	end
end
concommand.Add("buyweapon",ccBuyWeapon)

function ccBuyShipment(ply,command,args)
	if ply:GetTable().LastBuy+1.5<CurTime() then
		ply:GetTable().LastBuy=CurTime()
		BuyShipment(ply,tostring(args[1]))
	end
end
concommand.Add("buyshipment",ccBuyShipment)

function BuyDrug( ply, args )
	args = Purify(args)
	//if( args == "" ) then return ""; end
	local count = tonumber(args)
	if count==nil then count = 1 end
	if count>CfgVars["maxdruglabs"] || count<1 then count = 1 end
	local trace = { }

	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;

	local tr = util.TraceLine( trace );

	for i=1,count do
		if( not ply:CanAfford( CfgVars["druglabcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxDrug >= CfgVars["maxdruglabs"])then
			Notify( ply, 4, 3, "Max Drug Labs Reached!" );
			return "";
		end
		ply:AddMoney( CfgVars["druglabcost"] * -1 );
		Notify( ply, 0, 3, "You bought a Drug Lab" );
		local druglab = ents.Create( "drug_lab" );

		druglab:SetPos( tr.HitPos+Vector(0,0,i*10));
		druglab.Owner = ply
		druglab:Spawn();
	end
	return "";
end
AddChatCommand( "/buydruglab", BuyDrug );

function BuyMicrowave( ply )
--
--    if( args == "" ) then return ""; end
--	local trace = { }
--
--	trace.start = ply:EyePos();
--	trace.endpos = trace.start + ply:GetAimVector() * 85;
--	trace.filter = ply;
--
--	local tr = util.TraceLine( trace );
--
--		if( not ply:CanAfford( CfgVars["microwavecost"] ) ) then
--			Notify( ply, 4, 3, "Cannot afford this" );
--			return "";
--		end
--		if(ply:GetTable().maxMicrowaves == CfgVars["maxmicrowaves"])then
--			Notify( ply, 4, 3, "Max Microwaves Reached!" );
--			return "";
--		end
--			ply:AddMoney( CfgVars["microwavecost"] * -1 );
--			Notify( ply, 0, 3, "You bought a Microwave" );
--
--			local microwave = ents.Create( "microwave" );
--			microwave:SetNWEntity( "owner", ply )
--			microwave:SetPos( tr.HitPos );
--			microwave:Spawn();
--			return ""
end
AddChatCommand( "/buymicrowave", BuyMicrowave );

function BuyGunlab( ply )
    if( args == "" ) then return ""; end
	local trace = { }

	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;

	local tr = util.TraceLine( trace );

		if( not ply:CanAfford( CfgVars["gunlabcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxgunlabs >= CfgVars["maxgunlabs"])then
			Notify( ply, 4, 3, "Max Gun Labs Reached!" );
			return "";
		end
			ply:AddMoney( CfgVars["gunlabcost"] * -1 );
			Notify( ply, 0, 3, "You bought a Gun Lab" );
			local gunlab = ents.Create( "gunlab" );

			gunlab:SetPos( tr.HitPos + Vector(0,0,64));
			gunlab.Owner = ply
			gunlab:Spawn();
			return "";
end
AddChatCommand( "/buygunlab", BuyGunlab );

function BuyGunvault( ply )
    if( args == "" ) then return ""; end
	local trace = { }

	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;

	local tr = util.TraceLine( trace );

		if( not ply:CanAfford( CfgVars["gunvaultcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxvault >= CfgVars["maxgunvaults"])then
			Notify( ply, 4, 3, "Max Gun Vaults/Pill Boxes Reached!" );
			return "";
		end
		ply:AddMoney( CfgVars["gunvaultcost"] * -1 );
		Notify( ply, 0, 3, "You bought a Gun Vault" );
		local gunlab = ents.Create( "gunvault" );

		gunlab:SetPos( tr.HitPos );
		gunlab.Owner = ply
		gunlab:Spawn();
		return "";
end
AddChatCommand( "/buygunvault", BuyGunvault );

function BuyPillBox( ply )
    if( args == "" ) then return ""; end
	local trace = { }

	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;

	local tr = util.TraceLine( trace );

		if( not ply:CanAfford( CfgVars["pillboxcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxvault >= CfgVars["maxgunvaults"])then
			Notify( ply, 4, 3, "Max Gun Vaults/Pill Boxes Reached!" );
			return "";
		end
		ply:AddMoney( CfgVars["pillboxcost"] * -1 );
		Notify( ply, 0, 3, "You bought a Pill Box" );
		local gunlab = ents.Create( "pillbox" );

		gunlab:SetPos( tr.HitPos+Vector(0,0,40));
		gunlab.Owner = ply
		gunlab:Spawn();
		return "";
end
AddChatCommand( "/buypillbox", BuyPillBox );

----------------------------
--ent_mad_fuel
function BuyIncedAmmo( ply )
    if( args == "" ) then return ""; end
	local trace = { }

	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;

	local tr = util.TraceLine( trace );

		if( not ply:CanAfford( 500 )) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( -500 );
		Notify( ply, 0, 3, "You bought a Fuel Tank" );
		local fuel = ents.Create( "ent_mad_fuel" );
		fuel:SetPos( tr.HitPos+Vector(0,0,40));
		fuel:Spawn();
		return "";
end
AddChatCommand( "/buyfuel", BuyIncedAmmo );




function BuyHealth( ply )
	if( not ply:CanAfford( CfgVars["healthcost"] ) ) then
		Notify( ply, 4, 3, "Cannot afford this" );
		return "";
	end

	ply:AddMoney( CfgVars["healthcost"] * -1 );
	Notify(ply, 0, 3, "You bought a health kit")
	local trace = { }

	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 80;
	trace.filter = ply;

	local tr = util.TraceLine( trace );
	local vehiclespawn = ents.CreateEx( "item_buyhealth" );
	vehiclespawn:SetPos( tr.HitPos + Vector(0, 0, 15));
	vehiclespawn:Spawn();
	return "";
end
AddChatCommand( "/buyhealth", BuyHealth );

function GetHelp( ply, args )
	ply:ConCommand("serverHelp")
end
AddChatCommand( "/help", GetHelp );


function GiveMoney( ply, args )
	args = Purify(args)
    if( args == "" ) then return ""; end

	local trace = ply:GetEyeTrace();

	if( trace.Entity:IsValid() and trace.Entity:IsPlayer() and trace.Entity:GetPos():Distance( ply:GetPos() ) < 150 and trace.Entity:GetNWBool("AFK")==false) then

		local amount = tonumber( args );
		if amount==nil then return "" end
		if( not ply:CanAfford( amount ) ) then

			Notify( ply, 4, 3, "Cannot afford this" );
			return "";

		end
		if  (amount!=math.Round(amount)) then
			Notify(ply, 4, 3, "Must be a whole number" );
			return "";
		end
		trace.Entity:AddMoney( amount );
		ply:AddMoney( amount * -1 );

		Notify( trace.Entity, 2, 4, ply:Nick() .. " has given you " .. amount .. " dollars!" );
		Notify( ply, 0, 4, "Gave " .. trace.Entity:Nick() .. " " .. amount .. " dollars!" );

	else

		Notify( ply, 1, 3, "Must be looking at and be within distance of another player that is not AFK!" );

	end
	return "";
end
AddChatCommand( "/give", GiveMoney );

function DropMoney( ply, args )
	args = Purify(args)
    if( args == "" ) then return ""; end

	local amount = tonumber( args );
	if amount==nil then return "" end
	if( not ply:CanAfford( amount ) ) then

		Notify( ply, 4, 3, "Cannot afford this!" );
		return "";

	end

	if( amount < 10 || amount!=math.Round(amount)) then

		Notify( ply, 4, 4, "Invalid amount of money! Must be atleast 10 dollars!" );
		return "";

	end

	ply:AddMoney( amount * -1 );

	local trace = { }

	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;

	local tr = util.TraceLine( trace );

	local moneybag = ents.Create( "prop_moneybag" );
	moneybag:SetModel( "models/notes.mdl" )
	moneybag:SetPos( tr.HitPos );
	moneybag:Spawn();
	moneybag:SetColor(200,255,200,255)

	moneybag:GetTable().MoneyBag = true;
	moneybag:GetTable().Amount = amount;

	return "";

end
AddChatCommand( "/moneydrop", DropMoney );
AddChatCommand( "/dropmoney", DropMoney );

function GM:PlayerSpawnProp( ply, model )
	ply:ClearAFK()
	if( not self.BaseClass:PlayerSpawnProp( ply, model ) ) then return false; end

	local allowed = false;

	if( ply:GetTable().Arrested ) then return false; end
	if (ply:GetNWBool("shitwelding")) then
		Notify(ply, 4, 3, "You cannot spawn props when people have welded your stuff or have recently bombed you!")
		return false;
	end

		for k, v in pairs( AllowedProps ) do

			if( v == model ) then allowed = true; end

		end

	if( CfgVars["banprops"] == 1 ) then

		for k, v in pairs( BannedProps ) do
			if( string.lower(v) == string.lower(model) ) then return false; end

		end

	end

	if( allowed ) then

		if( CfgVars["proppaying"] == 1 ) then

			if( ply:CanAfford( CfgVars["propcost"] ) ) then

				Notify( ply, 0, 4, "Deducted $" .. CfgVars["propcost"] );
				ply:AddMoney( -CfgVars["propcost"] );

				return true;

			else

				Notify( ply, 4, 4, "Need $" .. CfgVars["propcost"] );
				return false;

			end

		else

			return true;

		end

	end

	return true;

end

local function CanDupe(ply, tr, mode)
	// Msg(mode .. " " .. tostring(ply:GetNWBool("shitwelding")) .. "\n")
	if ply:GetNWBool("shitwelding") then -- mode=="duplicator" &&
		Notify(ply,4,3,"You cannot use toolgun when people have welded your stuff or have recently bombed you!")
		return false
	end
end
hook.Add( "CanTool", "CanDupe", CanDupe )


function GM:SetupMove( ply, move )

	if( ply == nil or not ply:Alive() ) then
		return;
	end
	if ply:IsOnGround() then
		ply:GetTable().Jump2 = false
	end
	if( ply:GetTable().Arrested) then

		ply:SetWalkSpeed(100)
		ply:SetRunSpeed(90)
		return;

	end
	if ( ply:GetTable().Roided) then
		ply:SetWalkSpeed(330-(ply:GetTable().StunDuration)*2)
		ply:SetRunSpeed(550-(ply:GetTable().StunDuration)*2.75)
		return;
	end
	// give gangsters the small speed boost, since cops already get guns AND bigger payday, just to balance the game a little.

end


function GM:ShowSpare1( ply )

	umsg.Start( "ToggleClicker", ply ); umsg.End();

end

function GM:ShowSpare2( ply )

	local trace = ply:GetEyeTrace();

	if( trace.Entity:IsValid() and trace.Entity:IsOwnable() and ply:GetPos():Distance( trace.Entity:GetPos() ) < 115 ) then

		if( trace.Entity:OwnedBy( ply ) ) then
			Notify( ply, 0, 4, "You've unowned this door!" );
			trace.Entity:UnOwn( ply );
			ply:GetTable().Owned[trace.Entity:EntIndex()] = nil;
			ply:GetTable().OwnedNum = ply:GetTable().OwnedNum - 1;
		else

			if( trace.Entity:IsOwned() and not trace.Entity:AllowedToOwn( ply ) ) then

				Notify( ply, 4, 3, "Already owned" );
				return;

			end

			if( not ply:CanAfford( CfgVars["doorcost"] ) ) then

				Notify( ply, 4, 4, "You cannot afford this!" );
				return;

			end

			ply:AddMoney( CfgVars["doorcost"] * -1 );

			Notify( ply, 0, 4, "You've owned this door for " .. CfgVars["doorcost"] .. " bucks!" );

			trace.Entity:Own( ply );

			ply:GetTable().OwnedNum = ply:GetTable().OwnedNum + 1;

			ply:GetTable().Owned[trace.Entity:EntIndex()] = trace.Entity;

		end

	end

end

function GM:KeyPress( ply, code )
	ply:ClearAFK()
	self.BaseClass:KeyPress( ply, code );

	if( code == IN_JUMP && !ply:GetTable().Jump2 && !ply:IsOnGround() && ply:GetTable().DoubleJumped) then
		ply:SetVelocity(ply:GetForward()*150+Vector(0,0,300))
		ply:GetTable().Jump2 = true
	end

	if( code == IN_USE ) then

		local trace = { }

		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 95;
		trace.filter = ply;

		local tr = util.TraceLine( trace );

		if( tr.Entity!=nil and ValidEntity(tr.Entity) and not ply:KeyDown( IN_ATTACK ) ) then

			if( tr.Entity:GetTable().Letter ) then

				umsg.Start( "ShowLetter", ply );
					umsg.Short( tr.Entity:GetTable().type );
					umsg.Vector( tr.Entity:GetPos() );
					umsg.String( tr.Entity:GetTable().content );
				umsg.End();

			end

			if( tr.Entity:GetTable().MoneyBag ) then

				Notify( ply, 2, 4, "You found $" .. tr.Entity:GetTable().Amount );
				ply:AddMoney( tr.Entity:GetTable().Amount );
				ply:ConCommand("play chaching.mp3" )
				tr.Entity:Remove();

			end
			if( tr.Entity:GetTable().ScrapMetal ) then

				Notify( ply, 2, 4, "You found scrap metal worth $" .. tr.Entity:GetTable().Amount );
				ply:AddMoney( tr.Entity:GetTable().Amount );
				ply:ConCommand("play chaching.mp3" )
				tr.Entity:Remove();

			end
		else

			umsg.Start( "KillLetter", ply ); umsg.End();

		end

	end

end


function GM:EntityTakeDamage(ply, inflictor, attacker, damage, dmginfo)
	local ignoredrug = false
	if inflictor:GetClass()=="env_fire" || inflictor:GetClass()=="env_physexplosion" || inflictor:GetClass()=="auto_turret_gun" || inflictor:GetClass()=="weapon_molotov" || inflictor:GetClass()=="weapon_flamethrower" ||inflictor:GetClass()=="weapon_knife2" || inflictor:GetClass()=="weapon_gasgrenade" || inflictor:GetClass()=="weapon_tranqgun" || inflictor:GetClass()=="bigbomb" then
		ignoredrug = true
	end
	local scaler = 1
	if (inflictor:GetClass()=="env_physexplosion" || inflictor:GetClass()=="env_fire") && ValidEntity(inflictor:GetTable().attacker) then
		attacker = inflictor:GetTable().attacker
	end
	if (attacker.Amp == true && !inflictor:IsPlayer() && inflictor:GetClass()!="auto_turret_gun" && inflictor:GetClass()!="weapon_knife2" && inflictor:GetClass()!="weapon_gasgrenade" && inflictor:GetClass()!="weapon_tranqgun" && inflictor:GetClass()!="bigbomb") then
		//dmginfo:ScaleDamage(1.5)
		scaler = scaler*1.4
	end
	// before even applying painkiller or anything, take the max damage it can be, then bounce back part of that.
	// dont bounce knife damage because we dont want to risk bouncing poison
	// dont bounce burning damage because itl get annoying for people to have to burn with other people
	if (ply:GetTable().Mirror == true && attacker!=ply && !inflictor:IsPlayer() && ((dmginfo:IsExplosionDamage() && inflictor:GetClass()!="bigbomb" ) || !ignoredrug)) then
		attacker:TakeDamage(scaler*damage*0.25, ply, ply)
	end
	if (ply.PainKillered == true && attacker:IsPlayer() && attacker!=ply && inflictor:IsPlayer()==false) then
		//dmginfo:ScaleDamage(0.675)
		scaler = scaler*.675
	end

	// fuck the mingebags and thier propfaggotry. only thing that would be left is prop pushing, but at least you dont die and lose your gun.

	if (attacker!=nil && attacker:IsPlayer()==false) then
		local class = attacker:GetClass()
		local donotwant = false
		if class== "entityflame" || inflictor:IsVehicle() || attacker:IsVehicle() || class==v || (class==v && v=="bigbomb" && !dmginfo:IsExplosionDamage()) || (inflictor:IsWorld() && (!dmginfo:IsFallDamage() || ply:GetTable().Knockbacked)) then
			donotwant = true
		end
		for k, v in ipairs(physgunables) do
			if (class==v && v!="bigbomb") || (class==v && v=="bigbomb" && !dmginfo:IsExplosionDamage()) || (inflictor:IsWorld() && !dmginfo:IsFallDamage()) then
				donotwant = true
			end
		end
		if donotwant then
			//dmginfo:ScaleDamage(0)
			scaler = 0
		end
	end

	if (inflictor!=nil && inflictor:IsPlayer()==false) then
		local class = inflictor:GetClass()
		local donotwant = false
		if class== "entityflame" || inflictor:IsVehicle() || attacker:IsVehicle() || class==v || (class==v && v=="bigbomb" && !dmginfo:IsExplosionDamage()) || (inflictor:IsWorld() && (!dmginfo:IsFallDamage() || ply:GetTable().Knockbacked)) then
			donotwant = true
		end
		if donotwant then
			//dmginfo:ScaleDamage(0)
			scaler = 0
		end
	end

	if (ply:IsPlayer() || ply:IsNPC()) && attacker:IsPlayer() && !inflictor:IsPlayer() && !ignoredrug && attacker.Knockbacked && math.Rand(0,1)>.3 then
		local origin = inflictor:GetPos()
		local pos = ply:GetPos()+Vector(0,0,50)
		local yomomma = (pos-origin)
		yomomma:Normalize()
		local force = (dmginfo:GetDamage()*5)
		if force<100 then force = 100 end
		if force>700 then force = 700 end
		local knockdirection = yomomma*force+Vector(0,0,20)
		ply:SetVelocity(knockdirection)
		StunPlayer(ply, math.ceil(dmginfo:GetDamage()*0.1))
	end

	local tdamage = damage*scaler
	if !ply:IsPlayer() then return end
	if (scaler>0 && tdamage>=(ply:Health()+ply:Armor()) && ply:GetTable().Shielded) then
		ply:GetTable().Shieldon = true
		local IDSteam = string.gsub(ply:SteamID(), ":", "")
		timer.Create(IDSteam .. "shield", 0.25, 1, UnShield, ply)
		Notify(ply, 1, 3, "Snipe Shield Activated")
		ply:SetNWBool("shielded", false)
		ply:GetTable().Shielded = false
		// this is here so that fags can stop making bullshit claims about godmode.
		if (attacker:IsPlayer() && attacker!=ply) then
			Notify(attacker, 1, 3, "Target survived using Snipe Shield!")
		end
		dmginfo:SetDamage((ply:Health()+ply:Armor())-1)
		dmginfo:ScaleDamage(1)
	elseif (ply:GetTable().Shieldon) then
		// for that 4th of a second, godmode them just so that this works against shotguns.
		//dmginfo:SetDamage(0)
		scaler = 0
		dmginfo:ScaleDamage(0)
	else
		dmginfo:ScaleDamage(scaler)
	end
	// let leech heal the attacker, but only if they hit a player or npc, and its not poison or returned damage
	if (ply:IsPlayer() || ply:IsNPC()) && attacker:IsPlayer() && !inflictor:IsPlayer() && !ignoredrug && attacker.Leeched && attacker:Health()<attacker:GetMaxHealth() then
		attacker:SetHealth(attacker:Health()+(tdamage*.35))
		if attacker:Health()>attacker:GetMaxHealth() then
			attacker:SetHealth(attacker:GetMaxHealth())
		end
	end
end


function BuyNWeapons( ply, args )
	args = Purify(args)
	args = string.Explode(" ", args)
   	if( args[1] == "" ) then return ""; end
	local trace = { }

	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	local mult=1
	local tr = util.TraceLine( trace );

	if( args == "flashbang" || args == "stungrenade" || args == "stun" || args == "flash" ) then
		// it may say flashbang, but these are stun nades now.
		if( not ply:CanAfford( CfgVars["flashbangcost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["flashbangcost"]*mult * -1 );
		Notify( ply, 0, 3, "You bought a stun grenades!" );
		for i=-1, 1, 1 do
			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_eq_flashbang.mdl" );
			weapon:SetNWString("weaponclass", "cse_eq_flashbang");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (i*10), tr.HitPos.z));
			weapon:Spawn();
		end
	elseif( args == "smoke" || args == "smokegrenade" || args == "gasgrenade" || args == "bastardgas" || args=="teargas" || args=="mustardgas" || args =="gas") then
		if( not ply:CanAfford( CfgVars["gasgrenadecost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["gasgrenadecost"]*mult * -1 );
		Notify( ply, 0, 3, "You bought a gas grenades!" );
		for i=-1, 1, 1 do
			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_eq_smokegrenade.mdl" );
			weapon:SetNWString("weaponclass", "weapon_gasgrenade");
			weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (i*10), tr.HitPos.z));
			weapon:Spawn();
		end
	elseif( args == "grenade"  || args == "frag" || args == "fraggrenade" ) then
		if( not ply:CanAfford( CfgVars["grenadecost"]*mult ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["grenadecost"]*mult * -1 );
		Notify( ply, 0, 3, "You bought a grenades!" );
		for i=-3, 3, 1 do
			local weapon = ents.CreateEx( "spawned_weapon" );
			weapon:SetModel( "models/weapons/w_eq_fraggrenade.mdl" );
			weapon:SetNWString("weaponclass", "cse_eq_hegrenade"); weapon:SetPos( Vector(tr.HitPos.x, tr.HitPos.y + (i*10), tr.HitPos.z)); weapon:Spawn(); end elseif( args == "molotov"  || args == "firebomb") then Notify( ply, 0, 3, "Molotovs are disabled!" ); else Notify( ply, 4, 3, "That's not an available weapon." );
	end

	return "";
end
AddChatCommand( "/buynade", BuyNWeapons );


function ShowMeTheMoney( ply, args )
  if( not ply:IsSuperAdmin() ) then
    Notify( ply, 4, 3, "No Cheating!!!" );
    return "";
  end
  ply:AddMoney( 100000 );
  return "";
end
AddChatCommand( "/showmethemoney", ShowMeTheMoney );



local function SpawnEnt()
	if game.GetMap()=="basewars_ll_downtown" then
		local WelcomeSign = ents.Create( "welcomesign" );
		WelcomeSign:SetPos( Vector(-2795.4063, -2468.0625, -99.5000));
		WelcomeSign:SetAngles(Angle(90, 90, 180))
		WelcomeSign:Spawn();
		WelcomeSign:SetColor(0, 0, 0, 1)
		local phys = WelcomeSign:GetPhysicsObject()

		phys:EnableMotion(false)
	end
end

hook.Add("InitPostEntity", "SpawnEnt", SpawnEnt)
