



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