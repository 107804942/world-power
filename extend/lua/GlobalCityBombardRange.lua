print("This is the 'Global - City Bombard Range' mod script.")


local gTeamRange = {}
local gBombardTechs = {}
local gCityRange = {}
local gBombardBuildings = {}
local gDefaultRange = GameDefines.MAX_CITY_ATTACK_RANGE * ((GameDefines.CAN_CITY_USE_INDIRECT_FIRE == 1) and -1 or 1)

local iBuildingSpaceFortress =GameInfoTypes.BUILDING_SPACE_FORTRESS

function Initialise()
  for row in DB.Query("SELECT ID,  BombardIndirect FROM Technologies WHERE BombardIndirect > 0 ORDER BY BombardIndirect ASC") do
    local iTech = row.ID
    local iRange = ((row.BombardIndirect == 1) and -1 or 1)
  
    gBombardTechs[iTech] = iRange
  
    for iTeam = 0, GameDefines.MAX_CIV_TEAMS, 1 do
      if (Teams[iTeam]:IsHasTech(iTech)) then
	    gTeamRange[iTeam] = iRange
	  end
	end
  end
for row in DB.Query("SELECT ID, BombardRange FROM Buildings WHERE BombardRange > 0 ORDER BY BombardRange ASC") do
		local iBuilding = row.ID
		local iRange = row.BombardRange
		gBombardBuildings[iBuilding] = iRange
		for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
			for pCity in Players[iPlayer]:Cities() do
				if pCity:IsHasBuilding(iBuilding) then
					gCityRange[pCity] = iRange
				end
			end
		end
	end
end

function OnTechResearched(iTeam, iTech, iChange)
	if (iChange == 1 and gBombardTechs[iTech]) then
	  gTeamRange[iTeam] = gBombardTechs[iTech]
	end
end
GameEvents.TeamTechResearched.Add(OnTechResearched)



function OnCityConstructed(iPlayer, iCity, iBuilding)
	if gBombardBuildings[iBuilding] then
		local pCity = Players[iPlayer]:GetCityByID(iCity)
		gCityRange[pCity] = gBombardBuildings[iBuilding]
	end
end
GameEvents.CityConstructed.Add(OnCityConstructed)


function OnNewTurn(iPlayer)
	for pCity in Players[iPlayer]:Cities() do
		--if pCity:IsCapital()     
		--and not   pCity:IsHasBuilding(iBuildingSpaceFortress)    
		--then
			--gCityRange[pCity] = 3
		---else
			for pBuilding in GameInfo.Buildings("BombardRange > 0") do
				if pCity:IsHasBuilding(pBuilding.ID) then
					gCityRange[pCity] = pBuilding.BombardRange
				--end
			end
		end
	end
end
GameEvents.PlayerDoTurn.Add(OnNewTurn)

function OnGetBombardRange(playerID, cityID)
	local player = Players[playerID]
	local city = player:GetCityByID(cityID)
	local bombardRange = gCityRange[city] or 1
    local indirectRange = gTeamRange[player:GetTeam()] or 1
	return (bombardRange*indirectRange) or gDefaultRange
end
GameEvents.GetBombardRange.Add(OnGetBombardRange)

Initialise()


