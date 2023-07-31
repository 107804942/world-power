-- Lua Script2
-- Author: 11585
-- DateCreated: 2023/7/31 13:23:51
--------------------------------------------------------------
//------------------------------------------------------------------------------

----------------------------新政策属性----------------------------
function Knowledge_5or1(playerID)
    local player = Players[playerID]
    if player == nil or (not player:IsMajorCiv())
	then return 
	end

	----------------------------情报网络----------------------------
	if player:GetNumSpies() >= 1  and player:HasPolicy(GameInfo.Policies["POLICY_KNOWLEDGE_5"].ID) then
	local science = 0
	for k, v in pairs(player:GetEspionageSpies()) do
	local pSpyPlot = Map.GetPlot(v.CityX, v.CityY)
	local ecity = pSpyPlot:GetPlotCity() 
	if ecity:GetOwner() ~= player:GetID() then
	science = science + math.max(0,ecity:GetYieldRateTimes100(YieldTypes.YIELD_SCIENCE) / 100)
		end
	end
	local iTeamID = player:GetTeam()
	local iTeam = Teams[iTeamID]
	local iTeamTechs = iTeam:GetTeamTechs()
	ChangeResearchProcess(player, iTeamID, iTeam, iTeamTechs, playerID, science)
	end

end
GameEvents.PlayerDoTurn.Add(Knowledge_5or1)


//------------------------------------------------------------------------------
int CvLuaPlayer::lEspionageSetOutcome(lua_State* L)
{
	CvPlayer* pkPlayer = GetInstance(L);
	int iSpyIndex = lua_tointeger(L, 2);
	int iSpyResult = lua_tointeger(L, 3);
	bool bAffectsDiplomacy = lua_toboolean(L, 4);
	pkPlayer->GetEspionage()->SetOutcome(iSpyIndex, iSpyResult, bAffectsDiplomacy);

	return 0;
}


int CvLuaPlayer::lGetEspionageSpies(lua_State* L)
{
	CvPlayerAI* pkThisPlayer = GetInstance(L);
	CvPlayerEspionage* pkPlayerEspionage = pkThisPlayer->GetEspionage();

	lua_createtable(L, 0, 0);
	int index = 1;

	for(uint uiSpy = 0; uiSpy < pkPlayerEspionage->m_aSpyList.size(); ++uiSpy)
	{
		CvEspionageSpy* pSpy = &(pkPlayerEspionage->m_aSpyList[uiSpy]);

		lua_createtable(L, 0, 0);
		const int t = lua_gettop(L);

		lua_pushinteger(L, uiSpy);
		lua_setfield(L, t, "AgentID");

		lua_pushinteger(L, pSpy->m_iCityX);
		lua_setfield(L, t, "CityX");

		lua_pushinteger(L, pSpy->m_iCityY);
		lua_setfield(L, t, "CityY");

#if defined(MOD_BUGFIX_SPY_NAMES)
		const char* szSpyName = pSpy->GetSpyName(pkThisPlayer);
#else
		const char* szSpyName = pkThisPlayer->getCivilizationInfo().getSpyNames(pSpy->m_iName);
#endif
		lua_pushstring(L, szSpyName);
		lua_setfield(L, t, "Name");

		switch(pSpy->m_eRank)
		{
		case SPY_RANK_RECRUIT:
			lua_pushstring(L, "TXT_KEY_SPY_RANK_0");
			break;
		case SPY_RANK_AGENT:
			lua_pushstring(L, "TXT_KEY_SPY_RANK_1");
			break;
		case SPY_RANK_SPECIAL_AGENT:
			lua_pushstring(L, "TXT_KEY_SPY_RANK_2");
			break;
		default:
			CvAssertMsg(false, "pSpy->m_eRank not in case statement");
			break;
		}
		lua_setfield(L, t, "Rank");

		switch(pSpy->m_eSpyState)
		{
		case SPY_STATE_UNASSIGNED:
			lua_pushstring(L, "TXT_KEY_SPY_STATE_UNASSIGNED");
			break;
		case SPY_STATE_TRAVELLING:
			lua_pushstring(L, "TXT_KEY_SPY_STATE_TRAVELLING");
			break;
		case SPY_STATE_SURVEILLANCE:
			lua_pushstring(L, "TXT_KEY_SPY_STATE_SURVEILLANCE");
			break;
		case SPY_STATE_GATHERING_INTEL:
			lua_pushstring(L, "TXT_KEY_SPY_STATE_GATHERING_INTEL");
			break;
		case SPY_STATE_RIG_ELECTION:
			lua_pushstring(L, "TXT_KEY_SPY_STATE_RIGGING_ELECTION");
			break;
		case SPY_STATE_COUNTER_INTEL:
			lua_pushstring(L, "TXT_KEY_SPY_STATE_COUNTER_INTEL");
			break;
		case SPY_STATE_DEAD:
			lua_pushstring(L, "TXT_KEY_SPY_STATE_DEAD");
			break;
		case SPY_STATE_MAKING_INTRODUCTIONS:
			lua_pushstring(L, "TXT_KEY_SPY_STATE_MAKING_INTRODUCTIONS");
			break;
		case SPY_STATE_SCHMOOZE:
			lua_pushstring(L, "TXT_KEY_SPY_STATE_SCHMOOZING");
			break;
#if defined(MOD_API_LUA_EXTENSIONS) && defined(MOD_API_ESPIONAGE)
		case SPY_STATE_TERMINATED:
			lua_pushstring(L, "TXT_KEY_SPY_STATE_TERMINATED");
			break;
#endif
		default:
			CvAssertMsg(false, "pSpy->m_eSpyState not in case statement");
			break;
		}
		lua_setfield(L, t, "State");

		lua_pushinteger(L, pkPlayerEspionage->GetTurnsUntilStateComplete(uiSpy));
		lua_setfield(L, t, "TurnsLeft");

		lua_pushinteger(L, pkPlayerEspionage->GetPercentOfStateComplete(uiSpy));
		lua_setfield(L, t, "PercentComplete");

		lua_pushboolean(L, pkPlayerEspionage->HasEstablishedSurveillance(uiSpy));
		lua_setfield(L, t, "EstablishedSurveillance");

		lua_pushboolean(L, pkPlayerEspionage->IsDiplomat(uiSpy));
		lua_setfield(L, t, "IsDiplomat");

#if defined(MOD_API_LUA_EXTENSIONS) && defined(MOD_API_ESPIONAGE)
		lua_pushboolean(L, pSpy->m_bPassive);
		lua_setfield(L, t, "Passive");
#endif
		lua_rawseti(L, -2, index++);
	}
	return 1;
}