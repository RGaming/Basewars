SWEP.Base = "weapon_base" 

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.PrintName = "Vuvuzela"
SWEP.Author = "CapsAdmin"
SWEP.Instructions = "Hold attack to annoy"
SWEP.Purpose = "Annoyance"
SWEP.Category = "CapsAdmin"

SWEP.DrawCrosshair = false
SWEP.DrawWeaponInfoBox = false
SWEP.DrawAmmo = false

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.ViewModel = ""
SWEP.WorldModel = "models/vuvuzela.mdl"

SWEP.Pitch = 100
SWEP.Size = 1


function SWEP:SetupDataTables()
	self:DTVar("Vector", 0, "color")
	self:DTVar("Bool", 0, "on")
end

if SERVER then
	AddCSLuaFile( "shared.lua" )

	function SWEP:SecondaryAttack() end
	
	function SWEP:Think()	
		self.dt.on = self.Owner:KeyDown(IN_ATTACK2)
	end
	
	function SWEP:PrimaryAttack()
		if self.dt.on then return end
		umsg.Start("Vuvuzela:OneShot")
			umsg.Entity(self)
		umsg.End()
	end
		
else
	
	usermessage.Hook("Vuvuzela:OneShot", function(umr)
		local vuvuzela = umr:ReadEntity()
		if vuvuzela.OneShot then vuvuzela:OneShot() end
	end)
	
	function SWEP:InitializeSounds()
		if not IsValid(self.Owner) then return end
		
		if self.close then self.close:Stop() end
		if self.far then self.far:Stop() end
		
		self.close = CreateSound(self.Owner, "vuvuzela_loop_close.wav")
		self.far = CreateSound(self.Owner, "vuvuzela_loop_far.wav")
		self.release = Sound("vuvuzela_release.mp3")
		
		self.far:SetSoundLevel(0)
		self.far:PlayEx(0,0)
		self.close:SetSoundLevel(0)
		self.close:PlayEx(0,0)
		
		timer.Simple(0.1,function() 
			self.close:Stop()
			self.close:SetSoundLevel(70) 
			self.close:PlayEx(0,0) 
		end)
		
		self.smoothvolume = 0
		self.smoothpitch = self.Pitch
		
		self.released = true
		self.initialized = true
	end
	
	function SWEP:ReverbRelease()
		if not self.initialized then self:InitializeSounds() end
		WorldSound(self.release, self.Owner:GetPos(), 0, self.smoothpitch)
	end
	
	function SWEP:OneShot()
		if not self.initialized then self:InitializeSounds() end
		local path = "vuvuzela_oneshot_"..math.random(5)..".mp3"
		if not self.busy then
			local pitch = self.Pitch + math.Rand(-2,2) * (self.Pitch/255)
			local time = pitch/255*-1+0.5
			self:EmitSound(path, 120, pitch)
			self:ReverbRelease()
			self.busy = true
			timer.Simple(SoundDuration(path)+time-0.3, function()
				self.busy = false
			end)
		end
	end
	
	function SWEP:CalculateSounds()
		if not self.initialized then self:InitializeSounds() end	
		local volume = self.dt.on and 1 or 0
								
		self.smoothvolume = self.smoothvolume + ((volume - self.smoothvolume) / 3)
		self.smoothpitch = self.smoothpitch + ((self.Pitch + (math.Rand(-self.RandomPitch,self.RandomPitch)*(self.Pitch/255)) - self.smoothpitch) / 20)
		
		self.close:ChangeVolume(volume)
		self.close:ChangePitch(self.smoothpitch)
		
		self.far:ChangeVolume(self.smoothvolume)
		self.far:ChangePitch(self.smoothpitch)
		
		
		if self.smoothvolume > 0.66 then
			if not self.dt.on and not self.released then
				self:ReverbRelease()
				self.released = true
			elseif self.dt.on then
				self.released = false
			end
		
		end
		
		if not self.deployed then
			self:Deploy()
			self.deployed = true
		end
	
	end
	
	local visible = false
	
	hook.Add("PostPlayerDraw","Vuvuzela:PostPlayerDraw", function(ply)
		local self = ply:GetActiveWeapon()
		if IsValid(self) and self:GetClass():find("vuvuzela", 0, true) and IsValid(self.model) then
			local ply = self.Owner
			
			if not IsValid(ply) then self:DrawModel() return end
			
			local posang = ply:GetAttachment(ply:LookupAttachment("mouth"))
			
			if not posang then 
				posang = {}
				
				local headpos, headang = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
				
				posang.Pos = headpos
				posang.Ang = headang
				
				posang.Ang:RotateAroundAxis(posang.Ang:Right(), 90)
				posang.Ang:RotateAroundAxis(posang.Ang:Up(), -90)
			end
			
			local position = posang.Pos
			local angles = posang.Ang
							
			position = position + angles:Forward() * (13 * self.Size)

			local shake = Vector(0)
			
			if self.dt.on then
				shake = VectorRand() * 0.3
			end
			
			self.model:SetRenderOrigin(position+shake)
			self.model:SetRenderAngles(angles)
			self.model:SetModelScale(Vector()*self.Size)
			local color = self.dt.color
			render.SetColorModulation(color.x,color.y,color.z)
			self.model:DrawModel()
			
			if ply == LocalPlayer() then
				visible = true
				timer.Create("Vuvuzela:LocalPlayerVisible", 0.1, 1, function()
					visible = false
				end)
			end
		end
	end)
	
	local function RandomSphere()
		return Angle(math.Rand(-180,180),math.Rand(-180,180),math.Rand(-180,180)):Forward()
	end
		
	hook.Add("Think", "Vuvuzela:Think", function()
		for key, ply in pairs(player.GetAll()) do
			local self = ply:GetActiveWeapon()
			if IsValid(self) and self:GetClass():find("vuvuzela", 0, true) and self.CalculateSounds then
				self:CalculateSounds()
			end
		end
	end)
	
	hook.Add("PostDrawOpaqueRenderables", "Vuvuzela:PostDrawOpaqueRenderables", function()
		local self = LocalPlayer():GetActiveWeapon()
		if not IsValid(self) then return end
		if not self:GetClass():find("vuvuzela") then return end
		if not IsValid(self.model) then return end
				
		if not visible then
			local color = self.dt.color
			render.SetColorModulation(color.x,color.y,color.z)
			self.model:DrawModel()
		end
	end)
	
	hook.Add("CalcView", "Vuvuzela:CalcView", function(ply, origin, angles, fov)
		local self = ply:GetActiveWeapon()
		if not IsValid(self) then return end
		if not self:GetClass():find("vuvuzela") then return end
		
		if not IsValid(self.model) then return end
		
		local shake = Vector(0)
	
		if ply:KeyDown(IN_ATTACK2) then
			shake = VectorRand() * 0.2
		end
				
		local position = origin + angles:Up() * (-5*self.Size) + angles:Forward() * 10 + shake
		
		self.model:SetRenderOrigin(position)
		self.model:SetRenderAngles(angles)		
	end)
	
	function SWEP:Deploy()
		self:InitializeSounds()
		if IsValid(self.model) then self.model:Remove() end
		local model = ClientsideModel(self.WorldModel)
		model:SetNoDraw(true)
		model:SetModelScale(Vector()*self.Size * 2)
		model:SetMaterial("models/debug/debugwhite")
		self.model = model
		return true
	end
	
	
	function SWEP:Holster()
		if not self.initialized then self:InitializeSounds() end
		if self.close then self.close:PlayEx(0,0) end
		if self.far then self.far:PlayEx(0,0) end
		return true
	end
	
	function SWEP:DrawWorldModel() end
	function SWEP:PrimaryAttack() end
	function SWEP:SecondaryAttack() end
end



function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
	if CLIENT then 
		self.emitter = ParticleEmitter(self:GetPos())
		self:Deploy()
	else
		local color = HSVToColor(math.random(360),0.7, 0.7)
		self.dt.color = Vector(color.r/255,color.b/255,color.g/255)
	end
end