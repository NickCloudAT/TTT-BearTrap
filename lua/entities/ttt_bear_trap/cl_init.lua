include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

if TTT2 and CLIENT then
	hook.Add("Initialize", "ttt_beartrap init", function() 
		STATUS:RegisterStatus("ttt2_beartrap", {
			hud = Material("vgui/ttt/hud_icon_beartrap.png"),
			type = "bad"
		})
	end)
end