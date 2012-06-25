
ChatCommands = { }

--Usage:
--Chat command, Callback, Should the prefix stay constant?
function AddChatCommand( cmd, callback, prefixconst )

	table.insert( ChatCommands, { cmd = cmd, callback = callback, prefixconst = prefixconst } );

end

function GM:PlayerSay( ply, text )
	ply:ClearAFK()
	self.BaseClass:PlayerSay( ply, text );

	local ftext = string.lower( text );
	
	for k, v in pairs( ChatCommands ) do
	
		local endpos = string.len( v.cmd )+1;
		bump = false
		if string.len(ftext)<endpos then endpos = endpos-1 bump=true end
		local strcmd = string.sub( ftext, 1, endpos );

		local argstart = 1;
		
		if( string.sub( text, endpos , endpos  ) == " " ) then
			argstart = 2;
		end
		
		if(strcmd == v.cmd.." " && !bump) then
			return v.callback( ply, string.sub( text, string.len( v.cmd ) + argstart ) or "" )
		elseif (strcmd==v.cmd && bump) then
			return v.callback( ply, string.sub( text, string.len( v.cmd ) + argstart ) or "" );
			
		end
	
	end

	return text;
end
