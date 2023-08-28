-- Lua Script8
-- Author: 11585
-- DateCreated: 2023/8/28 22:55:49
--------------------------------------------------------------
	// Loop through adding the available units
	for (int iUnitLoop = 0; iUnitLoop < GC.getNumUnitInfos(); iUnitLoop++)
	{
		UnitTypes eLoopUnit = (UnitTypes)iUnitLoop;
		if (eLoopUnit != NO_UNIT)
		{
			int iNewHeal = 0;
			iNewHeal = pBuildingInfo->GetUnitTypePrmoteHealGlobal(eLoopUnit);
			if (iNewHeal > 0)
			{
				ChangeUnitTypePrmoteHealGlobal(eLoopUnit, iNewHeal);
			}
		}
	}




	//Building_UnitTypePrmoteHealGlobal
	{
		std::string strKey("Building_UnitTypePrmoteHealGlobal");
		Database::Results* pResults = kUtility.GetResults(strKey);
		if (pResults == NULL)
		{
			pResults = kUtility.PrepareResults(strKey, "select Units.ID as UnitID, Heal from Building_UnitTypePrmoteHealGlobal inner join Units on Units.Type = UnitType where BuildingType = ?");
		}

		pResults->Bind(1, szBuildingType);

		while (pResults->Step())
		{
			const int iUnit = pResults->GetInt(0);
			const int iHeal = pResults->GetInt(1);

			m_piUnitTypePrmoteHealGlobal[iUnit] += iHeal;
		}

		pResults->Reset();

		//Trim extra memory off container since this is mostly read-only.
		std::map<int, int>(m_piUnitTypePrmoteHealGlobal).swap(m_piUnitTypePrmoteHealGlobal);
	}




	TXT_KEY_PROMOTION_AIR_SWEEP

	TXT_KEY_AIR_PATROL_BOMBED_GROUND_TARGETS

	strAppendText =  GetLocalizedText("TXT_KEY_MISC_YOU_UNIT_WAS_DAMAGED_ATTRITION");
#if defined(MOD_API_UNIT_STATS)
				changeDamage(getEnemyDamage(), NO_PLAYER, -1, 0.0, &strAppendText);
#else
				changeDamage(getEnemyDamage(), NO_PLAYER, 0.0, &strAppendText);
#endif