include("shared.lua")

surface.CreateFont("Trebuchet22", 50, 700, true, false, "HostFont")
surface.CreateFont("Trebuchet22", 40, 700, true, false, "PlayerFont")

local Hostname = GetHostName()

local Map = game.GetMap()

local Me = LocalPlayer()

local Reps = 0

local Slots = {}

local Colors = {}

Colors["gm_construct"] = Color(51, 102, 255, 255)
Colors["gm_flatgrass"] = Color(51, 102, 255, 255)
Colors["bw_city18"] = Color(51, 102, 255, 255)  

timer.Create("CreateTable", 0.1, 64, function()
	if Reps < 64 then
		Reps = Reps + 1
	end
	Slots[Reps] = 90 + (55 * Reps)
	if Reps == 64 then
		timer.Destroy("CreateTable")
	end
end)


function ENT:Draw()
		
	cam.Start3D2D(self:GetPos() - self:GetAngles():Forward() * 190 + self:GetAngles():Right() * 190, self:GetAngles() + Angle(90, 90, 90), 0.3)
			
		draw.RoundedBox(3, 0, 0, 1270, 50, Colors[Map])
		draw.RoundedBox(3, 0, 70, 1270, 50, Colors[Map])
		draw.DrawText(Hostname, "HostFont", 5, 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.DrawText("Name                                                                   Kills          Ping", "HostFont", 5, 70, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			
		for k,v in pairs(player.GetAll()) do

			draw.RoundedBox(3, 0, Slots[k], 875, 50, Colors[Map])
			draw.RoundedBox(3, 885, Slots[k], 195, 50, Colors[Map])
			draw.RoundedBox(3, 1090, Slots[k], 180, 50, Colors[Map])
				
			draw.DrawText(v:Name(), "PlayerFont", 5, Slots[k], Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.DrawText(v:Frags(), "PlayerFont", 935, Slots[k], Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.DrawText(v:Ping(), "PlayerFont", 1200, Slots[k], Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				
		end
			
	cam.End3D2D()

end

