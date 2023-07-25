-- Author: ��ʢ�ٵİ���
-- DateCreated: 2023.7.16 
--=======================================================================================================================
-- INCLUDES
--=======================================================================================================================
include("PlotIterators.lua");
include ("Plague_SaveData.lua");
include ("Plague_UI.lua");
include( "FLuaVector" );
include("FunctionUtilities.lua");
include("Rog_SaveUtils.lua"); MY_MOD_NAME = "����ǿȨ";
--------------------------------------------------------------------

local gCityHeal				= GameDefines["CITY_HIT_POINTS_HEALED_PER_TURN"]
local gCityHealthList		= {}
local sort					= table.sort
local insert				= table.insert
local remove				= table.remove
--local floor				= math.floor
local ceil					= math.ceil

local defineCIDHealthPlagueMinThreshold		   = 150
if Game then defineCIDHealthPlagueMinThreshold = (GameDefines["HEALTH_PLAGUE_MIN_THRESHOLD_" .. GameInfo.GameSpeeds[Game.GetGameSpeedType()].Type] or 150) end

--=======================================================================================================================
-- USER SETTINGS
--=======================================================================================================================
--local bNoPlagues	 = (PreGame.GetGameOption("GAMEOPTION_PLAGUE_DISABLED") == 1)  ---�رս�����Ч��

--local bAbandonCity	 = (PreGame.GetGameOption("GAMEOPTION_PLAGUE_DESTROYS_CITIES") == 1)  ---�����˿ڼ���Ч��


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


--------------------------------------------------------------------
--������
--------------------------------------------------------------------
local yieldFoodID	 = YieldTypes.YIELD_FOOD
local yieldGoldID	 = YieldTypes.YIELD_GOLD
 
function GetNumTurn (player,city)
    local mathcheck=1    
    local NumTurn= math.max(0,ceil(city:GetPopulation()/10)+6 )  ---��ʼ�غ���
	if player~=nil and player:GetBuildingClassCount(GameInfo.BuildingClasses.BUILDINGCLASS_CENTERS.ID) > 0 then
	mathcheck=mathcheck-0.25
	end
	if  city:IsHasBuilding(GameInfoTypes.BUILDING_LOCAL_HOSPITAL) then ---��ҽ��
		mathcheck=mathcheck-0.25
	end

	return ceil(mathcheck*NumTurn)
end


function GetHealthYieldBuff(player,city,leftHealth)
    if  leftHealth > 0 then
	    if  leftHealth>20 and leftHealth<=50 then
	    leftHealth=10
		elseif leftHealth>50 and leftHealth<=80 then
		leftHealth=20
		elseif leftHealth>80 and leftHealth<=120 then
		leftHealth=30
		elseif leftHealth>120  then
		leftHealth=40
		end
	end
    return leftHealth
end



--if not bNoPlagues then  --ȷ�Ͽ���������ϵͳ


--------------------------------------------------------------------
--ɱ���˿�
function KillPopulation(player,city)
    local plagueID=city:GetPlagueType()
	local pop=0
	local bNotify = false

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



--Health_PlayerDoTurn
function Health_PlayerDoTurn(playerID)
	local player = Players[playerID]
	if (not player:IsAlive()) then return end
	--if (not bAbandonCity) then return end  --ȷ�Ͽ������߱���ϵͳ	
	if (not player:IsMajorCiv())  then return end 
	for city in player:Cities() do
		local totalHealth, totalDisease = player:GetCityHealthTotal(city, true) ---���������뼲������



		if (not city:HasPlague()) then   ---���е�ǰ������
			local plagueCounter, plagueThreshold, plagueTurns = player:GetCityPlagueCounterDetails(city, true, true)

			local leftHealth = totalHealth - totalDisease

			city:SetYieldModifierFromHealth(yieldFoodID, 0) 
	        city:SetYieldFromHealth(yieldFoodID, 0)
			city:SetYieldModifierFromHealth(yieldGoldID, GetHealthYieldBuff(player,city,leftHealth)) 
			city:SetYieldFromHealth(yieldGoldID, GetHealthYieldBuff(player,city,leftHealth))

			if leftHealth<0 then
	        city:SetYieldModifierFromHealth(yieldFoodID, GetHealthYieldBuff(player,city,leftHealth)) 
	        city:SetYieldFromHealth(yieldFoodID, GetHealthYieldBuff(player,city,leftHealth))
	        end

			----------����1
			if leftHealth > 0 then    --�����ȸ���
				if plagueCounter > 0 then     ---�����ۼƽ���
				    if plagueCounter> leftHealth then
					city:ChangePlagueCounter(-leftHealth) 
					else 
					city:ChangePlagueCounter(-plagueCounter) 
				 end
             end 

			----------����2
			elseif (leftHealth<0 ) then   --�����Ȳ���
				city:ChangePlagueCounter(-leftHealth)
				plagueCounter, plagueThreshold, plagueTurns = player:GetCityPlagueCounterDetails(city, true, true)
				if plagueCounter >= plagueThreshold then   ---��������������ʾ
					city:ChangePlagueTurns(GetNumTurn(player,city))
					city:SetPlagueCounter(0)
					Health_PlagueBegins(city)
					city:ChangeDamage(100+gCityHeal)
					DiseaseUnits(city)

				--elseif (plagueTurns == 5) then    ---����5�غϱ���ʱ����
					--SendNotification(playerID, "NOTIFICATION_PLAGUE", Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_IMMINENT_NOTIFICATION", city:GetName(), plagueTurns), Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_IMMINENT_NOTIFICATION_SHORT", city:GetName()), false, city:GetX(), city:GetY())
				end
			end

		else
			if city:GetPlagueTurns() == 0 then
				Health_PlagueEnds(city)
				KillPopulation(player,city)
			else

			if  totalDisease > 0 then  ---����������
					city:ChangeDamage(100+gCityHeal)
					DiseaseUnits(city)
					KillPopulation(player,city)
			   end
			end
		end
	end
end
GameEvents.PlayerDoTurn.Add(Health_PlayerDoTurn)



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


--------------------------------------------------------------------
---�Ե�λ����˺�
function DiseaseUnits(city)
	local iX=city:GetX()
	local iY=city:GetY()
	   	local extraRange = 2	
	    for dx = -extraRange, extraRange - 1, 1 do
	    for dy = -extraRange, extraRange - 1, 1 do
        local adjPlot = Map.PlotXYWithRangeCheck(iX, iY, dx, dy, 1);
		if adjPlot ~= nil then
		local unitCount = adjPlot:GetNumUnits();
        if unitCount > 0 then
		for i = 0, unitCount-1, 1 do
        local pFoundUnit = adjPlot:GetUnit(i);
		if  pFoundUnit~=nil and not pFoundUnit:IsImmuePlague() then
		          pFoundUnit:ChangeDamage(50)  
		          pFoundUnit:SetHasPromotion(GameInfoTypes.PROMOTION_PLAGUED, true) 
				  end
			   end
			end
	     end
      end
   end
end




--Health_PlagueEnds
function Health_PlagueEnds(city)
	local player = Players[city:GetOwner()]
	local plagueID=city:GetPlagueType()
	local iX=city:GetX()
	local iY=city:GetY()

	 -- Notification
	if player:IsHuman() and plagueID ~= -1 then
	local plague = GameInfo.Plagues[plagueID]
	local heading = Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_ENDS_NOTIFICATION_SHORT")
	local text = Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_ENDS_NOTIFICATION",plague.IconString,plague.Description,city:GetName())
	player:AddNotification(NotificationTypes.NOTIFICATION_INSTANT_YIELD, text, heading, iX, iY)
	Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
	end

	city:SetAdditionalFood(0)
	city:SetPlagueType(-1)
	city:SetPlagueCounter(0)
	--end
end



--Health_PlagueBegins
local cityFocusFoodID      = CityAIFocusTypes["CITY_AI_FOCUS_TYPE_FOOD"]
function Health_PlagueBegins(city)	
    local player = Players[city:GetOwner()]
	local plagueID= GetCityPlagueTypeToSpawn(city)
	local iX=city:GetX()
	local iY=city:GetY()
	city:SetPlagueType(plagueID)
	 -- Notification
	if player:IsHuman() and plagueID ~= -1 then
	local plague = GameInfo.Plagues[plagueID]
	local heading = Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_NOTIFICATION_SHORT")
	local text = Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_NOTIFICATION",plague.IconString,plague.Description, city:GetName())
	player:AddNotification(NotificationTypes.NOTIFICATION_PLAGUE, text, heading, iX,iY);
	--player:AddNotification(NotificationTypes.NOTIFICATION_STARVING, text, heading, iX, iY) 
	end

	Events.AudioPlay2DSound("AS2D_PLAGUE")
end

------------------------------------------------------------------------------------------------------------------------
-- DOCTOR
------------------------------------------------------------------------------------------------------------------------
-- Health_MissionPossible
local CUSTOM_MISSION_NO_ACTION		 = 0
local CUSTOM_MISSION_ACTION			 = 1
local CUSTOM_MISSION_DONE            = 2
local CUSTOM_MISSION_ACTION_AND_DONE = 3


 function IsHealthPlayer(player)

		for city in player:Cities() do
	    if	city:HasPlague() then
        return false
		   end
		end

		for unit in player:Units() do 
	    if	unit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED) then
		return false
		   end
		end

  return true
end


function GREAT_DOCTOR_MissionPossible(playerID, unitID, missionID, data1, data2, _, _, plotX, plotY, bTestVisible)
	local player = Players[playerID]

	if    missionID == GameInfoTypes["MISSION_CONSTRUCT_CITY"] then
		local unit = player:GetUnitByID(unitID)
		if unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_GREAT_DOCTOR"]   then
			local unitPlot = Map.GetPlot(plotX, plotY)
			local unitPlotCity = unitPlot:GetPlotCity()
			if ((not unitPlotCity) or ( unitPlotCity:IsHasBuilding(GameInfoTypes["BUILDING_LOCAL_HOSPITAL"])) ) then
				return bTestVisible
			end
			return true
		end


	elseif missionID == GameInfoTypes["MISSION_GREAT_DOCTOR_CURE"] then
		local unit = player:GetUnitByID(unitID)
		if unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_GREAT_DOCTOR"]   then
			local unitPlot = Map.GetPlot(plotX, plotY)
			local unitPlotCity = unitPlot:GetPlotCity()  
			if (unitPlot:GetOwner() == -1 or  playerID~= unitPlot:GetOwner() or IsHealthPlayer(player)) then
				return bTestVisible
			end
			return true
		end


	end
	return false
end
GameEvents.CustomMissionPossible.Add(GREAT_DOCTOR_MissionPossible)





function Health_MissionPossible(playerID, unitID, missionID, data1, data2, _, _, plotX, plotY, bTestVisible)
	local player = Players[playerID]
	if    missionID == GameInfoTypes["MISSION_DOCTOR_CURE_CITY"] then
		local unit = player:GetUnitByID(unitID)
		if unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_ERALY_DOCTOR"] 
	    or unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_MODERN_DOCTOR"]   then
			local unitPlot = Map.GetPlot(plotX, plotY)
			local unitPlotCity = unitPlot:GetPlotCity()
			if ((not unitPlotCity) or (not unitPlotCity:HasPlague()) ) then
				return bTestVisible
			end
			return true
		end
	elseif missionID == GameInfoTypes["MISSION_DOCTOR_CURE_UNIT"] then
		local unit = player:GetUnitByID(unitID)
		if unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_ERALY_DOCTOR"] 
	    or unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_MODERN_DOCTOR"]   then
			local unitPlot = Map.GetPlot(plotX, plotY)
			local unitPlotCity = unitPlot:GetPlotCity()  
			if (not IsNearDiseaseUnit(unit) ) then
				return bTestVisible
			end
			return true
		end
	end
	return false
end
GameEvents.CustomMissionPossible.Add(Health_MissionPossible)


function IsNearDiseaseUnit(unit)
      local num =0 
	  local iTileRadius = 2
	  for iShiftX = -iTileRadius, iTileRadius do
	  for iShiftY = -iTileRadius, iTileRadius do
	  local pTargetPlot = Map.PlotXYWithRangeCheck(unit:GetX(), unit:GetY(), iShiftX, iShiftY, 1)
      if pTargetPlot ~= nil then
      local unitCount = pTargetPlot:GetNumUnits();
      if unitCount > 0 then
      for i = 0, unitCount-1, 1 do
      local pFoundUnit = pTargetPlot:GetUnit(i);
	  if pFoundUnit ~= nil and pFoundUnit:GetOwner() == unit:GetOwner()  and pFoundUnit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED)
   	  then num=num+1 
		           end
		        end
		     end
		  end
	   end
	end
	if num >0 then
		 return true
	  end
	return false
end


-- Health_MissionStart
function Health_MissionStart(playerID, unitID, missionID, data1, data2, flags, turn)
	local player = Players[playerID]
	local unit = player:GetUnitByID(unitID)
	local city = unit:GetPlot():GetPlotCity()
	if missionID == GameInfoTypes["MISSION_DOCTOR_CURE_CITY"] then
		Health_CurePlagueMission(playerID, unit, city)
		return CUSTOM_MISSION_ACTION

	elseif missionID == GameInfoTypes["MISSION_DOCTOR_CURE_UNIT"] then
		Health_GrantPopulationMission(playerID, unit)
		return CUSTOM_MISSION_ACTION

	elseif missionID == GameInfoTypes["MISSION_CONSTRUCT_CITY"] then
		GREAT_DOCTOR_CONSTRUCT_Mission(playerID, unit, city)
		return CUSTOM_MISSION_ACTION

	elseif missionID == GameInfoTypes["MISSION_GREAT_DOCTOR_CURE"] then
		GREAT_DOCTOR_CURE_Mission(playerID, unit)
		return CUSTOM_MISSION_ACTION

	end
	return CUSTOM_MISSION_NO_ACTION
end
GameEvents.CustomMissionStart.Add(Health_MissionStart)

-- Health_MissionComplete
function Health_MissionComplete(playerID, unitID, missionID, data1, data2, flags, turn)
    local player = Players[playerID]
    if (missionID == GameInfoTypes["MISSION_DOCTOR_CURE_UNIT"] or missionID == GameInfoTypes["MISSION_DOCTOR_CURE_CITY"]
	or  missionID == GameInfoTypes["MISSION_GREAT_DOCTOR_CURE"] or missionID == GameInfoTypes["MISSION_CONSTRUCT_CITY"]) then 
	return true 
	end
	return false
end
GameEvents.CustomMissionCompleted.Add(Health_MissionComplete)


------------------------------------------------------------------------------------------------------------------------
-- GREAT PEOPLE UTILS
------------------------------------------------------------------------------------------------------------------------

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

function GREAT_DOCTOR_CONSTRUCT_Mission(playerID, unit, city)
   local player = Players[playerID]
   local plot = city:Plot();
   city:SetNumRealBuilding(GameInfoTypes["BUILDING_LOCAL_HOSPITAL"], 1)
   if player:IsHuman() then
	    local heading = Locale.ConvertTextKey("TXT_KEY_DOCTOR_CONSTRUCT_SHORT")
		local text = Locale.ConvertTextKey("TXT_KEY_DOCTOR_CONSTRUCT", city:GetName())
		player:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, text, heading, plot:GetX(),plot:GetY());
		Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
	end 
		unit:Kill();  
end


-- Health_CurePlagueMission
function Health_CurePlagueMission(playerID, unit, city)
	local player = Players[playerID]  
	if player:IsHuman() and city:HasPlague() then
		-- notification
	   Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
	   end
       Health_PlagueEnds(city)
	   unit:Kill()
end



-- Health_GrantPopulationMission
function Health_GrantPopulationMission(playerID, unit)
	local player = Players[playerID]
	local plot = unit:GetPlot();
	local unitCount = plot:GetNumUnits()  
	if unit then
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

--------------------------------------------------------------------
--�����ж� 
--------------------------------------------------------------------
--Player:GetCityPlagueTypeToSpawn
function GetCityPlagueTypeToSpawn(city)
    local player = Players[city:GetOwner()]
	local capital = player:GetCapitalCity()
	if (capital and player:IsCapitalConnectedToCity(city) and capital:HasPlague()) then
		return capital:GetPlagueType()
	end

	for _,v in ipairs(player:GetTradeRoutes()) do
		local fromCity = v.FromCity
		local toCity = v.ToCity
		if toCity == city then
			if fromCity:HasPlague() then
				return fromCity:GetPlagueType()
			end
		end
	end

	for _,v in ipairs(player:GetTradeRoutesToYou()) do
		local fromCity = v.FromCity
		local toCity = v.ToCity
		if toCity == city then
			if fromCity:HasPlague() then
				return fromCity:GetPlagueType()
			end
		end
	end

	local plagueBubonicID = GameInfoTypes["PLAGUE_BUBONIC"]
	local plagueID = plagueBubonicID
	local plagues = {}
	local count = 1
	for row in GameInfo.Plagues() do
		plagues[count] = row.ID
		count = count + 1
	end
	plagueID = plagues[Game.GetRandom(1,#plagues)]
	return plagueID or plagueBubonicID


end





function CitySetDoctor(iPlayer)
    local player = Players[iPlayer]
	if player == nil 

	or player:IsMinorCiv() 
	or player:IsBarbarian() 
	or player:IsHuman()
	or not player:IsAlive() 
	then return end

	local plaguecityTAB ={}
	local DoctorTAB ={}	
	local GreatDoctorTAB ={}	
	--local NumCanUse=0 	

	------Auto add doctor to cure
	for city in player:Cities() do		
	if  city:HasPlague()  then ------���д�������
	table.insert(plaguecityTAB, city)
			end
		end

	for unit in player:Units() do	
	if  unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_DOCTOR"].ID) then ------��ҽ����λ
	table.insert(DoctorTAB, unit)
	   end
	end

	for unit in player:Units() do	 
	if  unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_GREAT_DOCTOR"] then ------�д�ҽѧ�ҵ�λ
	table.insert(GreatDoctorTAB, unit)
		end
	end

	---------------------------------------------���ֲ�ͬ���----------------------------------
	if  #plaguecityTAB > 0 then  ---�������߳��У���ǰ�ᣩ


	if  #DoctorTAB > 0  then   ---����ͨҽ��
	    if  #GreatDoctorTAB == 0 then   ---�޴�ҽѧ��
		local randomNumber  = Game.GetRandom(1,#plaguecityTAB)
		local randomNumber2 = Game.GetRandom(1,#DoctorTAB)
		local tCITY = plaguecityTAB[randomNumber]
		local tUNIT = DoctorTAB[randomNumber2]
		Health_PlagueEnds(tCITY)  --����
		tUNIT:Kill()
		 print (" doctor cure health for ai !")
		 else   ---�д�ҽѧ��
		 local randomNumber3 = Game.GetRandom(1,#GreatDoctorTAB)
		 local tUNIT2 = GreatDoctorTAB[randomNumber3]
		 GREAT_DOCTOR_CURE_Mission(iPlayer, tUNIT2)
		 print ("great doctor cure health for ai !")
		 end
	 end

	 if  #DoctorTAB == 0 then    ---����ͨҽ��
	     if  #GreatDoctorTAB > 0  then   ---�д�ҽѧ��
		 local randomNumber4 = Game.GetRandom(1,#GreatDoctorTAB)
		 local tUNIT3 = GreatDoctorTAB[randomNumber4]
		 GREAT_DOCTOR_CURE_Mission(iPlayer, tUNIT3)
		 print ("great doctor cure health for ai !")
		 end
	 end

	
	 else  ---���������߳��У���ǰ�ᣩ
	 if  #GreatDoctorTAB > 0  then   ---�д�ҽѧ��
	 local randomNumber5 = Game.GetRandom(1,#GreatDoctorTAB)
	 local tUNIT4 = GreatDoctorTAB[randomNumber5]
	 local city = tUNIT4:GetPlot():GetPlotCity() or tUNIT4:GetPlot():GetWorkingCity();
	 if city~=nil 
	 and city:GetOwner()==iPlayer 
	 and not city:IsHasBuilding(GameInfoTypes.BUILDING_LOCAL_HOSPITAL) then ---δ���ѽ���ҽ�ݵĳ�����
	 city:SetNumRealBuilding(GameInfoTypes["BUILDING_LOCAL_HOSPITAL"], 1)
	 tUNIT4:Kill() 
	    end
	 end
	 
     if  LocalizingRandom(1,100) <=60 then
	 for unit in player:Units() do		
	 if  unit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED) then ------�л�����λ
	     unit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_PLAGUED"].ID, false); 
	         end
	      end
	   end
	end
end-------------Function End
GameEvents.PlayerDoneTurn.Add(CitySetDoctor)

--end




	