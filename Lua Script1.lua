-- Lua Script1
-- Author: 11585
-- DateCreated: 2023/7/26 0:13:52
--------------------------------------------------------------


--GetEspionageSpies


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





