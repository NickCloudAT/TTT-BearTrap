CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "submenu_addons_beartrap_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_addons_beartrap")

	form:MakeHelp({
		label = "help_beartrap_menu"
	})

    //Sliders

	form:MakeSlider({
		label = "label_beartrap_escape_pct",
		serverConvar = "ttt_beartrap_escape_pct",
		min = 0,
		max = 1,
		decimal = 2
	})

    form:MakeSlider({
		label = "label_beartrap_damage_per_tick",
		serverConvar = "ttt_beartrap_damage_per_tick",
		min = 0,
		max = 100,
		decimal = 0
	})

end