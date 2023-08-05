PlayerClass		 = getmetatable(Players[0]).__index
LuaEvents.Player = LuaEvents.Player		or function(player)	 end
LuaEvents.City	 = LuaEvents.City		or function(city)	 end


local gHandicap			= (PreGame.GetHandicap(0) > 0) and PreGame.GetHandicap(0) or 1

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
--顶部界面计数
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
		if  pCity:HasPlague()  then --城市已经爆发瘟疫
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
local defineCIDHealthDiseaseConnectionMod	   = GameDefines["HEALTH_DISEASE_CITY_CONNECTION_MODIFIER"] ----城市连接加成
local defineCIDHealthDiseasePerPop		 	   = GameDefines["HEALTH_DISEASE_PER_POPULATION"] 
local defineCIDHealthDiseaseTradeRoutesMod	   = GameDefines["HEALTH_DISEASE_TRADE_ROUTE_MODIFIER"]   ----贸易路线加成
local defineCIDHealthPlagueMinThreshold		   = 150
if Game then defineCIDHealthPlagueMinThreshold = (GameDefines["HEALTH_PLAGUE_MIN_THRESHOLD_" .. GameInfo.GameSpeeds[Game.GetGameSpeedType()].Type] or 150) end


-- ********************************************************
-- 健康点数
-- ********************************************************

--城市总健康度和总瘟疫
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
		--totalDisease = totalDisease + player:GetCityDiseaseFromPopulation(city) 
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


-- ********************************************************
-- 疾病点数
-- ********************************************************	
--Player:GetCityDiseaseFromConnections
function Player.GetCityDiseaseFromConnections(player, city, diseaseConnections)
	local capital = player:GetCapitalCity()
	if (capital:HasPlague() and player:IsCapitalConnectedToCity(city) and (not city:IsCapital())) then

		diseaseConnections = ((diseaseConnections*defineCIDHealthDiseaseConnectionMod)/100)

		return mathMax(ceil(diseaseConnections),0)
	else
		return 0
	end
end

--Player:GetCityDiseaseFromPopulation
function Player.GetCityDiseaseFromPopulation(player, city)

   local pop =city:GetPopulation()

	--local diseasePopulation = (city:GetPopulation()*defineCIDHealthDiseasePerPop)
	local diseasePopulation = city:GetYieldPerPopTimes100(yieldDiseaseID) * pop / 100

	return mathMax(ceil(diseasePopulation),0)
end

--Player:GetNumDiseaseFromTradeRoute
function Player.GetNumDiseaseFromTradeRoute(player, city)
	local numDisease = 0
	local totalHealth, totalDisease = player:GetCityHealthTotal(city, true, true)
	numDisease = numDisease + ((totalDisease*defineCIDHealthDiseaseTradeRoutesMod)/100)

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
-- 疾病明细
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


	--Modifier 百分比加成明细
	--local diseaseModifier = city:GetYieldRateModifier(yieldDiseaseID) + player:GetYieldRateModifier(yieldDiseaseID)
	--if diseaseModifier ~= 0 then
		--if diseaseModifier > 0 then diseaseModifier = "+" .. diseaseModifier end
		--toolTipDisease = toolTipDisease .. convertTextKey("TXT_KEY_CITYVIEW_DISEASE_TT_FROM_MODIFIERS", diseaseModifier)
	---end

   -- Puppet modifier
		local puppetMod = city:IsPuppet() and GameDefines.PUPPET_DISEASE_MODIFIER or 0
		if puppetMod ~= 0 then
			toolTipDisease = toolTipDisease .. convertTextKey("TXT_KEY_CITYVIEW_DISEASE_TT_FROM_PUPPET",puppetMod) 
		end

	if city:GetYieldModifierTooltip(yieldDiseaseID)~= "" then
	   toolTipDisease = toolTipDisease .. city:GetYieldModifierTooltip(yieldDiseaseID)
	end

-- ********************************************************
-- 健康度明细
-- ********************************************************
    -- 临近淡水
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


	--额外信条转化率
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

	--Modifier  百分比加成项目

	--local healthCrimeMod = city:GetYieldModifierFromCrime(yieldHealthID)
	--if healthCrimeMod ~= 0 then
		--toolTipHealth = toolTipHealth .. "[NEWLINE][ICON_BULLET]";
		--toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_HEALTH_FROM_CRIME", healthCrimeMod .. "%");
	--end

	--Modifier
	--local healthModifier = city:GetYieldRateModifier(yieldHealthID) + player:GetYieldRateModifier(yieldHealthID)
	--if healthModifier ~= 0 then
		--if healthModifier > 0 then healthModifier = "+" .. healthModifier end
		--toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_MODIFIERS", healthModifier)
	--end

	-- Puppet modifier
		local puppetMod = city:IsPuppet() and GameDefines.PUPPET_HEALTH_MODIFIER or 0
		if puppetMod ~= 0 then
		toolTipHealth = toolTipHealth .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TT_FROM_PUPPET",puppetMod) 
	end

	if city:GetYieldModifierTooltip(yieldHealthID)~= "" then
	   toolTipHealth = toolTipHealth .. city:GetYieldModifierTooltip(yieldHealthID)
	end

	----------------------------------------------------------------------------------------------------------
	local plagueCounter, plagueThreshold, plagueTurns = player:GetCityPlagueCounterDetails(city, true, true)
	local plagueTurnsHL = "[COLOR_DISEASE]"

	local BreakTurn = 0
	--if totalDisease < totalHealth then   ---健康度充足
	if totalHealth - totalDisease >= 0 then
		BreakTurn = 0
		plagueTurnsHL = "[COLOR_HEALTH]"
	end

	toolTipPlagueSentiment = convertTextKey("TXT_KEY_CITYVIEW_HEALTH_PLAGUE_SENTIMENT_TEXT_TT", plagueTurnsHL, plagueCounter, plagueThreshold)

	if (totalHealth - totalDisease < 0 and (not city:HasPlague())) then
	    BreakTurn = mathMax(0,ceil((plagueThreshold-plagueCounter)/(totalDisease-totalHealth)))
		toolTipPlagueSentiment = toolTipPlagueSentiment .. "[NEWLINE][NEWLINE]" .. convertTextKey("TXT_KEY_CITYVIEW_HEALTH_PLAGUE_TURNS_TEXT_TT", plagueTurnsHL, BreakTurn)
	end

	---------------------------------------------------健康度转化为其他产出-------------------------------------------------------
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
--Player:GetCityPlagueCounterDetails  瘟疫的计数细节（累计进度，爆发阈值，瘟疫回合数）
function Player.GetCityPlagueCounterDetails(player, city, resturnsThreshold, returnsTurns)
	local totalHealth, totalDisease = player:GetCityHealthTotal(city, true)--总健康度（基础健康度产出加上信条中信仰对健康度的转换数值，如25则增加25%）
	local plagueCounter = city:GetPlagueCounter()   ----疾病计数
	local plagueThreshold = 0
	if resturnsThreshold then
		--plagueThreshold = (totalHealth*10)+defineCIDHealthPlagueMinThreshold ---（总健康度阈值，动态阈值）
		plagueThreshold = defineCIDHealthPlagueMinThreshold ---（总健康度阈值，动态阈值）
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
		--plagueTurns = mathMax(1,Game.GetRound((plagueCounter-plagueThreshold)/excessDisease)*-1)  --将在剩余若干回合后爆发
		plagueTurns = mathMax(1,(plagueThreshold-plagueCounter)/(totalDisease-totalHealth))  --将在剩余若干回合后爆发
	end
	return plagueCounter, plagueThreshold, plagueTurns
end



--------------------------------------------------------------------

