

	---std::stable_sort( vSettlePlots.begin(), vSettlePlots.end() );

		--std::stable_sort(it->second.begin(), it->second.end());

g_TotalBuildingIDs = 0
for eBuilding, pBuilding in GameInfo.Buildings() do
	g_TotalBuildingIDs = g_TotalBuildingIDs + 1
end


function GetCityCrimePerTurnAndToolTip(pCity)

     ----------------------------腐败----------------------------
	local strCorruptionToolTip = Locale.Lookup("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_CORRUPTION")
	local pPlayer = Players[pCity:GetOwner()]


	----来自商路
	local iCorruptionPerTurnFromTradeRoutes =  pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_TOTALTRADEROUTES"]) * 2

	local iCorruptionPerTurnFromBuildingMaintenance = 0;
	local iBuildingMaintenance = math.floor(pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_TOTALBUILDINGMAINTENANCE"]) / 4);
	if iBuildingMaintenance > 0 then iCorruptionPerTurnFromBuildingMaintenance = iCorruptionPerTurnFromBuildingMaintenance + iBuildingMaintenance end
	if iCorruptionPerTurnFromTradeRoutes > 0 or iCorruptionPerTurnFromBuildingMaintenance > 0 then
		strCorruptionToolTip = strCorruptionToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_CORRUPTION_BASE", iCorruptionPerTurnFromTradeRoutes + iCorruptionPerTurnFromBuildingMaintenance);
	end


	

	----来自快乐度
	local iCorruptionPerTurnFromHappiness = 0
	if Players[pCity:GetOwner()]:GetHappiness() - Players[pCity:GetOwner()]:GetUnhappiness() < 0 then
		iCorruptionPerTurnFromHappiness = (Players[pCity:GetOwner()]:GetHappiness() - Players[pCity:GetOwner()]:GetUnhappiness()) * -1
		strCorruptionToolTip = strCorruptionToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_CORRUPTION_HAPPINESS", iCorruptionPerTurnFromHappiness);
	end
	


	----来自建筑
	local iNCorruptionPerTurnFromBuildings = 0;
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_ASSEMBLY_HALL"]) == 1 then iNCorruptionPerTurnFromBuildings = 1 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_FACTORY"]) == 1 and pCity:GetNumRealBuilding(GameInfoTypes["EDICT_GENERAL_16_DUMMY"]) == 1 then iNCorruptionPerTurnFromBuildings = 5 end
	if iNCorruptionPerTurnFromBuildings > 0 then
		strCorruptionToolTip = strCorruptionToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_CORRUPTION_NBUILDINGS", iNCorruptionPerTurnFromBuildings);
	end

	local iCorruptionPerTurnFromBuildings = 0;
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_JAIL"]) == 1 then iCorruptionPerTurnFromBuildings = iCorruptionPerTurnFromBuildings - 1 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_CONSTABLE"]) == 1 then iCorruptionPerTurnFromBuildings = iCorruptionPerTurnFromBuildings - 3 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_PRISON"]) == 1 then iCorruptionPerTurnFromBuildings = iCorruptionPerTurnFromBuildings - 5 end
	if iCorruptionPerTurnFromBuildings < 0 then
		strCorruptionToolTip = strCorruptionToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_CORRUPTION_BUILDINGS", iCorruptionPerTurnFromBuildings);
	end

	local iCorruptionPerTurnFromTaxEvasion = 0;
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_MARKET"]) == 1 then iCorruptionPerTurnFromTaxEvasion = iCorruptionPerTurnFromTaxEvasion + 1 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_STOCK_EXCHANGE"]) == 1 then iCorruptionPerTurnFromTaxEvasion = iCorruptionPerTurnFromTaxEvasion + 4 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_BANK"]) == 1 then iCorruptionPerTurnFromTaxEvasion = iCorruptionPerTurnFromTaxEvasion + 3 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_COURTHOUSE"]) == 1 then iCorruptionPerTurnFromTaxEvasion = iCorruptionPerTurnFromTaxEvasion + 1 end
	if pCity:GetNumRealBuilding(GameInfoTypes["EDICT_IMPERIALISM_1_DUMMY"]) == 1 then iCorruptionPerTurnFromTaxEvasion = iCorruptionPerTurnFromTaxEvasion + 3 end
	if pCity:GetNumRealBuilding(GameInfoTypes["EDICT_MONARCHY_2_DUMMY"]) == 1 then iCorruptionPerTurnFromTaxEvasion = iCorruptionPerTurnFromTaxEvasion + 5 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_WEIGHT_HOUSE"]) ~= nil then 
		if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_WEIGHT_HOUSE"]) == 1 then iCorruptionPerTurnFromTaxEvasion = iCorruptionPerTurnFromTaxEvasion + 2 end
	end
	if iCorruptionPerTurnFromTaxEvasion > 0 then
		strCorruptionToolTip = strCorruptionToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_CORRUPTION_TAX", iCorruptionPerTurnFromTaxEvasion);
	end

	----来自政策
	local iCorruptionPerTurnFromPolicies = 0;
	if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["POLICY_LIBERTY_CRIME"]) then iCorruptionPerTurnFromPolicies = iCorruptionPerTurnFromPolicies + 3 end
	if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["POLICY_LIBERTY_CRIME_NATIONALISM"]) then iCorruptionPerTurnFromPolicies = iCorruptionPerTurnFromPolicies + 3 end
	if iCorruptionPerTurnFromPolicies > 0 then
		strCorruptionToolTip = strCorruptionToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_CORRUPTION_POLICIES", iCorruptionPerTurnFromPolicies);
	end
	

	----来自间谍
	local iCorruptionPerTurnFromSpies = 0;
	for i,v in ipairs(Players[pCity:GetOwner()]:GetEspionageSpies()) do
		local plot = Map.GetPlot(v.CityX, v.CityY);
		if(plot ~= nil) then
			local city = plot:GetPlotCity();
			if(city ~= nil) then
				if city == pCity then
					iCorruptionPerTurnFromSpies = -6
					strCorruptionToolTip = strCorruptionToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_CORRUPTION_SPIES", iCorruptionPerTurnFromSpies);
				end
			end
		end
	end



	local iCorruptionPerTurn = iCorruptionPerTurnFromTradeRoutes + iCorruptionPerTurnFromBuildingMaintenance + iCorruptionPerTurnFromPolicies + iCorruptionPerTurnFromBuildings + iCorruptionPerTurnFromLoyalty + iCorruptionPerTurnFromTaxEvasion + iCorruptionPerTurnFromSpies + iCorruptionPerTurnFromVirtues + iCorruptionPerTurnFromHappiness + iNCorruptionPerTurnFromBuildings + iCorruptionPerTurnFromEdicts
	

	----来自宗教
	local iCorruptionPerTurnFromBeliefs = 0;
	if pCity:GetReligiousMajority() > 0 and iCorruptionPerTurn > 0 and math.floor(pCity:GetFaithPerTurn() / 2) > 0 then
		for i,v in ipairs(Game.GetBeliefsInReligion(pCity:GetReligiousMajority())) do
			if GameInfo.Beliefs[v].Type == "BELIEF_CRIME_2" then 
				iCorruptionPerTurnFromBeliefs = math.floor(pCity:GetFaithPerTurn() / 2) * -1
			end
		end
	end
	if GameInfoTypes["BELIEF_SHARIA"] ~= nil then
		if (pPlayer:HasCreatedReligion()) then
			local eReligion = pPlayer:GetReligionCreatedByPlayer();
			for i,v in ipairs(Game.GetBeliefsInReligion(eReligion)) do
				local pBelief = GameInfo.Beliefs[v];
				if pBelief.Type == "BELIEF_SHARIA" then
					bHasSharia = true
				end
			end
		end
	end
	if bHasSharia then
		iCorruptionPerTurnFromBeliefs = 2
		if pCity:GetReligiousMajority() == pPlayer:GetReligionCreatedByPlayer() then iCorruptionPerTurnFromBeliefs = -1 end
	end
	if iCorruptionPerTurnFromBeliefs < 0 then
		strCorruptionToolTip = strCorruptionToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_CORRUPTION_BELIEFS", iCorruptionPerTurnFromBeliefs);
	end

	iCorruptionPerTurn = iCorruptionPerTurn + iCorruptionPerTurnFromBeliefs
	
	if iCorruptionPerTurn < 0 then iCorruptionPerTurn = 0 end
	if iCorruptionPerTurn > pCity:GetYieldRateTimes100(YieldTypes.YIELD_GOLD) / 100 then iCorruptionPerTurn = pCity:GetYieldRateTimes100(YieldTypes.YIELD_GOLD) / 100 end
	if iCorruptionPerTurn == 0 then
		strCorruptionToolTip = strCorruptionToolTip .. Locale.Lookup("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_CORRUPTION_TOTAL_0ORLESS") --.. "[NEWLINE]" 
	else
		strCorruptionToolTip = strCorruptionToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_CORRUPTION_TOTAL_POSITIVE", iCorruptionPerTurn);
	end










	----------------------------暴力----------------------------


	local strViolenceToolTip = Locale.Lookup("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_VIOLENCE")

	local iViolencePerTurnFromPoverty = 0;   ---贫困
	local iGPT = pCity:GetBaseYieldRate(GameInfoTypes["YIELD_GOLD"])
	if pCity:GetPopulation() > iGPT then iViolencePerTurnFromPoverty = (iGPT - pCity:GetPopulation()) * -1 end
	if iViolencePerTurnFromPoverty > math.floor(pCity:GetPopulation() / 3) then iViolencePerTurnFromPoverty = math.floor(pCity:GetPopulation() / 3) end
	if iViolencePerTurnFromPoverty > 0 then
		strViolenceToolTip = strViolenceToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_VIOLENCE_POVERTY", iViolencePerTurnFromPoverty);
	end

	local iViolencePerTurnFromDisorder = 0;   ---混乱
	local iOrderBuildingCount = 0
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_PALACE"]) == 1 then iOrderBuildingCount = iOrderBuildingCount + 1 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_BARRACKS"]) == 1 then iOrderBuildingCount = iOrderBuildingCount + 1 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_JAIL"]) == 1 then iOrderBuildingCount = iOrderBuildingCount + 1 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_COURTHOUSE"]) == 1 then iOrderBuildingCount = iOrderBuildingCount + 1 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_CONSTABLE"]) == 1 then iOrderBuildingCount = iOrderBuildingCount + 1 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_POLICE_STATION"]) == 1 then iOrderBuildingCount = iOrderBuildingCount + 1 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_CASTLE"]) == 1 then iOrderBuildingCount = iOrderBuildingCount + 1 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_PRISON"]) == 1 then iOrderBuildingCount = iOrderBuildingCount + 1 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_MILITARY_BASE"]) == 1 then iOrderBuildingCount = iOrderBuildingCount + 1 end
	if math.floor(pCity:GetPopulation() / 3) > iOrderBuildingCount then iViolencePerTurnFromDisorder = math.floor(pCity:GetPopulation() / 3) - iOrderBuildingCount end
	if iViolencePerTurnFromDisorder > 0 then
		strViolenceToolTip = strViolenceToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_VIOLENCE_DISORDER", iViolencePerTurnFromDisorder);
	end
	
	local iViolencePerTurnFromOpinion = 0;
	local iOpinion = Players[pCity:GetOwner()]:GetPublicOpinionType()
	if (iOpinion == PublicOpinionTypes.PUBLIC_OPINION_DISSIDENTS) then
		iViolencePerTurnFromOpinion = 1
	elseif (iOpinion == PublicOpinionTypes.PUBLIC_OPINION_CIVIL_RESISTANCE) then
		iViolencePerTurnFromOpinion = 4
	elseif (iOpinion == PublicOpinionTypes.PUBLIC_OPINION_REVOLUTIONARY_WAVE) then
		iViolencePerTurnFromOpinion = 10
	end
	if iViolencePerTurnFromOpinion > 0 then
		strViolenceToolTip = strViolenceToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_VIOLENCE_OPINION", iViolencePerTurnFromOpinion);
	end

	local iViolencePerTurnFromPlague = 0;
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_PLAGUE_TIMER"]) > 0 then
		iViolencePerTurnFromPlague = 3
		strViolenceToolTip = strViolenceToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_VIOLENCE_PLAGUE", 3);
	end

	local iViolencePerTurnFromResistance = 0;
	if pCity:GetResistanceTurns() > 0 then
		iViolencePerTurnFromResistance = 3
		strViolenceToolTip = strViolenceToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_VIOLENCE_RESISTANCE", 3);
	end

	local iViolencePerTurnFromEdicts = 0;
	if pCity:GetNumRealBuilding(GameInfoTypes["EDICT_HONOR_3_DUMMY"]) == 1 and pCity:GetGarrisonedUnit() ~= nil then 
		iViolencePerTurnFromEdicts = iViolencePerTurnFromEdicts - 1
	end
	if pCity:GetNumRealBuilding(GameInfoTypes["EDICT_NEOLITHIC_2_DUMMY"]) == 1 then 
		iViolencePerTurnFromEdicts = iViolencePerTurnFromEdicts - 1
	end
	if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["DUMMY_EDICT_ISKA_FUTURE_3"]) then iViolencePerTurnFromEdicts = iViolencePerTurnFromEdicts - 10 end
	if iViolencePerTurnFromEdicts < 0 then 
		strViolenceToolTip = strViolenceToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_VIOLENCE_EDICTS", iViolencePerTurnFromEdicts);
	end



	local iViolencePerTurnFromBuildings = 0;
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_JAIL"]) == 1 then iViolencePerTurnFromBuildings = iViolencePerTurnFromBuildings - 2 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_COURTHOUSE"]) == 1 then 
		if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["EDICT_IMPERIALISM_1_DUMMY"]) then
			iViolencePerTurnFromBuildings = iViolencePerTurnFromBuildings - 1
		 end
	end
	if pCity:GetNumRealBuilding(GameInfoTypes["EDICT_TRADITION_2_DUMMY"]) == 1 then iViolencePerTurnFromBuildings = iViolencePerTurnFromBuildings - 3 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_CONSTABLE"]) == 1 then 
		if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["POLICY_COMMERCE_CRIME"]) then 
			iViolencePerTurnFromBuildings = iViolencePerTurnFromBuildings - 7
			if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["POLICY_COMMERCE_CRIME_NATIONALISM"]) then 
				iViolencePerTurnFromBuildings = iViolencePerTurnFromBuildings - 11
			end
		else
			iViolencePerTurnFromBuildings = iViolencePerTurnFromBuildings - 3 
		end
	end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_POLICE_STATION"]) == 1 then iViolencePerTurnFromBuildings = iViolencePerTurnFromBuildings - math.floor(pCity:GetPopulation() / 4) end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_PRISON"]) == 1 then iViolencePerTurnFromBuildings = iViolencePerTurnFromBuildings - 5 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_FACTORY"]) == 1 then 
		if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["EDICT_COMMERCE_3_DUMMY"]) then
			iViolencePerTurnFromBuildings = iViolencePerTurnFromBuildings + 2
		 end
	end
	if iViolencePerTurnFromBuildings < 0 then
		strViolenceToolTip = strViolenceToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_VIOLENCE_BUILDINGS", iViolencePerTurnFromBuildings);
	end
	
	local iViolencePerTurnFromPolicies = 0; 
	if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["POLICY_HONOR_CRIME"]) then iViolencePerTurnFromPolicies = iViolencePerTurnFromPolicies - 2 end
	if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["POLICY_HONOR_CRIME_NATIONALISM"]) then iViolencePerTurnFromPolicies = iViolencePerTurnFromPolicies - 2 end
	if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["CIVIC_POLICE_STATE"]) then iViolencePerTurnFromPolicies = iViolencePerTurnFromPolicies - 4 end
	if iViolencePerTurnFromPolicies < 0 then
		strViolenceToolTip = strViolenceToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_VIOLENCE_POLICIES", iViolencePerTurnFromPolicies);
	end



	local iViolencePerTurn = iViolencePerTurnFromOpinion + iViolencePerTurnFromDisorder + iViolencePerTurnFromPoverty + iViolencePerTurnFromBuildings + iViolencePerTurnFromPolicies + iViolencePerTurnFromPlague + iViolencePerTurnFromVirtues + iViolencePerTurnFromEdicts + iViolencePerTurnFromHousing
	
	local iViolencePerTurnFromBeliefs = 0;
	if pCity:GetReligiousMajority() > 0 and iViolencePerTurn > 0 then
		if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_TEMPLE"]) == 1 then
			for i,v in ipairs(Game.GetBeliefsInReligion(pCity:GetReligiousMajority())) do
				if GameInfo.Beliefs[v].Type == "BELIEF_CRIME_1" then 
					iViolencePerTurnFromBeliefs = iViolencePerTurn * -1 
					iViolencePerTurn = 0 
				end
			end
		end
	end
	if iViolencePerTurnFromBeliefs < 0 then
		strViolenceToolTip = strViolenceToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_VIOLENCE_BELIEFS", iViolencePerTurnFromBeliefs);
	end
	
	if iViolencePerTurn < 0 then iViolencePerTurn = 0 end
	if iViolencePerTurn == 0 then
		strViolenceToolTip = strViolenceToolTip .. Locale.Lookup("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_VIOLENCE_TOTAL_0ORLESS") --"[NEWLINE]" .. 
	else
		strViolenceToolTip = strViolenceToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_VIOLENCE_TOTAL_POSITIVE", iViolencePerTurn);
	end
	


	----------------------------盗窃----------------------------
	local strTheftToolTip = Locale.Lookup("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_THEFT")

	local iTheftPerTurnFromCitySize = math.floor((pCity:GetPopulation() + pCity:CountNumImprovedPlots()) / 3)
	if pCity:GetNumRealBuilding(GameInfoTypes["EDICT_GENERAL_10_DUMMY"]) == 1 then iTheftPerTurnFromCitySize = iTheftPerTurnFromCitySize + 2 end
	if iTheftPerTurnFromCitySize > 0 then
		strTheftToolTip = strTheftToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_THEFT_BASE", iTheftPerTurnFromCitySize);
	end



	local iTheftPerTurnFromEdicts = 0;
	if pCity:GetGarrisonedUnit() ~= nil then
		if pCity:GetNumRealBuilding(GameInfoTypes["EDICT_HONOR_3_DUMMY"]) == 1 and pCity:GetGarrisonedUnit():GetBaseRangedCombatStrength() ~= nil then
			iTheftPerTurnFromEdicts = iTheftPerTurnFromEdicts - 1
		end
	end
	if pCity:GetNumRealBuilding(GameInfoTypes["EDICT_NEOLITHIC_2_DUMMY"]) == 1 then
		iTheftPerTurnFromEdicts = iTheftPerTurnFromEdicts - 1
	end
	if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["DUMMY_EDICT_ISKA_FUTURE_3"]) then iTheftPerTurnFromEdicts = iTheftPerTurnFromEdicts - 10 end
	if iTheftPerTurnFromEdicts < 0 then 
		strTheftToolTip = strTheftToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_THEFT_EDICTS", iTheftPerTurnFromEdicts);
	end

	local iTheftPerTurnFromBuildings = 0;
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_JAIL"]) == 1 then iTheftPerTurnFromBuildings = iTheftPerTurnFromBuildings - 2 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_COURTHOUSE"]) == 1 then 
		if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["EDICT_IMPERIALISM_1_DUMMY"]) then
			iTheftPerTurnFromBuildings = iTheftPerTurnFromBuildings - 1
		 end
	end
	if pCity:GetNumRealBuilding(GameInfoTypes["EDICT_TRADITION_2_DUMMY"]) == 1 then iTheftPerTurnFromBuildings = iTheftPerTurnFromBuildings - 3 end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_CONSTABLE"]) == 1 then 
		if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["POLICY_COMMERCE_CRIME"]) then
			 iTheftPerTurnFromBuildings = iTheftPerTurnFromBuildings - 7
			if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["POLICY_COMMERCE_CRIME_NATIONALISM"]) then 
				iTheftPerTurnFromBuildings = iTheftPerTurnFromBuildings - 11
			end
		else
			iTheftPerTurnFromBuildings = iTheftPerTurnFromBuildings - 3
		 end
	end

	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_POLICE_STATION"]) == 1 then iTheftPerTurnFromBuildings = iTheftPerTurnFromBuildings - math.floor(pCity:GetPopulation() / 4) end
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_PRISON"]) == 1 then iTheftPerTurnFromBuildings = iTheftPerTurnFromBuildings - 5 end
	
	if iTheftPerTurnFromBuildings < 0 then
		strTheftToolTip = strTheftToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_THEFT_BUILDINGS", iTheftPerTurnFromBuildings);
	end
	
	local iTheftPerTurnFromPolicies = 0;
	if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["POLICY_HONOR_CRIME"]) then iTheftPerTurnFromPolicies = iTheftPerTurnFromPolicies + 1 end
	if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["POLICY_HONOR_CRIME_NATIONALISM"]) then iTheftPerTurnFromPolicies = iTheftPerTurnFromPolicies + 1 end
	if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["CIVIC_POLICE_STATE"]) then iTheftPerTurnFromPolicies = iTheftPerTurnFromPolicies + 4 end
	if iTheftPerTurnFromPolicies > 0 then
		strTheftToolTip = strTheftToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_THEFT_POLICIES", iTheftPerTurnFromPolicies * -1);
	end



	local iTheftPerTurn = iTheftPerTurnFromCitySize + iTheftPerTurnFromBuildings - iTheftPerTurnFromPolicies + iTheftPerTurnFromVirtues + iTheftPerTurnFromEdicts + iTheftPerTurnFromHousing
	if pCity:IsFoodProduction() then iTheftPerTurn = 0 end
	if iTheftPerTurn < 0 then iTheftPerTurn = 0 end
	if iTheftPerTurn > pCity:GetCurrentProductionDifferenceTimes100(false, false) / 100 then iTheftPerTurn = pCity:GetProduction() end
	if iTheftPerTurn == 0 then
		strTheftToolTip = strTheftToolTip .. Locale.Lookup("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_THEFT_TOTAL_0ORLESS") --"[NEWLINE]" .. 
	else
		strTheftToolTip = strTheftToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_THEFT_TOTAL_POSITIVE", iTheftPerTurn);
	end



	----------------------------邪教----------------------------
	local strHeresyToolTip = Locale.Lookup("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_HERESY")

	local iHeresyPerTurnFromDiscord = 0;
	if pCity:GetReligiousMajority() > 0 and pCity:GetNumFollowers(pCity:GetReligiousMajority()) ~= pCity:GetPopulation() then
		iHeresyPerTurnFromDiscord = pCity:GetPopulation() - pCity:GetNumFollowers(pCity:GetReligiousMajority())
	end
	if iHeresyPerTurnFromDiscord > 0 then
		strHeresyToolTip = strHeresyToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_HERESY_DISCORD", iHeresyPerTurnFromDiscord);
	end

	local iHeresyPerTurnFromDarkAge = 0;
	if Players[pCity:GetOwner()]:GetCapitalCity() then
		if Players[pCity:GetOwner()]:GetCapitalCity():GetNumRealBuilding(GameInfoTypes["BUILDING_DARKAGE"]) > 0 then
			iHeresyPerTurnFromDarkAge = 5
		end
		if iHeresyPerTurnFromDarkAge > 0 then
			strHeresyToolTip = strHeresyToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_HERESY_DARK_AGE", iHeresyPerTurnFromDarkAge);
		end
	end

	local iHeresyPerTurnFromBuildings = 0;
	if pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_TEMPLE"]) == 1 then iHeresyPerTurnFromBuildings = iHeresyPerTurnFromBuildings - 3 end
	if iHeresyPerTurnFromBuildings < 0 then
		strHeresyToolTip = strHeresyToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_HERESY_BUILDINGS", iHeresyPerTurnFromBuildings);
	end

	local iHeresyPerTurnFromPolicies = 0;
	if Players[pCity:GetOwner()]:HasPolicy(GameInfoTypes["CIVIC_THEOCRACY"]) then iHeresyPerTurnFromPolicies = iHeresyPerTurnFromPolicies + pCity:GetNumRealBuilding(GameInfoTypes["BUILDING_SHRINE"]) * -1 end
	if iHeresyPerTurnFromPolicies < 0 then
		strHeresyToolTip = strHeresyToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_HERESY_BUILDINGS", iHeresyPerTurnFromPolicies);
	end



	local iHeresyPerTurn = iHeresyPerTurnFromDiscord + iHeresyPerTurnFromDarkAge + iHeresyPerTurnFromBuildings + iHeresyPerTurnFromPolicies + iHeresyPerTurnFromVirtues
	if iHeresyPerTurn > pCity:GetFaithPerTurn() then iHeresyPerTurn = pCity:GetFaithPerTurn() end
	if iHeresyPerTurn < 0 then iHeresyPerTurn = 0 end
	if iHeresyPerTurn == 0 then
		strHeresyToolTip = strHeresyToolTip .. Locale.Lookup("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_HERESY_TOTAL_0ORLESS") --"[NEWLINE]" .. 
	else
		strHeresyToolTip = strHeresyToolTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_HEADER_HERESY_TOTAL_POSITIVE", iHeresyPerTurn);
	end

	local iCrimePerTurn = iViolencePerTurn + iCorruptionPerTurn + iTheftPerTurn + iHeresyPerTurn
	local strCrimeToolTip = strCorruptionToolTip .. strViolenceToolTip .. strTheftToolTip .. strHeresyToolTip
	if iCrimePerTurn > 0 then strCrimeToolTip = strCrimeToolTip .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_FOOTER_NEGATIVE", iCrimePerTurn) 
	else strCrimeToolTip = strCrimeToolTip .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_FOOTER_POSITIVE", iCrimePerTurn) end

	return iCrimePerTurn, strCrimeToolTip, iViolencePerTurn, strViolenceToolTip, iCorruptionPerTurn, strCorruptionToolTip, iTheftPerTurn, strTheftToolTip, iHeresyPerTurn, strHeresyToolTip
end







