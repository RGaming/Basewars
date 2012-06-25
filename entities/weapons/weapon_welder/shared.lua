// copy pasta from lock pick.

if(SERVER) then
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "shared.lua" )
end

if( CLIENT ) then

	SWEP.PrintName = "Blowtorch";
	SWEP.Slot = 5;
	SWEP.SlotPos = 8;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;

end

// Variables that are used on both client and server

SWEP.Author			= "HLTV Proxy"
SWEP.Instructions	= "Blowtorch: Hold left click on a prop to eventually remove it."
SWEP.Contact		= ""
SWEP.Purpose		= ""

SWEP.ViewModelFOV	= 73
SWEP.ViewModelFlip	= false
SWEP.ViewModel = Model( "models/weapons/v_IRifle.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_IRifle.mdl" )

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.Sound = Sound( "physics/wood/wood_box_impact_hard3.wav" );

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= true			// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""



/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()

	if( SERVER ) then
		// make it an ar2 model, but hold it as a pistol so that people know its the welder.
		self:SetWeaponHoldType( "pistol" );
	
	end
	util.PrecacheSound("physics/metal/metal_box_impact_soft2.wav")
	util.PrecacheSound("ambient/energy/spark1.wav")
	util.PrecacheSound("ambient/energy/spark2.wav")
	util.PrecacheSound("ambient/energy/spark3.wav")
	util.PrecacheSound("ambient/energy/spark4.wav")
end


/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end


/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + .075)
	
	local trace = self.Owner:GetEyeTrace()
	local snd = math.random(1,4)
	// filter what class it is, so that retards cannot delete crazy shit such as important map parts, jeeps, doors, etc.
	if (trace.HitPos:Distance(self.Owner:GetShootPos()) <= 128 and (trace.Entity:GetClass()=="prop_ragdoll" || trace.Entity:GetClass()=="prop_physics_multiplayer" || trace.Entity:GetClass()=="prop_physics_respawnable" || trace.Entity:GetClass()=="prop_physics" || trace.Entity:GetClass()=="phys_magnet" || trace.Entity:GetClass()=="gmod_spawner" || trace.Entity:GetClass()=="gmod_wheel" || trace.Entity:GetClass()=="gmod_thruster" || trace.Entity:GetClass()=="gmod_button" || trace.Entity:GetClass()=="sent_keypad")and trace.Entity:IsValid()) then
		local effectdata = EffectData()
			effectdata:SetOrigin(trace.HitPos)
			effectdata:SetMagnitude( 1 )
			effectdata:SetScale( 2 )
			effectdata:SetRadius( 2 )
		util.Effect( "Sparks", effectdata )
		
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Weapon:EmitSound("ambient/energy/spark" .. snd .. ".wav")
		
		// we dont want fags getting little welds off at a time, running away for like 30 minutes, then coming back and doing it a little again, so repair it after 10 seconds of no damage.
		if SERVER then
			timer.Destroy(tostring(trace.Entity) .. "unweldamage")
			
			// haha, oh wow. i didnt really think creating a function within this would actually work.
			timer.Create(tostring(trace.Entity) .. "unweldamage", 10, 1, WeldControl, trace.Entity, player.GetByUniqueID(trace.Entity:GetVar("PropProtection")))
			//timer.Create(tostring(trace.Entity) .. "unweldamage", 10, 1, function() trace.Entity:SetNWInt("welddamage", 255) end)
		end
		
		if(trace.Entity:GetNWInt("welddamage") == nil || trace.Entity:GetNWInt("welddamage") <= 0 || trace.Entity:GetNWInt("welddamage") == 255) then
			trace.Entity:SetNWInt("welddamage", 254)
			if SERVER then
				if (player.GetByUniqueID(trace.Entity:GetVar("PropProtection"))!=false) then
					local entowner = player.GetByUniqueID(trace.Entity:GetVar("PropProtection"))
					entowner:GetTable().shitweldcount=entowner:GetTable().shitweldcount+1
					entowner:SetNWBool("shitwelding", true)
					Notify(entowner, 1, 3, "someone is destroying one of your props with a blowtorch!!!")
					entowner:PrintMessage(HUD_PRINTTALK, "someone is destroying one of your props with a blowtorch!")
				end
			end
		elseif(trace.Entity:GetNWInt("welddamage") > 1) then
			trace.Entity:SetNWInt("welddamage", trace.Entity:GetNWInt("welddamage") - 1)
			if SERVER then
				if (trace.Entity:GetNWInt("welddamage")==130) then
					if SERVER then
						if (trace.Entity:CPPIGetOwner()==true) then
							local entowner = player.GetByUniqueID(trace.Entity:GetVar("PropProtection"))
							Notify(entowner, 1, 3, "someone has nearly finished destroying one of your props using blowtorch!!!")
							entowner:PrintMessage(HUD_PRINTTALK, "someone has nearly finished destroying one of your props with a blowtorch!")
						end
					end
				end
			end
		else
			if SERVER then
				if (player.GetByUniqueID(trace.Entity:GetVar("PropProtection"))!=false) then
						local entowner = player.GetByUniqueID(trace.Entity:GetVar("PropProtection"))
						Notify(entowner, 1, 3, "someone has destroyed one of your props using a blowtorch!!!")
						entowner:PrintMessage(HUD_PRINTTALK, "someone has destroyed one of your props with a blowtorch!")
				end
			end
			local effectdata = EffectData() 
				effectdata:SetStart( trace.Entity:GetPos() )
				effectdata:SetOrigin( trace.Entity:GetPos() ) 
				effectdata:SetScale( 1 ) 
			util.Effect( "Explosion", effectdata ) 
			if SERVER then
				timer.Destroy(tostring(trace.Entity) .. "unweldamage")
				// stick the thumb 30 seconds deeper into their ass and keep them from spawning anything on a successful weld attempt
				timer.Create(tostring(trace.Entity) .. "unweldamage", 30, 1, WeldControl, trace.Entity, player.GetByUniqueID(trace.Entity:GetVar("PropProtection")))
				//WeldControl(trace.Entity, player.GetByUniqueID(trace.Entity:GetVar("PropProtection")))
				timer.Destroy(tostring(trace.Entity) .. "undamagecolor")
				trace.Entity:Remove()
			end
		end
	else
		self.Weapon:EmitSound("ambient/energy/spark" .. snd.. ".wav")
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
	// copy pasta straight from the nail gun.
	local tr = {}
		tr.start = trace.HitPos
		tr.endpos = trace.HitPos + (self:GetOwner():GetAimVector() * 128)
		tr.filter = { self:GetOwner(), trace.Entity }
	local trtwo = util.TraceLine( tr )
	// if there isnt anything there, then FUCK IT
	if (!trtwo.Hit) then return end
	
	if (trtwo.HitPos:Distance(self.Owner:GetShootPos()) <= 256 and (trtwo.Entity:GetClass()=="prop_ragdoll" || trtwo.Entity:GetClass()=="prop_physics_multiplayer" || trtwo.Entity:GetClass()=="prop_physics_respawnable" || trtwo.Entity:GetClass()=="prop_physics" || trtwo.Entity:GetClass()=="phys_magnet" || trtwo.Entity:GetClass()=="gmod_spawner" || trtwo.Entity:GetClass()=="gmod_wheel" || trtwo.Entity:GetClass()=="gmod_thruster" || trtwo.Entity:GetClass()=="gmod_button" || trace.Entity:GetClass()=="sent_keypad")and trtwo.Entity:IsValid()) then
		
		if SERVER then
			timer.Destroy(tostring(trtwo.Entity) .. "unweldamage")
			
			timer.Create(tostring(trtwo.Entity) .. "unweldamage", 10, 1, WeldControl, trtwo.Entity, player.GetByUniqueID(trtwo.Entity:GetVar("PropProtection")), true)
			//timer.Create(tostring(trtwo.Entity) .. "unweldamage", 10, 1, function() trtwo.Entity:SetNWInt("welddamage", 255) end)
		end
		
		if(trtwo.Entity:GetNWInt("welddamage") == nil || trtwo.Entity:GetNWInt("welddamage") <= 0 || trtwo.Entity:GetNWInt("welddamage") == 255) then
			trtwo.Entity:SetNWInt("welddamage", 254)
			if SERVER then
				if (player.GetByUniqueID(trtwo.Entity:GetVar("PropProtection"))!=false) then
					local entowner = player.GetByUniqueID(trtwo.Entity:GetVar("PropProtection"))
					entowner:GetTable().shitweldcount=entowner:GetTable().shitweldcount+1
					entowner:SetNWBool("shitwelding", true)
					Notify(entowner, 1, 3, "someone is destroying one of your props with a blowtorch!!!")
					entowner:PrintMessage(HUD_PRINTTALK, "someone is destroying one of your props with a blowtorch!")
				end
			end
		elseif(trtwo.Entity:GetNWInt("welddamage") > 1) then
			trtwo.Entity:SetNWInt("welddamage", trtwo.Entity:GetNWInt("welddamage") - 1)
			if SERVER then
				if (trtwo.Entity:GetNWInt("welddamage")==130) then
					if SERVER then
						if (player.GetByUniqueID(trtwo.Entity:GetVar("PropProtection"))!=false) then
							local entowner = player.GetByUniqueID(trtwo.Entity:GetVar("PropProtection"))
							Notify(entowner, 1, 3, "someone has nearly finished destroying one of your props using blowtorch!!!")
							entowner:PrintMessage(HUD_PRINTTALK, "someone has nearly finished destroying one of your props with a blowtorch!")
						end
					end
				end
			end
		else
			if SERVER then
				if (player.GetByUniqueID(trtwo.Entity:GetVar("PropProtection"))!=false) then
						local entowner = player.GetByUniqueID(trtwo.Entity:GetVar("PropProtection"))
						Notify(entowner, 1, 3, "someone has destroyed one of your props using a blowtorch!!!")
						entowner:PrintMessage(HUD_PRINTTALK, "someone has destroyed one of your props with a blowtorch!")
				end
			end
			local effectdata = EffectData() 
				effectdata:SetStart( trtwo.Entity:GetPos() )
				effectdata:SetOrigin( trtwo.Entity:GetPos() ) 
				effectdata:SetScale( 1 ) 
			util.Effect( "Explosion", effectdata ) 
			if SERVER then
				timer.Destroy(tostring(trtwo.Entity) .. "unweldamage")
				// stick the thumb 30 seconds deeper into their ass and keep them from spawning anything on a successful weld attempt
				timer.Create(tostring(trtwo.Entity) .. "unweldamage", 30, 1, WeldControl, trtwo.Entity, player.GetByUniqueID(trtwo.Entity:GetVar("PropProtection")))
				//WeldControl(trtwo.Entity, player.GetByUniqueID(trtwo.Entity:GetVar("PropProtection")))
				timer.Destroy(tostring(trtwo.Entity) .. "undamagecolor")
				trtwo.Entity:Remove()
			end
		end
	end
	
	// 3
	local trx = {}
		trx.start = trtwo.HitPos
		trx.endpos = trtwo.HitPos + (self:GetOwner():GetAimVector() * 128.0)
		trx.filter = { self:GetOwner(), trace.Entity, trtwo.Entity }
	local trthree = util.TraceLine( trx )
	
	// if there isnt anything there this third time, then FUCK IT
	if (!trthree.Hit) then return end
	
	if (trthree.HitPos:Distance(self.Owner:GetShootPos()) <= 384 and (trthree.Entity:GetClass()=="prop_ragdoll" || trthree.Entity:GetClass()=="prop_physics_multiplayer" || trthree.Entity:GetClass()=="prop_physics_respawnable" || trthree.Entity:GetClass()=="prop_physics" || trthree.Entity:GetClass()=="phys_magnet" || trthree.Entity:GetClass()=="gmod_spawner" || trthree.Entity:GetClass()=="gmod_wheel" || trthree.Entity:GetClass()=="gmod_thruster" || trthree.Entity:GetClass()=="gmod_button" || trace.Entity:GetClass()=="sent_keypad")and trthree.Entity:IsValid()) then
		
		if SERVER then
			timer.Destroy(tostring(trthree.Entity) .. "unweldamage")
			
			timer.Create(tostring(trthree.Entity) .. "unweldamage", 10, 1, WeldControl, trthree.Entity, player.GetByUniqueID(trthree.Entity:GetVar("PropProtection")), true)
			//timer.Create(tostring(trthree.Entity) .. "unweldamage", 5, 1, function() trthree.Entity:SetNWInt("welddamage", 255) end)
		end
		
		if(trthree.Entity:GetNWInt("welddamage") == nil || trthree.Entity:GetNWInt("welddamage") <= 0 || trthree.Entity:GetNWInt("welddamage") == 255) then
			trthree.Entity:SetNWInt("welddamage", 254)
			if SERVER then
				if (player.GetByUniqueID(trthree.Entity:GetVar("PropProtection"))!=false) then
					local entowner = player.GetByUniqueID(trthree.Entity:GetVar("PropProtection"))
					entowner:GetTable().shitweldcount=entowner:GetTable().shitweldcount+1
					entowner:SetNWBool("shitwelding", true)
					Notify(entowner, 1, 3, "someone is destroying one of your props with a blowtorch!!!")
					entowner:PrintMessage(HUD_PRINTTALK, "someone is destroying one of your props with a blowtorch!")
				end
			end
		elseif(trthree.Entity:GetNWInt("welddamage") > 1) then
			trthree.Entity:SetNWInt("welddamage", trthree.Entity:GetNWInt("welddamage") - 1)
			if SERVER then
				if (trthree.Entity:GetNWInt("welddamage")==130) then
					if SERVER then
						if (player.GetByUniqueID(trthree.Entity:GetVar("PropProtection"))!=false) then
							local entowner = player.GetByUniqueID(trthree.Entity:GetVar("PropProtection"))
							Notify(entowner, 1, 3, "someone has nearly finished destroying one of your props using blowtorch!!!")
							entowner:PrintMessage(HUD_PRINTTALK, "someone has nearly finished destroying one of your props with a blowtorch!")
						end
					end
				end
			end
		else
			if SERVER then
				if (player.GetByUniqueID(trthree.Entity:GetVar("PropProtection"))!=false) then
						local entowner = player.GetByUniqueID(trthree.Entity:GetVar("PropProtection"))
						Notify(entowner, 1, 3, "someone has destroyed one of your props using a blowtorch!!!")
						entowner:PrintMessage(HUD_PRINTTALK, "someone has destroyed one of your props with a blowtorch!")
				end
			end
			local effectdata = EffectData() 
				effectdata:SetStart( trthree.Entity:GetPos() )
				effectdata:SetOrigin( trthree.Entity:GetPos() ) 
				effectdata:SetScale( 1 ) 
			util.Effect( "Explosion", effectdata ) 
			if SERVER then
				timer.Destroy(tostring(trthree.Entity) .. "unweldamage")
				// stick the thumb 30 seconds deeper into their ass and keep them from spawning anything on a successful weld attempt
				timer.Create(tostring(trthree.Entity) .. "unweldamage", 30, 1, WeldControl, trthree.Entity, player.GetByUniqueID(trthree.Entity:GetVar("PropProtection")))
				//WeldControl(trthree.Entity, player.GetByUniqueID(trthree.Entity:GetVar("PropProtection")))
				timer.Destroy(tostring(trthree.Entity) .. "undamagecolor")
				trthree.Entity:Remove()
			end
		end
	end
	
	// prop four. if they have this many in a row, then its probably a spammer.
	local try = {}
		try.start = trthree.HitPos
		try.endpos = trthree.HitPos + (self:GetOwner():GetAimVector() * 128.0)
		try.filter = { self:GetOwner(), trace.Entity, trtwo.Entity, trthree.Entity }
	local trfour = util.TraceLine( try )
	
	// if there isnt anything there this fourth time, then FUCK IT
	if (!trfour.Hit) then return end
	
	if (trfour.HitPos:Distance(self.Owner:GetShootPos()) <= 512 and (trfour.Entity:GetClass()=="prop_ragdoll" || trfour.Entity:GetClass()=="prop_physics_multiplayer" || trfour.Entity:GetClass()=="prop_physics_respawnable" || trfour.Entity:GetClass()=="prop_physics" || trfour.Entity:GetClass()=="phys_magnet" || trfour.Entity:GetClass()=="gmod_spawner" || trfour.Entity:GetClass()=="gmod_wheel" || trfour.Entity:GetClass()=="gmod_thruster" || trfour.Entity:GetClass()=="gmod_button" || trace.Entity:GetClass()=="sent_keypad")and trfour.Entity:IsValid()) then
		
		if SERVER then
			timer.Destroy(tostring(trfour.Entity) .. "unweldamage")
			
			timer.Create(tostring(trfour.Entity) .. "unweldamage", 10, 1, WeldControl, trfour.Entity, player.GetByUniqueID(trfour.Entity:GetVar("PropProtection")), true)
			//timer.Create(tostring(trfour.Entity) .. "unweldamage", 5, 1, function() trfour.Entity:SetNWInt("welddamage", 255) end)
		end
		
		if(trfour.Entity:GetNWInt("welddamage") == nil || trfour.Entity:GetNWInt("welddamage") <= 0 || trfour.Entity:GetNWInt("welddamage") == 255) then
			trfour.Entity:SetNWInt("welddamage", 254)
			if SERVER then
				if (player.GetByUniqueID(trfour.Entity:GetVar("PropProtection"))!=false) then
					local entowner = player.GetByUniqueID(trfour.Entity:GetVar("PropProtection"))
					entowner:GetTable().shitweldcount=entowner:GetTable().shitweldcount+1
					entowner:SetNWBool("shitwelding", true)
					Notify(entowner, 1, 3, "someone is destroying one of your props with a blowtorch!!!")
					entowner:PrintMessage(HUD_PRINTTALK, "someone is destroying one of your props with a blowtorch!")
				end
			end
		elseif(trfour.Entity:GetNWInt("welddamage") > 1) then
			trfour.Entity:SetNWInt("welddamage", trfour.Entity:GetNWInt("welddamage") - 1)
			if SERVER then
				if (trfour.Entity:GetNWInt("welddamage")==130) then
					if SERVER then
						if (player.GetByUniqueID(trfour.Entity:GetVar("PropProtection"))!=false) then
							local entowner = player.GetByUniqueID(trfour.Entity:GetVar("PropProtection"))
							Notify(entowner, 1, 3, "someone has nearly finished destroying one of your props using blowtorch!!!")
							entowner:PrintMessage(HUD_PRINTTALK, "someone has nearly finished destroying one of your props with a blowtorch!")
						end
					end
				end
			end
		else
			if SERVER then
				if (player.GetByUniqueID(trfour.Entity:GetVar("PropProtection"))!=false) then
						local entowner = player.GetByUniqueID(trfour.Entity:GetVar("PropProtection"))
						Notify(entowner, 1, 3, "someone has destroyed one of your props using a blowtorch!!!")
						entowner:PrintMessage(HUD_PRINTTALK, "someone has destroyed one of your props with a blowtorch!")
				end
			end
			local effectdata = EffectData() 
				effectdata:SetStart( trfour.Entity:GetPos() )
				effectdata:SetOrigin( trfour.Entity:GetPos() ) 
				effectdata:SetScale( 1 ) 
			util.Effect( "Explosion", effectdata ) 
			if SERVER then
				timer.Destroy(tostring(trfour.Entity) .. "unweldamage")
				// stick the thumb 30 seconds deeper into their ass and keep them from spawning anything on a successful weld attempt
				timer.Create(tostring(trfour.Entity) .. "unweldamage", 30, 1, WeldControl, trfour.Entity, player.GetByUniqueID(trfour.Entity:GetVar("PropProtection")))
				//WeldControl(trfour.Entity, player.GetByUniqueID(trfour.Entity:GetVar("PropProtection")))
				timer.Destroy(tostring(trfour.Entity) .. "undamagecolor")
				trfour.Entity:Remove()
			end
		end
	end
	
	// prop five. if i have to add a sixth one here, ill just make it a loop instead. this is getting far out of hand.
	local trz = {}
		trz.start = trfour.HitPos
		trz.endpos = trfour.HitPos + (self:GetOwner():GetAimVector() * 128.0)
		trz.filter = { self:GetOwner(), trace.Entity, trtwo.Entity, trthree.Entity, trfour.Entity }
	local trfive = util.TraceLine( trz )
	
	// if there isnt anything there this fifth time, then FUCK IT
	if (!trfive.Hit) then return end
	
	if (trfive.HitPos:Distance(self.Owner:GetShootPos()) <= 768 and (trfive.Entity:GetClass()=="prop_ragdoll" || trfive.Entity:GetClass()=="prop_physics_multiplayer" || trfive.Entity:GetClass()=="prop_physics_respawnable" || trfive.Entity:GetClass()=="prop_physics" || trfive.Entity:GetClass()=="phys_magnet" || trfive.Entity:GetClass()=="gmod_spawner" || trfive.Entity:GetClass()=="gmod_wheel" || trfive.Entity:GetClass()=="gmod_thruster" || trfive.Entity:GetClass()=="gmod_button" || trace.Entity:GetClass()=="sent_keypad")and trfive.Entity:IsValid()) then
		
		if SERVER then
			timer.Destroy(tostring(trfive.Entity) .. "unweldamage")
			
			timer.Create(tostring(trfive.Entity) .. "unweldamage", 10, 1, WeldControl, trfive.Entity, player.GetByUniqueID(trfive.Entity:GetVar("PropProtection")), true)
			//timer.Create(tostring(trfive.Entity) .. "unweldamage", 5, 1, function() trfive.Entity:SetNWInt("welddamage", 255) end)
		end
		
		if(trfive.Entity:GetNWInt("welddamage") == nil || trfive.Entity:GetNWInt("welddamage") <= 0 || trfive.Entity:GetNWInt("welddamage") == 255) then
			trfive.Entity:SetNWInt("welddamage", 254)
			if SERVER then
				if (player.GetByUniqueID(trfive.Entity:GetVar("PropProtection"))!=false) then
					local entowner = player.GetByUniqueID(trfive.Entity:GetVar("PropProtection"))
					entowner:GetTable().shitweldcount=entowner:GetTable().shitweldcount+1
					entowner:SetNWBool("shitwelding", true)
					Notify(entowner, 1, 3, "someone is destroying one of your props with a blowtorch!!!")
					entowner:PrintMessage(HUD_PRINTTALK, "someone is destroying one of your props with a blowtorch!")
				end
			end
		elseif(trfive.Entity:GetNWInt("welddamage") > 1) then
			trfive.Entity:SetNWInt("welddamage", trfive.Entity:GetNWInt("welddamage") - 1)
			if SERVER then
				if (trfive.Entity:GetNWInt("welddamage")==130) then
					if SERVER then
						if (player.GetByUniqueID(trfive.Entity:GetVar("PropProtection"))!=false) then
							local entowner = player.GetByUniqueID(trfive.Entity:GetVar("PropProtection"))
							Notify(entowner, 1, 3, "someone has nearly finished destroying one of your props using blowtorch!!!")
							entowner:PrintMessage(HUD_PRINTTALK, "someone has nearly finished destroying one of your props with a blowtorch!")
						end
					end
				end
			end
		else
			if SERVER then
				if (player.GetByUniqueID(trfive.Entity:GetVar("PropProtection"))!=false) then
						local entowner = player.GetByUniqueID(trfive.Entity:GetVar("PropProtection"))
						Notify(entowner, 1, 3, "someone has destroyed one of your props using a blowtorch!!!")
						entowner:PrintMessage(HUD_PRINTTALK, "someone has destroyed one of your props with a blowtorch!")
				end
			end
			local effectdata = EffectData() 
				effectdata:SetStart( trfive.Entity:GetPos() )
				effectdata:SetOrigin( trfive.Entity:GetPos() ) 
				effectdata:SetScale( 1 ) 
			util.Effect( "Explosion", effectdata ) 
			if SERVER then
				timer.Destroy(tostring(trfive.Entity) .. "unweldamage")
				// stick the thumb 30 seconds deeper into their ass and keep them from spawning anything on a successful weld attempt
				timer.Create(tostring(trfive.Entity) .. "unweldamage", 30, 1, WeldControl, trfive.Entity, player.GetByUniqueID(trfive.Entity:GetVar("PropProtection")))
				//WeldControl(trfive.Entity, player.GetByUniqueID(trfive.Entity:GetVar("PropProtection")))
				timer.Destroy(tostring(trfive.Entity) .. "undamagecolor")
				trfive.Entity:Remove()
			end
		end
	end
	
end


// secondary attack - repair shit.
// temporarily disabled to prevent "cant spawn shit ever again" glitch

function SWEP:SecondaryAttack()
	/*
	self.Weapon:SetNextSecondaryFire(CurTime() + .125)
	
	local trace = self.Owner:GetEyeTrace()
	local snd = math.random(1,6)
	// some of the spark sounds are annoying.
	if (snd==5 || snd==6) then snd=4 end
	// filter what class it is, so that retards cannot delete crazy shit such as important map parts, jeeps, doors, etc.
	if (trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 and (trace.Entity:GetClass()=="prop_physics" || trace.Entity:GetClass()=="phys_magnet" || trace.Entity:GetClass()=="gmod_spawner" || trace.Entity:GetClass()=="gmod_wheel" || trace.Entity:GetClass()=="gmod_thruster" || trace.Entity:GetClass()=="gmod_button")and trace.Entity:IsValid()) then
		local effectdata = EffectData()
			effectdata:SetOrigin(trace.HitPos)
			effectdata:SetMagnitude( 1 )
			effectdata:SetScale( 2 )
			effectdata:SetRadius( 2 )
		util.Effect( "Sparks", effectdata )
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		
		// self.Weapon:EmitSound("physics/metal/metal_box_impact_soft2.wav")
		self.Weapon:EmitSound("ambient/energy/spark" .. snd .. ".wav")
		if(trace.Entity:GetNWInt("welddamage") != nil && trace.Entity:GetNWInt("welddamage") > 0 && trace.Entity:GetNWInt("welddamage") < 255) then
			trace.Entity:SetNWInt("welddamage", trace.Entity:GetNWInt("welddamage") + 1)
		end
	else
		self.Weapon:EmitSound("ambient/energy/spark" .. snd.. ".wav")
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
	*/
end

// this isnt needed anymore, since there is a hook to make it not drop.
function SWEP:Equip()
	if SERVER then
		if (self.WasEquipped==1) then self.Weapon:Remove() end
		self.WasEquipped=1
	end
end

function SWEP:ShouldDropOnDie()
	return false
end