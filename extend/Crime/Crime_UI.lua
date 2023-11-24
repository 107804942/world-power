PlayerClass		 = getmetatable(Players[0]).__index
LuaEvents.Player = LuaEvents.Player		or function(player)	 end
LuaEvents.City	 = LuaEvents.City		or function(city)	 end


local gHandicap			= (PreGame.GetHandicap(0) > 0) and PreGame.GetHandicap(0) or 1

local insert			= table.insert 
local concat			= table.concat
local ceil				= math.ceil
local floor				= math.floor
local condition			= "YieldType = 'YIELD_CRIME'"
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

-- ********************************************************
-- end
-- ********************************************************	
local yieldCrimeID  = GameInfoTypes["YIELD_CRIME"]
local yieldLoyaltyID  = GameInfoTypes["YIELD_LOYALTY"]
local yieldViolenceID  = GameInfoTypes["YIELD_VIOLENCE"]
local yieldHeresyID  = GameInfoTypes["YIELD_HERESY"]

--Player:GetCityCrimeTT
function Player.GetCityCrimeTT(player, city)
	--local totalCrime, totalCrime = player:GetCityCrimeTotal(city, true)
	local toolTipCrime = ""
	--local toolTipDisease = ""
	local toolTipCrimeSentiment = nil
-- ********************************************************
-- ¸¯°ÜÃ÷Ï¸
-- ********************************************************
   
	-- Base Yield from Terrain
	local CrimeTerrain = city:GetBaseYieldRateFromTerrain(yieldCrimeID)
	if CrimeTerrain ~= 0 then
		if CrimeTerrain > 0 then CrimeTerrain = "+" .. CrimeTerrain end
		toolTipCrime = toolTipCrime .. convertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_FROM_TERRAIN", CrimeTerrain)
	end

	-- Base Yield from Buildings
	local CrimeBuilding = city:GetBaseYieldRateFromBuildings(yieldCrimeID)
	if CrimeBuilding ~= 0 then
		if CrimeBuilding > 0 then CrimeBuilding = "+" .. CrimeBuilding end
		toolTipCrime = toolTipCrime .. convertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_FROM_BUILDINGS", CrimeBuilding)
	end

	-- Base Yield from Specialists
	local CrimeSpecialist = city:GetBaseYieldRateFromSpecialists(yieldCrimeID)
	if CrimeSpecialist ~= 0 then
		if CrimeSpecialist > 0 then CrimeSpecialist = "+" .. CrimeSpecialist end
		toolTipCrime = toolTipCrime .. convertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_FROM_SPECIALISTS", CrimeSpecialist)
	end

	-- Base Yield from Misc
	local CrimeMisc = city:GetBaseYieldRateFromMisc(yieldCrimeID)
	if CrimeMisc ~= 0 then
		if CrimeMisc > 0 then CrimeMisc = "+" .. CrimeMisc end
		toolTipCrime = toolTipCrime .. convertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_FROM_TRAITS", CrimeMisc)
	end 

	-- Base Yield from Population
	local CrimePopulation = city:GetYieldPerPopTimes100(yieldCrimeID) * city:GetPopulation() / 100
	if CrimePopulation ~= 0 then
		if CrimePopulation > 0 then CrimePopulation = "+" .. CrimePopulation end
		toolTipCrime = toolTipCrime .. convertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_FROM_POPULATION", CrimePopulation)
	end 

	-- Base Yield from Religion
	local CrimeReligion = city:GetBaseYieldRateFromReligion(yieldCrimeID)
	if CrimeReligion ~= 0 then
		if CrimeReligion > 0 then CrimeReligion = "+" .. CrimeReligion end
		toolTipCrime = toolTipCrime .. convertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_FROM_RELIGION", CrimeReligion)
	end


	-- Base Yield from GreatWork
	local CrimeGreatWorks = city:GetBaseYieldRateFromGreatWorks(yieldCrimeID)
	if CrimeGreatWorks ~= 0 then
		if CrimeGreatWorks > 0 then CrimeGreatWorks = "+" .. CrimeGreatWorks end
		toolTipCrime = toolTipCrime .. convertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_FROM_GREATWORK", CrimeGreatWorks)
	end

	-- Base Yield from OtherYield
	local CrimeOtherYield = city:GetBaseYieldRateFromOtherYield(yieldCrimeID)
	if CrimeOtherYield ~= 0 then
		if CrimeOtherYield > 0 then CrimeOtherYield = "+" .. CrimeOtherYield end
		toolTipCrime = toolTipCrime .. convertTextKey("TXT_KEY_CITYVIEW_CRIME_TT_FROM_OTHER_YIELD", CrimeOtherYield)
	end


	if city:GetYieldModifierTooltip(yieldCrimeID)~= "" then
	   toolTipCrime = toolTipCrime .. city:GetYieldModifierTooltip(yieldCrimeID)
	end

	
	return convertTextKey("TXT_KEY_CITYVIEW_CRIME_TEXT_TT_FOOD",toolTipCrime)
	
end



