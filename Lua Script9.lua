function AddWaterBuildings(pCity)	

	pCity:SetNumRealBuilding(bProductionDummy, 0);

	if pCity:GetProductionBuilding() ~= -1 then
		local Building = pCity:GetProductionBuilding();

		local BClass = GameInfo.Buildings[Building].BuildingClass
		local BType = GameInfo.Buildings[Building].Type

		local BWonder = GameInfo.BuildingClasses["" .. BClass .. ""].MaxGlobalInstances
		local BNational = GameInfo.BuildingClasses["" .. BClass .. ""].MaxPlayerInstances

		local FaithCultureCheck = 0;
		if (BWonder == -1) and (BNational == -1) then
			for tRow in GameInfo.Building_YieldChanges() do
				if tRow.BuildingType == BType then
					if (tRow.YieldType == "YIELD_CULTURE") then
						if tRow.Yield >= 1 then
							FaithCultureCheck = 1;
						end
					elseif (tRow.YieldType == "YIELD_FAITH") then
						if tRow.Yield >= 1 then
							FaithCultureCheck = 1;
						end
					end
				end
			end
		end

		local WorkedWaterCount = 0;
		if FaithCultureCheck >= 1 then
			local plotX = pCity:GetX();
			local plotY = pCity:GetY();
			local iRange = 3;
			for iDX = -iRange, iRange do
				for iDY = -iRange, iRange do
					local pTargetPlot = Map.PlotXYWithRangeCheck(plotX, plotY, iDX, iDY, iRange);
					if pTargetPlot then
						if pTargetPlot:IsFreshWater() and pCity:IsWorkingPlot(pTargetPlot) then
							WorkedWaterCount = WorkedWaterCount + 1;
						end
					end
				end
			end
		end

		pCity:SetNumRealBuilding(bProductionDummy, WorkedWaterCount);

	end

end

function SriLankaWaterProduction(iPlayer)
	local pPlayer = Players[iPlayer];
	if (pPlayer:IsAlive()) then
		if (pPlayer:GetCivilizationType() == GameInfoTypes.CIVILIZATION_LITE_SRI_LANKA) then
			for pCity in pPlayer:Cities() do

				AddWaterBuildings(pCity)

			end
		end
	end
end

GameEvents.PlayerDoTurn.Add(SriLankaWaterProduction)











--------------------------------------------------------------------

function citiesVisible(pTeam)
  -- Could just do tech = GameInfo.Technologies["TECH_SATELLITES"]
  -- but that would exclude any alternative techs that may reveal the map
  --if pPlayer:HasWonder(GameInfoTypes.BUILDING_DIONYSUS) then
  local pOtherTeam = Teams[iOtherTeam]
  for tech in GameInfo.Technologies() do
    if (tech.MapVisible and pTeam:IsHasTech(tech.ID)) then
      print("cities are visible")
      return true
    end
  end

  return false
end


function revealCell(iTeam, pPlot)
  directions = {DirectionTypes.DIRECTION_NORTHEAST, DirectionTypes.DIRECTION_EAST, DirectionTypes.DIRECTION_SOUTHEAST,
                DirectionTypes.DIRECTION_SOUTHWEST, DirectionTypes.DIRECTION_WEST, DirectionTypes.DIRECTION_NORTHWEST}

  -- Reveal the central plot
  revealPlot(iTeam, pPlot)

  -- Reveal the surrounding plots
  for loop, direction in ipairs(directions) do
    revealPlot(iTeam, Map.PlotDirection(pPlot:GetX(), pPlot:GetY(), direction))
  end
end

function revealPlot(iTeam, pPlot)
  -- Don't reveal natural wonders more than once
  if (pPlot:GetFeatureType() == -1 or not GameInfo.Features[pPlot:GetFeatureType()].NaturalWonder) then
    -- Following lines copied from the Live Tuner Map tab script
    if (pPlot:GetVisibilityCount(iTeam) > 0) then
      pPlot:ChangeVisibilityCount(iTeam, -1, -1, true)
    end

    pPlot:SetRevealed(iTeam, false)

    pPlot:ChangeVisibilityCount(iTeam, 1, -1, true)
    pPlot:SetRevealed(iTeam, true)
  end
end

function onActivePlayerTurnStart()
  local iplayer = Game.GetActivePlayer()
  local iTeam = Game.GetActiveTeam()
  local pTeam = Teams[iTeam]

  if (citiesVisible(pTeam)) then

	local ihelios =  Players[Game:GetActivePlayer()]:GetBuildingClassCount(GameInfo.BuildingClasses.BUILDINGCLASS_HELIOS_BUILDING.ID) 

    for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
      local pPlot = Map.GetPlotByIndex(iPlotLoop)

      if (pPlot:IsCity()) then
        local pCity = pPlot:GetPlotCity()

        if (pCity:GetTeam() ~= iTeam) then
          if (ihelios > 0) then
            revealCell(iTeam, pPlot)
          else
            revealPlot(iTeam, pPlot)
          end
        end
      end
    end
  end

end
Events.ActivePlayerTurnStart.Add(onActivePlayerTurnStart)