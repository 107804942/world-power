-- ============================================================
-- ComplexFunctions.lua (精简优化版)
-- 世界强权模组 - 复合功能脚本
-- ============================================================

include("Rog_SaveUtils.lua")
include("PlotIterators.lua")
include("FunctionUtilities.lua")
include("FLuaVector.lua")
include("UtilityFunctions")

MY_MOD_NAME = "世界强权"

if not Game.IsWPActive() then return end

-- ============================================================
-- 工具函数
-- ============================================================
local function GetActivePlayer() return Players[Game:GetActivePlayer()] end
local function HasPromo(unit, key) return unit:IsHasPromotion(GameInfo.UnitPromotions[key].ID) end
local function HasPromoID(unit, id) return unit:IsHasPromotion(id) end

-- 重置铁浮屠冲锋数据
local IronPagodaChargeArray, IronPagodaChargeArrayDirection = {}, {}
local function ResetIronPagodaCharge()
    IronPagodaChargeArray = {}
    IronPagodaChargeArrayDirection = {}
    for i = 0, 5 do IronPagodaChargeArrayDirection[i] = {} end
end
ResetIronPagodaCharge()

local SpaceBattleCruiserSkill = 0
local lButtonDown, rButtonDown = false, false

-- ============================================================
-- 单位面板按钮
-- ============================================================

-- 浮石章鱼：创造瘟疫
LuaEvents.UnitPanelActionAddin({
    Name = "TXT_KEY_NAME_CREAT_PLAGUE",
    Title = "TXT_KEY_TITLE_CREAT_PLAGUE",
    OrderPriority = 300,
    IconAtlas = "SP_UNIT_ACTION_ATLAS2",
    PortraitIndex = 25,
    ToolTip = function(_, unit)
        return Locale.ConvertTextKey(
            CheckPlagueMissionButtonValidity(unit) and "TXT_KEY_COND_CREAT_PLAGUE" or "TXT_KEY_COND_CREAT_PLAGUE_2")
    end,
    Condition = function(_, unit)
        return unit:GetMoves() > 0 and HasPromo(unit, "PROMOTION_HOVER_WORM")
    end,
    Disabled = function(_, unit) return not CheckPlagueMissionButtonValidity(unit) end,
    Action = function(_, unit, eClick)
        if eClick == Mouse.eRClick then return end
        local city = unit:GetPlot():GetPlotCity() or unit:GetPlot():GetWorkingCity()
        if not city then return end
        unit:SetMoves(0)
        local zombie = Players[63]:InitUnit(GameInfoTypes.UNIT_ZOMBIE, city:GetX() + 1, city:GetY())
        zombie:JumpToNearestValidPlot()
    end
})

-- 幽灵：机械镇压
LuaEvents.UnitPanelActionAddin({
    Name = "Mech Control",
    Title = "TXT_KEY_SP_BTNNOTE_UNIT_RIOT_CONTROL_SHORT2",
    OrderPriority = 200,
    IconAtlas = "SP_UNIT_ACTION_ATLAS2",
    PortraitIndex = 25,
    ToolTip = "TXT_KEY_SP_BTNNOTE_UNIT_RIOT_CONTROL2",
    Condition = function(_, unit)
        return unit:CanMove() and unit:GetUnitType() == GameInfoTypes.UNIT_MECH
            and HasPromo(unit, "PROMOTION_GHOST_POWER")
    end,
    Disabled = function(_, unit)
        local plot = unit:GetPlot()
        if not plot:IsCity() then return true end
        local city = plot:GetPlotCity()
        return not city or city:GetOwner() ~= unit:GetOwner() or not city:IsResistance()
    end,
    Action = function(_, unit)
        local city = unit:GetPlot():GetPlotCity()
        if not city then return end
        city:ChangeResistanceTurns(-city:GetResistanceTurns())
        city:SetPopulation(math.ceil(city:GetPopulation() / 2), true)
        Events.AudioPlay2DSound("AS2D_MECH_POWER")
        unit:SetMoves(0)
    end
})

-- 太空战巡：主炮
local function DisplayCruiserHitArrow()
    local unit = UI.GetHeadSelectedUnit()
    if unit and unit:GetUnitType() == GameInfoTypes.UNIT_SPACESHIP then attacker = unit end
    if not attacker or SpaceBattleCruiserSkill ~= 1 then return end
    Events.ClearHexHighlights()
    local plot = Map.GetPlot(UI.GetMouseOverHex())
    for iPlot in PlotAreaSpiralIterator(plot, 1, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
        Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(iPlot:GetX(), iPlot:GetY())), true, Vector4(0, 1, 1, 1))
        Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(plot:GetX(), plot:GetY())), true, Vector4(0, 1, 1, 1))
    end
end
Events.SerialEventMouseOverHex.Add(DisplayCruiserHitArrow)

LuaEvents.UnitPanelActionAddin({
    Name = "TXT_KEY_NAME_SPACE_BATTLECRUISER",
    Title = "TXT_KEY_TITLE_SPACE_BATTLECRUISER",
    OrderPriority = 300,
    IconAtlas = "SP_UNIT_ACTION_ATLAS2",
    PortraitIndex = 7,
    ToolTip = function(_, unit)
        return Locale.ConvertTextKey(HasPromo(unit, "PROMOTION_SPACE_BATTLECRUISER_MANA_COLD_DOWN")
            and "TXT_KEY_COND_SPACE_BATTLECRUISER_2" or "TXT_KEY_COND_SPACE_BATTLECRUISER")
    end,
    Condition = function(_, unit)
        return unit:GetMoves() > 0 and unit:GetUnitType() == GameInfoTypes.UNIT_SPACESHIP
    end,
    Disabled = function(_, unit) return HasPromo(unit, "PROMOTION_SPACE_BATTLECRUISER_MANA_COLD_DOWN") end,
    Action = function(_, _, eClick)
        if eClick == Mouse.eRClick then
            Events.ClearHexHighlights()
            Events.SerialEventMouseOverHex.Remove(DisplayCruiserHitArrow)
            return
        end
        SpaceBattleCruiserSkill = 1
        Events.SerialEventMouseOverHex.Add(DisplayCruiserHitArrow)
    end
})

-- 太空战巡：核弹
local function ShowNukeArrow(PlotX, PlotY)
    local unit = UI.GetHeadSelectedUnit()
    if unit and unit:GetUnitType() == GameInfoTypes.UNIT_SPACESHIP then attacker = unit end
    if not attacker then return end
    if Map.PlotDistance(attacker:GetX(), attacker:GetY(), PlotX, PlotY) <= 30 then
        Events.SpawnArrowEvent(attacker:GetX(), attacker:GetY(), PlotX, PlotY)
    else
        Events.RemoveAllArrowsEvent()
    end
end

local function ShowNukeHitPlot()
    local unit = UI.GetHeadSelectedUnit()
    local plot = Map.GetPlot(UI.GetMouseOverHex())
    if unit and unit:GetUnitType() == GameInfoTypes.UNIT_SPACESHIP then Cruiser = unit end
    if not Cruiser or SpaceBattleCruiserSkill ~= 2 then return end
    Events.ClearHexHighlights()
    if Map.PlotDistance(Cruiser:GetX(), Cruiser:GetY(), plot:GetX(), plot:GetY()) <= 30 then
        Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(plot:GetX(), plot:GetY())), true, Vector4(0.7, 0, 0, 1), "ValidFireTargetBorder")
    end
end

LuaEvents.UnitPanelActionAddin({
    Name = "TXT_KEY_NAME_SPACE_BATTLECRUISER_NUKE",
    Title = "TXT_KEY_TITLE_SPACE_BATTLECRUISER_NUKE",
    OrderPriority = 300,
    IconAtlas = "UNIT_ACTION_ATLAS",
    PortraitIndex = 17,
    ToolTip = function(_, unit)
        return Locale.ConvertTextKey(HasPromo(unit, "PROMOTION_SPACE_BATTLECRUISER_NUKE_COLD_DOWN")
            and "TXT_KEY_COND_SPACE_BATTLECRUISER_CANT_NUKE" or "TXT_KEY_COND_SPACE_BATTLECRUISER_NUKE")
    end,
    Condition = function(_, unit)
        return unit:GetMoves() > 0 and unit:GetUnitType() == GameInfoTypes.UNIT_SPACESHIP
    end,
    Disabled = function(_, unit) return HasPromo(unit, "PROMOTION_SPACE_BATTLECRUISER_NUKE_COLD_DOWN") end,
    Action = function(_, _, eClick)
        if eClick == Mouse.eRClick then
            Events.RemoveAllArrowsEvent()
            Events.SerialEventMouseOverHex.Remove(ShowNukeArrow)
            Events.SerialEventMouseOverHex.Remove(ShowNukeHitPlot)
            return
        end
        SpaceBattleCruiserSkill = 2
        Events.SerialEventMouseOverHex.Add(ShowNukeArrow)
        Events.SerialEventMouseOverHex.Add(ShowNukeHitPlot)
    end
})

-- 铁浮屠：冲锋
LuaEvents.UnitPanelActionAddin({
    Name = "IRON PAGODA",
    Title = "TXT_KEY_TITLE_IRON_BUDDHA_CHARGE",
    OrderPriority = 200,
    IconAtlas = "ROBOT_ICON_ATLAS4",
    PortraitIndex = 59,
    ToolTip = function() return Locale.ConvertTextKey("TXT_KEY_COND_IRON_BUDDHA_CHARGE") end,
    Condition = function(_, unit)
        return unit:GetMoves() > 0 and unit:CanMove()
            and HasPromoID(unit, GameInfoTypes.PROMOTION_ANTI_ANTI_MOUNTED_BONUS)
            and unit:GetCurrHitPoints() > 99
    end,
    Disabled = function() return false end,
    Action = function(_, unit, eClick)
        if eClick == Mouse.eRClick then return end
        for i = 0, 5 do
            local range, x, y = 5, unit:GetX(), unit:GetY()
            while range > 0 do
                local plot = Map.PlotDirection(x, y, i)
                if plot and not plot:IsMountain() and not plot:IsWater() and not plot:IsCity() then
                    Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(plot:GetX(), plot:GetY())), true, Vector4(0.847, 0.611, 0.192, 1))
                    range = range - 1
                    x, y = plot:GetX(), plot:GetY()
                    table.insert(IronPagodaChargeArray, GetPlotKey(plot))
                    table.insert(IronPagodaChargeArrayDirection[i], GetPlotKey(plot))
                else
                    break
                end
            end
        end
        SpaceBattleCruiserSkill = 3
    end
})

-- 替换 SP 按钮：Air EVAC / Global Strike / Moral Boost
local function ReplaceSPButton(button, name)
    button.Name = name
    LuaEvents.UnitPanelActionRemove(button)
    LuaEvents.UnitPanelActionAddin(button)
end

ReplaceSPButton({
    Name = "Air EVAC", Title = "TXT_KEY_SP_BTNNOTE_UNIT_AIREVAC_SHORT", OrderPriority = 200,
    IconAtlas = "SP_UNIT_ACTION_ATLAS", PortraitIndex = 11, ToolTip = "TXT_KEY_SP_BTNNOTE_UNIT_AIREVAC",
    Condition = function(_, unit)
        return unit:CanMove()
            and (unit:GetUnitType() == GameInfoTypes.UNIT_TASKFORCE_141 or unit:GetUnitType() == GameInfoTypes.UNIT_GHOST)
            and Players[unit:GetOwner()]:GetCapitalCity() ~= nil
    end,
    Disabled = function() return false end,
    Action = function(_, unit)
        local city = Players[unit:GetOwner()]:GetCapitalCity()
        unit:SetXY(city:GetX(), city:GetY())
        unit:JumpToNearestValidPlot()
        unit:SetMoves(0)
    end
}, "Air EVAC")

ReplaceSPButton({
    Name = "Global Strike", Title = "TXT_KEY_SP_BTNNOTE_GLOBAL_STRIKE_SHORT", OrderPriority = 200,
    IconAtlas = "SP_UNIT_ACTION_ATLAS", PortraitIndex = 10, ToolTip = "TXT_KEY_SP_BTNNOTE_GLOBAL_STRIKE",
    Condition = function(_, unit) return unit:CanMove() and unit:GetUnitType() == GameInfoTypes.UNIT_ORBITAL_STRIKE end,
    Action = function(_, unit)
        unit:SetMoves(0)
        for _, player in pairs(Players) do
            if player and player:IsAlive() and player:GetNumCities() >= 1 and not player:IsHuman() and PlayerAtWarWithHuman(player) then
                for city in player:Cities() do
                    city:ChangeDamage(250)
                    Events.AudioPlay2DSound("AS2D_SATELLITE_CANNON")
                    Events.GameplayAlertMessage(Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_SATELLITE_CANNON"))
                end
            end
        end
    end
}, "Global Strike")

ReplaceSPButton({
    Name = "Moral Boost", Title = "TXT_KEY_SP_BTNNOTE_UNIT_MORAL_BOOST_SHORT", OrderPriority = 200,
    IconAtlas = "SP_UNIT_ACTION_ATLAS", PortraitIndex = 22, ToolTip = "TXT_KEY_SP_BTNNOTE_UNIT_MORAL_BOOST",
    Condition = function(_, unit)
        return unit:CanMove() and (
            unit:GetUnitClassType() == GameInfo.UnitClasses.UNITCLASS_GREAT_GENERAL.ID or
            unit:GetUnitClassType() == GameInfo.UnitClasses.UNITCLASS_GREAT_ADMIRAL.ID or
            unit:GetUnitType() == GameInfoTypes.UNIT_HUN_SHAMAN)
    end,
    Disabled = function(_, unit) return unit:GetPlot() == nil or unit:GetPlot():GetNumUnits() <= 1 end,
    Action = function(_, unit)
        if unit:GetPlot() == nil or unit:GetPlot():GetNumUnits() <= 1 then return end
        unit:ClearSamePlotPromotions()
        unit:SetMoves(0)
    end
}, "Moral Boost")

-- ============================================================
-- 输入处理器（统一处理太空战巡 / 铁浮屠的点击事件）
-- ============================================================
local function HandleCruiserMainGun(pPlot, pUnit, pPlayer)
    local num = 0
    local function KillUnitsOnPlot(plot)
        for i = 0, plot:GetNumUnits() - 1 do
            local u = plot:GetUnit(i)
            if u:IsCombatUnit() and Teams[pPlayer:GetTeam()]:IsAtWar(Players[u:GetOwner()]:GetTeam()) then
                u:Kill(true, -1)
                num = num + 1
            end
        end
    end
    local function DestroyNonCapital(plot)
        if plot:IsCity() and not plot:GetPlotCity():IsOriginalCapital() then
            local city = plot:GetPlotCity()
            local hexpos = ToHexFromGrid(Vector2(plot:GetX(), plot:GetY()))
            local cityID, owner = city:GetID(), city:GetOwner()
            city:SetPopulation(0, true)
            city:Kill()
            Events.SerialEventCityDestroyed(hexpos, owner, cityID, -1)
            Events.SerialEventGameDataDirty()
        end
    end

    if not pPlot:IsCity() then
        KillUnitsOnPlot(pPlot)
        DestroyNonCapital(pPlot)
        if num > 0 then
            for ePlot in PlotAreaSpiralIterator(pPlot, 1, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
                KillUnitsOnPlot(ePlot)
                DestroyNonCapital(ePlot)
            end
        end
    else
        DestroyNonCapital(pPlot)
        KillUnitsOnPlot(pPlot)
        if num > 0 then
            for ePlot in PlotAreaSpiralIterator(pPlot, 1, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
                KillUnitsOnPlot(ePlot)
            end
        end
    end

    if num > 0 then
        Events.AddPopupTextEvent(PositionCalculator(pPlot:GetX(), pPlot:GetY()), Locale.ConvertTextKey("TXT_KEY_ALERT_SPACE_BATTLECRUISER"), 0.1)
        Events.AudioPlay2DSound("AS2D_ARCTURUS_YAMATO_CANNON")
        pUnit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_SPACE_BATTLECRUISER_MANA_COLD_DOWN"].ID, true)
    end
end

local function HandleCruiserNuke(pPlot, pUnit, pPlayer)
    if pPlot == pUnit:GetPlot() then return end
    if Map.PlotDistance(pUnit:GetX(), pUnit:GetY(), pPlot:GetX(), pPlot:GetY()) > 30 then return end
    pUnit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_SPACE_BATTLECRUISER_NUKE_COLD_DOWN"].ID, true)
    pUnit:ChangeMoves(-GameDefines["MOVE_DENOMINATOR"])
    local unit = pPlayer:InitUnit(GameInfoTypes.UNIT_ICBM_MISSILE, pUnit:GetX(), pUnit:GetY())
    unit:PushMission(MissionTypes.MISSION_NUKE, pPlot:GetX(), pPlot:GetY(), 0, 0, 1, MissionTypes.MISSION_NUKE, unit:GetPlot(), unit)
end

local function HandleIronPagodaCharge(pPlot, pSUnit, pPlayer)
    if not HasPromoID(pSUnit, GameInfoTypes.PROMOTION_ANTI_ANTI_MOUNTED_BONUS) then return end
    if not isInArray(IronPagodaChargeArray, GetPlotKey(pPlot)) then return end

    for i = 0, 5 do
        if isInArray(IronPagodaChargeArrayDirection[i], GetPlotKey(pPlot)) then
            for _, key in pairs(IronPagodaChargeArrayDirection[i]) do
                local plot = GetPlotFromKey(key)
                for j = 0, plot:GetNumUnits() - 1 do
                    local u = plot:GetUnit(j)
                    if u and pPlayer:IsAtWarWith(u:GetOwner()) then
                        local att = pSUnit:GetMaxAttackStrength(pSUnit:GetPlot(), plot, u)
                        local def = u:GetMaxDefenseStrength(plot, pSUnit)
                        local dmg = math.floor(3 * pSUnit:GetCombatDamage(att, def, pSUnit:GetDamage(), false, false, false))
                        u:ChangeDamage(dmg)
                    end
                end
            end
            pSUnit:SetXY(pPlot:GetX(), pPlot:GetY())
            pSUnit:SetMoves(0)
            pSUnit:ChangeDamage(99)
            local hex = ToHexFromGrid(Vector2(pPlot:GetX(), pPlot:GetY()))
            Events.AddPopupTextEvent(HexToWorld(hex), Locale.ConvertTextKey("TXT_KEY_TITLE_IRON_BUDDHA_CHARGE"))
            Events.GameplayFX(hex.x, hex.y, -1)
            break
        end
    end
    ResetIronPagodaCharge()
end

function InputHandler(uiMsg, wParam, lParam)
    if SpaceBattleCruiserSkill == 0 then return false end

    if uiMsg == MouseEvents.LButtonDown then
        lButtonDown = true
        local pPlot = Map.GetPlot(UI.GetMouseOverHex())
        local pPlayer = Players[Game:GetActivePlayer()]
        local pUnit = UI.GetHeadSelectedUnit()

        if SpaceBattleCruiserSkill == 1 and pUnit:GetUnitType() == GameInfoTypes.UNIT_SPACESHIP then
            HandleCruiserMainGun(pPlot, pUnit, pPlayer)
            Events.ClearHexHighlights()
            SpaceBattleCruiserSkill = 0
        elseif SpaceBattleCruiserSkill == 2 and pUnit:GetUnitType() == GameInfoTypes.UNIT_SPACESHIP then
            HandleCruiserNuke(pPlot, pUnit, pPlayer)
            Events.RemoveAllArrowsEvent()
            Events.SerialEventMouseOverHex.Remove(ShowNukeArrow)
            Events.SerialEventMouseOverHex.Remove(ShowNukeHitPlot)
            Events.ClearHexHighlights()
            SpaceBattleCruiserSkill = 0
        elseif SpaceBattleCruiserSkill == 3 then
            HandleIronPagodaCharge(pPlot, pUnit, pPlayer)
            Events.ClearHexHighlights()
            SpaceBattleCruiserSkill = 0
        end
    elseif uiMsg == MouseEvents.LButtonUp then
        lButtonDown = false
    elseif uiMsg == MouseEvents.RButtonDown then
        rButtonDown = true
    elseif uiMsg == MouseEvents.RButtonUp then
        if rButtonDown and SpaceBattleCruiserSkill > 0 then
            rButtonDown = false
            SpaceBattleCruiserSkill = 0
            Events.ClearHexHighlights()
            Events.RemoveAllArrowsEvent()
            Events.SerialEventMouseOverHex.Remove(ShowNukeArrow)
            Events.SerialEventMouseOverHex.Remove(ShowNukeHitPlot)
        end
    end
    return false
end
ContextPtr:SetInputHandler(InputHandler)

-- ============================================================
-- 城市视野 / 揭示
-- ============================================================
local function citiesVisible(pTeam)
    for tech in GameInfo.Technologies() do
        if tech.MapVisible and pTeam:IsHasTech(tech.ID) then return true end
    end
    return false
end

local function revealPlot(iTeam, pPlot)
    if pPlot:GetFeatureType() == -1 or not GameInfo.Features[pPlot:GetFeatureType()].NaturalWonder then
        if pPlot:GetVisibilityCount(iTeam) > 0 then pPlot:ChangeVisibilityCount(iTeam, -1, -1, true) end
        pPlot:SetRevealed(iTeam, false)
        pPlot:ChangeVisibilityCount(iTeam, 1, -1, true)
        pPlot:SetRevealed(iTeam, true)
    end
end

local function revealCell(iTeam, pPlot)
    local dirs = {DirectionTypes.DIRECTION_NORTHEAST, DirectionTypes.DIRECTION_EAST, DirectionTypes.DIRECTION_SOUTHEAST,
                  DirectionTypes.DIRECTION_SOUTHWEST, DirectionTypes.DIRECTION_WEST, DirectionTypes.DIRECTION_NORTHWEST}
    revealPlot(iTeam, pPlot)
    for _, d in ipairs(dirs) do revealPlot(iTeam, Map.PlotDirection(pPlot:GetX(), pPlot:GetY(), d)) end
end

function revealCities()
    local iTeam = Game.GetActiveTeam()
    local pTeam = Teams[iTeam]
    if not citiesVisible(pTeam) then return end
    local iHelios = Players[Game:GetActivePlayer()]:GetBuildingClassCount(GameInfo.BuildingClasses.BUILDINGCLASS_HELIOS_BUILDING.ID)
    for i = 0, Map.GetNumPlots() - 1 do
        local pPlot = Map.GetPlotByIndex(i)
        if pPlot:IsCity() and pPlot:GetPlotCity():GetTeam() ~= iTeam then
            if iHelios > 0 then revealCell(iTeam, pPlot) else revealPlot(iTeam, pPlot) end
        end
    end
end
Events.ActivePlayerTurnStart.Add(revealCities)

-- ============================================================
-- 单位攻击判定
-- ============================================================
function UnitCanRangeAttackPlot(iPlayer, iUnit, iPlotX, iPlotY, bNeedWar)
    local pUnit = Players[iPlayer]:GetUnitByID(iUnit)
    local plot = Map.GetPlot(iPlotX, iPlotY)
    if pUnit:GetDomainType() == DomainTypes.DOMAIN_AIR then
        return NotEnemyAngelPlot(pUnit, plot)
    end
    if pUnit:GetDomainType() ~= DomainTypes.DOMAIN_AIR and not pUnit:IsHasPromotion(GameInfoTypes.PROMOTION_SPACESHIP) then
        return IsNotEnemySpaceShipPlot(pUnit, plot)
    end
    return true
end
GameEvents.UnitCanRangeAttackPlot.Add(UnitCanRangeAttackPlot)

-- ============================================================
-- 城邦任务 / 谴责 / 间谍事件
-- ============================================================
function PlayerCompletedQuest(iMajor, iMinor, iQuestType, iStartTurn, iOldInfluence, iNewInfluence)
    local pPlayer = Players[iMajor]
    if not pPlayer or iNewInfluence <= iOldInfluence then return end
    if pPlayer:HasWonder(GameInfoTypes.BUILDING_DIONYSUS) then
        Players[iMinor]:ChangeMinorCivFriendshipWithMajor(iMajor, 30)
    end
end
GameEvents.PlayerCompletedQuest.Add(PlayerCompletedQuest)

function Denounce_BUFF(PlayerID, OtherPlayerID)
    local otherPlayer = Players[OtherPlayerID]
    if not otherPlayer or not otherPlayer:HasWonder(GameInfoTypes.BUILDING_AP) then return end
    for row in GameInfo.MinorCivilizations() do
        local minor = Players[row.ID]
        if minor and minor:IsMinorCiv() and minor:IsEverAlive() and minor:IsAlive() then
            minor:ChangeMinorCivFriendshipWithMajor(PlayerID, -80)
        end
    end
end
GameEvents.DoDenounce.Add(Denounce_BUFF)

function EspionageStateResult(iPlayer, iSpy, iState, iCityX, iCityY)
    local Player = Players[iPlayer]
    if not Player then return end
    local CityPlot = Map.GetPlot(iCityX, iCityY)
    if not CityPlot then return end
    local City = CityPlot:GetPlotCity()
    local otherPlayer = Players[City:GetOwner()]
    if not otherPlayer or otherPlayer:IsMinorCiv() then return end
    if (iState == 5 or iState == 7) and otherPlayer ~= Player then
        if Player:HasWonder(GameInfoTypes.BUILDING_FOREIGN_OFFICE) then
            local iTeamID = Player:GetTeam()
            local iTeam = Teams[iTeamID]
            local iTeamTechs = iTeam:GetTeamTechs()
            local Boost = Player:GetScience()
            Player:ChangeGold(4 * Player:CalculateGoldRate())
            ChangeResearchProcess(Player, iTeamID, iTeam, iTeamTechs, iPlayer, 3 * Boost)
        end
    end
end
GameEvents.EspionageState.Add(EspionageStateResult)

function LOCKUP(iPlayer, iSpy, iResult, iCityX, iCityY)
    local Player = Players[iPlayer]
    local CityPlot = Map.GetPlot(iCityX, iCityY)
    if not CityPlot then return end
    local City = CityPlot:GetPlotCity()
    local otherPlayer = Players[City:GetOwner()]
    if not otherPlayer or otherPlayer:IsMinorCiv() or not Player then return end
    if iResult == SPY_RESULT_KILLED and otherPlayer ~= Player then
        if Player:HasWonder(GameInfoTypes.BUILDING_KGB) then
            local iTeamID = Player:GetTeam()
            local iTeam = Teams[iTeamID]
            local iTeamTechs = iTeam:GetTeamTechs()
            ChangeResearchProcess(Player, iTeamID, iTeam, iTeamTechs, iPlayer, 3 * Player:GetScience())
        end
        if City:IsHasBuilding(GameInfoTypes["BUILDING_LOCKUP"]) then
            local rank = iSpy + 1
            otherPlayer:ChangeJONSCulture(math.floor(0.4 * rank * otherPlayer:GetTotalJONSCulturePerTurn()))
            Player:ChangeGold(-4 * Player:CalculateGoldRate())
        end
    end
end
GameEvents.EspionageResult.Add(LOCKUP)

-- 定义间谍结果常量
SPY_RESULT_UNDETECTED = 0
SPY_RESULT_DETECTED   = 1
SPY_RESULT_IDENTIFIED = 2
SPY_RESULT_KILLED     = 3
SPY_RESULT_ELIMINATED = 4

-- ============================================================
-- 资源 / 难度 / AI 相关
-- ============================================================
function RemoveErrorResources()
    for i = 0, Map.GetNumPlots() - 1 do
        local plot = Map.GetPlotByIndex(i)
        if plot:IsNaturalWonder() or plot:HasAnyNaturalWonder() then
            plot:SetResourceType(-1)
        end
    end
end
Events.LoadScreenClose.Add(RemoveErrorResources)

local Difficult9Active = PreGame.GetHandicap(0) == GameInfoTypes.HANDICAP_IMPOSSIBLE
local Difficult10Active = PreGame.GetHandicap(0) == GameInfoTypes.HANDICAP_IMPOSSIBLE_EXTREM

function AI_DIFFICULTY_REDUCE()
    for i = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
        local Player = Players[i]
        if Player:IsAlive() and not Player:IsHuman() then
            Player:SetHasPolicy(GameInfo.Policies["POLICY_AI_REDUCE"].ID, true)
            if Game:GetHandicapType() > 8 then
                Player:SetHasPolicy(GameInfo.Policies["POLICY_DIFFICULTY_9"].ID, true)
            end
            if Difficult10Active then
                Player:SetHasPolicy(GameInfo.Policies["POLICY_DIFFICULTY_10"].ID, true)
            end
        end
    end
end
Events.SequenceGameInitComplete.Add(AI_DIFFICULTY_REDUCE)

local tWonders = {}
for row in DB.Query("SELECT ID FROM Buildings WHERE BuildingClass IN (SELECT Type FROM BuildingClasses WHERE MaxGlobalInstances = 1 OR MaxTeamInstances = 1 OR MaxPlayerInstances = 1)") do
    tWonders[row.ID] = true
end

function SetInvalidateCity()
    if city then
        local cityID, playerID = city:GetID(), city:GetOwner()
        Events.SpecificCityInfoDirty(playerID, cityID, CityUpdateTypes.CITY_UPDATE_TYPE_BANNER)
        Events.SpecificCityInfoDirty(playerID, cityID, CityUpdateTypes.CITY_UPDATE_TYPE_PRODUCTION)
    end
    Events.SerialEventGameDataDirty()
end

function AiIntoNewEra(ePlayer, eEra, bFirst)
    local handicap = Game:GetHandicapType()
    local pPlayer = Players[ePlayer]
    if handicap < 7 or not pPlayer:IsAlive() then return end
    if not pPlayer:IsMajorCiv() or pPlayer:IsHuman() then return end

    if eEra == GameInfoTypes["ERA_INDUSTRIAL"] then
        pPlayer:ChangeNumResourceTotal(GameInfoTypes.RESOURCE_GUNPOWDER, 200)
    elseif eEra == GameInfoTypes["ERA_MODERN"] then
        pPlayer:ChangeOverflowResearch(6 * pPlayer:GetScience())
    elseif eEra == GameInfoTypes["ERA_POSTMODERN"] then
        pPlayer:ChangeOverflowResearch(9 * pPlayer:GetScience())
    end

    if Difficult9Active or Difficult10Active then
        pPlayer:ChangeOverflowResearch(4 * pPlayer:GetScience())
    end

    pPlayer:ChangeGold(2000 * (pPlayer:GetCurrentEra() + 1))
    pPlayer:ChangeOverflowResearch(5 * pPlayer:GetScience())

    for city in pPlayer:Cities() do
        local iCurrentBuilding = city:GetProductionBuilding()
        if iCurrentBuilding > -1 and not tWonders[iCurrentBuilding] then
            city:SetProduction(city:GetProductionNeeded())
            SetInvalidateCity()
        end
    end
end
GameEvents.PlayerSetEra.Add(AiIntoNewEra)

if Difficult10Active then
    function StealTech(iPlayer)
        local pPlayer = Players[iPlayer]
        if not pPlayer or not pPlayer:IsMajorCiv() or pPlayer:IsHuman() then return end
        local pTeam = Teams[pPlayer:GetTeam()]
        for i = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
            local pOtherPlayer = Players[i]
            if pOtherPlayer:IsHuman() then
                local pOtherTeam = Teams[pOtherPlayer:GetTeam()]
                for tech in GameInfo.Technologies() do
                    if pPlayer:CanResearch(tech.ID) and pOtherTeam:IsHasTech(tech.ID) then
                        pTeam:SetHasTech(tech.ID, true, iPlayer, false, true)
                    end
                end
            end
        end
    end
    GameEvents.PlayerDoTurn.Add(StealTech)
end

-- ============================================================
-- 晋升限制 / 伟人复制 / 自然奇观 / 购买地块
-- ============================================================
function CanHavePromotion(iPlayer, iUnit, iPromotionType)
    local pUnit = Players[iPlayer]:GetUnitByID(iUnit)
    if iPromotionType == GameInfoTypes.PROMOTION_GUN_2 and pUnit:GetBaseRangedCombatStrength() > 0 then
        return false
    end
    if (iPromotionType == GameInfoTypes.PROMOTION_DRILL_4 or iPromotionType == GameInfoTypes.PROMOTION_SHOCK_4)
        and pUnit:GetUnitClassType() ~= GameInfo.UnitClasses.UNITCLASS_GLADIATOR.ID then
        return false
    end
    if (iPromotionType == GameInfoTypes.PROMOTION_AIR_RANGE_EXTEND or iPromotionType == GameInfoTypes.PROMOTION_EVASION)
        and pUnit:GetDomainType() ~= DomainTypes.DOMAIN_AIR then
        return false
    end
    return true
end
GameEvents.CanHavePromotion.Add(CanHavePromotion)

function ProduceCopy(iPlayer, iUnit, iGreatWork)
    local player = Players[iPlayer]
    if not player or not player:IsMajorCiv() then return end
    if player:GetNumCities() <= 0 or not player:HasWonder(GameInfoTypes.BUILDING_KARLSTEJN) then return end

    local gw
    for _, v in ipairs(player:GetGreatWorks(4)) do
        if load(player, "HaveCopied" .. Game.GetGreatWorkName(v.Index)) == nil
            and Game.GetGreatWorkCreator(v.Index) == iPlayer then
            gw = v.Index
            save(player, "HaveCopied" .. Game.GetGreatWorkName(v.Index), true)
            break
        end
    end
    if not gw then return end

    local city = player:GetCityOfClosestGreatWorkSlot(player:GetCapitalCity():GetX(), player:GetCapitalCity():GetY(), GameInfoTypes["GREAT_WORK_SLOT_MUSIC"])
    if not city then return end

    local building = player:GetBuildingOfClosestGreatWorkSlot(player:GetCapitalCity():GetX(), player:GetCapitalCity():GetY(), GameInfoTypes["GREAT_WORK_SLOT_MUSIC"])
    if not building then return end

    building = GameInfo.Buildings[building]
    local buildingClass, availableSlots = building.BuildingClass, building.GreatWorkCount
    for slot = 0, availableSlots - 1 do
        if city:GetBuildingGreatWork(GameInfoTypes[buildingClass], slot) == -1 then
            city:SetBuildingGreatWork(GameInfoTypes[buildingClass], slot, gw)
            break
        end
    end
end
GameEvents.GreatWorkCreated.Add(ProduceCopy)

function BuffForNaturalWonderDiscovered(iTeam, iFeature, iX, iY, bFirst)
    local pTeam = Teams[iTeam]
    local pPlayer = Players[pTeam:GetLeaderID()]
    if not pPlayer or not pPlayer:IsMajorCiv() then return end
    if pPlayer:HasWonder(GameInfoTypes.BUILDING_MALTA) then
        pPlayer:ChangeGold(1000)
    end
end
GameEvents.NaturalWonderDiscovered.Add(BuffForNaturalWonderDiscovered)

function MagaBoughtPlot(iPlayer, iCity, iPlotX, iPlotY, bGold, bCulture)
    local Player = Players[iPlayer]
    if not Player:HasTrait(GameInfoTypes["TRAIT_RIVER_EXPANSION"]) then return end
    local city = Player:GetCityByID(iCity)
    if not city then return end
    local iGain = Player:GetCurrentEra() + 1
    city:ChangeOverflowProduction(10 * iGain)
    Player:ChangeJONSCulture(10)
end
GameEvents.CityBoughtPlot.Add(MagaBoughtPlot)

-- ============================================================
-- 环球航行
-- ============================================================
local g_NotificationType = NotificationTypes.NOTIFICATION_GENERIC
local g_NotificationTypeTech = NotificationTypes.NOTIFICATION_FREE_TECH

LuaEvents.MagellanNotificationId.Add(function(id) g_NotificationType = id end)

function OnCircumnavigatedGlobe(iTeam)
    local pPlayer = Players[Game.GetActivePlayer()]
    local sHead = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_HEAD")
    local sText = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_TEXT_UNKNOWN")
    local Team = Teams[iTeam]
    local Player = Players[Team:GetLeaderID()]

    Player:SetNumFreeTechs(2)
    Player:ChangeFreePromotionCount(GameInfoTypes.PROMOTION_CIRCUMNAVIGATED, 1)

    if Game.GetActiveTeam() == iTeam then
        sText = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_TEXT_YOU")
        Player:AddNotification(g_NotificationTypeTech, Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_NEW_RESEARCH"),
            Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_SUMMARY_NEW_RESEARCH"), -1, -1, -1, -1)
    elseif Teams[Game.GetActiveTeam()]:IsHasMet(iTeam) then
        sText = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_TEXT_KNOWN", Players[Team:GetLeaderID()]:GetCivilizationShortDescriptionKey())
    end
    pPlayer:AddNotification(g_NotificationType, sText, sHead, -1, -1, -1, -1)
end
GameEvents.CircumnavigatedGlobe.Add(OnCircumnavigatedGlobe)
LuaEvents.MagellanNotificationIdRequest()

-- ============================================================
-- 幽灵伤害 / 冰冻通知
-- ============================================================
function ghostdamage(iPlayer, iUnit, iFromX, iFromY, iToX, iToY)
    local Player = Players[iPlayer]
    local pUnit = Player:GetUnitByID(iUnit)
    if not pUnit or not pUnit:IsHasPromotion(GameInfoTypes.PROMOTION_GHOST_POWER) then return end
    for i = 0, 5 do
        local adjPlot = Map.PlotDirection(iToX, iToY, i)
        if adjPlot then
            for j = 0, adjPlot:GetNumUnits() - 1 do
                local pFoundUnit = adjPlot:GetUnit(j)
                if Player:IsAtWarWith(pFoundUnit:GetOwner()) then
                    pFoundUnit:ChangeDamage(33, Player)
                end
            end
        end
    end
end
GameEvents.ParadropAt.Add(ghostdamage)

local iFreezeCollectionID = GameInfoTypes["PROMOTION_COLLECTION_FREEZE_BOMB"]
local iFreezedCollectionID = GameInfoTypes["PROMOTION_COLLECTION_FREEZE_EFFECT"]
GameEvents.OnTriggerAddEnemyPromotion.Add(function(eThisPromotionType, eThisPromotionCollection, eThisBattleType, iThisPlayer,
    iThisUnit, iThisUnitType, eThatPromotionType, eThatPromotionCollection, iThatPlayer, iThatUnit, iThatUnitType)
    if eThisPromotionCollection ~= iFreezeCollectionID or eThatPromotionCollection ~= iFreezedCollectionID then return end
    if eThatPromotionType == -1 then return end
    local pThisPlayer, pThatPlayer = Players[iThisPlayer], Players[iThatPlayer]
    if not pThisPlayer or not pThatPlayer then return end
    local pThisUnit = pThisPlayer:GetUnitByID(iThisUnit)
    local pThatUnit = pThatPlayer:GetUnitByID(iThatUnit)
    if not pThisUnit or not pThatUnit then return end
    if pThisPlayer:IsHuman() then
        Events.GameplayAlertMessage(Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_ENEMY_FREEZE", pThisUnit:GetName(), pThatUnit:GetName()))
    end
    if pThatPlayer:IsHuman() then
        Events.GameplayAlertMessage(Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_US_FREEZE", pThisUnit:GetName(), pThatUnit:GetName()))
    end
end)

-- ============================================================
-- 城镇堡垒升级（根据游戏速度）
-- ============================================================
local iGameSpeed = GameInfo.GameSpeeds[Game.GetGameSpeedType()].GrowthPercent / 100
local TownFortLv1_Threshold = 10 * iGameSpeed
local TownFortLv2_Threshold = 15 * iGameSpeed
local TownFortLv1 = GameInfoTypes["IMPROVEMENT_TRADING_POST"]
local TownFortLv2 = GameInfoTypes["IMPROVEMENT_TOWN"]
local TownFortLv3 = GameInfoTypes["IMPROVEMENT_LARGE_TOWN"]

function GetTownFortXPPerTurn(iX, iY, iImprovementType, iCurrentXP, iOwner, iWorkCity)
    if not Players[iOwner] or not Players[iOwner]:GetCityByID(iWorkCity) or not Map.GetPlot(iX, iY) then return end
    local plot = Map.GetPlot(iX, iY)
    if iImprovementType == TownFortLv1 then
        if not plot:IsImprovementPillaged() and plot:IsBeingWorked() then
            return 100 / TownFortLv1_Threshold
        end
    elseif iImprovementType == TownFortLv2 then
        if not plot:IsImprovementPillaged() and plot:IsBeingWorked() then
            return 100 / TownFortLv2_Threshold
        end
        return -50 / TownFortLv2_Threshold
    elseif iImprovementType == TownFortLv3 then
        if not plot:IsImprovementPillaged() and plot:IsBeingWorked() then
            return 5
        end
        return -2
    end
    return 0
end
GameEvents.GetImprovementXPPerTurn.Add(GetTownFortXPPerTurn)





