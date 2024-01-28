local concat			= table.concat
local insert			= table.insert 
local ceil				= math.ceil
local condition			= "YieldType = 'YIELD_HEALTH'"
local mathMax		 = math.max
local mathMin		 = math.min
local convertTextKey = Locale.ConvertTextKey
local floor				= math.floor


local yieldDiseaseID = GameInfoTypes["YIELD_DISEASE"]
local yieldHealthID  = GameInfoTypes["YIELD_HEALTH"]
local yieldFoodID	 = YieldTypes.YIELD_FOOD
local yieldGoldID	 = YieldTypes.YIELD_GOLD
local yieldProductionID	 = YieldTypes.YIELD_PRODUCTION



function Game.GetRandom(lower, upper)
	return Game.Rand((upper + 2) - lower, "") + lower
end

