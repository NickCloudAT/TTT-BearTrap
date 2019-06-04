AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

resource.AddFile("sound/beartrap.wav")
resource.AddFile("models/stiffy360/c_beartrap.dx80.vtx")
resource.AddFile("models/stiffy360/c_beartrap.dx90.vtx")
resource.AddFile("models/stiffy360/c_beartrap.mdl")
resource.AddFile("models/stiffy360/c_beartrap.sw.vtx")
resource.AddFile("models/stiffy360/c_beartrap.vvd")
resource.AddFile("models/stiffy360/c_beartrap.xbox.vtx")
resource.AddFile("models/stiffy360/beartrap.dx80.vtx")
resource.AddFile("models/stiffy360/beartrap.dx90.vtx")
resource.AddFile("models/stiffy360/beartrap.mdl")
resource.AddFile("models/stiffy360/beartrap.phy")
resource.AddFile("models/stiffy360/beartrap.sw.vtx")
resource.AddFile("models/stiffy360/beartrap.vvd")
resource.AddFile("models/stiffy360/beartrap.xbox.vtx")
resource.AddFile("materials/models/freeman/beartrap_specular.vtf")
resource.AddFile("materials/models/freeman/beartrap_diffuse.vtf")
resource.AddFile("materials/models/freeman/trap_dif.vmt")
resource.AddFile("materials/models/stiffy360/c_beartrap.dx80.vtx")
resource.AddFile("materials/models/stiffy360/c_beartrap.dx90.vtx")
resource.AddFile("materials/models/stiffy360/c_beartrap.mdl")
resource.AddFile("materials/models/stiffy360/c_beartrap.sw.vtx")
resource.AddFile("materials/models/stiffy360/c_beartrap.vvd")
resource.AddFile("materials/models/stiffy360/c_beartrap.xbox.vtx")
resource.AddFile("materials/models/stiffy360/beartrap.dx80.vtx")
resource.AddFile("materials/models/stiffy360/beartrap.dx90.vtx")
resource.AddFile("materials/models/stiffy360/beartrap.mdl")
resource.AddFile("materials/models/stiffy360/beartrap.phy")
resource.AddFile("materials/models/stiffy360/beartrap.sw.vtx")
resource.AddFile("materials/models/stiffy360/beartrap.vvd")
resource.AddFile("materials/models/stiffy360/beartrap.xbox.vtx")
resource.AddFile("materials/vgui/ttt/icon_beartrap.png")
resource.AddFile("vgui/ttt/icon_beartrap.vmt")
resource.AddFile("vgui/ttt/icon_beartrap.vtf")
resource.AddFile("materials/icon_beartrap.vmt")
resource.AddFile("materials/icon_beartrap.vtf")

function ENT:Initialize()
	self:SetModel("models/stiffy360/beartrap.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if self:GetPhysicsObject():IsValid() then
		self:GetPhysicsObject():EnableMotion(false)
	end
	self:SetSequence("ClosedIdle")
	timer.Simple(2, function()
		if IsValid(self) then
			self:SetSequence("OpenIdle")
		end
	end)
	self:SetUseType(SIMPLE_USE)
	self.dmg = 0
end

local function DoBleed(ent)
   if not IsValid(ent) or (ent:IsPlayer() and (not ent:Alive() or not ent:IsTerror())) then
      return
   end

   local jitter = VectorRand() * 30
   jitter.z = 20

   util.PaintDown(ent:GetPos() + jitter, "Blood", ent)
end

function ENT:Touch(toucher)
	if !IsValid(toucher) and !toucher:IsPlayer() then return end	
	if self:GetSequence() ~= 0 and self:GetSequence() ~= 2 then
		self:SetPlaybackRate(1)
		self:SetCycle(0)
		self:SetSequence("Snap")
		self:EmitSound("beartrap.wav")
		toucher.IsTrapped = true
		local dmg = DamageInfo()
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
		dmg:SetDamage(8)
		dmg:SetDamageType(DMG_GENERIC)
		if toucher:IsPlayer() then
			toucher:ChatPrint("BearTrap: Dont't be sad. You have a little chance of escaping this trap :)")
			timer.Create("beartrapdmg" .. toucher:EntIndex(), 1, 0, function()
				if !IsValid(toucher) then timer.Destroy("beartrapdmg" .. toucher:EntIndex()) return end
				
				local randint = math.random(1, 100)
				if randint == 32 or randint == 76 or randint == 15 then
					timer.Destroy("beartrapdmg" .. toucher:EntIndex())
					toucher.IsTrapped = false
					toucher:Freeze(false)
					toucher:ChatPrint("BearTrap: You had luck and escaped the beartrap!")
					return
				end
				
				toucher:TakeDamageInfo(dmg)
				toucher:Freeze(true)
				DoBleed(toucher)
				if !toucher:Alive() or !toucher.IsTrapped or !IsValid(self) then
					timer.Destroy("beartrapdmg" .. toucher:EntIndex())
					toucher.IsTrapped = false
					toucher:Freeze(false)
					return
				end
			end)
		end
		
		timer.Simple(0.1, function() self:SetSequence("ClosedIdle") end)
	end
end

if SERVER then
	hook.Add("TTTPrepareRound", "DestroyBearTrapTimers", function()
		for _, v in ipairs(player.GetAll()) do
			if IsValid(v) then
				v.IsTrapped = false
			end
		end
	end)
end

function ENT:Use(act)
	if IsValid(act) and act:IsPlayer() then
		
		if self.Owner:Alive() and act != self.Owner then
			return
		end
		
		if !act:HasWeapon("weapon_ttt_beartrap") then
			act:Give("weapon_ttt_beartrap")
			self:Remove()
		end
	end
end

function ENT:OnTakeDamage(dmg)
	self.dmg = self.dmg + dmg:GetDamage()
	if self.dmg >= 25 then
		if self:GetSequence() ~= 0 and self:GetSequence() ~= 2 then
			self:SetPlaybackRate(1)
			self:SetCycle(0)
			self:SetSequence("Snap")
			timer.Simple(0.1, function() self:SetSequence("ClosedIdle") end)
		end
	end
end