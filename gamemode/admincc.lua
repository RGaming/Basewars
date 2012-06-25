qValueCmds = { }
function AddValueCommand( cmd, cfgvar, global )

	ValueCmds[cmd] = { var = cfgvar, global = global };
	
	concommand.Add( cmd, ccValueCommand );
	
end
function ccValueCommand( ply, cmd, args )

	local valuecmd = ValueCmds[cmd];

	if( not valuecmd ) then return; end
	
	if( #args < 1 ) then
		if( valuecmd.global ) then
			if( ply:EntIndex() == 0 ) then
				Msg( cmd .. " = " .. GetGlobalInt( valuecmd.var ) );
			else
				ply:PrintMessage( 2, cmd .. " = " .. GetGlobalInt( valuecmd.var ) );
			end
		else
			if( ply:EntIndex() == 0 ) then
				Msg( cmd .. " = " .. CfgVars[valuecmd.var] );
			else
				ply:PrintMessage( 2, cmd .. " = " .. CfgVars[valuecmd.var] );
			end
		end
		return;
	end

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local amount = tonumber( args[1] );
	
	if( valuecmd.global ) then
		SetGlobalInt( valuecmd.var, amount );
	else
		CfgVars[valuecmd.var] = amount;
	end
	
	local nick = "";
	
	if( ply:EntIndex() == 0 ) then
		nick = "Console";
	else
		nick = ply:Nick();
	end
	
	NotifyAll( 0, 3, nick .. " set " .. cmd .. " to " .. amount );

end

ToggleCmds = { }
function AddToggleCommand( cmd, cfgvar, global )

	ToggleCmds[cmd] = { var = cfgvar, global = global };
	
	concommand.Add( cmd, ccToggleCommand );
	
end
function ccToggleCommand( ply, cmd, args )

	local togglecmd = ToggleCmds[cmd];

	if( not togglecmd ) then return; end
	
	if( #args < 1 ) then
		if( togglecmd.global ) then
			if( ply:EntIndex() == 0 ) then
				Msg( cmd .. " = " .. GetGlobalInt( togglecmd.var ) );
			else
				ply:PrintMessage( 2, cmd .. " = " .. GetGlobalInt( togglecmd.var ) );
			end
		else
			if( ply:EntIndex() == 0 ) then
				Msg( cmd .. " = " .. CfgVars[togglecmd.var] );
			else
				ply:PrintMessage( 2, cmd .. " = " .. CfgVars[togglecmd.var] );
			end
		end
		return;
	end

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local toggle = tonumber( args[1] );
	
	if( not toggle or ( toggle ~= 1 and toggle ~= 0 ) ) then
		if( ply:EntIndex() == 0 ) then
			Msg( "Invalid number.  Must be 1 or 0." );
		else
			ply:PrintMessage( 2, "Invalid number.  Must be 1 or 0." );
		end
		return; 
	end
	
	if( togglecmd.global ) then
		SetGlobalInt( togglecmd.var, toggle );
	else
		CfgVars[togglecmd.var] = toggle;
	end
	
	local nick = "";
	
	if( ply:EntIndex() == 0 ) then
		nick = "Console";
	else
		nick = ply:Nick();
	end
	
	NotifyAll( 3, 3, nick .. " set " .. cmd .. " to " .. toggle );

end

--------------------------------------------------------------------------------------------------
--Cfg Var Toggling
--------------------------------------------------------------------------------------------------

-- Usage of AddToggleCommand
-- ( command name,  cfg variable name, is it a global variable or a cfg variable? )

--------------------------------------------------------------------------------------------------
--------

function ccTell( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local target = FindPlayer( args[1] );
	
	if( target ) then
	
		local msg = "";
		
		for n = 2, #args do
		
			msg = msg .. args[n] .. " ";
		
		end
	
		umsg.Start( "AdminTell", target );
			umsg.String( msg );
		umsg.End();
	
	else
	
		if( ply:EntIndex() == 0 ) then
			Msg( "Could not find player: " .. args[1] );
		else
			ply:PrintMessage( 2, "Could not find player: " .. args[1] );
		end
	end

end
concommand.Add( "rp_tell", ccTell );

function ccSetChatCmdPrefix( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local oldprefix = GetGlobalString( "cmdprefix" );
	SetGlobalString( "cmdprefix", args[1] );
	
	if( ply:EntIndex() == 0 ) then
		nick = "Console";
	else
		nick = ply:Nick();
	end
	
	NotifyAll( 0, 3, nick .. " set rp_chatprefix to " .. args[1] );
	
	GenerateChatCommandHelp();
	
	for k, v in pairs( ChatCommands ) do
	
		if( not v.prefixconst ) then
			v.cmd = string.gsub( v.cmd, oldprefix, args[1] );
		end
	
	end
	
	umsg.Start( "UpdateHelp" ); umsg.End();

end
concommand.Add( "rp_chatprefix", ccSetChatCmdPrefix );

function ccPayDayTime( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local amount = tonumber( args[1] );
	
	if( not amount ) then return; end
	
	CfgVars["paydelay"] = amount;
	
	for k, v in pairs( player.GetAll() ) do
	
		v:UpdateJob( v:GetNWString( "job" ) );
	
	end
	
	if( ply:EntIndex() == 0 ) then
		nick = "Console";
	else
		nick = ply:Nick();
	end
	
	NotifyAll( 3, 3, nick .. " set rp_paydaytime to " .. amount );

end
concommand.Add( "rp_paydaytime", ccPayDayTime );

function ccArrest( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local target = FindPlayer( args[1] );
	
	if( target ) then
	
		target:Arrest();
		
	else
	
		if( ply:EntIndex() == 0 ) then
			Msg( "Did not find player: " .. args[1] );
		else
			ply:PrintMessage( 2, "Did not find player: " .. args[1] );
		end
		return;
	
	end

end
concommand.Add( "rp_arrest", ccArrest );

function ccUnarrest( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local target = FindPlayer( args[1] );
	
	if( target ) then
	
		target:Unarrest();
		
	else
	
		if( ply:EntIndex() == 0 ) then
			Msg( "Did not find player: " .. args[1] );
		else
			ply:PrintMessage( 2, "Did not find player: " .. args[1] );
		end
		return;
	
	end

end
concommand.Add( "rp_unarrest", ccUnarrest );

function ccMayor( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local target = FindPlayer( args[1] );
	
	if( target ) then
	
		target:SetTeam( 3 );
		target:UpdateJob( "Mayor" );
		target:KillSilent();
		
		local nick = "";
		
		if( ply:EntIndex() ~= 0 ) then
			nick = ply:Nick();
		else
			nick = "Console";
		end
		
		target:PrintMessage( 2, nick .. " made you Mayor" );
		
	else
	
		if( ply:EntIndex() == 0 ) then
			Msg( "Did not find player: " .. args[1] );
		else
			ply:PrintMessage( 2, "Did not find player: " .. args[1] );
		end
		
		return;
	
	end

end
concommand.Add( "rp_mayor", ccMayor );

// lol.
function ccCP( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local target = FindPlayer( args[1] );
	
	if( target ) then
	
		target:SetTeam( 2 );
		target:UpdateJob( "Civil Protection" );
		target:KillSilent();
		
		if( ply:EntIndex() ~= 0 ) then
			nick = ply:Nick();
		else
			nick = "Console";
		end
		
		target:PrintMessage( 2, nick .. " made you a CP" );
		
	else
	
		if( ply:EntIndex() == 0 ) then
			Msg( "Did not find player: " .. args[1] );
		else
			ply:PrintMessage( 2, "Did not find player: " .. args[1] );
		end
		
		return;
	
	end

end
concommand.Add( "rp_cp", ccCP );

function ccPoison( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local target = FindPlayer( args[1] );
	
	if( target ) then
	
		PoisonPlayer(target,tonumber(args[2]),ply,ply)
		
		if( ply:EntIndex() ~= 0 ) then
			nick = ply:Nick();
		else
			nick = "Console";
		end
		
		target:PrintMessage( 2, nick .. " poisoned you." );
		
	else
	
		if( ply:EntIndex() == 0 ) then
			Msg( "Did not find player: " .. args[1] );
		else
			ply:PrintMessage( 2, "Did not find player: " .. args[1] );
		end
		
		return;
	
	end

end
concommand.Add( "rp_poison", ccPoison );

function ccStun( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local target = FindPlayer( args[1] );
	
	if( target ) then
	
		StunPlayer(target,tonumber(args[2]),ply,ply)
		
		if( ply:EntIndex() ~= 0 ) then
			nick = ply:Nick();
		else
			nick = "Console";
		end
		
		target:PrintMessage( 2, nick .. " stun you." );
		
	else
	
		if( ply:EntIndex() == 0 ) then
			Msg( "Did not find player: " .. args[1] );
		else
			ply:PrintMessage( 2, "Did not find player: " .. args[1] );
		end
		
		return;
	
	end

end
concommand.Add( "rp_stun", ccStun );

function ccCitizen( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local target = FindPlayer( args[1] );
	
	if( target ) then
	
		target:SetTeam( 1 );
		target:UpdateJob( "Citizen" );
		target:KillSilent();
		
		if( ply:EntIndex() ~= 0 ) then
			nick = ply:Nick();
		else
			nick = "Console";
		end
		
		target:PrintMessage( 2, nick .. " made you a citizen" );
		
	else
	
		if( ply:EntIndex() == 0 ) then
			Msg( "Did not find player: " .. args[1] );
		else
			ply:PrintMessage( 2, "Did not find player: " .. args[1] );
		end
		
		return;
	
	end

end
concommand.Add( "rp_citizen", ccCitizen );

function ccKickBan( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local target = FindPlayer( args[1] );
	
	if( target ) then
	
		if( not args[2] ) then
			args[2] = 0;
		end
	
		game.ConsoleCommand( "banid " .. args[2] .. " " .. target:UserID() .. "\n" );
		game.ConsoleCommand( "kickid " .. target:UserID() .. " \"Kicked and Banned\"\n" );
		
	else
	
		if( ply:EntIndex() == 0 ) then
			Msg( "Did not find player: " .. args[1] );
		else
			ply:PrintMessage( 2, "Did not find player: " .. args[1] );
		end
		return;
	
	end

end
concommand.Add( "rp_kickban", ccKickBan );
// i don't trust people.
/*
function ccRcon( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local command = "";
		
	for n = 1, #args do
		
		command = command .. " " .. args[n];
		
	end
		
	game.ConsoleCommand( command .. "\n" );

end
concommand.Add( "rp_rcon", ccRcon );
*/
function ccKick( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end

	local target = FindPlayer( args[1] );
	
	if( target ) then
	
		local reason = "";
		
		if( args[2] ) then
		
			for n = 2, #args do
			
				reason = reason .. args[n];
				reason = reason .. " ";
				
			end
			
		end
		
		game.ConsoleCommand( "kickid " .. target:UserID() .. " \"" .. reason .. "\"\n" );
		
	else
	
		if( ply:EntIndex() == 0 ) then
			Msg( "Did not find player: " .. args[1] );
		else
			ply:PrintMessage( 2, "Did not find player: " .. args[1] );
		end
		return;
	
	end

end
concommand.Add( "rp_kick", ccKick );

function ccSetMoney( ply, cmd, args )

	ply:PrintMessage( 2, "This command has been deleted and disabled. Cut that shit out." );
	return;

end
concommand.Add( "rp_setmoney", ccSetMoney );

function ccSetCfgVar(ply,cmd,args)
	if( ply:EntIndex() ~= 0 and not Admins[ply:SteamID()] ) then 
		ply:PrintMessage( 2, "You're not an admin" );
		return;
	end
	local var = args[1]
	if var == "allowarmor" then var = "hltvproxywashere" end
	local num = tonumber(args[2])
	if var && num then
		if CfgVars[var]==nil then
			Notify(ply, 4, 3, "That is not a valid var")
			return
		else
			CfgVars[var]=num
			local lol = var
			if lol=="hltvproxywashere" then lol = "allowarmor" end
			NotifyAll(3,3, ply:GetName() .. " has set " .. tostring(lol) .. " to " .. tostring(num))
		end
	else
		if CfgVars[var]==nil then
			Notify(ply, 4, 3, "That is not a valid var")
			return
		else
			local lol = var
			if lol=="hltvproxywashere" then lol = "allowarmor" end
			Notify(ply,3,3, tostring(lol) .. "=" .. tostring(CfgVars[var]))
		end
	end
end

concommand.Add( "rp_setvar", ccSetCfgVar );
