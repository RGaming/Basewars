local rpdmhints = {
"Press F1 for a list of commands",
"You are currently playing LmaoLlama Basewars",
"say /buyturret to buy a sentry gun for $300",
"Remember to join the LmaoLlama Steam group and donate. Located at: http://steamcommunity.com/groups/LmaoLlama",
"Shooting every person randomly on this server usually ends with everyone teaming up against you.",
"RDM'ing is againist the rules! You will get a warning then you will be banned.",
"If you have a base set up and you hear beeping and can see 'BOMB' right outside of your base, then you should probably go and defuse it.",
"Is an enemy holed up in a secure place and blowtorch isnt helping much? Buy a bigbomb by saying /buybomb. It costs 15000, but can ruin a base.",
"One of the best ways to keep your base from being raided is to team up with people. People who won't go around shooting people that are looking for people to raid.",
"There is no such thing as a perfect base, if you just block everything with props, they will blowtorch it, if you keep them from doing that, they will probably use the bigbomb.",
"Props are not weapons! Get a gun instead. Press F1 to learn how.",
"Dying slowly from poison?  say /buyantidote",
"If you are low on money, buy some stuff to make more money. Press F1 to learn how."
}

function giveHint()
	PrintMessageAll( HUD_PRINTTALK , rpdmhints[math.random(1,#rpdmhints)])
end

timer.Create( "hints", 120, 0, giveHint )