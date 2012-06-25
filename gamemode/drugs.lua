
// Stun effect

function StunPlayer(pl, duration)
	pl:GetTable().Stunned = true
	pl:GetTable().StunDuration = pl:GetTable().StunDuration+duration
	if pl:GetTable().StunDuration>70 then pl:GetTable().StunDuration=70 end
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "STUN" , .2, pl:GetTable().StunDuration, CheckStun, pl)
	pl:ConCommand("pp_motionblur 1")
	pl:ConCommand("pp_motionblur_addalpha 0.1")
	pl:ConCommand("pp_motionblur_delay 0.035")
	local blindamount = pl:GetTable().StunDuration*0.025
	if blindamount>1 then blindamount = 1 end
	pl:ConCommand("pp_motionblur_drawalpha " .. (blindamount))
end

function CheckStun(pl)
	// Msg(tostring(pl:Nick()) .. " " .. tostring(pl:GetTable().StunDuration) .. "\n")
	pl:GetTable().StunDuration = pl:GetTable().StunDuration-1
	if pl:GetTable().Antidoted then
		pl:GetTable().StunDuration = pl:GetTable().StunDuration-3
	end
	local blindamount = pl:GetTable().StunDuration*0.035
	if blindamount>1 then blindamount = 1 end
	pl:ConCommand("pp_motionblur 1")
	pl:ConCommand("pp_motionblur_drawalpha " .. (blindamount))
	if (pl:GetTable().StunDuration>25) then
		pl:ViewPunch( Angle( (pl:GetTable().StunDuration-25)*((math.random()*0.2)-0.1), (pl:GetTable().StunDuration-25)*((math.random()*0.2)-0.1), (pl:GetTable().StunDuration-25)*((math.random()*0.1)-0.05) ) )
	end
	if (pl:GetTable().StunDuration<=0) then
		UnStun(pl)
		return
	end
end

function UnStun(pl)
	pl:GetTable().Stunned = false
	pl:GetTable().StunDuration = 0
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Destroy(IDSteam .. "STUN")
	pl:ConCommand("pp_motionblur 0")
end

// Burn effect

function BurnPlayer(pl, duration, attacker, inflictor)
	if ValidEntity(pl) then
		pl:SetNWBool("burned", true)
		pl:GetTable().Burned = true
		pl:GetTable().BurnAttacker = attacker
		pl:GetTable().BurnInflictor = inflictor
		if pl:GetTable().BurnDuration==nil then pl:GetTable().BurnDuration=0 end
		pl:GetTable().BurnDuration = pl:GetTable().BurnDuration+duration
		if pl:GetTable().BurnDuration>20 then pl:GetTable().BurnDuration=20 end
		if pl:GetTable().BurnDuration>=4 && !pl:IsOnFire() then
			pl:Ignite(pl:GetTable().BurnDuration,0)
		end
		local IDSteam = string.gsub(pl:SteamID(), ":", "")
		timer.Create( IDSteam .. "BURN" , 1, pl:GetTable().BurnDuration, CheckBurn, pl)
	end
end

function CheckBurn(pl)
	pl:GetTable().BurnDuration = pl:GetTable().BurnDuration-1
	// lol.
	if pl:GetTable().Antidoted then
		pl:GetTable().BurnDuration = pl:GetTable().BurnDuration-3
	end
	if pl:WaterLevel()>0 then
		pl:GetTable().BurnDuration=pl:GetTable().BurnDuration-pl:WaterLevel()
	end
	if pl:GetTable().BurnDuration<=2 && pl:IsOnFire() then
		pl:Extinguish()
	end
	pl:TakeDamage(math.ceil(pl:GetTable().BurnDuration/3), pl:GetTable().BurnAttacker, pl:GetTable().BurnInflictor)
	if (pl:GetTable().BurnDuration<=0) then
		UnBurn(pl)
		return
	end
end

function UnBurn(pl)
	pl:Extinguish()
	pl:SetNWBool("burned", false)
	pl:GetTable().Burned = false
	pl:GetTable().BurnDuration = 0
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Destroy(IDSteam .. "BURN")
end

// Poison effect

function PoisonPlayer(pl, duration, attacker, inflictor)
	if ValidEntity(pl) && pl:IsPlayer() then
		pl:SetNWBool("poisoned", true)
		pl:GetTable().Poisoned = true
		pl:GetTable().PoisonAttacker = attacker
		pl:GetTable().PoisonInflictor = inflictor
		if pl:GetTable().PoisonDuration==nil then pl:GetTable().PoisonDuration=0 end
		pl:GetTable().PoisonDuration = pl:GetTable().PoisonDuration+duration
		if pl:GetTable().PoisonDuration>60 then pl:GetTable().PoisonDuration=60 end
		pl:TakeDamage(math.ceil(pl:GetTable().PoisonDuration/8), pl:GetTable().PoisonAttacker, pl:GetTable().PoisonInflictor)
		local IDSteam = string.gsub(pl:SteamID(), ":", "")
		timer.Create( IDSteam .. "POISON" , 1, pl:GetTable().PoisonDuration, CheckPoison, pl)
	end
end

function CheckPoison(pl)
	pl:GetTable().PoisonDuration = pl:GetTable().PoisonDuration-1
	// lol.
	if pl:GetTable().Antidoted then
		pl:GetTable().PoisonDuration = pl:GetTable().PoisonDuration-5
	end
	pl:TakeDamage(math.ceil(pl:GetTable().PoisonDuration/8), pl:GetTable().PoisonAttacker, pl:GetTable().PoisonInflictor)
	//pl:ViewPunch( Angle( (pl:GetTable().PoisonDuration-25)*((math.random()*0.2)-0.1), (pl:GetTable().PoisonDuration-25)*((math.random()*0.2)-0.1), (pl:GetTable().PoisonDuration-25)*((math.random()*0.1)-0.05) ) )
	if (pl:GetTable().PoisonDuration<=0) then
		UnPoison(pl)
		return
	end
end
	
function UnPoison(pl)
	pl:SetNWBool("poisoned", false)
	pl:GetTable().Poisoned = false
	pl:GetTable().PoisonDuration = 0
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Destroy(IDSteam .. "POISON")
end


function Roidup(pl, duration)
	local time = duration or CfgVars["steroidduration"]
	// ok i know using gettable AND a NWBool is redundant, but it used to just use the gettable, and now that i want to add some clientside effects, i dont feel like going back and changing how everything works.
	pl:SetNWBool("roided", true)
	pl:GetTable().Roided = true
	pl:SetWalkSpeed(330-(pl:GetTable().StunDuration)*2)
	pl:SetRunSpeed(550-(pl:GetTable().StunDuration)*2.75)
	//pl:SetMaxHealth(pl:GetMaxHealth()*1.5)
	//pl:SetHealth(pl:Health()*1.5)
	Notify( pl, 3, 3, "You have taken steroids" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "ROID" , time, 1, UnRoidup, pl)
	pl:CheckOverdose()
end

function UnRoidup(pl)
	pl:SetNWBool("roided", false)
	pl:GetTable().Roided = false
	Notify( pl, 3, 3, "Steroids wore off" );
	pl:SetWalkSpeed(100)
	pl:SetRunSpeed(90)
end

// Superdrug

function Superup(pl, duration, type)
	local time = duration or CfgVars["superduration"]
	// ok i know using gettable AND a NWBool is redundant, but it used to just use the gettable, and now that i want to add some clientside effects, i dont feel like going back and changing how everything works.
	pl:GetTable()["Superdrug"..type] = true
	Notify( pl, 3, 3, "You have taken superdrug "..type );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "SUPERDRUG"..string.upper(type) , time, 1, UnSuperup, pl, type)
	pl:CheckOverdose()
end

function UnSuperup(pl, type)
	pl:GetTable()["Superdrug"..type] = false
	Notify( pl, 3, 3, "Superdrug "..type.." wore off" );
end

// Randomdrug

function Randup(ply, time)
	if ply:GetTable().Regened && ply:GetTable().Roided && ply:GetTable().MagicBulleted && ply:GetTable().Amp && ply:GetTable().Painkillered && ply:GetTable().Antidoted && ply:GetTable().Mirror && ply:GetTable().Focus && ply:GetTable().Adrenalined && ply:GetTable().DoubleJumped && ply:GetTable().ShockWaved && ply:GetTable().DoubleTapped && ply:GetTable().Leeched && ply:GetTable().KnockBacked && ply:GetTable().ArmorPiercered then
		return
	end
	local gaveadrug = false
	local i=0
	local duration = time or CfgVars["randomduration"]
	while !gaveadrug && i<50 do
		i=i+1
		local rand = math.random(1,15)
		gaveadrug = true
		if (ply:GetTable().Regened != true && rand==1) then
			Regenup(ply, duration)
		elseif (ply:GetTable().Roided != true && rand==2) then
			Roidup(ply, duration)
		elseif (ply:GetTable().MagicBulleted != true && rand==3) then
			MagicBulletup(ply, duration)
		elseif (ply:GetTable().Amp != true && rand==4) then
			Ampup(ply, duration)
		elseif (ply:GetTable().PainKillered != true && rand==5) then
			PainKillerup(ply, duration)
		elseif (ply:GetTable().Antidoted != true && rand==6) then
			Antidoteup(ply, duration)
		elseif (ply:GetTable().Mirror != true && rand==7) then
			Mirrorup(ply, duration)
		elseif (ply:GetTable().Focus != true && rand==8) then
			Focusup(ply, duration)
		elseif (ply:GetTable().Adrenalined != true && rand==9) then
			Adrenalineup(ply, duration)
		elseif (ply:GetTable().DoubleJumped != true && rand==10) then
			DoubleJumpup(ply, duration)
		elseif (ply:GetTable().ShockWaved != true && rand==11) then
			ShockWaveup(ply, duration)
		elseif (ply:GetTable().DoubleTapped != true && rand==12) then
			DoubleTapup(ply, duration)
		elseif (ply:GetTable().Leeched != true && rand==13) then
			Leechup(ply, duration)
		elseif (ply:GetTable().Knockbacked != true && rand==14) then
			Knockbackup(ply, duration)
		elseif (ply:GetTable().ArmorPiercered != true && rand==15) then
			ArmorPiercerup(ply, duration)
		else
			gaveadrug = false
		end
	end
end

// Regeneration

function Regenup(pl, duration)
	local time = duration or CfgVars["regenduration"]
	pl:SetNWBool("regened", true)
	pl:GetTable().Regened = true
	Notify( pl, 3, 3, "You have regeneration" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "REGEN" , time, 1, UnRegenup, pl)
	timer.Create( IDSteam .. "REGENTICK" , 1, time, Regentick, pl)
	pl:CheckOverdose()
end

function Regentick(pl)
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	if (!pl:GetTable().Regened || pl:Health()<=0) then
		timer.Destroy(IDSteam .. "REGENTICK")
		return "";
	end
	if (pl:Health()<pl:GetMaxHealth()) then
		pl:SetHealth(pl:Health()+4)
		if (pl:Health()>pl:GetMaxHealth()) then pl:SetHealth(pl:GetMaxHealth()) end
	elseif (pl:Armor()<100) then
		pl:SetArmor(pl:Armor()+2)
		if (pl:Armor()>100) then pl:SetArmor(100) end
	end
end

function UnRegenup(pl)
	pl:SetNWBool("regened", false)
	pl:GetTable().Regened = false
	Notify( pl, 3, 3, "regeneration wore off" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Destroy(IDSteam .. "REGENTICK")
end

// Snipe Shield

function UnShield(ply)
	ply:GetTable().Shieldon = false
	ply:SetNWBool("shielded", false)
end

// Helmet

function UnHelmet(ply)
	ply:SetNWBool("helmeted", false)
end

// Pain killers

function PainKillerup(pl, duration)
	local time = duration or CfgVars["painkillerduration"]
	pl:SetNWBool("painkillered", true)
	pl:GetTable().PainKillered = true
	Notify( pl, 3, 3, "You have taken Pain Killers" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "PAINKILLER" , time, 1, UnPainKillerup, pl)
	pl:CheckOverdose()
end

function UnPainKillerup(pl)
	pl:SetNWBool("painkillered", false)
	pl:GetTable().PainKillered = false
	Notify( pl, 3, 3, "Pain Killers wore off" );
end

// Armor Piercer

function ArmorPiercerup(pl, duration)
	local time = duration or CfgVars["armorpiercerduration"]
	pl:SetNWBool("armorpiercered", true)
	pl:GetTable().ArmorPiercered = true
	Notify( pl, 3, 3, "You have taken Armor Piercer" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "ARMORPIERCER" , time, 1, UnArmorPiercerup, pl)
	pl:CheckOverdose()
end

function UnArmorPiercerup(pl)
	pl:SetNWBool("armorpiercered", false)
	pl:GetTable().ArmorPiercered = false
	Notify( pl, 3, 3, "Armor Piercer wore off" );
end

// Magic Bullet

function MagicBulletup(pl, duration)
	local time = duration or CfgVars["magicbulletduration"]
	pl:SetNWBool("magicbulleted", true)
	pl:GetTable().MagicBulleted = true
	Notify( pl, 3, 3, "You have taken Magic Bullet" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "MAGICBULLET" , time, 1, UnMagicBulletup, pl)
	pl:CheckOverdose()
end

function UnMagicBulletup(pl)
	pl:SetNWBool("magicbulleted", false)
	pl:GetTable().MagicBulleted = false
	Notify( pl, 3, 3, "Magic Bullet wore off" );
end

// Knockback

function Knockbackup(pl, duration)
	local time = duration or CfgVars["knockbackduration"]
	pl:SetNWBool("knockbacked", true)
	pl:GetTable().Knockbacked = true
	Notify( pl, 3, 3, "You have taken Knockback" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "KNOCKBACK" , time, 1, UnKnockbackup, pl)
	pl:CheckOverdose()
end

function UnKnockbackup(pl)
	pl:SetNWBool("knockbacked", false)
	pl:GetTable().Knockbacked = false
	Notify( pl, 3, 3, "Knockback wore off" );
end

// Leech

function Leechup(pl, duration)
	local time = duration or CfgVars["leechduration"]
	pl:SetNWBool("leeched", true)
	pl:GetTable().Leeched = true
	Notify( pl, 3, 3, "You have taken Leech" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "LEECH" , time, 1, UnLeechup, pl)
	pl:CheckOverdose()
end

function UnLeechup(pl)
	pl:SetNWBool("leeched", false)
	pl:GetTable().Leeched = false
	Notify( pl, 3, 3, "Leech wore off" );
end

// Shock Wave

function ShockWaveup(pl, duration)
	local time = duration or CfgVars["shockwaveduration"]
	pl:SetNWBool("shockwaved", true)
	pl:GetTable().ShockWaved = true
	Notify( pl, 3, 3, "You have taken Shock Wave" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "SHOCKWAVE" , time, 1, UnShockWaveup, pl)
	pl:CheckOverdose()
end

function UnShockWaveup(pl)
	pl:SetNWBool("shockwaved", false)
	pl:GetTable().ShockWaved = false
	Notify( pl, 3, 3, "Shock Wave wore off" );
end

// Double Tap

function DoubleTapup(pl, duration)
	local time = duration or CfgVars["doubletapduration"]
	pl:SetNWBool("doubletapped", true)
	pl:GetTable().DoubleTapped = true
	Notify( pl, 3, 3, "You have taken Double Tap" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "DOUBLETAP" , time, 1, UnDoubleTapup, pl)
	pl:CheckOverdose()
end

function UnDoubleTapup(pl)
	pl:SetNWBool("doubletapped", false)
	pl:GetTable().DoubleTapped = false
	Notify( pl, 3, 3, "Double Tap wore off" );
end

// Amplifier

function Ampup(pl, duration)
	local time = duration or CfgVars["ampduration"]
	pl:SetNWBool("amped", true)
	pl:GetTable().Amp = true
	Notify( pl, 3, 3, "You have used Amplifier" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "AMP" , time, 1, UnAmpup, pl)
	pl:CheckOverdose()
end

function UnAmpup(pl)
	pl:SetNWBool("amped", false)
	pl:GetTable().Amp = false
	Notify( pl, 3, 3, "Amplifier wore off" );
end

// Reflect

function Mirrorup(pl, duration)
	local time = duration or CfgVars["reflectduration"]
	pl:SetNWBool("mirrored", true)
	pl:GetTable().Mirror = true
	Notify( pl, 3, 3, "You have Reflect" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "MIRROR" , time, 1, UnMirrorup, pl)
	pl:CheckOverdose()
end

function UnMirrorup(pl)
	pl:SetNWBool("mirrored", false)
	pl:GetTable().Mirror = false
	Notify( pl, 3, 3, "Reflect wore off" );
end

// Focus

function Focusup(pl, duration)
	local time = duration or CfgVars["focusduration"]
	pl:SetNWBool("focused", true)
	pl:GetTable().Focus = true
	Notify( pl, 3, 3, "You used Focus" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "FOCUS" , time, 1, UnFocusup, pl)
	pl:CheckOverdose()
end

function UnFocusup(pl)
	pl:SetNWBool("focused", false)
	pl:GetTable().Focus = false
	Notify( pl, 3, 3, "Focus wore off." );
end

// Antidote

function Antidoteup(pl, duration)
	local time = duration or CfgVars["antidoteduration"]
	// double lol.
	pl:SetNWBool("antidoted", true)
	pl:GetTable().Antidoted = true
	Notify( pl, 3, 3, "You have taken antidote" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "ANTIDOTE" , time, 1, UnAntidoteup, pl)
	pl:CheckOverdose()
end

function UnAntidoteup(pl)
	// double lol.
	pl:SetNWBool("antidoted", false)
	pl:GetTable().Antidoted = false
	Notify( pl, 3, 3, "Antidote wore off." );
end

// Adrenaline

function Adrenalineup(pl, duration)
	// prevent the effect from stacking
	if pl:GetTable().Adrenalined==true then
		pl:SetMaxHealth(pl:GetMaxHealth()/1.5)
		pl:SetHealth(pl:Health()/1.5)
	end
	local time = duration or CfgVars["adrenalineduration"]
	pl:SetNWBool("adrenalined", true)
	pl:GetTable().Adrenalined = true
	pl:SetMaxHealth(pl:GetMaxHealth()*1.5)
	pl:SetHealth(pl:Health()*1.5)
	Notify( pl, 3, 3, "You have taken adrenaline" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "ADRENALINE" , time, 1, UnAdrenalineup, pl)
	pl:CheckOverdose()
end

function UnAdrenalineup(pl)
	pl:SetNWBool("adrenalined", false)
	pl:GetTable().Adrenalined = false
	Notify( pl, 3, 3, "Adrenaline wore off" );
	if pl:Health()!=0 && pl:GetMaxHealth()!=0 then
		pl:SetMaxHealth(pl:GetMaxHealth()/1.5)
		pl:SetHealth(pl:Health()/1.5)
	end
end

// Double Jump

function DoubleJumpup(pl, duration)
	local time = duration or CfgVars["doublejumpduration"]
	pl:SetNWBool("doublejumped", true)
	pl:GetTable().DoubleJumped = true
	Notify( pl, 3, 3, "You used Double Jump" );
	local IDSteam = string.gsub(pl:SteamID(), ":", "")
	timer.Create( IDSteam .. "DOUBLEJUMP" , time, 1, UnDoubleJumpup, pl)
	pl:CheckOverdose()
end

function UnDoubleJumpup(pl)
	pl:SetNWBool("doublejumped", false)
	pl:GetTable().DoubleJumped = false
	Notify( pl, 3, 3, "Double Jump wore off." );
end