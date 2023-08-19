



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


UnitTypes eTrainUnit;

#if defined(MOD_ROG_CORE)
			CvBuildingEntry* pkBuildingInfo = GC.getBuildingInfo(eBuilding);
			int iCost = pkBuildingInfo->GetProductionCost();
			iCost *= GC.getGame().getGameSpeedInfo().getTrainPercent();
			iCost /= 100;

			if (MOD_ROG_CORE && (iChange > 0) && GetYieldFromUnitProduction(eYield) > 0)
			{			
				doInstantYield(eYield, iCost);
			}

			if (MOD_ROG_CORE && (iChange > 0) && GetYieldFromConstruction(eYield) > 0)
			{
				doInstantYield(eYield, iCost);
			}
			
#endif