Extracrap = { }
include("physables.lua")

Jackpot = 1000
Ticketsdrawn = 0

// upgrade command

function Upgrade(ply, args)
	args = Purify(args)
	if( args != "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 150;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	if (!ValidEntity(tr.Entity)) then
		return "";
	end
	local targent = tr.Entity
	if (targent:GetClass()!="auto_turret" && targent:GetClass()!="dispenser" && targent:GetClass()!="supplytable"  && targent:GetClass()!="drugfactory" && targent:GetClass()!="drug_lab" && targent:GetClass()!="still_average" && targent:GetClass()!="money_printer_washingmachine" && targent:GetClass()!="money_printer_bronze" && targent:GetClass()!="money_printer_silver" && targent:GetClass()!="money_printer_gold" && targent:GetClass()!="money_printer_platinum"  && targent:GetClass()!="money_printer_diamond" && targent:GetClass()!="money_printer_nuclear" && targent:GetClass()!="radartower" && targent:GetClass()!="gunfactory" && targent:GetClass()!="weedplant" && targent:GetClass()!="meth_lab" && targent:GetClass()!="meth_lab_stable") then
		Notify(ply,4,3,"This cannot be upgraded.")
		ply:ConCommand( "play buttons/button10.wav" )
		return "" ;
	end
	
	if not (targent.Owner) then
		Notify( ply, 4, 3, "You do not own this Structure!" );
			ply:ConCommand( "play buttons/button10.wav" )
		return "" ;
	end
	local lvl = targent:GetNWInt("upgrade") + 1
	if (lvl>2 and targent:GetClass()!="supplytable" and targent:GetClass()!="drug_lab") then
		Notify(ply, 4, 3, "This is already fully upgraded.")
		return "" ;
	end
	if (lvl>3 and targent:GetClass()=="supplytable") then
		Notify(ply, 4, 3, "This is already fully upgraded.")
		return "" ;
	end
	if (lvl>5 and targent:GetClass()=="drug_lab") then
		Notify(ply, 4, 3, "This is already fully upgraded.")
		return "" ;
	end
	
	local price = 0
	if targent:GetClass()== "auto_turret" then price = CfgVars["turretcost"]
	elseif targent:GetClass()== "dispenser" then price = CfgVars["dispensercost"]
	elseif targent:GetClass()== "drugfactory" then price = CfgVars["drugfactorycost"]
	elseif targent:GetClass()== "drug_lab" then price = CfgVars["druglabcost"]
	elseif targent:GetClass()== "still_average" then price = CfgVars["stillcost"]
	elseif targent:GetClass()== "money_printer_washingmachine" then price = 50000
	elseif targent:GetClass()== "money_printer_bronze" then price = CfgVars["bronzeprintercost"]
	elseif targent:GetClass()== "money_printer_silver" then price = 10000
	elseif targent:GetClass()== "money_printer_gold" then price = 100000
	elseif targent:GetClass()== "money_printer_platinum" then price = 500000
	elseif targent:GetClass()== "money_printer_nuclear" then price = 100000000
	elseif targent:GetClass()== "money_printer_diamond" then price = 1000000
	elseif targent:GetClass()== "meth_lab" then price = CfgVars["methlabcost"]
	elseif targent:GetClass()== "meth_lab_stable" then price = CfgVars["metlabstable"]
	elseif targent:GetClass()== "radartower" then price = CfgVars["radartowercost"]
	elseif targent:GetClass()== "weedplant" then price = CfgVars["weedcost"]
	elseif targent:GetClass()== "gunfactory" then price = CfgVars["gunfactorycost"]
	elseif targent:GetClass()== "supplytable" then price = 1000
	end
	price = price*CfgVars["upgradecost"]
	if (lvl==5) then price = price*16 end
	if (lvl==4) then price = price*8 end
	if (lvl==3) then price = price*4 end
	if (lvl==2) then price = price*2 end

	if (!ply:CanAfford(price)) then
		Notify(ply, 4, 3, "Cannot afford this. Cost is $" .. price)
			ply:ConCommand( "play buttons/button10.wav" )
		return "" ;
	end
	ply:AddMoney(price*-1)
	Notify( ply, 0, 3, "Applying level " .. lvl .. " upgrade.")
	targent:SetNWInt("upgrade", lvl)
		ply:ConCommand( "play buttons/button4.wav" )
	return "";
end
AddChatCommand( "/upgrade", Upgrade );

// refinery

function BuyRefinery( ply )
    if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
		if( not ply:CanAfford( CfgVars["drugfactorycost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxdrugfactory >= CfgVars["maxdrugfactory"])then
			Notify( ply, 4, 3, "Max Drug Refineries Reached!" );
			return "";
		end
		ply:AddMoney( CfgVars["drugfactorycost"] * -1 );
		Notify( ply, 0, 3, "You bought a Drug Refinery" );
		local gunlab = ents.Create( "drugfactory" );
		 
		gunlab.Owner = ply
		gunlab:SetPos( tr.HitPos+Vector(0,0,40));
		gunlab:Spawn();
		return "";
end
AddChatCommand( "/buyrefinery", BuyRefinery );
AddChatCommand( "/buydrugfactory", BuyRefinery );
AddChatCommand( "/buydrugrefinery", BuyRefinery );

--Treasure Chest
function BuyMoneyVault( ply )
    if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
		if( not ply:CanAfford( 500 ) ) then
			Notify( ply, 4, 3, "Cannot afford this Structure." );
			return "";
		end
		if(ply:GetTable().maxMoneyVault >= 1)then
			Notify( ply, 4, 3, "You already own a Money Vault!" );
			return "";
		end
		ply:AddMoney( CfgVars["drugfactorycost"] * -1 );
		Notify( ply, 0, 3, "You bought a Money Vault!" );
		local gunlab = ents.Create( "moneyvault" );
		 
		gunlab:SetPos( tr.HitPos+Vector(0,0,40));
		gunlab.Owner = ply
		gunlab:Spawn();
		return "";
end
AddChatCommand( "/buymoneyvault", BuyMoneyVault );


// gunfactory

function BuyGunFactory( ply )
    if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		
	if( not ply:CanAfford( CfgVars["gunfactorycost"] ) ) then
		Notify( ply, 4, 3, "Cannot afford this" );
		return "";
	end
	if(ply:GetTable().maxgunfactory >= CfgVars["maxgunfactory"])then
		Notify( ply, 4, 3, "Max Gun Factories Reached!" );
		return "";
	end
	ply:AddMoney( CfgVars["gunfactorycost"] * -1 );
	Notify( ply, 0, 3, "You bought a Gun Factory" );
	local gunlab = ents.Create( "gunfactory" );
	 
	gunlab.Owner = ply
	gunlab:SetPos( tr.HitPos+Vector(0,0,10));
	gunlab:Spawn();
	return "";
end
AddChatCommand( "/buygunfactory", BuyGunFactory );
AddChatCommand( "/buyfactory", BuyGunFactory );

// radar tower

function BuyTower( ply )
    if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	if( not ply:CanAfford( CfgVars["radartowercost"] ) ) then
		Notify( ply, 4, 3, "Cannot afford this" );
		return "";
	end
	if(ply:GetTable().maxtower >= 1)then
		Notify( ply, 4, 3, "You already have a Radar Tower!" );
		return "";
	end
	ply:AddMoney( CfgVars["radartowercost"] * -1 );
	Notify( ply, 0, 3, "You bought a Radar Tower" );
	local gunlab = ents.Create( "radartower" );
	 
	gunlab.Owner = ply
	gunlab:SetPos( tr.HitPos+Vector(0,0,10));
	gunlab:Spawn();
	return "";
end
AddChatCommand( "/buytower", BuyTower );
AddChatCommand( "/buyradar", BuyTower );

function BuySupplyTable( ply )
    if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	if( not ply:CanAfford( 1000 )) then
		Notify( ply, 4, 3, "Cannot afford this!" );
		return "";
	end
	if(ply:GetTable().maxsupplytable >= 1)then
		Notify( ply, 4, 3, "You already have a Supply Table!" );
		return "";
	end
	ply:AddMoney( -1000 );
	Notify( ply, 0, 3, "You bought a Supply Table" );
	local gunlab = ents.Create( "supplytable" );
	 
	gunlab:SetPos( tr.HitPos+Vector(0,0,10));
	gunlab.Owner = ply
	gunlab:Spawn();
	return "";
end
AddChatCommand( "/buysupplytable", BuySupplyTable );
AddChatCommand( "/buysupplycabinet", BuySupplyTable );

// power plant

function BuyGenerator( ply )
    if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		
		if( not ply:CanAfford( CfgVars["generatorcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxgenerator >= CfgVars["maxgenerator"])then
			Notify( ply, 4, 3, "Max Power Plants Reached!" );
			return "";
		end
		ply:AddMoney( CfgVars["generatorcost"] * -1 );
		Notify( ply, 0, 3, "You bought a Power Plant" );
		local gunlab = ents.Create( "powerplant" );
		 
		gunlab:SetPos( tr.HitPos+Vector(0,0,10));
		gunlab.Owner = ply
		gunlab:Spawn();
		return "";
end
AddChatCommand( "/buypowerplant", BuyGenerator );
AddChatCommand( "/buygenerator", BuyGenerator );

function BuySuperGenerator( ply )
			Notify( ply, 4, 3, "Super Generator has been disabled!" );

    if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		
		if( not ply:CanAfford( CfgVars["generatorcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxgenerator >= CfgVars["maxgenerator"])then
			Notify( ply, 4, 3, "Max Super Power Plants Reached!" );
			return "";
		end
		ply:AddMoney( CfgVars["generatorcost"] * -1 );
		Notify( ply, 0, 3, "You bought a Super Power Plant" );
		local gunlab = ents.Create( "superpowerplant" );
		 
		gunlab:SetPos( tr.HitPos+Vector(0,0,10));
		gunlab.Owner = ply
		gunlab:Spawn();
		return "";
end
AddChatCommand( "/buysuperpowerplant", BuySuperGenerator );
AddChatCommand( "/buysupergenerator", BuySuperGenerator );

// Big Bomb

function BuyBomb( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	if( not ply:CanAfford( CfgVars["bigbombcost"] ) ) then
		Notify( ply, 4, 3, "Cannot afford this!" );
		return "";
	end
		if(ply:GetTable().maxBigBombs >= CfgVars["bigbombmax"])then
			Notify( ply, 4, 3, "Max Big Bombs Reached!" );
			return "";
		end
	ply:AddMoney( CfgVars["bigbombcost"] * -1 );
	Notify( ply, 0, 3, "You bought the Big Bomb." );
	local Bigbomb = ents.Create( "bigbomb" );
	Bigbomb:SetPos( tr.HitPos + tr.HitNormal*15);
	Bigbomb.Owner = ply
	Bigbomb:Spawn();
	Bigbomb:Activate();
	return "";
end
AddChatCommand( "/buybomb", BuyBomb );

// tranquilizer dart gun

// pipe bomb

function BuyPBomb( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	if( not ply:CanAfford( CfgVars["pipebombcost"] ) ) then
		Notify( ply, 4, 3, "Cannot afford this" );
		return "";
	end
	ply:AddMoney( CfgVars["pipebombcost"] * -1 );
	Notify( ply, 0, 3, "You bought pipe bombs" );
	local vehiclespawn = ents.CreateEx( "spawned_weapon" );
	vehiclespawn:SetModel( "models/props_lab/pipesystem03b.mdl" );
	vehiclespawn:SetNWString("weaponclass", "weapon_pipebomb");
	vehiclespawn:SetPos( tr.HitPos + tr.HitNormal*15);
	vehiclespawn.Owner = ply
	vehiclespawn:Spawn();
	vehiclespawn:Activate();
	return "";
end
AddChatCommand( "/buypipebomb", BuyPBomb );

// buyknife

function BuyKnife( ply )
		if ( ply:GetTable().Arrested ) then
			Notify( ply, 4, 3, "You can't buy a knife while arrested!" );
			return "";
		end
		if( not ply:CanAfford( CfgVars["knifecost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["knifecost"] * -1 );
		Notify( ply, 0, 3, "You bought a knife" );
		
		ply:Give("weapon_knife2")
		return "";
end
AddChatCommand( "/buyknife", BuyKnife );

// buylockpick

function BuyLockPick( ply )
		if ( ply:GetTable().Arrested ) then
			Notify( ply, 4, 3, "You can't buy a lockpick while arrested!" );
			return "";
		end
		if( not ply:CanAfford( CfgVars["lockpickcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["lockpickcost"] * -1 );
		Notify( ply, 0, 3, "You bought a lockpick" );
		
		ply:Give("lockpick")
		return "";
end
AddChatCommand( "/buylockpick", BuyLockPick );

// Teh weld0r

function BuyWelder( ply )
		if (CfgVars["allowwelder"] == 0) then
			Notify( ply, 4, 3, "Welder has been disabled!");
			return "";
		end
		if ( ply:GetTable().Arrested ) then
			Notify( ply, 4, 3, "You can't buy a welder while arrested!" );
			return "";
		end
		if( not ply:CanAfford( CfgVars["weldercost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["weldercost"] * -1 );
		Notify( ply, 0, 3, "You bought a blowtorch/welder" );
		
		ply:Give("weapon_welder")
		return "";
end
AddChatCommand( "/buywelder", BuyWelder );
AddChatCommand( "/buyblowtorch", BuyWelder );

// buy a sentry turret

function BuyTurret( ply )
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 150;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (CfgVars["allowturrets"] == 0) then
			Notify( ply, 4, 3, "Sentry turrets have been disabled!");
			return "";
		end
		if (not tr.HitWorld) then
			Notify( ply, 4, 3, "Please look at the ground to spawn sentry turret" );
			return "";
		end
		if ( ply:GetTable().Arrested ) then
			Notify( ply, 4, 3, "You can't buy a sentry turret while arrested!" );
			return "";
		end
		if( not ply:CanAfford( CfgVars["turretcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxturret >= CfgVars["turretmax"])then
			Notify( ply, 4, 3, "Max sentry turrets Reached!" );
			return "";
		end
		local SpawnPos = tr.HitPos + tr.HitNormal * 20
		local SpawnAng = tr.HitNormal:Angle()
		for k, v in pairs( ents.FindInSphere(SpawnPos, 1250)) do
			if (v:GetClass() == "info_player_deathmatch" || v:GetClass() == "info_player_rebel" || v:GetClass() == "gmod_player_start" || v:GetClass() == "info_player_start" || v:GetClass() == "info_player_allies" || v:GetClass() == "info_player_axis" || v:GetClass() == "info_player_counterterrorist" || v:GetClass() == "info_player_terrorist") then
				Notify( ply, 4, 3, "Cannot create sentry turret near a spawn point!" );
				return "" ;
			end
		end
		ply:AddMoney( CfgVars["turretcost"] * -1 );
		Notify( ply, 0, 3, "You bought a Sentry turret" );
		
		local ent = ents.Create( "auto_turret" )
		ent:SetPos( SpawnPos + (tr.HitNormal*-3) )
		ent:SetAngles( SpawnAng + Angle(90, 0, 0) )
 
		ent.Owner = ply
		ent:SetNWString( "ally" , "")
		ent:SetNWString( "jobally", "")
		ent:SetNWString( "enemytarget", "")
		ent:SetNWBool( "hatetarget", false)

		ent:Spawn()
		ent:Activate()
		local head = ents.Create( "auto_turret_gun" )
		head:SetPos( SpawnPos + (tr.HitNormal*18) )
		head:SetAngles( SpawnAng + Angle(90, 0, 0) )
		head:Spawn()
		head:Activate()
		head:SetParent(ent)
		head.Body = ent
		ent.Head = head
		head:SetOwner(ply)
		return "";
end
AddChatCommand( "/buyturret", BuyTurret );

// buy a dispenser

function BuyDispenser( ply )
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 150;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (CfgVars["allowdispensers"] == 0) then
			Notify( ply, 4, 3, "Ammo dispensers have been disabled!");
			return "";
		end
		if ( ply:GetTable().Arrested ) then
			Notify( ply, 4, 3, "You can't buy an ammo dispenser while arrested!" );
			return "";
		end
		if( not ply:CanAfford( CfgVars["dispensercost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxdispensers >= CfgVars["dispensermax"])then
			Notify( ply, 4, 3, "Max dispensers Reached!" );
			return "";
		end
		local SpawnPos = tr.HitPos + tr.HitNormal * 20
		ply:AddMoney( CfgVars["dispensercost"] * -1 );
		Notify( ply, 0, 3, "You bought an ammo dispenser" );
		
		local ent = ents.Create( "dispenser" )
		ent:SetPos( SpawnPos + Vector(0,0,30) )
 
		ent.Owner = ply
		ent:Spawn()
		ent:Activate()
		return "";
end
AddChatCommand( "/buydispenser", BuyDispenser );

// buy a methlab

function BuyMethlab( ply,args )
	args = Purify(args)
	local count = tonumber(args)
	if count==nil then count = 1 end
	if count>CfgVars["maxmethlab"] || count<1 then count = 1 end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 150;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	if ( ply:GetTable().Arrested ) then
		Notify( ply, 4, 3, "You can't buy a methlab while arrested!" );
		return "";
	end
	for i=1,count do
		if( not ply:CanAfford( CfgVars["methlabcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxmethlab >= CfgVars["maxmethlab"])then
			Notify( ply, 4, 3, "Max methlabs Reached!" );
			return "";
		end
		local SpawnPos = tr.HitPos + tr.HitNormal * 20
		ply:AddMoney( CfgVars["methlabcost"] * -1 );
		Notify( ply, 0, 3, "You bought a meth lab. Good luck!" );
		
		local ent = ents.Create( "meth_lab" )
		ent:SetPos( SpawnPos + Vector(0,0,10) )
 
		ent.Owner = ply
		ent:Spawn()
		ent:SetColor(255, 255, 255, 255)
		ent:Activate()
	end
	return "";
end
AddChatCommand( "/buymethlab", BuyMethlab );
----------------Stable Methlab
function BuyStableMethLab( ply )
	args = Purify(args)
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		
		if( not ply:CanAfford( CfgVars["metlabstable"] )) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxstablemethlab >= CfgVars["maxstablemethlab"])then
			Notify( ply, 4, 3, "Max Stable Meth Labs Reached!" );
			return "";
		end
		ply:AddMoney( -CfgVars["metlabstable"] );
		Notify( ply, 0, 3, "You bought a Stable Meth Labs" );
		local druglab = ents.Create( "meth_lab_stable" );
 
		druglab.Owner = ply
		druglab:SetPos( tr.HitPos + tr.HitNormal*148);
		druglab:Spawn();

	return "";
end
AddChatCommand( "/buystablemethlab", BuyStableMethLab );

// buy a plant

function BuyPlant( ply,args )
--	args = Purify(args)
--	local count = tonumber(args)
--	if count==nil then count = 1 end
--	if count>CfgVars["maxweed"] || count<1 then count = 1 end
--	local trace = { }
--	
--	trace.start = ply:EyePos();
--	trace.endpos = trace.start + ply:GetAimVector() * 150;
--	trace.filter = ply;
--	
--	local tr = util.TraceLine( trace );
--		if ( ply:GetTable().Arrested ) then
--			Notify( ply, 4, 3, "You can't buy a plant while arrested!" );
--			return "";
--		end
--	for i=1,count do
--		if( not ply:CanAfford( CfgVars["weedcost"] ) ) then
--			Notify( ply, 4, 3, "Cannot afford this" );
--			return "";
--		end
--		if(ply:GetTable().maxweed >= CfgVars["maxweed"])then
--			Notify( ply, 4, 3, "Max plants Reached!" );
--			return "";
--		end
--		local SpawnPos = tr.HitPos + tr.HitNormal * 20
--		ply:AddMoney( CfgVars["weedcost"] * -1 );
--		Notify( ply, 0, 3, "You bought a plant!" );
--		
--		local ent = ents.Create( "weedplant" )
--		ent:SetPos( SpawnPos + Vector(0,0,20) )
-- 
--		ent:Spawn()
--		ent:Activate()
--		if (math.Rand(0,1)>.75) then
--			ent:Worthless()
--			Notify( ply, 1, 3, "unluckily for you, it's hemp. You might as well destroy it.")
--		end
--	end
--	return "";
end
AddChatCommand( "/buyplant", BuyPlant );
AddChatCommand( "/buyweed", BuyPlant );
AddChatCommand( "/buyweedplant", BuyPlant );

function BuySpawn( ply )
    
    if( args == "" ) then return ""; end
    	local trace = { }
    		trace.start = ply:GetPos()+Vector(0,0,1)
		trace.endpos = trace.start+Vector(0,0,90)
		trace.filter = ply
	trace = util.TraceLine(trace)
	if( trace.Fraction<1 ) then
            Notify( ply, 4, 3, "Need more room" );
            return "";
        end
        if( not ply:CanAfford( CfgVars["spawncost"] ) ) then
            Notify( ply, 4, 3, "Cannot afford this" );
            return "";
        end
	if(!ply:Alive())then
            Notify( ply, 4, 3, "Dead men buy no spawn points.");
            return "";
        end
	if ValidEntity(ply:GetTable().Spawnpoint) then
		ply:GetTable().Spawnpoint:Remove()
		Notify(ply,1,3, "Destroyed old spawnpoint to create this one.")
	end
        ply:AddMoney( CfgVars["spawncost"] * -1 );
        Notify( ply, 0, 3, "You bought a spawn point!" );
        local spawnpoint = ents.CreateEx( "spawnpoint" );
		spawnpoint.Owner = ply
        spawnpoint:SetPos( ply:GetPos());
		spawnpoint:SetColor(255, 255, 255, 254)
	ply:SetPos(ply:GetPos()+Vector(0,0,3))
--	spawnpoint:SetAngles(Angle(0, 0, 0))
        spawnpoint:Spawn();
    return "";
end
AddChatCommand( "/buyspawnpoint", BuySpawn );

function AllyTurret(ply, args)
	Notify( ply, 1, 3, "Use the LmaoLlamaBaseWarsV2 Allies menu instead of this")
	return "";
end
//AddChatCommand( "/setally", AllyTurret );
//AddChatCommand( "/addally", AllyTurret );

function UnAllyTurret(ply, args)
	Notify( ply, 1, 3, "Use the LmaoLlamaBaseWarsV2 Allies menu instead of this")
	return""
end
AddChatCommand( "/clearally", UnAllyTurret );
//AddChatCommand( "/removeally", UnAllyTurret );
//AddChatCommand( "/unsetally", UnAllyTurret );

function JobAllyTurret(ply, args)
	Notify( ply, 1, 3, "Use the LmaoLlamaBaseWarsV2 Allies menu instead of this")
	return""
end
//AddChatCommand( "/setjobally", JobAllyTurret );

function TargetTurret(ply, args)
	args = Purify(args)
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 150;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	local targent = tr.Entity
	if (targent:GetClass()!="auto_turret") then
		return "" ;
	end
	if (targent.Owner) then
		Notify( ply, 4, 3, "This is not your turret!" );
		return "" ;
	end
	Notify( ply, 0, 3, "Set turret target string to " .. args)
	targent:SetNWString("enemytarget", args)
	return "" ;
end
//AddChatCommand( "/settarget", TargetTurret );

// armor related shit.

function BuyArmor( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (CfgVars["hltvproxywashere"] == 0) then
			Notify( ply, 4, 3, "BuyArmor has been disabled!");
			return "";
		end
		if( not ply:CanAfford( CfgVars["armorcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["armorcost"] * -1 );
		Notify( ply, 0, 3, "You bought some armor" );
			local vehiclespawn = ents.CreateEx( "item_armor" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 25, 15));
			vehiclespawn:Spawn();
	return "";
end
AddChatCommand( "/buyarmor", BuyArmor );

// helmet related shit.

function BuyHelmet( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( 250 ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( -250 );
		Notify( ply, 0, 3, "You bought a helmet" );
			local vehiclespawn = ents.CreateEx( "item_helmet" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 25, 15));
			vehiclespawn:Spawn();
	return "";
end
AddChatCommand( "/buyhelmet", BuyHelmet );

// toolkit

function BuyToolKit( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( CfgVars["toolkitcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["toolkitcost"] * -1 );
		Notify( ply, 0, 3, "You bought toolkits" );
			local vehiclespawn = ents.CreateEx( "item_toolkit" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 20, 10));
			vehiclespawn:Spawn();
	return "";
end
AddChatCommand( "/buytoolkit", BuyToolKit );

// scanner

function BuyScanner( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( CfgVars["scannercost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["scannercost"] * -1 );
		Notify( ply, 0, 3, "You bought a Scan Blocker" );
			local vehiclespawn = ents.CreateEx( "item_scanner" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 20, 10));
			vehiclespawn:Spawn();
	return "";
end
AddChatCommand( "/buyscanner", BuyScanner );

// snipe shield

function BuyShield( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (CfgVars["allowsteroids"] == 0) then
			Notify( ply, 4, 3, "BuyShield has been disabled!");
			return "";
		end
		if( not ply:CanAfford( CfgVars["shieldcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["shieldcost"] * -1 );
		Notify( ply, 0, 3, "You bought a snipe shield." );
			local vehiclespawn = ents.CreateEx( "item_snipeshield" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 20, 10));
			vehiclespawn:Spawn();
	return "";
end
AddChatCommand( "/buyshield", BuyShield );


// steroid 

function BuyBatchSteroid( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (4 * CfgVars["allowsteroids"] == 0) then
			Notify( ply, 4, 3, "BuyBatchSteroids has been disabled!");
			return "";
		end
		if( not ply:CanAfford( 4 * CfgVars["steroidcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["steroidcost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of steroids" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_steroid" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchsteroids", BuyBatchSteroid );

// doublejump 

function BuyBatchDoubleJump( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( 4 * CfgVars["doublejumpcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["doublejumpcost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of double jump" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_doublejump" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchdoublejump", BuyBatchDoubleJump );

// adrenaline 

function BuyBatchAdrenaline( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( 4 * CfgVars["adrenalinecost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["adrenalinecost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of adrenaline" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_adrenaline" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchadrenaline", BuyBatchAdrenaline );

// knockback 

function BuyBatchKnockback( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( 4 * CfgVars["knockbackcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["knockbackcost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of knockback" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_knockback" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchknockback", BuyBatchKnockback );

// armorpiercer

function BuyBatchArmorpiercer( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( 4 * CfgVars["armorpiercercost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["armorpiercercost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of armorpiercer" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_armorpiercer" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchapiercer", BuyBatchArmorpiercer );
AddChatCommand( "/buybatchpiercer", BuyBatchArmorpiercer );
AddChatCommand( "/buybatcharmorpiercer", BuyBatchArmorpiercer );

// shockwave 

function BuyBatchShockWave( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( 4 * CfgVars["shockwavecost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["shockwavecost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of shock wave" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_shockwave" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchshockwave", BuyBatchShockWave );

// leech 

function BuyBatchLeech( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( 4 * CfgVars["leechcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["leechcost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of leech" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_leech" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchleech", BuyBatchLeech );

// double tap 

function BuyBatchDoubleTap( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( 4 * CfgVars["doubletapcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["doubletapcost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of double tap" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_doubletap" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchdoubletap", BuyBatchDoubleTap );

// reflect 

function BuyBatchReflect( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (4 * CfgVars["allowreflect"] == 0) then
			Notify( ply, 4, 3, "BuyBatchReflect has been disabled!");
			return "";
		end
		if( not ply:CanAfford( 4 * CfgVars["reflectcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["reflectcost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of reflect" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_reflect" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchreflect", BuyBatchReflect );

// focus 

function BuyBatchFocus( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (4 * CfgVars["allowfocus"] == 0) then
			Notify( ply, 4, 3, "BuyBatchFocus has been disabled!");
			return "";
		end
		if( not ply:CanAfford( 4 * CfgVars["focuscost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["focuscost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of focus" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_focus" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchfocus", BuyBatchFocus );

// antidote 

function BuyBatchAntidote( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (4 * CfgVars["allowantidote"] == 0) then
			Notify( ply, 4, 3, "BuyBatchAntidote has been disabled!");
			return "";
		end
		if( not ply:CanAfford( 4 * CfgVars["antidotecost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["antidotecost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of antidote" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_antidote" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchantidote", BuyBatchAntidote );

// Amplifier 

function BuyBatchAmp( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (4 * CfgVars["allowamp"] == 0) then
			Notify( ply, 4, 3, "BuyBatchAmplifier has been disabled!");
			return "";
		end
		if( not ply:CanAfford( 4 * CfgVars["ampcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["ampcost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of amplifier" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_amp" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchamp", BuyBatchAmp );

// pain killer 
function BuyBatchPainKiller( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (4 * CfgVars["allowpainkiller"] == 0) then
			Notify( ply, 4, 3, "BuyBatchPainKiller has been disabled!");
			return "";
		end
		if( not ply:CanAfford( 4 * CfgVars["painkillercost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["painkillercost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of pain killers" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_painkiller" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchpainkiller", BuyBatchPainKiller );
AddChatCommand( "/buybatchpainkillers", BuyBatchPainKiller );

// magic bullet 
function BuyBatchMagicBullet( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( 4 * CfgVars["magicbulletcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["magicbulletcost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of magic bullet" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_magicbullet" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchmagicbullet", BuyBatchMagicBullet );
AddChatCommand( "/buybatchmb", BuyBatchMagicBullet );

// regeneration 

function BuyBatchRegen( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (4 * CfgVars["allowregen"] == 0) then
			Notify( ply, 4, 3, "BuyBatchRegen has been disabled!");
			return "";
		end
		if( not ply:CanAfford( 4 * CfgVars["regencost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( 4 * CfgVars["regencost"] * -1 );
		Notify( ply, 0, 3, "You bought a batch of regeneration" );
		for i=-2, 2, 1 do 
			local vehiclespawn = ents.CreateEx( "item_regen" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, i*12, 15));
			vehiclespawn:Spawn();
		end
	return "";
end
AddChatCommand( "/buybatchregen", BuyBatchRegen );

----------------------End of Batch
// steroid 

function BuySteroid( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (CfgVars["allowsteroids"] == 0) then
			Notify( ply, 4, 3, "BuySteroids has been disabled!");
			return "";
		end
		if( not ply:CanAfford( CfgVars["steroidcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["steroidcost"] * -1 );
		Notify( ply, 0, 3, "You bought steroids" );

			local vehiclespawn = ents.CreateEx( "item_steroid" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buysteroids", BuySteroid );

// doublejump 

function BuyDoubleJump( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( CfgVars["doublejumpcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["doublejumpcost"] * -1 );
		Notify( ply, 0, 3, "You bought double jump" );

			local vehiclespawn = ents.CreateEx( "item_doublejump" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buydoublejump", BuyDoubleJump );

// adrenaline 

function BuyAdrenaline( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( CfgVars["adrenalinecost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["adrenalinecost"] * -1 );
		Notify( ply, 0, 3, "You bought adrenaline" );

			local vehiclespawn = ents.CreateEx( "item_adrenaline" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buyadrenaline", BuyAdrenaline );

// knockback 

function BuyKnockback( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( CfgVars["knockbackcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["knockbackcost"] * -1 );
		Notify( ply, 0, 3, "You bought knockback" );

			local vehiclespawn = ents.CreateEx( "item_knockback" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buyknockback", BuyKnockback );

// armorpiercer

function BuyArmorpiercer( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( CfgVars["armorpiercercost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["armorpiercercost"] * -1 );
		Notify( ply, 0, 3, "You bought armorpiercer" );

			local vehiclespawn = ents.CreateEx( "item_armorpiercer" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buyapiercer", BuyArmorpiercer );
AddChatCommand( "/buypiercer", BuyArmorpiercer );
AddChatCommand( "/buyarmorpiercer", BuyArmorpiercer );

// shockwave 

function BuyShockWave( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( CfgVars["shockwavecost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["shockwavecost"] * -1 );
		Notify( ply, 0, 3, "You bought shock wave" );

			local vehiclespawn = ents.CreateEx( "item_shockwave" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buyshockwave", BuyShockWave );

// leech 

function BuyLeech( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( CfgVars["leechcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["leechcost"] * -1 );
		Notify( ply, 0, 3, "You bought leech" );

			local vehiclespawn = ents.CreateEx( "item_leech" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buyleech", BuyLeech );

// double tap 

function BuyDoubleTap( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( CfgVars["doubletapcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["doubletapcost"] * -1 );
		Notify( ply, 0, 3, "You bought double tap" );

			local vehiclespawn = ents.CreateEx( "item_doubletap" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buydoubletap", BuyDoubleTap );

// reflect 

function BuyReflect( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (CfgVars["allowreflect"] == 0) then
			Notify( ply, 4, 3, "BuyReflect has been disabled!");
			return "";
		end
		if( not ply:CanAfford( CfgVars["reflectcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["reflectcost"] * -1 );
		Notify( ply, 0, 3, "You bought reflect" );

			local vehiclespawn = ents.CreateEx( "item_reflect" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buyreflect", BuyReflect );

// focus 

function BuyFocus( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (CfgVars["allowfocus"] == 0) then
			Notify( ply, 4, 3, "BuyFocus has been disabled!");
			return "";
		end
		if( not ply:CanAfford( CfgVars["focuscost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["focuscost"] * -1 );
		Notify( ply, 0, 3, "You bought focus" );

			local vehiclespawn = ents.CreateEx( "item_focus" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buyfocus", BuyFocus );

// antidote 

function BuyAntidote( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (CfgVars["allowantidote"] == 0) then
			Notify( ply, 4, 3, "BuyAntidote has been disabled!");
			return "";
		end
		if( not ply:CanAfford( CfgVars["antidotecost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["antidotecost"] * -1 );
		Notify( ply, 0, 3, "You bought antidote" );

			local vehiclespawn = ents.CreateEx( "item_antidote" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buyantidote", BuyAntidote );

// Amplifier 

function BuyAmp( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (CfgVars["allowamp"] == 0) then
			Notify( ply, 4, 3, "BuyAmplifier has been disabled!");
			return "";
		end
		if( not ply:CanAfford( CfgVars["ampcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["ampcost"] * -1 );
		Notify( ply, 0, 3, "You bought amplifier" );

			local vehiclespawn = ents.CreateEx( "item_amp" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buyamp", BuyAmp );

// pain killer 
function BuyPainKiller( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (CfgVars["allowpainkiller"] == 0) then
			Notify( ply, 4, 3, "BuyPainKiller has been disabled!");
			return "";
		end
		if( not ply:CanAfford( CfgVars["painkillercost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["painkillercost"] * -1 );
		Notify( ply, 0, 3, "You bought pain killers" );

			local vehiclespawn = ents.CreateEx( "item_painkiller" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buypainkiller", BuyPainKiller );
AddChatCommand( "/buypainkillers", BuyPainKiller );

// magic bullet 
function BuyMagicBullet( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if( not ply:CanAfford( CfgVars["magicbulletcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["magicbulletcost"] * -1 );
		Notify( ply, 0, 3, "You bought magic bullet" );

			local vehiclespawn = ents.CreateEx( "item_magicbullet" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buymagicbullet", BuyMagicBullet );
AddChatCommand( "/buymb", BuyMagicBullet );

// regeneration 

function BuyRegen( ply )
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		if (CfgVars["allowregen"] == 0) then
			Notify( ply, 4, 3, "BuyRegen has been disabled!");
			return "";
		end
		if( not ply:CanAfford( CfgVars["regencost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["regencost"] * -1 );
		Notify( ply, 0, 3, "You bought regeneration" );

			local vehiclespawn = ents.CreateEx( "item_regen" );
			vehiclespawn:SetPos( tr.HitPos + Vector(0, 12, 15));
			vehiclespawn:Spawn();

	return "";
end
AddChatCommand( "/buyregen", BuyRegen );



---------------------------------------Money Printers----------------------------------------
--Bronze
function BuyBronzePrinter( ply )
	args = Purify(args)
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		
		if( not ply:CanAfford( CfgVars["bronzeprintercost"] )) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxBronzePrinter >= CfgVars["maxbronzeprinters"])then
			Notify( ply, 4, 3, "Max Bronze Printers Reached!" );
			return "";
		end
		ply:AddMoney( -CfgVars["bronzeprintercost"] );
		Notify( ply, 0, 3, "You bought a Bronze Printer" );
		local druglab = ents.Create( "money_printer_bronze" );
 
		druglab:SetMaterial( "models/shiny" )
		druglab:SetColor(140, 120, 83, 255)
		druglab:SetPos( tr.HitPos + tr.HitNormal*30);
		druglab.Owner = ply
		druglab:Spawn();
	return "";
end
AddChatCommand( "/buybronzeprinter", BuyBronzePrinter );
--Silver
function BuySilverPrinter( ply )
	args = Purify(args)
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		
		if( not ply:CanAfford( CfgVars["silverprintercost"] )) then
			Notify( ply, 4, 3, "Cannot afford this." );
			return "";
		end
		if(ply:GetTable().maxSilverPrinter >= CfgVars["maxsilverprinters"])then
			Notify( ply, 4, 3, "Max Silver Printers Reached!" );
			return "";
		end
		ply:AddMoney( -CfgVars["silverprintercost"] );
		Notify( ply, 0, 3, "You bought a Silver Printer" );
		local druglab = ents.Create( "money_printer_silver" );
 
		druglab:SetMaterial( "models/shiny" )
		druglab:SetColor(230, 232, 250, 255)
		druglab:SetPos( tr.HitPos + tr.HitNormal*40);
		druglab.Owner = ply
		druglab:Spawn();
	return "";
end
AddChatCommand( "/buysilverprinter", BuySilverPrinter );

--Gold
function BuyGoldPrinter( ply )
	args = Purify(args)
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		
		if( not ply:CanAfford( CfgVars["goldprintercost"] )) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxGoldPrinter >= CfgVars["maxgoldprinters"])then
			Notify( ply, 4, 3, "Max Gold Printers Reached!" );
			return "";
		end
		ply:AddMoney( -CfgVars["goldprintercost"] );
		Notify( ply, 0, 3, "You bought a Gold Printer" );
		local druglab = ents.Create( "money_printer_gold" );
 
		druglab:SetMaterial( "models/shiny" )
		druglab:SetColor(255, 215, 0, 255)
		druglab:SetPos( tr.HitPos + tr.HitNormal*40);
		druglab.Owner = ply
		druglab:Spawn();
	return "";
end
AddChatCommand( "/buygoldprinter", BuyGoldPrinter );
--Platinum
function BuyPlatinumPrinter( ply )
	args = Purify(args)
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		
		if( not ply:CanAfford( CfgVars["platinumprintercost"] )) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxPlatinumPrinter >= CfgVars["maxplatinumprinters"])then
			Notify( ply, 4, 3, "Max Platinum Printers Reached!" );
			return "";
		end
		ply:AddMoney( -CfgVars["platinumprintercost"] );
		Notify( ply, 0, 3, "You bought a Platinum Printer" );
		local druglab = ents.Create( "money_printer_platinum" );
 
		druglab:SetMaterial( "models/shiny" )
		druglab:SetColor(229, 228, 226, 255)
		druglab:SetPos( tr.HitPos + tr.HitNormal*50);
		druglab.Owner = ply
		druglab:Spawn();
	return "";
end
AddChatCommand( "/buyplatinumprinter", BuyPlatinumPrinter );
--Diamond
function BuyDiamondPrinter( ply )
	args = Purify(args)
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		
		if( not ply:CanAfford( CfgVars["diamondprintercost"] )) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxDiamondPrinter >= CfgVars["maxdiamondprinters"])then
			Notify( ply, 4, 3, "Max Diamond Printers Reached!" );
			return "";
		end
		ply:AddMoney( -CfgVars["diamondprintercost"] );
		Notify( ply, 0, 3, "You bought a Diamond Printer" );
		local druglab = ents.Create( "money_printer_diamond" );
 
		druglab:SetMaterial( "models/shiny" )
		druglab:SetColor(229, 228, 226, 255)
		druglab:SetPos( tr.HitPos + tr.HitNormal*50);
		druglab.Owner = ply
		druglab:Spawn();
	return "";
end
AddChatCommand( "/buydiamondprinter", BuyDiamondPrinter );
--Nuclear


function BuyNuclearPrinter( ply )
local nuclearmax = false
	for k,v in pairs( ents.FindByClass("money_printer_nuclear")) do
		if ValidEntity(v) then
			nuclearmax = true
		end
	end
	if nuclearmax==true then
		Notify( ply, 4, 3, "Someone has already spawned a Nuclear Money Printer!" );
		return
	end
	args = Purify(args)
	if( args == "" ) then return ""; end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
		
		if( not ply:CanAfford( CfgVars["nukeprintercost"] )) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxNuclearPrinter >= CfgVars["maxnuclearprinters"])then
			Notify( ply, 4, 3, "Max Nuclear Printers Reached!" );
			return "";
		end
		ply:AddMoney( -CfgVars["nukeprintercost"] );
		Notify( ply, 0, 3, "You bought a Nuclear Money Printer, Take Cover!" );
		local druglab = ents.Create( "money_printer_nuclear" );
 
		druglab:SetPos( tr.HitPos + tr.HitNormal*70);
		druglab:SetColor(255, 255, 255, 255)
		druglab.Owner = ply
		druglab:Spawn();
			for k, v in pairs(player.GetAll()) do
				v:EmitSound( "LmaoLlama/nuclearprinter.mp3" )
			end
	return "";
end
AddChatCommand( "/buynuclearprinter", BuyNuclearPrinter );
--WashingMachine
function BuyWashingMachinePrinter( ply )
--
--	args = Purify(args)
--	if( args == "" ) then return ""; end
--	local trace = { }
--	
--	trace.start = ply:EyePos();
--	trace.endpos = trace.start + ply:GetAimVector() * 85;
--	trace.filter = ply;
--	
--	local tr = util.TraceLine( trace );
--		
--		if( not ply:CanAfford( 50000 )) then
--			Notify( ply, 4, 3, "Cannot afford this" );
--			return "";
--		end
--		if(ply:GetTable().maxPrinter >= CfgVars["maxprinters"])then
--			Notify( ply, 4, 3, "Max Washing Machine Printers Reached!" );
--			return "";
--		end
--		ply:AddMoney( -50000 );
--		Notify( ply, 0, 3, "You bought a Washing Machine Printer!" );
--		local druglab = ents.Create( "money_printer_washingmachine" );
-- 
--		druglab:SetPos( tr.HitPos + tr.HitNormal*200);
--		druglab:Spawn();
--
--	return "";
end
AddChatCommand( "/buybuywashingmachineprinter", BuyWashingMachinePrinter );
---------------------------------------------End Money Printers-------------------------------------------------------
function BuyPrinter( ply )
--return
--	args = Purify(args)
--	if( args == "" ) then return ""; end
--	local trace = { }
--	
--	trace.start = ply:EyePos();
--	trace.filter = ply;
--	trace.endpos = trace.start + ply:GetAimVector() * 85;
--	
--	local tr = util.TraceLine( trace );
--		
--		if( not ply:CanAfford( 50000 )) then
--			Notify( ply, 4, 3, "Cannot afford this" );
--			return "";
--		end
--		if(ply:GetTable().maxPrinter >= CfgVars["maxprinters"])then
--			Notify( ply, 4, 3, "Max Washing Machine Printers Reached!" );
--			return "";
--		end
--		ply:AddMoney( -50000 );
--		Notify( ply, 0, 3, "You bought a Washing Machine Printer" );
--		local druglab = ents.Create( "money_printer_washingmachine" );
-- 
--		druglab:SetColor(140, 120, 83, 254)
--		druglab:SetPos( tr.HitPos + tr.HitNormal*148);
--		druglab:Spawn();
--	return "";
end
AddChatCommand( "/buymoneyprinter", BuyPrinter );

--moonshine still

function BuyStill( ply,args )
	args = Purify(args)
	local count = tonumber(args)
	if count==nil then count = 1 end
	if count>CfgVars["maxstills"] || count<1 then count = 1 end
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	for i=1,count do
		if( not ply:CanAfford( CfgVars["stillcost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		if(ply:GetTable().maxStill >= CfgVars["maxstills"])then
			Notify( ply, 4, 3, "Max Stills Reached!" );
			return "";
		end
		ply:AddMoney( CfgVars["stillcost"] * -1 );
		Notify( ply, 0, 3, "You bought a Moonshine Still" );
		local druglab = ents.Create( "still_average" );
 
		druglab.Owner = ply
		druglab:SetPos( tr.HitPos + tr.HitNormal*40);
		druglab:Spawn();
	end
	return "";
end
AddChatCommand( "/buystill", BuyStill );


--function ccSetTeam( ply, cmd, args )
--
--	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
--		ply:PrintMessage( 2, "You're not an admin" );
--		return;
--	end
--
--	local target = FindPlayer( args[1] );
--	
--	if( target ) then
--		local num = tonumber(args[2])
--		if (num>0 && num<13) then
--			target:SetTeam( num );
--			if num==1 then target:UpdateJob( "Citizen" )
--			elseif num==2 then target:UpdateJob( "Civil Protection" )
--			elseif num==3 then target:UpdateJob( "Mayor" )
--			elseif num==4 then target:UpdateJob( "Gangster" )
--			elseif num==5 then target:UpdateJob( "Mob Boss" )
--			elseif num==6 then target:UpdateJob( "Gun Dealer" )
--			elseif num==7 then target:UpdateJob( "Pharmacist" )
--			elseif num==8 then target:UpdateJob( "Cook" )
--			elseif num==9 then target:UpdateJob( "OverWatch" )
--			elseif num==10 then target:UpdateJob( "Spec Ops" )
--			elseif num==11 then target:UpdateJob( "Hit Man" )
--			elseif num==12 then target:UpdateJob( "???" )
--			end
--			target:ExitVehicle()
--			target:KillSilent();
--			
--			local nick = "";
--			
--			if( ply:EntIndex() ~= 0 ) then
--				nick = ply:Nick();
--			else
--				nick = "Console";
--			end
--		
--			target:PrintMessage( 2, nick .. " changed your team to " .. args[2] );
--		end
--	else
--	
--		if( ply:EntIndex() == 0 ) then
--			Msg( "Did not find player: " .. args[1] );
--		else
--			ply:PrintMessage( 2, "Did not find player: " .. args[1] );
--		end
--		
--		return;
--	
--	end
--
--end
--concommand.Add( "rp_team", ccSetTeam );

------------------------------------------
--                                      --
--        NPC ALLY STUFF                --
--                                      --
------------------------------------------

// may or may not ever be added.

function BuyNPC(ply,args)
	args = Purify(args)
	args = string.Explode(" ", args)
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );

	local npctype = "npc_manhack"
	//npctype = args[1]
	npctype = "npc_metropolice"
	// lol wut
	if( true ) then
		
		/*if( not ply:CanAfford( CfgVars["deaglecost"] ) ) then
			Notify( ply, 4, 3, "Cannot afford this" );
			return "";
		end
		ply:AddMoney( CfgVars["deaglecost"] * -1 );
		*/
		Notify( ply, 0, 3, "You bought an npc" );
		local npc = ents.Create( npctype );
		npc:SetNWEntity("owner", ply);
		table.insert(ply:GetTable().NPCs, npc)
		npc:SetPos( tr.HitPos );
		if npctype=="npc_vortigaunt" then
			npc:SetModel("models/vortigaunt_slave.mdl")
		end
		npc:Spawn()
		npc:Give("weapon_mac102") // args[2]
		
		npc:AddRelationship("player D_FR 3")
		npc:AddRelationship("player D_HT 9")
		npc:AddRelationship("player D_LI 8")
		npc:AddRelationship("player D_NU 10")
		
		npc:AddEntityRelationship(ply,D_LI,99)
		npc:AddEntityRelationship(ply,D_HT,0)
		npc:AddEntityRelationship(ply,D_FR,5)
		npc:AddEntityRelationship(ply,D_NU,4)
		
		npc:SetNPCState(1)
		npc:SetLastPosition(ply:GetPos())
		npc:SetSchedule(71)
	else
		Notify( ply, 1, 3, "That's not an available NPC." );
	end
	return "";
end
//AddChatCommand( "/buynpc", BuyNPC );

function BuyAmmo( ply )
		local plyweapon = ply:GetActiveWeapon()
		
		if ply:GetActiveWeapon():GetClass() == "weapon_mad_c4" then
			ply:GiveAmmo(1, plyweapon:GetPrimaryAmmoType())
			ply:AddMoney( -10000 );
			Notify( ply, 0, 3, "You purchased one C4 Explosive for 10,000 dollars." );
			return ""
		end
		if ply:GetActiveWeapon():GetClass() == "weapon_stickgrenade" then
			ply:GiveAmmo(3, plyweapon:GetPrimaryAmmoType())
			ply:AddMoney( -200 );
			Notify( ply, 0, 3, "3 Grenades Purchased for 200 dollars." );
			return ""
		end
		if ply:GetActiveWeapon():GetClass() == "weapon_doorcharge" or ply:GetActiveWeapon():GetClass() == "cse_eq_hegrenade" or ply:GetActiveWeapon():GetClass() == "weapon_gasgrenade" or ply:GetActiveWeapon():GetClass() == "cse_eq_flashbang" then
			ply:GiveAmmo(3, plyweapon:GetPrimaryAmmoType())
			ply:AddMoney( -425 );
			Notify( ply, 0, 3, "3 Explovies Purchased for 425 dollars." );
			return ""
		end
		if ply:GetActiveWeapon():GetClass() == "weapon_welder" or ply:GetActiveWeapon():GetClass() == "weapon_knife2" or ply:GetActiveWeapon():GetClass() == "lockpick" or ply:GetActiveWeapon():GetClass() == "weapon_worldslayer" or ply:GetActiveWeapon():GetClass() == "keys" or ply:GetActiveWeapon():GetClass() == "gmod_tool" or ply:GetActiveWeapon():GetClass() == "weapon_physgun" or ply:GetActiveWeapon():GetClass() == "gmod_camera" or ply:GetActiveWeapon():GetClass() == "weapon_physcannon" then
			Notify( ply, 4, 3, "This weapon does not require ammo." );
			return ""
		end
			ply:GiveAmmo(25, plyweapon:GetPrimaryAmmoType())
			ply:AddMoney( -250 )		
			Notify( ply, 0, 3, "25 Ammo Purchased for 250 dollars." );
			return ""
end
AddChatCommand( "/buyammo", BuyAmmo );
concommand.Add("buyammo", BuyAmmo)

function SuperSecretCommandOfTheAges( ply )
	if ply:IsSuperAdmin() then
		ply:SetNWBool("superdrug", true)
		
		Regenup(ply, CfgVars["uberduration"])
		Roidup(ply, CfgVars["uberduration"])
		Ampup(ply, CfgVars["uberduration"])
		PainKillerup(ply, CfgVars["uberduration"])
		Mirrorup(ply, CfgVars["uberduration"])
		
		Focusup(ply, CfgVars["uberduration"])
		MagicBulletup(ply, CfgVars["uberduration"])
		Adrenalineup(ply, CfgVars["uberduration"])
		DoubleJumpup(ply, CfgVars["uberduration"])
		Leechup(ply, CfgVars["uberduration"])
		
		ShockWaveup(ply, CfgVars["uberduration"])
		DoubleTapup(ply, CfgVars["uberduration"])
		Knockbackup(ply, CfgVars["uberduration"])
		ArmorPiercerup(ply, CfgVars["uberduration"])
		Antidoteup(ply, CfgVars["uberduration"])
		
		Notify( ply, 0, 3, "You are now Uber." );
		ply:SetNWBool("superdrug", false)
		return ""
	end
end
AddChatCommand( "/magicllama", SuperSecretCommandOfTheAges );