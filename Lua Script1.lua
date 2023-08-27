-- Lua Script1
-- Author: 11585
-- DateCreated: 2023/7/26 0:13:52
--------------------------------------------------------------

	--if IsCivBE then
		-- Affinity Level Requirement
		--for affinityPrereq in GameInfo.Project_AffinityPrereqs{ ProjectType = project.Type } do
			--local affinityInfo = (tonumber( affinityPrereq.Level) or 0 ) > 0 and GameInfo.Affinity_Types[ affinityPrereq.AffinityType ]
			--if affinityInfo then
				--insert( tips, L( "TXT_KEY_AFFINITY_LEVEL_REQUIRED", affinityInfo.ColorType, affinityPrereq.Level, affinityInfo.IconString or "?", affinityInfo.Description or "???" ) )
			--end
		--end
	--end

--GetEspionageSpies


	--pMinorCapital->ChangeResistanceTurns(-pMinorCapital->GetResistanceTurns());



	function OnPillageDamageEnemies(iPlayer, iUnit, iImprovement, iGold)
	local pPlayer = Players[iPlayer]
	local pUnit = pPlayer:GetUnitByID(iUnit)
	if pPlayer == nil or (not pPlayer:IsMajorCiv()) or pUnit== nil then
	 	return
	         end 
	------------------------------------------------------------------
	  if pUnit:IsHasPromotion(GameInfoTypes.PROMOTION_PLUNDERED) then
	
		local iGameSpeedModifier1 = GameInfo.GameSpeeds[ Game.GetGameSpeedType() ].FaithPercent / 100
		local iGameSpeedModifier3 = GameInfo.GameSpeeds[ Game.GetGameSpeedType() ].GoldPercent / 100
		local iEraModifier = math.max(pPlayer:GetCurrentEra(), 1)
					
		local iGain1 = math.floor(10 * iGameSpeedModifier1 * iEraModifier)
		local iGain3 = math.floor(15 * iGameSpeedModifier3 * iEraModifier)
					
		pPlayer:ChangeFaith(iGain1)
		pPlayer:ChangeGold(iGain3)
		pUnit:ChangeDamage(-25)
		pUnit:SetMoves(pUnit:MovesLeft()+GameDefines["MOVE_DENOMINATOR"])
		pUnit:SetMadeAttack(false)
					
		if pPlayer:IsHuman() and pPlayer:IsTurnActive() then
			local vUnitPosition = PositionCalculator(pUnit:GetX(), pUnit:GetY())				
			Events.AddPopupTextEvent(vUnitPosition, "[COLOR_WHITE]+"..iGain1.." [ICON_PEACE][ENDCOLOR]", 1)
			Events.AddPopupTextEvent(vUnitPosition, "[COLOR_YIELD_GOLD]+"..iGain3.." [ICON_GOLD][ENDCOLOR]", 1.5)
		end
	end


end
GameEvents.UnitPillageGold.Add(OnPillageDamageEnemies)



function CanHaveInstaHeal(iPlayer, iUnit, iPromotionType)
  local Player = Players[iPlayer]
  if iPromotionType == GameInfoTypes.PROMOTION_INSTA_HEAL then
  if Player:IsMajorCiv() and (not Player:IsHuman()) then
  return true
  end
  return false
  end
  return true
end
GameEvents.CanHavePromotion.Add(CanHaveInstaHeal)


------------------------------------------------------------------

-- ****************************************
-- 武僧
-- ****************************************
function CanHaveExtraPromotionForMonk(iPlayer, iUnit, iPromotionType)
  local player = Players[iPlayer];
  local pUnit = Players[iPlayer]:GetUnitByID(iUnit);


  if iPromotionType == GameInfoTypes.PROMOTION_DRILL_4
  or iPromotionType == GameInfoTypes.PROMOTION_SHOCK_4 then
  if pUnit:GetUnitClassType() ==GameInfo.UnitClasses.UNITCLASS_MONK.ID then
	return true
  end
  return false
  end
    return true
end
GameEvents.CanHavePromotion.Add(CanHaveExtraPromotionForMonk)


	
function OnCanParadropFrom(iPlayer, iUnit, iPlotX, iPlotY)

  local pPlayer = Players[iPlayer]
  local pUnit = pPlayer:GetUnitByID(iUnit)

   local pPlot = Map.GetPlot(iPlotX, iPlotY)
		
		if (pUnit~=nil  and pUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_XCOM_WEAPON_BASE"].ID)) then

		  return true
		end
  return false
end
GameEvents.CanParadropFrom.Add(OnCanParadropFrom)



	function AG_BUFF(iPlayer)
	local player = Players[iPlayer]
	if player == nil 
	or (not player:IsMajorCiv()) 
	or (not player:IsAlive()) then
	 	return
	         end
  ----------------------------------------------------------------------------------
			 if  player:HasWonder(GameInfoTypes.BUILDING_AP) then
			 for otherPlayerID = 0, 64 - 1 do
                local otherPlayer = Players[otherPlayerID]
                if otherPlayer:IsAlive() then
                    --if otherPlayer:IsDenouncedPlayer(playerID) then
					if  otherPlayer:IsDenouncingPlayer(iPlayer) then			
			        for row in GameInfo.MinorCivilizations() do	
				    if row.Type ~=nil and Players[row.ID]:IsMinorCiv()  then 
					if Players[row.ID]:IsEverAlive() and Players[row.ID]:IsAlive() then
						--if pPlayer:IsProtectingMinor(row.ID) then
						Players[row.ID]:ChangeMinorCivFriendshipWithMajor(otherPlayerID,-80) 
						    end
                        end
                    end
                end
			end		
		end
	end

	----------------------------------------------------------------------------------
	if  player:CountNumBuildings(GameInfoTypes.BUILDING_FOREIGN_OFFICE) > 0 
	and player:GetNumSpies() >0 then
	            local sum= 0
				local agents = player:GetEspionageSpies()
				for i,v in ipairs(agents) do
					local iAgent = v
					if (v.IsDiplomat) then -- Only for diplomat!
						local pPlot = Map.GetPlot(iAgent.CityX, iAgent.CityY)
						local pCity = nil
						if(pPlot ~= nil) then
							pCity = pPlot:GetPlotCity()
							if(pCity ~= nil) then
								 local pOwner = Players[pCity:GetOwner()]
								 local science= math.max(0,pCity:GetYieldRate(YieldTypes.YIELD_SCIENCE))
				                 local gold= math.max(0,pCity:GetYieldRate(YieldTypes.YIELD_GOLD))
				                 local faith= pCity:GetFaithPerTurn()
								 local Culture= pCity:GetBaseJONSCulturePerTurn()
								--if (not pOwner:IsMinorCiv()) then -- Not for city states
									if  pOwner:IsDoF(iPlayer) then -- If not friend then begins attack
									    sum = 0.15
										else 
										sum = 0.25
									    end
					                    player:ChangeGold(gold*sum)
	                                    player:ChangeJONSCulture(Culture*sum)
					 					player:ChangeFaith(faith*sum)
					 					local iTeamID = player:GetTeam()
                     					local iTeam = Teams[iTeamID]
			         					local iTeamTechs = iTeam:GetTeamTechs()
			         					--local Boost = player:GetScience()
				                         ChangeResearchProcess(player, iTeamID, iTeam, iTeamTechs, iPlayer, science*sum)									
                					 end
		      					 end
           					 end
        				end
	 				end
	 ----------------------------------------------------------------------------------

end
GameEvents.PlayerDoTurn.Add(AG_BUFF)


local BletchleyEraUnits = {[0] = GameInfoTypes.UNIT_SUMERIAN_SPEARMAN,[1] = GameInfoTypes.UNIT_SWORDSMAN,
 [2] = GameInfoTypes.UNIT_LONGSWORDSMAN, [3] = GameInfoTypes.UNIT_MUSKETMAN, [4] = GameInfoTypes.UNIT_RIFLEMAN,
 [5] = GameInfoTypes.UNIT_GREAT_WAR_INFANTRY, [6] = GameInfoTypes.UNIT_INFANTRY,[7] = GameInfoTypes.UNIT_MOTORISED_INFANTRY,
 [8] = GameInfoTypes.UNIT_MECHANIZED_INFANTRY,[9] = GameInfoTypes.UNIT_FW_AUTOMATON};




function CarpenterCheck(iPlayer, iCity, iBuilding)
if (iBuilding == GameInfoTypes.BUILDING_CARPENTER) then
   local pPlayer = Players[iPlayer]
   local pCity = pPlayer:GetCityByID(iCity)
   if pCity:HasFeature(GameInfoTypes.FEATURE_FOREST)
   or pCity:HasFeature(GameInfoTypes.FEATURE_JUNGLE)
   then	
   return true
	        end     
   return false
	  end
	 return true
 end
GameEvents.CityCanConstruct.Add(CarpenterCheck)




function GRANDEUR_5(iPlayer, policyID) 
	local pPlayer = Players[iPlayer]; 

	if pPlayer == nil or (not pPlayer:IsMajorCiv()) then
	 	return
	         end
    if  policyID == GameInfo.Policies["POLICY_KNOWLEDGE_5"].ID then
		pPlayer:EspionageCreateSpy()
	 end
					
end
GameEvents.PlayerAdoptPolicy.Add(GRANDEUR_5)



function Knowledge_2(iPlayer, iUnit,bIsGreatPerson)
	local pPlayer = Players[iPlayer]
    local pUnit = pPlayer:GetUnitByID(iUnit)
	if pPlayer == nil or (not pPlayer:IsMajorCiv()) or pUnit == nil then
		return
		  end

	    if bIsGreatPerson  then 

		if  pPlayer:HasPolicy(GameInfo.Policies["POLICY_KNOWLEDGE_2"].ID) then 	    
		local iBoost = 0.15*pUnit:GetDiscoverAmount()
		pPlayer:ChangeOverflowResearch(iBoost)
	    end

	end
end
GameEvents.ScienceDiscover.Add(Knowledge_2)



function Knowledge_2(iPlayer, iUnit,bIsGreatPerson)
	local pPlayer = Players[iPlayer]
    local pUnit = pPlayer:GetUnitByID(iUnit)
	if pPlayer == nil or (not pPlayer:IsMajorCiv())  or pUnit == nil then
		return
		  end
		if bIsGreatPerson and pPlayer:HasPolicy(GameInfo.Policies["POLICY_INDUSTRY_3"].ID) then 	    
		for city in pPlayer:Cities() do
	    local plot = city:Plot()	    	    
		local iBoost = pUnit:GetHurryProduction(plot)
		city:ChangeProduction(0.25*iBoost)
		end
	end
end
GameEvents.ProductionDiscover.Add(Knowledge_2)




function DoneSomeEffects(iPlayer)
	local pPlayer = Players[iPlayer]

	if pPlayer==nil  then 
	return end 

	for pUnit in pPlayer:Units() do
--------------------------------------------------------------------------
	if (pUnit:GetUnitType() == GameInfoTypes["UNIT_NAVALCARRIER03P"]) then
		local pPlot = pUnit:GetPlot()
		if (pPlot ~= nil) then
		local iNumFighters = 0
		for iVal = 0,(pPlot:GetNumUnits() - 1) do
		local loopUnit = pPlot:GetUnit(iVal)
		if (loopUnit:GetUnitType() == GameInfoTypes["UNIT_CARRIER_FIGHTER_FUTURE"]
		or loopUnit:GetUnitType() == GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"]) then
		iNumFighters = iNumFighters + 1
			end
		end

		if iNumFighters <= 4  then
		pPlayer:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
		pPlayer:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
		end
		if iNumFighters == 5  then
	    pPlayer:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
			    end
			end
		end
	end
	
end
GameEvents.PlayerDoneTurn.Add(DoneSomeEffects)
	
function SLAVE_RAIDING(iPlotX, iPlotY, iPlayer) 
	local pPlayer = Players[iPlayer]; 

	if pPlayer == nil or (not pPlayer:IsMajorCiv()) then
	 	return
	         end
     if pPlayer:HasPolicy(GameInfo.Policies["POLICY_SLAVE_RAIDING"].ID) then
	    pPlayer:ChangeGold(500)
	 end
	  						
end
GameEvents.BarbariansCampCleared.Add(SLAVE_RAIDING)


function KillPopulation(player,city)
    local plagueID=city:GetPlagueType()
	local pop=0
	local bNotify = false
	
		if city:GetPopulation() > 2  then
		pop=math.max(math.floor((city:GetPopulation()/10)+1),1)
	    city:ChangePopulation(-pop, true)
		--city:SetFood(0)
		bNotify = true
		end

		if city:GetPopulation() > 2 and city:GetPopulation() <= 20 then
	    city:ChangePopulation(-1, true)
		--city:SetFood(0)
		pop= 1
		bNotify = true
		end

		if city:GetPopulation() > 20 and city:GetPopulation() <= 40 then
	    city:ChangePopulation(-2, true)
		--city:SetFood(0)
		pop= 2
		bNotify = true
		end

		if city:GetPopulation() > 40 and city:GetPopulation() <= 60 then
	    city:ChangePopulation(-3, true)
		--city:SetFood(0)
		pop= 3
		bNotify = true
		end

        if city:GetPopulation() > 60 then
	    city:ChangePopulation(-5, true)
		--city:SetFood(0)
		pop= 5
		bNotify = true
		end

	-- Notification
	if bNotify  and player:IsHuman() and plagueID~=-1
	then
	    local plague = GameInfo.Plagues[plagueID]
		local heading = Locale.ConvertTextKey("TXT_KEY_PLAGUE_DEATH_SHORT")
		local text = Locale.ConvertTextKey("TXT_KEY_PLAGUE_DEATH",plague.IconString, plague.Description,city:GetName(), pop)
    	player:AddNotification(NotificationTypes.NOTIFICATION_STARVING, text, heading, city:GetX(),city:GetY());
	end
end



--//------------------------------------------------------------------------------
--int CvLuaPlayer::lEspionageSetOutcome(lua_State* L)
--{
	--CvPlayer* pkPlayer = GetInstance(L);
	--int iSpyIndex = lua_tointeger(L, 2);
	--int iSpyResult = lua_tointeger(L, 3);
	--bool bAffectsDiplomacy = lua_toboolean(L, 4);
	--pkPlayer->GetEspionage()->SetOutcome(iSpyIndex, iSpyResult, bAffectsDiplomacy);

	--return 0;
--}
--#endif



function BLETCHLEY_PARK_SPY(iPlayer, iSpy, iResult, iCityX, iCityY) 
   local Player = Players[iPlayer]

   local CityPlot = Map.GetPlot(iCityX,iCityY )
   local City=CityPlot:GetPlotCity()

   if Player == nil or (not pPlayer:IsMajorCiv()) 
   or (not Player:HasWonder(GameInfoTypes.BUILDING_BLETCHLEY_PARK))   then
      return
   end

   if  iResult then

   local plotX = iCityX+1
   local plotY = iCityY

   local era = Players[City:GetOwner()]:GetCurrentEra()
   local unitType = BletchleyEraUnits[era]

   Players[63]:InitUnit(unitType, plotX, plotY)
   Players[63]:InitUnit(unitType, plotX, plotY)
   Players[63]:InitUnit(unitType, plotX, plotY)

   Unit:ChangeExperience(120)
   Unit2:ChangeExperience(120)
   Unit3:ChangeExperience(120)

   Unit:JumpToNearestValidPlot()
   Unit2:JumpToNearestValidPlot()
   Unit3:JumpToNearestValidPlot()
 
   City:ChangeDamage(50)
   --City:ChangeResistanceTurns(2)
   end
end 	
 GameEvents.EspionageResult.Add(BLETCHLEY_PARK_SPY)  

function ManyWorldWonderCompleted(iPlayer, iCity, iBuilding, bGold, bFaithOrCulture)
    local pPlayer = Players[iPlayer];
	local pCity = pPlayer:GetCityByID(iCity)
	if pPlayer == nil or (not pPlayer:IsMajorCiv()) then
	 	return
	         end
    

	 if iBuilding == GameInfoTypes["BUILDING_DIONYSUS"] then   ---剧场
		 for row in GameInfo.MinorCivilizations() do	
				if row.Type ~=nil then 
					if Teams[Players[row.ID]:GetTeam()]:IsHasMet(pPlayer:GetTeam()) then	
					if Players[row.ID]:IsMinorCiv() then
					Players[row.ID]:ChangeMinorCivFriendshipWithMajor(iPlayer, 50) ----增加50点关系
					end
				 end
			 end
		 end
	 end

	if pCity:IsHasBuilding(GameInfoTypes.BUILDING_DZIMBABWE) and not bGold then	 ---大津巴布韦
	   local freegold = GameInfo.Buildings[iBuilding].Cost
	   local bonus=GameInfo.GameSpeeds[Game.GetGameSpeedType()].ConstructPercent/100  
	   pPlayer:ChangeGold(math.floor(freegold*bonus))
	   end


end
GameEvents.CityConstructed.Add(ManyWorldWonderCompleted)



--=======================================================================================================================
-- UTILITIES
--=======================================================================================================================
function CityCanMaintainHealth(iPlayer, iCity, iProcess) 
  if (iProcess == GameInfoTypes.PROCESS_HEALTH) then
    local pPlayer = Players[iPlayer]
	if (not pPlayer:IsHuman()) then
	   return false
	end
  end
  return true
end
GameEvents.CityCanMaintain.Add(CityCanMaintainHealth) 


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
	science = science + math.max(0,ecity:GetYieldRate(YieldTypes.YIELD_SCIENCE))
		end
	end
	local iTeamID = player:GetTeam()
	local iTeam = Teams[iTeamID]
	local iTeamTechs = iTeam:GetTeamTechs()
	ChangeResearchProcess(player, iTeamID, iTeam, iTeamTechs, playerID, science)
	end

end
GameEvents.PlayerDoTurn.Add(Knowledge_5or1)




function AddGoodies()

	print("-------------------------------");
	print("Map Generation - Adding Goodies");
	
	-- If an era setting wants no goodies, don't place any.
	local startEra = Game.GetStartEra();
	if(GameInfo.Eras[startEra].NoGoodies) then
		print("** The Era specified NO GOODY HUTS");
		return;
	end

	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_GOODY_HUTS)) then
		print("** The game specified NO GOODY HUTS");
		return false;
	end

	-- Check XML for any and all Improvements flagged as "Goody" and distribute them.
	for improvement in GameInfo.Improvements() do
		local tilesPerGoody = improvement.TilesPerGoody;
		
		if(improvement.Goody and tilesPerGoody > 0) then
		
			local improvementID = improvement.ID;
			for index, plot in Plots(Shuffle) do
				if ( not plot:IsWater() ) then
					
					-- Prevents too many goodies from clustering on any one landmass.
					local area = plot:Area();
					local improvementCount = area:GetNumImprovements(improvementID);
					local scaler = (area:GetNumTiles() + (tilesPerGoody/2))/tilesPerGoody;	
					if (improvementCount < scaler) then
						
						if (CanPlaceGoodyAt(improvement, plot)) then
							plot:SetImprovementType(improvementID);
						end
					end
				end
			end
		end
	end

	--------------------------新增火山--------------------------
	for feature in GameInfo.Features() do
		local tilesPerVolcano = bWPIsActive and feature.TilesPerVolcano;
		if bWPIsActive and feature.Volcano and tilesPerVolcano > 0 then
			print("Placing Volcanoes");
			local featureID = feature.ID;
			for index, plot in Plots(Shuffle) do
				if ( not plot:IsWater() ) then
					if (CanPlaceVolcanoAt(feature, plot)) then
						plot:SetFeatureType(featureID);
						print("A Volcano has been placed");
					end
				end
			end
		end
	end
	------------------------------------------------------------------------------

	print("-------------------------------");
end


-- Health_GrantPopulationMission
function Health_GrantPopulationMission(playerID, unit)
	local player = Players[playerID]
	local plot = unit:GetPlot();
	local unitCount = plot:GetNumUnits()  
	if unit then
	local NumUseForCureUnit = load(unit, "UseForCureUnit") or 0
	--------------------------------------------------------------------------------------------------------------------------------------
	if  load(unit, "UseForCureUnit") ~= nil 
	and load(unit, "UseForCureUnit") ==2  then
	    for i = 0, unitCount-1, 1 do   	
   		local pFoundUnit = plot:GetUnit(i)
   		if pFoundUnit ~= nil and pFoundUnit:GetOwner() == unit:GetOwner()  and pFoundUnit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED)
   		then pFoundUnit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_PLAGUED"].ID, false); 
		   end
		end
        for pAdjacentPlot in PlotAreaSweepIterator(plot, 1, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		for iVal = 0,(pAdjacentPlot:GetNumUnits() - 1) do
			local loopUnit = pAdjacentPlot:GetUnit(iVal)
			 if  loopUnit:GetOwner() == unit:GetOwner()  and loopUnit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED) then
		     loopUnit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_PLAGUED"].ID, false);
		      end
		   end
		end
		Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
	   	unit:Kill(); 
	    end 

		--------------------------------------------------------------------------------------------------------------------------------------
	if  load(unit, "UseForCureUnit") ~= nil 
	and load(unit, "UseForCureUnit") ==1  then
    	 for i = 0, unitCount-1, 1 do   	
   		local pFoundUnit = plot:GetUnit(i)
   		if pFoundUnit ~= nil and pFoundUnit:GetOwner() == unit:GetOwner()  and pFoundUnit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED)
   		then pFoundUnit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_PLAGUED"].ID, false); 
		   end
		end
        for pAdjacentPlot in PlotAreaSweepIterator(plot, 1, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		for iVal = 0,(pAdjacentPlot:GetNumUnits() - 1) do
			local loopUnit = pAdjacentPlot:GetUnit(iVal)
			 if  loopUnit:GetOwner() == unit:GetOwner()  and loopUnit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED) then
		loopUnit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_PLAGUED"].ID, false);
		      end
		   end
		end
		Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
	   	save(unit, "UseForCureUnit", 2)
		unit:SetMoves(0);
	    end 
		--------------------------------------------------------------------------------------------------------------------------------------
	if unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_DOCTOR"].ID) 
	    and  load(unit, "UseForCureUnit") == nil 
		then
    	for i = 0, unitCount-1, 1 do   	
   		local pFoundUnit = plot:GetUnit(i)
   		if pFoundUnit ~= nil and pFoundUnit:GetOwner() == unit:GetOwner()  and pFoundUnit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED)
   		then pFoundUnit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_PLAGUED"].ID, false); 
		   end
		end
        for pAdjacentPlot in PlotAreaSweepIterator(plot, 1, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		for iVal = 0,(pAdjacentPlot:GetNumUnits() - 1) do
			local loopUnit = pAdjacentPlot:GetUnit(iVal)
			 if  loopUnit:GetOwner() == unit:GetOwner()  and loopUnit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED) then
		loopUnit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_PLAGUED"].ID, false);
		      end
		   end
		end
		Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
	   	save(unit, "UseForCureUnit", 1)
		unit:SetMoves(0);
	    end 
		--------------------------------------------------------------------------------------------------------------------------------------		
		if player:IsHuman() then
	    local heading = Locale.ConvertTextKey("TXT_KEY_DOCTOR_CURED_UNIT_SHORT")
		local text = Locale.ConvertTextKey("TXT_KEY_DOCTOR_CURED_UNIT")
		player:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, text, heading, plot:GetX(), plot:GetY());
		end  
	end	

end




function GREAT_DOCTOR_CURE_Mission(playerID, unit)

    local player = Players[playerID]
    local plot = unit:GetPlot();

    if  load(unit, "UseForCure") ~= nil 
	    and load(unit, "UseForCure") ==2  then
	    for  Unit in player:Units() do 	
   		if   Unit ~= nil  and Unit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED)
   		then Unit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_PLAGUED"].ID, false); 
		   end
		end
        for city in player:Cities() do
		Health_PlagueEnds(city)
		end
		Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
	   	unit:Kill(); 
	    end 

		--------------------------------------------------------------------------------------------------------------------------------------
	if  load(unit, "UseForCure") ~= nil 
	    and load(unit, "UseForCure") ==1  then
    	for Unit in player:Units() do 	
   		if Unit ~= nil  and Unit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED)
   		then Unit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_PLAGUED"].ID, false); 
		   end
		end
        for city in player:Cities() do
	    Health_PlagueEnds(city)
		end
		Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
	   	save(unit, "UseForCure", 2)
		unit:SetMoves(0);
	    end 
		--------------------------------------------------------------------------------------------------------------------------------------
	 if unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_GREAT_DOCTOR"]   
	    and  load(unit, "UseForCure") == nil 
		then
    	for Unit in player:Units() do 	
   		if Unit ~= nil  and Unit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED)
   		then Unit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_PLAGUED"].ID, false); 
		   end
		end
        for city in player:Cities() do
		Health_PlagueEnds(city)
		end
		Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
	   	save(unit, "UseForCure", 1)
		unit:SetMoves(0);
	    end 
		--------------------------------------------------------------------------------------------------------------------------------------		
		if player:IsHuman() then
	    local heading = Locale.ConvertTextKey("TXT_KEY_DOCTOR_CURED_SHORT")
		local text = Locale.ConvertTextKey("TXT_KEY_DOCTOR_CURED")
		player:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, text, heading, plot:GetX(), plot:GetY());
		   end  
	    --end	
   --end
end




--Health_CityCanTrain
function Health_CityCanTrain(playerID, cityID, unitID)
	local player = Players[playerID]
	local city = player:GetCityByID(cityID)
	if GameInfo.Units[unitID].Food then
		return (not city:HasPlague())
	end
	return true
end
GameEvents.CityCanTrain.Add(Health_CityCanTrain)




local UathachPromotion = GameInfoTypes["PROMOTION_NUKE_IMMUNE2"]
local iRadius = 2

function UathachActivate(playerID, unitID, bTestAllAllies)
	local pPlayer = Players[playerID]
	local pUnit = pPlayer:GetUnitByID(unitID)
	if not pUnit then return end
	if bTestAllAllies then
		for pUnit  in pPlayer:Units() do
			if pUnit :GetUnitType() ~= GameInfoTypes["UNIT_GOLEM"]  and not IsHugeUnit(pUnit )   then
				local bThisUnitStaysBuffed = UathachLoop(pPlayer, pUnit ,pUnit :GetPlot())
				if bThisUnitStaysBuffed then
					pUnit:SetHasPromotion(UathachPromotion, true)
				else
					pUnit:SetHasPromotion(UathachPromotion, false)
				end
			end
		end
	else
		if pUnit :GetUnitType() ~= GameInfoTypes["UNIT_GOLEM"]  and not IsHugeUnit(pUnit )  then
			local bThisUnitStaysBuffed = UathachLoop(pPlayer, pUnit, pUnit:GetPlot())
			if bThisUnitStaysBuffed then
				pUnit:SetHasPromotion(UathachPromotion, true)
			else
				pUnit:SetHasPromotion(UathachPromotion, false)
			end
		end
	end
end

function UathachLoop(pPlayer, pUnit, pPlot)
	if pPlot then
		for c = 0, pPlot:GetNumUnits() - 1 do
			local pPlotUnit = pPlot:GetUnit(c)
			if pPlotUnit and pPlotUnit ~= pUnit then
				if pPlotUnit:GetOwner() == pPlayer:GetID() and pPlotUnit:GetUnitType() == GameInfoTypes["UNIT_GOLEM"] then
					return true
				end
			end
		end
		if iRadius > 0 then
			for pAreaPlot in PlotAreaSpiralIterator(pPlot, iRadius, 2, true, true, true) do
				if pAreaPlot:IsUnit() then
					for c = 0, pAreaPlot:GetNumUnits() - 1 do
						local pPlotUnit = pAreaPlot:GetUnit(c)
						if pPlotUnit then
							if pPlotUnit:GetOwner() == pPlayer:GetID() and pPlotUnit:GetUnitType() == GameInfoTypes["UNIT_GOLEM"] then
								return true
							end
						end
					end
				end
			end
		end
	end
	return false
end
GameEvents.UnitSetXY.Add(UathachActivate)












function SpaceBattleCruiserManaForHuman(iPlayer)
		local pPlayer = Players[iPlayer]
		if not 	pPlayer:IsHuman() then
		return
	         end
        
		if  pPlayer:HasWonder(GameInfoTypes.BUILDING_SPACE_FORTRESS) then

				if pUnit:GetUnitType() == BattleCruiser and load(pUnit, "SpaceBattleCruiserEnergy") < 8 then

					local city = pUnit:GetPlot():GetPlotCity() or pUnit:GetPlot():GetWorkingCity();
					  if city == nil then 
					    save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 1)
		                end

						  if city ~= nil then 
						  if city:GetOwner()~=iPlayer  or (not city:IsHasBuilding(GameInfoTypes["BUILDING_WAR_MACHINE_FACTORY"]))    then 
					    save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 1)
		                   end
						end
						
					if city ~= nil and city:IsHasBuilding(GameInfoTypes["BUILDING_WAR_MACHINE_FACTORY"]) and city:GetOwner()==iPlayer then
					 if load(pUnit, "SpaceBattleCruiserEnergy") == 7 then 
				  	save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 1)
					end
					  if load(pUnit, "SpaceBattleCruiserEnergy") <7 then 
					save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 2)
					   end
					end

					for i = 0, 8 do
						pUnit:SetHasPromotion(ATBTEnergy[i], (i == load(pUnit, "SpaceBattleCruiserEnergy")))
					end
				end
			end

   --------------------------------------------------------------------------------------------------------------------------------------------
           if  pPlayer:HasWonder(GameInfoTypes.BUILDING_SPACE_FORTRESS) then

				if pUnit:GetUnitType() == BattleCruiser and load(pUnit, "SpaceBattleCruiserEnergy") < 18 then

					local city = pUnit:GetPlot():GetPlotCity() or pUnit:GetPlot():GetWorkingCity();
					  if city == nil then 
					    save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 1)
		                end

						  if city ~= nil then 
						  if city:GetOwner()~=iPlayer  or (not city:IsHasBuilding(GameInfoTypes["BUILDING_WAR_MACHINE_FACTORY"]))    then 
					    save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 1)
		                   end
						end
						
					if city ~= nil and city:IsHasBuilding(GameInfoTypes["BUILDING_WAR_MACHINE_FACTORY"]) and city:GetOwner()==iPlayer then
					  if load(pUnit, "SpaceBattleCruiserEnergy") == 17 then 
				  	save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 1)
					end
					  if load(pUnit, "SpaceBattleCruiserEnergy") <17 then 
					save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 2)
					   end
					end
	
					for i = 0, 18 do
				pUnit:SetHasPromotion(ATBTEnergy[i], (i == load(pUnit, "SpaceBattleCruiserEnergy")))
		     end
	     end
     end
end
GameEvents.PlayerDoTurn.Add(SpaceBattleCruiserManaForHuman)





