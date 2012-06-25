/*
local RPDM = {}

RPDM.AccessPanel = nil

function RPDM.MenuGet()
	spawnmenu.AddToolMenuOption("Options", "LmaoLlama Settings", "clPropAccess","Prop Protect","","",RPDM.AccessPanel)
end
MODULE:Hook("PopulateToolMenu", "RPDM_PopulateToolMenu", RPDM.MenuGet)

function RPDM.SpawnMenuOpen()
	if RPDM.AccessControlPanel then RPDM.AccessPanel(RPDM.AccessControlPanel) end
end
MODULE:Hook("SpawnMenuOpen", "RPDM_SpawnMenuOpen", RPDM.SpawnMenuOpen)

function RPDM.AccessPanel(Panel)
	Panel:ClearControls()
	if PrP.AccessControlPanel==nil then RPDM.AccessControlPanel=Panel end
	
	Panel:AddControl("Header", {Text="Prop Protect"})
	if LocalPlayer():IsAdmin() || LocalPlayer():IsSuperAdmin() then
		Panel:AddControl("Button", {Label="Clear disconnected player props", Command="propprotect_clearoldprops"})
	end
	for k, v in pairs(player.GetAll()) do
		if v!=LocalPlayer() then
			if LocalPlayer():GetInfo("propprotect_access_pl"..v:EntIndex())==nil then
				CreateClientConVar("propprotect_access_pl"..v:EntIndex(), 0, false, true)
			end
			Panel:AddControl("CheckBox", {Label=v:GetName(), Command="propprotect_access_pl"..v:EntIndex()})
		end
	end
	
end
*/