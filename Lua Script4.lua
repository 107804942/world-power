



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




