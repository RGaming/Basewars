BannedProps = { }
AllowedProps = { }

function AddBannedProp( mdl )
	table.insert( BannedProps, mdl );
end
function AddAllowedProp( mdl )
	table.insert( AllowedProps, mdl );
end

-- HOW TO ADD BANNED PROPS ( toggled with rp_bannedprops )
-- AddBannedProp( "MODEL NAME OF PROP" );

AddBannedProp( "models/Cranes/crane_frame.mdl" );
AddBannedProp( "models/props_c17/oildrum001_explosive.mdl" );
AddBannedProp( "models/props_canal/canal_bridge02.mdl" );
AddBannedProp( "models/props_canal/canal_bridge01.mdl" );
AddBannedProp( "models/props_canal/canal_bridge03a.mdl" );
AddBannedProp( "models/props_canal/canal_bridge03b.mdl" );
AddBannedProp( "models/props_canal/canal_bridge03c.mdl" );
AddBannedProp( "models/props_canal/canal_bridge01b.mdl" );
AddBannedProp( "cs_fix.mdl" );
AddBannedProp( "models/props_combine/combine_citadel001.mdl" );


AddBannedProp( [[models/\props_phx/playfield.mdl]] );
AddBannedProp( [[models/\props_phx/ww2bomb.mdl]] );
AddBannedProp( [[models/\props_phx/torpedo.mdl]] );
AddBannedProp( [[models/\props_phx/mk-82.mdl]] );
AddBannedProp( [[models/\props_phx/oildrum001_explosive.mdl]] );
AddBannedProp( [[models/\props_phx/cannonball.mdl]] );
AddBannedProp( [[models/\props_phx/ball.mdl]] );
AddBannedProp( [[models/\props_phx/amraam.mdl]] );
AddBannedProp( [[models/\props_junk/propane_tank001a.mdl]] );
AddBannedProp( [[models/\props_junk/gascan001a.mdl]] );
AddBannedProp( [[models/\props_phx/misc/flakshell_big.mdl]] );
AddBannedProp( [[models/\props_phx/huge/tower.mdl]] );

AddBannedProp( [[models/props_phx/playfield.mdl]] );
AddBannedProp( [[models/props_phx/ww2bomb.mdl]] );
AddBannedProp( [[models/props_phx/torpedo.mdl]] );
AddBannedProp( [[models/props_phx/mk-82.mdl]] );
AddBannedProp( [[models/props_phx/oildrum001_explosive.mdl]] );
AddBannedProp( [[models/props_phx/cannonball.mdl]] );
AddBannedProp( [[models/props_phx/ball.mdl]] );
AddBannedProp( [[models/props_phx/amraam.mdl]] );
AddBannedProp( [[models/props_junk/propane_tank001a.mdl]] );
AddBannedProp( [[models/props_junk/gascan001a.mdl]] );
AddBannedProp( [[models/props_phx/misc/flakshell_big.mdl]] );
AddBannedProp( [[models/props_phx/huge/tower.mdl]] );

-- HOW TO ADD ALLOWEDP PROPS ( toggled with rp_allowedprops )
-- AddAllowedProp( "MODEL NAME OF PROP" );

AddAllowedProp( "BLARGSTEIN.mdl" )