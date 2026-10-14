-- ============================================================
-- NewAttackEffects.lua (精简优化版)
-- 世界强权模组 - 战斗附加效果
-- ============================================================

include("FLuaVector.lua")
include("PlotIterators.lua")
include("FunctionUtilities.lua")
include("Rog_SaveUtils.lua")
MY_MOD_NAME = "世界强权"

local NewAttackOff         = GameInfo.SPNewEffectControler.SP_NEWATTACK_OFF.Enabled
local UnitDeathCounterOff  = GameInfo.SPNewEffectControler.UNIT_DEATH_COUNTER_OFF.Enabled

-- ============================================================
-- 工具函数：遍历指定坐标周围半径内的所有单位
-- callback(unit, plot) 返回 true 时可提前终止
-- ============================================================
local function ForEachUnitInRange(centerX, centerY, radius, callback)
    for dx = -radius, radius do
        for dy = -radius, radius do
            local plot = Map.PlotXYWithRangeCheck(centerX, centerY, dx, dy, radius)
            if plot then
                for i = 0, plot:GetNumUnits() - 1 do
                    local unit = plot:GetUnit(i)
                    if unit and callback(unit, plot) then return end
                end
            end
        end
    end
end

-- ============================================================
-- 战斗数据收集
-- ============================================================
local g_DoExtraAttackEffect = nil

function ExtraAttackEffectStarted(iType, iPlotX, iPlotY)
    if iType == GameInfoTypes["BATTLETYPE_MELEE"]
        or iType == GameInfoTypes["BATTLETYPE_RANGED"]
        or iType == GameInfoTypes["BATTLETYPE_AIR"]
        or iType == GameInfoTypes["BATTLETYPE_SWEEP"] then
        g_DoExtraAttackEffect = {
            attPlayerID = -1,
            attUnitID   = -1,
            defPlayerID = -1,
            defUnitID   = -1,
            attODamage  = 0,
            defODamage  = 0,
            PlotX = iPlotX,
            PlotY = iPlotY,
            bIsCity = false,
            defCityID = -1,
            battleType = iType,
        }
    end
end
GameEvents.BattleStarted.Add(ExtraAttackEffectStarted)

function ExtraAttackEffectJoined(iPlayer, iUnitOrCity, iRole, bIsCity)
    if not g_DoExtraAttackEffect
        or not Players[iPlayer] or not Players[iPlayer]:IsAlive()
        or (not bIsCity and not Players[iPlayer]:GetUnitByID(iUnitOrCity))
        or (bIsCity and (not Players[iPlayer]:GetCityByID(iUnitOrCity) or iRole == GameInfoTypes["BATTLEROLE_ATTACKER"]))
        or iRole == GameInfoTypes["BATTLEROLE_BYSTANDER"] then
        return
    end

    if bIsCity then
        g_DoExtraAttackEffect.defPlayerID = iPlayer
        g_DoExtraAttackEffect.defCityID   = iUnitOrCity
        g_DoExtraAttackEffect.bIsCity     = bIsCity
    elseif iRole == GameInfoTypes["BATTLEROLE_ATTACKER"] then
        g_DoExtraAttackEffect.attPlayerID = iPlayer
        g_DoExtraAttackEffect.attUnitID   = iUnitOrCity
        g_DoExtraAttackEffect.attODamage  = Players[iPlayer]:GetUnitByID(iUnitOrCity):GetDamage()
    elseif iRole == GameInfoTypes["BATTLEROLE_DEFENDER"] or iRole == GameInfoTypes["BATTLEROLE_INTERCEPTOR"] then
        g_DoExtraAttackEffect.defPlayerID = iPlayer
        g_DoExtraAttackEffect.defUnitID   = iUnitOrCity
        g_DoExtraAttackEffect.defODamage  = Players[iPlayer]:GetUnitByID(iUnitOrCity):GetDamage()
    end
end
GameEvents.BattleJoined.Add(ExtraAttackEffectJoined)

-- ============================================================
-- 战斗结束后的附加效果
-- ============================================================
function ExtraAttackEffectEffect()
    -- 状态校验
    if not g_DoExtraAttackEffect
        or not Players[g_DoExtraAttackEffect.defPlayerID]
        or not Players[g_DoExtraAttackEffect.attPlayerID]
        or not Players[g_DoExtraAttackEffect.attPlayerID]:IsAlive()
        or not Players[g_DoExtraAttackEffect.attPlayerID]:GetUnitByID(g_DoExtraAttackEffect.attUnitID)
        or not Map.GetPlot(g_DoExtraAttackEffect.PlotX, g_DoExtraAttackEffect.PlotY) then
        return
    end

    local attPlayerID = g_DoExtraAttackEffect.attPlayerID
    local attPlayer   = Players[attPlayerID]
    local defPlayerID = g_DoExtraAttackEffect.defPlayerID
    local defPlayer   = Players[defPlayerID]

    local attUnit  = attPlayer:GetUnitByID(g_DoExtraAttackEffect.attUnitID)
    local attPlot  = attUnit:GetPlot()

    local plotX    = g_DoExtraAttackEffect.PlotX
    local plotY    = g_DoExtraAttackEffect.PlotY
    local batPlot  = Map.GetPlot(plotX, plotY)
    local batType  = g_DoExtraAttackEffect.battleType
    local bIsCity  = g_DoExtraAttackEffect.bIsCity

    local defUnit, defPlot, defCity = nil, nil, nil
    if not bIsCity and defPlayer:GetUnitByID(g_DoExtraAttackEffect.defUnitID) then
        defUnit = defPlayer:GetUnitByID(g_DoExtraAttackEffect.defUnitID)
        defPlot = defUnit:GetPlot()
    elseif bIsCity and defPlayer:GetCityByID(g_DoExtraAttackEffect.defCityID) then
        defCity = defPlayer:GetCityByID(g_DoExtraAttackEffect.defCityID)
    end

    g_DoExtraAttackEffect = nil

    -- ========================================================
    -- 喷火效果：给攻击者周围敌人施加燃烧
    -- ========================================================
    if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_FIRE_WEAPON"].ID) then
        ForEachUnitInRange(plotX, plotY, 1, function(pFoundUnit)
            if (pFoundUnit:GetDomainType() == DomainTypes.DOMAIN_LAND
                or pFoundUnit:GetDomainType() == DomainTypes.DOMAIN_SEA)
                and not pFoundUnit:IsImmuneNegtivePromotions()
                and attPlayer:IsAtWarWith(pFoundUnit:GetOwner()) then
                pFoundUnit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_BURNING_EFFECT"].ID, true)
            end
        end)
    end

    -- ========================================================
    -- 悬浮毁灭者：瘫痪敌人所有单位与城市
    -- ========================================================
    if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_EMP_BOMB"].ID) then
        for unit in defPlayer:Units() do unit:SetMoves(0) end
        for city in defPlayer:Cities() do city:ChangeResistanceTurns(1) end

        if defPlayer:IsHuman() then
            defPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC,
                Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_US_LVD"),
                Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_US_LVD_SHORT"), plotX, plotY)
        elseif attPlayer:IsHuman() then
            attPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC,
                Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_ENEMY_LVD"),
                Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_ENEMY_LVD_SHORT"), plotX, plotY)
        end
    end

    -- ========================================================
    -- 仅当存在防御单位时生效的效果
    -- ========================================================
    if defUnit then

        -- ----------------------------------------------------
        -- 铁浮屠：击杀敌人后恢复附近铁浮屠的移动力
        -- ----------------------------------------------------
        if defUnit:IsDead() then
            ForEachUnitInRange(defPlot:GetX(), defPlot:GetY(), 5, function(pFoundUnit)
                if pFoundUnit:IsHasPromotion(GameInfoTypes.PROMOTION_ANTI_ANTI_MOUNTED_BONUS)
                    and pFoundUnit:GetMoves() < 6 * GameDefines["MOVE_DENOMINATOR"] then
                    pFoundUnit:SetMoves(math.floor(pFoundUnit:MovesLeft() + GameDefines["MOVE_DENOMINATOR"]))
                end
            end)
        end

        -- ----------------------------------------------------
        -- 海怪：攻击后自愈，并治疗周围友方海军
        -- ----------------------------------------------------
        if attUnit:IsHasPromotion(GameInfoTypes.PROMOTION_NAVAL_MONSTER) then
            attUnit:ChangeDamage(-50)
            ForEachUnitInRange(plotX, plotY, 2, function(pFoundUnit)
                if pFoundUnit ~= attUnit
                    and pFoundUnit:IsCombatUnit()
                    and pFoundUnit:GetDomainType() == DomainTypes.DOMAIN_SEA
                    and Players[pFoundUnit:GetOwner()] == attPlayer then
                    pFoundUnit:ChangeDamage(-50)
                end
            end)
        end

        -- ----------------------------------------------------
        -- 突击虎：为附近突击虎提供无限次远程火力支援
        -- ----------------------------------------------------
        if attUnit:GetDomainType() == DomainTypes.DOMAIN_LAND
            and not attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_STURMTIGER"].ID)
            and (batType == GameInfoTypes["BATTLETYPE_MELEE"]
                or (batType == GameInfoTypes["BATTLETYPE_RANGED"] and not attUnit:IsRangedSupportFire())) then

            ForEachUnitInRange(attUnit:GetX(), attUnit:GetY(), 1, function(pFoundUnit)
                if pFoundUnit ~= attUnit
                    and pFoundUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_STURMTIGER"].ID)
                    and Players[pFoundUnit:GetOwner()] == attPlayer
                    and Map.PlotDistance(pFoundUnit:GetX(), pFoundUnit:GetY(), defUnit:GetX(), defUnit:GetY()) <= pFoundUnit:Range() then

                    pFoundUnit:ChangeMoves(GameDefines["MOVE_DENOMINATOR"])

                    if pFoundUnit:GetNumAttacksMadeThisTurn() == 0 then
                        if pFoundUnit:CanRangeStrikeAt(defPlot:GetX(), defPlot:GetY()) then
                            pFoundUnit:RangeStrike(defPlot:GetX(), defPlot:GetY())
                            pFoundUnit:ChangeMadeAttackNum(-1)
                        else
                            pFoundUnit:ChangeMoves(-GameDefines["MOVE_DENOMINATOR"])
                        end
                    else
                        pFoundUnit:ChangeMadeAttackNum(-1)
                        if pFoundUnit:CanRangeStrikeAt(defPlot:GetX(), defPlot:GetY()) then
                            pFoundUnit:RangeStrike(defPlot:GetX(), defPlot:GetY())
                        else
                            pFoundUnit:ChangeMoves(-GameDefines["MOVE_DENOMINATOR"])
                            pFoundUnit:ChangeMadeAttackNum(1)
                        end
                    end
                end
            end)
        end
    end
end
GameEvents.BattleFinished.Add(ExtraAttackEffectEffect)



