AddCSLuaFile "cl_init.lua";
AddCSLuaFile "shared.lua";
include "shared.lua";

function ENT:UpdateMoney( )
	if self:IsValid( ) then
		-- self:SetNWInt( "vaultamount", self.Money );
		self.Owner:SetNWInt( "vaultamount", self.Money );
	end;
end;

local machineloop;
local called = false;
function ENT:Initialize( )
	self:SetModel( "models/props_lab/powerbox01a.mdl" );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:EmitSound( "ambient/machines/thumper_startup1.wav" );

	local phys = self:GetPhysicsObject( );
	if( phys:IsValid( ) ) then
		phys:Wake( );
	end;

	self.Entity:SetNWInt("damage",1000)
	self.Entity:SetNWInt("upgrade", 0)
	machineloop = CreateSound( self, Sound( "ambient/machines/wall_loop1.wav" ) );
	machineloop:Play( );

			timer.Create("giveIntrest", 5, 0, self.giveInterest, self)

	self.Money = 0;
	self.KeyPress = CurTime( );
	local ply = self.Entity.Owner
	self.Owner:GetTable().maxMoneyVault=self.Owner:GetTable().maxMoneyVault + 1
end;

function ENT:Use( activator, caller )
	if CurTime( ) >= self.KeyPress then
		if self.Owner == activator then
			umsg.Start( "MoneyVaultMenu", activator ) umsg.End( );
			self.KeyPress = CurTime( ) + 1;
		else
			activator:ChatPrint( "That isn't your Money Vault!" );
		end;
	end;
end;

function ENT:giveIntrest()
		if (self.Entity:GetNWInt("upgrade")==0) then
			self.Money = self.Money * 1.1
			Notify( ply, 4, 3, "You have been given 10% Intrest in Your Money Bank." );
		end
		if (self.Entity:GetNWInt("upgrade")==1) then
			Notify( ply, 4, 3, "You have been given 20% Intrest in Your Money Bank." );
			self.Money = self.Money * 1.2
		end
		if (self.Entity:GetNWInt("upgrade")==2) then
			self.Money = self.Money * 1.3
		Notify( ply, 4, 3, "You have been given 30% Intrest in Your Money Bank." );
		end
	timer.Create("giveIntrest", 5, 0, self.giveInterest, self)
end

function ENT:EjectMoney( )
	if self.Money > 0 then
		local moneybag = ents.Create( "prop_moneybag" );
      moneybag:SetModel( "models/props/cs_assault/Money.mdl" );
			moneybag:SetPos( self:GetPos( ) + Vector( 0, 0, 20 ) );
			moneybag:SetAngles( self:GetAngles( ) );
			moneybag:SetColor( 200, 255, 200, 255 );
			moneybag:Spawn( );
			moneybag:GetTable( ).MoneyBag = true;
			moneybag:GetTable( ).Amount = self.Money;
			moneybag:SetVelocity( Vector( 0, 0, 10 ) * 10 );
			moneybag.Ejected = true;

			self.Money = 0;
			self:UpdateMoney( );
	else
		Notify(self.Owner, 4, 3, "This Money Vault is empty!")
		end;
end;

function ENT:OnRemove( )
	self:EjectMoney( );
	self:EmitSound( "ambient/machines/thumper_shutdown1.wav" );
	machineloop:Stop( );

	self.Owner:GetTable().maxMoneyVault=self.Owner:GetTable().maxMoneyVault - 1
end;

function ENT:Touch( ent )
	if ent:GetClass( ) == "prop_moneybag" then
		if not ent.Ejected and not called then
			self.Money = self.Money + ent:GetTable( ).Amount;
			ent:Remove( );
			self:UpdateMoney( );
			called = true;
			timer.Simple( 1, function( )
				called = false;
			end );
		end;
	end;
end;

concommand.Add( "ll_vault_deposit", function( ply, cmd, argv )
	local amt = tonumber( argv[ 1 ] );
	if not amt then
		ply:ChatPrint "Invalid Money Vault deposit type!";
		return;
	end;
	if not ply:CanAfford( amt ) then
		ply:ChatPrint "You can't afford that!";
		return;
	end;

	ply:AddMoney( amt );
	local trace = { };
		trace.start = ply:GetShootPos( );
		trace.endpos = ply:GetShootPos( ) + ( ply:GetAimVector( ) * 200 );
		trace.filter = ply;
		local traceline = util.TraceLine( trace );
		if traceline.HitNonWorld and traceline.Entity:IsValid( ) then
			local ent = traceline.Entity;
			ent.Money = ent.Money + amt;
			ent:EmitSound( "ambient/levels/labs/coinslot1.wav" );
			ent:UpdateMoney( );
		end;
end );

concommand.Add( "ll_vault_eject", function( ply, cmd, argv )
	local trace = { };
		trace.start = ply:GetShootPos( );
		trace.endpos = ply:GetShootPos( ) + ( ply:GetAimVector( ) * 200 );
		trace.filter = ply;
		local traceline = util.TraceLine( trace );
		if traceline.HitNonWorld and traceline.Entity:IsValid( ) then
			traceline.Entity:EjectMoney( );
			traceline.Entity:EmitSound( "ambient/alarms/klaxon1.wav" );
		end;
end );
