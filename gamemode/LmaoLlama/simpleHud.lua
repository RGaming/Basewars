function myhud()
    local client = LocalPlayer()
    if !client:Alive() then return end
    if(client:GetActiveWeapon() == NULL or client:GetActiveWeapon() == "Camera") then return end
    
    local mag_left = client:GetActiveWeapon():Clip1()
    local mag_extra = client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType())
    local secondary_ammo = client:GetAmmoCount(client:GetActiveWeapon():GetSecondaryAmmoType())
    
    MaxAmmo={}
    MaxAmmo["weapon_crowbar"]=0
    MaxAmmo["weapon_physcannon"]=0
    MaxAmmo["weapon_physgun"]=0
    MaxAmmo["weapon_pistol"]=18
    MaxAmmo["weapon_357"]=6
    MaxAmmo["weapon_smg1"]=45
    MaxAmmo["weapon_ar2"]=30
    MaxAmmo["weapon_crossbow"]=1
    MaxAmmo["weapon_frag"]=-1
    MaxAmmo["weapon_rpg"]=-1
    
    draw.RoundedBox(0, 25, ScrH()-105, 200, 85, Color(25,  25, 25, 150))
    draw.SimpleText("Health: "..client:Health() .. "%", "ScoreboardText", 35, ScrH()-100, Color(250, 230, 10, 255), 0, 0)
    draw.SimpleText("Armor: "..client:Armor().."%","ScoreboardText",35,ScrH()-65,Color(5,150,255,255),0,0)
    draw.RoundedBox(0, 35, ScrH()-80, math.Clamp(client:Health(),0,100)*1.8,15, Color(255,170,0,250))
    draw.RoundedBox(0, 35, ScrH()-79, math.Clamp(client:Health(),0,100)*1.8,5, Color(255,210,120,200))
    draw.RoundedBox(0, 35, ScrH()-45, math.Clamp(client:Armor(),0,100)*1.8,15, Color(0,120,255,250))
    draw.RoundedBox(0, 35, ScrH()-44, math.Clamp(client:Armor(),0,100)*1.8,5, Color(0,190,255,200))
    draw.RoundedBox(0, 25, ScrH()-130, 75, 20, Color(25,  25, 25, 150))
    draw.RoundedBox(0, ScrW()-215, ScrH()-60, 200, 40, Color(25,  25, 25, 150))
    draw.SimpleText("Clock: "..tostring(os.date()),"ScoreboardText",ScrW()-200,ScrH()-50,Color(220,220,220,255),0,0)
    draw.SimpleText("Ping: "..client:Ping(),"ScoreboardText",35,ScrH()-128,Color(250,230,0,255),0,0)
    surface.SetDrawColor(0,0,0,200)
    surface.DrawOutlinedRect( 25, ScrH()-130,75,20)
    surface.DrawOutlinedRect( 25, ScrH()-105,200,85)
    surface.DrawOutlinedRect( 35, ScrH()-80,180,15)
    surface.DrawOutlinedRect( ScrW()-215, ScrH()-60,200,40)
    surface.DrawOutlinedRect( 35, ScrH()-80,math.Clamp(client:Health(),0,100)*1.8,15)
    surface.DrawOutlinedRect( 35, ScrH()-45,math.Clamp(client:Armor(),0,100)*1.8,15)
    surface.DrawOutlinedRect( 35, ScrH()-45,180,15)
    
    if mag_left <= 0 && mag_extra <= 0 then
        hasprim=0
    else 
        hasprim=1
    end
    
    if secondary_ammo <= 0 then
        hassec=0
    else 
        hassec=1
    end
    
    if(client:GetActiveWeapon().Primary)then
        ammobar=mag_left/client:GetActiveWeapon().Primary.ClipSize*180
    else
        ammobar=mag_left/MaxAmmo[client:GetActiveWeapon():GetClass()]*180
    end
    draw.RoundedBox(0, 230, ScrH()-105, 200, 40, Color(25,  25, 25, 150*hasprim))
    draw.RoundedBox(0, 230, ScrH()-60, 200, 40, Color(25,  25, 25, 150*hassec))
    
    draw.SimpleText("Mag: "..mag_left , "ScoreboardText", 240, ScrH()-100, Color(0, 220, 0, 255*hasprim), 0, 0)
    draw.SimpleText(mag_extra , "ScoreboardText", 380, ScrH()-100, Color(0, 220, 0, 255*hasprim), 0, 0)
    draw.RoundedBox(0, 240, ScrH()-80, ammobar, 10, Color(0,180,0,255*hasprim), 0, 0)
    draw.RoundedBox(0, 240, ScrH()-80, ammobar, 4, Color(120,180,120,175*hasprim), 0, 0)
    draw.SimpleText("Sec: "..secondary_ammo , "ScoreboardText", 240, ScrH()-55, Color(220, 0, 0, 255*hassec), 0, 0)
    draw.RoundedBox(0, 240, ScrH()-35, math.Clamp(secondary_ammo,0,18)*10,10, Color(200,0,0,255*hassec))
    draw.RoundedBox(0, 240, ScrH()-35, math.Clamp(secondary_ammo,0,18)*10,4, Color(255,155,155,100*hassec))
    surface.SetDrawColor(0,0,0,200*hasprim)
    surface.DrawOutlinedRect( 230, ScrH()-105,200,40 )
    surface.DrawOutlinedRect( 240, ScrH()-80,ammobar,10)
    surface.DrawOutlinedRect( 240, ScrH()-80,180,10)
    surface.SetDrawColor(0,0,0,200*hassec)
    surface.DrawOutlinedRect( 230, ScrH()-60,200,40)
    surface.DrawOutlinedRect( 240, ScrH()-35,math.Clamp(secondary_ammo,0,18)*10,10)
    surface.DrawOutlinedRect( 240, ScrH()-35,180,10)
end

hook.Add("HUDPaint", "huddie", myhud)

function hidehud(name)
    for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
        if name == v then return false end
    end
end
hook.Add("HUDShouldDraw", "hidehud", hidehud)
    
