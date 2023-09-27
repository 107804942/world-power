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