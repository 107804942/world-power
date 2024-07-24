
//	--------------------------------------------------------------------------------
// returns true if unit can initiate a war action with plot (possibly by declaring war)
bool CvUnit::potentialWarAction(const CvPlot* pPlot) const
{
	VALIDATE_OBJECT
	TeamTypes ePlotTeam = pPlot->getTeam();

	if(ePlotTeam == NO_TEAM)
	{
		return false;
	}

	if(isEnemy(ePlotTeam, pPlot))
	{
		return true;
	}

	if(IsDeclareWar())
	{
		return true;
	}

	return false;
}
