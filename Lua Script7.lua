

int CvLuaCity::lGetPlagueTurns(lua_State* L)
{
	CvCity* pkCity = GetInstance(L);
	lua_pushinteger(L, pkCity->GetPlagueTurns());
	return 1;
}


int CvLuaCity::lGetPlagueThreshold(lua_State* L)
{
	CvCity* pkCity = GetInstance(L);
	lua_pushinteger(L, pkCity->getPlagueThreshold());
	return 1;
}

int CvLuaCity::lGetPlagueTurnsAfter(lua_State* L)
{
	CvCity* pkCity = GetInstance(L);
	lua_pushinteger(L, pkCity->getPlagueTurnsAfter());
	return 1;
}




//	--------------------------------------------------------------------------------
bool CvUnit::canRebaseAt(int iXDest, int iYDest, bool bForced) const
{
	// If we can't rebase ANYWHERE then we definitely can't rebase at this X,Y
	if (!canRebase(bForced))
	{
		return false;
	}





	//	--------------------------------------------------------------------------------
bool CvUnit::canRebase(const CvPlot* /*pPlot*/) const
{
	// Must be an air unit
	if(getDomainType() != DOMAIN_AIR)
	{
		return false;
	}

	// Must be an "immobile" air unit (e.g. no helicopters)
	if(!IsImmobile())
	{
		return false;
	}

	// Must have movement points left this turn
	if(getMoves() <= 0)
	{
		return false;
	}

	return true;
}
