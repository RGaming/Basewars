--ents = ents or { };
local _decays = { };
local DecayTime = 5;
local DecayRate = DecayTime
local DecayRateCounter = CurTime( ) + DecayRate;

local function AddDecay( ent, decaytime )
	timer.Simple( 1, function( )
		if ent:IsValid( ) then
			local _r, _g, _b = ent:GetColor( );
			
			_decays[ ent ] = {
				Time = decaytime;
				R = _r or 255;
				G = _g or 255;
				B = _b or 255;
				A = _a or 255;
			};
		end;
	end );
end;

hook.Add( "Think", "EntityDecay", function( )
	for k, v in pairs( _decays ) do
		if k:IsValid( ) then
			if v.Time == CurTime( ) then
				k:Remove( );
			end;
			if CurTime( ) >= DecayRateCounter then
				k:SetColor( v.R - 5, v.G - 5, v.B - 5, v.A );
				v.R = v.R - 5;
				v.G = v.G - 5;
				v.B = v.B - 5;
				
				DecayRateCounter = CurTime( ) + DecayRate;
			end;
		end;
	end;
end );

function ents.CreateEx( entity )
	entity = ents.Create( entity );
	
--	timer.Create( "decaytimer", 5, 1, function()
--		if entity:IsValid( ) then
--			entity:Remove()
--		end
--	end )

	
	return entity;
end;