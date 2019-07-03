AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

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

util.AddNetworkString("ttt_bt_send_to_chat")
local function LangChatPrint(ply, lang_key)
	net.Start("ttt_bt_send_to_chat")
	net.WriteString(lang_key)
	net.Send(ply)
end

function ENT:Touch(toucher)
	if not IsValid(toucher) or not IsValid(self) then return end
	if self:GetSequence() ~= 0 and self:GetSequence() ~= 2 then
		self:SetPlaybackRate(1)
		self:SetCycle(0)
		self:SetSequence("Snap")
		self:EmitSound("beartrap.wav")

		if not toucher:IsPlayer() then
			timer.Simple(0.1, function()
				if not IsValid(self) then return end
				self:SetSequence("ClosedIdle")
			end)
			return
		end

		if toucher.IsTrapped then return end

		toucher.IsTrapped = true

		local escpct = GetConVar("ttt_beartrap_escape_pct"):GetFloat()

		if TTT2 then -- add element to HUD if TTT2 is loaded
			STATUS:AddStatus(toucher, "ttt2_beartrap")
		end

		LangChatPrint(toucher, "ttt_bt_catched")

		timer.Create("beartrapdmg" .. toucher:EntIndex(), 1, 0, function()
			if !IsValid(toucher) then timer.Destroy("beartrapdmg" .. toucher:EntIndex()) return end

			local randint = math.Rand(0, 1)
			randint = math.Round(randint, 2)

			if randint < escpct then
				timer.Destroy("beartrapdmg" .. toucher:EntIndex())
				toucher.IsTrapped = false
				toucher:Freeze(false)
				LangChatPrint(toucher, "ttt_bt_escaped")

				if TTT2 then -- remove element to HUD if TTT2 is loaded
					STATUS:RemoveStatus(toucher, "ttt2_beartrap")
				end

				return
			end

			if not toucher:IsTerror() or not toucher:Alive() or not toucher.IsTrapped or not IsValid(self) then
				timer.Destroy("beartrapdmg" .. toucher:EntIndex())
				toucher.IsTrapped = false
				toucher:Freeze(false)

				if toucher:Health() > 0 then
					LangChatPrint(toucher, "ttt_bt_freed")
				end

				if TTT2 then -- remove element to HUD if TTT2 is loaded
					STATUS:RemoveStatus(toucher, "ttt2_beartrap")
				end

				return
			end

			local dmg = DamageInfo()

			local attacker = nil
			if IsValid(self.Owner) then
				attacker = self.Owner
			else
				attacker = toucher
			end

			dmg:SetAttacker(attacker)
			local inflictor = ents.Create("weapon_ttt_beartrap")
			dmg:SetInflictor(inflictor)
			dmg:SetDamage(GetConVar("ttt_beartrap_damage_per_tick"):GetInt())
			dmg:SetDamageType(DMG_GENERIC)

			toucher:TakeDamageInfo(dmg)
			toucher:Freeze(true)
			DoBleed(toucher)

		end)

		timer.Simple(0.1, function()
			if not IsValid(self) then return end
			self:SetSequence("ClosedIdle")
		end)
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
	if IsValid(act) and act:IsPlayer() and IsValid(self) then

		if self.Owner and IsValid(self.Owner) then
			if self.Owner:IsTerror() and self.Owner ~= act then
				return
			end
		end

		if !act:HasWeapon("weapon_ttt_beartrap") then
			act:Give("weapon_ttt_beartrap")
			self:Remove()
		end
	end
end

function ENT:OnTakeDamage(dmg)
	if not IsValid(self) then return end
	self.dmg = self.dmg + dmg:GetDamage()
	if self.dmg >= 25 then
		if self:GetSequence() ~= 0 and self:GetSequence() ~= 2 then
			self:SetPlaybackRate(1)
			self:SetCycle(0)
			self:SetSequence("Snap")
			timer.Simple(0.1, function()
				if not IsValid(self) then return end
				self:SetSequence("ClosedIdle")
			end)
		end
	end
end
