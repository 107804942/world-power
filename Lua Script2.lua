-- Lua Script2
-- Author: 11585
-- DateCreated: 2023/7/31 13:23:51
--------------------------------------------------------------
--------------------------------------------------------------------------------
--m_iPopulationChange(0),
--m_iMinorCivFriendship(0),


	
					--[[else if (MOD_ROG_CORE && eUnitClass == GC.getInfoTypeForString("UNITCLASS_GREAT_DOCTOR", true /*bHideAssert*/))
					{
						eBranch = (PolicyBranchTypes)GC.getInfoTypeForString("POLICY_BRANCH_RATIONALISM", true /*bHideAssert*/);
						iNum = kPlayer.getDoctorsFromFaith();
					}
	

#if defined(MOD_ROG_CORE)
			if (MOD_ROG_CORE) {
				CvBuildingEntry* pkBuildingInfo = GC.getBuildingInfo(eBuilding);
				int iCost = pkBuildingInfo->GetProductionCost();
				iCost *= GC.getGame().getGameSpeedInfo().getConstructPercent();
				iCost /= 100;
				if (iChange > 0 && GetYieldFromConstruction(eYield) > 0)
				{
					iCost *= GetYieldFromConstruction(eYield) / 100;
					doInstantYield(eYield, iCost);
				}
			}
#endif


			else if (MOD_ROG_CORE && eUnitClass == GC.getInfoTypeForString("UNITCLASS_GREAT_DOCTOR"))
			{
				kPlayer.incrementGeneralsFromFaith();
			}]]


			-- ****************************************
--
-- ****************************************	
function EspionageCanMove(iPlayer, iCityOwner, iCity) 
   local Player = Players[iPlayer]   
   local otherPlayer=Players[iCityOwner]
   if Player~= otherPlayer then 
      return not otherPlayer:HasWonder(GameInfoTypes.BUILDING_KGB)
   end
   return true
end 	
GameEvents.EspionageCanMoveSpyTo.Add(EspionageCanMove)  

		
-- ********************************************************
-- 乌尔班效果
-- ******************************************************** 
	if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_URBAN"].ID) then	        
			local textcount = 0
		    local unitCount = defPlot:GetNumUnits();
		    if unitCount > 0 then
			for i = 0, unitCount-1, 1 do
				local pFoundUnit = defPlot:GetUnit(i)
				if attPlayer:IsAtWarWith(pFoundUnit:GetOwner())   then
				if   not pFoundUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_ANTI_DEBUFF"].ID) then
					pFoundUnit:SetMoves(0);     
		               end
					end
				end
			end

			----------------------------------------------------------------------------------------------------------------------------
			local TileRadius = 2
	        for dx = -TileRadius, TileRadius - 1, 1 do
	        for dy = -TileRadius, TileRadius - 1, 1 do
            local loopPlot = Map.PlotXYWithRangeCheck(defUnit:GetX(), defUnit:GetY(), dx, dy, 1)
			if (loopPlot ~= nil and not loopPlot:IsCity()) then
                unitNum = loopPlot:GetNumUnits();
                if unitNum > 0 then
           for i = 0, unitNum-1, 1 do
           local pFoundUnit = loopPlot:GetUnit(i);
           if    pFoundUnit ~=defUnit and  not pFoundUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_ANTI_DEBUFF"].ID)  then	
	       if attPlayer:IsAtWarWith(pFoundUnit:GetOwner())   then

		   local randomNumber = ROG_GetTrueRandom(1, 100)
		   if randomNumber <=50 then
		   textcount = textcount+1
		   pFoundUnit:SetMoves(0)
		                            end
					            end
				             end
			              end
		               end
					end
				 end
			 end  	    
		 -- Notification
		    if textcount==0 then
		    if    defPlayer:IsHuman() then
			local heading = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_US_URBAN_SHORT")
			local text = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_US_URBAN")
			defPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC , text, heading, defUnit:GetX(), defUnit:GetY())
		    elseif attPlayer:IsHuman() then
			local heading = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_ENEMY_URBAN_SHORT")
			local text = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_ENEMY_URBAN")
			attPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC , text, heading, defUnit:GetX(), defUnit:GetY())
		       end
		    end
		   -- Notification
		    if textcount>0 then
		    if    defPlayer:IsHuman() then
			local heading = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_US_URBAN_SHORT")
			local text = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_US_URBAN2")
			defPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC , text, heading, defUnit:GetX(), defUnit:GetY())
		    elseif attPlayer:IsHuman() then
			local heading = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_ENEMY_URBAN_SHORT")
			local text = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_ENEMY_URBAN2")
			attPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC , text, heading, defUnit:GetX(), defUnit:GetY())
		      end
		   end
		end






function UnitNearIronBeddhaKilled(iPlayer, iUnit, iUnitType, iX, iY, bDelay, iByPlayer)

	local pPlayer = Players[iPlayer]
	local pUnit = pPlayer:GetUnitByID(iUnit)		
	
	if iPlayer == -1  then return end -- 被毁灭单位所属文明
	if pUnit == -1  then return end -- 被毁灭单位	
	if not pUnit:IsCombatUnit() then return end ---非战斗单位
	--if iPlayer == iByPlayer  then return end --只能被其他文明摧毁
	--if iByPlayer == -1   then return end
    --local Plot =  pUnit:GetPlot()

	local Plot = Map.GetPlot(iX, iY)		
	for pAdjacentPlot in PlotAreaSweepIterator(Plot, 5, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		for iVal = 0,(pAdjacentPlot:GetNumUnits() - 1) do
			 local loopUnit = pAdjacentPlot:GetUnit(iVal)
			 if   loopUnit:IsHasPromotion(GameInfoTypes.PROMOTION_ANTI_ANTI_MOUNTED_BONUS) 
			 and  loopUnit:GetMoves() < 6*GameDefines["MOVE_DENOMINATOR"] 
			 and  not loopUnit:IsHasPromotion(GameInfoTypes.PROMOTION_NO_CHARGE_BONUS)  then
			   loopUnit:ChangeMoves(0.5*GameDefines["MOVE_DENOMINATOR"])
			   print("Unit Near IronBeddha Killed!")
			end
        end
	end
end
GameEvents.UnitPrekill.Add(UnitNearIronBeddhaKilled)

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





	//SpecialistYieldModifiers
	{
		kUtility.Initialize2DArray(m_ppaiSpecialistYieldModifier, "Specialists", "Yields");

		std::string strKey("Building_SpecialistYieldModifiers");
		Database::Results* pResults = kUtility.GetResults(strKey);
		if (pResults == NULL)
		{
			pResults = kUtility.PrepareResults(strKey, "select Specialists.ID as SpecialistID, Yields.ID as YieldID, Yield from Building_SpecialistYieldModifiers inner join Specialists on Specialists.Type = SpecialistType inner join Yields on Yields.Type = YieldType where BuildingType = ?");
		}

		pResults->Bind(1, szBuildingType);

		while (pResults->Step())
		{
			const int SpecialistID = pResults->GetInt(0);
			const int YieldID = pResults->GetInt(1);
			const int yield = pResults->GetInt(2);

			m_ppaiSpecialistYieldModifier[SpecialistID][YieldID] = yield;
		}
	}


	//Building_SpecialistYieldModifiersGlobal
	{

		kUtility.Initialize2DArray(m_ppaiSpecialistYieldModifierGlobal, "Specialists", "Yields");

		std::string strKey("Building_SpecialistYieldModifiersGlobal");
		Database::Results* pResults = kUtility.GetResults(strKey);
		if (pResults == NULL)
		{
			pResults = kUtility.PrepareResults(strKey, "select Specialists.ID as SpecialistID, Yields.ID as YieldID, Yield from Building_SpecialistYieldModifiersGlobal inner join Specialists on Specialists.Type = SpecialistType inner join Yields on Yields.Type = YieldType where BuildingType = ?");
		}

		pResults->Bind(1, szBuildingType);

		while (pResults->Step())
		{
			const int SpecialistID = pResults->GetInt(0);
			const int YieldID = pResults->GetInt(1);
			const int yield = pResults->GetInt(2);

			m_ppaiSpecialistYieldModifierGlobal[SpecialistID][YieldID] = yield;
		}
	}