if CLIENT then
   SWEP.Slot      = 7

	SWEP.ViewModelFlip		= false
	SWEP.ViewModelFOV		= 54
end

SWEP.Base = "weapon_tttbase"

SWEP.HoldType = "normal"
SWEP.PrintName = "Beartrap"
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
	  name = "Beartrap",
      desc = [[OM NOM NOM... OM NOM ]]
   }

	function SWEP:GetViewModelPosition(pos, ang)
		return pos + ang:Forward() * 15, ang
	end
end

if SERVER then

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
		local tr = util.TraceLine({start = self.Owner:GetShootPos(), endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 100, filter = self.Owner})
		if tr.HitWorld then
			local dot = vector_up:Dot(tr.HitNormal)
			if dot > 0.55 and dot <= 1 then
				local ent = ents.Create("ttt_bear_trap")
				ent:SetPos(tr.HitPos + tr.HitNormal)
				local ang = tr.HitNormal:Angle()
				ang:RotateAroundAxis(ang:Right(), -90)
				ent:SetAngles(ang)
				ent:Spawn()
				ent.Owner = self.Owner
				ent.fingerprints = self.fingerprints
				self:Remove()
			end
		end
	end

	function SWEP:Deploy()
	end

	function SWEP:OnRemove()
		if self.Owner:IsValid() and self.Owner:IsPlayer() then
			self.Owner:ConCommand("lastinv")
		end
	end


end
