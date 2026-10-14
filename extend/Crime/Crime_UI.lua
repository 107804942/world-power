-- ============================================================
-- Crime_UI.lua (修复 + 精简版)
-- 世界强权模组 - 犯罪率 UI 接口
-- ============================================================

PlayerClass     = getmetatable(Players[0]).__index
LuaEvents.Player = LuaEvents.Player or function(player) end
LuaEvents.City   = LuaEvents.City   or function(city)   end

local gHandicap = (PreGame.GetHandicap(0) > 0) and PreGame.GetHandicap(0) or 1

-- ★ 修复：范围应为 [lower, upper]，原代码 (upper + 2) - lower 会多 1
function Game.GetRandom(lower, upper)
    return Game.Rand((upper + 1) - lower, "") + lower
end

-- ============================================================
-- 犯罪率提示（Tooltip）
-- ============================================================
function Player.GetCityCrimeTT(player, city)
    local totalCrime = city:GetYieldRate(GameInfoTypes["YIELD_CRIME"])
    local toolTipCrime = ""

    toolTipCrime = toolTipCrime .. city:GetYieldRateInfoTool(GameInfoTypes["YIELD_CRIME"])
    if city:GetYieldModifierTooltip(GameInfoTypes["YIELD_CRIME"]) ~= "" then
        toolTipCrime = toolTipCrime .. city:GetYieldModifierTooltip(GameInfoTypes["YIELD_CRIME"])
    end

    local CrimeCounter, CrimeThreshold = player:GetCityCrimeCounterDetails(city, true, true)

    local toolTipCrimeSentiment = Locale.ConvertTextKey(
        "TXT_KEY_CITYVIEW_CRIME_SENTIMENT_TEXT_TT", CrimeCounter, CrimeThreshold)

    if totalCrime > 0 then
        local BreakTurn = math.max(0, math.ceil((CrimeThreshold - CrimeCounter) / totalCrime))
        toolTipCrimeSentiment = toolTipCrimeSentiment .. "[NEWLINE][NEWLINE]" ..
            Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TURNS_TEXT_TT", BreakTurn)
    end

    return Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TEXT_TT_FOOD", toolTipCrime, totalCrime)
        .. "[NEWLINE][NEWLINE][NEWLINE]" .. toolTipCrimeSentiment
end

-- ============================================================
-- 犯罪率计数细节
-- ★ 修复：CrimeTurns 只在 totalCrime > 0 时计算（原逻辑 totalCrime < 0 会得出负数）
-- ============================================================
local defineCrimeMinThreshold = 300
if Game then
    defineCrimeMinThreshold =
        (GameDefines["CRIME_MIN_THRESHOLD_" .. GameInfo.GameSpeeds[Game.GetGameSpeedType()].Type] or 300)
end

function Player.GetCityCrimeCounterDetails(player, city, resturnsThreshold, returnsTurns)
    local totalCrime = city:GetYieldRate(GameInfoTypes["YIELD_CRIME"])
    local CrimeCounter = city:GetResistanceCounter()
    local CrimeThreshold = resturnsThreshold and defineCrimeMinThreshold or 0

    local CrimeTurns = 0
    if returnsTurns and totalCrime > 0 then
        CrimeTurns = math.max(1, (CrimeThreshold - CrimeCounter) / totalCrime)
    end
    return CrimeCounter, CrimeThreshold, CrimeTurns
end