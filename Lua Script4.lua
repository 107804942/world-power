



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



CvUnit* pBestDefender = plot.getBestDefender(NO_PLAYER, kAttacker.getOwner()).pointer();

DoNewBattleEffects(kCombatInfo, iDamage);


void CvUnitCombat::ResolveRangedUnitVsCombat(const CvCombatInfo& kCombatInfo, uint uiParentEventID)

void CvUnitCombat::DoNewBattleEffects(const CvCombatInfo& kCombatInfo, int iAttackDamage)
{
	if (!ShouldDoNewBattleEffects(kCombatInfo))
		return;
	DoNukeDamage(kCombatInfo);
	DoSplashDamage(kCombatInfo);
	DoCollateralDamage(kCombatInfo);
	DoAddEnemyPromotions(kCombatInfo);
	DoDestroyBuildings(kCombatInfo);
	DoKillCitizens(kCombatInfo);
	DoStackingFightBack(kCombatInfo);
	DoStopAttacker(kCombatInfo);
	DoBounsFromCombatDamageWhenFinish(kCombatInfo, iAttackDamage);
	DoInsightEnemyDamage(kCombatInfo);
}

bool CvUnitCombat::ShouldDoNewBattleEffects(const CvCombatInfo& kCombatInfo)
{
	if (kCombatInfo.getAttackIsNuclear()) return false;

	CvPlayerAI& kAttackPlayer = getAttackerPlayer(kCombatInfo);
	CvPlayerAI& kDefensePlayer = getDefenderPlayer(kCombatInfo);

	// Only do this for human players.
	// May provide GameOption to enable for AI later.
	return kAttackPlayer.isHuman() || kDefensePlayer.isHuman();
}

