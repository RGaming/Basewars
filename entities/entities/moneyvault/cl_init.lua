include "shared.lua";

local DFrame1;
local DPanel1;
local DLabel1;
local DLabel2;
local DButton1;
local DButton2;

canopenmenu = true;
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
		DButton1.DoClick = function( )
			RunConsoleCommand( "ll_vault_eject" );
		end;
		
		DLabel2 = vgui.Create( "DLabel", DPanel1 );
		DLabel2:SetPos( 58, 14 );
		DLabel2:SetText( LocalPlayer( ):GetNWInt( "vaultamount", 0 ) );
		DLabel2:SizeToContents( );
		DLabel2:SetTextColor( Color( 10, 135, 10, 255 ) );
		
		DLabel1 = vgui.Create( "DLabel", DPanel1 );
		DLabel1:SetPos( 8, 14 );
		DLabel1:SetText( "Total: " );
		DLabel1:SizeToContents( );
		
		DButton2 = vgui.Create( "DButton", DPanel1 );
		DButton2:SetSize( 193, 51 );
		DButton2:SetPos( 195, 40 );
		DButton2:SetText( "Deposit" );
		DButton2.DoClick = function( )
			DButton2:SetDisabled( true )
		end;
		--	Derma_StringRequest( "Money Vault", "How much money do you wish to store?", "0", function( str ) RunConsoleCommand( "ll_vault_deposit", str ) end );
		--surface.PlaySound "items/ammocrate_open.wav";
		--canopenmenu = false;
	end;
end;

local oldtime = 1;
hook.Add( "Think", "MoneyVaultUpdate", function( )
	--[[
	local trace = { };
		trace.start = LocalPlayer( ):GetShootPos( );
		trace.endpos = LocalPlayer( ):GetShootPos( ) + ( LocalPlayer( ):GetAimVector( ) * 200 );
		trace.filter = LocalPlayer( );
		local traceline = util.TraceLine( trace );
		if traceline.HitNonWorld and traceline.Entity:IsValid( ) then
			if DLabel2 then
				DLabel2:SetText( traceline.Entity:GetNWInt( "vaultamount", 0 ) );
			end;
		end;
	--]]
	if DLabel2 then
		DLabel2:SetText( LocalPlayer( ):GetNWInt( "vaultamount", 0 ) );
	end;
	if CurTime( ) >= oldtime then
		canopenmenu = true;
		oldtime = oldtime + 1;
	end;
end );
usermessage.Hook( "MoneyVaultMenu", function( ) OpenVaultMenu( ) end );