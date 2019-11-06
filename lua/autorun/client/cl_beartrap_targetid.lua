-- handle looking at beartraps
hook.Add('TTTRenderEntityInfo', 'ttt2_beartrap_highlight_beartrap', function(data, params)
  local client = LocalPlayer()
  local bt_class = data.ent:GetClass()

  if data.distance > 100 then return end
  if bt_class ~= "ttt_bear_trap" then return end
  if not IsValid(client) or not client:IsTerror() or not client:Alive() then return end

  local canPickup = true

  local bt_owner = data.ent:GetNWEntity('BTOWNER')

  if IsValid(bt_owner) and bt_owner ~= client then
    if bt_owner:IsTerror() then canPickup = false end
  end

  if not canPickup then return end

  params.drawInfo = true
  params.displayInfo.key = input.GetKeyCode(input.LookupBinding('+use'))
  params.displayInfo.title.text = LANG.GetTranslation('ttt_bt_pickup')
  params.drawOutline = true
  params.outlineColor = client:GetRoleColor()
end)
