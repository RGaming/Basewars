include "shared.lua";

local DFrame1;
local DPanel1;
local DLabel1;
local DLabel2;
local DButton1;
local DButton2;

canopenmenu = true;

local function OnEjectClick
  RunConsoleCommand( "ll_vault_eject" );
end

local function OpenVaultMenu( )
	if canopenmenu then
		DFrame1 = vgui.Create( "DFrame" );
		DFrame1:SetSize( 402, 126 );
		DFrame1:SetPos( ScrW( ) * 0.40, ScrH( ) * 0.50 );
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
		DButton1.DoClick = OnEjectClick

		DLabel2 = vgui.Create( "DLabel", DPanel1 );
		DLabel2:SetPos( 58, 14 );
		DLabel2:SetText( LocalPlayer( ):GetNWInt( "vaultamount", 0 ) );
		DLabel2:SizeToContents( );
		DLabel2:SetTextColor( Color( 10, 135, 10, 255 ) );

		DLabel1 = vgui.Create( "DLabel", DPanel1 );
		DLabel1:SetPos( 8, 14 );
		DLabel1:SetText( "Total: " );
		DLabel1:SizeToContents( );

	end;
end;

local oldtime = 1;
hook.Add( "Think", "MoneyVaultUpdate", function( )
	if DLabel2 then
		DLabel2:SetText( LocalPlayer( ):GetNWInt( "vaultamount", 0 ) );
	end;
	if CurTime( ) >= oldtime then
		canopenmenu = true;
		oldtime = oldtime + 1;
	end;
end );
usermessage.Hook( "MoneyVaultMenu", function( ) OpenVaultMenu( ) end );
