
if( BuyGUI ) then

	for k, v in pairs( BuyGUI ) do
	
		v:Remove();
		BuyGUI[k] = nil;
	
	end

end
BuyGUI = {}
SubBuyGUI = {}
local currentpage = 1

local RPDM = {}

// just a little temporary fix.
CreateClientConVar("sv_benchmark_force_start", 0, false, false)

function RPDM.MenuGet()
	spawnmenu.AddToolMenuOption("Base War Settings", "Base War Settings", "clAllies","Allies","","",RPDM.AllyPanel)
	spawnmenu.AddToolMenuOption("Base War Settings", "Base War Settings", "clSettings","Settings","","",RPDM.OptionPanel)
end
hook.Add("PopulateToolMenu", "RPDM_PopulateToolMenu", RPDM.MenuGet)

function RPDM.SpawnMenuOpen()
	if RPDM.OptionControlPanel then RPDM.OptionPanel(RPDM.OptionControlPanel) end
	if RPDM.AllyControlPanel then RPDM.AllyPanel(RPDM.AllyControlPanel) end
	if RPDM.AccessControlPanel then RPDM.AccessPanel(RPDM.AccessControlPanel) end
end
hook.Add("SpawnMenuOpen", "RPDM_SpawnMenuOpen", RPDM.SpawnMenuOpen)


// msg

RPDM.OptionControlPanel = nil

CreateClientConVar("bw_showmessages", 1, true, false)
CreateClientConVar("bw_shownotify", 0, true, false)
CreateClientConVar("bw_messages_warningnotify", 1, true, false)
CreateClientConVar("bw_messages_dontshowincome", 0, true, false)
CreateClientConVar("bw_showsparks",1,true,false)
CreateClientConVar("bw_clcolor_r",255,true,true)
CreateClientConVar("bw_clcolor_g",255,true,true)
CreateClientConVar("bw_clcolor_b",255,true,true)

function RPDM.OptionPanel(Panel)
	Panel:ClearControls()
	if RPDM.OptionControlPanel==nil then RPDM.OptionControlPanel=Panel end
	
	Panel:AddControl("Header", {Text="Messenger Options"})
	Panel:AddControl("CheckBox", {Label="Show Messenger", Command="bw_showmessages"})
	Panel:AddControl("CheckBox", {Label="Show Messages as notifications", Command="bw_shownotify"})
	Panel:AddControl("CheckBox", {Label="Show Warnings as notifications", Command="bw_messages_warningnotify"})
	Panel:AddControl("CheckBox", {Label="Don't show Income Messages", Command="bw_messages_dontshowincome"})
	Panel:AddControl("Header", {Text="Effect Options"})
	Panel:AddControl("CheckBox", {Label="Show spark effects", Command="bw_showsparks"})
	if LocalPlayer():GetInfo("bw_clcolor_r")==nil then
		CreateClientConVar("bw_clcolor_r",255,true,true)
	end
	if LocalPlayer():GetInfo("bw_clcolor_g")==nil then
		CreateClientConVar("bw_clcolor_g",255,true,true)
	end
	if LocalPlayer():GetInfo("bw_clcolor_b")==nil then
		CreateClientConVar("bw_clcolor_b",255,true,true)
	end
	Panel:AddControl( "Color",  { Label	= "Effect Colors",
									Red			= "bw_clcolor_r",
									Green		= "bw_clcolor_g",
									Blue		= "bw_clcolor_b",
									ShowAlpha	= 0,
									ShowHSV		= 1,
									ShowRGB 	= 1,
									Multiplier	= 255 } )	
									
	
end

// allies


RPDM.AllyPanel = nil

function RPDM.AllyPanel(Panel)
	Panel:ClearControls()
	if RPDM.AllyControlPanel==nil then RPDM.AllyControlPanel=Panel end
	
	Panel:AddControl("Header", {Text="Allies"})
	for k, v in pairs(player.GetAll()) do
		if LocalPlayer():GetInfo("bw_ally_pl"..v:EntIndex())==nil then
			CreateClientConVar("bw_ally_pl"..v:EntIndex(), 0, false, true)
		end
		Panel:AddControl("CheckBox", {Label=v:GetName(), Command="bw_ally_pl"..v:EntIndex()})
	end

	
end

// prop protect

function RPDM.AccessPanel(Panel)
	Panel:ClearControls()
	if RPDM.AccessControlPanel==nil then RPDM.AccessControlPanel=Panel end
	
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

function MakeAddToolMenuTabs()
    spawnmenu.AddToolTab("Base War Settings", "Base War Settings")
end

hook.Add("AddToolMenuTabs", "MakeAddToolMenuTabs", MakeAddToolMenuTabs)
