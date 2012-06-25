include "shared.lua";

local DFrame1;
local DPanel1;
local DLabel1;
local DLabel2;
local DButton1;
local DTextEntry1;
local DButton2;
function ENT:OpenMenu( )
	DFrame1 = vgui.Create( "DFrame" );
	DFrame1:SetSize( 402, 126 );
	DFrame1:SetPos( 166, 104 );
	DFrame1:SetTitle( "Money Vault" );
	DFrame1:SetSizable( true );
	DFrame1:SetDeleteOnClose( false );
	DFrame1:MakePopup( );

	DPanel1 = vgui.Create( "DPanel", DFrame1 );
	DPanel1:SetSize( 394, 95 );
	DPanel1:SetPos( 4, 27 );

	DButton1 = vgui.Create( "DButton", DPanel1 );
	DButton1:SetSize( 188, 51 );
	DButton1:SetPos( 4, 40 );
	DButton1:SetText( "Eject" );
	DButton1.DoClick = function( ) end;

	DLabel2 = vgui.Create( "DLabel", DPanel1 );
	DLabel2:SetPos( 58, 14 );
	DLabel2:SetText( LocalPlayer( ):GetNWInt( "vaultamount", 0 ) );
	DLabel2:SizeToContents( );
	DLabel1:SetTextColor( Color( 10, 135, 10, 255 ) );

	DLabel1 = vgui.Create( "DLabel", DPanel1 );
	DLabel1:SetPos( 8, 14 );
	DLabel1:SetText( "Contents: " );
	DLabel1:SizeToContents( );

	DTextEntry1 = vgui.Create( "DTextEntry", DPanel1 );
	DTextEntry1:SetSize( 192, 20 );
	DTextEntry1:SetPos( 366, 141 );
	DTextEntry1:SetText( "" );
	DTextEntry1.OnEnter = function( ) end;
	
	DButton2 = vgui.Create( "DButton", DPanel1 );
	DButton2:SetSize( 193, 51 );
	DButton2:SetPos( 195, 40 );
	DButton2:SetText( "Deposit" );
	DButton2.DoClick = function( )
		RunConsoleCommand( "ll_vault_deposit", DTextEntry1:GetValue( ) );
	end;
	surface.PlaySound "items/ammocrate_open.wav";
end;

hook.Add( "Think", "MoneyVaultUpdate", function( )
	if DLabel2 then
		DLabel2:SetText( LocalPlayer( ):GetNWInt( "vaultamount", 0 ) );
	end;
end );
usermessage.Hook( "MoneyVaultMenu", function( ) ENT:OpenMenu( ) end );