
include('shared.lua')

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

/*---------------------------------------------------------
   Console command to switch to camera
---------------------------------------------------------*/
function CC_GMOD_Camera( player, command, arguments )
	player:SelectWeapon( "gmod_camera" )
end
concommand.Add( "gmod_camera", CC_GMOD_Camera )


function SWEP:Deploy()

	self.Owner:DrawViewModel( false )

end


/*---------------------------------------------------------
   
---------------------------------------------------------*/
function SWEP:DoRotateThink()

end


/*---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
---------------------------------------------------------*/
function SWEP:ShouldDropOnDie()
	return false
end
