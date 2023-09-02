-- Lua Script8
-- Author: 11585
-- DateCreated: 2023/8/28 22:55:49
--------------------------------------------------------------
	bool CvUnit::attemptGroundAttacks(const CvPlot& pPlot)
{
	bool bFoundSomething = false;
	if (!IsAirSweepCapable())
		return bFoundSomething;

	int iAirSweepDamage = getGroundAttackDamage();
	int iRange = getGroundAttackRange();
	int iRangeFinal = 1;

	CvString strAppendText = GetLocalizedText("TXT_KEY_PROMOTION_AIR_SWEEP");

	if (iRange >= 0)
	{
		if (iRange == 1)
		{
			iRange = 2;
			iRangeFinal = 2;
		}
		else if (iRange == 0)
		{
			iRange = 2;
			iRangeFinal = 1;
		}
		else
		{
			iRange = getGroundAttackRange() + 1;
			iRangeFinal = getGroundAttackRange() + 1;
		}

		for (int i = -iRange; i <= iRange; ++i)
		{
			for (int j = -iRange; j <= iRange; ++j)
			{
				CvPlot* pLoopPlot = ::plotXYWithRangeCheck(pPlot.getX(), pPlot.getY(), i, j, iRangeFinal);
				if (NULL != pLoopPlot)
				{
					pLoopPlot->changeVisibilityCount(getTeam(), 1, NO_INVISIBLE, false, false, this);

					//if (pLoopPlot->getOwner() == NO_PLAYER || pLoopPlot->getOwner() == getOwner())
						//continue;

					const IDInfo* pUnitNode = pLoopPlot->headUnitNode();
					while (pUnitNode != NULL)
					{
						CvUnit* pLoopUnit = (CvUnit*)GetPlayerUnit(*pUnitNode);
						//CvUnit* pLoopUnit = GetPlayerUnit(*pUnitNode);
						pUnitNode = pLoopPlot->nextUnitNode(pUnitNode);

						if (pLoopUnit == NULL)
							continue;
						//if (!pLoopUnit->canIntercept() && pLoopUnit->getDomainType() != DOMAIN_AIR)
							//continue;
						//if (pLoopUnit->isSuicide())
							//continue;
						//if (pLoopUnit->isCargo())
							///continue;
						if (!GET_TEAM(pLoopUnit->getTeam()).isAtWar(getTeam()))
							continue;

#if defined(MOD_API_UNIT_STATS)
						pLoopUnit->changeDamage(iAirSweepDamage, getOwner(), GetID(), 0.25f, &strAppendText);
#else
						pLoopUnit->changeDamage(iAirSweepDamage, getOwner(), 0.25f, &strAppendText);
#endif
						if (pLoopUnit->IsDead())
						{
							CvString strBuffer;
							int iActivePlayerID = GC.getGame().getActivePlayer();

							if (iActivePlayerID == getOwner())
							{
								strBuffer = GetLocalizedText("TXT_KEY_MISC_YOU_UNIT_DESTROYED_ENEMY", getNameKey(), iAirSweepDamage, pLoopUnit->getNameKey());
								GC.GetEngineUserInterface()->AddMessage(0, getOwner(), true, /*10*/ GD_INT_GET(EVENT_MESSAGE_TIME), strBuffer/*, GC.getEraInfo(GC.getGame().getCurrentEra())->getAudioUnitVictoryScript(), MESSAGE_TYPE_INFO, NULL, (ColorTypes)GC.getInfoTypeForString("COLOR_GREEN"), pkTargetPlot->getX(), pkTargetPlot->getY()*/);
							}

							CvUnitCombat::ApplyPostCombatTraitEffects(this, pLoopUnit);
					}

						bFoundSomething = true;
				}
			}
		}
	}
	}
	return bFoundSomething;
}







int CvPromotionEntry::GetTurnDamage() const
{
	return m_iTurnDamage;
}
int CvPromotionEntry::GetTurnDamagePercent() const
{
	return m_iTurnDamagePercent;
}
int CvPromotionEntry::GetNearbyEnemyDamage() const
{
	return m_iNearbyEnemyDamage;
}
int CvPromotionEntry::GetAdjacentEnemySapMovement() const
{
	return m_iAdjacentEnemySapMovement;
}
int CvPromotionEntry::GetAdjacentSapExperience() const
{
	return m_iAdjacentSapExperience;
}



	--	, m_iTurnDamage(0)
		--, m_iTurnDamagePercent(0)
		--, m_iNearbyEnemyDamage(0)
		--, m_iAdjacentEnemySapMovement(0)
		, m_iAdjacentSapExperience(0)

			//if we are a builder (something with builderstrength), our value decrease with our build strength
	if (MOD_CIV6_WORKER && getBuilderStrength() > 0)
	{
		iNumGold *= getUnitInfo().GetBuilderStrength() - getBuilderStrength();
		iNumGold /= getUnitInfo().GetBuilderStrength();
	}

	AdjacentFriendlySapMovement

	//	--------------------------------------------------------------------------------
int CvUnit::GetAdjacentFriendlySapMovement() const
{
	return m_iAdjacentFriendlySapMovement;
}

//	--------------------------------------------------------------------------------
void CvUnit::ChangeAdjacentFriendlySapMovement(int iChange)
{
	m_iAdjacentFriendlySapMovement += iChange;
}