
HELP_CATEGORY_CHATCMD = 1;
HELP_CATEGORY_CONCMD = 2;
HELP_CATEGORY_ADMINTOGGLE = 3;
HELP_CATEGORY_ADMINCMD = 4;

HelpCategories = { }
HelpLabels = { }

function AddHelpCategory( id, name )
	Msg("makingacategory\n")
end

function ChangeHelpLabel( id, text )
	Msg("changelabel\n")
end

function AddHelpLabel( id, category, text, constant )
	Msg("addlabel ".. tostring(text) .." \n")
end

function NetworkHelpLabels( ply )
	Msg("spammingtheplayerwithfail\n")
end

function GenerateChatCommandHelp()
	Msg("buildingthespam\n")
/*
	local p = GetGlobalString( "cmdprefix" );
	
	AddHelpLabel( 900, HELP_CATEGORY_CHATCMD, p .. "echelp - Bring up extra command list" );
	AddHelpLabel( 1000, HELP_CATEGORY_CHATCMD, p .. "help - Bring up this menu" );
	AddHelpLabel( 1100, HELP_CATEGORY_CHATCMD, p .. "job <Job Name> - Set your job" );
	AddHelpLabel( 1200, HELP_CATEGORY_CHATCMD, p .. "w <Message> - Whisper a message" );
	AddHelpLabel( 1300, HELP_CATEGORY_CHATCMD, p .. "y <Message> - Yell a message" );
	AddHelpLabel( 1400, HELP_CATEGORY_CHATCMD, "//, or /a, or /ooc - OOC speak", 1 );
	AddHelpLabel( 2700, HELP_CATEGORY_CHATCMD, p .. "pm <Name/Partial Name> <Message> - Send another player a PM." );
	AddHelpLabel( 2500, HELP_CATEGORY_CHATCMD, "" );
	AddHelpLabel( 2650, HELP_CATEGORY_CHATCMD, "Letters - Press use key to read a letter.  Look away and press use key again to stop reading a letter." );
	AddHelpLabel( 2550, HELP_CATEGORY_CHATCMD, p .. "write <Message> - Write a letter. Use // to go down a line." );
	AddHelpLabel( 2600, HELP_CATEGORY_CHATCMD, p .. "type <Message> - Type a letter.  Use // to go down a line." );
	AddHelpLabel( 1450, HELP_CATEGORY_CHATCMD, "" );
	AddHelpLabel( 1500, HELP_CATEGORY_CHATCMD, p .. "give <Amount> - Give a money amount" );
	AddHelpLabel( 1600, HELP_CATEGORY_CHATCMD, p .. "moneydrop <Amount> - Drop a money amount" );
	AddHelpLabel( 1650, HELP_CATEGORY_CHATCMD, "" );
	AddHelpLabel( 1700, HELP_CATEGORY_CHATCMD, p .. "title <Name> - Give a door you own, a title" );
	AddHelpLabel( 1800, HELP_CATEGORY_CHATCMD, p .. "addowner <Name> - Allow another to player to own your door" );
	AddHelpLabel( 1825, HELP_CATEGORY_CHATCMD, p .. "removeowner <Name> - Remove an owner from your door" );
	AddHelpLabel( 1850, HELP_CATEGORY_CHATCMD, "" );
	AddHelpLabel( 1900, HELP_CATEGORY_CHATCMD, p .. "votecop - Vote to be a Cop" );
	AddHelpLabel( 1920, HELP_CATEGORY_CHATCMD, p .. "voteow - Vote to be Overwatch (only if already Cop or Mayor)" );
	AddHelpLabel( 2750, HELP_CATEGORY_CHATCMD, p .. "votemayor - Vote to be Mayor" );
	AddHelpLabel( 2100, HELP_CATEGORY_CHATCMD, p .. "citizen - Become a Citizen" );
	AddHelpLabel( 2000, HELP_CATEGORY_CHATCMD, p .. "mayor - Become Mayor if you're on the admin's Mayor list" );
	AddHelpLabel( 2150, HELP_CATEGORY_CHATCMD, p .. "ow - Become OverWatch if you're an admin." );
	AddHelpLabel( 2200, HELP_CATEGORY_CHATCMD, p .. "cp - Become a Combine if you're on the admin's Cop list" );
	AddHelpLabel( 2250, HELP_CATEGORY_CHATCMD, "" );
	AddHelpLabel( 2400, HELP_CATEGORY_CHATCMD, p .. "r <Message> - Radio speak with other Combine (only if you're a Cop)" );
	AddHelpLabel( 2450, HELP_CATEGORY_CHATCMD, p .. "cr <Message> - Request the Combine" );
	*/
end
