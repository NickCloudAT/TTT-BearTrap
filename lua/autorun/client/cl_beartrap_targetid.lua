-- handle looking at beartraps
hook.Add('TTTRenderEntityInfo', 'ttt2_beartrap_highlight_beartrap', function(tData)
    local client = LocalPlayer()
    local bt_class = tData:GetEntity():GetClass()
  
    if tData:GetEntityDistance() > 100 then return end
    if bt_class ~= "ttt_bear_trap" then return end
    if not IsValid(client) or not client:IsTerror() or not client:Alive() then return end
  
    local canPickup = true
  
    local bt_owner = tData:GetEntity():GetNWEntity('BTOWNER')
  
    if IsValid(bt_owner) and bt_owner ~= client then
      if bt_owner:IsTerror() then canPickup = false end
    end
  
    if not canPickup then return end
  
    tData:EnableText()
    tData:EnableOutline()
    tData:SetOutlineColor(client:GetRoleColor())
  
    tData:SetTitle("Beartrap")
    tData:SetSubtitle(LANG.GetTranslation('ttt_bt_pickup'))
    tData:SetKeyBinding("+use")
  
  end)