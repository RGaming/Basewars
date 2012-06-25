--if there's no CPPI thing then make it
CPPI = CPPI or {}
CPPI.CPPI_DEFER = 102112 --\102\112 = fp
CPPI.CPPI_NOTIMPLEMENTED = 7080// FP

function CPPI:GetName()
	return "Falco's prop protection"
end

function CPPI:GetVersion()
	return "addon.1"
end

function CPPI:GetInterfaceVersion()
	return 1.1
end

function CPPI:GetNameFromUID(uid)
	return CPPI.CPPI_NOTIMPLEMENTED
end

local PLAYER = FindMetaTable("Player")
function PLAYER:CPPIGetFriends()
	return self.Buddies or CPPI.CPPI_DEFER
end

local ENTITY = FindMetaTable("Entity")
function ENTITY:CPPIGetOwner()
	if not ValidEntity(self.Owner) then return nil, CPPI.CPPI_NOTIMPLEMENTED end
	return self.Owner, self.Owner:UniqueID()
end

if SERVER then
	function ENTITY:CPPISetOwner(ply)
		self.Owner = ply
		return true
	end

	function ENTITY:CPPISetOwnerUID(UID)
		local ply = player.GetByUniqueID(tostring(UID))
		if self.Owner and ply:IsValid() then
			if self.AllowedPlayers then
				table.insert(self.AllowedPlayers, ply)
			else
				self.AllowedPlayers = {ply}
			end
			return true
		elseif ply:IsValid() then
			self.Owner = ply
			return true
		end
		return false
	end
	
	function ENTITY:CPPICanTool(ply, tool)
		local trace = ply:GetEyeTrace()
		return FPP.Protect.CanTool(ply, trace, tool, self) -- fourth argument is entity, to avoid traces.
	end
	
	function ENTITY:CPPICanPhysgun(ply)
		return FPP.PlayerCanTouchEnt(ply, self, "Physgun", "FPP_PHYSGUN")
	end
	
	function ENTITY:CPPICanPickup(ply)
		return FPP.PlayerCanTouchEnt(ply, self, "Gravgun", "FPP_GRAVGUN")
	end
	
	function ENTITY:CPPICanPunt(ply)
		return FPP.PlayerCanTouchEnt(ply, self, "Gravgun", "FPP_GRAVGUN")
	end 
end