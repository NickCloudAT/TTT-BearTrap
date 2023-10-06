include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

if TTT2 and CLIENT then
	local TryT = LANG.TryTranslation
	local ParT = LANG.GetParamTranslation

	hook.Add("Initialize", "ttt_beartrap init", function()
		STATUS:RegisterStatus("ttt2_beartrap", {
			hud = Material("vgui/ttt/hud_icon_beartrap.png"),
			type = "bad"
		})
	end)

	hook.Add("TTTRenderEntityInfo", "ttt2_beartrap_highlight_beartrap", function(tData)
		local client = LocalPlayer()
		local ent = tData:GetEntity()

		if not IsValid(client) or not client:IsTerror() or not client:Alive()
		or not IsValid(ent) or tData:GetEntityDistance() > 100 or ent:GetClass() ~= "ttt_bear_trap" then
			return
		end

		local bt_owner = tData:GetEntity():GetNWEntity("BTOWNER")

		if IsValid(bt_owner) and bt_owner ~= client and bt_owner:IsTerror() then
			return
		end

		tData:EnableText()
		tData:EnableOutline()
		tData:SetOutlineColor(client:GetRoleColor())

		tData:SetTitle(TryT("beartrap_name"))
		tData:SetSubtitle(ParT("target_pickup", {usekey = Key("+use", "USE")}))
		tData:SetKeyBinding("+use")
		tData:AddDescriptionLine(TryT("beartrap_desc"))
	end)

	local materialIcon = Material("vgui/ttt/hud_icon_beartrap.png")

	net.Receive("ttt_bt_send_to_chat", function(len, ply)
		local langKey = net.ReadString()

		MSTACK:AddColoredImagedMessage(
			LANG.TryTranslation(langKey),
			nil,
			materialIcon
		)
	end)
end