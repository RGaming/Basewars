function TeamCreationCon( ply, command, arguments )
	local id, name, color = ply:UniqueID(), unpack(arguments)
	team.SetUp(id, name, color)
	ply:SetTeam( id )
end
concommand.Add( "basewars_teamcreate", TeamCreationCon )

if not CLIENT then return end

local TeamPanel = vgui.Create( "DFrame" )
TeamPanel:Center()
TeamPanel:SetTitle( "Faction Setup" )
TeamPanel:SetSize( ScrW() / 4, ScrH() / 4 )
TeamPanel:SetDraggable( false )
TeamPanel:ShowCloseButton( true )

local TeamcolorCircle = vgui.Create( "DColorCircle", TeamPanel )
TeamcolorCircle:SetPos( 50, 70 )
TeamcolorCircle:SetSize( 100, 100 )

local TeamNameTextBox = vgui.Create("DTextEntry", TeamPanel)
TeamNameTextBox:SetText("Initial Value")
TeamNameTextBox:SetSize( 100, 30 )
TeamNameTextBox:SetPos( 50, 30 )
TeamName:SetEditable(true)

			  
local button = vgui.Create( "DButton", TeamPanel )
button:SetSize( 100, 30 )
button:SetPos( 50, 50 )
button:SetText( "Test Button" )
button.DoClick = function( button )
	RunConsoleCommand( "basewars_teamcreate", TeamNameTextBox:GetValue(), TeamcolorCircle:GetRGB() )
end

local function ShowTeamPanel()
	TeamPanel:SetVisible( true )
	TeamPanel:MakePopup()
end
concommand.Add( "showteamcreation", ShowTeamPanel )