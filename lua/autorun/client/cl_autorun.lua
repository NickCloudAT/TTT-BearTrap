if not CLIENT then return end

net.Receive("ttt_bt_send_to_chat", function()
    chat.AddText(LANG.GetTranslation(net.ReadString()))
end)