CreateConVar("ttt_beartrap_escape_pct", 0.03, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Escape chance each time you get damaged by the BearTrap")
CreateConVar("ttt_beartrap_damage_per_tick", 8, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Amount of damage dealt per tick")

hook.Add('TTTUlxInitCustomCVar', 'TTTBeartrapInitRWCVar', function(name)
	ULib.replicatedWritableCvar('ttt_beartrap_escape_pct', 'rep_ttt_beartrap_escape_pct', GetConVar('ttt_beartrap_escape_pct'):GetFloat(), true, false, name)
	ULib.replicatedWritableCvar('ttt_beartrap_damage_per_tick', 'rep_ttt_beartrap_damage_per_tick', GetConVar('ttt_beartrap_damage_per_tick'):GetInt(), true, false, name)
end)

if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	hook.Add('TTTUlxModifyAddonSettings', 'TTTBeartrapModifySettings', function(name)
		local tttrspnl = xlib.makelistlayout{w = 415, h = 318, parent = xgui.null}

		local tttrsclp = vgui.Create('DCollapsibleCategory', tttrspnl)
		tttrsclp:SetSize(390, 80)
		tttrsclp:SetExpanded(1)
		tttrsclp:SetLabel('Basic Settings')

		local tttrslst = vgui.Create('DPanelList', tttrsclp)
		tttrslst:SetPos(5, 25)
		tttrslst:SetSize(390, 60)
		tttrslst:SetSpacing(5)

		local tttrsdh1 = xlib.makeslider{label = 'ttt_beartrap_escape_pct (Def. 0.03)', repconvar = 'rep_ttt_beartrap_escape_pct', min = 0, max = 1, decimal = 2, parent = tttrslst}
		tttrslst:AddItem(tttrsdh1)

		local tttrsdh2 = xlib.makeslider{label = 'ttt_beartrap_damage_per_tick (Def. 8)', repconvar = 'rep_ttt_beartrap_damage_per_tick', min = 1, max = 100, decimal = 0, parent = tttrslst}
		tttrslst:AddItem(tttrsdh2)

		xgui.hookEvent('onProcessModules', nil, tttrspnl.processModules)
		xgui.addSubModule('Beartrap', tttrspnl, nil, name)
	end)
end