-- ============================================================
-- Crime_Events.lua (精简优化版 · 固定生成3个叛军)
-- 世界强权模组 - 犯罪率事件
-- ============================================================

include("Crime_UI.lua")
include("FLuaVector")
include("FunctionUtilities.lua")
include("PlotIterators.lua")
include("Rog_SaveUtils.lua")
MY_MOD_NAME = "世界强权"

-- ============================================================
-- 各时代叛军单位
-- ============================================================
local EraEnemyUnits = {
    [0] = GameInfoTypes.UNIT_SPEARMAN,
    [1] = GameInfoTypes.UNIT_SWORDSMAN,
    [2] = GameInfoTypes.UNIT_LONGSWORDSMAN,
    [3] = GameInfoTypes.UNIT_MUSKETMAN,
    [4] = GameInfoTypes.UNIT_RIFLEMAN,
    [5] = GameInfoTypes.UNIT_GREAT_WAR_INFANTRY,
    [6] = GameInfoTypes.UNIT_INFANTRY,
    [7] = GameInfoTypes.UNIT_MOTORISED_INFANTRY,
    [8] = GameInfoTypes.UNIT_MECHANIZED_INFANTRY,
    [9] = GameInfoTypes.UNIT_AEGIS,
}

-- ============================================================
-- 在指定城市周围生成 3 个叛军（野蛮人阵营 63）
-- 优先在城市周围 2 格内寻找可通行地块，避免全部挤在同一格
-- ============================================================
local REBEL_COUNT = 3

local function SpawnRebels(city, unitType)
    local spawned = 0
    for plot in PlotAreaSpiralIterator(city:Plot(), 2, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
        if spawned >= REBEL_COUNT then break end
        if plot and not plot:IsWater() and not plot:IsMountain() and not plot:IsCity() then
            local rebel = Players[63]:InitUnit(unitType, plot:GetX(), plot:GetY())
            rebel:JumpToNearestValidPlot()
            spawned = spawned + 1
        end
    end
    -- 如果周围没有合适地块，则退化为在城边生成，确保仍然生成 3 个
    while spawned < REBEL_COUNT do
        local rebel = Players[63]:InitUnit(unitType, city:GetX(), city:GetY())
        rebel:JumpToNearestValidPlot()
        spawned = spawned + 1
    end
end

-- ============================================================
-- 每回合犯罪结算
-- ============================================================
function Crime_PlayerDoTurn(playerID)
    local player = Players[playerID]
    if not player:IsAlive() or not player:IsMajorCiv() then return end

    local era = player:GetCurrentEra()
    local unitType = EraEnemyUnits[era]

    for city in player:Cities() do
        -- 每回合先重置犯罪对产量的修正
        city:SetYieldModifierFromCrime(GameInfoTypes["YIELD_PRODUCTION"], 0)

        local totalCrime = city:GetYieldRate(GameInfoTypes["YIELD_CRIME"])
        local CrimeCounter, CrimeThreshold = player:GetCityCrimeCounterDetails(city, true, true)
        local CrimeMod = city:GetYieldRateModifier(GameInfoTypes["YIELD_PRODUCTION"])

        -- ----------------------------------------------------
        -- 犯罪率优秀：减少累计犯罪
        -- ----------------------------------------------------
        if totalCrime < 0 then
            if CrimeCounter > 0 then
                city:ChangeResistanceCounter(math.min(totalCrime, -CrimeCounter))
            end
        else
            -- ------------------------------------------------
            -- 犯罪率 > 35：扣产量 + 50% 概率生成 3 个叛军
            -- ------------------------------------------------
            if totalCrime > 35 then
                local mod = (CrimeMod > 0) and -CrimeMod * 0.25 or -25
                city:SetYieldModifierFromCrime(GameInfoTypes["YIELD_PRODUCTION"], mod)

                if LocalizingRandom(0, 100) < 50 then
                    SpawnRebels(city, unitType)   -- ★ 生成 3 个叛军
                end
            end

            -- ------------------------------------------------
            -- 犯罪率 > 70：额外扣产量 + 25% 概率进入抵抗
            -- ------------------------------------------------
            if totalCrime > 70 then
                local mod = (CrimeMod > 0) and -CrimeMod * 0.5 or -33
                city:SetYieldModifierFromCrime(GameInfoTypes["YIELD_PRODUCTION"], mod)

                if LocalizingRandom(0, 100) > 75 and not city:IsResistance() then
                    city:ChangeResistanceTurns(4)
                end
            end

            -- ------------------------------------------------
            -- 累计犯罪，检查是否达到叛乱阈值
            -- ------------------------------------------------
            city:ChangeResistanceCounter(totalCrime)
            CrimeCounter, CrimeThreshold = player:GetCityCrimeCounterDetails(city, true, true)

            if CrimeCounter >= CrimeThreshold then
                city:SetResistanceCounter(0)

                -- 查找附近敌国城市
                local EnemyTAB = {}
                for loopPlot in PlotAreaSpiralIterator(city:Plot(), 10, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
                    if loopPlot:IsCity() and loopPlot:GetPlotCity() ~= city then
                        local loopCity = loopPlot:GetPlotCity()
                        local otherPlayer = Players[loopCity:GetOwner()]
                        if otherPlayer ~= player and otherPlayer:IsMajorCiv()
                            and player:IsAtWarWith(loopCity:GetOwner()) then
                            table.insert(EnemyTAB, otherPlayer)
                        end
                    end
                end

                -- 非首都且非原始首都才可能被割让
                if not city:IsCapital() and not city:IsOriginalCapital() then
                    if #EnemyTAB > 0 then
                        local tPlayer = EnemyTAB[ROG_GetTrueRandom(1, #EnemyTAB)]
                        tPlayer:AcquireCity(city)
                    else
                        Players[63]:AcquireCity(city)
                    end
                end
            end
        end
    end
end
GameEvents.PlayerDoTurn.Add(Crime_PlayerDoTurn)