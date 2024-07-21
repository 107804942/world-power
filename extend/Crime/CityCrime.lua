include("IconSupport")
include("InstanceManager")
include( "Crime_UI.lua" );
include( "Crime_Events.lua" );
--------------------------------------------------------------------
local g_CrimeManager = InstanceManager:new("CityCrime", "City", Controls.CrimeStack)

local g_SortTable = {}
local g_ActiveSort = "status"
local g_ReverseSort = false

--------------------------------------------------------------------
function OnSort(sort)
  if (sort == g_ActiveSort) then
    g_ReverseSort = not g_ReverseSort
  else
    g_ReverseSort = not (sort == "name" or sort == "status" )
    g_ActiveSort = sort
  end

  Controls.CrimeStack:SortChildren(SortByValue)
end
Controls.SortName:RegisterCallback(Mouse.eLClick, function() OnSort("name") end)
Controls.SortCrime:RegisterCallback(Mouse.eLClick, function() OnSort("Crime") end)
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

  g_CrimeManager:ResetInstances()
  g_SortTable = {}

  for pCity in pPlayer:Cities() do
    local instance = g_CrimeManager:GetInstance()
    local sort = {}
    g_SortTable[tostring(instance.City)] = sort

	
	local CrimeCounter, CrimeThreshold, CrimeTurns = Players[pCity:GetOwner()]:GetCityCrimeCounterDetails(pCity, true, true)


    sort.name = pCity:GetName()
  

	instance.Name:SetText(Locale.ConvertTextKey("TXT_KEY_CITY_CRIME_FOR_UI", CrimeCounter,CrimeThreshold,pCity:GetName()))

    instance.Name:RegisterCallback(Mouse.eLClick, function() OnCity(pCity) end)


	local cityCrime =pCity:GetYieldRate(GameInfoTypes["YIELD_CRIME"])

	local strCrimeToolTip = Players[pCity:GetOwner()]:GetCityCrimeTT(pCity)

    sort.Crime = cityCrime
    instance.Crime:SetText(cityCrime)
	instance.Crime:SetToolTipString(strCrimeToolTip)
	
    --sort.risk = GetCityRiskString(cityHealth)
	sort.risk = GetCityRiskString(pCity)
    instance.Risk:SetText(Locale.ConvertTextKey(sort.risk))
	
  end
  
  Controls.CrimeStack:SortChildren(SortByValue)
  Controls.CrimeStack:CalculateSize()
  Controls.CrimeScrollPanel:CalculateInternalSize()
end
--------------------------------------------------------------------
function GetCityRiskString(pCity)
	local strRisk = "TXT_KEY_CH_RISK_LOW"
	local CrimeCounter, CrimeThreshold, CrimeTurns = Players[pCity:GetOwner()]:GetCityCrimeCounterDetails(pCity, true, true)

	local totalCrime = pCity:GetYieldRate(GameInfoTypes["YIELD_CRIME"])

	--if (not bAbandonCity) or totalHealth-totalDisease >= 0  then  ---无瘟疫风险

		if  totalCrime <= 0  then  ---无瘟疫风险
		strRisk = "TXT_KEY_CH_RISK_NONE"
	end

		if totalCrime > 0 then


		local CrimeTurns=math.max(0,math.ceil((CrimeThreshold-CrimeCounter)/totalCrime))

		if     (CrimeTurns > 20) then
			    strRisk = "TXT_KEY_CH_RISK_LOW"

        elseif (CrimeTurns <= 20) and (CrimeTurns >10 )   then
				strRisk = "TXT_KEY_CH_RISK_AVERAGE"
        elseif (CrimeTurns <= 10) and (CrimeTurns >5 )   then
				strRisk = "TXT_KEY_CH_RISK_HIGH"
		elseif (CrimeTurns <= 5) then
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
function OnCityCrimeListPopup()
	ContextPtr:SetHide(false)
end
LuaEvents.Crime_CityHealthListPopup.Add( OnCityCrimeListPopup )
--------------------------------------------------------------------

--[[function OnAdditionalInformationDropdownGatherEntries(additionalEntries)
	table.insert(additionalEntries, {text=Locale.ConvertTextKey("TXT_KEY_CH_DIPLO_CORNER_HOOK"), call=OnCityHealthListPopup})
end
--------------------------------------------------------------------
LuaEvents.AdditionalInformationDropdownGatherEntries.Add(OnAdditionalInformationDropdownGatherEntries)
LuaEvents.RequestRefreshAdditionalInformationDropdownEntries()]]
--------------------------------------------------------------------
Events.GameplaySetActivePlayer.Add(OnClose)

