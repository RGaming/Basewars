-- These are the default settings. Don't mind changing these.
FPP = FPP or {}
FPP.Settings = {}
FPP.Settings.FPP_PHYSGUN = {
	toggle = 1,
	adminall = 1,
	worldprops = 1, 
	adminworldprops = 1,
	canblocked = 0,
	admincanblocked = 0,
	shownocross = 1,
	checkconstrained = 1,
	antinoob = 0,
	reloadprotection = 1,
	iswhitelist = 0}
FPP.Settings.FPP_GRAVGUN = {
	toggle = 1,
	adminall = 1,
	worldprops = 1, 
	adminworldprops = 1,
	canblocked = 0,
	admincanblocked = 0,
	shownocross = 1,
	checkconstrained = 1,
	noshooting = 1,
	iswhitelist = 0}
FPP.Settings.FPP_TOOLGUN = {
	toggle = 1,
	adminall = 1,
	worldprops = 0, 
	adminworldprops = 0,
	canblocked = 0,
	admincanblocked = 0,
	shownocross = 1,
	checkconstrained = 1,
	iswhitelist = 0,
	
	duplicatorprotect = 1,
	duplicatenoweapons = 1,
	spawniswhitelist = 0,
	spawnadmincanweapon = 0,
	spawnadmincanblocked = 0}
FPP.Settings.FPP_PLAYERUSE = {
	toggle = 0,
	adminall = 1,
	worldprops = 1, 
	adminworldprops = 1,
	canblocked = 0,
	admincanblocked = 1,
	shownocross = 1,
	checkconstrained = 0,
	iswhitelist = 0}
FPP.Settings.FPP_ENTITYDAMAGE = {
	toggle = 0,
	protectpropdamage = 1,
	adminall = 1,
	worldprops = 1, 
	adminworldprops = 1,
	canblocked = 0,
	admincanblocked = 0,
	shownocross = 1,
	checkconstrained = 0,
	iswhitelist = 0}
FPP.Settings.FPP_GLOBALSETTINGS = {
	cleanupdisconnected = 1,
	cleanupdisconnectedtime = 30,
	cleanupadmin = 1,
	antispeedhack = 0}
FPP.Settings.FPP_ANTISPAM = {
	toggle = 1,
	antispawninprop = 0,
	bigpropsize = 5.85,
	bigpropwait = 1.5,
	smallpropdowngradecount = 3,
	smallpropghostlimit = 2,
	smallpropdenylimit = 6,
	duplicatorlimit = 3
}
FPP.Settings.FPP_BLOCKMODELSETTINGS = {
	toggle = 1,
	iswhitelist = 0
}


for Protection, Settings in pairs(FPP.Settings) do
	for Option, value in pairs(Settings) do
		CreateConVar("_"..Protection.."_"..Option, value, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})
	end
end