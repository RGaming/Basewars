-- CHANGE THE BUILD NUMBER --
local build = "1.2.1"
/*---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
---------------------------------------------------------*/
function GM:ScoreboardShow()
	GAMEMODE.ShowScoreboard = true
end
/*---------------------------------------------------------
   Name: gamemode:ScoreboardHide( )
   Desc: Hides the scoreboard
---------------------------------------------------------*/
function GM:ScoreboardHide()
	GAMEMODE.ShowScoreboard = false
end


local basename = surface.GetTextureID("LmaoLlama/basewars/scoreboard/name");
local head = surface.GetTextureID("LmaoLlama/basewars/scoreboard/llheadertexture");
local bg = surface.GetTextureID("LmaoLlama/basewars/scoreboard/llbgtexture");

surface.CreateFont( "arial", 16, 500, true, false, "arial20")
surface.CreateFont( "arial", 16, 600, true, false, "arialbold")

function GM:GetTeamScoreInfo()

	local TeamInfo = {}

	
		for id,pl in pairs( player.GetAll() ) do
		
	
	--	local _tag = string.sub(pl:GetNWString("currtag"), 1, -5)
		local _team = pl:Team()
		local _frags = pl:Frags()
		local _deaths =pl:Deaths(	) --getMoney(pl) --pl:Deaths()
		local _ping = pl:Ping()
		
		if (not TeamInfo[_team]) then 
			TeamInfo[_team] = {}
			TeamInfo[_team].TeamName = team.GetName( _team )
			TeamInfo[_team].Color = team.GetColor( _team )
			TeamInfo[_team].Players = {}
		end		
		
		local PlayerInfo = {}


	

	--	PlayerInfo.Tag = _tag
		PlayerInfo.Frags = _frags
		PlayerInfo.Deaths = _deaths
		PlayerInfo.Score = _frags - _deaths
		PlayerInfo.Ping = _ping
		PlayerInfo.Name = pl:Nick()
		PlayerInfo.SteamID = pl:SteamID()
		PlayerInfo.PlayerObj = pl
		
		local insertPos = #TeamInfo[_team].Players + 1
		for idx,info in pairs(TeamInfo[_team].Players) do
			if (PlayerInfo.Frags > info.Frags) then
				insertPos = idx
				break
			elseif (PlayerInfo.Frags == info.Frags) then
				if (PlayerInfo.Deaths < info.Deaths) then
					insertPos = idx
					break
				elseif (PlayerInfo.Deaths == info.Deaths) then
					if (PlayerInfo.Name < info.Name) then
						insertPos = idx
						break
					end
				end
			end
		end
		
		table.insert(TeamInfo[_team].Players, insertPos, PlayerInfo)
	end
	
	return TeamInfo
end

function GM:HUDDrawScoreBoard()

	if (!GAMEMODE.ShowScoreboard) then return end
	
	if (GAMEMODE.ScoreDesign == nil) then
	
		GAMEMODE.ScoreDesign = {}
		GAMEMODE.ScoreDesign.HeaderY = 0
		GAMEMODE.ScoreDesign.Height = ScrH() / 2
	
	end
--	          						VARIABLES
	local alpha = 255

	local ScoreboardInfo = self:GetTeamScoreInfo()
	
	local xOffset = ScrW() / 10
	local yOffset = 32
	local scrWidth = ScrW()
	local scrHeight = ScrH() - 64
	local boardx1 = (ScrW()/2)-(244)
	local boardx2 = boardx1 + 487
	local boardy1 = ScrH()/10
	local boardWidth = 487
	local boardHeight = scrHeight
	local colWidth = 75
	local y = yOffset + 15

	
		boardHeight = GAMEMODE.ScoreDesign.Height
	
	xOffset = (ScrW() - boardWidth) / 2.0
	yOffset = (ScrH() - boardHeight) / 2.0
	yOffset = yOffset - ScrH() / 4.0
	yOffset = math.Clamp( yOffset, 32, ScrH() )
	

	
	local hostname = GetHostName()
	local gamemodeName = GAMEMODE.Name .. " - " .. GAMEMODE.Author
	
	-- Reset the color
	surface.SetDrawColor( 255, 255, 255, 255 );
		
	
	-- Draw the Background
	
	surface.SetDrawColor( 255, 255, 255, 255 );	
	surface.SetTexture( bg );
	surface.DrawTexturedRect( boardx1+1, boardy1+120, 484, boardHeight-y+yOffset-32	);
	surface.DrawTexturedRect( boardx2-2, boardy1+120, 2, boardHeight-y+yOffset-32	);
	


	surface.SetDrawColor( 255, 255, 255, 255 );	
	
	-- Draw Blue box thing
	
	surface.SetDrawColor( 180, 213, 255, 255 ); 
    surface.DrawRect( boardx1+1, boardy1+97, boardWidth-2, 24);
			


	
	-- Draw the Header
	surface.SetDrawColor( 255, 255, 255, 255 ); 
	surface.SetTexture( head );
	surface.DrawTexturedRect( boardx1, boardy1, 512, 128);
	
	-- THE MIGHTY Outline
	surface.SetDrawColor( 0, 0, 0, 255 ); 
	surface.DrawLine( boardx1, boardy1+21, boardx1, boardy1+98 + boardHeight-y+yOffset-10 )
	surface.DrawLine( boardx2-1, boardy1+21, boardx2-1, boardy1+98 + boardHeight-y+yOffset-10 )	
	surface.DrawLine( boardx1, boardy1+21, boardx1+406, boardy1+21 )
	surface.DrawLine( boardx2-18, boardy1+21, boardx2-1, boardy1+21 )
	surface.DrawLine( boardx1, boardy1+98 + boardHeight-y+yOffset-10, boardx2, boardy1+98 + boardHeight-y+yOffset-10 )
	surface.DrawLine( boardx1, boardy1+97, boardx2-1, boardy1+97 )
	surface.SetDrawColor( 181, 181, 181, 255 );
	surface.DrawLine( boardx1+1, boardy1+119, boardx2-2, boardy1+119 )
	surface.SetDrawColor( 229, 229, 229, 255 );
	surface.DrawLine( boardx1+1, boardy1+120, boardx2-2, boardy1+120 )
	surface.SetDrawColor( 255, 255, 255, 255 ); 



	

	

	
	-- Draw the Footer
	
	-- Draw the sides
	
	
	-- Draw the Build Number
--	surface.SetTextColor( 255, 255, 255, 255 )
--	surface.SetFont( "BudgetLabel" );
--  surface.SetTextPos( boardx1+10, boardy1+boardHeight-y+yOffset+100 );
--	surface.DrawText( "Build:" .. build );
	



	
	----------------------	
	surface.SetFont( "arial20" )
	local txWidth, txHeight = surface.GetTextSize( "w" )
	

	
	
	
	
	surface.SetTextColor( 20, 20, 20, 255 )
	surface.SetTextPos( xOffset + 32,								boardy1+102)	surface.DrawText("#Name")
	surface.SetTextPos( xOffset + boardWidth - (colWidth*3) + 8,	boardy1+102)	surface.DrawText("Kills")
	surface.SetTextPos( xOffset + boardWidth - (colWidth*2) + 8,	boardy1+102)	surface.DrawText("Deaths")
	surface.SetTextPos( xOffset + boardWidth - (colWidth*1) + 10,	boardy1+102)	surface.DrawText("#Ping")
	
	local y = y + txHeight + 30
	
		-- Draw the Faction Seperators!
		
	local yPosition = y
	for team,info in pairs(ScoreboardInfo) do
		
		surface.CreateFont( "Bebas Neue", 40, 500, true, false, "teamfont")
		local teamText = info.TeamName -- .. "  (" .. #info.Players .. " Players)"
		teamText = string.upper(teamText)
		teamText = string.TrimLeft( teamText )
		teamText = string.Left( teamText, 32 )


		surface.SetDrawColor( 210, 210, 210, 200 )
		surface.DrawRect( boardx1+2, boardy1+yPosition+38, boardWidth-3, 18);
		surface.SetDrawColor( info.Color.r, info.Color.g, info.Color.b, 255 )
		surface.DrawRect( boardx2-10, boardy1+yPosition+38, 9, 18);
		
		yPosition = yPosition + 2
		surface.SetFont( "teamfont" )
		surface.SetTextColor( 91, 91, 91, 255 )
		surface.SetTextPos( boardx1+10, boardy1+yPosition+27 )
		surface.DrawText( teamText )
		yPosition = yPosition + 2
			
		surface.SetFont( "arialout" )
				

		
		yPosition = yPosition + txHeight + 2
		
		for index,plinfo in pairs(info.Players) do

			txWidth, txHeight = surface.GetTextSize( plinfo.Name )

			local textcolor = Color( info.Color.r, info.Color.g, info.Color.b, alpha )
			local shadowcolor = Color( 100, 100, 100, 255 )

			-------------------------------
			local py = yPosition
			
			draw.SimpleText( plinfo.Name, "arialbold", xOffset + 32, boardy1+py+37, textcolor )
			draw.SimpleText( plinfo.Frags, "arialbold", xOffset + boardWidth - (colWidth*3) + 18, boardy1+py+37, textcolor )
			draw.SimpleText( plinfo.Deaths, "arialbold", xOffset + boardWidth - (colWidth*2) + 24	, boardy1+py+37, textcolor )
			draw.SimpleText( plinfo.Ping, "arialbold", xOffset + boardWidth - (colWidth*1) + 18, boardy1+py+37, textcolor )

			txHeight = 16

			yPosition = yPosition + txHeight + 3
		end
	end
	
	yPosition = yPosition + 8
	
	GAMEMODE.ScoreDesign.Height = (GAMEMODE.ScoreDesign.Height * 2) + (yPosition-yOffset)
	GAMEMODE.ScoreDesign.Height = GAMEMODE.ScoreDesign.Height / 3
	
end

function GM:HUDDrawTargetID()

	local tr = utilx.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetCursorAimVector() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end
	
	local text = "ERROR"
	local font = "TargetID"
	
	if (trace.Entity:IsPlayer() and (LocalPlayer():GetObserverTarget()== nil or trace.Entity!=LocalPlayer():GetObserverTarget())) then
		text = trace.Entity:Nick()
	else
		return
		//text = trace.Entity:GetClass()
	end
	
	--surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	
	local MouseX, MouseY = gui.MousePos()
	
	if ( MouseX == 0 && MouseY == 0 ) then
	
		MouseX = ScrW() / 2
		MouseY = ScrH() / 2
	
	end
	
	local x = MouseX
	local y = MouseY
	
--	local QuadTable = {} 
--	QuadTable.texture = surface.GetTextureID( string.sub(trace.Entity:GetNWString("currtag"), 1, -5) )
--	QuadTable.x = x-16
--	QuadTable.y = y+10
--	QuadTable.w = 32
--	QuadTable.h = 16
--	draw.TexturedQuad( QuadTable )
	
	x = x - w / 2
	y = y + 30
	
	// The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )
	
	y = y + h + 5	
	
	local text = trace.Entity:Health() .. "%"
	local font = "TargetIDSmall"
	
	--surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	local x =  MouseX  - w / 2
	
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )

end