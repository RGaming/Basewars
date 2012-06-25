/*---------------------------------------------------------
  ChatCommand system
---------------------------------------------------------*/
--GMS.ChatCommands = {}
--function GMS.RegisterChatCmd( cmd, tbl )
--    GMS.ChatCommands[cmd] = tbl
--end
--
--function GMS.RunChatCmd( ply, ... )
--	if # arg > 0 and GMS.ChatCommands[ arg[1] ] != nil then
--			local cmd = arg[1]
--			table.remove( arg, 1)
--			GMS.ChatCommands[cmd]:Run( ply, unpack( arg ) )
--			return ""
--	end
--end


----------------------------------------------------------------
function ccSWEPSpawn( ply, cmd, args )

	
		if( not Admins[ply:SteamID()] and not ply:IsAdmin() and not ply:IsSuperAdmin() ) then
			Notify( ply, 4, 2, "Admin-Only!" );
			return;
		end
	
	PrintMessageAll(HUD_PRINTCONSOLE,ply:GetName().." spawned weapon "..args[1].."\n")
	CCSpawnSWEP( ply, cmd, args );

end
concommand.Add( "gm_giveswep", ccSWEPSpawn );
concommand.Add( "gm_spawnswep", ccSWEPSpawn );

function ccSENTSPawn( ply, cmd, args )

	
		if( not Admins[ply:SteamID()] and not ply:IsAdmin() and not ply:IsSuperAdmin() ) then
			Notify( ply, 4, 2, "Admin-Only!" );
			return;
		end
	

	CCSpawnSENT( ply, cmd, args );

end
concommand.Add( "gm_spawnsent", ccSENTSPawn )

function Magnet( pl, pos, angle, model, material, key, maxobjects, strength, nopull, allowrot, alwayson, toggle, Vel, aVel, frozen )
	if ( !gamemode.Call( "PlayerSpawnMagnet", pl, Model ) ) then return end
	local magnet = ents.Create("phys_magnet")
	magnet:SetPos(pos)
	magnet:SetAngles(angle)
	magnet:SetModel( model )
	magnet:SetMaterial( material )
				
	local spawnflags = 4
	if (nopull > 0) then		spawnflags = spawnflags - 4		end		// no pull required: remove the suck flag
	if (allowrot > 0) then		spawnflags = spawnflags + 8		end
				
	magnet:SetKeyValue( "maxobjects", maxobjects )
	magnet:SetKeyValue( "forcelimit", strength )
	magnet:SetKeyValue( "spawnflags", spawnflags )
	magnet:SetKeyValue( "overridescript", "surfaceprop,metal")
	magnet:SetKeyValue( "massScale", 0 )
	
	magnet:Activate()
	magnet:Spawn()
	
	if magnet:GetPhysicsObject():IsValid() then
		Phys = magnet:GetPhysicsObject()
		if Vel then Phys:SetVelocity(Vel) end
		if Vel then Phys:AddAngleVelocity(aVel) end
		Phys:EnableMotion(frozen != true)
	end

	if (alwayson > 0) then
		magnet:Input("TurnOn", nil, nil, nil)
	else
		magnet:Input("TurnOff", nil, nil, nil)
	end
	
	local mtable = {
		model = model,
		material = material,
		key = key,
		maxobjects = maxobjects,
		strength = strength,
		nopull = nopull,
		allowrot = allowrot,
		alwayson = alwayson,
		toggle = toggle
	}
	
	magnet:SetTable( mtable )
	
	numpad.OnDown( 	 pl, 	key, 	"MagnetOn", 	magnet )
	numpad.OnUp( 	 pl, 	key, 	"MagnetOff", 	magnet )
	
	gamemode.Call( "PlayerSpawnedMagnet", pl, model, magnet )
	return magnet
	
end
	
duplicator.RegisterEntityClass( "phys_magnet", Magnet, "pos", "angle", "model", "material", "key", "maxobjects", "strength", "nopull", "allowrot", "alwayson", "toggle", "Vel", "aVel", "frozen" )
