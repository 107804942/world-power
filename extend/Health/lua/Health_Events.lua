-- Author: 华盛顿的棒子
-- DateCreated: 2023.7.16 
--=======================================================================================================================
-- INCLUDES
--=======================================================================================================================
include("PlotIterators.lua");
include("Plague_UI.lua");
include( "FLuaVector" );
include("FunctionUtilities.lua");
include("Rog_SaveUtils.lua"); MY_MOD_NAME = "世界强权";
--------------------------------------------------------------------
local gCityHealthList		= {}
local defineCIDHealthPlagueMinThreshold		   = 150
if Game then defineCIDHealthPlagueMinThreshold = (GameDefines["HEALTH_PLAGUE_MIN_THRESHOLD_" .. GameInfo.GameSpeeds[Game.GetGameSpeedType()].Type] or 150) end

--------------------------------------------------------------------
--健康度
--------------------------------------------------------------------
local yieldFoodID	 = YieldTypes.YIELD_FOOD
local yieldGoldID	 = YieldTypes.YIELD_GOLD
local yieldProductionID	 = YieldTypes.YIELD_PRODUCTION
 
function GetNumTurn (player,city)
    local mathcheck=1    
    local NumTurn= math.max(0,math.ceil(city:GetPopulation()/10)+6 )  ---初始回合数
	if player~=nil and player:GetBuildingClassCount(GameInfo.BuildingClasses.BUILDINGCLASS_CENTERS.ID) > 0 then
	mathcheck=mathcheck-0.25
	end
	if  city:IsHasBuilding(GameInfoTypes.BUILDING_LOCAL_HOSPITAL) then ---有医馆
		mathcheck=mathcheck-0.25
	end
	return math.ceil(mathcheck*NumTurn)
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

--------------------------------------------------------------------
--杀死人口
function KillPopulation(player,city)
    local plagueID=city:GetPlagueType()
	local pop=0
	local bNotify = false
	
		if city:GetPopulation() > 2  then
		pop=math.max(math.floor(city:GetPopulation()/10),1)
	    city:ChangePopulation(-pop, true)
		--city:SetFood(0)
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
	if (not player:IsMajorCiv())  then return end 
	for city in player:Cities() do
		local totalHealth, totalDisease = player:GetCityHealthTotal(city, true) ---健康点数与疾病点数
		local plagueCounter, plagueThreshold, plagueTurns = player:GetCityPlagueCounterDetails(city, true, true)
        local leftHealth = totalHealth - totalDisease

		if  player:IsHuman() then 
			city:SetYieldModifierFromHealth(yieldFoodID, 0) 
	        city:SetYieldFromHealth(yieldFoodID, 0)
			city:SetYieldModifierFromHealth(yieldProductionID, 0) 
	        city:SetYieldFromHealth(yieldProductionID, 0)
			if leftHealth<0 then
			city:SetYieldModifierFromHealth(yieldProductionID, GetHealthYieldBuff(player,city,leftHealth)) 
			city:SetYieldFromHealth(yieldProductionID, GetHealthYieldBuff(player,city,leftHealth))	
	        city:SetYieldModifierFromHealth(yieldFoodID, GetHealthYieldBuff(player,city,leftHealth)) 
	        city:SetYieldFromHealth(yieldFoodID, GetHealthYieldBuff(player,city,leftHealth))
	        end
        end

		if (not city:HasPlague()) then   ---城市当前无瘟疫
			----------情形1
			if leftHealth > 0 then    --健康度富余
				if plagueCounter > 0 then     ---已有累计进度
				    if plagueCounter> leftHealth then
					city:ChangePlagueCounter(-leftHealth) 
					else 
					city:ChangePlagueCounter(-plagueCounter) 
				 end
             end 

			----------情形2
			elseif (leftHealth<0 ) then   --健康度不足
				city:ChangePlagueCounter(-leftHealth)
				plagueCounter, plagueThreshold, plagueTurns = player:GetCityPlagueCounterDetails(city, true, true)
				if plagueCounter >= plagueThreshold then   ---立即爆发无需提示
					city:ChangePlagueTurns(GetNumTurn(player,city))
					city:SetPlagueCounter(0)
					Health_PlagueBegins(city)
					city:ChangeDamage(100)
					DiseaseUnits(city)

				--elseif (plagueTurns == 5) then    ---还有5回合爆发时提醒
					--SendNotification(playerID, "NOTIFICATION_PLAGUE", Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_IMMINENT_NOTIFICATION", city:GetName(), plagueTurns), Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_IMMINENT_NOTIFICATION_SHORT", city:GetName()), false, city:GetX(), city:GetY())
				end
			end
        -------------------------------------------------------------------------------------------------------------------
		else
			if city:GetPlagueTurns() == 0 then
				Health_PlagueEnds(city)
				KillPopulation(player,city)
			else

			if  totalDisease > 0 then  ---处于瘟疫中
					city:ChangeDamage(100)
					DiseaseUnits(city)
					KillPopulation(player,city)
			   end
			end
		end
	end
end
GameEvents.PlayerDoTurn.Add(Health_PlayerDoTurn)


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
	------Auto add doctor to cure
	for city in player:Cities() do		
	if  city:HasPlague()  then ------城市处于瘟疫
	table.insert(plaguecityTAB, city)
			end
		end

	for unit in player:Units() do	
	if  unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_DOCTOR"].ID) then ------有医生单位
	table.insert(DoctorTAB, unit)
	   end
	end

	for unit in player:Units() do	 
	if  unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_GREAT_DOCTOR"] then ------有大医学家单位
	table.insert(GreatDoctorTAB, unit)
		end
	end
	---------------------------------------------区分不同情况----------------------------------
	if  #plaguecityTAB > 0 then  ---存在瘟疫城市（大前提）

	if  #DoctorTAB > 0  then   ---有普通医生
	    if  #GreatDoctorTAB == 0 then   ---无大医学家
		local randomNumber  = ROG_GetTrueRandom(1,#plaguecityTAB)
		--Game.GetRandom(1,#plaguecityTAB)
		local randomNumber2 = ROG_GetTrueRandom(1,#DoctorTAB)
		--Game.GetRandom(1,#DoctorTAB)
		local tCITY = plaguecityTAB[randomNumber]
		local tUNIT = DoctorTAB[randomNumber2]
		Health_PlagueEnds(tCITY)  --治疗
		tUNIT:Kill()
		 print (" doctor cure health for ai !")
		 else   ---有大医学家
		 local randomNumber3 =  ROG_GetTrueRandom(1,#GreatDoctorTAB)
		 --Game.GetRandom(1,#GreatDoctorTAB)
		 local tUNIT2 = GreatDoctorTAB[randomNumber3]
		 GREAT_DOCTOR_CURE_Mission(iPlayer, tUNIT2)
		 print ("great doctor cure health for ai !")
		 end
	 end

	 if  #DoctorTAB == 0 then    ---无普通医生
	     if  #GreatDoctorTAB > 0  then   ---有大医学家
		 local randomNumber4 = ROG_GetTrueRandom(1,#GreatDoctorTAB)  	 
		 --Game.GetRandom(1,#GreatDoctorTAB)
		 local tUNIT3 = GreatDoctorTAB[randomNumber4]
		 GREAT_DOCTOR_CURE_Mission(iPlayer, tUNIT3)
		 print ("great doctor cure health for ai !")
		 end
	 end

	
	 else  ---不存在瘟疫城市（大前提）
	 if  #GreatDoctorTAB > 0  then   ---有大医学家
	 local randomNumber5 = ROG_GetTrueRandom(1,#GreatDoctorTAB) 
	 --Game.GetRandom(1,#GreatDoctorTAB)
	 local tUNIT4 = GreatDoctorTAB[randomNumber5]
	 local city = tUNIT4:GetPlot():GetPlotCity() or tUNIT4:GetPlot():GetWorkingCity();
	 if city~=nil 
	 and city:GetOwner()==iPlayer 
	 and not city:IsHasBuilding(GameInfoTypes.BUILDING_LOCAL_HOSPITAL) then ---未在已建造医馆的城市中
	 city:SetNumRealBuilding(GameInfoTypes["BUILDING_LOCAL_HOSPITAL"], 1)
	 tUNIT4:Kill() 
	    end
	 end
	 
     if  LocalizingRandom(1,100) <=60 then
	 for unit in player:Units() do		
	 if  unit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED) then ------有患病单位
	     unit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_PLAGUED"].ID, false); 
	         end
	      end
	   end
	end
end
GameEvents.PlayerDoneTurn.Add(CitySetDoctor)

--------------------------------------------------------------------
---对单位造成伤害
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
		if  pFoundUnit~=nil and pFoundUnit:NukeDamageLevel()== -1  and not pFoundUnit:IsImmuePlague() then
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
	 -- Notification
	if player:IsHuman() and plagueID ~= -1 then
	local plague = GameInfo.Plagues[plagueID]
	local heading = Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_ENDS_NOTIFICATION_SHORT")
	local text = Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_ENDS_NOTIFICATION",plague.IconString,plague.Description,city:GetName())
	player:AddNotification(NotificationTypes.NOTIFICATION_INSTANT_YIELD, text, heading,city:GetX(),city:GetY())
	Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
	end
	--city:SetAdditionalFood(0)
	city:SetPlagueType(-1)
	city:SetPlagueCounter(0)
end


--Health_PlagueBegins
local cityFocusFoodID      = CityAIFocusTypes["CITY_AI_FOCUS_TYPE_FOOD"]
function Health_PlagueBegins(city)	
    local player = Players[city:GetOwner()]
	local plagueID= GetCityPlagueTypeToSpawn(city)
	city:SetPlagueType(plagueID)
	 -- Notification
	if player:IsHuman() and plagueID ~= -1 then
	local plague = GameInfo.Plagues[plagueID]
	local heading = Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_NOTIFICATION_SHORT")
	local text = Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_NOTIFICATION",plague.IconString,plague.Description, city:GetName())
	player:AddNotification(NotificationTypes.NOTIFICATION_PLAGUE, text, heading, city:GetX(),city:GetY());
	end
	Events.AudioPlay2DSound("AS2D_PLAGUE")
end



-- **********************************************************************************************************************************************
-- 浮石章鱼
-- **********************************************************************************************************************************************
--local NoPlagues	 = (PreGame.GetGameOption("GAMEOPTION_PLAGUE_DISABLED") == 1)  
--local AbandonCity	 = (PreGame.GetGameOption("GAMEOPTION_PLAGUE_DESTROYS_CITIES") == 1)  

local PlagueMissionButton = {
		Name = "TXT_KEY_NAME_CREAT_PLAGUE",
		Title = "TXT_KEY_TITLE_CREAT_PLAGUE",
		OrderPriority = 300,
		IconAtlas = "SP_UNIT_ACTION_ATLAS2",
		PortraitIndex = 25,
		ToolTip = function(action, unit)
			local sTooltip;
			local pPlayer = Players[Game:GetActivePlayer()];
			local bIsValid = CheckPlagueMissionButtonValidity( unit);
			if bIsValid then
				sTooltip = Locale.ConvertTextKey( "TXT_KEY_COND_CREAT_PLAGUE");
			else
				sTooltip = Locale.ConvertTextKey( "TXT_KEY_COND_CREAT_PLAGUE_2" );
			end
			return sTooltip
		end, -- or a TXT_KEY_ or a function
		Condition = function(action, unit)
			if unit:GetMoves() <= 0 then
				return false
			end
				if unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_HOVER_WORM"].ID) then
					return true
				else
					return false
			end
			
		end, -- or nil or a boolean, default is true
		Disabled = function(action, unit)
			local bIsValid = CheckPlagueMissionButtonValidity(unit);
			if bIsValid then
				return false
			end
			return true;
		end, -- or nil or a boolean, default is false
		Action = function(action, unit, eClick)
		if eClick == Mouse.eRClick then
			return
		end
		    local city = unit:GetPlot():GetPlotCity() or unit:GetPlot():GetWorkingCity()
			if 	city~=nil then
			unit:SetMoves(0)
			local zombie = Players[63]:InitUnit(GameInfoTypes["UNIT_ZOMBIE"], city:GetX()+1, city:GetY())
			zombie:JumpToNearestValidPlot()

			if  city:HasPlague() then   ----有瘟疫则延长持续
				city:ChangePlagueTurns(city:GetPlagueTurns()+8)
				Events.AudioPlay2DSound("AS2D_PLAGUE")
			else
			    city:SetPlagueCounter(0)
			    Health_PlagueBegins(city)
			    city:ChangeDamage(250)
			    DiseaseUnits(city)			    
		 end
	  end
  end
}
LuaEvents.UnitPanelActionAddin(PlagueMissionButton)


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
		if unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_DOCTOR"] or unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_MODERN_DOCTOR"] then
			local unitPlot = Map.GetPlot(plotX, plotY)
			local unitPlotCity = unitPlot:GetPlotCity()
			if ((not unitPlotCity) or (not unitPlotCity:HasPlague()) ) then
				return bTestVisible
			end
			return true
		end
	elseif missionID == GameInfoTypes["MISSION_DOCTOR_CURE_UNIT"] then
		local unit = player:GetUnitByID(unitID)
		if unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_DOCTOR"]  or unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_MODERN_DOCTOR"]  then
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

	if missionID == GameInfoTypes["MISSION_DOCTOR_CURE_CITY"]     then  ----医生治疗城市
		Health_CurePlagueMission(playerID, unit, city)
		return CUSTOM_MISSION_ACTION

	elseif missionID == GameInfoTypes["MISSION_DOCTOR_CURE_UNIT"] then  ----医生治疗单位
		Health_GrantPopulationMission(playerID, unit)
		return CUSTOM_MISSION_ACTION

	elseif missionID == GameInfoTypes["MISSION_CONSTRUCT_CITY"]   then
		GREAT_DOCTOR_CONSTRUCT_Mission(playerID, unit, city)
		return CUSTOM_MISSION_ACTION

	elseif missionID == GameInfoTypes["MISSION_GREAT_DOCTOR_CURE"]then
		GREAT_DOCTOR_CURE_Mission(playerID, unit)
		return CUSTOM_MISSION_ACTION
	end

	return CUSTOM_MISSION_NO_ACTION
end
GameEvents.CustomMissionStart.Add(Health_MissionStart)

-- Health_MissionComplete
function Health_MissionComplete(playerID, unitID, missionID, data1, data2, flags, turn)
    local player = Players[playerID]
    if (missionID == GameInfoTypes["MISSION_DOCTOR_CURE_UNIT"]  or missionID == GameInfoTypes["MISSION_DOCTOR_CURE_CITY"]
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
	local NumUseForCureAll = load(unit, "UseForCure") or 0

	    for  Unit in player:Units() do 	
   		if   Unit ~= nil  and Unit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED)
   		then Unit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_PLAGUED"].ID, false); 
		   end
		end
        for city in player:Cities() do
		Health_PlagueEnds(city)
		end

		NumUseForCureAll=NumUseForCureAll+1
		unit:SetMoves(0)
		save(unit, "UseForCure", NumUseForCureAll)
		Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
		if NumUseForCureAll>2 then
	   	unit:Kill(); 
	    end 
		--------------------------------------------------------------------------------------------------------------------------------------		
		if player:IsHuman() then
	    local heading = Locale.ConvertTextKey("TXT_KEY_DOCTOR_CURED_SHORT")
		local text = Locale.ConvertTextKey("TXT_KEY_DOCTOR_CURED")
		player:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, text, heading, plot:GetX(), plot:GetY());
    end  
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
		unit:Kill()
end


-- Health_CurePlagueMission
function Health_CurePlagueMission(playerID, unit, city)
	local player = Players[playerID]  
	if player:IsHuman() and city:HasPlague() then
	local plagueID=city:GetPlagueType()  ---疾病种类
	if plagueID ~= -1 then
	------------------------------------------不足六回合立即治愈
	if city:GetPlagueTurns()<6+GetExtraCureTurns(unit, city) then
	 -- Notification
	local plague = GameInfo.Plagues[plagueID]
	local heading = Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_ENDS_NOTIFICATION_SHORT")
	local text = Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_ENDS_NOTIFICATION",plague.IconString,plague.Description,city:GetName())
	player:AddNotification(NotificationTypes.NOTIFICATION_INSTANT_YIELD, text, heading,city:GetX(),city:GetY())
	Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
	city:SetPlagueType(-1)
	city:SetPlagueCounter(0)
	------------------------------------------大于六回合减少回合数
	else  
	 -- Notification
	local reduce= 5+GetExtraCureTurns(unit, city)
	local plague = GameInfo.Plagues[plagueID]
	local heading = Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_REDUCE_NOTIFICATION_SHORT")
	local text = Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_REDUCE_NOTIFICATION",plague.IconString,plague.Description,city:GetName(),reduce)
	player:AddNotification(NotificationTypes.NOTIFICATION_INSTANT_YIELD, text, heading,city:GetX(),city:GetY())  
	Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
	city:ChangePlagueTurns(-reduce)
	--city:SetPlagueCounter(city:GetPlagueTurns()-5)
	end
	------------------------------------------
	unit:Kill()
	   end
	end
		
end


-- Extra Cure Turn
function GetExtraCureTurns(unit, city)
   local ExtraCureTurn =0
   local player = Players[unit:GetOwner()]  
   if  player:HasPolicy(GameInfo.Policies["POLICY_KNOWLEDGE_4"].ID) then  ExtraCureTurn=ExtraCureTurn+2 end
   if  city:IsHasBuilding(GameInfoTypes["BUILDING_HERBALIST"]) then ExtraCureTurn=ExtraCureTurn+1 end
   if  city:IsHasBuilding(GameInfoTypes["BUILDING_HOSPITAL"]) then ExtraCureTurn=ExtraCureTurn+2 end
   return 
   ExtraCureTurn
end


-- Health_GrantPopulationMission
function Health_GrantPopulationMission(playerID, unit)
	local player = Players[playerID]
	local plot = unit:GetPlot();
	local unitCount = plot:GetNumUnits()  
	if unit then
	local NumUseForCureUnit = load(unit, "UseForCureUnit") or 0
	--------------------------------------------------------------------------------------------------------------------------------------
		local extraRange = 2	
	    for dx = -extraRange, extraRange - 1, 1 do
	    for dy = -extraRange, extraRange - 1, 1 do
        local adjPlot = Map.PlotXYWithRangeCheck(plot:GetX(), plot:GetY(), dx, dy, 1);
		if adjPlot ~= nil then
		unitCount = adjPlot:GetNumUnits();
        if unitCount > 0 then
		for i = 0, unitCount-1, 1 do
        local pFoundUnit = adjPlot:GetUnit(i);
        if pFoundUnit:GetOwner() == unit:GetOwner() and  pFoundUnit:IsHasPromotion(GameInfoTypes.PROMOTION_PLAGUED) then
		pFoundUnit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_PLAGUED"].ID, false)
		               end
		            end
		         end
		      end
		   end
		end
		NumUseForCureUnit=NumUseForCureUnit+1
		save(unit, "UseForCureUnit", NumUseForCureUnit)
		Events.AudioPlay2DSound("AS2D_SOUND_DOCTOR")
		unit:SetMoves(0)
		if NumUseForCureUnit>2 then
	   	unit:Kill()
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
--其他判定 
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








	