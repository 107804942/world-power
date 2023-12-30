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
		   plagueTurns=mathMax(0,ceil((plagueFinal)/(-iCityHealthIndex)))
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


--Player:GetCityHealthTT
function Player.GetCityHealthTT(player, city)
	local totalHealth, totalDisease = player:GetCityHealthTotal(city, true)
	local toolTipHealth = ""
	local toolTipDisease = ""
	local toolTipPlagueSentiment = nil

-- ********************************************************
-- 疾病明细
-- ********************************************************

	toolTipDisease = toolTipDisease..city:GetYieldRateInfoTool(yieldDiseaseID)

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


	if city:GetYieldModifierTooltip(yieldDiseaseID)~= "" then
	   toolTipDisease = toolTipDisease .. city:GetYieldModifierTooltip(yieldDiseaseID)
	end

-- ********************************************************
-- 健康度明细
-- ********************************************************
  
	toolTipHealth = toolTipHealth ..city:GetYieldRateInfoTool(yieldHealthID)

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

	
	return convertTextKey("TXT_KEY_CITYVIEW_HEALTH_TEXT_TT_FOOD", toolTipDisease, totalDisease, toolTipHealth, totalHealth).."[NEWLINE]" .."[NEWLINE][NEWLINE]"..toolTipPlagueSentiment
	
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

