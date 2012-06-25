AddCSLuaFile "cl_init.lua";
AddCSLuaFile "shared.lua";
include "shared.lua";

function ENT:UpdateMoney( )
	if self.Owner and self.Entity:IsValid( ) then
		self.Owner:SetNWInt( "vaultamount", self.Money );
	end;
end;

local machineloop;
function ENT:Initialize( )
	self.Entity:SetModel( "models/props/chest/chest.mdl" );
	self.Entity:PhysicsInit( SOLID_VPHYSICS );
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS );
	self.Entity:SetSolid( SOLID_VPHYSICS );
	self.Entity:EmitSound( "ambient/machines/thumper_startup1.wav" );
	
	local phys = self.Entity:GetPhysicsObject( );
	if( phys:IsValid( ) ) then 
		phys:Wake( );
	end;
	
	local machineloop = CreateSound( self.Entity, Sound( "ambient/machines/wall_loop1.wav" ) );
	machineloop:Play( );
	
	self.Money = 0;
end;

function ENT:Use( activator, caller )
	umsg.Start( "MoneyVaultMenu", activator );
	umsg.End( );
end;

function ENT:EjectMoney( )
	trace.start = self.Entity:GetPos( )+self.Entity:GetAngles( ):Up( ) * 15;
	trace.endpos = trace.start + self.Entity:GetAngles( ):Forward( ) + self.Entity:GetAngles( ):Right( );
	trace.filter = self.Entity;
	
	local moneybag = ents.Create( "prop_moneybag" );
		moneybag:SetModel( "models/notes.mdl" );
		moneybag:SetPos( tr.HitPos );
		moneybag:SetAngles( self.Entity:GetAngles( ) );
		moneybag:SetColor( 200, 255, 200, 255 );
		moneybag:Spawn( );
		moneybag:GetTable( ).MoneyBag = true;
		moneybag:SetMoveType( MOVETYPE_VPHYSICS )
		moneybag:GetTable( ).Amount = self.Money;
		moneybag:SetVelocity( Vector( 0, 0, 10 ) * 10 );
		self:UpdateMoney( );
	
	self.Money = 0;
end;

function ENT:OnRemove( )
	self.Entity:EjectMoney( );
	self.Entity:EmitSound "ambient/machines/thumper_shutdown.wav";
	machineloop:Stop( );
end;

concommand.Add( "ll_vault_deposit", function( ply, cmd, argv )
	if not tonumber( argv[ 1 ] ) then
		ply:ChatPrint "Invalid Money Vault deposit type!";
		return;
	end;
	if not ply:CanAfford( argv[ 1 ] ) then
		ply:ChatPrint "You can't afford that!";
		return;
	end;
	
	ply:AddMoney( -argv[ 1 ] );
	ENT.Money = ENT.Money + argv[ 1 ];
end );