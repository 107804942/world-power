PlayerClass		 = getmetatable(Players[0]).__index
LuaEvents.Player = LuaEvents.Player		or function(player)	 end
LuaEvents.City	 = LuaEvents.City		or function(city)	 end


local gHandicap			= (PreGame.GetHandicap(0) > 0) and PreGame.GetHandicap(0) or 1


function Game.GetRandom(lower, upper)
	return Game.Rand((upper + 2) - lower, "") + lower
end

-- ********************************************************
-- end
-- ********************************************************	

--Player:GetCityCrimeTT
function Player.GetCityCrimeTT(player, city)
	local totalCrime = city:GetYieldRate(GameInfoTypes["YIELD_CRIME"])
	local toolTipCrime = ""
	local toolTipCrimeSentiment = nil
-- ********************************************************
-- 犯罪率明细
-- ********************************************************

    toolTipCrime = toolTipCrime ..city:GetYieldRateInfoTool(GameInfoTypes["YIELD_CRIME"])

	if city:GetYieldModifierTooltip(GameInfoTypes["YIELD_CRIME"])~= "" then
	   toolTipCrime = toolTipCrime .. city:GetYieldModifierTooltip(GameInfoTypes["YIELD_CRIME"])
	end

	
	----------------------------------------------------------------------------------------------------------
	local CrimeCounter, CrimeThreshold, CrimeTurns = player:GetCityCrimeCounterDetails(city, true, true)
	--local plagueTurnsHL = "[COLOR_DISEASE]"

	local BreakTurn = 0

	if  totalCrime <= 0 then
		BreakTurn = 0
		--CrimeTurnsHL = "[COLOR_HEALTH]"
	end

	toolTipCrimeSentiment = Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_SENTIMENT_TEXT_TT", CrimeCounter, CrimeThreshold)

	if  totalCrime > 0  then
	    BreakTurn = math.max(0,math.ceil((CrimeThreshold-CrimeCounter)/totalCrime ) )   ---发生叛乱爆发的回合数
		toolTipCrimeSentiment = toolTipCrimeSentiment .. "[NEWLINE][NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TURNS_TEXT_TT", BreakTurn)
	end
	return Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TEXT_TT_FOOD", toolTipCrime, totalCrime).."[NEWLINE]" .."[NEWLINE][NEWLINE]"..toolTipCrimeSentiment
	

	--return Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CRIME_TEXT_TT_DETAIL",toolTipCrime)
	
end


------------------------------------------------------------------------------------------------------------------------
-- Crime
------------------------------------------------------------------------------------------------------------------------

local defineCrimeMinThreshold		   = 300
if Game then defineCrimeMinThreshold = (GameDefines["CRIME_MIN_THRESHOLD_" .. GameInfo.GameSpeeds[Game.GetGameSpeedType()].Type] or 300) end


--Player:GetCityCrimeCounterDetails  犯罪率的计数细节（累计进度，爆发阈值）
function Player.GetCityCrimeCounterDetails(player, city, resturnsThreshold, returnsTurns)
    local totalCrime = city:GetYieldRate(GameInfoTypes["YIELD_CRIME"])
	local CrimeCounter = city:GetResistanceCounter()   ----犯罪率计数
	local CrimeThreshold = 0
	if resturnsThreshold then
		CrimeThreshold = defineCrimeMinThreshold ---（总犯罪率阈值，动态阈值）
		--Buildings
		--for row in GameInfo.Building_CrimeMods("CrimeMod <> 0") do
			--if (((not row.IsLocal) and player:HasBuilding(GameInfoTypes[row.BuildingType])) or city:HasBuilding(GameInfoTypes[row.BuildingType])) then
				--CrimeThreshold = CrimeThreshold + math.floor((CrimeThreshold*row.CrimeMod)/100)
			--end
		--end
	end
	local CrimeTurns = 0

	if (returnsTurns and totalCrime < 0) then
		CrimeTurns = math.max(1,(CrimeThreshold-CrimeCounter)/(totalCrime))  --将在剩余若干回合后爆发
	end
	return CrimeCounter, CrimeThreshold, CrimeTurns
end
--------------------------------------------------------------------


