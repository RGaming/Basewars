timer.Create('Payday',1,0,function()
    for k,v in pairs( player.GetAll() ) do 
        local amount = 0
        if !v:CanAfford(20000) then
			amount = amount + math.random(10,25)
		end
        if !v:CanAfford(10000) then
			amount = amount + math.random(30,45)
		end
        if !v:CanAfford(5000) then
			amount = amount + math.random(20,35)
		end
		// if they are FLAT broke, help them more.
        if !v:CanAfford(500) then
			amount = amount + math.random(150,200)
		end
    end
end)