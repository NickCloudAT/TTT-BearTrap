if CLIENT then

    local beatrap_addon_name = 'BEARTRAP'

    hook.Add('Initialize', 'ttt_beartrap_init', function()
		-- ENGLISH
		LANG.AddToLanguage('English', 'ttt_bt_catched', '[' .. beatrap_addon_name .. ']: Don\'t be sad. You have a small chance of escaping this trap! :)')
		LANG.AddToLanguage('English', 'ttt_bt_escaped', '[' .. beatrap_addon_name .. ']: You got lucky and escaped the beartrap!')
		LANG.AddToLanguage('English', 'ttt_bt_freed', '[' .. beatrap_addon_name .. ']: You got lucky and were freed!')
    LANG.AddToLanguage('English', 'ttt_bt_pickup', 'Press [key] to pickup beatrap')

		-- GERMAN
		LANG.AddToLanguage('Deutsch', 'ttt_bt_catched', '[' .. beatrap_addon_name .. ']: Sei nicht traurig. Mit etwas Glück kannst du der Falle entkommen! :)')
		LANG.AddToLanguage('Deutsch', 'ttt_bt_escaped', '[' .. beatrap_addon_name .. ']: Du hattest Glück und bist der Falle entkommen!')
		LANG.AddToLanguage('Deutsch', 'ttt_bt_freed', '[' .. beatrap_addon_name .. ']: Du hattest Glück und wurdest befreit!')
    end)

    net.Receive("ttt_bt_send_to_chat", function()
        chat.AddText(LANG.GetTranslation(net.ReadString()))
    end)

end
