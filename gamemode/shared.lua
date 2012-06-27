team.SetUp( 1, "Citizen", Color( 125, 125, 125, 255 ) );
--team.SetUp( 2, "Cop", Color( 25, 25, 170, 255 ) );
--team.SetUp( 3, "Mayor", Color( 150, 20, 20, 255 ) );
--team.SetUp( 4, "Gangster", Color( 90, 90, 90, 255 ) );
--team.SetUp( 5, "Mob Boss", Color( 0, 0, 0, 255 ) );
--team.SetUp( 6, "Gun Dealer", Color( 255, 140, 0, 255 ) );
--team.SetUp( 7, "Pharmacist", Color( 47, 79, 79, 255 ) );
--team.SetUp( 8, "Cook", Color( 238, 99, 99, 255 ) );
--team.SetUp( 9, "OverWatch", Color(25, 120, 170, 255) );
--team.SetUp( 10, "Spec Ops", Color(100, 150, 200, 255) );
--team.SetUp( 11, "Hitman", Color(60, 70, 60, 255) );
--team.SetUp( 12, "Grenadier", Color(200, 15, 15, 255) );
--// won't be used
--team.SetUp( 13, "???", Color(200, 200, 200, 255) );
--team.SetUp( 14, "Vuvuzela'ist", Color(153, 204, 102, 255) );
--team.SetUp( 15, "Negro Derp", Color(51, 26, 0, 255) );
--team.SetUp( 16, "Superman", Color(51, 51, 204, 255) );
--team.SetUp( 17, "Red Spy", Color(255, 51, 0, 255) );
--team.SetUp( 18, "Grim Reaper", Color(61, 61, 61, 255) );
--team.SetUp( 19, "Sonic", Color(51, 51, 204, 255) );
--team.SetUp( 20, "Gabe Newell", Color( 238, 99, 99, 255 ) );
GMS = {}

GM.Name 	= "RGaming Base Wars"
GM.Author 	= "By Uggleking and nickelpro"
GM.Email 	= "nickelpro@gmail.com"
GM.Website 	= "www.xldoy.com/blog"

--include("sh_teammenu.lua")

drugtable = {}
drugtable["regen"] = {}
drugtable["regen"].color = Color(50, 150, 50, 255)
drugtable["regen"].string = "regened"
drugtable["regen"].symbol = "F"
drugtable["regen"].font = "DrugFont"
drugtable["regen"].type = 0
drugtable["antidote"] = {}
drugtable["antidote"].color = Color(50, 150, 150, 255)
drugtable["antidote"].string = "antidoted"
drugtable["antidote"].symbol = "F"
drugtable["antidote"].font = "DrugFont"
drugtable["antidote"].type = 0
drugtable["painkiller"] = {}
drugtable["painkiller"].color = Color(50, 50, 150, 255)
drugtable["painkiller"].string = "painkillered"
drugtable["painkiller"].symbol = "L"
drugtable["painkiller"].font = "DrugFont"
drugtable["painkiller"].type = 0
drugtable["reflect"] = {}
drugtable["reflect"].color = Color(100,125,0,255)
drugtable["reflect"].string = "mirrored"
drugtable["reflect"].symbol = "E"
drugtable["reflect"].font = "DrugFont"
drugtable["reflect"].type = 0
drugtable["adrenaline"] = {}
drugtable["adrenaline"].color = Color(100,125,150,255)
drugtable["adrenaline"].string = "adrenalined"
drugtable["adrenaline"].symbol = "M"
drugtable["adrenaline"].font = "DrugFont2"
drugtable["adrenaline"].type = 0

drugtable["steroid"] = {}
drugtable["steroid"].color = Color(150, 50, 50, 255)
drugtable["steroid"].string = "roided"
drugtable["steroid"].symbol = "D"
drugtable["steroid"].font = "DrugFont2"
drugtable["steroid"].type = 1
drugtable["amplifier"] = {}
drugtable["amplifier"].color = Color(100,50,125,255)
drugtable["amplifier"].string = "amped"
drugtable["amplifier"].symbol = "K"
drugtable["amplifier"].font = "DrugFont"
drugtable["amplifier"].type = 1
drugtable["leech"] = {}
drugtable["leech"].color = Color(50,0,0,255)
drugtable["leech"].string = "leeched"
drugtable["leech"].symbol = "z"
drugtable["leech"].font = "DrugFont2"
drugtable["leech"].type = 1
drugtable["doublejump"] = {}
drugtable["doublejump"].color = Color(100, 100, 100, 255)
drugtable["doublejump"].string = "doublejumped"
drugtable["doublejump"].symbol = "N"
drugtable["doublejump"].font = "DrugFont2"
drugtable["doublejump"].type = 1
drugtable["armorpiercer"] = {}
drugtable["armorpiercer"].color = Color(125, 125, 100, 255)
drugtable["armorpiercer"].string = "armorpiercered"
drugtable["armorpiercer"].symbol = "X"
drugtable["armorpiercer"].font = "DrugFont2"
drugtable["armorpiercer"].type = 1

drugtable["magicbullet"] = {}
drugtable["magicbullet"].color = Color(100,75,0,255)
drugtable["magicbullet"].string = "magicbulleted"
drugtable["magicbullet"].symbol = "W"
drugtable["magicbullet"].font = "DrugFont2"
drugtable["magicbullet"].type = 2
drugtable["focus"] = {}
drugtable["focus"].color = Color(200, 125, 50, 255)
drugtable["focus"].string = "focused"
drugtable["focus"].symbol = "D"
drugtable["focus"].font = "DrugFont"
drugtable["focus"].type = 2
drugtable["shockwave"] = {}
drugtable["shockwave"].color = Color(150, 125, 75, 255)
drugtable["shockwave"].string = "shockwaved"
drugtable["shockwave"].symbol = "I"
drugtable["shockwave"].font = "DrugFont"
drugtable["shockwave"].type = 2
drugtable["doubletap"] = {}
drugtable["doubletap"].color = Color(150,150,0,255)
drugtable["doubletap"].string = "doubletapped"
drugtable["doubletap"].symbol = "G"
drugtable["doubletap"].font = "DrugFont"
drugtable["doubletap"].type = 2
drugtable["knockback"] = {}
drugtable["knockback"].color = Color(200,200,150,255)
drugtable["knockback"].string = "knockbacked"
drugtable["knockback"].symbol = "*"
drugtable["knockback"].font = "DrugFont2"
drugtable["knockback"].type = 2

cleanup.Register( "magnets" )
