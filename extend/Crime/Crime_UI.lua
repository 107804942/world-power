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

    toolTipCrime = toolTipCrime ..city:GetYieldRateInfoTool(GameInfoTypes["YIELD_CRIME"])

	if city:GetYieldModifierTooltip(GameInfoTypes["YIELD_CRIME"])~= "" then
	   toolTipCrime = toolTipCrime .. city:GetYieldModifierTooltip(GameInfoTypes["YIELD_CRIME"])
	end

	
	return convertTextKey("TXT_KEY_CITYVIEW_CRIME_TEXT_TT_DETAIL",toolTipCrime)
	
end



