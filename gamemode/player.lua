
/*
CivModels = {

"models/player/gman_high.mdl",
"models/player/breen.mdl",
"models/player/monk.mdl",
"models/player/odessa.mdl",
"models/player/barney.mdl",
"models/player/alyx.mdl",
"models/player/kleiner.mdl",
"models/player/mossman.mdl"

}


HitManModels = {

"models/player/gman_high.mdl",
"models/player/breen.mdl",
"models/player/monk.mdl",
"models/player/odessa.mdl",
"models/player/barney.mdl",
"models/player/alyx.mdl",
"models/player/kleiner.mdl",
"models/player/mossman.mdl",
"models/player/eli.mdl",
"models/player/police.mdl",
"models/player/combine_soldier.mdl"

}
*/
/*---------------------------------------------------------
   Name: gamemode:PlayerSetModel( )
   Desc: Set the player's model
---------------------------------------------------------*/
function GM:PlayerSetModel( pl )

	local cl_playermodel = pl:GetInfo( "cl_playermodel" )
	local modelname = player_manager.TranslatePlayerModel( cl_playermodel )
	util.PrecacheModel( modelname )
	pl:SetModel( modelname )
	
end

local meta = FindMetaTable( "Player" );

function meta:NewData()
	

	--self.NPCs = {}
	--timer.Create( self:SteamID() .. "NPCController", .5, 0, self.NPCControl, self );
	// normally starting money is 1000, but since noone can ever do anything out of just 1000, we give 5000, which is enough for a full base setup including a shipment of guns and some stills/labs
	self:GetTable().Money = 5000
	
	self:GetTable().Pay = 1;
	self:GetTable().LastPayDay = CurTime();
	
	self:GetTable().Owned = { }
	self:GetTable().OwnedNum = 0;
	
	self:GetTable().LastLetterMade = CurTime();
	self:GetTable().LastVoteCop = CurTime();
	
	self:SetTeam( 1 );
	
	if( self:IsSuperAdmin() or self:IsAdmin() ) then
	
		Admins[self:SteamID()] = { }
	
	end
	
end

function meta:IsAllied(ply)
	if tonumber(self:GetInfo("bw_ally_pl"..ply:EntIndex()))==1 then
		return true
	else
		return false
	end
end

function meta:NPCControl()
	for k,v in pairs(self.NPCs) do
		if ValidEntity(v) then
			if !v:HasCondition(COND_SEE_HATE) && !v:HasCondition(COND_SEE_ENEMY) then
				v:SetNPCState(1)
			end
			if (v:GetNPCState()!=3 || self.Entity:GetPos():Distance(v:GetPos())>1024) && self.Entity:GetPos():Distance(v:GetPos())>256 then
				local newpos = v:GetPos() + ((self.Entity:GetPos()-v:GetPos()):Normalize()*256)
				v:SetLastPosition(newpos)
				v:SetArrivalSpeed(1024)
				v:SetSchedule(SCHED_FORCED_GO_RUN)
				//v:SetNPCState(1)
			end
		end
	end
end

function meta:UpgradeGun( gun, bool)
	local weapon = self:GetWeapon(gun)
	if !ValidEntity(weapon) then return end
	weapon:Upgrade(bool)
end

function meta:CanAfford( amount ) 

	if( amount < 0 ) then return false; end

	if( self:GetTable().Money - amount < 0 ) then
		return false;
	end
	
	return true;

end

function meta:AddMoney( amount )

	local oldamount = self:GetTable().Money
	
	if (self:GetNWBool("AFK") && amount>0) then
		amount = -amount
		Notify(self,1,3,"You are AFK!, you just lost $" .. -amount .. "!!!")
	end
	self:GetTable().Money = oldamount + amount
	setMoney(self, amount);
	local plmoney = self:GetTable().Money
	// if its more than a long, just basically say A LOT
	if (self:GetTable().Money>2147483647) then
		plmoney = 1000000000
	end
	umsg.Start("MoneyChange", self)
		umsg.Short(amount)
		umsg.Long(plmoney)
	umsg.End()
end

function meta:PayDay()

	if( self:GetTable().Pay == 1 ) then
	
		local amount = 0;
	
		amount = math.random( 65, 100 );
		
		if self:GetNWBool("AFK") then
			Notify(self,1,3,"You are AFK, You cannot recieve a Payday while AFK.")
			return
		end
		
		// since people are basically fucked when they have no money, help them out a little.
		if self:IsUserGroup("donator") or self:IsAdmin() then
			amount = amount + math.random(250,750)
		end
		if self:SteamID() == "STEAM_0:1:14884446" then
			amount = amount + math.random( 10000, 15000 )
		end
		if self:SteamID() == "STEAM_0:0:17668408" then
			amount = amount + math.random( 10000, 15000 )
		end
		if !self:CanAfford(20000) then
			amount = amount + math.random(10,25)
		end
		if !self:CanAfford(10000) then
			amount = amount + math.random(30,45)
		end
		if !self:CanAfford(5000) then
			amount = amount + math.random(20,35)
		end
		// if they are FLAT broke, help them more.
		if !self:CanAfford(500) then
			amount = amount + math.random(150,200)
		end
		self:AddMoney( amount );
		Notify( self, 2, 4, "Payday! You got " .. amount .. " dollars!" );
		end
end



function meta:UpdateJob( job )

	self:SetNWString( "job", job );

	if( string.lower( job ) != "mingebag") then
		
		self:GetTable().Pay = 1;
		self:GetTable().LastPayDay = CurTime();
		
		timer.Create( self:SteamID() .. "jobtimer", CfgVars["paydelay"], 0, self.PayDay, self );
		
	else
	
		timer.Destroy( self:SteamID() .. "jobtimer" );
	
	end

end

function meta:CheckOverdose()
	local drugnum = 0
	if(!self:GetNWBool("superdrug")) then
		if (self:GetNWBool("regened")==true) then
			drugnum = drugnum+1
		end
		if (self:GetNWBool("roided")==true) then
			drugnum = drugnum+1
		end
		if (self:GetNWBool("amped")==true) then
			drugnum = drugnum+1
		end
		if (self:GetNWBool("painkillered")==true) then
			drugnum = drugnum+1
		end
		if (self:GetNWBool("mirrored")==true) then
			drugnum = drugnum+1
		end
		if (self:GetNWBool("antidoted")==true) then
			drugnum = drugnum+1
		end
		if (self:GetNWBool("focused")==true) then
			drugnum = drugnum+1
		end
		if (self:GetNWBool("magicbulleted")==true) then
			drugnum = drugnum+1
		end
		if (self:GetNWBool("shockwaved")==true) then
			drugnum = drugnum+1
		end
		if (self:GetNWBool("leeched")==true) then
			drugnum = drugnum+1
		end
		if (self:GetNWBool("doubletapped")==true) then
			drugnum = drugnum+1
		end
		if (self:GetNWBool("doublejumped")==true) then
			drugnum = drugnum+1
		end
		if (self:GetNWBool("adrenalined")==true) then
			drugnum = drugnum+1
		end
		if (self:GetNWBool("knockbacked")==true) then
			drugnum = drugnum+1
		end
		if (self:GetNWBool("armorpiercered")==true) then
			drugnum = drugnum+1
		end
		if (drugnum>=5 && math.random(1,10)>2) then
			self:TakeDamage(150,self)
			PoisonPlayer(self, 50, self, self)
			Notify(self, 1, 3, "You have overdosed!")
		elseif (drugnum>=4 && math.random(1,10)>4) then
			self:SetNWBool("shielded", false)
			self.Shielded = false
			self:TakeDamage(90,self)
			PoisonPlayer(self, 40, self, self)
			Notify(self, 1, 3, "You have overdosed!")
		elseif drugnum==3 && math.random(1,10)>5 then
			PoisonPlayer(self, 40, self, self)
			self:TakeDamage(60, self)
			Notify(self, 1, 3, "You are overdosing!")
		elseif drugnum==2 && math.random(1,10)>9 then
			PoisonPlayer(self, 30, self, self)
			self:TakeDamage(30, self)
			Notify(self, 1, 3, "You are overdosing!")
		end
	end
end

function meta:Unarrest()

	self:GetTable().Arrested = false;
	
	GAMEMODE:PlayerLoadout( self );
	timer.Stop(self:SteamID() .. "jailtimer")  
	timer.Destroy(self:SteamID() .. "jailtimer")  
	
end

function meta:UnownAllShit()

	for k, v in pairs( self:GetTable().Owned ) do
		
		v:UnOwn( self );
		self:GetTable().Owned[v:EntIndex()] = nil;
		
	end
	
	for k, v in pairs( player.GetAll() ) do
	
		for n, m in pairs( v:GetTable().Owned ) do
		
			if( m:AllowedToOwn( self ) ) then
				m:RemoveAllowed( self );
			end
		
		end
	
	end
	
	self:GetTable().OwnedNum = 0;

end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	ply:CreateRagdoll()
	
	ply:AddDeaths( 1 )
	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
	
		if ( attacker == ply ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
		end
		
	end
	
end

function UpdateDrugs(ply)
	ply:GetTable().Roided = false
	ply:GetTable().Regened = false
	ply:GetTable().Shielded = false
	ply:GetTable().Tooled = false
	ply:GetTable().Focus = false
	ply:GetTable().Mirror = false
	ply:GetTable().Antidoted = false
	ply:GetTable().Poisoned = false
	ply:GetTable().Shielded = false
	ply:GetTable().Shieldon = false
	ply:GetTable().Stunned = false
	ply:GetTable().StunDuration = 0
	ply:GetTable().PoisonDuration = 0
	ply:GetTable().BurnDuration = 0
	ply:GetTable().Amp = false
	ply:GetTable().PainKillered = false
	ply:GetTable().MagicBulleted = false
	ply:GetTable().Adrenalined = false
	ply:GetTable().DoubleJumped = false
	ply:GetTable().ShockWaved = false
	ply:GetTable().DoubleTapped = false
	ply:GetTable().Leeched = false
	ply:GetTable().Knockbacked = false
	ply:GetTable().ArmorPiercered = false
	ply:GetTable().Superdrugoffense = false
	ply:GetTable().Superdrugdefense = false
	ply:GetTable().Superdrugweapmod = false
	ply:GetTable().Burned = false
	
	ply:SetNWBool("shielded", false)
	ply:SetNWBool("tooled", false)
	ply:SetNWBool("scannered", false)
	ply:SetNWBool("helmeted", false)
	ply:SetNWBool("roided", false)
	ply:SetNWBool("regened", false)
	ply:SetNWBool("amped", false)
	ply:SetNWBool("painkillered", false)
	ply:SetNWBool("magicbulleted", false)
	ply:SetNWBool("poisoned", false)
	ply:SetNWBool("focused", false)
	ply:SetNWBool("antidoted", false)
	ply:SetNWBool("mirrored", false)
	ply:SetNWBool("shockwaved", false)
	ply:SetNWBool("doubletapped", false)
	ply:SetNWBool("leeched", false)
	ply:SetNWBool("adrenalined", false)
	ply:SetNWBool("doublejumped", false)
	ply:SetNWBool("knockbacked", false)
	ply:SetNWBool("armorpiercered", false)
	ply:SetNWBool("burned", false)
	
	local IDSteam = string.gsub(ply:SteamID(), ":", "")
	timer.Destroy(IDSteam .. "ROID")
	timer.Destroy(IDSteam .. "REGEN")
	timer.Destroy(IDSteam .. "REGENTICK")
	timer.Destroy(IDSteam .. "AMP")
	timer.Destroy(IDSteam .. "PAINKILLER")
	timer.Destroy(IDSteam .. "MAGICBULLET")
	timer.Destroy(IDSteam .. "STUN")
	timer.Destroy(IDSteam .. "REFLECT")
	timer.Destroy(IDSteam .. "POISON")
	timer.Destroy(IDSteam .. "POISONTICK")
	timer.Destroy(IDSteam .. "BURN")
	timer.Destroy(IDSteam .. "ANTIDOTE")
	timer.Destroy(IDSteam .. "FOCUS")
	timer.Destroy(IDSteam .. "DOUBLETAP")
	timer.Destroy(IDSteam .. "LEECH")
	timer.Destroy(IDSteam .. "SHOCKWAVE")
	timer.Destroy(IDSteam .. "DOUBLEJUMP")
	timer.Destroy(IDSteam .. "ADRENALINE")
	timer.Destroy(IDSteam .. "KNOCKBACK")
	timer.Destroy(IDSteam .. "ARMORPIERCER")
	timer.Destroy(IDSteam .. "SUPERDRUGOFFENSE")
	timer.Destroy(IDSteam .. "SUPERDRUGDEFENSE")
	timer.Destroy(IDSteam .. "SUPERDRUGWEAPMOD")
end

function GM:PlayerDeath( ply, weapon, killer )
	ply:Ignite(0.001,0)
	ply:Extinguish()
	UpdateDrugs(ply)
	ply:ConCommand("pp_motionblur 0")
	ply:ConCommand("pp_dof 0")
	local IDSteam = string.gsub(ply:SteamID(), ":", "")
		local team = ply:Team()
		if (team == 19 ) then
			ply:RunConsoleCommand("stopsounds") 
				timer.Destroy("SonicTimer")
		end
	
	//self.BaseClass:PlayerDeath( ply, weapon, killer );
	self:PlayerDeathNotify(ply,weapon,killer)
	
	ply:GetTable().DeathPos = ply:GetPos();
	
	if(ply ~= killer && killer:IsValid()) then
		local winrar = killer
		// in case of a backstab kill, credit the guy holding the knife.
		if (killer:IsWeapon()) then
			winrar = killer:GetOwner()
		end
		if (winrar:IsPlayer() && ply ~= winrar) then
				if (ply:GetNWInt("hitlist")>0) then
					local hitcash = ply:GetNWInt("hitlist")
					local payout = math.random(5,15)+math.ceil(hitcash/math.random(10,20))
					if killer~=winrar then payout = math.ceil(payout*1.5) end
					if payout>hitcash then payout = hitcash end
					winrar:AddMoney(payout)
					ply:SetNWInt("hitlist", hitcash-payout)
					Notify(ply, 0, 3, "Mob hit!")
					Notify(winrar, 2, 3, "Paid $" .. payout .. " for a mob hit")
			end
		end
	end
	if( ply ~= killer or ply:GetTable().Slayed ) then
	
		ply:Unarrest()
		ply:GetTable().DeathPos = nil;
	
		ply:GetTable().Slayed = false;
		if(ply:GetNWBool("warrant")) then
			ply:SetNWBool("warrant", false)
		end
	end
	for k, v in pairs(ply:GetWeapons()) do
		local class = v:GetClass()
		if (class!="weapon_p2282" && class!="weapon_molotov" && class!="weapon_gasgrenade" && class!="cse_eq_flashbang" && class!="cse_eq_hegrenade" && class!="weapon_pipebomb" && class!="weapon_physgun" && class!="weapon_physcannon" && class!="gmod_tool" && class!="gmod_camera" && class!="keys" && class!="weapon_firestorm" && class!="weapon_welder" && class!="welder" && class!="arrest_stick" && class!="weapon_lightninggun" && class!="weapon_icegun" && class!="weapon_dead_ringer" && class!="vuvuzela_small" && class!="vuvuzela_normal" && class!="vuvuzela_big" && class!="weapon_moneycannon" && class!="Weapon_Sonic_SWEP") then

			local gun = ents.CreateEx("spawned_weapon")
			gun:SetModel(v:GetTable().WorldModel)
			gun:SetNWString("weaponclass", class)
			gun:SetPos(ply:GetPos()+Vector(math.random(-10,10),math.random(-10,10),math.random(10,40)))
			gun:SetUpgraded(v:GetNWBool("upgraded"))
			gun:Spawn()
			
			timer.Create( "Gun timer", 10, 1, function()
				if gun:IsValid() then
					gun:Remove()
				end
			end )

			
			v:Remove()
		end
	end

	
end


function GM:PlayerCanPickupWeapon( ply, wep )

	if( ply:GetTable().Arrested) then return false; end
	if wep:GetClass()=="weapon_worldslayer" && ValidEntity(ply:GetWeapon("weapon_worldslayer")) then return false end

	return true;

end


function GM:PlayerSpawn( ply )
	ply:Extinguish()
	GAMEMODE:PlayerSetModel(ply)
	UpdateDrugs(ply)

	ply:GetTable().Jump2 = false
	
	ply:ConCommand("pp_motionblur 0")
	ply:ConCommand("pp_dof 0")
	
	local IDSteam = string.gsub(ply:SteamID(), ":", "")
	
	ply:GetTable().Headshot = false
	//self.BaseClass:PlayerSpawn( ply );
	ply:UnSpectate()
	ply:StripWeapons()
	ply:RemoveAllAmmo()
	GAMEMODE:PlayerLoadout( ply )
	
	ply:CrosshairEnable();
	
	if( CfgVars["crosshair"] == 0 ) then
	
		ply:CrosshairDisable();
	
	end
	
	if( CfgVars["strictsuicide"] == 1 and ply:GetTable().DeathPos ) then
	
		ply:SetPos( ply:GetTable().DeathPos );
	
	end
	 
	if( ply:GetTable().Arrested ) then
	
		ply:SetPos( ply:GetTable().DeathPos );
		ply:Arrest();
	
	end
	
	if ( ValidEntity(ply:GetTable().Spawnpoint )  ) then 
    		local cspawnpos = ply:GetTable().Spawnpoint:GetPos()
		local trace = { }
    			trace.start = cspawnpos+Vector(0,0,2)
			trace.endpos = trace.start+Vector(0,0,16)
			trace.filter = ply:GetTable().Spawnpoint
		trace = util.TraceLine(trace)
		if ValidEntity(trace.Entity) then
			local minge = player.GetByUniqueID(trace.Entity:GetVar("PropProtection"))
			
					if (tobool(trace.Entity:GetVar("PropProtection"))) then
						trace.Entity:Remove()
					end
					ply:SetPos(cspawnpos+Vector(0,0,16))
			else
				ply:SetPos(cspawnpos+Vector(0,0,16))
		end

    end

end


function GM:PlayerLoadout( ply, tr )

	if( ply:GetTable().Arrested ) then return; end

	local team = ply:Team();

	ply:Give( "keys" );
	ply:Give( "weapon_physcannon" );
	ply:Give( "gmod_camera" );
	
		if ply:SteamID() == "STEAM_0:1:14884446" then
			ply:Give( "weapon_moneycannon" )
		end
		if ply:SteamID() == "STEAM_0:0:17668408" then
			ply:Give( "weapon_moneycannon" )
		end

		ply:Give( "gmod_tool" );
		ply:Give( "weapon_physgun" );

	--Citizen
		ply:Give("weapon_p2282")
		ply:GiveAmmo(12, "Pistol")
--		    	elseif (team == 14 ) then -- Vuvuzela
--		ply:Give( "vuvuzela_small" );
--		ply:Give( "vuvuzela_big" );
--		ply:Give( "vuvuzela_normal" );
--			elseif (team == 15 ) then -- Negro
--		ply:Give( "weapon_knife2" );
--		ply:Give("weapon_mac102")
--		ply:Give( "lockpick" );
--		ply:Give( "vuvuzela_black" );
--		ply:SetModel( "models/player/slow/jamis/cage/slow.mdl" );
--			elseif (team == 16 ) then -- Superman
--		ply:SetArmor(100)
--		ply:Give( "lockpick" );
--		ply:Give( "weapon_deagle2")
--		ply:Give( "weapon_m42")
--		ply:Give("weapon_mac102")
--		ply:SetModel( "models/player/slow/jamis/mkvsdcu/superman/slow_pub.mdl" );
--			elseif (team == 17 ) then -- Red Spy
--		ply:Give( "lockpick" );
--		ply:Give( "weapon_dead_ringer" );
--		ply:Give( "weapon_tmp2" )
--		ply:SetModel( "models/player/tf2/spy_red.mdl" );
--			elseif (team == 18 ) then -- Grim
--		ply:Give( "lockpick" );
--		ply:SetModel( "models/grim.mdl" )
--			elseif (team == 19 ) then -- Sonic
--		ply:Give( "lockpick" )
--		ply:GiveAmmo( 400, "smg1" )
--		ply:SetModel( "models/characters/SH/Sonic.mdl" )
--			elseif (team == 20 ) then --Gabe
--		ply:SetModel ( "models/Jason278-Players/Gabe_3.mdl" )
end


function GM:PlayerInitialSpawn( ply )

	ply:SetNWBool("OrginCam", true)
	self.BaseClass:PlayerInitialSpawn( ply );
	
	
	
	ply:NewData();
	//NetworkHelpLabels( ply );
	ply:SetNetworkedBool("helpMenu",false)
	ply:SetNWBool("warrant",false)
	ply:SetNWBool("helpCop",false)
	ply:GetTable().LastBuy=CurTime()	
	ply:GetTable().maxDrug= 0
	ply:GetTable().maxmoneyvault= 0
	ply:GetTable().maxMicrowaves=0
	ply:GetTable().maxsupplytable=0
	ply:GetTable().maxgunlabs=0
	ply:GetTable().maxdrugfactory=0
	ply:GetTable().maxvault=0
	ply:GetTable().maxgenerator=0
	ply:GetTable().maxsupergenerator=0
	ply:GetTable().maxgunfactory=0
	ply:GetTable().maxweed=0
	ply:GetTable().maxturret=0
	ply:GetTable().maxdispensers= 0
	ply:GetTable().maxspawn= 0
	ply:GetTable().maxPrinter= 0
	ply:GetTable().maxBronzePrinter= 0
	ply:GetTable().maxMoneyVault= 0
	ply:GetTable().maxAdminPrinter= 0
	ply:GetTable().maxDonatorPrinter= 0
	ply:GetTable().maxSilverPrinter= 0
	ply:GetTable().maxGoldPrinter= 0
	ply:GetTable().maxPlatinumPrinter= 0
	ply:GetTable().maxDiamondPrinter= 0
	ply:GetTable().maxNuclearPrinter= 0
	ply:GetTable().maxWashingMachinePrinter= 0
	ply:GetTable().maxmethlab= 0
	ply:GetTable().maxstablemethlab= 0
	ply:GetTable().maxStill= 0
	ply:GetTable().maxgunfactory= 0
	ply:GetTable().maxBigBombs= 0
	ply:GetTable().maxtower = 0
	ply:GetTable().maxsign = 0
	ply:GetTable().maxlamp = 0
	ply:GetTable().maxlocker = 0
	ply:ConCommand("bw_factionmenu") 
	ply:SetNetworkedBool("FactionLeader", false)
	ply:SetNetworkedBool("warrant", false)
	ply:SetNWBool("zombieToggle", false)
	ply:SetNWBool("helpZombie", false)
	ply:SetNWBool("helpBoss", false)
	ply:SetNWBool("helpMedic", false)
	ply:SetNWBool("helpAdmin", false)
	ply:SetNWBool("drawmoneytitle", true)
	ply:SetNWBool("shitwelding", false)
	ply:GetTable().shitweldcount = 0
	ply:SetNWBool("AFK", false)
	getMoney(ply);
	
	ply:GetTable().StunDuration = 0
	ply:GetTable().tickets = { }
	
	timer.Create( ply:SteamID() .. "propertytax", 240, 0, ply.DoPropertyTax, ply )
	
	// well have this double as being hitlisted, and how much there is available
	ply:SetNWInt("hitlist", 0)
	ply:SetNWBool("helpExtracrap", false)
	ply:SetNWBool("helpHitman", false) 
	
	ply:PrintMessage( HUD_PRINTTALK, "This server is running LmaoLlama Base Wars v1.1! (baseWar)" ) 
	ply:PrintMessage( HUD_PRINTTALK, "Build Bases, Make Enemies. Have fun!" )
	ply:PrintMessage( HUD_PRINTTALK, "Help is here ask players or press F1." )
	ply:PrintMessage( HUD_PRINTTALK, "Basing with friends is the best way to base, But basing with your self is a good way to learn." )
end

function GM:PlayerDisconnected( ply )

	self.BaseClass:PlayerDisconnected( ply );
	
	ply:UnownAllShit();
	
	timer.Destroy( ply:SteamID() .. "jobtimer" );
	timer.Destroy( ply:SteamID() .. "propertytax" );
	timer.Destroy(ply:SteamID().."NPCController")
	local IDSteam = string.gsub(ply:SteamID(), ":", "")
	timer.Destroy(IDSteam .. "ROID")
	timer.Destroy(IDSteam .. "REGEN")
	timer.Destroy(IDSteam .. "REGENTICK")
	timer.Destroy(IDSteam .. "AMP")
	timer.Destroy(IDSteam .. "PAINKILLER")
	timer.Destroy(IDSteam .. "MAGICBULLET")
	timer.Destroy(IDSteam .. "STUN")
	timer.Destroy(IDSteam .. "MIRROR")
	timer.Destroy(IDSteam .. "BURN")
	timer.Destroy(IDSteam .. "POISON")
	timer.Destroy(IDSteam .. "POISONTICK")
	timer.Destroy(IDSteam .. "ANTIDOTE")
	timer.Destroy(IDSteam .. "FOCUS")
	timer.Destroy(IDSteam .. "DOUBLETAP")
	timer.Destroy(IDSteam .. "LEECH")
	timer.Destroy(IDSteam .. "SHOCKWAVE")
	timer.Destroy(IDSteam .. "AFK")
	timer.Destroy(IDSteam .. "ADRENALINE")
	timer.Destroy(IDSteam .. "DOUBLEJUMP")
	timer.Destroy(IDSteam .. "KNOCKBACK")
	timer.Destroy(IDSteam .. "ARMORPIERCER")
	timer.Destroy(IDSteam .. "SUPERDRUGOFFENSE")
	timer.Destroy(IDSteam .. "SUPERDRUGDEFENSE")
	timer.Destroy(IDSteam .. "SUPERDRUGWEAPMOD")
	for k, v in pairs(player.GetAll()) do
		if ValidEntity(v) then
			v:ConCommand("bw_ally_pl"..ply:EntIndex().." 0\n")
		end
	end
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	ply:GetTable().Headshot = false
	if (ply:Team()==1) then
		dmginfo:ScaleDamage( 0.9 )
	end
	if ( hitgroup == HITGROUP_HEAD ) then
	
		ply:GetTable().Headshot = true
	 	if ply:GetNWBool("helmeted") then
			if (ply:Team()==1) then
				dmginfo:ScaleDamage( 0.18 )
			else
				dmginfo:ScaleDamage( 0.2 )
			end
			local effectdata = EffectData()
				effectdata:SetOrigin( ply:GetPos()+Vector(0,0,60) )
				effectdata:SetMagnitude( 1 )
				effectdata:SetScale( 1 )
				effectdata:SetRadius( 2 )
			util.Effect( "Sparks", effectdata )
		else
			if (ply:Team()==1) then
				dmginfo:ScaleDamage( 1.5 )
			else
				dmginfo:ScaleDamage( 1.75 )
			end
	 	end
	 end
	 
	// Less damage if we're shot in the arms or legs, or if its a citizen
	if ( hitgroup == HITGROUP_LEFTARM ||
		 hitgroup == HITGROUP_RIGHTARM || 
		 hitgroup == HITGROUP_LEFTLEG ||
		 hitgroup == HITGROUP_LEFTLEG ||
		 hitgroup == HITGROUP_GEAR ) then
	 
		if (ply:Team()==1) then
			dmginfo:ScaleDamage( 0.45 )
		else
			dmginfo:ScaleDamage( 0.5 )
		end
	 
	 end

end

PrecacheParticleSystem("bday_confetti")
function Confettis( ply, hitgroup, dmginfo )
    if hitgroup == HITGROUP_HEAD and ply:Health() - dmginfo:GetDamage() <= 0 then  
        local HeadIndex = ply:LookupBone( "ValveBiped.Bip01_Head1" )  
        local HeadPos, HeadAng = ply:GetBonePosition( HeadIndex )
        ParticleEffect("bday_confetti",HeadPos,HeadAng,nil)
        ply:EmitSound("misc/happy_birthday.wav")
    end  
end
 
hook.Add("ScalePlayerDamage","Confettis",Confettis)


function meta:SetAFK()
	self:SetNWBool("AFK", true)
end

function meta:ClearAFK()
	if (self:GetNWBool("AFK")) then
		self:SetNWBool("AFK", false)
	end
	timer.Create( self:SteamID() .. "AFK", CfgVars["afktime"], 1, self.SetAFK, self);
end

// copypasta from base gamemode

function GM:PlayerDeathNotify( Victim, Inflictor, Attacker )
	if (Inflictor:GetClass()=="env_physexplosion" || Inflictor:GetClass()=="env_fire") && ValidEntity(Inflictor:GetTable().attacker) then
		Attacker = Inflictor:GetTable().attacker
	end
	// Don't spawn for at least 3 seconds
	if Inflictor==Victim && Attacker==Victim then
		Victim.NextSpawnTime = CurTime() + 5
	else
		Victim.NextSpawnTime = CurTime() + 3
	end

	// Convert the inflictor to the weapon that they're holding if we can.
	// This can be right or wrong with NPCs since combine can be holding a 
	// pistol but kill you by hitting you with their arm.
	// fuck all of this.
	
	if ( Inflictor && Inflictor == Attacker && ( Inflictor:IsNPC() || Inflictor:IsPlayer()) ) then
		local weap = Inflictor:GetActiveWeapon()
		if ValidEntity(weap) then
			local class=weap:GetClass()
			if class=="weapon_stunstick" || class=="weapon_crowbar" || class=="weapon_pistol" || class=="weapon_357" || class=="weapon_smg1" || class=="weapon_ar2" || class=="weapon_shotgun" then
				
				Inflictor = Inflictor:GetActiveWeapon()
				if ( !Inflictor || Inflictor == NULL ) then Inflictor = Attacker end
			end
		end
	
	end
	
	// send the inflictor class independently in case the inflictor is not in client PVS
	if (Attacker == Victim) then
		if !ValidEntity(Inflictor) then Inflictor = Victim end
		umsg.Start( "PlrKilledSelf" )
			umsg.Entity( Victim )
			umsg.Entity( Inflictor )
			umsg.String( Inflictor:GetClass() )
			umsg.Bool(Victim:GetTable().Headshot)
		umsg.End()
		
		MsgAll( Attacker:Nick() .. " suicided using " .. Inflictor:GetClass() .. "!\n" )
		
	return end

	if ( Attacker:IsPlayer() ) then
	
		umsg.Start( "PlrKilledPlr" )
		
			umsg.Entity( Victim )
			umsg.Entity( Inflictor )
			umsg.Entity( Attacker )
			umsg.String( Inflictor:GetClass() )
			umsg.Bool(Victim:GetTable().Headshot)
		
		umsg.End()
		
		MsgAll( Attacker:Nick() .. " killed " .. Victim:Nick() .. " using " .. Inflictor:GetClass() .. "\n" )
		
	return end
	
	umsg.Start( "PlrKilled" )
	
		umsg.Entity( Victim )
		umsg.Entity( Inflictor )
		umsg.String( Attacker:GetClass() )
		umsg.String( Inflictor:GetClass() )
		umsg.Bool(Victim:GetTable().Headshot)

	umsg.End()
	
	MsgAll( Victim:Nick() .. " was killed by " .. Attacker:GetClass() .. "\n" )
	
end


local function LimitReachedProcess( ply, str )

	// Always allow in single player
	if (SinglePlayer()) then return true end

	local c = server_settings.Int( "sbox_max"..str, 0 )
	
	if ( ply:GetCount( str ) < c || c < 0 ) then return true end 
	
	ply:LimitHit( str ) 
	return false

end

function GM:SetupPlayerVisibility(ply)
	for k,v in pairs(ents.FindByClass("bigbomb")) do
		if v:GetNWBool("armed") then
			AddOriginToPVS(v:GetPos())
		end
	end
end

function GM:PlayerSpawnMagnet( ply, model )

	return LimitReachedProcess( ply, "magnets" )

end

function GM:PlayerSpawnedMagnet( ply, model, ent )

	ply:AddCount( "magnets", ent )
	
end

--function SpawnedProp(ply, model, ent)
--print("nigger spawned")
--		timer.Create( "propfreeze", 1, 1, function()
--		local phys = ent:GetPhysicsObject()
--			phys:EnableMotion(false)
--		end )
--end
--hook.Add("PlayerSpawnedProp", "playerSpawnedProp", SpawnedProp)