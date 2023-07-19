include ("Health_Events.lua")

--------------------------------------------------------------------
PlayerClass		 = getmetatable(Players[0]).__index
LuaEvents.Player = LuaEvents.Player		or function(player)	 end
LuaEvents.City	 = LuaEvents.City		or function(city)	 end
--------------------------------------------------------------------
--local plagueThreshold = GameDefines["PLAGUE_THRESHOLD_" .. GameInfo.GameSpeeds[Game.GetGameSpeedType()].Type] or 100
local bAbandonCity	 = (PreGame.GetGameOption("GAMEOPTION_PLAGUE_DESTROYS_CITIES") == 1)
local gHandicap			= (PreGame.GetHandicap(0) > 0) and PreGame.GetHandicap(0) or 1
--��DUEL 0.4 ��TINY 0.56��SMALL 0.66��STANDARD 0.8 ��LARGE 1.04 ��HUGE 1.28��
local insert			= table.insert 
local concat			= table.concat
local ceil				= math.ceil
local floor				= math.floor
local condition			= "YieldType = 'YIELD_HEALTH'"
local mathMax		 = math.max
local mathMin		 = math.min
local convertTextKey = Locale.ConvertTextKey

function Game.GetRandom(lower, upper)
	return Game.Rand((upper + 2) - lower, "") + lower
end

function Game.GetRound(num, idp)
	local mult = 10^(idp or 0)
	return floor(num * mult + 0.5) / mult
end
--------------------------------------------------------------------
-- UI
--------------------------------------------------------------------

function PlayerClass.GetEmpireHealthTotal(pPlayer)
	local t = pPlayer:GetYieldRateModifier(yieldHealthID)
	return t
end
LuaEvents.Player.Add( PlayerClass.GetEmpireHealthTotal )


--------------------------------------------------------------------
--�����������
--------------------------------------------------------------------
function GetCityPlagueInfoForTopPlane(pCity)
	local totalHealth, totalDisease = pPlayer:GetCityHealthTotal(pCity, true)
	local plagueCounter, plagueThreshold, plagueTurns = pPlayer:GetCityPlagueCounterDetails(pCity, true, true)
	local iCityHealthIndex=totalHealth-totalDisease
	local plagueFinal =plagueThreshold-plagueCounter
	if iCityHealthIndex <0 and pCity:GetPlagueType()~=-1  then
		   plagueTurns=mathMax(0,ceil(  (plagueFinal)/(-iCityHealthIndex)  ))
		else 
		   plagueTurns=0
		   end
	return  plagueTurns
end
LuaEvents.City.Add( GetCityPlagueInfoForTopPlane )

function GetCityPlagueInfo(pCity)
	--if not bNoPlagues then
		--local t = GetPlagueCities()
		if  pCity:HasPlague()  then --�����Ѿ���������
			local iTurns = pCity:GetPlagueTurns() 
				if (iTurns > 0) then
				return true, iTurns
			end
		end
	--end
	return false, 0;
end
LuaEvents.City.Add( GetCityPlagueInfo )
--=======================================================================================================================
-- GAME DEFINES
--=======================================================================================================================
local defineCIDHealthDiseaseConnectionMod	   = GameDefines["HEALTH_DISEASE_CITY_CONNECTION_MODIFIER"] 
local defineCIDHealthDiseasePerPop		 	   = GameDefines["HEALTH_DISEASE_PER_POPULATION"] 
local defineCIDHealthDiseaseTradeRoutesMod	   = GameDefines["HEALTH_DISEASE_TRADE_ROUTE_MODIFIER"] 
local defineCIDHealthPlagueMinThreshold		   = 150
if Game then defineCIDHealthPlagueMinThreshold = (GameDefines["HEALTH_PLAGUE_MIN_THRESHOLD_" .. GameInfo.GameSpeeds[Game.GetGameSpeedType()].Type] or 150) end


-- ********************************************************
-- ��������
-- ********************************************************

--�����ܽ����Ⱥ�������
--Player:GetCityHealthTotal
local yieldDiseaseID = GameInfoTypes["YIELD_DISEASE"]
local yieldFaithID   = GameInfoTypes["YIELD_FAITH"]
local yieldHealthID  = GameInfoTypes["YIELD_HEALTH"]

function Player.GetCityHealthTotal(player, city, returnsDisease, isBase)
    if city==nil 
	then return 
	end

	local totalHealth = city:GetYieldRate(yieldHealthID)
	for row in GameInfo.Beliefs("FaithToHealthRate > 0") do
		if player:HasBelief(row.ID) then
			totalHealth = totalHealth + ((city:GetYieldRate(yieldFaithID) * row.FaithToHealthRate)/100)
		end
	end
	
	----------------------------------------------------------------------------------------

	local totalDisease = 0
	local totalDiseaseLessMods = 0
	if returnsDisease then 
		totalDisease = totalDisease + city:GetYieldRate(yieldDiseaseID)
		totalDisease = totalDisease + player:GetCityDiseaseFromPopulation(city) 
		totalDiseaseLessMods = totalDisease
		if (not isBase) then
			totalDisease = totalDisease + player:GetCityDiseaseFromConnections(city, totalDiseaseLessMods)
			totalDisease = totalDisease + player:GetCityDiseaseFromTradeRoutes(city)
		end
		for building in GameInfo.Buildings("IsNoDiseaseFromBuildings = 1") do
			if city:HasBuilding(building.ID) then
				totalDisease = totalDisease - city:GetBaseYieldRateFromBuildings(yieldDiseaseID)
			end
		end
	end
	--return Game.GetRound(totalHealth), Game.GetRound(totalDisease)
	return totalHealth, totalDisease
end




--���и��ཡ���ȶ�ʳ��ӳ�
--Player:GetCityExcessHealthBonusFood
function Player.GetCityExcessHealthBonusFood(player, city)
	local excessHealthBonus = 0
	for row in GameInfo.Building_HealthMods("HealthToFoodMod <> 0") do
		if (((not row.IsLocal) and player:HasBuilding(GameInfoTypes[row.BuildingType])) or city:HasBuilding(GameInfoTypes[row.BuildingType])) then
			excessHealthBonus = excessHealthBonus + row.HealthToFoodMod
		end
	end
	for row in GameInfo.Policy_HealthMods("HealthToFoodMod <> 0") do
		if player:HasPolicy(GameInfoTypes[row.PolicyType]) then
			excessHealthBonus = excessHealthBonus + row.HealthToFoodMod
		end
	end
	for row in GameInfo.Trait_HealthMods("HealthToFoodMod <> 0") do
		if player:HasTrait(GameInfoTypes[row.TraitType]) then
			excessHealthBonus = excessHealthBonus + row.HealthToFoodMod
		end
	end
	return excessHealthBonus
end


-- ********************************************************
-- ��������
-- ********************************************************	
--Player:GetCityDiseaseFromConnections
function Player.GetCityDiseaseFromConnections(player, city, diseaseConnections)
	local capital = player:GetCapitalCity()
	if (capital:HasPlague() and player:IsCapitalConnectedToCity(city) and (not city:IsCapital())) then
		diseaseConnections = ((diseaseConnections*defineCIDHealthDiseaseConnectionMod)/100)
		for row in GameInfo.Building_HealthMods("DiseaseConnectionMod <> 0") do
			if (((not row.IsLocal) and player:HasBuilding(GameInfoTypes[row.BuildingType])) or city:HasBuilding(GameInfoTypes[row.BuildingType])) then
				diseaseConnections = diseaseConnections + ((diseaseConnections*row.DiseaseConnectionMod)/100)
			end
		end
		for row in GameInfo.Policy_HealthMods("DiseaseConnectionMod <> 0") do
			if player:HasPolicy(GameInfoTypes[row.PolicyType]) then
				diseaseConnections = diseaseConnections + ((diseaseConnections*row.DiseaseConnectionMod)/100)
			end
		end
		for row in GameInfo.Trait_HealthMods("DiseaseConnectionMod <> 0") do
			if player:HasTrait(GameInfoTypes[row.TraitType]) then
				diseaseConnections = diseaseConnections + ((diseaseConnections*row.DiseaseConnectionMod)/100)
			end
		end
		return mathMax(ceil(diseaseConnections),0)
	else
		return 0
	end
end

--Player:GetCityDiseaseFromPopulation
function Player.GetCityDiseaseFromPopulation(player, city)

   local pop =city:GetPopulation()
   if pop<=30 then defineCIDHealthDiseasePerPop = 0.6
   elseif pop >30 and pop<=60 then defineCIDHealthDiseasePerPop = 0.8
   elseif pop >60 and pop<=100 then defineCIDHealthDiseasePerPop = 1.25
   elseif pop >100  then defineCIDHealthDiseasePerPop = 1.5
   end

	local diseasePopulation = (city:GetPopulation()*defineCIDHealthDiseasePerPop)
	for row in GameInfo.Building_HealthMods("DiseasePopMod <> 0") do
		if (((not row.IsLocal) and player:HasBuilding(GameInfoTypes[row.BuildingType])) or city:HasBuilding(GameInfoTypes[row.BuildingType])) then
			diseasePopulation = diseasePopulation + ((diseasePopulation*row.DiseasePopMod)/100)
		end
	end
	for row in GameInfo.Policy_HealthMods("DiseasePopMod <> 0") do
		if player:HasPolicy(GameInfoTypes[row.PolicyType]) then
			diseasePopulation = diseasePopulation + ((diseasePopulation*row.DiseasePopMod)/100)
		end
	end
	for row in GameInfo.Trait_HealthMods("DiseasePopMod <> 0") do
		if player:HasTrait(GameInfoTypes[row.TraitType]) then
			diseasePopulation = diseasePopulation + ((diseasePopulation*row.DiseasePopMod)/100)
		end
	end

	return mathMax(ceil(diseasePopulation),0)
end

--Player:GetNumDiseaseFromTradeRoute
function Player.GetNumDiseaseFromTradeRoute(player, city)
	local numDisease = 0
	local totalHealth, totalDisease = player:GetCityHealthTotal(city, true, true)
	numDisease = numDisease + ((totalDisease*defineCIDHealthDiseaseTradeRoutesMod)/100)
	for row in GameInfo.Building_HealthMods("DiseaseTRMod <> 0") do
		if (((not row.IsLocal) and player:HasBuilding(GameInfoTypes[row.BuildingType])) or city:HasBuilding(GameInfoTypes[row.BuildingType])) then
			numDisease = numDisease + ((numDisease*row.DiseaseTRMod)/100)
		end
	end
	for row in GameInfo.Policy_HealthMods("DiseaseTRMod <> 0") do
		if player:HasPolicy(GameInfoTypes[row.PolicyType]) then
			numDisease = numDisease + ((numDisease*row.DiseaseTRMod)/100)
		end
	end

	for row in GameInfo.Trait_HealthMods("DiseaseTRMod <> 0") do
		if player:HasTrait(GameInfoTypes[row.TraitType]) then
			numDisease = numDisease + ((numDisease*row.DiseaseTRMod)/100)
		end
	end
	return mathMax(ceil(numDisease),0)
end

--Player:GetCityDiseaseFromTradeRoutes
function Player.GetCityDiseaseFromTradeRoutes(player, city)
	local diseaseTradeRoutes = 0
	local diseaseTradeRouteRate = defineCIDHealthDiseaseTradeRoutesMod
	local diseaseTradeRoutesMod = 0
	for _,v in ipairs(player:GetTradeRoutes()) do
		local fromCity = v.FromCity
		local toCity = v.ToCity
		if fromCity == city then
			diseaseTradeRoutes = diseaseTradeRoutes + Players[fromCity:GetOwner()]:GetNumDiseaseFromTradeRoute(toCity)
		elseif toCity == city then
			diseaseTradeRoutes = diseaseTradeRoutes + Players[toCity:GetOwner()]:GetNumDiseaseFromTradeRoute(fromCity)
		end
	end
	for _,v in ipairs(player:GetTradeRoutesToYou()) do
		local fromCity = v.FromCity
		local toCity = v.ToCity
		if fromCity == city then
			diseaseTradeRoutes = diseaseTradeRoutes + Players[fromCity:GetOwner()]:GetNumDiseaseFromTradeRoute(toCity)
		elseif toCity == city then
			diseaseTradeRoutes = diseaseTradeRoutes + Players[toCity:GetOwner()]:GetNumDiseaseFromTradeRoute(fromCity)
		end
	end
	return mathMax(diseaseTradeRoutes,0)
end
-- ********************************************************
-- end
-- ********************************************************	



----------------
-- TEXT
----------------
--Player:GetCityHealthTT
function Player.GetCityHealthTT(player, city)
	local totalHealth, totalDisease = player:GetCityHealthTotal(city, true)
	local toolTipHealth = ""
	local toolTipDisease = ""
	local toolTipPlagueSentiment = nil

-- ********************************************************
-- ������ϸ
-- ********************************************************
	--Population
	local diseasePopulation = player:GetCityDiseaseFromPopulation(city)
	toolTipDisease = toolTipDisease .. convertTextKey("TXT_KEY_CITYVIEW_DISEASE_TT_FROM_POPULATION", diseasePopulation)

	-- Base Yield from Terrain
	local diseaseTerrain = city:GetBaseYieldRateFromTerrain(yieldDiseaseID)
	if diseaseTerrain ~= 0 then
		if diseaseTerrain > 0 then diseaseTerrain = "+" .. diseaseTerrain end
		toolTipDisease = toolTipDisease .. convertTextKey("TXT_KEY_CITYVIEW_DISEASE_TT_FROM_TERRAIN", diseaseTerrain)
	end

	-- Base Yield from Buildings
	local diseaseBuilding = city:GetBaseYieldRateFromBuildings(yieldDiseaseID)
	for building in GameInfo.Buildings("IsNoDiseaseFromBuildings = 1") do
		if city:HasBuilding(building.ID) then
			diseaseBuilding = 0
			break
		end
	end
	if diseaseBuilding ~= 0 then
		if diseaseBuilding > 0 then diseaseBuilding = "+" .. diseaseBuilding end
		toolTipDisease = toolTipDisease .. convertTextKey("TXT_KEY_CITYVIEW_DISEASE_TT_FROM_BUILDINGS", diseaseBuilding)
	end



	--City Connection
	local diseaseConnection = player:GetCityDiseaseFromConnections(city, totalDisease)
	if diseaseConnection ~= 0 then
		toolTipDisease = toolTipDisease .. convertTextKey("TXT_KEY_CITYVIEW_DISEASE_TT_FROM_CITY_CONNECTION", diseaseConnection)
	end
	--Trade Routes
	local diseaseTradeRoute = player:GetCityDiseaseFromTradeRoutes(city, totalDisease)
	if diseaseTradeRoute ~= 0 then
		toolTipDisease = toolTipDisease .. convertTextKey("TXT_KEY_CITYVIEW_DISEASE_TT_FROM_TRADE", diseaseTradeRoute)
	end


	--Modifier
	local diseaseModifier = city:GetYieldRateModifier(yieldDiseaseID) + player:GetYieldRateModifier(yieldDiseaseID)
	if diseaseModifier ~= 0 then
		if diseaseModifier > 0 then diseaseModifier = "+" .. diseaseModifier end
		toolTipDisease = toolTipDisease .. convertTextKey("TXT_KEY_CITYVIEW_DISEASE_TT_FROM_MODIFIERS", diseaseModifier)
	end

   -- Puppet modifier
		local puppetMod = city:IsPuppet() and GameDefines.PUPPET_DISEASE_MODIFIER or 0
		if puppetMod ~= 0 then
			toolTipDisease = toolTipDisease .. convertTextKey("TXT_KEY_CITYVIEW_DISEASE_TT_FROM_PUPPET",puppetMod) 
		end

-- ********************************************************
-- ��������ϸ
-- ********************************************************
    -- �ٽ���ˮ
	if  city:Plot():IsFreshWater() then
	    toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_FRESH_WATER", GameDefines["FRESH_WATER_HEALTH_YIELD"])
	else
	    toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_NO_FRESH_WATER", GameDefines["FRESH_WATER_HEALTH_YIELD"])
	end

	-- Base Yield from Terrain
	local healthTerrain = city:GetBaseYieldRateFromTerrain(yieldHealthID)
	if healthTerrain ~= 0 then
		if healthTerrain > 0 then healthTerrain = "+" .. healthTerrain end
		toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_TERRAIN", healthTerrain)
	end

	-- Base Yield from Buildings
	local healthBuilding = city:GetBaseYieldRateFromBuildings(yieldHealthID)
	if healthBuilding ~= 0 then
		if healthBuilding > 0 then healthBuilding = "+" .. healthBuilding end
		toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_BUILDINGS", healthBuilding)
	end

	-- Base Yield from Specialists
	local healthSpecialist = city:GetBaseYieldRateFromSpecialists(yieldHealthID)
	if healthSpecialist ~= 0 then
		if healthSpecialist > 0 then healthSpecialist = "+" .. healthSpecialist end
		toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_SPECIALISTS", healthSpecialist)
	end

	-- Base Yield from Misc
	local healthMisc = city:GetBaseYieldRateFromMisc(yieldHealthID)
	if healthMisc ~= 0 then
		if healthMisc > 0 then healthMisc = "+" .. healthMisc end
		toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_TRAITS", healthMisc)
	end 

	-- Base Yield from Population
	local healthPopulation = city:GetYieldPerPopTimes100(yieldHealthID) * city:GetPopulation() / 100
	if healthPopulation ~= 0 then
		if healthPopulation > 0 then healthPopulation = "+" .. healthPopulation end
		toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_POPULATION", healthPopulation)
	end 

	-- Base Yield from Religion
	local healthReligion = city:GetBaseYieldRateFromReligion(yieldHealthID)
	if healthReligion ~= 0 then
		if healthReligion > 0 then healthReligion = "+" .. healthReligion end
		toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_RELIGION", healthReligion)
	end


	-- Base Yield from GreatWork
	local healthGreatWorks = city:GetBaseYieldRateFromGreatWorks(yieldHealthID)
	if healthGreatWorks ~= 0 then
		if healthGreatWorks > 0 then healthGreatWorks = "+" .. healthGreatWorks end
		toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_GREATWORK", healthGreatWorks)
	end

	-- Base Yield from OtherYield
	local healthOtherYield = city:GetBaseYieldRateFromOtherYield(yieldHealthID)
	if healthOtherYield ~= 0 then
		if healthOtherYield > 0 then healthOtherYield = "+" .. healthOtherYield end
		toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_OTHER_YIELD", healthOtherYield)
	end


	--��������ת����
	local healthFaith = 0
	for row in GameInfo.Beliefs("FaithToHealthRate > 0") do
		if city:HasBelief(row.ID) then
			healthFaith = ((city:GetYieldRate(yieldFaithID) * row.FaithToHealthRate)/100)
		end
	end
	if healthFaith ~= 0 then
		if healthFaith > 0 then healthFaith = "+" .. healthFaith end
		toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_FAITH", healthFaith)
	end



	--Crime
	local healthCrime = city:GetYieldFromCrime(yieldHealthID)
	if healthCrime ~= 0 then
		toolTipHealth = toolTipHealth .. "[NEWLINE][ICON_BULLET]";
		toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_HEALTH_FROM_CRIME", healthCrime);
	end
	local healthCrimeMod = city:GetYieldModifierFromCrime(yieldHealthID)
	if healthCrimeMod ~= 0 then
		toolTipHealth = toolTipHealth .. "[NEWLINE][ICON_BULLET]";
		toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_HEALTH_FROM_CRIME", healthCrimeMod .. "%");
	end

	--Modifier
	local healthModifier = city:GetYieldRateModifier(yieldHealthID) + player:GetYieldRateModifier(yieldHealthID)
	if healthModifier ~= 0 then
		if healthModifier > 0 then healthModifier = "+" .. healthModifier end
		toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_MODIFIERS", healthModifier)
	end

	-- Puppet modifier
		local puppetMod = city:IsPuppet() and GameDefines.PUPPET_HEALTH_MODIFIER or 0
		if puppetMod ~= 0 then
		toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_PUPPET",puppetMod) 
	end


	----------------------------------------------------------------------------------------------------------
	local plagueCounter, plagueThreshold, plagueTurns = player:GetCityPlagueCounterDetails(city, true, true)
	local plagueTurnsHL = "[COLOR_DISEASE]"

	local BreakTurn = 0
	--if totalDisease < totalHealth then   ---�����ȳ���
	if totalHealth - totalDisease >= 0 then
		BreakTurn = 0
		plagueTurnsHL = "[COLOR_HEALTH]"
	end

	toolTipPlagueSentiment = convertTextKey("TXT_KEY_CITYVIEW_HEALTH_PLAGUE_SENTIMENT_TEXT_TT", plagueTurnsHL, plagueCounter, plagueThreshold)

	if (totalHealth - totalDisease < 0 and (not city:HasPlague())) then
	    BreakTurn = mathMax(0,ceil((plagueThreshold-plagueCounter)/(totalDisease-totalHealth)))
		toolTipPlagueSentiment = toolTipPlagueSentiment .. "[NEWLINE][NEWLINE]" .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_PLAGUE_TURNS_TEXT_TT", plagueTurnsHL, BreakTurn)
	end

	---------------------------------------------------ת��-------------------------------------------------------
	local toolTipHealthToOtherYield="" 
	local FoodChange = city:GetYieldFromHealth(YieldTypes.YIELD_FOOD)
	if FoodChange ~= 0 then
	if FoodChange > 0 then FoodChange = "+" .. FoodChange
	end
	toolTipHealthToOtherYield = "[ICON_BULLET]" ..convertTextKey("TXT_KEY_CITYVIEW_HEALTH_CHANGE_FOOD_TEXT_TT",FoodChange)
	end
	local FoodChangeMod = city:GetYieldModifierFromHealth(YieldTypes.YIELD_FOOD)
	if FoodChangeMod ~= 0 then
	if FoodChangeMod > 0 then FoodChangeMod = "+" .. FoodChangeMod 
	end
	toolTipHealthToOtherYield = toolTipHealthToOtherYield .."[NEWLINE][ICON_BULLET]"..convertTextKey("TXT_KEY_CITYVIEW_HEALTH_CHANGE_FOOD_MOD_TEXT_TT",FoodChangeMod)
	end


	local GoldChange = city:GetYieldFromHealth(YieldTypes.YIELD_GOLD)
	if GoldChange ~= 0 then
	if GoldChange > 0 then GoldChange = "+" .. GoldChange
	end
	toolTipHealthToOtherYield = toolTipHealthToOtherYield .."[NEWLINE][ICON_BULLET]"..convertTextKey("TXT_KEY_CITYVIEW_HEALTH_CHANGE_GOLD_TEXT_TT",GoldChange)
	end
	local GoldChangeMod = city:GetYieldModifierFromHealth(YieldTypes.YIELD_GOLD)
	if GoldChangeMod ~= 0 then
	if GoldChangeMod > 0 then GoldChangeMod = "+" .. GoldChangeMod 
	end
	toolTipHealthToOtherYield = toolTipHealthToOtherYield .."[NEWLINE][ICON_BULLET]"..convertTextKey("TXT_KEY_CITYVIEW_HEALTH_CHANGE_GOLD_MOD_TEXT_TT",GoldChangeMod)
	end


	local ScienceChange = city:GetYieldFromHealth(YieldTypes.YIELD_SCIENCE)
	if ScienceChange ~= 0 then
	if ScienceChange > 0 then ScienceChange = "+" .. ScienceChange
	end
	toolTipHealthToOtherYield = toolTipHealthToOtherYield .."[NEWLINE][ICON_BULLET]"..convertTextKey("TXT_KEY_CITYVIEW_HEALTH_CHANGE_SCIENCE_TEXT_TT",ScienceChange)
	end
	local ScienceChangeMod = city:GetYieldModifierFromHealth(YieldTypes.YIELD_SCIENCE)
	if ScienceChangeMod ~= 0 then
	if ScienceChangeMod > 0 then ScienceChangeMod = "+" .. ScienceChangeMod 
	end
	toolTipHealthToOtherYield = toolTipHealthToOtherYield .."[NEWLINE][ICON_BULLET]"..convertTextKey("TXT_KEY_CITYVIEW_HEALTH_CHANGE_SCIENCE_MOD_TEXT_TT",ScienceChangeMod)
	end


	local FaithChange = city:GetYieldFromHealth(YieldTypes.YIELD_FAITH)
	if FaithChange ~= 0 then
	if FaithChange > 0 then FaithChange = "+" .. FaithChange
	end
	toolTipHealthToOtherYield = toolTipHealthToOtherYield .."[NEWLINE][ICON_BULLET]"..convertTextKey("TXT_KEY_CITYVIEW_HEALTH_CHANGE_FAITH_TEXT_TT",FaithChange)
	end
	local FaithChangeMod = city:GetYieldModifierFromHealth(YieldTypes.YIELD_FAITH)
	if FaithChangeMod ~= 0 then
	if FaithChangeMod > 0 then FaithChangeMod = "+" .. FaithChangeMod 
	end
	toolTipHealthToOtherYield = toolTipHealthToOtherYield .."[NEWLINE][ICON_BULLET]"..convertTextKey("TXT_KEY_CITYVIEW_HEALTH_CHANGE_FAITH_MOD_TEXT_TT",FaithChangeMod)
	end


	local ProductionChange = city:GetYieldFromHealth(YieldTypes.YIELD_PRODUCTION)
	if ProductionChange ~= 0 then
	if ProductionChange > 0 then ProductionChange = "+" .. ProductionChange
	end
	toolTipHealthToOtherYield = toolTipHealthToOtherYield .."[NEWLINE][ICON_BULLET]"..convertTextKey("TXT_KEY_CITYVIEW_HEALTH_CHANGE_PRODUCTION_TEXT_TT",ProductionChange)
	end
	local ProductionChangeMod = city:GetYieldModifierFromHealth(YieldTypes.YIELD_PRODUCTION)
	if ProductionChangeMod ~= 0 then
	if ProductionChangeMod > 0 then ProductionChangeMod = "+" .. ProductionChangeMod 
	end
	toolTipHealthToOtherYield = toolTipHealthToOtherYield .."[NEWLINE][ICON_BULLET]"..convertTextKey("TXT_KEY_CITYVIEW_HEALTH_CHANGE_PRODUCTION_MOD_TEXT_TT",ProductionChangeMod)
	end


	return convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TEXT_TT_FOOD", toolTipDisease, totalDisease, toolTipHealth, totalHealth).."[NEWLINE]"..toolTipHealthToOtherYield .."[NEWLINE][NEWLINE]"..toolTipPlagueSentiment
	
end



------------------------------------------------------------------------------------------------------------------------
-- PLAGUE
------------------------------------------------------------------------------------------------------------------------


--Player:GetCityPlagueCounterDetails  ���ߵļ���ϸ�ڣ��ۼƽ��ȣ�������ֵ�����߻غ�����
function Player.GetCityPlagueCounterDetails(player, city, resturnsThreshold, returnsTurns)
	local totalHealth, totalDisease = player:GetCityHealthTotal(city, true)--�ܽ����ȣ����������Ȳ������������������Խ����ȵ�ת����ֵ����25������25%��
	local plagueCounter = city:GetPlagueCounter()   ----��������
	local plagueThreshold = 0
	if resturnsThreshold then
		--plagueThreshold = (totalHealth*10)+defineCIDHealthPlagueMinThreshold ---���ܽ�������ֵ����̬��ֵ��
		plagueThreshold = defineCIDHealthPlagueMinThreshold ---���ܽ�������ֵ����̬��ֵ��
		--Buildings
		for row in GameInfo.Building_HealthMods("PlagueMod <> 0") do
			if (((not row.IsLocal) and player:HasBuilding(GameInfoTypes[row.BuildingType])) or city:HasBuilding(GameInfoTypes[row.BuildingType])) then
				plagueThreshold = plagueThreshold + floor((plagueThreshold*row.PlagueMod)/100)
			end
		end
		--Policies
		for row in GameInfo.Policy_HealthMods("PlagueMod <> 0") do
			if player:HasPolicy(GameInfoTypes[row.PolicyType]) then
				plagueThreshold = plagueThreshold + floor((plagueThreshold*row.PlagueMod)/100)
			end
		end
		--Traits
		for row in GameInfo.Trait_HealthMods("PlagueMod <> 0") do
			if player:HasTrait(GameInfoTypes[row.TraitType]) then
				plagueThreshold = plagueThreshold + floor((plagueThreshold*row.PlagueMod)/100)
			end
		end
	end
	local plagueTurns = 0

	if (returnsTurns and totalHealth-totalDisease < 0) then
		--plagueTurns = mathMax(1,Game.GetRound((plagueCounter-plagueThreshold)/excessDisease)*-1)  --����ʣ�����ɻغϺ󱬷�
		plagueTurns = mathMax(1,(plagueThreshold-plagueCounter)/(totalDisease-totalHealth))  --����ʣ�����ɻغϺ󱬷�
	end
	return plagueCounter, plagueThreshold, plagueTurns
end

--------------------------------------------------------------------
function GetHappinessMod(pPlayer)
	local iHealth = 0
	if pPlayer:IsGoldenAge() then
		iHealth = 10
	elseif pPlayer:IsEmpireUnhappy() then
		local iUnhappy = pPlayer:GetExcessHappiness()
		iHealth = (iUnhappy < -15) and -15 or iUnhappy
	end
	return iHealth;
end

--------------------------------------------------------------------
function GetTechMod(pPlayer)
	local pTeam = Teams[pPlayer:GetTeam()]
	local iHealth = 0
	for row in GameInfo.Technology_Health() do
		local iYield = row.Yield
		local techInfo = GameInfo.Technologies[row.TechType]
		if techInfo then
			if ( pTeam:IsHasTech(techInfo.ID) ) then
				iHealth = iHealth + iYield
			end
		end
	end
	return iHealth;
end
--------------------------------------------------------------------
function GetEmpirePolicyMod(pPlayer)
	local iHealth = 0
	for row in GameInfo.PolicyBranch_Health() do
		local iYield = row.Yield
		local branchInfo = GameInfo.PolicyBranchTypes[row.PolicyBranchType]
		if branchInfo then
			for row in GameInfo.Policies("PolicyBranchType='" .. branchInfo.Type .. "'") do
				if pPlayer:HasPolicy(row.ID) and not pPlayer:IsPolicyBlocked(row.ID) then 
					iHealth = iHealth + iYield
				end
			end
		end
	end

	for row in GameInfo.Policy_YieldModifiers(condition) do
		local policyInfo = GameInfo.Policies[row.PolicyType]
		if policyInfo then
			if pPlayer:HasPolicy(policyInfo.ID) and not pPlayer:IsPolicyBlocked(policyInfo.ID) then 
				iHealth = iHealth + row.Yield
			end
		end
	end

	for row in GameInfo.Policy_BuildingClassYieldModifiers(condition) do
		local policyInfo = GameInfo.Policies[row.PolicyType]
		if policyInfo then
			if pPlayer:HasPolicy(policyInfo.ID) and not pPlayer:IsPolicyBlocked(policyInfo.ID) then 
				local classInfo = GameInfo.BuildingClasses[row.BuildingClassType]
				if classInfo then
					local iBonus = row.YieldMod * pPlayer:GetBuildingClassCount(classInfo.ID)
					iBonus = iBonus < 10 and iBonus or 10
					iHealth = iHealth + iBonus
				end
			end
		end
	end

	return iHealth;
end
--------------------------------------------------------------------
function GetEmpireBuildingMod(pPlayer)
	local iHealth = 0
	--for row in GameInfo.Building_YieldModifiers(condition) do
	for row in GameInfo.Building_GlobalYieldModifiers(condition) do
		local buildingInfo = GameInfo.Buildings[row.BuildingType]
		if buildingInfo then
			iHealth = iHealth + (pPlayer:CountNumBuildings(buildingInfo.ID) * row.Yield)
		end
	end
	return iHealth;
end
--------------------------------------------------------------------
function GetEmpireTradeMod(pPlayer)
	local iHealth = 0
	local routes = pPlayer:GetTradeRoutes()	
	for i,v in ipairs(routes) do
		if v.FromID ~= v.ToID then
			iHealth = iHealth - 1
		end
	end
	return iHealth;
end
--------------------------------------------------------------------

function GetEmpireReligionMod(pPlayer)
	local iHealth = 0
	
	if pPlayer:HasCreatedReligion() then
	local eReligion = pPlayer:GetReligionCreatedByPlayer()
				for row in GameInfo.Belief_YieldChangePerForeignCity(condition) do

				if  pPlayer:HasBelief(GameInfo.Beliefs{Type=row.BeliefType}().ID)  then

					--if row.BeliefType == belief.Type then
						local iBonus = (Game.GetNumCitiesFollowing(eReligion) * row.Yield)
						iBonus = (iBonus < 20) and iBonus or 20
						iHealth = iHealth + iBonus
					--end
				end
			end
		end
	return iHealth;
end


--------------------------------------------------------------------

