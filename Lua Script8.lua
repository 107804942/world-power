--==========================================================
-- EUI tooltip server (optimized)
--==========================================================

print("Loading EUI tooltip server...")

local UserInterfaceSettings = UserInterfaceSettings
local GameInfo = GameInfoCache

local IsCiv5 = InStrategicView ~= nil
local IsCivBE = not IsCiv5
local IsCiv5notVanilla = Game.GetReligionName ~= nil
local IsCiv5BNW = IsCiv5 and Game.GetActiveLeague ~= nil
local IsCiv5BNW_BE = IsCiv5BNW or IsCivBE

if IsCiv5BNW then
    include "GreatPeopleIcons"
end
local GreatPeopleIcons = GreatPeopleIcons

include "StackInstanceManager"
include "IconHookup"
include "ScanGP"
include "ShortUnitTip"
include "GetUnitBuildProgressData"
include "ScratchDeal"
include "CityStateStatusHelper"
include "InfoTooltipInclude"
include "TechHelpInclude"
include "ShowProgress"

-- ========== 局部别名（性能优化） ==========
local print = print
local ipairs = ipairs
local pairs = pairs
local tostring = tostring
local ceil = math.ceil
local floor = math.floor
local min = math.min
local max = math.max
local modf = math.modf
local insert = table.insert
local concat = table.concat
local format = string.format

local PreGame = PreGame
local Game = Game
local GetActivePlayer = Game.GetActivePlayer
local GetActiveTeam = Game.GetActiveTeam
local GetResourceUsageType = Game.GetResourceUsageType
local GameOptionTypes = GameOptionTypes
local GameInfoActions = GameInfoActions
local GameInfoTypes = GameInfoTypes
local GetPlot = Map.GetPlot
local PlotDirection = Map.PlotDirection
local L = Locale.ConvertTextKey
local Matchmaking = Matchmaking
local Network = Network
local OptionsManager = OptionsManager
local Players = Players
local Teams = Teams
local GetHeadSelectedCity = UI.GetHeadSelectedCity
local GetHeadSelectedUnit = UI.GetHeadSelectedUnit
local GetUnitPortraitIcon = UI.GetUnitPortraitIcon
local GetMousePos = UIManager.GetMousePos
local TradeableItems = TradeableItems
local DomainTypes = DomainTypes
local TTManager = TTManager
local Controls = Controls
local Events = Events
local LuaEvents = LuaEvents
local Modding = Modding

-- 常用 GameInfo 表
local Resources = GameInfo.Resources
local Builds = GameInfo.Builds
local Improvements = GameInfo.Improvements
local Routes = GameInfo.Routes
local Units = GameInfo.Units
local Buildings = GameInfo.Buildings
local Projects = GameInfo.Projects
local Processes = GameInfo.Processes
local Technologies = GameInfo.Technologies
local Policies = GameInfo.Policies
local PolicyBranchTypes = GameInfo.PolicyBranchTypes
local UnitPromotions = GameInfo.UnitPromotions
local Features = GameInfo.Features
local Terrains = GameInfo.Terrains
local Eras = GameInfo.Eras
local Victories = GameInfo.Victories
local Civilizations = GameInfo.Civilizations
local Leaders = GameInfo.Leaders
local MinorCivilizations = GameInfo.MinorCivilizations

local NUM_YIELD_TYPES_minus1 = YieldTypes.NUM_YIELD_TYPES - 1
local RESOURCEUSAGE_STRATEGIC = ResourceUsageTypes.RESOURCEUSAGE_STRATEGIC
local RESOURCEUSAGE_LUXURY = ResourceUsageTypes.RESOURCEUSAGE_LUXURY
local RESOURCEUSAGE_BONUS = ResourceUsageTypes.RESOURCEUSAGE_BONUS
local TRADE_ITEM_RESOURCES = TradeableItems.TRADE_ITEM_RESOURCES
local ACTIONSUBTYPE_BUILD = ActionSubTypes.ACTIONSUBTYPE_BUILD
local ACTIONSUBTYPE_PROMOTION = ActionSubTypes.ACTIONSUBTYPE_PROMOTION
local RELIGION_PANTHEON = ReligionTypes and ReligionTypes.RELIGION_PANTHEON
local MOVE_DENOMINATOR = GameDefines.MOVE_DENOMINATOR
local MAX_CIV_PLAYERS_minus1 = GameDefines.MAX_CIV_PLAYERS - 1
local MAX_MAJOR_CIVS = GameDefines.MAX_MAJOR_CIVS
local DOF_EXPIRATION_TIME = GameDefines.DOF_EXPIRATION_TIME or 50
local MINOR_CIV_QUEST_CONNECT_RESOURCE = MinorCivQuestTypes.MINOR_CIV_QUEST_CONNECT_RESOURCE

local ORDER_TRAIN = OrderTypes.ORDER_TRAIN
local ORDER_CONSTRUCT = OrderTypes.ORDER_CONSTRUCT
local ORDER_CREATE = OrderTypes.ORDER_CREATE
local ORDER_MAINTAIN = OrderTypes.ORDER_MAINTAIN

local g_scienceTextColor = IsCiv5 and "[COLOR:33:190:247:255]" or "[COLOR_MENU_BLUE]"
local g_currencyIcon = IsCiv5 and "[ICON_GOLD]" or "[ICON_ENERGY]"
local g_currencyString = IsCiv5 and "GOLD" or "ENERGY"
local g_yieldCurrency = IsCiv5 and YieldTypes.YIELD_GOLD or YieldTypes.YIELD_ENERGY
local g_happinessString = IsCiv5 and "HAPPINESS" or "HEALTH"

-- Tooltip 控件表
local g_UnitTooltipControls = {}
TTManager:GetTypeControlTable("EUI_UnitTooltip", g_UnitTooltipControls)
local g_UnitActionTooltipControls = {}
TTManager:GetTypeControlTable("EUI_UnitAction", g_UnitActionTooltipControls)
local g_CivilizationTooltipControls = {}
TTManager:GetTypeControlTable("EUI_CivilizationTooltip", g_CivilizationTooltipControls)
local g_CityProductionTooltipControls = {}
TTManager:GetTypeControlTable("EUI_CityProductionTooltip", g_CityProductionTooltipControls)
local g_CityGrowthTooltipControls = {}
TTManager:GetTypeControlTable("EUI_CityGrowthTooltip", g_CityGrowthTooltipControls)
local g_TechProgressToolTipControls = {}
TTManager:GetTypeControlTable("EUI_TopPanelProgressTooltip", g_TechProgressToolTipControls)
local g_ItemTooltipControls = {}
TTManager:GetTypeControlTable("EUI_ItemTooltip", g_ItemTooltipControls)

local g_UnitTooltipTimer = Controls.UnitTooltipTimer

-- ========== 栈实例管理器 ==========
local g_PromotionIconIM = StackInstanceManager("PromotionIcon", "Image", g_UnitTooltipControls.IconStack)
local g_PromotionIconIM2 = StackInstanceManager("PromotionIcon2", "Image2", g_ItemTooltipControls.IconStack2)

-- ========== 全局选项与 WP 检测 ==========
local g_isCityStateLeaders, g_isBasicHelp, g_isScienceEnabled, g_isReligionEnabled
local g_isHappinessEnabled, g_isPoliciesEnabled, g_isHealthEnabled, g_isEspionageDisabled
local g_isAlwaysWar, g_isOneCityChallenge
local WpModActive

local function IsUsingWP()
    local WPID = "41450919-c52c-406f-8752-5ea34be32b2d"
    for _, mod in pairs(Modding.GetActivatedMods()) do
        if mod.ID == WPID then return true end
    end
    return false
end
WpModActive = IsUsingWP()

local function UpdateOptions()
    g_isScienceEnabled = not Game.IsOption(GameOptionTypes.GAMEOPTION_NO_SCIENCE)
    g_isPoliciesEnabled = not Game.IsOption(GameOptionTypes.GAMEOPTION_NO_POLICIES)
    g_isHappinessEnabled = IsCiv5 and not Game.IsOption(GameOptionTypes.GAMEOPTION_NO_HAPPINESS)
    g_isReligionEnabled = IsCiv5notVanilla and not Game.IsOption(GameOptionTypes.GAMEOPTION_NO_RELIGION)
    g_isHealthEnabled = WpModActive
    g_isEspionageDisabled = Game.IsOption(GameOptionTypes.GAMEOPTION_NO_ESPIONAGE)
    g_isAlwaysWar = Game.IsOption(GameOptionTypes.GAMEOPTION_ALWAYS_WAR)
    g_isOneCityChallenge = Game.IsOption(GameOptionTypes.GAMEOPTION_ONE_CITY_CHALLENGE)
    g_isBasicHelp = IsCivBE or not OptionsManager.IsNoBasicHelp()
    g_UnitTooltipTimer:SetToBeginning()
    g_UnitTooltipTimer:SetPauseTime(OptionsManager.GetTooltip2Seconds() / 100)
    g_isCityStateLeaders = UserInterfaceSettings.CityStateLeaders ~= 0
end
Events.GameOptionsChanged.Add(UpdateOptions)
UpdateOptions()

-- ========== 工具函数 ==========
local function cleanupTable(t)
    t[-1] = nil
    return t
end

local g_yieldString = cleanupTable{
    [YieldTypes.YIELD_FOOD or -1] = "TXT_KEY_BUILD_FOOD_STRING",
    [YieldTypes.YIELD_PRODUCTION or -1] = "TXT_KEY_BUILD_PRODUCTION_STRING",
    [YieldTypes.YIELD_GOLD or -1] = "TXT_KEY_BUILD_GOLD_STRING",
    [YieldTypes.YIELD_SCIENCE or -1] = "TXT_KEY_BUILD_SCIENCE_STRING",
    [YieldTypes.YIELD_CULTURE or -1] = "TXT_KEY_BUILD_CULTURE_STRING",
    [YieldTypes.YIELD_FAITH or -1] = "TXT_KEY_BUILD_FAITH_STRING",
}

local g_infoSource = cleanupTable{
    [ActionSubTypes.ACTIONSUBTYPE_PROMOTION or -1] = UnitPromotions,
    [ActionSubTypes.ACTIONSUBTYPE_INTERFACEMODE or -1] = GameInfo.InterfaceModes,
    [ActionSubTypes.ACTIONSUBTYPE_MISSION or -1] = GameInfo.Missions,
    [ActionSubTypes.ACTIONSUBTYPE_COMMAND or -1] = GameInfo.Commands,
    [ActionSubTypes.ACTIONSUBTYPE_AUTOMATE or -1] = GameInfo.Automates,
    [ActionSubTypes.ACTIONSUBTYPE_BUILD or -1] = Builds,
    [ActionSubTypes.ACTIONSUBTYPE_CONTROL or -1] = GameInfo.Controls,
}

local g_cityFocusTooltips = cleanupTable{
    [CityAIFocusTypes.NO_CITY_AI_FOCUS_TYPE or -1] = L"TXT_KEY_CITYVIEW_FOCUS_BALANCED_TEXT",
    [CityAIFocusTypes.CITY_AI_FOCUS_TYPE_FOOD or -1] = L"TXT_KEY_CITYVIEW_FOCUS_FOOD_TEXT",
    [CityAIFocusTypes.CITY_AI_FOCUS_TYPE_PRODUCTION or -1] = L"TXT_KEY_CITYVIEW_FOCUS_PROD_TEXT",
    [CityAIFocusTypes.CITY_AI_FOCUS_TYPE_GOLD or -1] = L"TXT_KEY_CITYVIEW_FOCUS_GOLD_TEXT",
    [CityAIFocusTypes.CITY_AI_FOCUS_TYPE_SCIENCE or -1] = L"TXT_KEY_CITYVIEW_FOCUS_RESEARCH_TEXT",
    [CityAIFocusTypes.CITY_AI_FOCUS_TYPE_CULTURE or -1] = L"TXT_KEY_CITYVIEW_FOCUS_CULTURE_TEXT",
    [CityAIFocusTypes.CITY_AI_FOCUS_TYPE_GREAT_PEOPLE or -1] = L"TXT_KEY_CITYVIEW_FOCUS_GREAT_PERSON_TEXT",
    [CityAIFocusTypes.CITY_AI_FOCUS_TYPE_FAITH or -1] = L"TXT_KEY_CITYVIEW_FOCUS_FAITH_TEXT",
}

local g_activityMissions = cleanupTable{
    [ActivityTypes.ACTIVITY_HOLD or -1] = false,
    [ActivityTypes.ACTIVITY_HEAL or -1] = GameInfo.Missions.MISSION_HEAL,
    [ActivityTypes.ACTIVITY_SENTRY or -1] = GameInfo.Missions.MISSION_ALERT,
    [ActivityTypes.ACTIVITY_INTERCEPT or -1] = GameInfo.Missions.MISSION_AIRPATROL,
}

-- ========== 颜色辅助 ==========
local function Colorize(x)
    if x > 0 then return "[COLOR_POSITIVE_TEXT]"..x.."[ENDCOLOR]"
    elseif x < 0 then return "[COLOR_WARNING_TEXT]"..x.."[ENDCOLOR]"
    else return "0" end
end
local function ColorizeSigned(x)
    if x > 0 then return "[COLOR_POSITIVE_TEXT]+"..x.."[ENDCOLOR]"
    elseif x < 0 then return "[COLOR_WARNING_TEXT]"..x.."[ENDCOLOR]"
    else return "0" end
end
local function ColorizeAbs(x)
    if x > 0 then return "[COLOR_POSITIVE_TEXT]"..x.."[ENDCOLOR]"
    elseif x < 0 then return "[COLOR_WARNING_TEXT]"..(-x).."[ENDCOLOR]"
    else return "0" end
end

local function append(t, text) t[#t] = t[#t] .. text end

local function insertLocalizedIfNonZero(t, textKey, val)
    if val and val ~= 0 then insert(t, L(textKey, val)) end
end

local function insertLocalizedBulletIfNonZero(t, a, b, c)
    if type(b) == "number" and b ~= 0 then
        insert(t, "[ICON_BULLET]"..L(a, b, c))
    elseif c and c ~= 0 then
        insert(t, a..L(b, c))
    end
end

local function GetItemPortraitIcon(itemTable, itemID)
    local item = itemTable and itemTable[itemID]
    if item then
        return item.PortraitIndex or item.IconIndex, item.IconAtlas
    end
end

local function UnitColor(s) return "[COLOR_UNIT_TEXT]"..s.."[ENDCOLOR]" end
local function BuildingColor(s) return "[COLOR_YIELD_FOOD]"..s.."[ENDCOLOR]" end
local function PolicyColor(s) return "[COLOR_MAGENTA]"..s.."[ENDCOLOR]" end
local function TechColor(s) return "[COLOR_CYAN]"..s.."[ENDCOLOR]" end
local function ReligionColor(s) return "[COLOR_WHITE]"..s.."[ENDCOLOR]" end

local function TooltipSelect(tooltipTable, control, ...)
    local func = tooltipTable[control:GetID()]
    if func then return func(...) end
end

-- ========== 通用工具提示显示（合并版） ==========
local function ShowTextToolTipAndPictureEx(controls, tip, index, atlas, promotionList)
    controls.Text2:SetText(tip or "")
    -- 重置并绘制晋升图标
    controls.IconStack2:ResetInstances()
    if promotionList and #promotionList > 0 then
        for _, promo in ipairs(promotionList) do
            local inst = controls.IconStack2:GetInstance()
            IconHookup(promo.PortraitIndex, 32, promo.IconAtlas, inst.Image2)
        end
        local names = {}
        for _, promo in ipairs(promotionList) do names[#names+1] = promo._Name end
        controls.PromotionText2:SetText(table.concat(names, "[NEWLINE]"))
        controls.PromotionText2:SetHide(false)
    else
        controls.PromotionText2:SetHide(true)
    end
    controls.PortraitFrame2:SetHide(not (atlas and IconHookup(index, 256, atlas, controls.Portrait2)))
    controls.PortraitFrame2:SetAnchor(GetMousePos() > 300 and "L,C" or "R,C")
    controls.IconStack2:SetWrapWidth(32)
    controls.IconStack2:CalculateSize()
    controls.Box:ReprocessAnchoring()
    controls.Box:DoAutoSize()
end

local function ShowTextToolTip(...)
    return ShowTextToolTipAndPictureEx(g_ItemTooltipControls, concat({...}, "[NEWLINE]----------------[NEWLINE]"))
end

-- 原 ShowTextToolTipAndPicture 简单封装（无晋升）
local function ShowSimpleTextToolTip(tip, index, atlas)
    ShowTextToolTipAndPictureEx(g_ItemTooltipControls, tip, index, atlas, nil)
end

-- 兼容旧调用
local ShowTextToolTipAndPicture = ShowSimpleTextToolTip
local ShowTextToolTipAndPicture2 = function(tip, orderID, itemID, index, atlas)
    local unit = Units[itemID]
    local promotionList = {}
    if unit then
        for row in GameInfo.Unit_FreePromotions({UnitType = unit.Type}) do
            local promo = UnitPromotions[row.PromotionType]
            if promo and promo.ShowInUnitPanel ~= 0 and promo.ShowInTooltip ~= 0 then
                promotionList[#promotionList+1] = promo
            end
        end
    end
    ShowTextToolTipAndPictureEx(g_ItemTooltipControls, tip, index, atlas, promotionList)
end

-- ========== 资源工具提示（精简） ==========
local function ShowResourceToolTip(resourceID, tips)
    local resource = Resources[resourceID]
    if not resource then return end
    local activePlayer = Players[GetActivePlayer()]
    local numAvail = activePlayer:GetNumResourceAvailable(resourceID, true)
    local numUsed = activePlayer:GetNumResourceUsed(resourceID)
    local numTotal = activePlayer:GetNumResourceTotal(resourceID, false)
    tips[#tips+1] = ColorizeAbs(numAvail) .. resource.IconString .. " " .. Locale.ToUpper(resource._Name)
    tips[#tips+1] = "----------------"
    tips[#tips+1] = L("TXT_KEY_EO_LOCAL_RESOURCES") .. ": " .. ColorizeAbs(numTotal)
    if numUsed ~= 0 then
        tips[#tips+1] = Colorize(-numUsed) .. " " .. L"TXT_KEY_PEDIA_USED_RESRC_LABEL"
    end
    -- 奢侈品快乐
    local resourceHappiness = resource.Happiness or 0
    if resourceHappiness > 0 then
        tips[#tips+1] = resourceHappiness .. "[ICON_HAPPINESS_1]"
    end
    ShowTextToolTipAndPictureEx(g_ItemTooltipControls, concat(tips, "[NEWLINE]"), resource.PortraitIndex, resource.IconAtlas)
end
LuaEvents.ResourceToolTip.Add(function(control) ShowResourceToolTip(control:GetVoid1(), {}) end)

-- ========== 文明工具提示 ==========
local function ShowCivilizationToolTip(toolTip, playerID)
    local controls = g_CivilizationTooltipControls
    controls.Text:SetText(toolTip)
    local player = Players[playerID]
    local isMinor, isMajor = false, false
    if player then
        if player:IsMinorCiv() then
            local minInfo = MinorCivilizations[player:GetMinorCivType()]
            if minInfo and g_isCityStateLeaders and Locale.HasTextKey("TXT_KEY_CSL_ICON_"..minInfo.Type) then
                isMinor = controls.Leader:SetTexture(L("TXT_KEY_CSL_ICON_"..minInfo.Type))
            end
        else
            local leader = Leaders[player:GetLeaderType()]
            isMajor = leader and IconHookup(leader.PortraitIndex, controls.Portrait:GetSizeY(), leader.IconAtlas, controls.Portrait)
            CivIconHookup(playerID, controls.CivIconBG:GetSizeY(), controls.CivIcon, controls.CivIconBG, controls.CivIconShadow, false, true)
        end
    end
    controls.MajorCiv:SetHide(not isMajor)
    controls.MinorCiv:SetHide(not isMinor)
    controls.Box:DoAutoSize()
end

local function TooltipWithRemainingTurns(toolTip, remainingTurns)
    toolTip = L(toolTip)
    if remainingTurns and remainingTurns > 0 then
        toolTip = toolTip .. " ("..L("TXT_KEY_STR_TURNS", remainingTurns)..")"
    end
    return toolTip
end

local function TooltipAndGetRemainingTurns(toolTip, tradeableItemID, fromPlayerID, toPlayerID)
    local activePlayerID = GetActivePlayer()
    PushScratchDeal()
    for i = 0, UI.GetNumCurrentDeals(activePlayerID) - 1 do
        UI.LoadCurrentDeal(activePlayerID, i)
        if not toPlayerID or toPlayerID == activePlayerID or toPlayerID == ScratchDeal:GetOtherPlayer(activePlayerID) then
            ScratchDeal:ResetIterator()
            local itemID
            repeat
                local item = {ScratchDeal:GetNextItem()}
                itemID = item[1]
                if itemID == tradeableItemID and item[#item] == fromPlayerID then
                    PopScratchDeal()
                    return TooltipWithRemainingTurns(toolTip, item[3] - Game.GetGameTurn() + 1)
                end
            until not itemID
        end
    end
    PopScratchDeal()
    return L(toolTip)
end

local function Pledge(playerID)
    local player = Players[playerID]
    local toolTip = L"TXT_KEY_POP_CSTATE_PLEDGE_TO_PROTECT"
    if player and player.CanMajorWithdrawProtection then
        toolTip = L("TXT_KEY_NOTIFICATION_SUMMARY_QUEST_COMPLETE_PLEDGE_TO_PROTECT", player:GetCivilizationShortDescriptionKey())
        if player:CanMajorWithdrawProtection(GetActivePlayer()) then
            toolTip = toolTip.."[NEWLINE][NEWLINE]"..L"TXT_KEY_POP_CSTATE_REVOKE_PROTECTION_TT"
        else
            toolTip = toolTip..L("TXT_KEY_POP_CSTATE_REVOKE_PROTECTION_DISABLED_COMMITTED_TT",
                player:GetTurnLastPledgedProtectionByMajor(GetActivePlayer()) + 10 - Game.GetGameTurn())
        end
    end
    return toolTip
end

local CivilizationToolTips = {
    Button = function(playerID)
        local player = Players[playerID]
        if player:IsMinorCiv() then
            return GetCityStateStatusToolTip(GetActivePlayer(), playerID, true)
        else
            return GetMoodInfo(playerID, true)
        end
    end,
    Quests = function(playerID) return GetActiveQuestToolTip(GetActivePlayer(), playerID) end,
    Ally = function(playerID) return GetAllyToolTip(GetActivePlayer(), playerID) end,
    Pledge1 = Pledge,
    Pledge2 = Pledge,
    Spy = function(playerID)
        local player = Players[playerID]
        local activePlayer = Players[GetActivePlayer()]
        if player and activePlayer then
            for _, s in ipairs(activePlayer:GetEspionageSpies()) do
                local plot = GetPlot(s.CityX, s.CityY)
                local city = plot and plot:GetPlotCity()
                if city and city:GetOwner() == playerID then
                    return L("TXT_KEY_CITY_SPY_CITY_STATE_TT", s.Rank, s.Name, player:GetCivilizationShortDescriptionKey(), s.Rank, s.Name)
                end
            end
        end
    end,
    DeclarationOfFriendship = function(playerID)
        local activePlayer = Players[GetActivePlayer()]
        if activePlayer and activePlayer.GetDoFCounter then
            return TooltipWithRemainingTurns("TXT_KEY_DIPLOMACY_FRIENDSHIP_ADV_QUEST", DOF_EXPIRATION_TIME - activePlayer:GetDoFCounter(playerID))
        else
            return L("TXT_KEY_DIPLOMACY_FRIENDSHIP_ADV_QUEST")
        end
    end,
    ResearchAgreement = function(playerID)
        return TooltipAndGetRemainingTurns("TXT_KEY_DO_RESEARCH_AGREEMENT", TradeableItems.TRADE_ITEM_RESEARCH_AGREEMENT, playerID)
    end,
    DefenseAgreement = function(playerID)
        return TooltipAndGetRemainingTurns("TXT_KEY_DO_PACT", TradeableItems.TRADE_ITEM_DEFENSIVE_PACT, playerID)
    end,
    TheirBordersClosed = function() return L"TXT_KEY_EUI_CLOSED_BORDERS_THEIR" end,
    OurBordersClosed = function() return L"TXT_KEY_EUI_CLOSED_BORDERS_YOUR" end,
    TheirBordersOpen = function(playerID)
        local key = "TXT_KEY_EUI_OPEN_BORDERS_THEIR"
        if not Locale.HasTextKey(key) then key = "TXT_KEY_DO_THEY_PROVIDE" end
        return TooltipAndGetRemainingTurns(key, TradeableItems.TRADE_ITEM_OPEN_BORDERS, playerID)
    end,
    OurBordersOpen = function(playerID)
        local key = "TXT_KEY_EUI_OPEN_BORDERS_YOUR"
        if not Locale.HasTextKey(key) then key = "TXT_KEY_DO_WE_PROVIDE" end
        return TooltipAndGetRemainingTurns(key, TradeableItems.TRADE_ITEM_OPEN_BORDERS, GetActivePlayer(), playerID)
    end,
    ActivePlayer = function() return L"TXT_KEY_YOU" end,
    War = function(playerID)
        local player = Players[playerID]
        local activeTeam = Teams[GetActiveTeam()]
        if player and activeTeam then
            local tips = {L("TXT_KEY_AT_WAR_WITH", player:GetCivilizationShortDescriptionKey())}
            local teamID = player:GetTeam()
            local locked = activeTeam:GetNumTurnsLockedIntoWar(teamID)
            if locked > 0 then
                tips[#tips+1] = L("TXT_KEY_DIPLO_NEGOTIATE_PEACE_BLOCKED_TT", locked)
            elseif not activeTeam:CanChangeWarPeace(teamID) then
                tips[#tips+1] = L"TXT_KEY_PEACE_BLOCKED"
            end
            return concat(tips, "[NEWLINE]")
        end
    end,
    Score = function(playerID)
        local player = Players[playerID]
        if not player then return end
        local tips = {L("TXT_KEY_POP_SCORE").." "..player:GetScore(), "----------------",
            L("TXT_KEY_DIPLO_MY_SCORE_CITIES", player:GetScoreFromCities()),
            L("TXT_KEY_DIPLO_MY_SCORE_POPULATION", player:GetScoreFromPopulation()),
            L("TXT_KEY_DIPLO_MY_SCORE_LAND", player:GetScoreFromLand()),
            L("TXT_KEY_DIPLO_MY_SCORE_WONDERS", player:GetScoreFromWonders())}
        if g_isScienceEnabled then
            tips[#tips+1] = L("TXT_KEY_DIPLO_MY_SCORE_TECH", player:GetScoreFromTechs())
            tips[#tips+1] = L("TXT_KEY_DIPLO_MY_SCORE_FUTURE_TECH", player:GetScoreFromFutureTech())
        end
        if g_isReligionEnabled then
            tips[#tips+1] = L("TXT_KEY_DIPLO_MY_SCORE_RELIGION", player:GetScoreFromReligion())
        end
        if g_isPoliciesEnabled and player.GetScoreFromPolicies then
            tips[#tips+1] = L("TXT_KEY_DIPLO_MY_SCORE_POLICIES", player:GetScoreFromPolicies())
        end
        if player.GetScoreFromGreatWorks then
            tips[#tips+1] = L("TXT_KEY_DIPLO_MY_SCORE_GREAT_WORKS", player:GetScoreFromGreatWorks())
        end
        if PreGame.GetLoadWBScenario() then
            for i = 1,4 do
                local key = "TXT_KEY_DIPLO_MY_SCORE_SCENARIO"..i
                if Locale.HasTextKey(key) then
                    tips[#tips+1] = L(key, player["GetScoreFromScenario"..i](player))
                end
            end
        end
        return concat(tips, "[NEWLINE]")
    end,
    Gold = function(playerID)
        local player = Players[playerID]
        if not player then return end
        local team = Teams[player:GetTeam()]
        if team and team:IsAtWar(GetActiveTeam()) then
            return L"TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_WAR"
        elseif not player.IsDoF or player:IsDoF(GetActivePlayer()) then
            return L"TXT_KEY_REPLAY_DATA_TOTALGOLD"
        else
            return L"TXT_KEY_REPLAY_DATA_GOLDPERTURN"
        end
    end,
    TheirTradeItems = function(playerID)
        local player = Players[playerID]
        if not player then return end
        local tips = {L("TXT_KEY_DIPLO_ITEMS_LABEL", player:GetCivilizationAdjective())}
        local activePlayerID = GetActivePlayer()
        for usage = RESOURCEUSAGE_LUXURY, RESOURCEUSAGE_STRATEGIC, RESOURCEUSAGE_STRATEGIC - RESOURCEUSAGE_LUXURY do
            for resource in Resources({ResourceUsage = usage}) do
                if ScratchDeal:IsPossibleToTradeItem(playerID, activePlayerID, TRADE_ITEM_RESOURCES, resource.ID, 1) then
                    local a,b = player:GetNumResourceAvailable(resource.ID, true), player:GetNumResourceAvailable(resource.ID)
                    tips[#tips+1] = format(a==b and "%i%s%s" or "%i%s%s (%i)", a, resource.IconString, resource._Name, b)
                end
            end
        end
        return concat(tips, "[NEWLINE]")
    end,
    OurTradeItems = function(playerID)
        local player = Players[playerID]
        if not player then return end
        local activePlayerID = GetActivePlayer()
        local activePlayer = Players[activePlayerID]
        local tips = {L"TXT_KEY_DIPLO_YOUR_ITEMS_LABEL"}
        for usage = RESOURCEUSAGE_LUXURY, RESOURCEUSAGE_STRATEGIC, RESOURCEUSAGE_STRATEGIC - RESOURCEUSAGE_LUXURY do
            for resource in Resources({ResourceUsage = usage}) do
                if ScratchDeal:IsPossibleToTradeItem(activePlayerID, playerID, TRADE_ITEM_RESOURCES, resource.ID, 1)
                    and player:GetNumResourceAvailable(resource.ID, true) <= player:GetNumCities() then
                    local a,b = activePlayer:GetNumResourceAvailable(resource.ID, true), activePlayer:GetNumResourceAvailable(resource.ID)
                    tips[#tips+1] = format(a==b and "%i%s%s" or "%i%s%s (%i)", a, resource.IconString, resource._Name, b)
                end
            end
        end
        return concat(tips, "[NEWLINE]"), activePlayerID
    end,
    Host = function() return L"TXT_KEY_HOST" end,
    Connection = function(playerID)
        local player = Players[playerID]
        if not player then return end
        local toolTip
        if Network.IsPlayerHotJoining(playerID) then
            toolTip = L"TXT_KEY_MP_PLAYER_CONNECTING"
        elseif player:IsConnected() then
            toolTip = L"TXT_KEY_MP_PLAYER_CONNECTED"
        else
            toolTip = L"TXT_KEY_MP_PLAYER_NOTCONNECTED"
        end
        if Matchmaking.GetHostID() == playerID then
            toolTip = L"TXT_KEY_HOST"..", "..toolTip
        end
        local playerInfo
        if playerID == GetActivePlayer() then
            playerInfo = Network.GetLocalTurnSliceInfo()
        else
            playerInfo = Network.GetPlayerTurnSliceInfo(playerID)
        end
        local ping = ""
        if PreGame.IsInternetGame() then
            local p = Network.GetPingTime(playerID)
            if p >= 0 then
                ping = p==0 and L"TXT_KEY_STAGING_ROOM_UNDER_1_MS" or (p<1000 and p..L"TXT_KEY_STAGING_ROOM_TIME_MS" or ("%.2f"):format(p/1000)..L"TXT_KEY_STAGING_ROOM_TIME_S")
                ping = L"TXT_KEY_ACTION_PING".." "..ping.." "
            end
        end
        return toolTip.."[NEWLINE][NEWLINE]"..ping.."Network turn slice: "..playerInfo.Shortest.." ("..playerInfo.Average..") "..playerInfo.Longest
    end,
    Diplomacy = function(playerID)
        if UI.ProposedDealExists(playerID, GetActivePlayer()) then
            return L"TXT_KEY_DIPLO_REQUEST_INCOMING"
        elseif UI.ProposedDealExists(GetActivePlayer(), playerID) then
            return L"TXT_KEY_DIPLO_REQUEST_OUTGOING"
        end
    end,
}
LuaEvents.CivilizationToolTips.Add(function(control, playerID)
    local toolTip, id = TooltipSelect(CivilizationToolTips, control, playerID)
    ShowCivilizationToolTip(toolTip, id or playerID)
end)

-- ========== 单位行动工具提示 ==========
LuaEvents.UnitActionToolTip.Add(function(button)
    local activePlayer = Players[GetActivePlayer()]
    local activeTeam = Teams[GetActiveTeam()]
    local unit = GetHeadSelectedUnit()
    local actionID = button:GetVoid1()
    local action = GameInfoActions[actionID]
    if not (unit and activePlayer and activeTeam and action) then
        g_UnitActionTooltipControls.UnitActionMouseover:SetHide(true)
        return
    end
    local controls = g_UnitActionTooltipControls
    local activeTechs = activeTeam:GetTeamTechs()
    local actionType = action.Type
    local unitPlot = unit:GetPlot()
    local x,y = unit:GetX(), unit:GetY()

    -- 图标
    if actionType == "MISSION_FOUND" then
        controls.UnitActionIcon:SetTextureOffsetVal(0,0)
        controls.UnitActionIcon:SetTexture("BuildCity64.dds")
    else
        local info = g_infoSource[action.SubType]
        info = info and info[actionType]
        if info then
            IconHookup(info.IconIndex or info.PortraitIndex, 64, info.IconAtlas, controls.UnitActionIcon)
        end
    end

    local gameCanHandle = Game.CanHandleAction(actionID, unitPlot, false)
    local isBuild = action.SubType == ACTIONSUBTYPE_BUILD
    local buildID = action.MissionData
    local build = Builds[buildID]
    local improvement = build and Improvements[build.ImprovementType]
    local improvementID = improvement and improvement.ID
    local featureID = unitPlot:GetFeatureType()
    local feature = Features[featureID]
    local route = build and Routes[build.RouteType]

    local toolTip = {}
    local disabledTip = {}
    local strBuildTurns = ""

    if actionType == "COMMAND_UPGRADE" then
        local upgradeUnitTypeID = unit:GetUpgradeUnitType()
        local upgradePrice = unit:UpgradePrice(upgradeUnitTypeID)
        local upgradeInfo = Units[upgradeUnitTypeID]
        if upgradeInfo then
            toolTip[#toolTip+1] = L("TXT_KEY_UPGRADE_HELP", UnitColor(upgradeInfo._Name), upgradePrice)
            toolTip[#toolTip+1] = "----------------"
            toolTip[#toolTip+1] = GetHelpTextForUnit(upgradeUnitTypeID, true)
        end
        if not gameCanHandle then
            toolTip[#toolTip+1] = "----------------"
            if unitPlot:GetOwner() ~= unit:GetOwner() then
                disabledTip[#disabledTip+1] = L"TXT_KEY_UPGRADE_HELP_DISABLED_TERRITORY"
            end
            if unit:GetDomainType() == DomainTypes.DOMAIN_AIR and not unitPlot:IsCity() then
                disabledTip[#disabledTip+1] = L"TXT_KEY_UPGRADE_HELP_DISABLED_CITY"
            end
            if upgradePrice > activePlayer:GetGold() then
                disabledTip[#disabledTip+1] = L"TXT_KEY_UPGRADE_HELP_DISABLED_GOLD"
            end
            local resNeeded = {}
            for resource in Resources() do
                local need = unit:GetNumResourceNeededToUpgrade(resource.ID)
                if need > 0 and need > activePlayer:GetNumResourceAvailable(resource.ID) then
                    resNeeded[#resNeeded+1] = need.." "..resource.IconString.." "..resource._Name
                end
            end
            if #resNeeded > 0 then
                disabledTip[#disabledTip+1] = L("TXT_KEY_UPGRADE_HELP_DISABLED_RESOURCES", concat(resNeeded, ", "))
            end
            if unitPlot:GetNumFriendlyUnitsOfType(unit) > 1 then
                disabledTip[#disabledTip+1] = L"TXT_KEY_UPGRADE_HELP_DISABLED_STACKING"
            end
        end
    elseif actionType == "MISSION_ALERT" and not unit:IsEverFortifyable() then
        toolTip[#toolTip+1] = L"TXT_KEY_MISSION_ALERT_NO_FORTIFY_HELP"
    elseif actionType == "MISSION_GOLDEN_AGE" then
        toolTip[#toolTip+1] = L("TXT_KEY_MISSION_START_GOLDENAGE_HELP", unit:GetGoldenAgeTurns())
    elseif actionType == "MISSION_SPREAD_RELIGION" then
        local eMajority = unit:GetMajorityReligionAfterSpread()
        toolTip[#toolTip+1] = L"TXT_KEY_MISSION_SPREAD_RELIGION_HELP"
        toolTip[#toolTip+1] = "----------------"
        toolTip[#toolTip+1] = L("TXT_KEY_MISSION_SPREAD_RELIGION_RESULT", Game.GetReligionName(unit:GetReligion()), unit:GetNumFollowersAfterSpread())
            .." "..(eMajority < RELIGION_PANTHEON and L"TXT_KEY_MISSION_MAJORITY_RELIGION_NONE" or L("TXT_KEY_MISSION_MAJORITY_RELIGION", Game.GetReligionName(eMajority)))
    elseif actionType == "MISSION_CREATE_GREAT_WORK" then
        toolTip[#toolTip+1] = L"TXT_KEY_MISSION_CREATE_GREAT_WORK_HELP"
        if gameCanHandle then
            local slotType = unit:GetGreatWorkSlotType()
            local building = Buildings[activePlayer:GetBuildingOfClosestGreatWorkSlot(x,y,slotType)]
            local city = activePlayer:GetCityOfClosestGreatWorkSlot(x,y,slotType)
            toolTip[#toolTip+1] = "----------------"
            toolTip[#toolTip+1] = L("TXT_KEY_MISSION_CREATE_GREAT_WORK_RESULT", building and building.Description or "???", city and city:GetNameKey() or "???")
        end
    elseif actionType == "INTERFACEMODE_PARADROP" then
        toolTip[#toolTip+1] = L("TXT_KEY_INTERFACEMODE_PARADROP_HELP_WITH_RANGE", unit:GetDropRange())
    elseif actionType == "MISSION_SELL_EXOTIC_GOODS" then
        toolTip[#toolTip+1] = L"TXT_KEY_MISSION_SELL_EXOTIC_GOODS_HELP"
        if gameCanHandle then
            toolTip[#toolTip+1] = "----------------"
            toolTip[#toolTip+1] = "+"..unit:GetExoticGoodsGoldAmount().."[ICON_GOLD]"
            toolTip[#toolTip+1] = L("TXT_KEY_EXPERIENCE_POPUP", unit:GetExoticGoodsXPAmount())
        end
    elseif actionType == "MISSION_DISCOVER" then
        toolTip[#toolTip+1] = L"TXT_KEY_MISSION_DISCOVER_TECH_HELP"
        if gameCanHandle then
            toolTip[#toolTip+1] = "----------------"
            toolTip[#toolTip+1] = "+"..unit:GetDiscoverAmount().."[ICON_RESEARCH]"
        end
    elseif actionType == "MISSION_HURRY" then
        toolTip[#toolTip+1] = L"TXT_KEY_MISSION_HURRY_PRODUCTION_HELP"
        if gameCanHandle then
            toolTip[#toolTip+1] = "----------------"
            toolTip[#toolTip+1] = "+"..unit:GetHurryProduction(unitPlot).."[ICON_PRODUCTION]"
        end
    elseif actionType == "MISSION_TRADE" then
        toolTip[#toolTip+1] = L"TXT_KEY_MISSION_CONDUCT_TRADE_MISSION_HELP"
        if gameCanHandle then
            toolTip[#toolTip+1] = "----------------"
            toolTip[#toolTip+1] = "+"..unit:GetTradeInfluence(unitPlot).."[ICON_INFLUENCE]"
            toolTip[#toolTip+1] = "+"..unit:GetTradeGold(unitPlot).."[ICON_GOLD]"
        end
    elseif actionType == "MISSION_GIVE_POLICIES" then
        toolTip[#toolTip+1] = L"TXT_KEY_MISSION_GIVE_POLICIES_HELP"
        if gameCanHandle then
            toolTip[#toolTip+1] = "----------------"
            toolTip[#toolTip+1] = "+"..unit:GetGivePoliciesCulture().."[ICON_CULTURE]"
        end
    elseif actionType == "MISSION_ONE_SHOT_TOURISM" then
        toolTip[#toolTip+1] = L"TXT_KEY_MISSION_ONE_SHOT_TOURISM_HELP"
        if gameCanHandle then
            toolTip[#toolTip+1] = "----------------"
            toolTip[#toolTip+1] = "+"..unit:GetBlastTourism().."[ICON_TOURISM]"
        end
    elseif actionType == "COMMAND_DELETE" then
        toolTip[#toolTip+1] = L("TXT_KEY_SCRAP_HELP", unit:GetScrapGold())
    elseif action.Help and action.Help ~= "" then
        toolTip[#toolTip+1] = L(action.Help)
    end

    if not gameCanHandle then
        if isBuild then
            if improvement or route then
                local strName = (improvement and improvement.Description) or (route and route.Description) or ""
                if Game.IsPlotExceedMaxBuild(unit:GetOwner(), unitPlot:GetPlotIndex()) then
                    disabledTip[#disabledTip+1] = L("TXT_KEY_BUILD_BLOCKED_MAX_BUILD_NUM")
                end
                local prereqTech = Technologies[build.PrereqTech]
                if prereqTech and not activeTechs:HasTech(prereqTech.ID) then
                    disabledTip[#disabledTip+1] = L("TXT_KEY_BUILD_BLOCKED_PREREQ_TECH", prereqTech.Description, strName)
                end
                if improvement then
                    if improvement.InAdjacentFriendly and unitPlot:GetTeam() ~= unit:GetTeam() and not unitPlot:IsAdjacentTeam(unit:GetTeam(), true) then
                        disabledTip[#disabledTip+1] = L("TXT_KEY_BUILD_BLOCKED_NOT_IN_ADJACENT_TERRITORY", strName)
                    end
                    if improvement.OnlyCityStateTerritory then
                        local owner = Players[unitPlot:GetOwner()]
                        if not (owner and owner:IsMinorCiv()) then
                            disabledTip[#disabledTip+1] = L("TXT_KEY_BUILD_BLOCKED_NOT_IN_CITY_STATE_TERRITORY", strName)
                        end
                    end
                    if improvement.OutsideBorders == false and unitPlot:GetTeam() ~= unit:GetTeam() then
                        disabledTip[#disabledTip+1] = L("TXT_KEY_BUILD_BLOCKED_OUTSIDE_TERRITORY", strName)
                    end
                    if improvement.AdjacentLuxury then
                        local found = false
                        for d = 0,5 do
                            local adj = PlotDirection(x,y,d)
                            if adj then
                                local resType = adj:GetResourceType()
                                if resType ~= -1 and GetResourceUsageType(resType) == RESOURCEUSAGE_LUXURY then
                                    found = true
                                    break
                                end
                            end
                        end
                        if not found then
                            disabledTip[#disabledTip+1] = L("TXT_KEY_BUILD_BLOCKED_NO_ADJACENT_LUXURY", strName)
                        end
                    end
                    if improvement.NoTwoAdjacent then
                        for d = 0,5 do
                            local adj = PlotDirection(x,y,d)
                            if adj and (adj:GetImprovementType() == improvementID or adj:GetBuildProgress(buildID) > 0) then
                                disabledTip[#disabledTip+1] = L("TXT_KEY_BUILD_BLOCKED_CANNOT_BE_ADJACENT", strName)
                                break
                            end
                        end
                    end
                end
            end
            if activePlayer:IsBuildBlockedByFeature(buildID, featureID) then
                for row in GameInfo.BuildFeatures({BuildType = build.Type, FeatureType = feature.Type}) do
                    local tech = Technologies[row.PrereqTech]
                    disabledTip[#disabledTip+1] = L("TXT_KEY_BUILD_BLOCKED_BY_FEATURE", tech.Description, feature.Description)
                end
            end
        else
            if actionType == "MISSION_FOUND" and activePlayer:IsEmpireVeryUnhappy() then
                disabledTip[#disabledTip+1] = L"TXT_KEY_MISSION_BUILD_CITY_DISABLED_UNHAPPY"
            elseif actionType == "MISSION_CULTURE_BOMB" and activePlayer:GetCultureBombTimer() > 0 then
                disabledTip[#disabledTip+1] = L("TXT_KEY_MISSION_CULTURE_BOMB_DISABLED_COOLDOWN", activePlayer:GetCultureBombTimer())
            elseif action.DisabledHelp and action.DisabledHelp ~= "" then
                disabledTip[#disabledTip+1] = L(action.DisabledHelp)
            end
        end
        if #disabledTip > 0 then
            toolTip[#toolTip+1] = "[COLOR_WARNING_TEXT]"..concat(disabledTip, "[NEWLINE]").."[ENDCOLOR]"
        end
    end

    if isBuild then
        local turns = GetUnitBuildProgressData(unitPlot, buildID, unit)
        if turns > 0 then
            strBuildTurns = " ... "..L("TXT_KEY_STR_TURNS", turns)
        end
        for yieldID = 0, NUM_YIELD_TYPES_minus1 do
            local change = unitPlot:GetYieldWithBuild(buildID, yieldID, false, activePlayer:GetID()) - unitPlot:CalculateYield(yieldID)
            if change > 0 then
                toolTip[#toolTip+1] = "[COLOR_POSITIVE_TEXT]+"..L(g_yieldString[yieldID], change)
            elseif change < 0 then
                toolTip[#toolTip+1] = "[COLOR_NEGATIVE_TEXT]"..L(g_yieldString[yieldID], change)
            end
        end
        if improvement then
            local resID = unitPlot:GetResourceType(activeTeam:GetID())
            local res = Resources[resID]
            if res and unitPlot:IsResourceConnectedByImprovement(improvementID) and GetResourceUsageType(resID) ~= RESOURCEUSAGE_BONUS then
                toolTip[#toolTip+1] = L("TXT_KEY_BUILD_CONNECTS_RESOURCE", res.IconString, res.Description)
            end
        end
        if feature and unitPlot:IsBuildRemovesFeature(buildID) then
            local tip = L("TXT_KEY_BUILD_FEATURE_CLEARED", feature.Description)
            local prod = unitPlot:GetFeatureProduction(buildID, activeTeam:GetID())
            if prod > 0 then
                tip = tip..L("TXT_KEY_BUILD_FEATURE_PRODUCTION", prod)
                local city = unitPlot:GetWorkingCity()
                if city then tip = tip.." ("..city:GetName()..")" end
            end
            toolTip[#toolTip+1] = tip
        end
    end

    controls.UnitActionHelp:SetText(concat(toolTip, "[NEWLINE]"))
    controls.UnitActionText:SetText("[COLOR_POSITIVE_TEXT]"..L(tostring(action.TextKey or actionType)).."[ENDCOLOR]"..strBuildTurns)
    if action.HotKey and action.HotKey ~= "" and action.SubType ~= ACTIONSUBTYPE_PROMOTION then
        controls.UnitActionHotKey:SetText("("..tostring(action.HotKey)..")")
    else
        controls.UnitActionHotKey:SetText()
    end
    controls.UnitActionMouseover:DoAutoSize()
    if controls.UnitActionMouseover:GetSizeX() < 350 then
        controls.UnitActionMouseover:SetSizeX(350)
    end
end)

-- ========== 单位工具提示 ==========
local function GetSortedPromotions(unit)
    local list = {}
    for _, promo in pairs(UnitPromotions) do
        if unit:IsHasPromotion(promo.ID) and promo.ShowInUnitPanel ~= 0 and promo.ShowInTooltip ~= 0 then
            list[#list+1] = promo
        end
    end
    table.sort(list, function(a,b) return a.ID < b.ID end)
    return list
end

local function UnitToolTip(unit)
    if not unit then return end
    local controls = g_UnitTooltipControls
    local tip = ShortUnitTip(unit)
    local playerID = unit:GetOwner()
    if playerID == GetActivePlayer() then
        tip = tip.."[NEWLINE]"..L("TXT_KEY_UNIT_EXPERIENCE_INFO", unit:GetLevel(), unit:GetExperience(), unit:ExperienceNeeded())..L"TXT_KEY_UPANEL_CLICK_TO_SELECT"
    end
    controls.Text:SetText(tip)

    local iconIndex, iconAtlas = GetUnitPortraitIcon(unit)
    IconHookup(iconIndex, 256, iconAtlas, controls.UnitPortrait)
    CivIconHookup(playerID, 64, controls.CivIcon, controls.CivIconBG, controls.CivIconShadow, false, true)

    g_PromotionIconIM:ResetInstances()
    local promoList = {}
    if not (unit.IsTrade and unit:IsTrade()) then
        for _, promo in ipairs(GetSortedPromotions(unit)) do
            local inst = g_PromotionIconIM:GetInstance()
            IconHookup(promo.PortraitIndex, 32, promo.IconAtlas, inst.Image)
            promoList[#promoList+1] = promo._Name
        end
    end
    controls.PromotionText:SetText(concat(promoList, "[NEWLINE]"))
    controls.PromotionText:SetHide(#promoList ~= 1)
    controls.IconStack:SetWrapWidth(ceil(#promoList / ceil(#promoList / 10)) * 26)
    controls.IconStack:CalculateSize()
    controls.PortraitFrame:SetAnchor(GetMousePos() > 300 and "L,T" or "R,T")
    controls.Box:DoAutoSize()
    Controls.UnitTooltipTimer:SetToBeginning()
    Controls.UnitTooltipTimer:Reverse()
end
LuaEvents.UnitToolTip.Add(UnitToolTip)

LuaEvents.UnitFlagToolTip.Add(function(button)
    local player = Players[button:GetVoid1()]
    UnitToolTip(player and player:GetUnitByID(button:GetVoid2()))
end)

local UnitToolTips = {
    Button = UnitToolTip,
    MovementPip = function(unit)
        if not unit then return end
        return ShowTextToolTip(format("%s %.3g / %g [ICON_MOVES]", L"TXT_KEY_UPANEL_MOVEMENT", unit:MovesLeft()/MOVE_DENOMINATOR, unit:MaxMoves()/MOVE_DENOMINATOR))
    end,
    Mission = function(unit)
        if not unit then return ShowTextToolTip("Error - cannot find unit") end
        local status
        local buildID = unit:GetBuildType()
        if buildID ~= -1 then
            status = (Builds[buildID]._Name or "???").." ("..GetUnitBuildProgressData(unit:GetPlot(), buildID, unit)..")"
        elseif unit:IsEmbarked() then
            status = L"TXT_KEY_MISSION_EMBARK_HELP"
        elseif unit:IsAutomated() then
            if unit:IsWork() then
                status = L"TXT_KEY_ACTION_AUTOMATE_BUILD"
            elseif unit.IsTrade and unit:IsTrade() then
                status = L"TXT_KEY_ACTION_AUTOMATE_TRADE"
            else
                status = L"TXT_KEY_ACTION_AUTOMATE_EXPLORE"
            end
        else
            local activity = unit:GetActivityType()
            local info = g_activityMissions[activity]
            if not info then
                if unit:MovesLeft() > 0 then
                    if info == false then
                        info = GameInfo.Missions.MISSION_SKIP
                    elseif unit:IsGarrisoned() then
                        info = GameInfo.Missions.MISSION_GARRISON
                    elseif unit:IsEverFortifyable() then
                        status = format("%s %+i%%[ICON_STRENGTH]", L"TXT_KEY_UNIT_STATUS_FORTIFIED", unit:FortifyModifier())
                    else
                        info = GameInfo.Missions.MISSION_SLEEP
                    end
                else
                    info = GameInfo.Missions.MISSION_MOVE_TO
                end
            end
            if info then
                status = L(info.Help)
            end
        end
        return ShowTextToolTip(status or "Unknown activity")
    end,
}
LuaEvents.UnitToolTips.Add(function(...) return TooltipSelect(UnitToolTips, ...) end)

-- ========== 单位类型工具提示 ==========
LuaEvents.UnitPanelItemTooltip.Add(function(control, itemID)
    local iconIdx, atlas = GetUnitPortraitIcon(itemID, GetActivePlayer())
    ShowTextToolTipAndPictureEx(g_ItemTooltipControls, GetHelpTextForUnit(itemID, true), iconIdx, atlas, nil)
end)

-- ========== 城市横幅 & 工具提示 ==========
local function CityPlots(city, startIdx)
    startIdx = startIdx or 0
    local maxDist = GameDefines.MAXIMUM_ACQUIRE_PLOT_DISTANCE
    local maxPlot = (maxDist+1)^2 * 3
    return function()
        while startIdx <= maxPlot do
            local plot = city:GetCityIndexPlot(startIdx)
            startIdx = startIdx + 1
            if plot and plot:GetWorkingCity() == city then
                return plot
            end
        end
    end
end

local function CityIsCapital(city)
    local ownerID = city:GetOwner()
    local owner = Players[ownerID]
    local origOwnerID = city:GetOriginalOwner()
    local origOwner = Players[origOwnerID]
    local activePlayerID = GetActivePlayer()
    local nameKey = city:GetNameKey()
    if city:IsOriginalCapital() then
        if ownerID == origOwnerID then
            if ownerID == activePlayerID then
                return L("TXT_KEY_VP_DIPLO_TT_YOU_CONTROL_YOUR_CAPITAL", nameKey)
            else
                return L("TXT_KEY_VP_DIPLO_TT_SOMEONE_CONTROLS_THEIR_CAPITAL", owner:GetName(), nameKey)
            end
        end
    else
        for pid, p in pairs(Players) do
            for c in p:Cities() do
                if c:IsOriginalCapital() and c:GetOriginalOwner() == origOwnerID then
                    nameKey = c:GetNameKey()
                    ownerID = pid
                    owner = p
                    p = nil
                    break
                end
            end
            if not p then break end
        end
    end
    if ownerID == activePlayerID then
        return L("TXT_KEY_VP_DIPLO_TT_YOU_CONTROL_OTHER_PLAYER_CAPITAL", nameKey, origOwner:GetCivilizationShortDescriptionKey())
    elseif origOwnerID == activePlayerID then
        return L("TXT_KEY_VP_DIPLO_TT_OTHER_PLAYER_CONTROLS_YOUR_CAPITAL", owner:GetName(), nameKey)
    else
        return L("TXT_KEY_VP_DIPLO_TT_OTHER_PLAYER_CONTROLS_OTHER_PLAYER_CAPITAL", owner:GetName(), nameKey, origOwner:GetCivilizationShortDescriptionKey())
    end
end

local function CityProduction(city)
    if not city then return end
    local controls = g_CityProductionTooltipControls
    local orderID, itemID = city:GetOrderFromQueue()
    local tip, iconIdx, atlas, isRealRepeat
    local isProducing = true
    if orderID == ORDER_TRAIN then
        iconIdx, atlas = GetUnitPortraitIcon(itemID, city:GetOwner())
        tip = GetHelpTextForUnit(itemID, true)
        isRealRepeat = false
    elseif orderID == ORDER_CONSTRUCT then
        iconIdx, atlas = GetItemPortraitIcon(Buildings, itemID)
        tip = GetHelpTextForBuilding(itemID, false, false, city:GetNumFreeBuilding(itemID) > 0, city)
        isRealRepeat = false
    elseif orderID == ORDER_CREATE then
        iconIdx, atlas = GetItemPortraitIcon(Projects, itemID)
        tip = GetHelpTextForProject(itemID, true, city)
        isRealRepeat = false
    elseif orderID == ORDER_MAINTAIN then
        iconIdx, atlas = GetItemPortraitIcon(Processes, itemID)
        tip = GetHelpTextForProcess(itemID, true)
        isRealRepeat = true
        isProducing = false
    else
        tip = L("TXT_KEY_CITY_NOT_PRODUCING", city:GetName())
        isProducing = false
    end
    local change = city:GetCurrentProductionDifferenceTimes100(false, false)
    ShowProgressToolTip(controls, 256, iconIdx, atlas, tip,
        isProducing and city:GetProductionTurnsLeft(),
        city:GetProductionNeeded() * 100,
        city:GetProductionTimes100() + city:GetCurrentProductionDifferenceTimes100(false, true) - change,
        change)
end

local CityToolTips = {
    CityBannerButton = function(city)
        local cityOwner = Players[city:GetOwner()]
        local activeTeam = Teams[GetActiveTeam()]
        local tip = ""
        local resources = {}
        for plot in CityPlots(city) do
            if plot and plot:IsRevealed(activeTeam:GetID(), true) then
                local resID = plot:GetResourceType(activeTeam:GetID())
                local num = plot:GetNumResource()
                if num > 0 then
                    if not plot:IsCity() and (plot:IsImprovementPillaged() or not plot:IsResourceConnectedByImprovement(plot:GetImprovementType())) then
                        num = num / 65536
                    end
                    resources[resID] = (resources[resID] or 0) + num
                end
            end
        end
        for resID, num in pairs(resources) do
            local res = Resources[resID]
            if res then
                local conn, notconn = modf(num)
                notconn = notconn * 65536
                local usage = GetResourceUsageType(resID)
                if usage == RESOURCEUSAGE_STRATEGIC or usage == RESOURCEUSAGE_LUXURY then
                    if conn > 0 then tip = tip.." [COLOR_POSITIVE_TEXT]"..conn.."[ENDCOLOR]"..res.IconString end
                    if notconn > 0 then tip = tip.." [COLOR_WARNING_TEXT]"..notconn.."[ENDCOLOR]"..res.IconString end
                end
            end
        end
        if city:GetTeam() == activeTeam:GetID() then
            local stored = city:GetJONSCultureStored()
            local needed = city:GetJONSCultureThreshold()
            local perTurn = city:GetJONSCulturePerTurn()
            if perTurn > 0 then
                tip = tip.."[NEWLINE][COLOR_MAGENTA]"..L("TXT_KEY_CITYVIEW_TURNS_TILL_TILE_TEXT", max(ceil((needed - stored)/perTurn), 1)).."[ENDCOLOR]"
            else
                tip = tip.." 0 [ICON_CULTURE]"
            end
            if city.GetReligiousMajority and city:GetReligiousMajority() < 0 then
                local relTip = GetReligionTooltip(city)
                if relTip and relTip~="" then tip = tip.."[NEWLINE]"..relTip end
            end
            if g_isBasicHelp then
                if city:GetOwner() == GetActivePlayer() then
                    tip = tip.."[NEWLINE]"..L"TXT_KEY_CITY_ENTER_CITY_SCREEN"
                else
                    tip = tip.."[NEWLINE]"..L"TXT_KEY_CITY_TEAMMATE"
                end
            end
        elseif activeTeam:IsHasMet(city:GetTeam()) then
            if city.GetReligiousMajority and city:GetReligiousMajority() < 0 then
                local relTip = GetReligionTooltip(city)
                if relTip and relTip~="" then tip = tip.."[NEWLINE]"..relTip end
            end
            if cityOwner.GetWarmongerPreviewString and activeTeam:IsAtWar(city:GetTeam()) then
                tip = tip.."[NEWLINE]"..cityOwner:GetWarmongerPreviewString(city:GetOwner())
                if city:GetOriginalOwner() ~= city:GetOwner() then
                    tip = tip.."[NEWLINE]"..cityOwner:GetLiberationPreviewString(city:GetOriginalOwner())
                end
            elseif g_isAlwaysWar then
                tip = tip.."[NEWLINE]"..L"TXT_KEY_ALWAYS_AT_WAR_WITH_CITY"
            end
        end
        return tip
    end,
    CityBannerRightBackground = function(city)
        local cityOwner = Players[city:GetOwner()]
        local activeTeam = Teams[GetActiveTeam()]
        if cityOwner and activeTeam and activeTeam:IsHasMet(cityOwner:GetTeam()) then
            local tip = cityOwner:IsMinorCiv() and GetCityStateStatusToolTip(GetActivePlayer(), city:GetOwner(), true) or GetMoodInfo(city:GetOwner(), true)
            return g_isBasicHelp and L"TXT_KEY_TALK_TO_PLAYER".."[NEWLINE][NEWLINE]"..tip or tip
        else
            return L"TXT_KEY_HAVENT_MET"
        end
    end,
    BuildGrowth = function(city)
        return ShowTextToolTip(L("TXT_KEY_CITY_CURRENTLY_PRODUCING_TT", city:GetName(), city:GetProductionNameKey(), city:GetProductionTurnsLeft()), GetProductionTooltip(city))
    end,
    CityGrowth = function(city)
        local foodPerTurn = city:FoodDifferenceTimes100()
        local tip
        if foodPerTurn < 0 then
            tip = L("TXT_KEY_NTFN_CITY_STARVING", city:GetName())
        elseif city:IsForcedAvoidGrowth() then
            tip = L"TXT_KEY_CITYVIEW_FOCUS_AVOID_GROWTH_TEXT"
        elseif city:IsFoodProduction() or foodPerTurn == 0 then
            tip = L"TXT_KEY_CITYVIEW_STAGNATION_TEXT"
        else
            tip = L("TXT_KEY_CITYVIEW_TURNS_TILL_CITIZEN_TEXT", city:GetFoodTurnsLeft())
        end
        return ShowTextToolTip(tip, GetFoodTooltip(city))
    end,
    BorderGrowth = function(city)
        return ShowTextToolTip(city:GetName(),
            L("TXT_KEY_CITYVIEW_TURNS_TILL_TILE_TEXT", ceil((city:GetJONSCultureThreshold() - city:GetJONSCultureStored()) / city:GetJONSCulturePerTurn())),
            GetCultureTooltip(city))
    end,
    CityReligion = function(city) return GetReligionTooltip(city) end,
    CityFocus = function(city) return city and g_cityFocusTooltips[city:GetFocusType()] end,
    CityQuests = function(city)
        local cityOwner = Players[city:GetOwner()]
        if not cityOwner then return end
        if cityOwner:IsMinorCiv() then
            return GetActiveQuestToolTip(GetActivePlayer(), city:GetOwner())
        else
            local res = Resources[city:GetResourceDemanded()]
            local wltk = city:GetWeLoveTheKingDayCounter()
            if wltk > 0 then
                return L("TXT_KEY_CITYVIEW_WLTKD_COUNTER", wltk)
            elseif res then
                return ShowResourceToolTip(res.ID, {L("TXT_KEY_CITYVIEW_RESOURCE_DEMANDED", res.IconString.." "..res._Name)})
            end
        end
    end,
    CityIsPuppet = function(city)
        local owner = Players[city:GetOwner()]
        if owner.MayNotAnnex and owner:MayNotAnnex() or city:GetOwner() ~= GetActivePlayer() then
            return L"TXT_KEY_CITY_PUPPET"
        else
            return L"TXT_KEY_CITY_PUPPET".."[NEWLINE][NEWLINE]"..L"TXT_KEY_CITY_ANNEX_TT"
        end
    end,
    CityIsRazing = function(city) return L("TXT_KEY_CITY_BURNING", city:GetRazingTurns()) end,
    CityIsResistance = function(city) return L("TXT_KEY_CITY_RESISTANCE", city:GetResistanceTurns()) end,
    CityIsConnected = function(city)
        local owner = Players[city:GetOwner()]
        local tip = L"TXT_KEY_CITY_CONNECTED"
        if owner then
            tip = format("%s (%+g[ICON_GOLD])", tip, (owner.GetRouteGoldTimes100 or owner.GetCityConnectionRouteGoldTimes100)(owner, city) / 100)
        end
        return tip
    end,
    CityIsBlockaded = function() return L"TXT_KEY_CITY_BLOCKADED" end,
    CityIsOccupied = function() return L"TXT_KEY_CITY_OCCUPIED" end,
    CityIsCapital = CityIsCapital,
    CityIsOriginalCapital = CityIsCapital,
    CivIndicator = function(city)
        local owner = city:GetOwner()
        if owner == city:GetOriginalOwner() then
            return GetAllyToolTip(GetActivePlayer(), owner)
        else
            return L("TXT_KEY_POPUP_CITY_CAPTURE_INFO_LIBERATE", Players[city:GetOriginalOwner()]:GetCivilizationShortDescription())
        end
    end,
    CityProductionBG = CityProduction,
    Button = CityProduction,
    CityPopulation = function(city)
        local foodStored = city:GetFoodTimes100()
        local foodPerTurn = city:FoodDifferenceTimes100(true)
        local turns = city:GetFoodTurnsLeft()
        local iconIdx = 0
        if foodPerTurn < 0 then
            turns = floor(foodStored / -foodPerTurn) + 1
            iconIdx = 5
        end
        return ShowProgressToolTip(g_CityGrowthTooltipControls, 256, iconIdx, "CITIZEN_ATLAS",
            city:GetPopulation(), turns, city:GrowthThreshold()*100, foodStored, foodPerTurn)
    end,
}
LuaEvents.CityToolTips.Add(function(control, city)
    local tip = city and TooltipSelect(CityToolTips, control, city)
    return tip and ShowTextToolTip(city:GetName(), tip)
end)

-- ========== 城市界面工具提示 ==========
LuaEvents.CityViewBuildingToolTip.Add(function(control)
    local buildingID = control:GetVoid1()
    local building = Buildings[buildingID]
    local city = GetHeadSelectedCity()
    if city then
        local tip = GetHelpTextForBuilding(buildingID, false, false, city:GetNumFreeBuilding(buildingID) > 0, city)
        ShowTextToolTipAndPictureEx(g_ItemTooltipControls, tip, building and building.PortraitIndex, building and building.IconAtlas)
    end
end)

local function CityOrderItemTooltip(city, isDisabled, purchaseYieldID, orderID, itemID, _, isRepeat)
    if not city then return ShowTextToolTip("Unknown city") end
    local tip, iconIdx, atlas, isRealRepeat
    local itemInfo
    if orderID == ORDER_TRAIN then
        itemInfo = Units
        iconIdx, atlas = GetUnitPortraitIcon(itemID, city:GetOwner())
        tip = GetHelpTextForUnit(itemID, true)
        isRealRepeat = isRepeat
        if isDisabled then
            local disabledMsg
            if purchaseYieldID == g_yieldCurrency then
                disabledMsg = city:GetPurchaseUnitTooltip(itemID)
            elseif purchaseYieldID == YieldTypes.YIELD_FAITH then
                disabledMsg = city:GetFaithPurchaseUnitTooltip(itemID)
            else
                disabledMsg = city:CanTrainTooltip(itemID)
            end
            if disabledMsg and #disabledMsg > 0 then
                disabledMsg = disabledMsg:gsub("^%[NEWLINE%]",""):gsub("^%[NEWLINE%]","")
                tip = "[COLOR_WARNING_TEXT]"..disabledMsg.."[ENDCOLOR][NEWLINE][NEWLINE]"..tip
            end
        end
    elseif orderID == ORDER_CONSTRUCT then
        itemInfo = Buildings
        tip = GetHelpTextForBuilding(itemID, false, false, city:GetNumFreeBuilding(itemID) > 0, city)
        isRealRepeat = false
        if isDisabled then
            local disabledMsg
            if purchaseYieldID == g_yieldCurrency then
                disabledMsg = city:GetPurchaseBuildingTooltip(itemID)
            elseif purchaseYieldID == YieldTypes.YIELD_FAITH then
                disabledMsg = city:GetFaithPurchaseBuildingTooltip(itemID)
            else
                disabledMsg = city:CanConstructTooltip(itemID)
            end
            if disabledMsg and #disabledMsg > 0 then
                disabledMsg = disabledMsg:gsub("^%[NEWLINE%]",""):gsub("^%[NEWLINE%]","")
                tip = "[COLOR_WARNING_TEXT]"..disabledMsg.."[ENDCOLOR][NEWLINE][NEWLINE]"..tip
            end
        end
    elseif orderID == ORDER_CREATE then
        itemInfo = Projects
        tip = GetHelpTextForProject(itemID, true, city)
        isRealRepeat = false
    elseif orderID == ORDER_MAINTAIN then
        itemInfo = Processes
        tip = GetHelpTextForProcess(itemID, true)
        isRealRepeat = true
    else
        tip = L"TXT_KEY_PRODUCTION_NO_PRODUCTION"
    end
    if tip then
        if isRealRepeat then tip = "[ICON_TURNS_REMAINING]"..tip end
        if purchaseYieldID and not isDisabled then
            tip = "[COLOR_YELLOW]"..L"TXT_KEY_CITYVIEW_PURCHASE_TT".."[ENDCOLOR][NEWLINE][NEWLINE]"..tip
        elseif isDisabled then
            tip = "[COLOR_YIELD_FOOD]"..L"TXT_KEY_CITYVIEW_QUEUE_PROD_TT".."[ENDCOLOR][NEWLINE][NEWLINE]"..tip
        end
    end
    local item = itemInfo and itemInfo[itemID]
    ShowTextToolTipAndPictureEx(g_ItemTooltipControls, tip, iconIdx or (item and item.PortraitIndex), atlas or (item and item.IconAtlas))
end
LuaEvents.CityOrderItemTooltip.Add(CityOrderItemTooltip)

local CityViewToolTips = {
    ProdBox = GetProductionTooltip,
    FoodBox = GetFoodTooltip,
    PopulationBox = GetFoodTooltip,
    GoldBox = GetGoldTooltip,
    ScienceBox = GetScienceTooltip,
    CultureBox = GetCultureTooltip,
    FaithBox = GetFaithTooltip,
    TourismBox = GetTourismTooltip,
    ProductionPortraitButton = function() CityOrderItemTooltip(GetHeadSelectedCity(), false, false, GetHeadSelectedCity():GetOrderFromQueue(0)) end,
}
LuaEvents.CityViewToolTips.Add(function(control)
    local city = GetHeadSelectedCity()
    local tip = city and TooltipSelect(CityViewToolTips, control, city)
    return tip and ShowTextToolTip(tip)
end)

-- ========== 科技 & 生产选择工具提示 ==========
Controls.UnitTooltipTimer2:RegisterAnimCallback(function()
    local c = g_ItemTooltipControls
    c.PortraitFrame2:SetHide(false)
    c.IconStack2:SetWrapWidth(32)
    c.IconStack2:CalculateSize()
    c.PromotionText2:SetHide(false)
    c.Box:ReprocessAnchoring()
    c.Box:DoAutoSize()
end)

LuaEvents.TechButtonTooltip.Add(function(orderID, itemID)
    local tip, iconIdx, atlas
    if orderID == ORDER_TRAIN then
        iconIdx, atlas = GetUnitPortraitIcon(itemID, GetActivePlayer())
        tip = GetHelpTextForUnit2(itemID)  -- 假设外部提供
        ShowTextToolTipAndPicture2(tip, orderID, itemID, iconIdx, atlas)
    elseif orderID == ORDER_CONSTRUCT then
        iconIdx, atlas = GetItemPortraitIcon(Buildings, itemID)
        tip = GetHelpTextForBuilding(itemID)
        ShowTextToolTipAndPictureEx(g_ItemTooltipControls, tip, iconIdx, atlas, nil)
    elseif orderID == ORDER_CREATE then
        iconIdx, atlas = GetItemPortraitIcon(Projects, itemID)
        tip = GetHelpTextForProject(itemID, true)
        ShowTextToolTipAndPictureEx(g_ItemTooltipControls, tip, iconIdx, atlas, nil)
    elseif orderID == ORDER_MAINTAIN then
        iconIdx, atlas = GetItemPortraitIcon(Processes, itemID)
        tip = GetHelpTextForProcess(itemID, true)
        ShowTextToolTipAndPictureEx(g_ItemTooltipControls, tip, iconIdx, atlas, nil)
    elseif orderID == 11 then  -- Resource reveal
        iconIdx, atlas = GetItemPortraitIcon(Resources, itemID)
        tip = L("TXT_KEY_REVEALS_RESOURCE_ON_MAP", Resources[itemID]._Name)
        ShowTextToolTipAndPictureEx(g_ItemTooltipControls, tip, iconIdx, atlas, nil)
    elseif orderID == 12 then  -- Build
        local build = Builds[itemID]
        if build then
            tip = build._Name
            local imp = Improvements[build.ImprovementType]
            if imp then
                tip = GetHelpTextForImprovement(imp.ID)
                iconIdx, atlas = imp.PortraitIndex, imp.IconAtlas
            else
                local route = Routes[build.RouteType]
                if route then
                    iconIdx, atlas = route.PortraitIndex, route.IconAtlas
                else
                    local row = GameInfo.BuildFeatures({BuildType = build.Type})()
                    if row then
                        local feat = Features[row.FeatureType]
                        if feat then iconIdx, atlas = feat.PortraitIndex, feat.IconAtlas end
                    end
                end
            end
        end
        ShowTextToolTipAndPictureEx(g_ItemTooltipControls, tip, iconIdx, atlas, nil)
    elseif orderID == 13 then  -- Mission
        local mission = GameInfo.Missions[itemID]
        if mission then
            local entry = mission.Type
            if entry == "MISSION_EMBARK" then
                mission = GameInfo.Concepts.CONCEPT_MOVEMENT_EMBARKING
            elseif entry == "MISSION_ROUTE_TO" then
                mission = GameInfo.Concepts.CONCEPT_WORKERS_ROADS_TRADE_ROUTES
            elseif entry == "MISSION_ESTABLISH_TRADE_ROUTE" then
                mission = GameInfo.Concepts.CONCEPT_TRADE_ROUTES
            end
            if mission then tip = mission._Name end
        end
        ShowTextToolTipAndPictureEx(g_ItemTooltipControls, tip, nil, nil, nil)
    elseif orderID == 14 then  -- Terraform
        local tf = GameInfo.Terraform[itemID]
        if tf then
            local entry = tf.Type
            if entry == "TERRAFORM_ADD_MIASMA" then
                tf = GameInfo.Concepts.CONCEPT_WORKERS_PLACE
            elseif entry == "TERRAFORM_CLEAR_MIASMA" then
                tf = GameInfo.Concepts.CONCEPT_WORKERS_REMOVE
            else
                tf = Features[tf.FeatureTypeChange] or Terrains[tf.TerrainTypeChange]
            end
            if tf then tip = tf._Name end
        end
        ShowTextToolTipAndPictureEx(g_ItemTooltipControls, tip, nil, nil, nil)
    end
end)

LuaEvents.TechTooltip.Add(function(techID)
    local tech = Technologies[techID]
    local player = Players[GetActivePlayer()]
    local canResearch = player and player:CanResearch(techID) or false
    local tip = GetHelpTextForTech(techID, canResearch)
    ShowTextToolTipAndPictureEx(g_ItemTooltipControls, tip, tech and tech.PortraitIndex, tech and tech.IconAtlas)
end)

-- ========== 政策工具提示 ==========
LuaEvents.PolicyTooltip.Add(function(control)
    local policyID = control:GetVoid1()
    local policy = Policies[policyID]
    local player = Players[GetActivePlayer()]
    if not (policy and player) then return end
    local tip = L(policy.Help)
    if player:HasPolicy(policyID) then
        if player:IsPolicyBlocked(policyID) then
            tip = tip.."[NEWLINE][NEWLINE]"..L("TXT_KEY_POLICY_BRANCH_BLOCKED")
        end
    elseif player:CanAdoptPolicy(policyID) then
        -- can adopt
    elseif player:CanAdoptPolicy(policyID, true) then
        tip = tip.."[NEWLINE][NEWLINE]"..L("TXT_KEY_POLICY_BRANCH_CANNOT_UNLOCK_CULTURE", player:GetNextPolicyCost())
    else
        tip = tip.."[NEWLINE][NEWLINE]"..L("TXT_KEY_POLICY_CANNOT_UNLOCK")
    end
    ShowTextToolTipAndPictureEx(g_ItemTooltipControls, tip, policy.PortraitIndex, policy.IconAtlas)
end)

LuaEvents.PolicyBranchTooltip.Add(function(control)
    local branchID = control:GetVoid1()
    local branch = PolicyBranchTypes[branchID]
    local player = Players[GetActivePlayer()]
    if not (branch and player) then return end
    local tip = L(branch.Help)
    if player:IsPolicyBranchUnlocked(branchID) then
        if player:IsPolicyBranchBlocked(branchID) then
            tip = tip.."[NEWLINE][NEWLINE]"..L("TXT_KEY_POLICY_BRANCH_BLOCKED")
        end
    elseif branch.LockedWithoutReligion and not g_isReligionEnabled then
        tip = tip.."[NEWLINE][NEWLINE]"..L("TXT_KEY_POLICY_BRANCH_CANNOT_UNLOCK_RELIGION")
    elseif player:CanUnlockPolicyBranch(branchID) then
        tip = tip.."[NEWLINE][NEWLINE]"..L("TXT_KEY_POLICY_BRANCH_UNLOCK_SPEND", player:GetNextPolicyCost())
    else
        tip = tip.."[NEWLINE][NEWLINE]"..L("TXT_KEY_POLICY_BRANCH_CANNOT_UNLOCK")
        local eraReq = GameInfoTypes[branch.EraPrereq]
        local civType = Civilizations[player:GetCivilizationType()].Type
        local bLocked = GameInfo.PolicyBranch_CivilizationLocked({PolicyBranchType = branch.Type, CivilizationType = civType})()
        if eraReq and Teams[player:GetTeam()]:GetCurrentEra() < eraReq then
            tip = tip.." "..L("TXT_KEY_POLICY_BRANCH_CANNOT_UNLOCK_ERA", Eras[eraReq].Description)
        elseif bLocked then
            tip = tip.." "..L("TXT_KEY_POLICY_BRANCH_CANNOT_UNLOCK_CIVILIZATION")
        else
            tip = tip.." "..L("TXT_KEY_POLICY_BRANCH_CANNOT_UNLOCK_CULTURE", player:GetNextPolicyCost())
        end
    end
    ShowTextToolTip(tip)
end)

LuaEvents.TenetToolTip.Add(function(control)
    local player = Players[GetActivePlayer()]
    local tenetID = control:GetVoid1()
    local tenetLevel = control:GetVoid2()
    local tip = "???"
    if player then
        local tenetInfo = Policies[tenetID]
        if tenetInfo then
            tip = L(tenetInfo.Help)
        else
            if tenetID == -1 then
                tip = L"TXT_KEY_POLICYSCREEN_ADD_TENET"
            elseif tenetID == -2 then
                tip = L("TXT_KEY_POLICY_BRANCH_CANNOT_UNLOCK_CULTURE", player:GetNextPolicyCost())
            elseif tenetID == -3 then
                tip = "[ICON_LOCKED]"..L("TXT_KEY_POLICYSCREEN_NEED_L"..(tenetLevel-1).."_TENETS_TOOLTIP")
            elseif tenetID == -4 then
                tip = "[ICON_LOCKED][COLOR_WARNING_TEXT]"..L("TXT_KEY_POLICYSCREEN_IDEOLOGY_LEVEL"..tenetLevel).."[ENDCOLOR]"
            end
            local tips = {tip}
            for _, tid in ipairs(player:GetAvailableTenets(tenetLevel)) do
                local info = Policies[tid]
                if info then
                    tips[#tips+1] = L(info.Help or info.Description or "???")
                end
            end
            tip = concat(tips, "[NEWLINE][NEWLINE]")
        end
    end
    ShowTextToolTip(tip)
end)

-- ========== 顶部面板工具提示 ==========
local function AppendAnarchy(tips)
    local player = Players[GetActivePlayer()]
    if IsCiv5BNW_BE and player:IsAnarchy() then
        tips[#tips+1] = L("TXT_KEY_TP_ANARCHY", player:GetAnarchyNumTurns())
        tips[#tips+1] = ""
    end
end

local function ScienceTooltip()
    local tips = {}
    if g_isScienceEnabled then
        local activePlayer = Players[GetActivePlayer()]
        local activeTeam = Teams[GetActiveTeam()]
        local activeTeamTechs = activeTeam:GetTeamTechs()
        local sciencePerTurn = activePlayer:GetScienceTimes100() / 100
        local techID = activePlayer:GetCurrentResearch()
        local recentTechID = activeTeamTechs:GetLastTechAcquired()
        AppendAnarchy(tips)

        if techID ~= -1 then
            local tech = Technologies[techID]
            local turnsLeft = activePlayer:GetResearchTurnsLeft(techID, true)
            local cost = activePlayer:GetResearchCost(techID)
            local progress = activePlayer:GetResearchProgress(techID)
            local tip = progress.."[ICON_RESEARCH]"
            if tech then
                tip = L("TXT_KEY_PROGRESS_TOWARDS", g_scienceTextColor..Locale.ToUpper(tech._Name).."[ENDCOLOR]").." "..tip.."/ "..cost.."[ICON_RESEARCH]"
            end
            tips[#tips+1] = tip
            if sciencePerTurn > 0 then
                local overflow = sciencePerTurn * turnsLeft + progress - cost
                local line = g_scienceTextColor..Locale.ToUpper(L("TXT_KEY_STR_TURNS", turnsLeft)).."[ENDCOLOR] "..format("%+g", overflow).."[ICON_RESEARCH]"
                if turnsLeft > 1 then
                    line = L("TXT_KEY_STR_TURNS", turnsLeft-1).." "..format("%+g", overflow - sciencePerTurn).."[ICON_RESEARCH]  "..line
                end
                tips[#tips+1] = line
            end
        elseif recentTechID ~= -1 then
            local tech = Technologies[recentTechID]
            local tip = L"TXT_KEY_NOTIFICATION_SUMMARY_NEW_RESEARCH"
            if tech then
                tip = L"TXT_KEY_RESEARCH_FINISHED".." "..g_scienceTextColor..Locale.ToUpper(tech._Name).."[ENDCOLOR], "..tip
            end
            tips[#tips+1] = tip
        end

        tips[#tips+1] = g_scienceTextColor..format("%+g", sciencePerTurn).."[ENDCOLOR] "..L"TXT_KEY_REPLAY_DATA_SCIENCEPERTURN"
        local deficit = activePlayer:GetScienceFromBudgetDeficitTimes100() / 100
        insertLocalizedIfNonZero(tips, "TXT_KEY_TP_SCIENCE_FROM_BUDGET_DEFICIT", deficit)
        insertLocalizedIfNonZero(tips, "TXT_KEY_TP_SCIENCE_FROM_CITIES", activePlayer:GetScienceFromCitiesTimes100(true) / 100)
        insertLocalizedIfNonZero(tips, "TXT_KEY_TP_SCIENCE_FROM_ITR", (activePlayer:GetScienceFromCitiesTimes100(false) - activePlayer:GetScienceFromCitiesTimes100(true)) / 100)
        insertLocalizedIfNonZero(tips, "TXT_KEY_TP_SCIENCE_FROM_MINORS", activePlayer:GetScienceFromOtherPlayersTimes100() / 100)

        if IsCiv5 then
            insertLocalizedIfNonZero(tips, "TXT_KEY_TP_SCIENCE_FROM_RELIGION", activePlayer:GetScienceFromReligion())
            insertLocalizedIfNonZero(tips, "TXT_KEY_SP_UI_SCIENCE_BY_HAPPINESS_NEW", activePlayer:GetYieldModifierFromHappinessPolicy(GameInfoTypes["YIELD_SCIENCE"]))
            insertLocalizedIfNonZero(tips, "TXT_KEY_PRODMOD_YIELD_RESOURCE_BUFF", activePlayer:GetGlobalYieldModifierFromResource(GameInfoTypes["YIELD_SCIENCE"]))
            insertLocalizedIfNonZero(tips, "TXT_KEY_TP_SCIENCE_FROM_HAPPINESS", activePlayer:GetScienceFromHappinessTimes100() / 100)
            insertLocalizedIfNonZero(tips, "TXT_KEY_TP_SCIENCE_FROM_RESEARCH_AGREEMENTS", activePlayer:GetScienceFromResearchAgreementsTimes100() / 100)

            -- 研究协定列表
            local activePlayerID = GetActivePlayer()
            local gameTurn = Game.GetGameTurn() - 1
            local agreements = {}
            PushScratchDeal()
            for i = 0, UI.GetNumCurrentDeals(activePlayerID) - 1 do
                UI.LoadCurrentDeal(activePlayerID, i)
                ScratchDeal:ResetIterator()
                repeat
                    local item = {ScratchDeal:GetNextItem()}
                    local itemType = item[1]
                    if itemType == TradeableItems.TRADE_ITEM_RESEARCH_AGREEMENT and item[#item] ~= activePlayerID then
                        agreements[item[#item]] = item[3] - gameTurn
                        break
                    end
                until not item[1]
            end
            PopScratchDeal()
            local idx = #tips
            for pid = 0, MAX_MAJOR_CIVS-1 do
                if pid ~= activePlayerID then
                    local p = Players[pid]
                    if p and p:IsAlive() and activeTeam:IsHasMet(p:GetTeam()) then
                        if activeTeam:IsHasResearchAgreement(p:GetTeam()) then
                            tips[#tips+1] = "[ICON_BULLET][COLOR_POSITIVE_TEXT]"..p:GetName().."[ENDCOLOR]"
                            if agreements[pid] then
                                append(tips, " "..g_scienceTextColor..Locale.ToUpper(L("TXT_KEY_STR_TURNS", agreements[pid])).."[ENDCOLOR]")
                            end
                        else
                            tips[#tips+1] = "[ICON_BULLET][COLOR_WARNING_TEXT]"..p:GetName().."[ENDCOLOR]"
                        end
                    end
                end
            end
            if #tips > idx then
                insert(tips, idx+1, "")
                insert(tips, idx+2, L"TXT_KEY_DO_RESEARCH_AGREEMENT")
            end
        end

        if IsCiv5BNW_BE and g_isBasicHelp then
            tips[#tips+1] = ""
            tips[#tips+1] = L("TXT_KEY_TP_TECH_CITY_COST", Game.GetNumCitiesTechCostMod() * (100 + (IsCivBE and activePlayer:GetNumCitiesResearchCostDiscount() or 0)) / 100)
        end
    else
        tips[#tips+1] = L"TXT_KEY_TOP_PANEL_SCIENCE_OFF"..": "..L"TXT_KEY_TOP_PANEL_SCIENCE_OFF_TOOLTIP"
    end
    local techID = Players[GetActivePlayer()]:GetCurrentResearch()
    local tech = Technologies[techID]
    ShowProgressToolTip(g_TechProgressToolTipControls, 256, tech and tech.PortraitIndex, tech and tech.IconAtlas,
        concat(tips, "[NEWLINE]"),
        techID ~= -1 and Players[GetActivePlayer()]:GetResearchTurnsLeft(techID, true) or nil,
        techID ~= -1 and Players[GetActivePlayer()]:GetResearchCost(techID) or nil,
        techID ~= -1 and Players[GetActivePlayer()]:GetResearchProgress(techID) or nil,
        g_isScienceEnabled and Players[GetActivePlayer()]:GetScienceTimes100()/100 or 0,
        g_isScienceEnabled and Players[GetActivePlayer()]:GetScienceFromBudgetDeficitTimes100()/100 or 0)
end

local function FaithTooltip()
    if not g_isReligionEnabled then return L"TXT_KEY_TOP_PANEL_RELIGION_OFF_TOOLTIP" end
    local activePlayer = Players[GetActivePlayer()]
    local tips = {}
    AppendAnarchy(tips)
    tips[#tips+1] = L("TXT_KEY_TP_FAITH_ACCUMULATED", activePlayer:GetFaith())
    tips[#tips+1] = ""
    local faithPerTurn = activePlayer:GetTotalFaithPerTurn()
    tips[#tips+1] = "[COLOR_WHITE]"..format("%+g", faithPerTurn).."[ENDCOLOR] "..L"TXT_KEY_YIELD_FAITH".."[ICON_PEACE] "..L"TXT_KEY_GOLD_PERTURN_HEADING4_TITLE"
    insertLocalizedIfNonZero(tips, "TXT_KEY_TP_FAITH_FROM_CITIES", activePlayer:GetFaithPerTurnFromCities())
    insertLocalizedIfNonZero(tips, "TXT_KEY_TP_FAITH_FROM_OUTPOSTS", IsCivBE and activePlayer:GetFaithPerTurnFromOutposts() or 0)
    insertLocalizedIfNonZero(tips, "TXT_KEY_TP_FAITH_FROM_MINORS", activePlayer:GetFaithPerTurnFromMinorCivs())
    insertLocalizedIfNonZero(tips, "TXT_KEY_TP_FAITH_FROM_RELIGION", activePlayer:GetFaithPerTurnFromReligion())

    if IsNewWorldDeluxeScenario then
        tips[#tips+1] = L"TXT_KEY_NEWWORLD_SCENARIO_TP_RELIGION_TOOLTIP"
    else
        if activePlayer:HasCreatedPantheon() then
            if (Game.GetNumReligionsStillToFound() > 0 or activePlayer:HasCreatedReligion())
                and activePlayer:GetCurrentEra() < GameInfoTypes.ERA_INDUSTRIAL then
                insertLocalizedIfNonZero(tips, "TXT_KEY_TP_FAITH_NEXT_PROPHET", activePlayer:GetMinimumFaithNextGreatProphet())
            end
        else
            if activePlayer:CanCreatePantheon(false) then
                insertLocalizedIfNonZero(tips, "TXT_KEY_TP_FAITH_NEXT_PANTHEON", Game.GetMinimumFaithNextPantheon())
            else
                tips[#tips+1] = L"TXT_KEY_TP_FAITH_PANTHEONS_LOCKED"
            end
        end
        tips[#tips+1] = ""
        tips[#tips+1] = L("TXT_KEY_TP_FAITH_RELIGIONS_LEFT", max(Game.GetNumReligionsStillToFound(), 0))
        if activePlayer:GetCurrentEra() >= GameInfoTypes.ERA_INDUSTRIAL then
            tips[#tips+1] = ""
            tips[#tips+1] = L("TXT_KEY_TP_FAITH_NEXT_GREAT_PERSON", activePlayer:GetMinimumFaithNextGreatProphet())
            local num = #tips
            local capital = activePlayer:GetCapitalCity()
            if capital then
                for unit in Units({Special = "SPECIALUNIT_PEOPLE"}) do
                    local id = unit.ID
                    if capital:GetUnitFaithPurchaseCost(id, true) > 0
                        and activePlayer:IsCanPurchaseAnyCity(false, true, id, -1, YieldTypes.YIELD_FAITH)
                        and activePlayer:DoesUnitPassFaithPurchaseCheck(id) then
                        tips[#tips+1] = "[ICON_BULLET]"..unit._Name
                    end
                end
            end
            if num == #tips then
                tips[#tips+1] = "[ICON_BULLET]"..L"TXT_KEY_RO_YR_NO_GREAT_PEOPLE"
            end
        end
    end
    return concat(tips, "[NEWLINE]")
end

local function GoldPerTurnTooltip()
    local activePlayer = Players[GetActivePlayer()]
    local activeTeam = Teams[GetActiveTeam()]
    local tips = {}
    local goldFromDiplo = activePlayer:GetGoldPerTurnFromDiplomacy()
    local goldFromOther = max(0, goldFromDiplo) * 100
    local goldToOther = -min(0, goldFromDiplo)
    local goldFromReligion = IsCiv5notVanilla and activePlayer:GetGoldPerTurnFromReligion() * 100 or 0
    local goldFromCities = activePlayer:GetGoldFromCitiesTimes100()
    local cityConnGold = activePlayer:GetCityConnectionGoldTimes100()
    local playerTraitGold = 0
    local tradeRouteGold = 0
    local goldFromPolicies = 0
    local unitCost = activePlayer:CalculateUnitCost()
    local unitSupply = activePlayer:CalculateUnitSupply()
    local buildingMaint = activePlayer:GetBuildingGoldMaintenance()
    local improvementMaint = activePlayer:GetImprovementGoldMaintenance()
    local vassalMaint = activePlayer.GetVassalGoldMaintenance and activePlayer:GetVassalGoldMaintenance() or 0
    local routeMaint = 0
    local beaconDelta = 0

    if IsCiv5BNW_BE then
        tradeRouteGold = activePlayer:GetGoldFromCitiesMinusTradeRoutesTimes100()
        goldFromCities, tradeRouteGold = tradeRouteGold, goldFromCities - tradeRouteGold
        playerTraitGold = activePlayer:GetGoldPerTurnFromTraits() * 100
        AppendAnarchy(tips)
    end
    local totalWealth = IsCiv5 and activePlayer:GetGold() or activePlayer:GetEnergy()
    tips[#tips+1] = L("TXT_KEY_TP_AVAILABLE_GOLD", totalWealth)
    tips[#tips+1] = ""
    local explicitIncome = goldFromCities + goldFromOther + cityConnGold + goldFromReligion + tradeRouteGold + playerTraitGold
    if not IsCiv5 then
        goldFromPolicies = activePlayer:GetGoldPerTurnFromPolicies()
        explicitIncome = explicitIncome + goldFromPolicies
        routeMaint = activePlayer:GetRouteEnergyMaintenance()
        beaconDelta = activePlayer:GetBeaconEnergyCostPerTurn()
    end
    local totalIncome = IsCiv5 and explicitIncome or activePlayer:CalculateGrossGoldTimes100() + goldToOther * 100
    local totalExpenses = unitCost + unitSupply + buildingMaint + improvementMaint + goldToOther + vassalMaint + routeMaint + beaconDelta
    tips[#tips+1] = format("[COLOR_YELLOW]%+g[ENDCOLOR] ", activePlayer:CalculateGoldRateTimes100()/100)..L(format("TXT_KEY_REPLAY_DATA_%sPERTURN", g_currencyString))
    insertLocalizedIfNonZero(tips, "TXT_KEY_TP_SCIENCE_FROM_BUDGET_DEFICIT", activePlayer:GetScienceFromBudgetDeficitTimes100()/100)

    tips[#tips+1] = "[COLOR_WHITE]"
    tips[#tips+1] = L("TXT_KEY_TP_TOTAL_INCOME", totalIncome / 100)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_CITY_OUTPUT", goldFromCities / 100)
    if IsCiv5BNW_BE then
        insertLocalizedBulletIfNonZero(tips, format("TXT_KEY_TP_%s_FROM_CITY_CONNECTIONS", g_currencyString), cityConnGold / 100)
        insertLocalizedBulletIfNonZero(tips, IsCiv5 and "TXT_KEY_TP_GOLD_FROM_ITR" or "TXT_KEY_TP_ENERGY_FROM_TRADE_ROUTES", tradeRouteGold / 100)
        insertLocalizedBulletIfNonZero(tips, format("TXT_KEY_TP_%s_FROM_TRAITS", g_currencyString), playerTraitGold / 100)
        insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_ENERGY_FROM_POLICIES", goldFromPolicies / 100)
    else
        insertLocalizedBulletIfNonZero(tips, format("TXT_KEY_TP_%s_FROM_TR", g_currencyString), cityConnGold / 100)
    end
    insertLocalizedBulletIfNonZero(tips, format("TXT_KEY_TP_%s_FROM_OTHERS", g_currencyString), goldFromOther / 100)
    insertLocalizedBulletIfNonZero(tips, format("TXT_KEY_TP_%s_FROM_RELIGION", g_currencyString), goldFromReligion / 100)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_YIELD_FROM_UNCATEGORIZED", (totalIncome - explicitIncome) / 100)
    tips[#tips+1] = "[ENDCOLOR]"

    tips[#tips+1] = "[COLOR:255:150:150:255]"..L("TXT_KEY_TP_TOTAL_EXPENSES", totalExpenses)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_UNIT_MAINT", unitCost)
    insertLocalizedBulletIfNonZero(tips, format("TXT_KEY_TP_%s_UNIT_SUPPLY", g_currencyString), unitSupply)
    insertLocalizedBulletIfNonZero(tips, format("TXT_KEY_TP_%s_BUILDING_MAINT", g_currencyString), buildingMaint)
    insertLocalizedBulletIfNonZero(tips, format("TXT_KEY_TP_%s_TILE_MAINT", g_currencyString), improvementMaint)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_ENERGY_ROUTE_MAINT", routeMaint)
    insertLocalizedBulletIfNonZero(tips, format("TXT_KEY_TP_%s_TO_OTHERS", g_currencyString), goldToOther)
    tips[#tips+1] = "[ENDCOLOR]"

    -- Manpower discount
    local manpowerBonus = math.abs(activePlayer:GetGoldHurryCostModifierFromResourceByIndex(GameInfoTypes["RESOURCE_MANPOWER"]))
    if manpowerBonus > 0 then
        tips[#tips+1] = "[NEWLINE]  "..L("TXT_KEY_SP_UI_MANPOWER_DISCOUNT").." "..manpowerBonus.."%"
    end

    -- 可交易黄金
    local idx = #tips
    for pid = 0, MAX_MAJOR_CIVS-1 do
        if pid ~= GetActivePlayer() then
            local p = Players[pid]
            if p and p:IsAlive() and activeTeam:IsHasMet(p:GetTeam()) then
                tips[#tips+1] = "[ICON_BULLET]"..p:GetName()..format("  %i%s(%+i)", ScratchDeal:GetGoldAvailable(pid, -1), g_currencyIcon, p:CalculateGoldRate())
            end
        end
    end
    if #tips > idx then
        insert(tips, idx+1, "")
        insert(tips, idx+2, L"TXT_KEY_EO_RESOURCES_AVAILBLE")
    end
    if g_isBasicHelp then
        tips[#tips+1] = ""
        tips[#tips+1] = L(format("TXT_KEY_TP_%s_EXPLANATION", g_currencyString))
    end
    return concat(tips, "[NEWLINE]")
end

local function GpTooltip()
    local gp = ScanGP(Players[GetActivePlayer()])
    if not gp then return "No Great Person found..." end
    local icon = GreatPeopleIcons and GreatPeopleIcons[gp.Class.Type] or "[ICON_GREAT_PEOPLE]"
    return L("TXT_KEY_PROGRESS_TOWARDS", "[COLOR_YIELD_FOOD]"..Locale.ToUpper(gp.Class._Name).."[ENDCOLOR]")
        .." "..gp.Progress..icon.." / "..gp.Threshold..icon.."[NEWLINE]"
        ..gp.City:GetName()..format(" %+g", gp.Change)..icon.." "..L"TXT_KEY_GOLD_PERTURN_HEADING4_TITLE"
        .." [COLOR_YIELD_FOOD]"..Locale.ToUpper(L("TXT_KEY_STR_TURNS", gp.Turns)).."[ENDCOLOR]"
end

local function HappinessTooltip()
    if not g_isHappinessEnabled then return L"TXT_KEY_TOP_PANEL_HAPPINESS_OFF_TOOLTIP" end
    local activePlayer = Players[GetActivePlayer()]
    local activeTeam = Teams[GetActiveTeam()]
    local tips = {}
    local excess = activePlayer:GetExcessHappiness()
    if not activePlayer:IsEmpireUnhappy() then
        tips[#tips+1] = L("TXT_KEY_TP_TOTAL_HAPPINESS", excess)
    elseif activePlayer:IsEmpireVeryUnhappy() then
        tips[#tips+1] = L("TXT_KEY_TP_TOTAL_UNHAPPINESS", "[ICON_HAPPINESS_4]", -excess)
    else
        tips[#tips+1] = L("TXT_KEY_TP_TOTAL_UNHAPPINESS", "[ICON_HAPPINESS_3]", -excess)
    end
    local policiesHap = activePlayer:GetHappinessFromPolicies()
    local resourcesHap = activePlayer:GetHappinessFromResources()
    local hapFromExtraRes = activePlayer:GetHappinessFromResourceVariety()
    local extraLuxHap = activePlayer:GetExtraHappinessPerLuxury()
    local buildingHap = activePlayer:GetHappinessFromBuildings()
    local cityHap = 0
    local garrisonHap = 0
    local minorHap = 0
    local religionHap = 0
    if IsCiv5notVanilla then
        cityHap = activePlayer:GetHappinessFromCities()
        minorHap = activePlayer:GetHappinessFromMinorCivs()
        religionHap = activePlayer:GetHappinessFromReligion()
    else
        garrisonHap = activePlayer:GetHappinessFromGarrisonedUnits()
        for pid = MAX_MAJOR_CIVS, MAX_CIV_PLAYERS_minus1 do
            minorHap = minorHap + activePlayer:GetHappinessFromMinor(pid)
        end
    end
    local tradeHap = activePlayer:GetHappinessFromTradeRoutes()
    local wonderHap = activePlayer:GetHappinessFromNaturalWonders()
    local extraPerCity = activePlayer:GetExtraHappinessPerCity() * activePlayer:GetNumCities()
    local leagueHap = IsCiv5BNW_BE and activePlayer:GetHappinessFromLeagues() or 0
    local totalHap = activePlayer:GetHappiness()
    local handicapHap = Game.GetHappinessFromHandicap()

    if activePlayer:IsEmpireVeryUnhappy() then
        if activePlayer:IsEmpireSuperUnhappy() then
            tips[#tips+1] = "[COLOR:255:60:60:255]"..L"TXT_KEY_TP_EMPIRE_SUPER_UNHAPPY".."[ENDCOLOR]"
        else
            tips[#tips+1] = "[COLOR:255:60:60:255]"..L"TXT_KEY_TP_EMPIRE_VERY_UNHAPPY".."[ENDCOLOR]"
        end
    elseif activePlayer:IsEmpireUnhappy() then
        tips[#tips+1] = "[COLOR:255:60:60:255]"..L"TXT_KEY_TP_EMPIRE_UNHAPPY".."[ENDCOLOR]"
    end
    if g_isBasicHelp then
        tips[#tips+1] = L"TXT_KEY_TP_HAPPINESS_EXPLANATION"
        tips[#tips+1] = ""
    end

    -- 资源详情
    local baseResHap = 0
    local numLux = 0
    local availRes = ""
    local missRes = ""
    for resource in Resources({ResourceUsage = RESOURCEUSAGE_LUXURY}) do
        local avail = activePlayer:GetNumResourceAvailable(resource.ID, true)
        if avail > 0 then
            local hap = IsCiv5notVanilla and activePlayer:GetHappinessFromLuxury(resource.ID) or resource.Happiness
            if hap > 0 then
                availRes = availRes.." [COLOR_POSITIVE_TEXT]"..avail.."[ENDCOLOR]"..resource.IconString
                numLux = numLux + 1
                baseResHap = baseResHap + hap
            end
        elseif avail == 0 then
            missRes = missRes..resource.IconString
        else
            missRes = missRes.." [COLOR_WARNING_TEXT]"..avail.."[ENDCOLOR]"..resource.IconString
        end
    end

    -- 不满
    local unhapPuppet = activePlayer:GetUnhappinessFromPuppetCityPopulation()
    local unhapSpecialists = activePlayer:GetUnhappinessFromCitySpecialists()
    local unhapPop = activePlayer:GetUnhappinessFromCityPopulation() - unhapSpecialists - unhapPuppet
    tips[#tips+1] = "[COLOR:255:150:150:255]"..L("TXT_KEY_TP_UNHAPPINESS_TOTAL", activePlayer:GetUnhappiness())
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_UNHAPPINESS_CITY_COUNT", activePlayer:GetUnhappinessFromCityCount() / 100)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_UNHAPPINESS_CAPTURED_CITY_COUNT", activePlayer:GetUnhappinessFromCapturedCityCount() / 100)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_UNHAPPINESS_POPULATION", unhapPop / 100)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_UNHAPPINESS_PUPPET_CITIES", unhapPuppet / 100)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_UNHAPPINESS_SPECIALISTS", unhapSpecialists / 100)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_UNHAPPINESS_OCCUPIED_POPULATION", activePlayer:GetUnhappinessFromOccupiedCities() / 100)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_UNHAPPINESS_UNITS", activePlayer:GetUnhappinessFromUnits() / 100)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_HAPPINESS_POLICIES", min(policiesHap, 0))
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_UNHAPPINESS_PUBLIC_OPINION", IsCiv5BNW_BE and activePlayer:GetUnhappinessFromPublicOpinion() or 0)

    -- 快乐来源
    tips[#tips+1] = "[ENDCOLOR][COLOR:150:255:150:255]"
    tips[#tips+1] = L("TXT_KEY_TP_HAPPINESS_SOURCES", totalHap)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_HAPPINESS_DIFFICULTY_LEVEL", handicapHap)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_HAPPINESS_POLICIES", max(policiesHap, 0))
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_HAPPINESS_BUILDINGS", buildingHap)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_HAPPINESS_CITIES", cityHap)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_HAPPINESS_GARRISONED_UNITS", garrisonHap)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_HAPPINESS_CONNECTED_CITIES", tradeHap)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_HAPPINESS_STATE_RELIGION", religionHap)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_HAPPINESS_NATURAL_WONDERS", wonderHap)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_HAPPINESS_CITY_COUNT", extraPerCity)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_HAPPINESS_CITY_STATE_FRIENDSHIP", minorHap)
    insertLocalizedBulletIfNonZero(tips, "TXT_KEY_TP_HAPPINESS_LEAGUES", leagueHap)
    insertLocalizedBulletIfNonZero(tips, "          ", "TXT_KEY_TP_HAPPINESS_RESOURCE_VARIETY", hapFromExtraRes)
    insertLocalizedBulletIfNonZero(tips, "          ", "TXT_KEY_TP_HAPPINESS_EXTRA_PER_RESOURCE", extraLuxHap, numLux)
    local miscHap = resourcesHap - baseResHap - hapFromExtraRes - (extraLuxHap * numLux)
    insertLocalizedBulletIfNonZero(tips, "          ", "TXT_KEY_TP_HAPPINESS_OTHER_SOURCES", miscHap)

    -- 消费品
    local consumerUnhap = activePlayer:GetUnHappinessModFromResourceByIndex(GameInfoTypes["RESOURCE_CONSUMER"])
    if consumerUnhap < 0 then
        tips[#tips+1] = "[NEWLINE][NEWLINE]"..L("TXT_KEY_SP_UI_HAPPINESS_CONSUMERGOODS_BONUS").." "..(-consumerUnhap).."%"
        if activePlayer:HasPolicy(Policies["POLICY_MERCANTILISM"].ID) then
            tips[#tips+1] = "[NEWLINE]"..L("TXT_KEY_POLICY_MERCANTILISM_CONSUMERGOODS_BONUS")
        end
    elseif consumerUnhap > 0 then
        tips[#tips+1] = "[NEWLINE][NEWLINE]"..L("TXT_KEY_SP_UI_HAPPINESS_CONSUMERGOODS_PENALTY").." "..consumerUnhap.."%"
    end

    -- 本地奢侈资源
    if #availRes > 0 then
        tips[#tips+1] = "[ICON_BULLET]"..L("TXT_KEY_TP_HAPPINESS_FROM_RESOURCES", resourcesHap)
        tips[#tips+1] = "  "..availRes
    end
    tips[#tips+1] = "[ENDCOLOR]"

    -- 城市内资源显示
    local locStr = ""
    for resource in Resources({ResourceUsage = RESOURCEUSAGE_LUXURY}) do
        local qty = activePlayer:GetNumResourceTotal(resource.ID, false) + activePlayer:GetResourceExport(resource.ID)
        if qty > 0 then locStr = locStr.." "..ColorizeAbs(qty)..resource.IconString end
    end
    tips[#tips+1] = L("TXT_KEY_EO_LOCAL_RESOURCES")..(#locStr>0 and locStr or (" : "..L"TXT_KEY_TP_NO_RESOURCES_DISCOVERED"))

    for city in activePlayer:Cities() do
        local conn = {}
        local unconn = {}
        for plot in CityPlots(city) do
            local resID = plot:GetResourceType(activeTeam:GetID())
            local num = plot:GetNumResource()
            if num > 0 and GetResourceUsageType(resID) == RESOURCEUSAGE_LUXURY then
                if plot:IsCity() or (not plot:IsImprovementPillaged() and plot:IsResourceConnectedByImprovement(plot:GetImprovementType())) then
                    conn[resID] = (conn[resID] or 0) + num
                else
                    unconn[resID] = (unconn[resID] or 0) + num
                end
            end
        end
        local tip = ""
        for resource in Resources({ResourceUsage = RESOURCEUSAGE_LUXURY}) do
            if (conn[resource.ID] or 0) > 0 then tip = tip.." "..ColorizeAbs(conn[resource.ID])..resource.IconString end
            if (unconn[resource.ID] or 0) > 0 then tip = tip.." "..ColorizeAbs(-unconn[resource.ID])..resource.IconString end
        end
        if #tip > 0 then tips[#tips+1] = "[ICON_BULLET]"..city:GetName()..tip end
    end

    -- 进出口略（保持简单，可保留基本提示）
    return concat(tips, "[NEWLINE]")
end

local function GoldenAgeTooltip()
    if not g_isHappinessEnabled then return L"TXT_KEY_TOP_PANEL_HAPPINESS_OFF_TOOLTIP" end
    local activePlayer = Players[GetActivePlayer()]
    local tips = {}
    local iHap = activePlayer:GetExcessHappiness()
    local gaTurns = activePlayer:GetGoldenAgeTurns()
    local progress = activePlayer:GetGoldenAgeProgressMeter()
    local threshold = activePlayer:GetGoldenAgeProgressThreshold()
    local gaFromReligion = activePlayer:GetGoldenAgePointPerTurnFromReligion()
    local gaFromTraits = activePlayer:GetGoldenAgePointPerTurnFromTraits()
    local gaFromCities = activePlayer:GetGoldenAgePointPerTurnFromCitys()

    if gaTurns > 0 then
        local mult = GameDefines["GOLDEN_AGE_POINT_MULTIPLE_IN_GA"]
        iHap = math.floor(iHap * mult / 100)
        gaFromReligion = math.floor(gaFromReligion * mult / 100)
        gaFromTraits = math.floor(gaFromTraits * mult / 100)
        gaFromCities = math.floor(gaFromCities * mult / 100)
        tips[#tips+1] = L("TXT_KEY_TP_GOLDEN_AGE_NOW", gaTurns)
        tips[#tips+1] = "[NEWLINE]"..L("TXT_KEY_TP_GOLDEN_AGE_NOW_EXTRA", mult).."[NEWLINE]"
    end
    tips[#tips+1] = L("TXT_KEY_TP_GOLDEN_AGE_PROGRESS", progress, threshold)
    tips[#tips+1] = "[NEWLINE]"
    if iHap >= 0 then
        tips[#tips+1] = L("TXT_KEY_TP_GOLDEN_AGE_ADDITION", iHap)
    else
        tips[#tips+1] = "[COLOR_WARNING_TEXT]"..L("TXT_KEY_TP_GOLDEN_AGE_LOSS", -iHap).."[ENDCOLOR]"
    end
    if gaFromReligion > 0 then tips[#tips+1] = "[NEWLINE]"..L("TXT_KEY_TP_GOLDEN_AGE_ADDITION_RELIGION", gaFromReligion) end
    if gaFromTraits > 0 then tips[#tips+1] = "[NEWLINE]"..L("TXT_KEY_TP_GOLDEN_AGE_ADDITION_TRAIT", gaFromTraits) end
    if gaFromCities > 0 then tips[#tips+1] = "[NEWLINE]"..L("TXT_KEY_TP_GOLDEN_AGE_ADDITION_CITY", gaFromCities) end

    if g_isBasicHelp then
        tips[#tips+1] = "[NEWLINE]"
        if activePlayer:IsGoldenAgeCultureBonusDisabled() then
            tips[#tips+1] = L"TXT_KEY_TP_GOLDEN_AGE_EFFECT_NO_CULTURE"
        elseif gaTurns > 0 and GameInfo.Leader_Traits({LeaderType = Leaders[activePlayer:GetLeaderType()].Type, TraitType = "TRAIT_ART_OF_WAR"})() and
            (GameInfo.Traits["TRAIT_ART_OF_WAR"].PrereqPolicy == nil or (GameInfo.Traits["TRAIT_ART_OF_WAR"].PrereqPolicy and activePlayer:HasPolicy(GameInfoTypes[GameInfo.Traits["TRAIT_ART_OF_WAR"].PrereqPolicy]))) then
            tips[#tips+1] = L"TXT_KEY_SP_UA_CHINA_GOLDENAGE_EFFECTS"
        else
            tips[#tips+1] = L"TXT_KEY_TP_GOLDEN_AGE_EFFECT"
        end
        if IsCiv5BNW and gaTurns > 0 and activePlayer:GetGoldenAgeTourismModifier() > 0 then
            tips[#tips+1] = "[NEWLINE]"..L"TXT_KEY_TP_CARNIVAL_EFFECT"
        end
    end
    return concat(tips, "[NEWLINE]")
end

local function CultureTooltip()
    if not g_isPoliciesEnabled then return L"TXT_KEY_TOP_PANEL_POLICIES_OFF_TOOLTIP" end
    local activePlayer = Players[GetActivePlayer()]
    local tips = {}
    local progress, perTurn, free, fromCities, fromHap, fromTraits
    if IsCiv5 then
        progress = activePlayer:GetJONSCulture()
        perTurn = activePlayer:GetTotalJONSCulturePerTurn()
        free = activePlayer:GetJONSCulturePerTurnForFree()
        fromCities = activePlayer:GetJONSCulturePerTurnFromCities()
        fromHap = activePlayer:GetJONSCulturePerTurnFromExcessHappiness()
        fromTraits = IsCiv5BNW and activePlayer:GetJONSCulturePerTurnFromTraits() or 0
    else
        progress = activePlayer:GetCulture()
        perTurn = activePlayer:GetTotalCulturePerTurn()
        free = activePlayer:GetCulturePerTurnForFree()
        fromCities = activePlayer:GetCulturePerTurnFromCities()
        fromHap = activePlayer:GetCulturePerTurnFromExcessHealth()
        fromTraits = activePlayer:GetCulturePerTurnFromTraits()
    end
    local threshold = activePlayer:GetNextPolicyCost()
    local turns = 1
    if threshold > progress and perTurn > 0 then
        turns = ceil((threshold - progress) / perTurn)
    elseif threshold > progress then
        turns = "?"
    end
    AppendAnarchy(tips)
    tips[#tips+1] = L("TXT_KEY_PROGRESS_TOWARDS", "[COLOR_MAGENTA]"..Locale.ToUpper"TXT_KEY_ADVISOR_SCREEN_SOCIAL_POLICY_DISPLAY".."[ENDCOLOR]").." "..progress.."[ICON_CULTURE]/ "..threshold.."[ICON_CULTURE]"
    if perTurn > 0 then
        local overflow = perTurn * turns + progress - threshold
        local line = "[COLOR_MAGENTA]"..Locale.ToUpper(L("TXT_KEY_STR_TURNS", turns)).."[ENDCOLOR]"..format(" %+g[ICON_CULTURE]", overflow)
        if turns > 1 then
            line = L("TXT_KEY_STR_TURNS", turns-1)..format(" %+g[ICON_CULTURE]  ", overflow - perTurn)..line
        end
        tips[#tips+1] = line
    end
    tips[#tips+1] = ""
    tips[#tips+1] = "[COLOR_MAGENTA]"..format("%+g", perTurn).."[ENDCOLOR] "..L"TXT_KEY_REPLAY_DATA_CULTUREPERTURN"
    insertLocalizedIfNonZero(tips, "TXT_KEY_TP_CULTURE_FOR_FREE", free)
    insertLocalizedIfNonZero(tips, "TXT_KEY_TP_CULTURE_FROM_CITIES", fromCities)
    insertLocalizedIfNonZero(tips, "TXT_KEY_TP_CULTURE_FROM_"..g_happinessString, fromHap)
    insertLocalizedIfNonZero(tips, "TXT_KEY_TP_CULTURE_FROM_TRAITS", fromTraits)
    if IsCiv5 then
        local fromMinors = activePlayer:GetJONSCulturePerTurnFromMinorCivs()
        insertLocalizedIfNonZero(tips, "TXT_KEY_TP_CULTURE_FROM_MINORS", fromMinors)
        local fromReligion = IsCiv5notVanilla and activePlayer:GetCulturePerTurnFromReligion() or 0
        insertLocalizedIfNonZero(tips, "TXT_KEY_TP_CULTURE_FROM_RELIGION", fromReligion)
        local fromBonus = 0
        if IsCiv5BNW then
            fromBonus = activePlayer:GetCulturePerTurnFromBonusTurns()
            insertLocalizedIfNonZero(tips, "TXT_KEY_TP_CULTURE_FROM_BONUS_TURNS", fromBonus, activePlayer:GetCultureBonusTurns())
        end
        local fromVassals = activePlayer.GetJONSCulturePerTurnFromVassals and activePlayer:GetJONSCulturePerTurnFromVassals() or 0
        insertLocalizedIfNonZero(tips, "TXT_KEY_TP_CULTURE_VASSALS", fromVassals)
        local fromGA = perTurn - free - fromCities - fromHap - fromMinors - fromReligion - fromTraits - fromBonus - fromVassals
        insertLocalizedIfNonZero(tips, "TXT_KEY_TP_CULTURE_FROM_GOLDEN_AGE", fromGA)
    else
        local other = perTurn - free - fromCities - fromHap - fromTraits
        insertLocalizedIfNonZero(tips, "TXT_KEY_TP_YIELD_FROM_UNCATEGORIZED", other)
    end
    if g_isBasicHelp then
        tips[#tips+1] = ""
        tips[#tips+1] = L("TXT_KEY_TP_CULTURE_CITY_COST", Game.GetNumCitiesPolicyCostMod() * (100 + (IsCivBE and activePlayer:GetNumCitiesPolicyCostDiscount() or 0)) / 100)
    end
    return concat(tips, "[NEWLINE]")
end

local function TourismTooltip()
    local activePlayer = Players[GetActivePlayer()]
    local totalGW = activePlayer:GetNumGreatWorks()
    local totalSlots = activePlayer:GetNumGreatWorkSlots()
    local tip = L("TXT_KEY_TOP_PANEL_TOURISM_TOOLTIP_1", totalGW).."[NEWLINE]"..L("TXT_KEY_TOP_PANEL_TOURISM_TOOLTIP_2", totalSlots - totalGW)
    local cultVictory = Victories.VICTORY_CULTURAL
    if cultVictory and PreGame.IsVictory(cultVictory.ID) then
        tip = tip.."[NEWLINE][NEWLINE]"..L("TXT_KEY_TOP_PANEL_TOURISM_TOOLTIP_3", L("TXT_KEY_CO_VICTORY_INFLUENTIAL_OF", activePlayer:GetNumCivsInfluentialOn(), activePlayer:GetNumCivsToBeInfluentialOn()))
    end
    local hapBonus = activePlayer:GetYieldModifierFromHappiness(GameInfoTypes["YIELD_TOURISM"])
    if hapBonus ~= 0 then
        tip = tip.."[NEWLINE][NEWLINE]"..L("TXT_KEY_SP_UI_TOURISMBOOST_BY_HAPPINESS").." "..hapBonus.."%"
    end
    local gwBonus = activePlayer:GetYieldModifierFromNumGreakWork(GameInfoTypes["YIELD_TOURISM"])
    if gwBonus ~= 0 then
        tip = tip.."[NEWLINE]"..L("TXT_KEY_SP_UI_TOURISMBOOST_BY_NUM_GREAT_WORK", gwBonus)
    end
    local artBonus = activePlayer:GetYieldModifierFromNumArtifact(GameInfoTypes["YIELD_TOURISM"])
    if artBonus ~= 0 then
        tip = tip.."[NEWLINE]"..L("TXT_KEY_SP_UI_TOURISMBOOST_BY_NUM_ARTIFACT", artBonus)
    end
    tip = tip..activePlayer:GetInternationalTourismTooltip()
    return tip
end

local function TradeRoutesTooltip()
    local activePlayer = Players[GetActivePlayer()]
    local tip = ""
    for _, domain in ipairs({DomainTypes.DOMAIN_LAND, DomainTypes.DOMAIN_SEA}) do
        local avail = activePlayer:GetNumAvailableTradeUnits(domain)
        if avail > 0 then
            local unitType = activePlayer:GetTradeUnitType(domain)
            tip = tip..L("TXT_KEY_TOP_PANEL_INTERNATIONAL_TRADE_ROUTES_TT_UNASSIGNED", avail, Units[unitType]._Name).."[NEWLINE]"
        end
    end
    local used = activePlayer:GetNumInternationalTradeRoutesUsed()
    local total = activePlayer:GetNumInternationalTradeRoutesAvailable()
    if #tip > 0 then tip = tip.."[NEWLINE]" end
    tip = tip..L("TXT_KEY_TOP_PANEL_INTERNATIONAL_TRADE_ROUTES_TT", used, total)
    local yourRoutes = activePlayer:GetTradeYourRoutesTTString()
    if #yourRoutes > 0 then
        tip = tip.."[NEWLINE][NEWLINE]"..L"TXT_KEY_TOP_PANEL_ITR_ESTABLISHED_BY_PLAYER_TT".."[NEWLINE]"..yourRoutes
    end
    local toYou = activePlayer:GetTradeToYouRoutesTTString()
    if #toYou > 0 then
        tip = tip.."[NEWLINE][NEWLINE]"..L"TXT_KEY_TOP_PANEL_ITR_ESTABLISHED_BY_OTHER_TT".."[NEWLINE]"..toYou
    end
    return tip
end

local function HealthTooltip() return L"TXT_KEY_TP_HEALTH_EXPLANATION" end

local TopPanelTooltips = {
    SciencePerTurn = ScienceTooltip,
    TechIcon = ScienceTooltip,
    GoldPerTurn = GoldPerTurnTooltip,
    GpIcon = GpTooltip,
    HappinessString = HappinessTooltip,
    GoldenAgeString = GoldenAgeTooltip,
    CultureString = CultureTooltip,
    FaithString = FaithTooltip,
    FaithIcon = FaithTooltip,
    TourismString = TourismTooltip,
    InternationalTradeRoutes = TradeRoutesTooltip,
    HealthString = HealthTooltip,
}
LuaEvents.TopPanelTooltips.Add(function(control)
    local tip = TooltipSelect(TopPanelTooltips, control)
    if tip then ShowTextToolTip(tip) end
end)

print("EUI tooltip server loaded.")