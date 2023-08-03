-- Author: 华盛顿的棒子
-- DateCreated: 2021/2/22 21:38:22
--------------------------------------------------------------
include("Rog_SaveUtils.lua"); MY_MOD_NAME = "世界强权";
include("PlotIterators.lua");
include("FLuaVector.lua");
include("CityView.lua")
include("InfoTooltipInclude");
include("FunctionUtilities.lua");




function DoSomeEffects(playerID)
    local player = Players[playerID]
    if (not player:IsMajorCiv())
	or (not player:IsAlive())
	then return 
	end

	for unit in player:Units() do  

	 if unit:IsHasPromotion(GameInfoTypes.PROMOTION_BURNING_EFFECT) ---猛火油柜
		then
		local damage = math.floor(unit:GetCurrHitPoints()*0.4)
		local damagefinal = math.max(20,damage)
		      unit:ChangeDamage(damagefinal)                                  
		   end

       if  load(unit, "DoFireSelf") ~= nil    ---突击虎
	   or  load(unit, "DoFireSupport") ~= nil then
		   save(unit, "DoFireSelf", nil)
		   save(unit, "DoFireSupport", nil)
           end
	   end

end
GameEvents.PlayerDoTurn.Add(DoSomeEffects)


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
		local Unit =  pPlayer:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
		local Unit2 = pPlayer:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
		end
		if iNumFighters == 5  then
		local Unit4 = pPlayer:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
			    end
			end
		end
	end
	
end
GameEvents.PlayerDoneTurn.Add(DoneSomeEffects)


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

------------------------------------------------------------------

function CanHavePromotion(iPlayer, iUnit, iPromotionType)
  local pUnit = Players[iPlayer]:GetUnitByID(iUnit)


  if iPromotionType == GameInfoTypes.PROMOTION_GUN_2 then
  if pUnit:GetBaseRangedCombatStrength()>0   then 
  return false
     end
  end

  if iPromotionType == GameInfoTypes.PROMOTION_AIR_RANGE_EXTEND then
  if pUnit:GetUnitType() == GameInfoTypes["UNIT_NUCLEAR_ARTILLERY"]  then 
  return false
     end
  end

   return true
end
GameEvents.CanHavePromotion.Add(CanHavePromotion)

------------------------------------------------------------------


function TourismToGold(iPlayer, iUnit, iX, iY, bIsGreatPerson)
local pPlayer = Players[iPlayer]
local pUnit = pPlayer:GetUnitByID(iUnit)
if bIsGreatPerson 
and pPlayer:HasWonder(GameInfoTypes.BUILDING_KARLSTEJN) then
local gold = pPlayer:CalculateGoldRate()
pPlayer:ChangeGold(3*gold)
   end
end
GameEvents.TourismDiscover.Add(TourismToGold)






function ProduceCopy(iPlayer, iUnit, iGreatWork)
	local player = Players[iPlayer]
	if player == nil or (not player:IsMajorCiv())   then
		return
	end 
	if player:GetNumCities() <= 0 or not player:HasWonder(GameInfoTypes.BUILDING_KARLSTEJN)   then
		return
	end

		local gw
		for i,v in ipairs(player:GetGreatWorks(4)) do
			if load(player,"HaveCopied" .. Game.GetGreatWorkName(v.Index)) == nil and Game.GetGreatWorkCreator(v.Index) == iPlayer then
				gw = v.Index
				save(player,"HaveCopied" .. Game.GetGreatWorkName(v.Index), true)
				break
			end
		end
		if gw then
			local city = player:GetCityOfClosestGreatWorkSlot(player:GetCapitalCity():GetX(), player:GetCapitalCity():GetY(), GameInfoTypes["GREAT_WORK_SLOT_MUSIC"])
			if city then
		        local building = player:GetBuildingOfClosestGreatWorkSlot(player:GetCapitalCity():GetX(), player:GetCapitalCity():GetY(), GameInfoTypes["GREAT_WORK_SLOT_MUSIC"])
		        if  building then
			        building = GameInfo.Buildings[building]
			        local buildingClass = building.BuildingClass
			        local availableSlots = building.GreatWorkCount
					for slot = 0, availableSlots-1, 1 do
						if  city:GetBuildingGreatWork(GameInfoTypes[buildingClass], slot) == -1 then
							city:SetBuildingGreatWork(GameInfoTypes[buildingClass],slot,gw)
							break
						--end
					end
				end
			end
		end
	end
end
GameEvents.GreatWorkCreated.Add(ProduceCopy)



	
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



function FaithCure(iPlayer, iUnit, iX, iY, bIsGreatPerson)
    local Player = Players[iPlayer]
	local iTileRadius = 3

	--if bIsGreatPerson then
      if Player:HasWonder(GameInfoTypes.BUILDING_PUMA_PUMKU) then
 
      for iShiftX = -iTileRadius, iTileRadius do
	  for iShiftY = -iTileRadius, iTileRadius do
	  local pTargetPlot = Map.PlotXYWithRangeCheck(iX, iY, iShiftX, iShiftY, iTileRadius)
      if pTargetPlot ~= nil  then
      unitCount = pTargetPlot:GetNumUnits()
      if unitCount > 0 then
      for i = 0, unitCount-1, 1 do
      local pFoundUnit = pTargetPlot:GetUnit(i)
      if pFoundUnit:GetOwner()==iPlayer then
	  pFoundUnit:ChangeDamage(-25) 
	                   end
	                end
	             end
	          end 
		   end
	    end
	end

    if Player:HasWonder(GameInfoTypes.BUILDING_OSARAGI) then
	for unit in Player:Units() do
	unit:ChangeDamage(-20) 
	   end
	end

 end
GameEvents.FaithDiscover.Add(FaithCure)




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


-- ****************************************
-- 贝伦塔
-- ****************************************	
function PromotedWonderBuff(iPlayer, iUnit, iPromotionType)
  local player = Players[iPlayer]
  local unit = player:GetUnitByID(iUnit)

  if player == nil or (not player:IsMajorCiv()) then
	 	return
	         end

  if player:HasWonder(GameInfoTypes.BUILDING_BEILUN_TOWER) then 
  if unit:GetDomainType() ==DomainTypes.DOMAIN_SEA and unit:IsCombatUnit() then
	   unit:ChangeDamage(-50)
	   --unit:SetMoves(unit:MaxMoves());
         end
	  end

  if player:HasWonder(GameInfoTypes.BUILDING_KRAK_DES_CHEVALIERS) then  
    if unit:GetDamage() >0 and unit:GetUnitCombatType()==GameInfoTypes["UNITCOMBAT_MOUNTED"] and
	unit:IsHasPromotion(GameInfoTypes.PROMOTION_KNIGHT_COMBAT) then
	unit:ChangeDamage(-50) 
           end
	  end
end    
GameEvents.UnitPromoted.Add(PromotedWonderBuff)



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


function RemoveJungle(iPlayer, iUnit, iX, iY, iBuild)
   if iBuild == GameInfoTypes.BUILD_REMOVE_JUNGLE 
   or iBuild == GameInfoTypes.BUILD_REMOVE_FOREST then
   local  pPlot = Map.GetPlot(iX, iY)
   if  pPlot:GetResourceType()==GameInfoTypes.RESOURCE_LUMBER then
   pPlot:SetResourceType(-1)
       end
    end
 end
GameEvents.PlayerBuilt.Add(RemoveJungle)



-- ****************************************
-- 异种研究所
-- ****************************************	
function JurassicParkBonus(iPlayer)
	local pPlayer = Players[iPlayer];
	if pPlayer == nil or (not pPlayer:IsMajorCiv()) then
	 	return
	         end
    if pPlayer:GetCurrentEra()~=GameInfoTypes.ERA_FUTURE  then
			return
	   end
	if  pPlayer:HasWonder(GameInfoTypes.BUILDING_FW_JURASSIC_PARK)  then

		local iCheckForDinos = LocalizingRandom(1, 100)
		if (iCheckForDinos < 90) then
			local tPlots ={}
			local tPlots2 ={}
			for pCity in pPlayer:Cities() do
					if pCity:IsHasBuilding(GameInfoTypes.BUILDING_FW_JURASSIC_PARK) then	
						local pCentralPlot = pCity:Plot()
			             for pPlot in PlotAreaSpiralIterator(pCentralPlot, 4, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
							local iTerrain = pPlot:GetTerrainType()
							local iOwner = pPlot:GetOwner()
							if (((iTerrain == GameInfoTypes.TERRAIN_PLAINS) or 
							(iTerrain == GameInfoTypes.TERRAIN_GRASS)) 
							and (iOwner == iPlayer) and (pPlot:GetNumUnits() == 0) and not (pPlot:IsMountain())) then
								table.insert(tPlots, pPlot)
								end
                            if (((iTerrain == GameInfoTypes.TERRAIN_OCEAN) ) 
							and (iOwner == iPlayer) and (pPlot:GetNumUnits() == 0) 
							and not (pPlot:IsMountain())) then
								table.insert(tPlots2, pPlot)
								end
								--print("Inserted plot")
							end
						end
					end
				--end
			--end
			if #tPlots > 0 then
				local randomNumber = LocalizingRandom(1, #tPlots)
				local tPlot = tPlots[randomNumber]
				local iDinoNumber = LocalizingRandom(1, 100)
				--print("单位种类 " .. 根据随机数确定)
				if (iDinoNumber >= 80) and  (pPlayer:GetUnitClassCount(GameInfo.UnitClasses.UNITCLASS_ALIEN_SIEGE_WORM.ID) == 0 ) then 
					iDinoType = GameInfoTypes.UNIT_ALIEN_SIEGE_WORM
					local nUnit = pPlayer:InitUnit(iDinoType, tPlot:GetX(), tPlot:GetY())
				end
				if (iDinoNumber <= 10) and  (pPlayer:GetUnitClassCount(GameInfo.UnitClasses.UNITCLASS_HOVER_WORM.ID) == 0 ) 
				and pPlayer:IsHasTech(GameInfo.Technologies["TECH_COGNITIVE"].ID) then 
					iDinoType3 = GameInfoTypes.UNIT_HOVER_WORM
					local nUnit3 = pPlayer:InitUnit(iDinoType3, tPlot:GetX(), tPlot:GetY())
					end
				end
             if #tPlots2 > 0 then
				local randomNumber = LocalizingRandom(1, #tPlots2)
				local tPlot2 = tPlots2[randomNumber]
				local iDinoNumber = ROG_GetTrueRandom(1, 100)
				if (iDinoNumber <= 15) and  (pPlayer:GetUnitClassCount(GameInfo.UnitClasses.UNITCLASS_NAVAL_MONSTER.ID) == 0 ) 
				and pPlayer:IsHasTech(GameInfo.Technologies["TECH_MATTERTRANSMISSION"].ID) then 
					iDinoType2 = GameInfoTypes.UNIT_NAVAL_MONSTER
					local nUnit2 = pPlayer:InitUnit(iDinoType2, tPlot2:GetX(), tPlot2:GetY())
				end
			end
		end
	end
end
GameEvents.PlayerDoTurn.Add(JurassicParkBonus)



--UI/InGame/Popups/ProductionPopup.lua
--Events.SpecificCityInfoDirty( player, cityID, CityUpdateTypes.CITY_UPDATE_TYPE_BANNER);
--Events.SpecificCityInfoDirty( player, cityID, CityUpdateTypes.CITY_UPDATE_TYPE_PRODUCTION);



-- ****************************************************************
-- 高德院
-- ****************************************************************	
function BuffForLiberated(iPlayer, iOtherPlayer, iCity) 
	local pPlayer = Players[iPlayer]; 
	if pPlayer == nil or (not pPlayer:IsMajorCiv())  then
	 	return
	         end
			  if pPlayer:HasWonder(GameInfoTypes.BUILDING_OSARAGI)then				
			    for row in GameInfo.MinorCivilizations() do	
				 if row.Type ~=nil then 
				 if Players[row.ID]:IsMinorCiv() then
					if Players[row.ID]:IsEverAlive() and Players[row.ID]:IsAlive() then
					Players[row.ID]:ChangeMinorCivFriendshipWithMajor(iPlayer,50)
					end
				end
			end
		end
	end
end
GameEvents.PlayerLiberated.Add(BuffForLiberated)




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




-- ********************************************************
--加速建造
-- ********************************************************
local tWonders = {}
for row in DB.Query("SELECT ID FROM Buildings WHERE BuildingClass IN (SELECT Type FROM BuildingClasses WHERE MaxGlobalInstances = 1 OR MaxTeamInstances = 1 OR MaxPlayerInstances = 1)") do
	tWonders[row.ID] = true
end



function Palmyra(iPlayer)
	local pPlayer = Players[iPlayer]
	if pPlayer == nil or (not pPlayer:IsMajorCiv()) then
	 	return
	         end
	--if  policyID ~=nil  then
	if  pPlayer:HasWonder(GameInfoTypes.BUILDING_PALMYRA)
	and pPlayer:IsGoldenAge() then

	for city in pPlayer:Cities() do
	local iCurrentBuilding = city:GetProductionBuilding();
	if iCurrentBuilding ~= -1 and (not tWonders[iCurrentBuilding])  then
	local prod = city:GetProductionNeeded()
	city:SetProduction(prod)
	local cityID = city:GetID()
	local playerID = city:GetOwner()
	Events.SpecificCityInfoDirty(playerID, cityID, CityUpdateTypes.CITY_UPDATE_TYPE_BANNER)
	Events.SpecificCityInfoDirty(playerID, cityID, CityUpdateTypes.CITY_UPDATE_TYPE_PRODUCTION)
	Events.SerialEventGameDataDirty()
             end
          end
       end
   end
GameEvents.PlayerAdoptPolicy.Add(Palmyra)
GameEvents.PlayerAdoptPolicyBranch.Add(Palmyra)


-- ********************************************************
-- 阿基米德
-- ********************************************************	 
function ARCHIMEDES(plot)
         if plot==nil then
         return false
		 end
		 local city= plot:GetWorkingCity()
		 if city~=nil and city:IsHasBuilding(GameInfoTypes.BUILDING_ARCHIMEDES) then
		    return true  
	    end
  return false 
end 

function ARCHIMEDES(iPlayer, iUnit, iX, iY, iBuild)
   if iBuild == GameInfoTypes.BUILD_BEACON  then
   local plot= Map.GetPlot(iX, iY)
   local pPlayer = Players[iPlayer]
   if pPlayer:HasWonder(GameInfoTypes.BUILDING_ARCHIMEDES) 
   and ARCHIMEDES(plot) 
   and pPlayer:CountAllImprovement(GameInfoTypes["IMPROVEMENT_BEACON"])==0    then
      return true
		 end   
	  return false
	  end
	  return true
 end
GameEvents.PlayerCanBuild.Add(ARCHIMEDES)




-- **********************************************************************************************************************************************
-- 购买地块
-- **********************************************************************************************************************************************
function GetCultureGain(pPlayer)
	local iEra = pPlayer:GetCurrentEra()
	return (iEra + 1) 
end


function MagaBoughtPlot(iPlayer, iCity, iPlotX, iPlotY, bGold, bCulture)  
	local Player = Players[iPlayer]
	--local plot = Map.GetPlot(iPlotX, iPlotY)
	local city = Player:GetCityByID(iCity)
	if Player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_AMERICA"]  then
	--if bGold then
	local iGain = GetCultureGain(Player)
	city:ChangeProduction(20*iGain)
	Player:ChangeJONSCulture(20*iGain)
	  -- end
	end
end
GameEvents.CityBoughtPlot.Add(MagaBoughtPlot)



-- ********************************************************
-- 环球航行
-- ********************************************************
local g_NotificationType = NotificationTypes.NOTIFICATION_GENERIC
function OnMagellanNotificationId(id)
  print(string.format("Setting magellan notification id to %i", id))
  g_NotificationType = id
end
LuaEvents.MagellanNotificationId.Add(OnMagellanNotificationId)

function OnCircumnavigatedGlobe(iTeam)
  local pPlayer = Players[Game.GetActivePlayer()]
  local sHead = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_HEAD")
  local sText = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_TEXT_UNKNOWN")

  local Team = Teams[iTeam]
  local Player = Players[Team:GetLeaderID()];
  local plot =  Player:GetCapitalCity():Plot()
  local Unit  = Player:InitUnit(GameInfoTypes.UNIT_SCIENTIST, plot:GetX(), plot:GetY())

  if (Game.GetActiveTeam() == iTeam) then
    sText = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_TEXT_YOU")
  else
    if (Teams[Game.GetActiveTeam()]:IsHasMet(iTeam)) then
      sText = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_TEXT_KNOWN", Players[Teams[iTeam]:GetLeaderID()]:GetCivilizationShortDescriptionKey())
	end
  end

  pPlayer:AddNotification(g_NotificationType, sText, sHead, -1, -1, -1, -1)
end
GameEvents.CircumnavigatedGlobe.Add(OnCircumnavigatedGlobe)
LuaEvents.MagellanNotificationIdRequest()




  
-- ********************************************************
-- 
-- ********************************************************           
function GUIGU(iPlayer, iUnit, iUnitType, iX, iY)
local pPlayer = Players[iPlayer]
local pUnit = pPlayer:GetUnitByID(iUnit);
if pPlayer == nil or (not pPlayer:IsMajorCiv())   then
	 	return
	         end
 if pUnit == nil  then
	 	return
	         end
if  pPlayer:HasWonder(GameInfoTypes.BUILDING_GUIGU) 
and pPlayer:IsGoldenAge()  then
local randomNumber = ROG_GetTrueRandom(1, 100)
if randomNumber<=20 then
pPlayer:InitUnit(pUnit:GetUnitType(), iX,iY)
if pPlayer:IsHuman() then
	local title = Locale.ConvertTextKey("TXT_KEY_GUIGU_HEAD");
	local descr = Locale.ConvertTextKey("TXT_KEY_GUIGU", pUnit:GetName());
	pPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, descr, title, iX, iY, -1)
	     end
	  end
   end

end
GameEvents.GreatPersonExpended.Add(GUIGU)		  
		  

function GUIGU_SPY(iPlayer, iSpy, iResult, iCityX, iCityY) 
   local Player = Players[iPlayer]
   local tSpecialists ={}

   if Player == nil or (not Player:IsMajorCiv())
   or (not Player:HasWonder(GameInfoTypes.BUILDING_GUIGU)) then
      return
   end

   local iTeamID = Player:GetTeam()
   local iTeam = Teams[iTeamID]
   local iTeamTechs = iTeam:GetTeamTechs()
   local iGoldPerTurn = Player:CalculateGoldRate()
   local Science=math.max(0,4*Player:GetScience())
   if  iResult then

   --City:ChangeDamage(50)

   Player:ChangeGold(2*iGoldPerTurn)
   ChangeResearchProcess(Player, iTeamID, iTeam, iTeamTechs, iPlayer, science)

  local randomNumber = ROG_GetTrueRandom(1, 100)
  if randomNumber>=80 then
  local iX, iY = GetGuiGuCity(Player):GetX(), GetGuiGuCity(Player):GetY() 
 
  for row in GameInfo.Units() do
  if  row.Special=='SPECIALUNIT_PEOPLE' then
	    table.insert(tSpecialists, row.ID)
		   end
		end
		   if #tSpecialists > 0 then
			  local randomNumber = ROG_GetTrueRandom(1, #tSpecialists)
			  local tSpecialist = tSpecialists[randomNumber]
			  Specialistinfo = GameInfo.Units{ID=tSpecialist}()    
              local SpecialistUnit = Player:InitUnit(Specialistinfo.ID, iX,iY)
			  SpecialistUnit:JumpToNearestValidPlot()
			  SpecialistUnit:SetHasPromotion(GameInfoTypes["PROMOTION_CULTURE_GREAT_PEOPLE"], true) 
             end	
         end

     end

end 	
GameEvents.EspionageResult.Add(GUIGU_SPY)  
   

-- ****************************************
--
-- ****************************************	
function SoldBuildingBuff(iPlayer, iCity, iBuilding)
	local player = Players[iPlayer]
	local city = player:GetCityByID(iCity)

	if player == nil or (not player:IsMajorCiv())   then
		return
	end

	if  player:HasWonder(GameInfoTypes.BUILDING_ROCKEFELLER)  then
	for row in GameInfo.Buildings("HurryCostModifier <> -1") do
	if  row.ID == iBuilding then 
	city:ChangeProduction(row.Cost)	
	for Othercity in player:Cities() do  
	if  Othercity~=city then
	Othercity:ChangeProduction(0.25*row.Cost)	
	                 end
		          end	
		      end
		  end
	 end 
end 	
GameEvents.CitySoldBuilding.Add(SoldBuildingBuff)  


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



local iFreezeCollectionID = GameInfoTypes["PROMOTION_COLLECTION_FREEZE_BOMB"];
local iFreezedCollectionID = GameInfoTypes["PROMOTION_COLLECTION_FREEZE_EFFECT"];
GameEvents.OnTriggerAddEnemyPromotion.Add(function(eThisPromotionType, eThisPromotionCollection, eThisBattleType, iThisPlayer,
 iThisUnit, iThisUnitType, eThatPromotionType,eThatPromotionCollection, iThatPlayer, iThatUnit, iThatUnitType)

    if eThisPromotionCollection ~= iFreezeCollectionID or eThatPromotionCollection ~= iFreezedCollectionID then
        return;
    end

    local pThisPlayer = Players[iThisPlayer];
    local pThatPlayer = Players[iThatPlayer];
    if pThisPlayer == nil or pThatPlayer == nil then
        return;
    end

    local pThisUnit = pThisPlayer:GetUnitByID(iThisUnit);
    local pThatUnit = pThatPlayer:GetUnitByID(iThatUnit);
    if pThisUnit == nil or pThatUnit == nil then
        return;
    end

    if eThatPromotionType == -1 then
        return;
    end

    local thisUnitName = pThisUnit:GetName();
    local thatUnitName = pThatUnit:GetName();
    if pThisPlayer:IsHuman() then
        local text = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_ENEMY_FREEZE", thisUnitName, thatUnitName);
        Events.GameplayAlertMessage(text);
    end
    if pThatPlayer:IsHuman() then
        local text = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_US_FREEZE", thisUnitName, thatUnitName);
        Events.GameplayAlertMessage(text);
    end
end);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      