-- ============================================================
-- CityCrime.lua (精简版)
-- 世界强权模组 - 城市犯罪列表
-- ============================================================

include("IconSupport")
include("InstanceManager")
include("Crime_UI.lua")
include("Crime_Events.lua")

local g_CrimeManager = InstanceManager:new("CityCrime", "City", Controls.CrimeStack)
local g_SortTable = {}
local g_ActiveSort = "status"
local g_ReverseSort = false

-- ============================================================
-- 排序
-- ============================================================
function SortByValue(a, b)
    local entryA = g_SortTable[tostring(a)]
    local entryB = g_SortTable[tostring(b)]
    if not entryA or not entryB then return tostring(a) < tostring(b) end

    local valueA, valueB = entryA[g_ActiveSort], entryB[g_ActiveSort]
    if valueA == valueB then
        valueA, valueB = entryA.name, entryB.name
    elseif g_ReverseSort then
        valueA, valueB = entryB[g_ActiveSort], entryA[g_ActiveSort]
    end
    if not valueA or not valueB then return tostring(a) < tostring(b) end
    return valueA < valueB
end

function OnSort(sort)
    if sort == g_ActiveSort then
        g_ReverseSort = not g_ReverseSort
    else
        g_ReverseSort = not (sort == "name" or sort == "status")
        g_ActiveSort = sort
    end
    Controls.CrimeStack:SortChildren(SortByValue)
end
Controls.SortName:RegisterCallback(Mouse.eLClick, function() OnSort("name") end)
Controls.SortCrime:RegisterCallback(Mouse.eLClick, function() OnSort("Crime") end)
Controls.SortRisk:RegisterCallback(Mouse.eLClick, function() OnSort("risk") end)

-- ============================================================
-- 点击城市
-- ============================================================
function OnCity(pCity)
    if pCity:IsPuppet() then
        Events.SerialEventGameMessagePopup({
            Type = ButtonPopupTypes.BUTTONPOPUP_ANNEX_CITY,
            Data1 = pCity:GetID(), Data2 = -1, Data3 = -1, Option1 = false, Option2 = false })
    else
        UI.DoSelectCityAtPlot(pCity:Plot())
    end
end

-- ============================================================
-- 风险等级字符串
-- ============================================================
function GetCityRiskString(pCity)
    local totalCrime = pCity:GetYieldRate(GameInfoTypes["YIELD_CRIME"])
    if totalCrime <= 0 then return "TXT_KEY_CH_RISK_NONE" end

    local CrimeCounter, CrimeThreshold = Players[pCity:GetOwner()]:GetCityCrimeCounterDetails(pCity, true, true)
    local CrimeTurns = math.max(0, math.ceil((CrimeThreshold - CrimeCounter) / totalCrime))

    if CrimeTurns > 20 then return "TXT_KEY_CH_RISK_LOW" end
    if CrimeTurns > 10 then return "TXT_KEY_CH_RISK_AVERAGE" end
    if CrimeTurns > 5  then return "TXT_KEY_CH_RISK_HIGH" end
    return "TXT_KEY_CH_RISK_EXTREME"
end

-- ============================================================
-- 刷新数据
-- ============================================================
function UpdateData(iPlayer)
    local pPlayer = Players[iPlayer]
    g_CrimeManager:ResetInstances()
    g_SortTable = {}

    for pCity in pPlayer:Cities() do
        local instance = g_CrimeManager:GetInstance()
        local sort = {}
        g_SortTable[tostring(instance.City)] = sort

        local CrimeCounter, CrimeThreshold = Players[pCity:GetOwner()]:GetCityCrimeCounterDetails(pCity, true, true)

        sort.name = pCity:GetName()
        instance.Name:SetText(Locale.ConvertTextKey(
            "TXT_KEY_CITY_CRIME_FOR_UI", CrimeCounter, CrimeThreshold, pCity:GetName()))
        instance.Name:RegisterCallback(Mouse.eLClick, function() OnCity(pCity) end)

        local cityCrime = pCity:GetYieldRate(GameInfoTypes["YIELD_CRIME"])
        sort.Crime = cityCrime
        instance.Crime:SetText(cityCrime)
        instance.Crime:SetToolTipString(Players[pCity:GetOwner()]:GetCityCrimeTT(pCity))

        sort.risk = GetCityRiskString(pCity)
        instance.Risk:SetText(Locale.ConvertTextKey(sort.risk))
    end

    Controls.CrimeStack:SortChildren(SortByValue)
    Controls.CrimeStack:CalculateSize()
    Controls.CrimeScrollPanel:CalculateInternalSize()
end

-- ============================================================
-- 关闭与输入
-- ============================================================
function OnClose() ContextPtr:SetHide(true) end
Controls.CloseButton:RegisterCallback(Mouse.eLClick, OnClose)

function InputHandler(uiMsg, wParam, lParam)
    if uiMsg == KeyEvents.KeyDown and wParam == Keys.VK_ESCAPE then
        OnClose()
        return true
    end
end
ContextPtr:SetInputHandler(InputHandler)

-- ============================================================
-- 城市视图刷新
-- ============================================================
function OnCityViewUpdate()
    if not ContextPtr:IsHidden() then
        UpdateData(Game.GetActivePlayer())
    end
end
Events.SerialEventCityInfoDirty.Add(OnCityViewUpdate)

-- ============================================================
-- 进入/退出城市界面
-- ============================================================
local wasHidden
function OnEnterCityScreen()
    wasHidden = ContextPtr:IsHidden()
    ContextPtr:SetHide(true)
end
Events.SerialEventEnterCityScreen.Add(OnEnterCityScreen)

function OnExitCityScreen()
    ContextPtr:SetHide(wasHidden)
end
Events.SerialEventExitCityScreen.Add(OnExitCityScreen)

-- ============================================================
-- 显示/隐藏处理
-- ============================================================
function ShowHideHandler(bIsHide, bInitState)
    if not bInitState and not bIsHide then
        OnCityViewUpdate()
    end
end
ContextPtr:SetShowHideHandler(ShowHideHandler)

-- ============================================================
-- 弹窗触发
-- ============================================================
function OnCityCrimeListPopup()
    ContextPtr:SetHide(false)
end
LuaEvents.Crime_CityHealthListPopup.Add(OnCityCrimeListPopup)

-- ============================================================
-- 切换玩家时关闭
-- ============================================================
Events.GameplaySetActivePlayer.Add(OnClose)