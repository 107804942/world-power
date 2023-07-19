

include("IconSupport")

local Magellan = {
  label = "TXT_KEY_MAGELLAN_NOTIFICATIONS", 
  key   = "MAGELLAN_NOTIFICATIONS", 
  item = "Magellan",
  show  = true, 
  ui    = true, 
}

function OnMagellanNotification(cbData)
  print(string.format("OnMagellan(%i, %i, %s, %s)", cbData.iExtra1, cbData.iExtra2, cbData.sHeading, cbData.sText))
  local instance = {}
  ContextPtr:BuildInstanceForControl("MagellanItem", instance, cbData.parent)
  cbData.instance = instance
end
Magellan.callback = OnMagellanNotification

function OnMagellanNotificationIdRequest()
  if (Magellan.id ~= nil) then
    LuaEvents.MagellanNotificationId(Magellan.id)
  end
end
LuaEvents.MagellanNotificationIdRequest.Add(OnMagellanNotificationIdRequest)

function Register()
  LuaEvents.CustomNotificationAddin(Magellan)
  OnMagellanNotificationIdRequest()
end

Register()
