-- ============================================================
-- Plague_UI.lua (修复 + 精简版)
-- 世界强权模组 - 瘟疫 UI 接口
-- ============================================================

PlayerClass     = getmetatable(Players[0]).__index
LuaEvents.Player = LuaEvents.Player or function(player) end
LuaEvents.City   = LuaEvents.City   or function(city)   end

-- ============================================================
-- GAME DEFINES
-- ============================================================
local gHandicap = (PreGame.GetHandicap(0) > 0) and PreGame.GetHandicap(0) or 1
local defineCIDHealthPlagueMinThreshold = 150
if Game then
    defineCIDHealthPlagueMinThreshold =
        (GameDefines["HEALTH_PLAGUE_MIN_THRESHOLD_" .. GameInfo.GameSpeeds[Game.GetGameSpeedType()].Type] or 150)
end

-- ============================================================
-- 帝国总健康（供 UI 顶部使用）
-- ============================================================
function PlayerClass.GetEmpireHealthTotal(pPlayer)
    return pPlayer:GetYieldRateModifier(GameInfoTypes["YIELD_HEALTH"])
end
LuaEvents.Player.Add(PlayerClass.GetEmpireHealthTotal)

-- ============================================================
-- 城市瘟疫信息（顶部界面计数）
-- ★ 修复：pPlayer 未定义 → 从 pCity:GetOwner() 获取
-- ============================================================
function GetCityPlagueInfoForTopPlane(pCity)
    local pPlayer = Players[pCity:GetOwner()]   -- ★ 新增
    local totalHealth  = pCity:GetYieldRate(GameInfoTypes["YIELD_HEALTH"])
    local totalDisease = pCity:GetYieldRate(GameInfoTypes["YIELD_DISEASE"])
    local plagueCounter, plagueThreshold = pPlayer:GetCityPlagueCounterDetails(pCity, true, true)
    local healthIndex  = totalHealth - totalDisease
    local plagueFinal  = plagueThreshold - plagueCounter

    if healthIndex < 0 and pCity:GetPlagueType() ~= -1 then
        return math.max(0, math.ceil(plagueFinal / (-healthIndex)))
    end
    return 0
end
LuaEvents.City.Add(GetCityPlagueInfoForTopPlane)

-- ============================================================
-- 城市瘟疫信息（是否已爆发 + 剩余回合）
-- ============================================================
function GetCityPlagueInfo(pCity)
    if pCity:HasPlague() then
        local iTurns = pCity:GetPlagueTurns()
        if iTurns > 0 then return true, iTurns end
    end
    return false, 0
end
LuaEvents.City.Add(GetCityPlagueInfo)

-- ============================================================
-- 健康点数提示（Tooltip）
-- ============================================================
function Player.GetCityHealthTT(player, city)
    local totalHealth  = city:GetYieldRate(GameInfoTypes["YIELD_HEALTH"])
    local totalDisease = city:GetYieldRate(GameInfoTypes["YIELD_DISEASE"])
    local toolTipHealth, toolTipDisease = "", ""

    -- 疾病明细
    toolTipDisease = toolTipDisease .. city:GetYieldRateInfoTool(GameInfoTypes["YIELD_DISEASE"])
    if city:GetYieldModifierTooltip(GameInfoTypes["YIELD_DISEASE"]) ~= "" then
        toolTipDisease = toolTipDisease .. city:GetYieldModifierTooltip(GameInfoTypes["YIELD_DISEASE"])
    end

    -- 健康度明细
    toolTipHealth = toolTipHealth .. city:GetYieldRateInfoTool(GameInfoTypes["YIELD_HEALTH"])
    if city:GetYieldModifierTooltip(GameInfoTypes["YIELD_HEALTH"]) ~= "" then
        toolTipHealth = toolTipHealth .. city:GetYieldModifierTooltip(GameInfoTypes["YIELD_HEALTH"])
    end

    -- 瘟疫计数
    local plagueCounter, plagueThreshold = player:GetCityPlagueCounterDetails(city, true, true)
    local plagueTurnsHL = "[COLOR_DISEASE]"
    local BreakTurn = 0
    if totalHealth - totalDisease >= 0 then
        plagueTurnsHL = "[COLOR_HEALTH]"
    end

    local toolTipPlagueSentiment = Locale.ConvertTextKey(
        "TXT_KEY_CITYVIEW_HEALTH_PLAGUE_SENTIMENT_TEXT_TT", plagueTurnsHL, plagueCounter, plagueThreshold)

    if totalHealth - totalDisease < 0 and not city:HasPlague() then
        BreakTurn = math.max(0, math.ceil((plagueThreshold - plagueCounter) / (totalDisease - totalHealth)))
        toolTipPlagueSentiment = toolTipPlagueSentiment .. "[NEWLINE][NEWLINE]" ..
            Locale.ConvertTextKey("TXT_KEY_CITYVIEW_HEALTH_PLAGUE_TURNS_TEXT_TT", plagueTurnsHL, BreakTurn)
    end

    return Locale.ConvertTextKey("TXT_KEY_CITYVIEW_HEALTH_TEXT_TT_FOOD", toolTipDisease, totalDisease, toolTipHealth, totalHealth)
        .. "[NEWLINE][NEWLINE][NEWLINE]" .. toolTipPlagueSentiment
end

-- ============================================================
-- 瘟疫计数细节（累计进度、爆发阈值、瘟疫回合数）
-- ============================================================
function Player.GetCityPlagueCounterDetails(player, city, resturnsThreshold, returnsTurns)
    local totalHealth  = city:GetYieldRate(GameInfoTypes["YIELD_HEALTH"])
    local totalDisease = city:GetYieldRate(GameInfoTypes["YIELD_DISEASE"])
    local plagueCounter = city:GetPlagueCounter()
    local plagueThreshold = 0

    if resturnsThreshold then
        plagueThreshold = defineCIDHealthPlagueMinThreshold
        for row in GameInfo.Building_HealthMods("PlagueMod <> 0") do
            if ((not row.IsLocal) and player:HasBuilding(GameInfoTypes[row.BuildingType]))
                or city:HasBuilding(GameInfoTypes[row.BuildingType]) then
                plagueThreshold = plagueThreshold + math.floor((plagueThreshold * row.PlagueMod) / 100)
            end
        end
    end

    local plagueTurns = 0
    if returnsTurns and totalHealth - totalDisease < 0 then
        plagueTurns = math.max(1, (plagueThreshold - plagueCounter) / (totalDisease - totalHealth))
    end
    return plagueCounter, plagueThreshold, plagueTurns
end