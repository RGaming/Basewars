include('shared.lua')

function SWEP:DrawHUD()

	if( LocalPlayer():KeyDown(1)) then
			local trace = self.Owner:GetEyeTrace()
			if (trace.Entity:GetNWInt("welddamage")!=nil && trace.HitPos:Distance(LocalPlayer():GetShootPos()) <= 128 and (trace.Entity:GetClass()=="prop_physics_multiplayer" || trace.Entity:GetClass()=="prop_physics_respawnable" || trace.Entity:GetClass()=="prop_physics" || trace.Entity:GetClass()=="phys_magnet" || trace.Entity:GetClass()=="gmod_spawner" || trace.Entity:GetClass()=="gmod_wheel" || trace.Entity:GetClass()=="gmod_thruster" || trace.Entity:GetClass()=="gmod_button" || trace.Entity:GetClass()=="sent_keypad")and trace.Entity:IsValid()) then
				draw.RoundedBox( 2, ScrW()/2+10, ScrH()/2+25, 100, 33, Color(0,0,0,50) )
				local weldpercent = -((tonumber(trace.Entity:GetNWInt("welddamage"))/255)*100)+100
				draw.RoundedBox( 1, ScrW()/2+11, ScrH()/2+26, weldpercent, 6, Color(150,150,0,100) )
			end
			
			local tr = {}
				tr.start = trace.HitPos
				tr.endpos = trace.HitPos + (self:GetOwner():GetAimVector() * 128.0)
				tr.filter = { self:GetOwner(), trace.Entity }
			local trtwo = util.TraceLine( tr )
			
			if (!trtwo.Hit) then return end
			
			if (trtwo.Entity:GetNWInt("welddamage")!=nil && trtwo.HitPos:Distance(LocalPlayer():GetShootPos()) <= 256 and (trtwo.Entity:GetClass()=="prop_physics_multiplayer" || trtwo.Entity:GetClass()=="prop_physics_respawnable" || trtwo.Entity:GetClass()=="prop_physics" || trtwo.Entity:GetClass()=="phys_magnet" || trtwo.Entity:GetClass()=="gmod_spawner" || trtwo.Entity:GetClass()=="gmod_wheel" || trtwo.Entity:GetClass()=="gmod_thruster" || trtwo.Entity:GetClass()=="gmod_button" || trace.Entity:GetClass()=="sent_keypad")and trtwo.Entity:IsValid()) then
				local weldpercenttwo = -((tonumber(trtwo.Entity:GetNWInt("welddamage"))/255)*100)+100
				draw.RoundedBox( 1, ScrW()/2+11, ScrH()/2+32, weldpercenttwo, 6, Color(120,120,0,100) )
			end
			
			local trx = {}
				trx.start = trtwo.HitPos
				trx.endpos = trtwo.HitPos + (self:GetOwner():GetAimVector() * 128.0)
				trx.filter = { self:GetOwner(), trace.Entity, trtwo.Entity }
			local trthree = util.TraceLine( trx )
			
			if (!trthree.Hit) then return end
			
			if (trthree.Entity:GetNWInt("welddamage")!=nil && trthree.HitPos:Distance(LocalPlayer():GetShootPos()) <= 384 and (trthree.Entity:GetClass()=="prop_physics_multiplayer" || trthree.Entity:GetClass()=="prop_physics_respawnable" || trthree.Entity:GetClass()=="prop_physics" || trthree.Entity:GetClass()=="phys_magnet" || trthree.Entity:GetClass()=="gmod_spawner" || trthree.Entity:GetClass()=="gmod_wheel" || trthree.Entity:GetClass()=="gmod_thruster" || trthree.Entity:GetClass()=="gmod_button" || trace.Entity:GetClass()=="sent_keypad")and trthree.Entity:IsValid()) then
				local weldpercentthree = -((tonumber(trthree.Entity:GetNWInt("welddamage"))/255)*100)+100
				draw.RoundedBox( 1, ScrW()/2+11, ScrH()/2+38, weldpercentthree, 6, Color(150,150,0,100) )
			end
			
			local try = {}
				try.start = trthree.HitPos
				try.endpos = trthree.HitPos + (self:GetOwner():GetAimVector() * 128.0)
				try.filter = { self:GetOwner(), trace.Entity, trtwo.Entity, trthree.Entity }
			local trfour = util.TraceLine( try )
			
			if (!trfour.Hit) then return end
			
			if (trfour.Entity:GetNWInt("welddamage")!=nil && trfour.HitPos:Distance(LocalPlayer():GetShootPos()) <= 512 and (trfour.Entity:GetClass()=="prop_physics_multiplayer" || trfour.Entity:GetClass()=="prop_physics_respawnable" || trfour.Entity:GetClass()=="prop_physics" || trfour.Entity:GetClass()=="phys_magnet" || trfour.Entity:GetClass()=="gmod_spawner" || trfour.Entity:GetClass()=="gmod_wheel" || trfour.Entity:GetClass()=="gmod_thruster" || trfour.Entity:GetClass()=="gmod_button" || trace.Entity:GetClass()=="sent_keypad")and trfour.Entity:IsValid()) then
				local weldpercentfour = -((tonumber(trfour.Entity:GetNWInt("welddamage"))/255)*100)+100
				draw.RoundedBox( 1, ScrW()/2+11, ScrH()/2+44, weldpercentfour, 6, Color(120,120,0,100) )
			end
			
			local trz = {}
				trz.start = trfour.HitPos
				trz.endpos = trfour.HitPos + (self:GetOwner():GetAimVector() * 128.0)
				trz.filter = { self:GetOwner(), trace.Entity, trtwo.Entity, trthree.Entity, trfour.Entity }
			local trfive = util.TraceLine( trz )
			
			if (!trfive.Hit) then return end
			
			if (trfive.Entity:GetNWInt("welddamage")!=nil && trfive.HitPos:Distance(LocalPlayer():GetShootPos()) <= 768 and (trfive.Entity:GetClass()=="prop_physics_multiplayer" || trfive.Entity:GetClass()=="prop_physics_respawnable" || trfive.Entity:GetClass()=="prop_physics" || trfive.Entity:GetClass()=="phys_magnet" || trfive.Entity:GetClass()=="gmod_spawner" || trfive.Entity:GetClass()=="gmod_wheel" || trfive.Entity:GetClass()=="gmod_thruster" || trfive.Entity:GetClass()=="gmod_button" || trace.Entity:GetClass()=="sent_keypad")and trfive.Entity:IsValid()) then
				local weldpercentfive = -((tonumber(trfive.Entity:GetNWInt("welddamage"))/255)*100)+100
				draw.RoundedBox( 1, ScrW()/2+11, ScrH()/2+50, weldpercentfive, 6, Color(150,150,0,100) )
			end
	end
		
end