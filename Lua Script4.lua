



		case INSTANT_YIELD_TYPE_CONSTRUCTION:
				{
					if (eBuilding != NO_BUILDING)
					{
						TechTypes eTech = (TechTypes)GC.getBuildingInfo(eBuilding)->GetPrereqAndTech();
						int iEra = 0;
						if (eTech == NO_TECH)
						{
							iEra = 0;
						}
						else
						{
							iEra = GC.getTechInfo(eTech)->GetEra();
						}
						for (int iLoopEra = 0; iLoopEra <= iEra; ++iLoopEra)
						{
							iValue += pLoopCity->GetGreatPersonProgressFromConstruction(eGreatPerson, (EraTypes)iLoopEra);
						}
					}
					break;
				}




YieldTypes eYield;

		for(int iI = 0; iI < NUM_YIELD_TYPES; iI++)
		{
			eYield = (YieldTypes) iI;


#if defined(MOD_ROG_CORE)
			CvBuildingEntry* pkBuildingInfo = GC.getBuildingInfo(eBuilding);
			int iCost = pkBuildingInfo->GetProductionCost();
			iCost *= GC.getGame().getGameSpeedInfo().getConstructPercent();
			iCost /= 100;
			if (MOD_ROG_CORE && (iChange > 0) && GetYieldFromConstruction(eYield) > 0)
			{
				doInstantYield(eYield, iCost);
			}		
#endif






kUtility.SetYields(m_piYieldFromPillage, "Building_YieldFromPillage", "BuildingType", szBuildingType);
	kUtility.SetYields(m_piYieldFromPillageGlobal, "Building_YieldFromPillageGlobal", "BuildingType", szBuildingType);
	kUtility.SetYields(m_piYieldFromPillageGlobalPlayer, "Building_YieldFromPillageGlobalPlayer", "BuildingType", szBuildingType);
	kUtility.SetYields(m_piYieldModifierFromWonder, "Building_CityWithWorldWonderYieldModifierGlobal", "BuildingType", szBuildingType);


	m_aiYieldPerPopInEmpire








	#if defined(MOD_ROG_CORE)
		
				CvCity* pOriginCity = getOriginCity();
				if (pOriginCity == NULL)
					pOriginCity = GET_PLAYER(getOwner()).getCapitalCity();

				if (pPlot->getOwner() != NO_PLAYER)
				{
					for (int iYieldLoop = 0; iYieldLoop < NUM_YIELD_TYPES; iYieldLoop++)
					{
						YieldTypes iYieldType = (YieldTypes)iYieldLoop;
						int iValue = pOriginCity->GetYieldFromPillage(iYieldType)+ GET_PLAYER(getOwner()).GetYieldFromPillage(iYieldType);
						if (iValue > 0)
						{
							pOriginCity->doInstantYield((YieldTypes)iYieldLoop, iValue);

							int iLoop = 0;
							for (CvCity* pLoopCity = GET_PLAYER(getOwner()).firstCity(&iLoop); pLoopCity != NULL; pLoopCity = GET_PLAYER(getOwner()).nextCity(&iLoop))
							{
								//If we passed in a city, only check that city.
								if (pLoopCity != pOriginCity)
								{
									pLoopCity->doInstantYield((YieldTypes)iYieldLoop, iValue);
								}
							}
						}
					}
				}
#endif



	REGIST_STATIC_FUNCTION(CvLuaUnit::lGetNumAttacks);
	REGIST_STATIC_FUNCTION(CvLuaUnit::lChangeMadeAttackNum);
	REGIST_STATIC_FUNCTION(CvLuaUnit::lGetNumAttacksMadeThisTurn);



-- ********************************************************
-- 突击虎无限次远程火力支援
-- ******************************************************** 
if attUnit:GetDomainType() == DomainTypes.DOMAIN_LAND then
if not attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_STURMTIGER"].ID)  then 
if not defUnit:IsDead()  then

if batType == GameInfoTypes["BATTLETYPE_MELEE"] 
or (batType == GameInfoTypes["BATTLETYPE_RANGED"] and attUnit:IsRangedSupportFire() == false) then

    local uniqueRange = 2
	for dx = -uniqueRange, uniqueRange - 1, 1 do
		for dy = -uniqueRange, uniqueRange - 1, 1 do
            local adjPlot = Map.PlotXYWithRangeCheck(attUnit:GetX(),attUnit:GetY(), dx, dy,1)
            if (adjPlot ~= nil) then
                local unitCount = adjPlot:GetNumUnits();
                if unitCount > 0 then
                    for i = 0, unitCount-1, 1 do
                        local pFoundUnit = adjPlot:GetUnit(i);
                        if pFoundUnit~=attUnit and pFoundUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_STURMTIGER"].ID)  then
						if Players[pFoundUnit:GetOwner()] == attPlayer then
						if Map.PlotDistance(pFoundUnit:GetX(), pFoundUnit:GetY(), defUnit:GetX(), defUnit:GetY()) <= pFoundUnit:Range() then

					    pFoundUnit:ChangeMadeAttackNum(-1)
						pFoundUnit:ChangeMoves(GameDefines["MOVE_DENOMINATOR"])
						
						if 	pFoundUnit:CanRangeStrikeAt(defUnit:GetX(), defUnit:GetY())			  
						pFoundUnit:RangeStrike(defUnit:GetX(), defUnit:GetY())
						else 
						pFoundUnit:ChangeMadeAttackNum(1)
						pFoundUnit:ChangeMoves(-GameDefines["MOVE_DENOMINATOR"]) 
						           end         
						       end
						    end
						 end
					  end
				   end
				end
			 end
		  end     
	   end  
    end
 end


    if  pFoundUnit:GetNumAttacks() > pFoundUnit:GetNumAttacksMadeThisTurn() then  ---攻击次数未用完








	-- ********************************************************
-- 突击虎无限次远程火力支援
-- ******************************************************** 
if attUnit:GetDomainType() == DomainTypes.DOMAIN_LAND then
if not attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_STURMTIGER"].ID)  then 
if not defUnit:IsDead()  then

if batType == GameInfoTypes["BATTLETYPE_MELEE"] 
or (batType == GameInfoTypes["BATTLETYPE_RANGED"] and attUnit:IsRangedSupportFire() == false) then

    local uniqueRange = 2
	for dx = -uniqueRange, uniqueRange - 1, 1 do
		for dy = -uniqueRange, uniqueRange - 1, 1 do
            local adjPlot = Map.PlotXYWithRangeCheck(attUnit:GetX(),attUnit:GetY(), dx, dy,1)
            if (adjPlot ~= nil) then
                local unitCount = adjPlot:GetNumUnits();
                if unitCount > 0 then
                    for i = 0, unitCount-1, 1 do
                        local pFoundUnit = adjPlot:GetUnit(i);
                        if pFoundUnit~=attUnit and pFoundUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_STURMTIGER"].ID)  then
						if Players[pFoundUnit:GetOwner()] == attPlayer then
						if Map.PlotDistance(pFoundUnit:GetX(), pFoundUnit:GetY(), defUnit:GetX(), defUnit:GetY()) <= pFoundUnit:Range() then
                        pFoundUnit:SetMadeAttack(false)
						pFoundUnit:ChangeMoves(GameDefines["MOVE_DENOMINATOR"])  
						pFoundUnit:RangeStrike(defUnit:GetX(), defUnit:GetY())
						pFoundUnit:SetMadeAttack(false)
						           end         
						       end
						    end
						 end
					  end
				   end
				end
			 end
		  end     
	   end  
    end
 end