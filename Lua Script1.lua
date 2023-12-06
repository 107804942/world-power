-- Lua Script1
-- Author: 11585
-- DateCreated: 2023/7/26 0:13:52
--------------------------------------------------------------\


function UpdateGreatPerson(eTeam, eEra, bFirst)
	   if  (bFirst) then
	   for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
	   local pPlayer = Players[iPlayer]
	   if pPlayer:IsAlive() then
	
	   if pPlayer:GetTeam() == eTeam then
    	---------------------------------------
	   if pPlayer:IsMajorCiv() and (not pPlayer:IsHuman())  then

         pPlayer:ChangeOverflowResearch(4*pPlayer:GetScience())
		 end

		     end
		  end
	   end
    end
 end
GameEvents.TeamSetEra.Add(UpdateGreatPerson)

function AiIntoNewEra(eTeam, eEra, bFirst)
        local handicap = Game:GetHandicapType();
	    if   handicap >= 7 then
	    for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
	    local pPlayer = Players[iPlayer]
	   	if pPlayer:IsAlive() then
	    if pPlayer:GetTeam() == eTeam then

		 if pPlayer:IsMajorCiv() and  not pPlayer:IsHuman()  then

		 pPlayer:ChangeGold(2000*(pPlayer:GetCurrentEra()+1))
		 pPlayer:ChangeOverflowResearch(4*pPlayer:GetScience())

		 for city in pPlayer:Cities() do
	     local iCurrentBuilding = city:GetProductionBuilding()
	     if iCurrentBuilding > -1 and (not tWonders[iCurrentBuilding])  then
	     local prod = city:GetProductionNeeded();
	     city:SetProduction(prod)
	     SetInvalidateCity()
		              end
		           end
		        end
		     end
		  end
	   end
    end
 end
GameEvents.TeamSetEra.Add(AiIntoNewEra)


function AG_BUFF(iPlayer)
	local player = Players[iPlayer]
	if player == nil 
	or (not player:IsMajorCiv()) 
	or (not player:IsAlive()) then
	 	return
	         end

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




function Building_EmpireReourceAnds_Check(playerID, buildingID)
	local player = Players[playerID];

	local condition = "BuildingType = '" .. GameInfo.Buildings[buildingID].Type .. "'";
	for row in GameInfo.Building_EmpireResourceAnds(condition) do
		if(player:GetNumResourceAvailable(GameInfoTypes[row.ResourceType], row.AllowsImport) <= 0) then
			return false; -- 列出玩家未拥有的资源
		end
	end

	return true;
end
GameEvents.PlayerCanConstruct.Add(Building_EmpireReourceAnds_Check);



function Building_EmpireReourceOrs_Check(playerID, buildingID)
	local player = Players[playerID];
	local buildingNotInTable = true;
	
	local condition = "BuildingType = '" .. GameInfo.Buildings[buildingID].Type .. "'";
	for row in GameInfo.Building_EmpireResourceOrs(condition) do
		buildingNotInTable = false; -- 建筑需要资源才可建造
			
		if(player:GetNumResourceAvailable(GameInfoTypes[row.ResourceType], row.AllowsImport) > 0) then
			return true; -- 列出玩家拥有的资源
		end
	end

	return buildingNotInTable;
end
GameEvents.PlayerCanConstruct.Add(Building_EmpireReourceOrs_Check);


local retVal = {};
LuaEvents.Building_EmpireResources_IsInitialized(retVal);


if (retVal.isInitialized == nil) then
	LuaEvents.Building_EmpireResources_IsInitialized.Add(function (retVal) retVal.isInitialized = true; end);
	-- 置入代码
	GameEvents.PlayerCanConstruct.Add(Building_EmpireReourceAnds_Check);
	GameEvents.PlayerCanConstruct.Add(Building_EmpireReourceOrs_Check);
end







function GolemActivate(playerID, unitID, bTestAllAllies)
	local pPlayer = Players[playerID]
	local pUnit = pPlayer:GetUnitByID(unitID)
	if not pUnit then return end
	if bTestAllAllies then
		for pUnit  in pPlayer:Units() do
			if pUnit:GetUnitType() ~= GameInfoTypes["UNIT_GOLEM"]   then
				if  pUnit:IsWithinDistanceOfUnit(GameInfoTypes["UNIT_GOLEM"], 2, true, false) then
					pUnit:SetHasPromotion(GameInfoTypes["PROMOTION_NUKE_IMMUNE2"], true)
				else
					pUnit:SetHasPromotion(GameInfoTypes["PROMOTION_NUKE_IMMUNE2"], false)
				end
			end
		end
	else
		 if pUnit:GetUnitType() ~= GameInfoTypes["UNIT_GOLEM"] then
			if  pUnit:IsWithinDistanceOfUnit(GameInfoTypes["UNIT_GOLEM"], 2, true, false) then
				pUnit:SetHasPromotion(GameInfoTypes["PROMOTION_NUKE_IMMUNE2"], true)
			else
				pUnit:SetHasPromotion(GameInfoTypes["PROMOTION_NUKE_IMMUNE2"], false)
			end
		end
	end
end
GameEvents.UnitSetXY.Add(GolemActivate)






iTeam = -1

function MauryaWarMonitor (iAttacker, iDefender, bWar)

	-- Gets the Attacker
	if iTeam ~= -1 then
		iTeam = -1
		return
	else
		iTeam = iAttacker
	end
	--print(iAttacker, iDefender)
	--print("Attacker is " .. iTeam)
	
	--War Declared
	if bWar then
		local pTeam = Teams[iTeam]
		--print("War Declared")
		for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
			local pPlayer = Players[iPlayer]
			if (pTeam:GetAtWarCount() == 0) and (pPlayer:GetCivilizationType() == iCivType) then
				--print("Enemies annihilated, peace")
				save(pPlayer, "bBonusEnabled", true)
			elseif (pPlayer:GetTeam() == iTeam) and (pPlayer:GetCivilizationType() == iCivType) then
				--print(iPlayer .. " is Maurya and Attacking!")
				if load(pPlayer, "bBonusEnabled") == true then
					--print("Bonus Reset")
					save(pPlayer, "iNumCaptured", 0)
				end
				save(pPlayer, "bBonusEnabled", false)
			end
		end
		
	--Peace Made
	else
		--print("Peace Made")
		for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
			local pPlayer = Players[iPlayer]
			local iPlayerTeam = pPlayer:GetTeam()
			if ((iPlayerTeam == iAttacker) or (iPlayerTeam == iDefender)) and (pPlayer:GetCivilizationType() == iCivType) then
				--print(iPlayer .. " is Maurya and has made Peace!")
				local pTeam = Teams[iPlayerTeam]
				if pTeam:GetAtWarCount() > 0 then
					--print("However, is still at war with someone else")
				else
					save(pPlayer, "bBonusEnabled", true)
					MauryaNotification(pPlayer)
				end
			end        
		end    
	end    
end
Events.WarStateChanged.Add(MauryaWarMonitor)


	-- ********************************************************
-- 乌尔班
-- ********************************************************
	 if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_URBAN"].ID)  then 
        defCity:ChangeResistanceTurns(1)
       end	
  -- end


  
function HeroicCarrierRollStart(iTeam1, iTeam2, bWar)
	if iTeam1 == nil or iTeam2 == nil then
		return
	end
	local pTeam1 = Teams[iTeam1]
	local pTeam2 = Teams[iTeam2]
	if not pTeam1:IsAtWar(pTeam2) then
		return
	end
	local CapitalCity = nil
	for playerID, pPlayer in pairs(Players) do
		if pPlayer and pPlayer:IsAlive() and not pPlayer:IsMinorCiv() and not pPlayer:IsBarbarian() then
			CapitalCity = pPlayer:GetCapitalCity()
			if CapitalCity ~= nil and CapitalCity:IsHasBuilding(GameInfoTypes["BUILDING_HEROIC_CARRIER_PROJECT"])
				and (pPlayer:GetTeam() == iTeam1 or pPlayer:GetTeam() == iTeam2) then
				print("The war calls the Heroic Carrier")
				CapitalCity:SetNumRealBuilding(GameInfoTypes["BUILDING_HEROIC_CARRIER_START"], 1)
				CapitalCity:SetNumRealBuilding(GameInfoTypes["BUILDING_HEROIC_CARRIER_PROJECT"], 0)
				print("for next turn")
				return
			end
		end
	end
end
Events.WarStateChanged.Add(HeroicCarrierRollStart)


	 function DoSomeEffects(playerID)
    local player = Players[playerID]
    if player==nil
	then return 
	end
	for unit in player:Units() do  

	if  unit:GetUnitType() == GameInfoTypes["UNIT_NAVALCARRIER03P"] then
	    local iNumFighters = unit:GetCargo()
		local iNumFightersIn =unit:CargoSpace()  
		local pPlot = unit:GetPlot()
	    if iNumFighters-iNumFightersIn >=2  then
		player:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
		player:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
		else
	    player:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
		 end
	  end	
   end
end
GameEvents.PlayerDoTurn.Add(DoSomeEffects)

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



		if PreGame.GetHandicap(0)== GameInfoTypes.HANDICAP_SETTLER then
			iModifier=40
			elseif 
			PreGame.GetHandicap(0)== GameInfoTypes.HANDICAP_CHIEFTAIN then
			iModifier=20
			elseif 
			PreGame.GetHandicap(0)== GameInfoTypes.HANDICAP_WARLORD then
			iModifier=0
			elseif 
			PreGame.GetHandicap(0)== GameInfoTypes.HANDICAP_PRINCE then
			iModifier=0
			elseif 
			PreGame.GetHandicap(0)== GameInfoTypes.HANDICAP_KING then
			iModifier=0
			elseif 
			PreGame.GetHandicap(0)== GameInfoTypes.HANDICAP_EMPEROR then
			iModifier=0
			elseif 
			PreGame.GetHandicap(0)== GameInfoTypes.HANDICAP_IMMORTAL then
			iModifier=0
			elseif 
			PreGame.GetHandicap(0)== GameInfoTypes.HANDICAP_DEITY then
			iModifier=0
			end

	if (eIndex == YIELD_HERESY)
	{
		ReligionTypes eMajority = GetCityReligions()->GetReligiousMajority();
		if (eMajority >= RELIGION_PANTHEON )
		{
			//const CvReligion* pReligion = GC.getGame().GetGameReligions()->GetReligion(eMajority, getOwner());
			if (eMajority && (GetCityReligions()->GetNumFollowers(eMajority) != getPopulation()))
			{
				int iBase = getPopulation() - GetCityReligions()->GetNumFollowers(eMajority);
				if (iBase > 0)
				{
					iBaseValue = iBase;
					szRtnValue += GetLocalizedText("TXT_KEY_CITYVIEW_BASE_YIELD_TT_HERESY_DISCORD", iBaseValue, YieldIcon);
				}
			}
		}

		iBaseValue = -5;
		if (GET_PLAYER(m_eOwner).isGoldenAge())
		{
			szRtnValue += GetLocalizedText("TXT_KEY_CITYVIEW_BASE_YIELD_TT_HERESY_DISCORD_FROM_GOLDENAGE", iBaseValue, YieldIcon);
		}
		//GetCityReligions()->GetNumReligionsWithFollowers()
	}
	