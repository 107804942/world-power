function MC_Maratha_GunpowderSepoys(teamID, techID)
    local playerID = Teams[teamID]:GetLeaderID()
    local player = Players[playerID]
    if player:GetCivilizationType() ~= civilizationMarathaID then return end
    if techID == techGunpowderID then
        local capital = player:GetCapitalCity()
        player:InitUnit(unitSepoyID, capital:GetX(), capital:GetY())
        player:InitUnit(unitSepoyID, capital:GetX(), capital:GetY())
    end
end
GameEvents.TeamTechResearched.Add(MC_Maratha_GunpowderSepoys)



		--建筑对全局杰作产出
		GreatWorkyieldChange = 0
		for row in  GameInfo.Building_GreatWorkYieldChanges( thisBuildingAndYieldTypes ) do
			GreatWorkyieldChange = GreatWorkyieldChange + (row.Yield or 0)
		end


iImmobileWhileDamaged = GameInfo.UnitPromotions["PROMOTION_IMMOBILE_WHILE_DAMAGED"].ID




-- ****************************************
-- 异种研究所
-- ****************************************	
function JurassicParkBonus(iPlayer)
	local pPlayer = Players[iPlayer];
	if pPlayer == nil or (not pPlayer:IsMajorCiv()) then
	 	return
	         end
    if pPlayer:GetCurrentEra()~=GameInfoTypes.ERA_FUTURE  then
			return
	   end
	if  pPlayer:HasWonder(GameInfoTypes.BUILDING_FW_JURASSIC_PARK)  then

		local iCheckForDinos = LocalizingRandom(1, 100)
		if (iCheckForDinos < 90) then
			local tPlots ={}
			local tPlots2 ={}
			for pCity in pPlayer:Cities() do
					if pCity:IsHasBuilding(GameInfoTypes.BUILDING_FW_JURASSIC_PARK) then	
						local pCentralPlot = pCity:Plot()
			             for pPlot in PlotAreaSpiralIterator(pCentralPlot, 4, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
							local iTerrain = pPlot:GetTerrainType()
							local iOwner = pPlot:GetOwner()
							if (((iTerrain == GameInfoTypes.TERRAIN_PLAINS) or 
							(iTerrain == GameInfoTypes.TERRAIN_GRASS)) 
							and (iOwner == iPlayer) and (pPlot:GetNumUnits() == 0) and not (pPlot:IsMountain())) then
								table.insert(tPlots, pPlot)
								end
                            if (((iTerrain == GameInfoTypes.TERRAIN_OCEAN) ) 
							and (iOwner == iPlayer) and (pPlot:GetNumUnits() == 0) 
							and not (pPlot:IsMountain())) then
								table.insert(tPlots2, pPlot)
								end
								--print("Inserted plot")
							end
						end
					end
				--end
			--end
			if #tPlots > 0 then
				local randomNumber = LocalizingRandom(1, #tPlots)
				local tPlot = tPlots[randomNumber]
				local iDinoNumber = LocalizingRandom(1, 100)
				--print("单位种类 " .. 根据随机数确定)
				if (iDinoNumber >= 80) and  (pPlayer:GetUnitClassCount(GameInfo.UnitClasses.UNITCLASS_ALIEN_SIEGE_WORM.ID) == 0 ) then 
					iDinoType = GameInfoTypes.UNIT_ALIEN_SIEGE_WORM
					local nUnit = pPlayer:InitUnit(iDinoType, tPlot:GetX(), tPlot:GetY())
				end
				if (iDinoNumber <= 10) and  (pPlayer:GetUnitClassCount(GameInfo.UnitClasses.UNITCLASS_HOVER_WORM.ID) == 0 ) 
				and pPlayer:IsHasTech(GameInfo.Technologies["TECH_COGNITIVE"].ID) then 
					iDinoType3 = GameInfoTypes.UNIT_HOVER_WORM
					local nUnit3 = pPlayer:InitUnit(iDinoType3, tPlot:GetX(), tPlot:GetY())
					end
				end
             if #tPlots2 > 0 then
				local randomNumber = LocalizingRandom(1, #tPlots2)
				local tPlot2 = tPlots2[randomNumber]
				local iDinoNumber = ROG_GetTrueRandom(1, 100)
				if (iDinoNumber <= 15) and  (pPlayer:GetUnitClassCount(GameInfo.UnitClasses.UNITCLASS_NAVAL_MONSTER.ID) == 0 ) 
				and pPlayer:IsHasTech(GameInfo.Technologies["TECH_MATTERTRANSMISSION"].ID) then 
					iDinoType2 = GameInfoTypes.UNIT_NAVAL_MONSTER
					local nUnit2 = pPlayer:InitUnit(iDinoType2, tPlot2:GetX(), tPlot2:GetY())
				end
			end
		end
	end
end
GameEvents.PlayerDoTurn.Add(JurassicParkBonus)



GameEvents.PlayerCanFoundCityRegardless.Add(function(iPlayer, iPlotX, iPlotY) return false end) 



function OnUnitCanRangeAttackAt(iPlayer,iPlotX, iPlotY)
	local pPlayer = Players[iPlayer]
	local pPlot = Map.GetPlot(iPlotX, iPlotY)
	
	if (pUnitInfo.RangedPillage > 0) then
		local pPlot = Map.GetPlot(iX, iY)
		local ePlayer = Players[pPlot:GetOwner()]
		local iRangedPillage = pUnitInfo.RangedPillage

    	if (pPlot:GetImprovementType() ~= -1 and PlayersAtWar(ePlayer, pPlayer)) then
      		print(string.format("%s can range pillage the improvement at (%i, %i)", pUnit:GetName(), iX, iY))

      		if (iRangedPillage == 1 or not pPlot:IsImprovementPillaged()) then
        		-- TODO - for an AI player, does this unit want to pillage the tile?  This opens a whole can of worms!
	    		return pPlayer:IsHuman();
	  		end
		elseif (pPlot:IsRoute()) then
      	print(string.format("%s can range pillage the route at (%i, %i)", pUnit:GetName(), iX, iY))

      		if (iRangedPillage == 1 or not pPlot:IsRoutePillaged()) then
        		-- TODO - for an AI player, does this unit want to pillage the tile?  This opens a whole can of worms!
	   	 		return pPlayer:IsHuman();
	  		end
		end
  	end
  return false;
end
GameEvents.UnitCanRangeAttackAt.Add(OnUnitCanRangeAttackAt)

local tMissions = {
iMove = MissionTypes.MISSION_MOVE_TO,
iRoute = MissionTypes.MISSION_ROUTE_TO,
iMovetoUnit = MissionTypes.MISSION_MOVE_TO_UNIT,
iSwap = MissionTypes.MISSION_SWAP_UNITS
}

function ImmobileWhileDamaged(iPlayer, iUnit, iMission)
local pPlayer = Players[iPlayer]
local pUnit = pPlayer:GetUnitByID(iUnit)

if (pUnit:IsHasPromotion(iImmobileWhileDamaged)) and (pUnit:GetCurrHitPoints() < pUnit:GetMaxHitPoints()) then
for sKey, iValue in pairs(tMissions) do
if iMission == iValue then
return false
end
end
end

return true

end
GameEvents.CanStartMission.Add(ImmobileWhileDamaged)


	if (pkDefender->GetIgnoreDamageChance() > 0)
		{
			int iRand = GC.getGame().getJonRandNum(100, "Ignore Damage Chance");
			if (iRand <= pkDefender->GetIgnoreDamageChance())
			{
				iDamage = 0;
			}
		}












		int CvCombatInfo::getDamageInflicted(BattleUnitTypes unitType) const
{
	checkBattleUnitType(unitType);
	int iDamage = m_iDamageInflicted[unitType];
#ifdef MOD_EVENTS_BATTLES_DAMAGE
#ifndef MOD_EVENTS_BATTLES_CUSTOM_DAMAGE
	if (MOD_EVENTS_BATTLES_DAMAGE) {
		int iValue = 0;
		if (GAMEEVENTINVOKE_VALUE(iValue, GAMEEVENT_BattleDamageDelta, unitType, iDamage) == GAMEEVENTRETURN_VALUE) {
			if (iValue != 0) {
				if (iValue < 0) {
					// Decreasing the amount of damage, in which case it can't be more than the amount inflicted (as that's called 'healing'!)
					if (iDamage + iValue < 0) {
						iValue = -iDamage;
					}
				} else {
					// Increasing the amount of damage, in which case we can't exceed unit/city hit points
					CvCity* pCity = m_pCities[unitType];
					if (pCity)
					{
						if (iDamage + iValue + pCity->getDamage() > pCity->GetMaxHitPoints())
						{
							iValue = pCity->GetMaxHitPoints() - pCity->getDamage() - iDamage;
						}
					}
					else
					{
						if (iDamage + iValue > m_pUnits[unitType]->GetCurrHitPoints())
						{
							iValue = m_pUnits[unitType]->GetCurrHitPoints() - iDamage;
						}
					}
				}
				
				iDamage += iValue;
	
// Fuck fucking C const, it should have been fucking banned fucking years ago!
//				if (unitType == BATTLE_UNIT_ATTACKER) {
//					m_iFinalDamage[BATTLE_UNIT_DEFENDER] += iValue;
//				} else {
//					m_iFinalDamage[BATTLE_UNIT_ATTACKER] += iValue;
//				}
			}
		}
	}
#endif
#endif

#ifdef MOD_EVENTS_BATTLES_CUSTOM_DAMAGE
	if (MOD_EVENTS_BATTLES_CUSTOM_DAMAGE)
	{
		int iAttackPlayerID = 0;
		int iAttackUnitOrCityID = 0;
		bool bAttackIsCity = false;
		int iAttackDamage = 0;

		int iDefensePlayerID = 0;
		int iDefenseUnitOrCityID = 0;
		bool bDefenseIsCity = false;
		int iDefenseDamage = 0;

		int iInterceptorPlayerID = 0;
		int iInterceptorUnitOrCityID = 0;
		bool bInterceptorIsCity = false;
		int iInterceptorDamage = 0;

		BattleUnitTypes iBattleUnitType = unitType;
		BattleTypeTypes iBattleType = getBattleType();

		setBattleUnitInfo(BATTLE_UNIT_ATTACKER, iAttackPlayerID, iAttackUnitOrCityID, bAttackIsCity, iAttackDamage);
		setBattleUnitInfo(BATTLE_UNIT_DEFENDER, iDefensePlayerID, iDefenseUnitOrCityID, bDefenseIsCity, iDefenseDamage);
		setBattleUnitInfo(BATTLE_UNIT_INTERCEPTOR, iInterceptorPlayerID, iInterceptorUnitOrCityID, bInterceptorIsCity, iInterceptorDamage);

		int iDelta = 0;
		if (GAMEEVENTINVOKE_VALUE(iDelta, GAMEEVENT_BattleCustomDamage, 
								iBattleUnitType, iBattleType,
								iAttackPlayerID, iAttackUnitOrCityID, bAttackIsCity, iAttackDamage,
								iDefensePlayerID, iDefenseUnitOrCityID, bDefenseIsCity, iDefenseDamage,
								iInterceptorPlayerID, iInterceptorUnitOrCityID, bInterceptorIsCity, iInterceptorDamage) == GAMEEVENTRETURN_VALUE)
		{
			iDamage += iDelta;

			CvPlayer& AttackPlayer = GET_PLAYER((PlayerTypes)iAttackPlayerID);
			CvPlayer& DefensePlayer = GET_PLAYER((PlayerTypes)iDefensePlayerID);

			if (iAttackPlayerID != NULL && iDefensePlayerID != NULL && !bDefenseIsCity)
			{

				CvUnit* defUnit = DefensePlayer.getUnit(iDefenseUnitOrCityID);

				if (defUnit != NULL && defUnit->GetIgnoreDamageChance() > 0)
				{
					int iRand = GC.getGame().getJonRandNum(100, "Ignore Damage Chance");
					if (iRand <= defUnit->GetIgnoreDamageChance())
					{
						iDamage = 0;
					}
				}
			}
		}
	}
#endif




#if defined(MOD_ROG_CORE)
				if (pkDefender->GetIgnoreDamageChance() > 0)
				{
					int iRand = GC.getGame().getJonRandNum(100, "Ignore Damage Chance");
					if (iRand <= pkDefender->GetIgnoreDamageChance())
					{
						iDamage = 0;
					}
				}
#endif
		



