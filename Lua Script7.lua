
void CvPlayer::UpdateAreaEffectUnit(CvUnit* pUnit)
{
	if (!pUnit || pUnit->isDelayedDeath())
		return;

	CvPlot* pPlot = pUnit->plot();

	if (!pPlot)
		return;

	if (pUnit->IsCombatSupportUnit())
	{
		bool bFound = false;
		for (size_t i = 0; i < m_unitsAreaEffectPositive.size(); i++)
		{
			if (m_unitsAreaEffectPositive[i].first == pUnit->GetID())
			{
				m_unitsAreaEffectPositive[i].second = pPlot->GetPlotIndex();
				bFound = true;
				break;
			}
		}

		if (!bFound)
			m_unitsAreaEffectPositive.push_back(std::make_pair(pUnit->GetID(), pPlot->GetPlotIndex()));
	}

	if (pUnit->getNearbyEnemyCombatMod() < 0)
	{
		bool bFound = false;
		for (size_t i = 0; i < m_unitsAreaEffectNegative.size(); i++)
		{
			if (m_unitsAreaEffectNegative[i].first == pUnit->GetID())
			{
				m_unitsAreaEffectNegative[i].second = pPlot->GetPlotIndex();
				bFound = true;
				break;
			}
		}

		if (!bFound)
			m_unitsAreaEffectNegative.push_back(std::make_pair(pUnit->GetID(), pPlot->GetPlotIndex()));
	}

	//do not include medics here, it kills performance
	//medics are range 1, they can easily be found by iterating the 6 neighbor plots
	if (pUnit->isNearbyPromotion())
	{
		bool bFound = false;
		for (size_t i = 0; i < m_unitsAreaEffectPromotion.size(); i++)
		{
			if (m_unitsAreaEffectPromotion[i].first == pUnit->GetID())
			{
				m_unitsAreaEffectPromotion[i].second = pPlot->GetPlotIndex();
				bFound = true;
				break;
			}
		}

		if (!bFound)
			m_unitsAreaEffectPromotion.push_back(std::make_pair(pUnit->GetID(), pPlot->GetPlotIndex()));
	}

	// Must be able to intercept
	if (pUnit->canIntercept())
	{
		bool bFound = false;
		for (size_t i = 0; i < m_unitsWhichCanIntercept.size(); i++)
		{
			if (m_unitsWhichCanIntercept[i].first == pUnit->GetID())
			{
				m_unitsWhichCanIntercept[i].second = pPlot->GetPlotIndex();
				bFound = true;
				break;
			}
		}

		if (!bFound)
			m_unitsWhichCanIntercept.push_back(std::make_pair(pUnit->GetID(), pPlot->GetPlotIndex()));
	}

	//might need to update the UI
	//UpdateCityStrength();
}

void CvPlayer::UpdateAreaEffectUnits()
{
	//great generals/admirals
	m_unitsAreaEffectPositive.clear();
	//maori warrior et al
	m_unitsAreaEffectNegative.clear();
	//interceptors
	m_unitsWhichCanIntercept.clear();
	//special promotions
	m_unitsAreaEffectPromotion.clear();

	// Loop through our units
	int iLoop = 0;
	for (CvUnit* pLoopUnit = firstUnit(&iLoop); pLoopUnit; pLoopUnit = nextUnit(&iLoop))
	{
		CvPlot* pPlot = pLoopUnit->plot();

		if (!pPlot)
		{
			continue;
		}

		if (pLoopUnit->IsCombatSupportUnit())
			m_unitsAreaEffectPositive.push_back(std::make_pair(pLoopUnit->GetID(), pPlot->GetPlotIndex()));

		if (pLoopUnit->getNearbyEnemyCombatMod() < 0)
			m_unitsAreaEffectNegative.push_back(std::make_pair(pLoopUnit->GetID(), pPlot->GetPlotIndex()));

		//do not include medics here, it kills performance
		//medics are range 1, they can easily be found by iterating the 6 neighbor plots
		if (pLoopUnit->isNearbyPromotion())
			m_unitsAreaEffectPromotion.push_back(std::make_pair(pLoopUnit->GetID(), pPlot->GetPlotIndex()));

		if (pLoopUnit->canIntercept())
			m_unitsWhichCanIntercept.push_back(std::make_pair(pLoopUnit->GetID(), pPlot->GetPlotIndex()));
	}

	//might need to update the UI
	//UpdateCityStrength();
}

void CvPlayer::UpdateAreaEffectPlots()
{
	//moai et al
	m_plotsAreaEffectPositiveFromTraits.clear();

	// Loop through our plots
	ImprovementTypes iTraitImprovement = GetPlayerTraits()->GetCombatBonusImprovementType();
	if (iTraitImprovement != NO_IMPROVEMENT)
	{
		for (int iPlotLoop = 0; iPlotLoop < GC.getMap().numPlots(); iPlotLoop++)
		{
			CvPlot* pPlot = GC.getMap().plotByIndexUnchecked(iPlotLoop);
			if (pPlot && pPlot->getOwner() == GetID() && pPlot->getImprovementType() == iTraitImprovement)
				m_plotsAreaEffectPositiveFromTraits.push_back(iPlotLoop);
		}
	}
}

const std::vector<std::pair<int, int>>& CvPlayer::GetAreaEffectPromotionUnits() const
{
	return m_unitsAreaEffectPromotion;
}
const std::vector<std::pair<int, int>>& CvPlayer::GetAreaEffectPositiveUnits() const
{
	return m_unitsAreaEffectPositive;
}

const std::vector<std::pair<int, int>>& CvPlayer::GetAreaEffectNegativeUnits() const
{
	return m_unitsAreaEffectNegative;
}

const std::vector<std::pair<int, int>>& CvPlayer::GetPossibleInterceptors() const
{
	return m_unitsWhichCanIntercept;
}

const std::vector<int>& CvPlayer::GetAreaEffectPositiveFromTraitsPlots() const
{
	return m_plotsAreaEffectPositiveFromTraits;
}

int CvPlayer::GetAreaEffectModifier(AreaEffectType eType, DomainTypes eDomain, const CvPlot* pTestPlot, const CvUnit* pIgnoreThisUnit) const
{
	int iResult = 0;
	if (pTestPlot == NULL)
		return 0;

	const std::vector<std::pair<int, int>>& possibleUnits = GetAreaEffectPositiveUnits();
	for (std::vector<std::pair<int, int>>::const_iterator it = possibleUnits.begin(); it != possibleUnits.end(); ++it)
	{
		//performance: very rough distance check first without looking up the unit pointer ...
		//do not reuse the plot below
		{
			CvPlot* pUnitPlot = GC.getMap().plotByIndexUnchecked(it->second);
			if (plotDistance(*pUnitPlot, *pTestPlot) > 8)
				continue;
		}

		CvUnit* pUnit = getUnit(it->first);
		//catch all sorts of weird problems (this may be called while a general is being killed!)
		if (pUnit == NULL || pUnit->isDelayedDeath() || pUnit->plot() == NULL || pUnit == pIgnoreThisUnit)
			continue;

		//domain check
		if (eDomain != NO_DOMAIN && pUnit->getDomainType() != eDomain)
			continue;

		int iEffectRange = pUnit->GetAuraRangeChange() + /*2*/ GD_INT_GET(GREAT_GENERAL_RANGE);

		//actual distance check
		int iDistance = plotDistance(*pUnit->plot(), *pTestPlot);
		if (iDistance > iEffectRange)
			continue;

		switch (eType)
		{
		case AE_GREAT_GENERAL:
		{
			if (pUnit->IsGreatGeneral() || pUnit->IsGreatAdmiral())
				iResult = max(iResult, GetGreatGeneralCombatBonus() + GetPlayerTraits()->GetGreatGeneralExtraBonus() + pUnit->GetAuraEffectChange());
			break;
		}
		case AE_SAPPER:
		{
			if (pUnit->IsSapper() && IsAtWarWith(pTestPlot->getOwner()))
			{
				if (iDistance < iEffectRange)
				{
					iResult = max(iResult, /*50 in CP, 40 in VP*/ GD_INT_GET(SAPPED_CITY_ATTACK_MODIFIER));
				}
				else if (iDistance == iEffectRange)
				{
					iResult = max(iResult, /*25 in CP, 20 in VP*/ GD_INT_GET(SAPPED_CITY_ATTACK_MODIFIER) / 2);
				}
			}
			break;
		}
		//case AE_SIEGETOWER:
		//{
			//if (pUnit->IsCityAttackSupport())
				//return 1; //just used as a boolean flag
			//break;
		//}
		}
	}

	return iResult;
}



	pLoopUnit = ::getUnit(*pUnitNode);
		pUnitNode = oldUnits.next(pUnitNode);
