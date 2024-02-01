include("Plague_UI.lua");
include( "FLuaVector" );
include("FunctionUtilities.lua");
include("Rog_SaveUtils.lua"); MY_MOD_NAME = "世界强权";
--------------------------------------------------------------------
local defineCIDHealthPlagueMinThreshold		   = 150
if Game then defineCIDHealthPlagueMinThreshold = (GameDefines["HEALTH_PLAGUE_MIN_THRESHOLD_" .. GameInfo.GameSpeeds[Game.GetGameSpeedType()].Type] or 150) end
--------------------------------------------------------------------
--健康度
-------------------------------------------------------------------
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

--------------------------------------------------------------------
--杀死人口
function KillPopulation(player,city)
    local plagueID=city:GetPlagueType()
	local pop=0
	local bNotify = false
	
		if city:GetPopulation() > 2  then
		pop=math.max(math.floor(city:GetPopulation()/10),1)
	    city:ChangePopulation(-pop, true)
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


--Health_AttackReduce
function AttackReduceHealth(iAttackPlayer, iAttackUnit,iDefenderPlayer, iDefenderCity, iPlotX, iPlotY)
	local Attackplayer = Players[iAttackPlayer]
	local unit = player:GetUnitByID(iAttackUnit)
	local city   = Players[iDefenderPlayer]:GetCityByID(iDefenderCity)
	if player==nil or unit==nil or city==nil
	then return end
	if unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_HUIHUIPAO"].ID) then  
	if not city:HasPlague() then  
	local plagueCounter, plagueThreshold, plagueTurns = Players[iDefenderPlayer]:GetCityPlagueCounterDetails(city, true, true)
	if plagueCounter+2<=plagueThreshold then
	city:SetPlagueCounter(city:GetPlagueCounter()+2)
	      end
	   end
	end
end
GameEvents.UnitAttackCity.Add(AttackReduceHealth)



--Health_PlayerDoTurn
function Health_PlayerDoTurn(playerID)
	local player = Players[playerID]
	if (not player:IsAlive()) then return end
	if (not player:IsMajorCiv())  then return end 
	for city in player:Cities() do
		local totalHealth = city:GetYieldRate(GameInfoTypes["YIELD_HEALTH"])
	    local totalDisease = city:GetYieldRate(GameInfoTypes["YIELD_DISEASE"])
		local plagueCounter, plagueThreshold, plagueTurns = player:GetCityPlagueCounterDetails(city, true, true)
        local leftHealth = totalHealth - totalDisease

		if (not city:HasPlague()) then   
			if leftHealth > 0 then    
				if plagueCounter > 0 then     
				    if plagueCounter> leftHealth then
					city:ChangePlagueCounter(-leftHealth) 
					else 
					city:ChangePlagueCounter(-plagueCounter) 
				    end
                end 
			else
				city:ChangePlagueCounter(-leftHealth)
				plagueCounter, plagueThreshold, plagueTurns = player:GetCityPlagueCounterDetails(city, true, true)
				if plagueCounter >= plagueThreshold then 
					city:ChangePlagueTurns(GetNumTurn(player,city))
					city:SetPlagueCounter(0)
					PlagueBegins(city)
					city:ChangeDamage(100)

				--elseif (plagueTurns == 5) then    ---还有5回合爆发时提醒
					--SendNotification(playerID, "NOTIFICATION_PLAGUE", Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_IMMINENT_NOTIFICATION", city:GetName(), plagueTurns), Locale.ConvertTextKey("TXT_KEY_CITY_PLAGUE_IMMINENT_NOTIFICATION_SHORT", city:GetName()), false, city:GetX(), city:GetY())
				end
			end
        -------------------------------------------------------------------------------------------------------------------
		else
			if city:GetPlagueTurns() == 0 then
				PlagueEnds(city)
				KillPopulation(player,city)
			else
			if  totalDisease > 0 then  
					city:ChangeDamage(100)
					KillPopulation(player,city)
			   end
			end
		end
	end
end
GameEvents.PlayerDoTurn.Add(Health_PlayerDoTurn)


function CitySetDoctor(iPlayer)
    local player = Players[iPlayer]
	if player == nil or player:IsMinorCiv() or player:IsBarbarian() or player:IsHuman() or not player:IsAlive() 
	then return end

	local plaguecityTAB ={}
	local DoctorTAB ={}	
	local GreatDoctorTAB ={}	
	------Auto add doctor to cure
	for city in player:Cities() do		
	if  city:HasPlague()  then 
	table.insert(plaguecityTAB, city)
		end
	end
	for unit in player:Units() do	
	if  unit:GetUnitType() ==GameInfoTypes["UNIT_DOCTOR"] then 
	table.insert(DoctorTAB, unit)
	   end
	end
	for unit in player:Units() do	 
	if  unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_GREAT_DOCTOR"] then 
	table.insert(GreatDoctorTAB, unit)
		end
	end
	---------------------------------------------区分不同情况----------------------------------
	if  #plaguecityTAB > 0 then  

	if  #DoctorTAB > 0  then 
	    if  #GreatDoctorTAB == 0 then  
		local randomNumber  = ROG_GetTrueRandom(1,#plaguecityTAB)
		local randomNumber2 = ROG_GetTrueRandom(1,#DoctorTAB)
		local tCITY = plaguecityTAB[randomNumber]
		local tUNIT = DoctorTAB[randomNumber2]
		PlagueEnds(tCITY) 
		tUNIT:Kill()
		 print (" doctor cure health for ai !")
		 else  
		 local randomNumber3 =  ROG_GetTrueRandom(1,#GreatDoctorTAB)
		 local tUNIT2 = GreatDoctorTAB[randomNumber3]
		 GREAT_DOCTOR_CURE_Mission(iPlayer, tUNIT2)
		 print ("great doctor cure health for ai !")
		 end
	 end

	 if  #DoctorTAB == 0 then  
	     if  #GreatDoctorTAB > 0  then 
		 local randomNumber4 = ROG_GetTrueRandom(1,#GreatDoctorTAB)  	 
		 local tUNIT3 = GreatDoctorTAB[randomNumber4]
		 GREAT_DOCTOR_CURE_Mission(iPlayer, tUNIT3)
		 print ("great doctor cure health for ai !")
		 end
	 end
	 		     
	end
end
GameEvents.PlayerDoneTurn.Add(CitySetDoctor)




--PlagueEnds
function PlagueEnds(city)
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


--PlagueBegins
local cityFocusFoodID      = CityAIFocusTypes["CITY_AI_FOCUS_TYPE_FOOD"]
function PlagueBegins(city)	
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
		if unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_DOCTOR"] then
			local unitPlot = Map.GetPlot(plotX, plotY)
			local unitPlotCity = unitPlot:GetPlotCity()
			if ((not unitPlotCity) or (not unitPlotCity:HasPlague()) ) then
				return bTestVisible
			end
			return true
		end
	end
	return false
end
GameEvents.CustomMissionPossible.Add(Health_MissionPossible)



-- Health_MissionStart
function Health_MissionStart(playerID, unitID, missionID, data1, data2, flags, turn)
	local player = Players[playerID]
	local unit = player:GetUnitByID(unitID)
	local city = unit:GetPlot():GetPlotCity()

	if missionID == GameInfoTypes["MISSION_DOCTOR_CURE_CITY"]     then  ----医生治疗城市
		Health_CurePlagueMission(playerID, unit, city)
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
    if (missionID == GameInfoTypes["MISSION_DOCTOR_CURE_CITY"]
	or  missionID == GameInfoTypes["MISSION_GREAT_DOCTOR_CURE"]
	or missionID == GameInfoTypes["MISSION_CONSTRUCT_CITY"]) then 
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

        for city in player:Cities() do
		PlagueEnds(city)
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

--------------------------------------------------------------------
--其他判定 
--------------------------------------------------------------------
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








	