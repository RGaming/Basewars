// take quotes out of things. probably couldve done better.
function Purify ( strng )
	if (string.find(tostring(strng), [[%"]])) then
		strng = " "
	end
	if (string.find(tostring(strng), [[\n]])) then
		strng = " "
	end
	return strng
end

CreateConVar('sbox_maxmagnets', 50)

function Notify( ply, msgtype, len, msg )
	ply:PrintMessage( 2, msg );
	umsg.Start("RPDMNotify", ply)
		umsg.String(msg)
		umsg.Short(msgtype)
		umsg.Short(len)
	umsg.End()
	//ply:SendLua( "GAMEMODE:AddNotify(\"" .. msg .. "\", " .. msgtype .. ", " .. len .. ")" );

end

function NotifyAll( msgtype, len, msg )

	for k, v in pairs( player.GetAll() ) do
		
		Notify( v, msgtype, len, msg );
		
	end

end

function PrintMessageAll( msgtype, msg )

	for k, v in pairs( player.GetAll() ) do
	
		v:PrintMessage( msgtype, msg );
	
	end

end

function TalkToRange( msg, pos, size )

	local ents = ents.FindInSphere( pos, size );
	
	for k, v in pairs( ents ) do
	
		if( v:IsPlayer() ) then
		
			v:ChatPrint( msg );
			v:PrintMessage( 2, msg );
		
		end
	
	end

end

function FindPlayer( info )

	for k, v in pairs( player.GetAll() ) do
		
		if( tonumber( info ) == v:EntIndex() ) then
			return v;
		end
		
		if( info == v:SteamID() ) then
			return v;
		end
		
		if( string.find( string.lower(v:Nick()), string.lower(info) ) != nil ) then
			return v;
		end
		
	end
	
	return nil;

end

function ShockWaveExplosion(pos, ply, hitnorm, rad)
	rad = math.Round(rad*.5)
	//usermessage for the one who fired, so that they can see it.
	umsg.Start("shockwaveeffect", ply)
		umsg.Vector(pos)
		umsg.Angle(hitnorm)
		umsg.Short(rad)
	umsg.End()
	local efdt = EffectData()
		efdt:SetStart(pos)
		efdt:SetOrigin(pos)
		efdt:SetScale(1)
		efdt:SetRadius(rad)
		efdt:SetNormal(hitnorm)
	util.Effect("cball_bounce",efdt)
end

function SpyScan(ply,target,backscan)
	if target:GetNWBool("scannered") then
		Notify(ply,4,3,"Could not scan target information due to target having a scanner")
		if !backscan && target!=ply then
			Notify(target, 1, 3, "Using your scanner to scan them back.")
			SpyScan(target,ply,true)
		end
	else
		Notify(ply,2,3,"Printing information on scan target in your console")
		local weapon = "Nothing"
		if ValidEntity(target:GetActiveWeapon()) then
			weapon = target:GetActiveWeapon():GetClass()
		end
		ply:PrintMessage(2, "\n" ..target:GetName() .. "\n" .. target:Health() .. "/" .. target:GetMaxHealth() .. " Health and " .. target:Armor() .. "/100 Armor\nHolding weapon: " .. weapon .. "\nOther weapons: \n")
		for k,v in pairs(target:GetWeapons()) do
			if v!=target:GetActiveWeapon() then
				ply:PrintMessage(2, v:GetClass() .. "\n")
			end
		end
		local shield = ""
		local scanner = ""
		local helmet = ""
		if target:GetNWBool("shielded") then shield = "shield " end
		if target:GetNWBool("helmeted") then helmet = "helmet " end
		if target:GetNWBool("scannered") then scanner = "scanner " end
		if scanner=="" && helmet == "" && shield == "" then scanner = "Nothing" end
		ply:PrintMessage(2, "Equipped: " .. shield .. helmet .. scanner .. "\n\n")
		// backscan to keep an infinite scan loop from happening back and forth
	end
end

function ReconScan(ply, target)
	Notify(ply,2,3,"Printing a list of things found in scan to your console")
	local scanpos = target:GetPos()
	local stuff = 0
	ply:PrintMessage(2,"\n")
	for k, v in pairs(ents.FindInSphere(scanpos, 512)) do
		if ValidEntity(v) then
			if v:GetTable().Structure then
				stuff = stuff+1
				ply:PrintMessage(2, v:GetTable().PrintName .. " " .. v.Owner:GetName())
			end
		end
	end
	ply:PrintMessage(2,"\n")
	if stuff>0 then
		Notify(ply,3,3,"Scan has found " .. tostring(stuff) .. " structures near " .. target:GetName().."")
	else
		Notify(ply,4,3,"Scan has found nothing")
	end
end

// i dont know why i bothered. oh right, im bored. guess it would be like in red alert 2, when kirov airships announced theirself to everyone once built.

local uberexists=false
function UberDrugExists()
	if !uberexists then
		NotifyAll(1,5,"Someone has created an UberDrug!")
		uberexists=true
	end
end

function ccBuyDrugs( ply, command, args )
	local drug = args[1]
	if ply:GetTable().LastBuy+1.5<CurTime() then
		ply:GetTable().LastBuy=CurTime()
		if( drug == "steroid" ) then
			BuySteroid(ply)
		elseif( drug == "doublejump" ) then
			BuyDoubleJump(ply)
		elseif( drug == "leech" ) then
			BuyLeech(ply)
		elseif( drug == "amp" ) then
			BuyAmp(ply)
		elseif( drug == "armorpiercer" ) then
			BuyArmorpiercer(ply)
		
		elseif( drug == "regen" ) then
			BuyRegen(ply)
		elseif( drug == "painkiller" ) then
			BuyPainKiller(ply)
		elseif( drug == "antidote" ) then
			BuyAntidote(ply)
		elseif( drug == "reflect" ) then
			BuyReflect(ply)
		elseif( drug == "adrenaline" ) then
			BuyAdrenaline(ply)
		
		elseif( drug == "magicbullet" ) then
			BuyMagicBullet(ply)
		elseif( drug == "shockwave" ) then
			BuyShockWave(ply)
		elseif( drug == "knockback" ) then
			BuyKnockback(ply)
		elseif( drug == "doubletap" ) then
			BuyDoubleTap(ply)
		elseif( drug == "focus" ) then
			BuyFocus(ply)
		
		elseif( drug == "health" ) then
			BuyHealth(ply)
		elseif( drug == "shield" ) then
			BuyShield(ply)
		elseif( drug == "helmet" ) then
			BuyHelmet(ply)
		elseif( drug == "scanner" ) then
			BuyScanner(ply)
		elseif( drug == "toolkit" ) then
			BuyToolKit(ply)
		elseif( drug == "armor" ) then
			BuyArmor(ply)
		end
	end
end
concommand.Add( "buydrug", ccBuyDrugs );
--------------------------------Start Batch

function ccBuyBatchDrugs( ply, command, args )
	local drug = args[1]
	if ply:GetTable().LastBuy+1.5<CurTime() then
		ply:GetTable().LastBuy=CurTime()
		if( drug == "steroid" ) then
			BuyBatchSteroid(ply)
		elseif( drug == "doublejump" ) then
			BuyBatchDoubleJump(ply)
		elseif( drug == "leech" ) then
			BuyBatchLeech(ply)
		elseif( drug == "amp" ) then
			BuyBatchAmp(ply)
		elseif( drug == "armorpiercer" ) then
			BuyBatchArmorpiercer(ply)
		
		elseif( drug == "regen" ) then
			BuyBatchRegen(ply)
		elseif( drug == "painkiller" ) then
			BuyBatchPainKiller(ply)
		elseif( drug == "antidote" ) then
			BuyBatchAntidote(ply)
		elseif( drug == "reflect" ) then
			BuyBatchReflect(ply)
		elseif( drug == "adrenaline" ) then
			BuyBatchAdrenaline(ply)
		
		elseif( drug == "magicbullet" ) then
			BuyBatchMagicBullet(ply)
		elseif( drug == "shockwave" ) then
			BuyBatchShockWave(ply)
		elseif( drug == "knockback" ) then
			BuyBatchKnockback(ply)
		elseif( drug == "doubletap" ) then
			BuyBatchDoubleTap(ply)
		elseif( drug == "focus" ) then
			BuyBatchFocus(ply)

		end
	end
end
concommand.Add( "buybatchdrug", ccBuyBatchDrugs );

--------------------------------End Batch
function ccBuyStructure( ply, command, args )
	local building = args[1]
	if ply:GetTable().LastBuy+1.5<CurTime() then
		ply:GetTable().LastBuy=CurTime()
		if( building == "sentry" ) then
			BuyTurret(ply)
		elseif( building == "spawn" ) then
			BuySpawn(ply)
		elseif( building == "dispenser" ) then
			BuyDispenser(ply)
		elseif( building == "microwave" ) then
			BuyMicrowave(ply)
		elseif( building == "radar" ) then
			BuyTower(ply)
		elseif( building == "refinery" ) then
			BuyRefinery(ply)
		elseif( building == "gunlab" ) then
			BuyGunlab(ply)
		elseif( building == "factory" ) then
			BuyGunFactory(ply)
		elseif( building == "plant" ) then
			BuyPlant(ply)
		elseif( building == "still" ) then
			BuyStill(ply)
		elseif( building == "druglab" ) then
			BuyDrug(ply)
		elseif( building == "methlab" ) then
			BuyMethlab(ply)
		elseif( building == "stablemethlab" ) then
			BuyStableMethLab(ply)
		elseif( building == "supplycabinet" ) then
			BuySupplyTable(ply)
--Printers
		elseif( building == "bronzeprinter" ) then
			BuyBronzePrinter(ply)
		elseif( building == "printer" ) then
			BuyPrinter(ply)
		elseif( building == "silverprinter" ) then
			BuySilverPrinter(ply)
		elseif( building == "goldprinter" ) then
			BuyGoldPrinter(ply)
		elseif( building == "platinumprinter" ) then
			BuyPlatinumPrinter(ply)
		elseif( building == "washingmachineprinter" ) then
			BuyWashingMachinePrinter(ply)
		elseif( building == "diamondprinter" ) then
			BuyDiamondPrinter(ply)
		elseif( building == "nuclearprinter" ) then
			BuyNuclearPrinter(ply)
--Printers
		elseif( building == "generator" ) then
			BuyGenerator(ply)
		elseif( building == "supergenerator" ) then
			BuySuperGenerator(ply)
		elseif( building == "moneyvault" ) then
			BuyMoneyVault(ply)
		end
	end
end
concommand.Add( "buystruct", ccBuyStructure );
		
function ccBuySpecial( ply, command, args )
	local building = args[1]
	if ply:GetTable().LastBuy+1.5<CurTime() then
		ply:GetTable().LastBuy=CurTime()
		if( building == "knife" ) then
			BuyKnife(ply)
		elseif( building == "pipebomb" ) then
			BuyPBomb(ply)
		elseif( building == "lockpick" ) then
			BuyLockPick(ply)
		elseif( building == "welder" ) then
			BuyWelder(ply)
		elseif( building == "bigbomb" ) then
			BuyBomb(ply)
		elseif( building == "airboat" ) then
			BuyAirboat(ply)
		elseif( building == "jeep" ) then
			BuyJeep(ply)
		elseif( building == "gunvault" ) then
			BuyGunvault(ply)
		elseif( building == "pillbox" ) then
			BuyPillBox(ply)
		elseif( building == "fueltank" ) then
			BuyIncedAmmo(ply)
		elseif( building == "bluefireworks" ) then
			BuyFireWorksBlue(ply)
		elseif( building == "greenfireworks" ) then
			BuyFireWorksGreen(ply)
		elseif( building == "redfireworks" ) then
			BuyFireWorksRed(ply)
		elseif( building == "purplefireworks" ) then
			BuyFireWorksPurple(ply)
		elseif( building == "donatorprinter" ) then
			BuyDonatorPrinter(ply)
		end
	end
end
concommand.Add( "buyspecial", ccBuySpecial );

// ive made this exact typo millions of times.
/*
function Curtime()
	return CurTime()
end
*/