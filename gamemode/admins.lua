

--Fuck file parsing for this.
Admins = { }
Mayor = { }
CP = { }
Tool = { }
Phys = { }
function AddAdmin( steamid )
	Admins[steamid] = { }
end
function AddMayor( steamid )
	Mayor[steamid] = { }
end
function AddCP( steamid )
	CP[steamid] = { }
end
function AddTool( steamid )
	Tool[steamid] = { }
end
function AddPhys( steamid )
	Phys[steamid] = { }
end
-------------------------------------
-- IGNORE EVERYTHING ABOVE THIS 
-------------------------------------

-------------------------------------
-- ADD ADMINS, MAYORS, AND CPS BELOW!
-------------------------------------
-- HOW TO ADD AN ADMIN:
-- AddAdmin( steamid )

-- HOW TO ADD A MAYOR
-- AddMayor( steamid )

-- HOW TO ADD A CP
-- AddCP( steamid )

--A STEAMID LOOKS LIKE THIS:
-- STEAM_0:1:3903209

-- HOW TO GET A STEAM ID:
-- 1. JOIN AN INTERNET SERVER (NOT YOURS, UNLESS IT IS DEDICATED AND NON LAN)
-- 2. TYPE status IN CONSOLE
-- 3. IT WILL LIST STEAMIDS


--EXAMPLE:

--AddAdmin( "" );
--AddMayor( "" );
--AddCP( "" );
--AddTool( "" );
--AddPhys( "" );