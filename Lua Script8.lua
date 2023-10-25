function MC_Maratha_GunpowderSepoys(teamID, techID)
    local playerID = Teams[teamID]:GetLeaderID()
    local player = Players[playerID]
    if player:GetCivilizationType() ~= civilizationMarathaID then return end
    if techID == techGunpowderID then
        local capital = player:GetCapitalCity()
        player:InitUnit(unitSepoyID, capital:GetX(), capital:GetY())
        player:InitUnit(unitSepoyID, capital:GetX(), capital:GetY())
    end
end
GameEvents.TeamTechResearched.Add(MC_Maratha_GunpowderSepoys)



		--建筑对全局杰作产出
		GreatWorkyieldChange = 0
		for row in  GameInfo.Building_GreatWorkYieldChanges( thisBuildingAndYieldTypes ) do
			GreatWorkyieldChange = GreatWorkyieldChange + (row.Yield or 0)
		end


iImmobileWhileDamaged = GameInfo.UnitPromotions["PROMOTION_IMMOBILE_WHILE_DAMAGED"].ID




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







local tMissions = {
iMove = MissionTypes.MISSION_MOVE_TO,
iRoute = MissionTypes.MISSION_ROUTE_TO,
iMovetoUnit = MissionTypes.MISSION_MOVE_TO_UNIT,
iSwap = MissionTypes.MISSION_SWAP_UNITS
}

function ImmobileWhileDamaged(iPlayer, iUnit, iMission)
local pPlayer = Players[iPlayer]
local pUnit = pPlayer:GetUnitByID(iUnit)

if (pUnit:IsHasPromotion(iImmobileWhileDamaged)) and (pUnit:GetCurrHitPoints() < pUnit:GetMaxHitPoints()) then
for sKey, iValue in pairs(tMissions) do
if iMission == iValue then
return false
end
end
end

return true

end
GameEvents.CanStartMission.Add(ImmobileWhileDamaged)