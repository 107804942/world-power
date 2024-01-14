include("IconSupport")
include("InstanceManager")


-- PLAGUE MOD
include( "Plague_UI.lua" );
include( "Health_Events.lua" );

------------------------------------------------------------------
--local bAbandonCity	 = (PreGame.GetGameOption("GAMEOPTION_PLAGUE_DESTROYS_CITIES") == 1)

--local plagueThreshold		   = 150
--if Game then plagueThreshold = (GameDefines["HEALTH_PLAGUE_MIN_THRESHOLD_" .. GameInfo.GameSpeeds[Game.GetGameSpeedType()].Type] or 150) end

--------------------------------------------------------------------
local g_ProductionManager = InstanceManager:new("CityHealth", "City", Controls.HealthStack)

local g_SortTable = {}
local g_ActiveSort = "status"
local g_ReverseSort = false

local g_StatusIcons = {"", "[ICON_PLAGUE]"}
local g_StatusToolTips = {"", "TXT_KEY_CH_STATUS_PLAGUED_TT"}

--------------------------------------------------------------------
function OnSort(sort)
  if (sort == g_ActiveSort) then
    g_ReverseSort = not g_ReverseSort
  else
    g_ReverseSort = not (sort == "name" or sort == "status")
    g_ActiveSort = sort
  end

  Controls.HealthStack:SortChildren(SortByValue)
end
Controls.SortIcon:RegisterCallback(Mouse.eLClick, function() OnSort("status") end)
Controls.SortName:RegisterCallback(Mouse.eLClick, function() OnSort("name") end)
Controls.SortHealth:RegisterCallback(Mouse.eLClick, function() OnSort("health") end)
Controls.SortRisk:RegisterCallback(Mouse.eLClick, function() OnSort("risk") end)
--------------------------------------------------------------------
function SortByValue(a, b)
  local entryA = g_SortTable[tostring(a)]
  local entryB = g_SortTable[tostring(b)]

  if (entryA == nil or entryB == nil) then
    return tostring(a) < tostring(b)
  end

  local valueA = entryA[g_ActiveSort]
  local valueB = entryB[g_ActiveSort]

  if (valueA == valueB) then
    valueA = entryA.name
    valueB = entryB.name
  elseif (g_ReverseSort) then
    valueA = entryB[g_ActiveSort]
    valueB = entryA[g_ActiveSort]
  end

  if (valueA == nil or valueB == nil) then
    return tostring(a) < tostring(b)
  end

  return valueA < valueB
end
--------------------------------------------------------------------
function OnCity(pCity)
  -- From CityBannerManager
  if (pCity:IsPuppet()) then
    Events.SerialEventGameMessagePopup({Type=ButtonPopupTypes.BUTTONPOPUP_ANNEX_CITY, Data1=pCity:GetID(), Data2=-1, Data3=-1, Option1=false, Option2=false})
  else
    UI.DoSelectCityAtPlot(pCity:Plot())
  end
end
--------------------------------------------------------------------
function UpdateData(iPlayer)
  local pPlayer = Players[iPlayer]

  g_ProductionManager:ResetInstances()
  g_SortTable = {}

  for pCity in pPlayer:Cities() do
    local instance = g_ProductionManager:GetInstance()
    local sort = {}
    g_SortTable[tostring(instance.City)] = sort

	local bPlagued, iTurns = GetCityPlagueInfo(pCity)

    --local iStatus = bPlagued and 2 or 1
    --sort.status = iStatus
    --instance.Icon:SetText(g_StatusIcons[iStatus])

	if bPlagued then --Œ¡“ﬂ◊¥Ã¨

	 local plagueID = pCity:GetPlagueType()
	 local plague = GameInfo.Plagues[plagueID]
	  instance.Icon:SetText(plague.IconString)

		instance.Icon:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_CH_STATUS_PLAGUED_TT", plague.IconString, plague.Description, iTurns))
	else  --∑«Œ¡“ﬂ◊¥Ã¨
	    instance.Icon:SetText("")
		--instance.Icon:SetToolTipString(Locale.ConvertTextKey(g_StatusToolTips[iStatus]))
	end
    
	--------------------------------------------------------------------
	local plagueCounter, plagueThreshold, plagueTurns = Players[pCity:GetOwner()]:GetCityPlagueCounterDetails(pCity, true, true)


	local iHealthLeft = plagueThreshold- plagueCounter
    sort.name = pCity:GetName()
  



	instance.Name:SetText(Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUED_FOR_UI", iHealthLeft,plagueThreshold,pCity:GetName()))


    instance.Name:RegisterCallback(Mouse.eLClick, function() OnCity(pCity) end)


	local totalHealth, totalDisease = Players[pCity:GetOwner()]:GetCityHealthTotal(pCity, true)
	local cityHealth =totalHealth-totalDisease
	local strHealthToolTip = Players[pCity:GetOwner()]:GetCityHealthTT(pCity)

    sort.health = cityHealth
    instance.Health:SetText(cityHealth)
	instance.Health:SetToolTipString(strHealthToolTip)
	
    --sort.risk = GetCityRiskString(cityHealth)
	sort.risk = GetCityRiskString(pCity)
    instance.Risk:SetText(Locale.ConvertTextKey(sort.risk))
	
  end
  
  Controls.HealthStack:SortChildren(SortByValue)
  Controls.HealthStack:CalculateSize()
  Controls.HealthScrollPanel:CalculateInternalSize()
end
--------------------------------------------------------------------
function GetCityRiskString(pCity)
	local strRisk = "TXT_KEY_CH_RISK_LOW"
	local plagueCounter, plagueThreshold, plagueTurns = Players[pCity:GetOwner()]:GetCityPlagueCounterDetails(pCity, true, true)

	local totalHealth, totalDisease = Players[pCity:GetOwner()]:GetCityHealthTotal(pCity, true)

	--if (not bAbandonCity) or totalHealth-totalDisease >= 0  then  ---ŒﬁŒ¡“ﬂ∑Áœ’

		if  totalHealth-totalDisease >= 0  then  ---ŒﬁŒ¡“ﬂ∑Áœ’
		strRisk = "TXT_KEY_CH_RISK_NONE"
	end

		if totalHealth-totalDisease < 0 then


		local plagueTurns=math.max(0,math.ceil((plagueThreshold-plagueCounter)/(totalDisease-totalHealth)))

		if     (plagueTurns > 20) then
			    strRisk = "TXT_KEY_CH_RISK_LOW"

        elseif (plagueTurns <= 20) and (plagueTurns >10 )   then
				strRisk = "TXT_KEY_CH_RISK_AVERAGE"
        elseif (plagueTurns <= 10) and (plagueTurns >5 )   then
				strRisk = "TXT_KEY_CH_RISK_HIGH"
		elseif (plagueTurns <= 5) then
				strRisk = "TXT_KEY_CH_RISK_EXTREME"
		
			end
		end
	--end
	
	return strRisk
end
--------------------------------------------------------------------
function OnClose()
  ContextPtr:SetHide(true)
end
Controls.CloseButton:RegisterCallback(Mouse.eLClick, OnClose)
--------------------------------------------------------------------
function InputHandler(uiMsg, wParam, lParam)
  if (uiMsg == KeyEvents.KeyDown) then
    if (wParam == Keys.VK_ESCAPE) then
      OnClose()
      return true
    end
  end
end
ContextPtr:SetInputHandler(InputHandler)
--------------------------------------------------------------------
function OnCityViewUpdate()
  if (not ContextPtr:IsHidden()) then
    UpdateData(Game.GetActivePlayer())
  end
end
Events.SerialEventCityInfoDirty.Add(OnCityViewUpdate)
--------------------------------------------------------------------
local wasHidden
function OnEnterCityScreen()
  wasHidden = ContextPtr:IsHidden()
  ContextPtr:SetHide(true);
end
Events.SerialEventEnterCityScreen.Add(OnEnterCityScreen)
--------------------------------------------------------------------
function OnExitCityScreen()
  ContextPtr:SetHide(wasHidden)
end
Events.SerialEventExitCityScreen.Add(OnExitCityScreen)
--------------------------------------------------------------------
function ShowHideHandler(bIsHide, bInitState)
	if (not bInitState and not bIsHide) then
		OnCityViewUpdate()
	end
end
ContextPtr:SetShowHideHandler(ShowHideHandler)
--------------------------------------------------------------------
function OnCityHealthListPopup()
	ContextPtr:SetHide(false)
end
LuaEvents.PLAGUE_CityHealthListPopup.Add( OnCityHealthListPopup )
--------------------------------------------------------------------



--[[function OnAdditionalInformationDropdownGatherEntries(additionalEntries)
	table.insert(additionalEntries, {text=Locale.ConvertTextKey("TXT_KEY_CH_DIPLO_CORNER_HOOK"), call=OnCityHealthListPopup})
end
--------------------------------------------------------------------
LuaEvents.AdditionalInformationDropdownGatherEntries.Add(OnAdditionalInformationDropdownGatherEntries)
LuaEvents.RequestRefreshAdditionalInformationDropdownEntries()]]
--------------------------------------------------------------------
Events.GameplaySetActivePlayer.Add(OnClose)

