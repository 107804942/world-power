-- ============================================================
-- Health_Events.lua (精简优化版)
-- 世界强权模组 - 健康/瘟疫事件
-- ============================================================

include("Plague_UI.lua")
include("FLuaVector")
include("FunctionUtilities.lua")
include("Rog_SaveUtils.lua")
MY_MOD_NAME = "世界强权"

-- ============================================================
-- 常量与工具
-- ============================================================
local defineCIDHealthPlagueMinThreshold = 150
if Game then
    defineCIDHealthPlagueMinThreshold =
        (GameDefines["HEALTH_PLAGUE_MIN_THRESHOLD_" .. GameInfo.GameSpeeds[Game.GetGameSpeedType()].Type] or 150)
end

local CUSTOM_MISSION_NO_ACTION       = 0
local CUSTOM_MISSION_ACTION          = 1
local CUSTOM_MISSION_DONE            = 2
local CUSTOM_MISSION_ACTION_AND_DONE = 3

local function IsHealthPlayer(player)
    for city in player:Cities() do
        if city:HasPlague() then return false end
    end
    return true
end

local function IsAIPlayer(player)
    return player and player:IsAlive() and not player:IsMinorCiv()
        and not player:IsBarbarian() and not player:IsHuman()
end

-- ============================================================
-- 瘟疫基础逻辑
-- ============================================================
function GetNumTurn(player, city)
    local mathcheck = 1
    local NumTurn = math.max(0, math.ceil(city:GetPopulation() / 10) + 6)
    if player and player:GetBuildingClassCount(GameInfo.BuildingClasses.BUILDINGCLASS_CENTERS.ID) > 0 then
        mathcheck = mathcheck - 0.25
    end
    if city:IsHasBuilding(GameInfoTypes.BUILDING_LOCAL_HOSPITAL) then
        mathcheck = mathcheck - 0.25
    end
    return math.ceil(mathcheck * NumTurn)
end

function KillPopulation(player, city)
    local plagueID = city:GetPlagueType()
    local pop = 0
    local bNotify = false

    if city:GetPopulation() > 2 then
        pop = math.max(math.floor(city:GetPopulation() / 10), 1)
        city:ChangePopulation(-pop, true)
        bNotify = true
    end

    if bNotify and player:IsHuman() and plagueID ~= -1 then
        local plague = GameInfo.Plagues[plagueID]
        player:AddNotification(NotificationTypes.NOTIFICATION_STARVING,
            Locale.ConvertTextKey("TXT_KEY_PLAGUE_DEATH", plague.IconString, plague.Description, city:GetName(), pop),
            Locale.ConvertTextKey("TXT_KEY_PLAGUE_DEATH_SHORT"),
            city:GetX(), city:GetY())
    end
end

function PlagueEnds(city)
    local player = Players[city:GetOwner()]
    local plagueID = city:GetPlagueType()
    if player:IsHuman() and plagueID ~= -1 then
        local plague = GameInfo.Plagues[plagueID]
        player:AddNotification(NotificationTypes.NOTIFICATION_INSTANT_YIELD,
            Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_ENDS_NOTIFICATION", plague.IconString, plague.Description, city:GetName()),
            Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_ENDS_NOTIFICATION_SHORT"),
            city:GetX(), city:GetY())
        Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
    end
    city:SetPlagueType(-1)
    city:SetPlagueCounter(0)
    city:SetPlagueTurns(0)
end

function PlagueBegins(city)
    local player = Players[city:GetOwner()]
    local plagueID = GetCityPlagueTypeToSpawn(city)
    city:SetPlagueType(plagueID)
    if player:IsHuman() and plagueID ~= -1 then
        local plague = GameInfo.Plagues[plagueID]
        player:AddNotification(NotificationTypes.NOTIFICATION_PLAGUE,
            Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_NOTIFICATION", plague.IconString, plague.Description, city:GetName()),
            Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_NOTIFICATION_SHORT"),
            city:GetX(), city:GetY())
    end
    Events.AudioPlay2DSound("AS2D_PLAGUE")
end

-- ============================================================
-- 攻击城市时降低健康
-- ============================================================
function AttackReduceHealth(iAttackPlayer, iAttackUnit, iDefenderPlayer, iDefenderCity, iPlotX, iPlotY)
    local Attackplayer = Players[iAttackPlayer]
    local unit = Attackplayer:GetUnitByID(iAttackUnit)
    local city = Players[iDefenderPlayer]:GetCityByID(iDefenderCity)
    if not Attackplayer or not unit or not city then return end
    if unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_HUIHUIPAO"].ID) and not city:HasPlague() then
        local plagueCounter, plagueThreshold = Players[iDefenderPlayer]:GetCityPlagueCounterDetails(city, true, true)
        if plagueCounter + 2 <= plagueThreshold then
            city:SetPlagueCounter(city:GetPlagueCounter() + 2)
        end
    end
end
GameEvents.UnitAttackCity.Add(AttackReduceHealth)

-- ============================================================
-- 每回合健康结算
-- ============================================================
function Health_PlayerDoTurn(playerID)
    local player = Players[playerID]
    if not player:IsAlive() or not player:IsMajorCiv() then return end

    for city in player:Cities() do
        local totalHealth  = city:GetYieldRate(GameInfoTypes["YIELD_HEALTH"])
        local totalDisease = city:GetYieldRate(GameInfoTypes["YIELD_DISEASE"])
        local plagueCounter, plagueThreshold = player:GetCityPlagueCounterDetails(city, true, true)
        local leftHealth = totalHealth - totalDisease

        if not city:HasPlague() then
            if leftHealth > 0 then
                if plagueCounter > 0 then
                    city:ChangePlagueCounter(-math.min(plagueCounter, leftHealth))
                end
            else
                city:ChangePlagueCounter(-leftHealth)
                plagueCounter, plagueThreshold = player:GetCityPlagueCounterDetails(city, true, true)
                if plagueCounter >= plagueThreshold then
                    city:ChangePlagueTurns(GetNumTurn(player, city))
                    city:SetPlagueCounter(0)
                    PlagueBegins(city)
                    city:ChangeDamage(100)
                end
            end
        else
            if city:GetPlagueTurns() == 0 then
                PlagueEnds(city)
                KillPopulation(player, city)
            elseif totalDisease > 0 then
                city:ChangeDamage(100)
                KillPopulation(player, city)
            end
        end
    end
end
GameEvents.PlayerDoTurn.Add(Health_PlayerDoTurn)

-- ============================================================
-- AI 自动使用医生治疗瘟疫
-- ============================================================
function CitySetDoctor(iPlayer)
    local player = Players[iPlayer]
    if not IsAIPlayer(player) then return end

    local plagueCities, doctors, greatDoctors = {}, {}, {}
    for city in player:Cities() do
        if city:HasPlague() then table.insert(plagueCities, city) end
    end
    if #plagueCities == 0 then return end

    for unit in player:Units() do
        if unit:GetUnitType() == GameInfoTypes["UNIT_DOCTOR"] then
            table.insert(doctors, unit)
        elseif unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_GREAT_DOCTOR"] then
            table.insert(greatDoctors, unit)
        end
    end

    if #doctors > 0 then
        local city = plagueCities[ROG_GetTrueRandom(1, #plagueCities)]
        local doctor = doctors[ROG_GetTrueRandom(1, #doctors)]
        PlagueEnds(city)
        doctor:Kill()
    elseif #greatDoctors > 0 then
        local greatDoctor = greatDoctors[ROG_GetTrueRandom(1, #greatDoctors)]
        GREAT_DOCTOR_CURE_Mission(iPlayer, greatDoctor)
    end
end
GameEvents.PlayerDoneTurn.Add(CitySetDoctor)

-- ============================================================
-- 任务可能性判断
-- ============================================================
function GREAT_DOCTOR_MissionPossible(playerID, unitID, missionID, data1, data2, _, _, plotX, plotY, bTestVisible)
    local player = Players[playerID]
    local unit = player:GetUnitByID(unitID)
    if not unit or unit:GetUnitClassType() ~= GameInfoTypes["UNITCLASS_GREAT_DOCTOR"] then return false end

    local unitPlot = Map.GetPlot(plotX, plotY)
    local unitPlotCity = unitPlot:GetPlotCity()

    if missionID == GameInfoTypes["MISSION_CONSTRUCT_CITY"] then
        if (not unitPlotCity) or unitPlotCity:IsHasBuilding(GameInfoTypes["BUILDING_LOCAL_HOSPITAL"]) then
            return bTestVisible
        end
        return true
    elseif missionID == GameInfoTypes["MISSION_GREAT_DOCTOR_CURE"] then
        if unitPlot:GetOwner() == -1 or playerID ~= unitPlot:GetOwner() or IsHealthPlayer(player) then
            return bTestVisible
        end
        return true
    end
    return false
end
GameEvents.CustomMissionPossible.Add(GREAT_DOCTOR_MissionPossible)

function Health_MissionPossible(playerID, unitID, missionID, data1, data2, _, _, plotX, plotY, bTestVisible)
    if missionID ~= GameInfoTypes["MISSION_DOCTOR_CURE_CITY"] then return false end
    local player = Players[playerID]
    local unit = player:GetUnitByID(unitID)
    if not unit or unit:GetUnitClassType() ~= GameInfoTypes["UNITCLASS_DOCTOR"] then return false end
    local unitPlotCity = Map.GetPlot(plotX, plotY):GetPlotCity()
    if (not unitPlotCity) or (not unitPlotCity:HasPlague()) then return bTestVisible end
    return true
end
GameEvents.CustomMissionPossible.Add(Health_MissionPossible)

-- ============================================================
-- 任务开始 / 完成
-- ============================================================
function Health_MissionStart(playerID, unitID, missionID, data1, data2, flags, turn)
    local player = Players[playerID]
    local unit = player:GetUnitByID(unitID)
    local city = unit:GetPlot():GetPlotCity()

    if missionID == GameInfoTypes["MISSION_DOCTOR_CURE_CITY"] then
        Health_CurePlagueMission(playerID, unit, city)
        return CUSTOM_MISSION_ACTION
    elseif missionID == GameInfoTypes["MISSION_CONSTRUCT_CITY"] then
        GREAT_DOCTOR_CONSTRUCT_Mission(playerID, unit, city)
        return CUSTOM_MISSION_ACTION
    elseif missionID == GameInfoTypes["MISSION_GREAT_DOCTOR_CURE"] then
        GREAT_DOCTOR_CURE_Mission(playerID, unit)
        return CUSTOM_MISSION_ACTION
    end
    return CUSTOM_MISSION_NO_ACTION
end
GameEvents.CustomMissionStart.Add(Health_MissionStart)

function Health_MissionComplete(playerID, unitID, missionID, data1, data2, flags, turn)
    return missionID == GameInfoTypes["MISSION_DOCTOR_CURE_CITY"]
        or missionID == GameInfoTypes["MISSION_GREAT_DOCTOR_CURE"]
        or missionID == GameInfoTypes["MISSION_CONSTRUCT_CITY"]
end
GameEvents.CustomMissionCompleted.Add(Health_MissionComplete)

-- ============================================================
-- 大医生治疗任务
-- ============================================================
function GREAT_DOCTOR_CURE_Mission(playerID, unit)
    local player = Players[playerID]
    local plot = unit:GetPlot()
    local NumUseForCureAll = load(unit, "UseForCure") or 0

    for city in player:Cities() do
        PlagueEnds(city)
    end

    NumUseForCureAll = NumUseForCureAll + 1
    unit:SetMoves(0)
    save(unit, "UseForCure", NumUseForCureAll)
    Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
    if NumUseForCureAll > 2 then unit:Kill() end

    if player:IsHuman() then
        player:AddNotification(NotificationTypes.NOTIFICATION_GENERIC,
            Locale.ConvertTextKey("TXT_KEY_DOCTOR_CURED"),
            Locale.ConvertTextKey("TXT_KEY_DOCTOR_CURED_SHORT"),
            plot:GetX(), plot:GetY())
    end
end

function GREAT_DOCTOR_CONSTRUCT_Mission(playerID, unit, city)
    local player = Players[playerID]
    local plot = city:Plot()
    city:SetNumRealBuilding(GameInfoTypes["BUILDING_LOCAL_HOSPITAL"], 1)
    if player:IsHuman() then
        player:AddNotification(NotificationTypes.NOTIFICATION_GENERIC,
            Locale.ConvertTextKey("TXT_KEY_DOCTOR_CONSTRUCT", city:GetName()),
            Locale.ConvertTextKey("TXT_KEY_DOCTOR_CONSTRUCT_SHORT"),
            plot:GetX(), plot:GetY())
        Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
    end
    unit:Kill()
end

-- ============================================================
-- 医生治疗瘟疫（普通医生）
-- ============================================================
function Health_CurePlagueMission(playerID, unit, city)
    local player = Players[playerID]
    if not player:IsHuman() or not city:HasPlague() then return end
    local plagueID = city:GetPlagueType()
    if plagueID == -1 then return end

    local plague = GameInfo.Plagues[plagueID]
    local extra = GetExtraCureTurns(unit, city)

    if city:GetPlagueTurns() < 6 + extra then
        player:AddNotification(NotificationTypes.NOTIFICATION_INSTANT_YIELD,
            Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_ENDS_NOTIFICATION", plague.IconString, plague.Description, city:GetName()),
            Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_ENDS_NOTIFICATION_SHORT"),
            city:GetX(), city:GetY())
        Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
        city:SetPlagueType(-1)
        city:SetPlagueCounter(0)
        city:SetPlagueTurns(0)
    else
        local reduce = 5 + extra
        player:AddNotification(NotificationTypes.NOTIFICATION_INSTANT_YIELD,
            Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_REDUCE_NOTIFICATION", plague.IconString, plague.Description, city:GetName(), reduce),
            Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_REDUCE_NOTIFICATION_SHORT"),
            city:GetX(), city:GetY())
        Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
        city:ChangePlagueTurns(-reduce)
    end
    unit:Kill()
end

-- 计算额外治疗回合
function GetExtraCureTurns(unit, city)
    local extra = 0
    local player = Players[unit:GetOwner()]
    if player:HasPolicy(GameInfo.Policies["POLICY_KNOWLEDGE_4"].ID) then extra = extra + 2 end
    if city:IsHasBuilding(GameInfoTypes["BUILDING_HERBALIST"]) then extra = extra + 1 end
    if city:IsHasBuilding(GameInfoTypes["BUILDING_HOSPITAL"]) then extra = extra + 2 end
    return extra
end

-- ============================================================
-- 瘟疫传播判定
-- ============================================================
function GetCityPlagueTypeToSpawn(city)
    local player = Players[city:GetOwner()]
    local capital = player:GetCapitalCity()

    if capital and player:IsCapitalConnectedToCity(city) and capital:HasPlague() then
        return capital:GetPlagueType()
    end

    for _, v in ipairs(player:GetTradeRoutes()) do
        if v.ToCity == city and v.FromCity:HasPlague() then
            return v.FromCity:GetPlagueType()
        end
    end
    for _, v in ipairs(player:GetTradeRoutesToYou()) do
        if v.ToCity == city and v.FromCity:HasPlague() then
            return v.FromCity:GetPlagueType()
        end
    end

    local plagues = {}
    for row in GameInfo.Plagues() do
        table.insert(plagues, row.ID)
    end
    local plagueBubonicID = GameInfoTypes["PLAGUE_BUBONIC"]
    return plagues[Game.GetRandom(1, #plagues)] or plagueBubonicID
end

-- ============================================================
-- 威尼斯特殊：人口增长时清除瘟疫
-- ============================================================
function CheckUploading(iPlotX, iPlotY, iOldPop, iNewPop)
    local city = Map.GetPlot(iPlotX, iPlotY):GetPlotCity()
    local pPlayer = Players[city:GetOwner()]
    if pPlayer:GetCivilizationType() == GameInfoTypes.CIVILIZATION_VENICE and iNewPop > iOldPop then
        city:SetPlagueType(-1)
        city:SetPlagueCounter(0)
        city:SetPlagueTurns(0)
    end
end
GameEvents.SetPopulation.Add(CheckUploading)





	