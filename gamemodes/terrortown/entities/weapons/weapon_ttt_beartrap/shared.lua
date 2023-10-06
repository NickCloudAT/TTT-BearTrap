if CLIENT then
	SWEP.Slot = 7
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV	= 54
end

SWEP.Base = "weapon_tttbase"

SWEP.HoldType = "normal"
SWEP.PrintName = "beartrap_name"
SWEP.ViewModel  = "models/stiffy360/c_beartrap.mdl"
SWEP.WorldModel  = "models/stiffy360/beartrap.mdl"
SWEP.UseHands	= true
SWEP.Kind = WEAPON_EQUIP2
SWEP.AutoSpawnable = false
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.LimitedStock = true

if CLIENT then
	SWEP.Icon = "vgui/ttt/icon_beartrap.png"

	SWEP.EquipMenuData = {
		type = "item_weapon",
		name = "beartrap_name",
		desc = "beartrap_desc",
	}

	function SWEP:GetViewModelPosition(pos, ang)
		return pos + ang:Forward() * 15, ang
	end
end

if SERVER then
	CreateConVar("ttt_beartrap_escape_pct", 0.03, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Escape chance each time you get damaged by the BearTrap")
	CreateConVar("ttt_beartrap_damage_per_tick", 8, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Amount of damage dealt per tick")
	CreateConVar("ttt_beartrap_disarm_health", 25, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "How much damage the beartrap can take")

	resource.AddFile("materials/vgui/ttt/icon_beartrap.png")
	resource.AddFile("materials/vgui/ttt/hud_icon_beartrap.png")

	resource.AddFile("materials/models/freeman/beartrap_diffuse.vtf")
	resource.AddFile("materials/models/freeman/beartrap_specular.vtf")
	resource.AddFile("materials/models/freeman/trap_dif.vmt")

	resource.AddFile("sound/beartrap.wav")

	resource.AddFile("models/stiffy360/beartrap.dx80.vtx")
	resource.AddFile("models/stiffy360/beartrap.dx90.vtx")
	resource.AddFile("models/stiffy360/beartrap.mdl")
	resource.AddFile("models/stiffy360/beartrap.phy")
	resource.AddFile("models/stiffy360/beartrap.sw.vtx")
	resource.AddFile("models/stiffy360/beartrap.vvd")
	resource.AddFile("models/stiffy360/beartrap.xbox.vtx")

	resource.AddFile("models/stiffy360/c_beartrap.dx80.vtx")
	resource.AddFile("models/stiffy360/c_beartrap.dx90.vtx")
	resource.AddFile("models/stiffy360/c_beartrap.mdl")
	resource.AddFile("models/stiffy360/c_beartrap.sw.vtx")
	resource.AddFile("models/stiffy360/c_beartrap.vvd")
	resource.AddFile("models/stiffy360/c_beartrap.xbox.vtx")

end

function SWEP:Deploy()
	self.Weapon:DrawWorldModel(false)
end

if SERVER then
	AddCSLuaFile()

	function SWEP:PrimaryAttack()
		local owner = self:GetOwner()
		local tr = util.TraceLine({start = owner:GetShootPos(), endpos = owner:GetShootPos() + owner:GetAimVector() * 100, filter = owner})
		if tr.HitWorld then
			local dot = vector_up:Dot(tr.HitNormal)
			if dot > 0.55 and dot <= 1 then
				local ent = ents.Create("ttt_bear_trap")
				ent:SetPos(tr.HitPos + tr.HitNormal)
				local ang = tr.HitNormal:Angle()
				ang:RotateAroundAxis(ang:Right(), -90)
				ent:SetAngles(ang)
				ent:Spawn()
				ent.Owner = owner
				ent:SetNWEntity("BTOWNER", owner)
				ent.fingerprints = self.fingerprints
				self:Remove()
			end
		end
	end

	function SWEP:Deploy()
	end

	function SWEP:OnRemove()
		local owner = self:GetOwner()
		if IsValid(owner) and owner:IsPlayer() then
			owner:ConCommand("lastinv")
		end
	end
end

if CLIENT then
	function SWEP:Initialize()
		self:AddTTT2HUDHelp("beartrap_help_primary")
	end

	function SWEP:AddToSettingsMenu(parent)
		local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

		form:MakeSlider({
			serverConvar = "ttt_beartrap_disarm_health",
			label = "label_beartrap_disarm_health",
			min = 0,
			max = 100,
			decimal = 0,
		})

		form:MakeSlider({
			serverConvar = "ttt_beartrap_escape_pct",
			label = "label_beartrap_escape_pct",
			min = 0,
			max = 1,
			decimal = 2,
		})

		form:MakeSlider({
			serverConvar = "ttt_beartrap_damage_per_tick",
			label = "label_beartrap_damage_per_tick",
			min = 0,
			max = 100,
			decimal = 0,
		})
	end
end