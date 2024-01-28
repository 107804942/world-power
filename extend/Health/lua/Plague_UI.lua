PlayerClass		 = getmetatable(Players[0]).__index
LuaEvents.Player = LuaEvents.Player		or function(player)	 end
LuaEvents.City	 = LuaEvents.City		or function(city)	 end

--=======================================================================================================================
-- GAME DEFINES
--=======================================================================================================================
local gHandicap			= (PreGame.GetHandicap(0) > 0) and PreGame.GetHandicap(0) or 1
local defineCIDHealthPlagueMinThreshold		   = 150
if Game then defineCIDHealthPlagueMinThreshold = (GameDefines["HEALTH_PLAGUE_MIN_THRESHOLD_" .. GameInfo.GameSpeeds[Game.GetGameSpeedType()].Type] or 150) end

--------------------------------------------------------------------
-- UI
--------------------------------------------------------------------
function PlayerClass.GetEmpireHealthTotal(pPlayer)
	local t = pPlayer:GetYieldRateModifier(GameInfoTypes["YIELD_HEALTH"])
	return t
end
LuaEvents.Player.Add( PlayerClass.GetEmpireHealthTotal )

--------------------------------------------------------------------
--�����������
--------------------------------------------------------------------
function GetCityPlagueInfoForTopPlane(pCity)
    local totalHealth = pCity:GetYieldRate(GameInfoTypes["YIELD_HEALTH"])
	local totalDisease = pCity:GetYieldRate(GameInfoTypes["YIELD_DISEASE"])
	local plagueCounter, plagueThreshold, plagueTurns = pPlayer:GetCityPlagueCounterDetails(pCity, true, true)
	local iCityHealthIndex=totalHealth-totalDisease
	local plagueFinal =plagueThreshold-plagueCounter
	if iCityHealthIndex <0 and pCity:GetPlagueType()~=-1  then
		   plagueTurns=math.max(0,math.ceil((plagueFinal)/(-iCityHealthIndex)))
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


-- ********************************************************
-- ��������
-- ********************************************************
--Player:GetCityHealthTT
function Player.GetCityHealthTT(player, city)
    local totalHealth = city:GetYieldRate(GameInfoTypes["YIELD_HEALTH"])
	local totalDisease = city:GetYieldRate(GameInfoTypes["YIELD_DISEASE"])
	local toolTipHealth = ""
	local toolTipDisease = ""
	local toolTipPlagueSentiment = nil

-- ********************************************************
-- ������ϸ
-- ********************************************************

	toolTipDisease = toolTipDisease..city:GetYieldRateInfoTool( GameInfoTypes["YIELD_DISEASE"])


	if city:GetYieldModifierTooltip( GameInfoTypes["YIELD_DISEASE"])~= "" then
	   toolTipDisease = toolTipDisease .. city:GetYieldModifierTooltip( GameInfoTypes["YIELD_DISEASE"])
	end

-- ********************************************************
-- ��������ϸ
-- ********************************************************
  
	toolTipHealth = toolTipHealth ..city:GetYieldRateInfoTool(GameInfoTypes["YIELD_HEALTH"])

	if city:GetYieldModifierTooltip(GameInfoTypes["YIELD_HEALTH"])~= "" then
	   toolTipHealth = toolTipHealth .. city:GetYieldModifierTooltip(GameInfoTypes["YIELD_HEALTH"])
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

	toolTipPlagueSentiment = Locale.ConvertTextKey("TXT_KEY_CITYVIEW_HEALTH_PLAGUE_SENTIMENT_TEXT_TT", plagueTurnsHL, plagueCounter, plagueThreshold)

	if (totalHealth - totalDisease < 0 and (not city:HasPlague())) then
	    BreakTurn = math.max(0,math.ceil((plagueThreshold-plagueCounter)/(totalDisease-totalHealth)))
		toolTipPlagueSentiment = toolTipPlagueSentiment .. "[NEWLINE][NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITYVIEW_HEALTH_PLAGUE_TURNS_TEXT_TT", plagueTurnsHL, BreakTurn)
	end
	return Locale.ConvertTextKey("TXT_KEY_CITYVIEW_HEALTH_TEXT_TT_FOOD", toolTipDisease, totalDisease, toolTipHealth, totalHealth).."[NEWLINE]" .."[NEWLINE][NEWLINE]"..toolTipPlagueSentiment
	
end

------------------------------------------------------------------------------------------------------------------------
-- PLAGUE
------------------------------------------------------------------------------------------------------------------------
--Player:GetCityPlagueCounterDetails  ���ߵļ���ϸ�ڣ��ۼƽ��ȣ�������ֵ�����߻غ�����
function Player.GetCityPlagueCounterDetails(player, city, resturnsThreshold, returnsTurns)
    local totalHealth = city:GetYieldRate(GameInfoTypes["YIELD_HEALTH"])
	local totalDisease = city:GetYieldRate( GameInfoTypes["YIELD_DISEASE"])
	local plagueCounter = city:GetPlagueCounter()   ----��������
	local plagueThreshold = 0
	if resturnsThreshold then
		plagueThreshold = defineCIDHealthPlagueMinThreshold ---���ܽ�������ֵ����̬��ֵ��
		--Buildings
		for row in GameInfo.Building_HealthMods("PlagueMod <> 0") do
			if (((not row.IsLocal) and player:HasBuilding(GameInfoTypes[row.BuildingType])) or city:HasBuilding(GameInfoTypes[row.BuildingType])) then
				plagueThreshold = plagueThreshold + math.floor((plagueThreshold*row.PlagueMod)/100)
			end
		end
	end
	local plagueTurns = 0

	if (returnsTurns and totalHealth-totalDisease < 0) then
		plagueTurns = math.max(1,(plagueThreshold-plagueCounter)/(totalDisease-totalHealth))  --����ʣ�����ɻغϺ󱬷�
	end
	return plagueCounter, plagueThreshold, plagueTurns
end
--------------------------------------------------------------------

