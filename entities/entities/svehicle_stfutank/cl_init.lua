// STFU Tank HUD
// By HLTV Proxy
//

include('shared.lua')
function ENT:DrawEntityOutline( size )
end

local self = {}
local Hooked = false

function ENT.Initialize()
	killicon.AddFont("svehicle_stfutank","HL2MPTypeDeath","A",Color(100,100,100,255))
end

function ENT:Draw()
	
	self.Entity:DrawModel()
end

function ENT:Think()
	if !Hooked then
		hook.Add("HUDPaint", "SVehicle.STFUTank.HUD", STFUTankHUDInfo)
		Hooked = true
	end
end

// simple function that draws a rectangle with an outline.
local function DrawBox(startx, starty, sizex, sizey, color1,color2 )
	draw.RoundedBox( 0, startx, starty, sizex, sizey, color2 )
	draw.RoundedBox( 0, startx+1, starty+1, sizex-2, sizey-2, color1 )
end

function STFUTankHUDInfo()
	local scrxl = 0
	local scrxh = ScrW()
	local scryl = 0
	local scryh = ScrH()
	
	for k, v in pairs(ents.FindByClass("svehicle_stfutank")) do
		local driver = nil
		local guncore = nil
		if (ValidEntity(v)) then
			driver = v:GetNWEntity("Driver")
			guncore = v:GetNWEntity("GunCore")
		end
		if (ValidEntity(driver) && driver==LocalPlayer()) then
			
			
			// damagechart
			local plate1 = v:GetNWEntity("Plate1")
			local plate2 = v:GetNWEntity("Plate2")
			local plate3 = v:GetNWEntity("Plate3")
			local plate4 = v:GetNWEntity("Plate4")
			local plate5 = v:GetNWEntity("Plate5")
			local plate6 = v:GetNWEntity("Plate6")
			local plate7 = v:GetNWEntity("Plate7")
			local plate8 = v:GetNWEntity("Plate8")
			local engine = v:GetNWEntity("Engine")
			
			if ValidEntity(engine) then
				local damage = engine:GetNWInt("damage")/10
				local color = Color(0,150,0,250)
				local color2 = Color(0,255,0,250)
				if damage<150 && damage > 50 then
					color = Color(140,140,0,250)
					color2 = Color(250,250,0,250)
				elseif damage<=50 then
					color = Color(150,0,0,250)
					color2 = Color(255,0,0,250)
				end
				
				DrawBox(scrxh-101,scryl+40, 42, 80, color, color2)
				draw.RoundedBox( 0, scrxh-100, scryl+80, 40, 1, color2 )
				
				DrawBox(scrxh-80,scryl+119, 15, 5, color, color2)
			else
				draw.RoundedBox( 0, scrxh-101, scryl+40, 42, 80, Color(0,0,0,150) )
			end
			
			/*
			2 3
			4 6
			5 7
			1 8
			*/
			if ValidEntity(plate1) then
				local damage = plate1:GetNWInt("damage")/2
				local color = Color(0,150,0,250)
				local color2 = Color(0,255,0,250)
				if damage<170 && damage > 70 then
					color = Color(140,140,0,250)
					color2 = Color(250,250,0,250)
				elseif damage<=70 then
					color = Color(150,0,0,250)
					color2 = Color(255,0,0,250)
				end
				DrawBox(scrxh-125,scryl+110, 25, 31, color, color2)
				draw.RoundedBox( 0, scrxh-117, scryl+110, 1, 31, color2 )
				draw.RoundedBox( 0, scrxh-109, scryl+110, 1, 31, color2 )
				
			else
				draw.RoundedBox( 0, scrxh-125, scryl+110, 25, 31, Color(0,0,0,150) )
			end
			
			if ValidEntity(plate2) then
				local damage = plate2:GetNWInt("damage")/2
				local color = Color(0,150,0,250)
				local color2 = Color(0,255,0,250)
				if damage<170 && damage > 70 then
					color = Color(140,140,0,250)
					color2 = Color(250,250,0,250)
				elseif damage<=70 then
					color = Color(150,0,0,250)
					color2 = Color(255,0,0,250)
				end
				DrawBox(scrxh-125,scryl+20, 25, 31, color, color2)
				draw.RoundedBox( 0, scrxh-117, scryl+20, 1, 31, color2 )
				draw.RoundedBox( 0, scrxh-109, scryl+20, 1, 31, color2 )
				
			else
				draw.RoundedBox( 0, scrxh-125, scryl+20, 25, 31, Color(0,0,0,150) )
			end
			
			if ValidEntity(plate3) then
				local damage = plate3:GetNWInt("damage")/2
				local color = Color(0,150,0,250)
				local color2 = Color(0,255,0,250)
				if damage<170 && damage > 70 then
					color = Color(140,140,0,250)
					color2 = Color(250,250,0,250)
				elseif damage<=70 then
					color = Color(150,0,0,250)
					color2 = Color(255,0,0,250)
				end
				DrawBox(scrxh-60,scryl+20, 25, 31, color, color2)
				draw.RoundedBox( 0, scrxh-52, scryl+20, 1, 31, color2 )
				draw.RoundedBox( 0, scrxh-44, scryl+20, 1, 31, color2 )
				
			else
				draw.RoundedBox( 0, scrxh-60, scryl+20, 25, 31, Color(0,0,0,150) )
			end
			
			if ValidEntity(plate4) then
				local damage = plate4:GetNWInt("damage")/2
				local color = Color(0,150,0,250)
				local color2 = Color(0,255,0,250)
				if damage<170 && damage > 70 then
					color = Color(140,140,0,250)
					color2 = Color(250,250,0,250)
				elseif damage<=70 then
					color = Color(150,0,0,250)
					color2 = Color(255,0,0,250)
				end
				DrawBox(scrxh-125,scryl+50, 25, 31, color, color2)
				draw.RoundedBox( 0, scrxh-117, scryl+50, 1, 31, color2 )
				draw.RoundedBox( 0, scrxh-109, scryl+50, 1, 31, color2 )
				
			else
				draw.RoundedBox( 0, scrxh-125, scryl+50, 25, 31, Color(0,0,0,150) )
			end
			
			if ValidEntity(plate5) then
				local damage = plate5:GetNWInt("damage")/2
				local color = Color(0,150,0,250)
				local color2 = Color(0,255,0,250)
				if damage<170 && damage > 70 then
					color = Color(140,140,0,250)
					color2 = Color(250,250,0,250)
				elseif damage<=70 then
					color = Color(150,0,0,250)
					color2 = Color(255,0,0,250)
				end
				DrawBox(scrxh-125,scryl+80, 25, 31, color, color2)
				draw.RoundedBox( 0, scrxh-117, scryl+80, 1, 31, color2 )
				draw.RoundedBox( 0, scrxh-109, scryl+80, 1, 31, color2 )
				
			else
				draw.RoundedBox( 0, scrxh-125, scryl+80, 25, 31, Color(0,0,0,150) )
			end
			
			if ValidEntity(plate6) then
				local damage = plate6:GetNWInt("damage")/2
				local color = Color(0,150,0,250)
				local color2 = Color(0,255,0,250)
				if damage<170 && damage > 70 then
					color = Color(140,140,0,250)
					color2 = Color(250,250,0,250)
				elseif damage<=70 then
					color = Color(150,0,0,250)
					color2 = Color(255,0,0,250)
				end
				DrawBox(scrxh-60,scryl+50, 25, 31, color, color2)
				draw.RoundedBox( 0, scrxh-52, scryl+50, 1, 31, color2 )
				draw.RoundedBox( 0, scrxh-44, scryl+50, 1, 31, color2 )
				
			else
				draw.RoundedBox( 0, scrxh-60, scryl+50, 25, 31, Color(0,0,0,150) )
			end
			
			if ValidEntity(plate7) then
				local damage = plate7:GetNWInt("damage")/2
				local color = Color(0,150,0,250)
				local color2 = Color(0,255,0,250)
				if damage<170 && damage > 70 then
					color = Color(140,140,0,250)
					color2 = Color(250,250,0,250)
				elseif damage<=70 then
					color = Color(150,0,0,250)
					color2 = Color(255,0,0,250)
				end
				DrawBox(scrxh-60,scryl+80, 25, 31, color, color2)
				draw.RoundedBox( 0, scrxh-52, scryl+80, 1, 31, color2 )
				draw.RoundedBox( 0, scrxh-44, scryl+80, 1, 31, color2 )
				
			else
				draw.RoundedBox( 0, scrxh-60, scryl+80, 25, 31, Color(0,0,0,150) )
			end
			
			if ValidEntity(plate8) then
				local damage = plate8:GetNWInt("damage")/2
				local color = Color(0,150,0,250)
				local color2 = Color(0,255,0,250)
				if damage<170 && damage > 70 then
					color = Color(140,140,0,250)
					color2 = Color(250,250,0,250)
				elseif damage<=70 then
					color = Color(150,0,0,250)
					color2 = Color(255,0,0,250)
				end
				DrawBox(scrxh-60,scryl+110, 25, 31, color, color2)
				draw.RoundedBox( 0, scrxh-52, scryl+110, 1, 31, color2 )
				draw.RoundedBox( 0, scrxh-44, scryl+110, 1, 31, color2 )
				
			else
				draw.RoundedBox( 0, scrxh-60, scryl+110, 25, 31, Color(0,0,0,150) )
			end
			
			// crosshair
			if (ValidEntity(guncore)) then
				local gunoffset = guncore:GetForward()*200.784+guncore:GetRight()*-0.56+guncore:GetUp()*70.77
				local firingangle = guncore:GetAngles()
				firingangle:RotateAroundAxis(firingangle:Right(), -90)
				local tracedata = {}
					tracedata.start = gunoffset+v:GetPos()
					tracedata.endpos = tracedata.start+(firingangle:Up()*32678)
				trace = util.TraceLine(tracedata)
				local crosshairpos = tracedata.endpos:ToScreen()
				if (trace.Hit) then
					crosshairpos = trace.HitPos:ToScreen()
				end
				draw.DrawText( "+", "TargetID", crosshairpos.x, crosshairpos.y, Color( 255, 0, 0, 200 ), 1 )
				
				
				// draw the gun only when it wasnt wasted from tank damage
				
				local color = Color(0,150,0,250)
				local color2 = Color(0,255,0,250)
				
				DrawBox(scrxh-95,scryl+90, 30, 25, color, color2)
				DrawBox(scrxh-87,scryl+45, 14, 46, color, color2)
				DrawBox(scrxh-90,scryl+20, 20, 26, color, color2)
				
				draw.RoundedBox( 0, scrxh-90, scryl+25, 20, 1, Color(0,255,0,250) )
				draw.RoundedBox( 0, scrxh-90, scryl+30, 20, 1, Color(0,255,0,250) )
				draw.RoundedBox( 0, scrxh-90, scryl+35, 20, 1, Color(0,255,0,250) )
				draw.RoundedBox( 0, scrxh-90, scryl+40, 20, 1, Color(0,255,0,250) )
			else
				draw.RoundedBox( 0, scrxh-95, scryl+90, 30, 25, Color(0,0,0,255) )
			end
			
		end
	end
end

