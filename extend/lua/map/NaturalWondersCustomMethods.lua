------------------------------------------------------------------------------
--	FILE:	  NaturalWondersCustomMethods.lua
--	AUTHOR:   Bob Thomas
--	PURPOSE:  Functions designed to support custom natural wonder placement.
------------------------------------------------------------------------------
--	Copyright (c) 2011 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------

--[[ -------------------------------------------------------------------------
NOTE: This file is an essential component of the Start Plot System. I have
separated out the functions in this file to permit more convenient operation
for modders wishing to add new natural wonders or modify existing ones. If
you are supplying new custom methods, you will not have to supply an updated
version of AssignStartingPlots with your mod; instead, you only have to supply
an update of this file along with your updated Civ5Features.xml file.

CONTENTS OF THIS FILE:

* NWCustomEligibility(x, y, method_number)
* NWCustomPlacement(x, y, row_number, method_number)
------------------------------------------------------------------------- ]]--

include("MapmakerUtilities");

------------------------------------------------------------------------------
function NWCustomEligibility(x, y, method_number)
local ePlotOcean = PlotTypes.PLOT_OCEAN
	local ePlotFlat = PlotTypes.PLOT_LAND
	local ePlotHill = PlotTypes.PLOT_HILLS
	local ePlotMountain = PlotTypes.PLOT_MOUNTAIN
	local eTerrainCoast = TerrainTypes.TERRAIN_COAST
	local eTerrainOcean = TerrainTypes.TERRAIN_OCEAN
	local eTerrainGrass = TerrainTypes.TERRAIN_GRASS	
	local eTerrainPlains = TerrainTypes.TERRAIN_PLAINS
	local eTerrainDesert = TerrainTypes.TERRAIN_DESERT
	local eTerrainTundra = TerrainTypes.TERRAIN_TUNDRA
	local eTerrainSnow = TerrainTypes.TERRAIN_SNOW
	local eFeatureNo = FeatureTypes.NO_FEATURE
	local eFeatureForest = FeatureTypes.FEATURE_FOREST
	local eFeatureJungle = FeatureTypes.FEATURE_JUNGLE
	local eFeatureIce = FeatureTypes.FEATURE_ICE
	local eFeatureAtoll = GameInfoTypes.FEATURE_ATOLL

	local tDirectionTypes = {
		DirectionTypes.DIRECTION_NORTHEAST,
		DirectionTypes.DIRECTION_EAST,
		DirectionTypes.DIRECTION_SOUTHEAST,
		DirectionTypes.DIRECTION_SOUTHWEST,
		DirectionTypes.DIRECTION_WEST,
		DirectionTypes.DIRECTION_NORTHWEST
	}

	local iW, iH = Map.GetGridSize()
	
	if method_number == 1 then
		-- This method checks a candidate plot for eligibility to be the Great Barrier Reef.
		local plotIndex = y * iW + x + 1;
		-- We don't care about the center plot for this wonder. It can be forced. It's the surrounding plots that matter.
		-- This is also the only natural wonder type with a footprint larger than seven tiles.
		-- So first we'll check the extra tiles, make sure they are there, are ocean water, and have no Ice.
		-- local iNumCoast = 0;
		local extra_direction_types = {
			DirectionTypes.DIRECTION_EAST,
			DirectionTypes.DIRECTION_SOUTHEAST,
			DirectionTypes.DIRECTION_SOUTHWEST};
		local SEPlot = Map.PlotDirection(x, y, DirectionTypes.DIRECTION_SOUTHEAST)
		if SEPlot == nil then
			return false
		end
		local southeastX = SEPlot:GetX();
		local southeastY = SEPlot:GetY();
		for loop, direction in ipairs(extra_direction_types) do -- The three plots extending another plot past the SE plot.
			local adjPlot = Map.PlotDirection(southeastX, southeastY, direction)
			if adjPlot == nil then
				return false
			end
			if adjPlot:IsWater() == false or adjPlot:IsLake() == true then
				return false
			end
			local featureType = adjPlot:GetFeatureType()
			if featureType == FeatureTypes.FEATURE_ICE then -- allow oasis
				return false
			end
			-- local terrainType = adjPlot:GetTerrainType()
			-- if terrainType == TerrainTypes.TERRAIN_COAST then
				-- iNumCoast = iNumCoast + 1;
			-- end
		end
		-- Now check the rest of the adjacent plots.
		local direction_types = { -- Not checking to southeast.
			DirectionTypes.DIRECTION_NORTHEAST,
			DirectionTypes.DIRECTION_EAST,
			DirectionTypes.DIRECTION_SOUTHWEST,
			DirectionTypes.DIRECTION_WEST,
			DirectionTypes.DIRECTION_NORTHWEST};
		for loop, direction in ipairs(direction_types) do
			local adjPlot = Map.PlotDirection(x, y, direction)
			if adjPlot == nil then
				return false
			end
			if adjPlot:IsWater() == false or adjPlot:IsLake() == true then
				return false
			end
			local featureType = adjPlot:GetFeatureType()
			if featureType == FeatureTypes.FEATURE_ICE then -- allow oasis
				return false
			end
			-- local terrainType = adjPlot:GetTerrainType()
			-- if terrainType == TerrainTypes.TERRAIN_COAST then
				-- iNumCoast = iNumCoast + 1;
			-- end
		end
		-- If not enough coasts, reject this site.
		-- Removed since fertility check should be enough.
		-- if iNumCoast < 4 then
			-- return false
		-- end
		-- This site is in the water, with at least some of the water plots being coast, so it's good.
		return true
	
	elseif method_number == 2 then
		-- This method checks a candidate plot for eligibility to be Rock of Gibraltar.
		local plot = Map.GetPlot(x, y);
		-- Checking center plot, which must be in the water or on the coast.
		if plot:IsWater() == false and AdjacentToSaltWater(x, y) == false then
			return false
		end
		-- Now process the surrounding plots.
		local iNumLand, iNumCoast = 0, 0;
		local direction_types = {
			DirectionTypes.DIRECTION_NORTHEAST,
			DirectionTypes.DIRECTION_EAST,
			DirectionTypes.DIRECTION_SOUTHEAST,
			DirectionTypes.DIRECTION_SOUTHWEST,
			DirectionTypes.DIRECTION_WEST,
			DirectionTypes.DIRECTION_NORTHWEST
		};
		for loop, direction in ipairs(direction_types) do
			local adjPlot = Map.PlotDirection(x, y, direction)
			local plotType = adjPlot:GetPlotType();
			local terrainType = adjPlot:GetTerrainType()
			local featureType = adjPlot:GetFeatureType()
			if terrainType == TerrainTypes.TERRAIN_COAST and plot:IsLake() == false then
				if featureType == FeatureTypes.NO_FEATURE then
					iNumCoast = iNumCoast + 1;
				end
			end
			if plotType ~= PlotTypes.PLOT_OCEAN then
				iNumLand = iNumLand + 1;
			end
		end
		-- If too much land (or none), reject this site.
		if iNumLand ~= 1 then
			return false
		end
		-- If not enough coast, reject this site.
		if iNumCoast < 3 then
			return false
		end
		-- This site is good.
		return true

	-- These method numbers are not needed for the core game's natural wonders;
	-- however, this is where a modder could insert more custom methods, as needed.
	-- Any new methods added must be called from Natural_Wonder_Placement in Civ5Features.xml - Sirian, June 2011
	--
	--elseif method_number == 3 then
	--elseif method_number == 4 then
	--elseif method_number == 5 then

	elseif method_number == 6 then
		-- reserved: 乌尤尼盐湖
	elseif method_number == 9 then
		-- reserved: 珠峰

    
	elseif method_number == 10 then
		-- reserved: 瑞特巴湖
		local pMainPlot = Map.GetPlot(x, y)
		
		if pMainPlot == nil then return false end
		if not pMainPlot:IsAdjacentToShallowWater() then return false end
		if pMainPlot:IsRiver() then return false end
		if pMainPlot:GetPlotType() ~= ePlotFlat and pMainPlot:GetPlotType() ~= ePlotHill then return false end
		
		local pMainTerrainType = pMainPlot:GetTerrainType()

		if pMainTerrainType == eTerrainTundra or pMainTerrainType == eTerrainSnow then return false end
		
		local pMainAreaNear = pMainPlot:Area():GetNumTiles()

		if pMainAreaNear < 30 then return false end 

		local bIsHasSeaTiles = false
		local iNumLandTiles = 0

		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			
			if pAdjacentPlot == nil then return false end
		
			local sAdjacentTerrainType = pAdjacentPlot:GetTerrainType()

			if sAdjacentTerrainType == eTerrainGrass or sAdjacentTerrainType == eTerrainTundra or sAdjacentTerrainType == eTerrainSnow then return false end

			local sAdjacentPlotType = pAdjacentPlot:GetPlotType()
			
			if sAdjacentPlotType == ePlotMountain then return false end
			if not bIsHasSeaTiles and sAdjacentPlotType == ePlotOcean then
				if pAdjacentPlot:IsLake() then return false end
				
				bIsHasSeaTiles = true
			end

			if sAdjacentPlotType ~= ePlotOcean then
				iNumLandTiles = iNumLandTiles + 1
			end
		end

		if not bIsHasSeaTiles or iNumLandTiles < 3 or iNumLandTiles > 4 then return false end

		return true
	elseif method_number == 13 then
		-- reserved: 达洛尔火山
	elseif method_number == 14 then
		-- 荧光海
		local pPlot = Map.GetPlot(x, y)
		
		if pPlot == nil then return false end
		if pPlot:IsWater() == false then return false end
		if pPlot:IsLake() then return false end
		if pPlot:GetTerrainType() ~= eTerrainCoast then return false end
		
		local iNumCoast, iNumJungle, iNumGrass = 0, 0, 0

		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			
			if pAdjacentPlot == nil then return false end
		
			local sAdjacentPlotType = pAdjacentPlot:GetPlotType()
			local sAdjacentFeatureType = pAdjacentPlot:GetFeatureType()
			
			if sAdjacentPlotType ~= ePlotOcean then
				if sAdjacentFeatureType == eFeatureJungle then
					iNumJungle = iNumJungle + 1
				end
			else
				iNumCoast = iNumCoast + 1
			end
		end
		
		if iNumCoast < 1 or iNumCoast > 3 or iNumJungle == 0 then return false end
		
		return true



		elseif method_number == 15 then
		-- 巨人堤
		local pPlot = Map.GetPlot(x, y)
		
		if pPlot == nil then return false end
		if pPlot:IsWater() == false then return false end
		if pPlot:IsLake() then return false end
		if pPlot:GetTerrainType() ~= eTerrainCoast then return false end
		
		local iNumCoast, iNumJungle, iNumGrass = 0, 0, 0

		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			
			if pAdjacentPlot == nil then return false end
		
			local sAdjacentPlotType = pAdjacentPlot:GetPlotType()
			local sAdjacentFeatureType = pAdjacentPlot:GetFeatureType()
			
			if sAdjacentPlotType ~= ePlotOcean then
				if sAdjacentFeatureType == eFeatureJungle or sAdjacentFeatureType == eFeatureForest then
					iNumJungle = iNumJungle + 1
				end
			else
				iNumCoast = iNumCoast + 1
			end
		end
		
		if iNumCoast < 1 or iNumCoast > 4 or iNumJungle > 0 then return false end
		
		return true
		-- end

 elseif method_number == 16 then
		-- reserved: 精致拱门
		local pMainPlot = Map.GetPlot(x, y)
		
		if pMainPlot == nil then return false end
		---if not pMainPlot:IsAdjacentToShallowWater() then return false end   --必须临近浅水
		if pMainPlot:IsRiver() then return false end  ---不可沿河
		if pMainPlot:GetPlotType() ~= ePlotFlat  then return false end
		--if pMainPlot:GetTerrainType() ~= eTerrainDesert then return false end ---非沙漠   

		local pMainTerrainType = pMainPlot:GetTerrainType()

		if pMainTerrainType ~= eTerrainDesert then return false end ---非沙漠 
		
		--local pMainAreaNear = pMainPlot:Area():GetNumTiles()

		--if pMainAreaNear < 20 then return false end 

		local bIsHasSeaTiles = false
		local iNumLandTiles = 0

		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			
			if pAdjacentPlot == nil then return false end
		
			local sAdjacentTerrainType = pAdjacentPlot:GetTerrainType()

			if sAdjacentTerrainType ~= eTerrainDesert then return false end  ----附近地块非沙漠

			local sAdjacentPlotType = pAdjacentPlot:GetPlotType()
			
			if sAdjacentPlotType == ePlotMountain  then return false end  ---临近地块存在山脉
			--if sAdjacentPlotType:IsNaturalWonder()  then return false end  ---临近地块存在自然奇观

		end

		return true



	elseif method_number == 100 then
		-- dummy
		return false
	else
		-- unidentified method number;
		return false
	end
end
------------------------------------------------------------------------------
function NWCustomPlacement(x, y, row_number, method_number)
	local ePlotOcean = PlotTypes.PLOT_OCEAN
	local ePlotFlat = PlotTypes.PLOT_LAND
	local ePlotHill = PlotTypes.PLOT_HILLS
	local ePlotMountain = PlotTypes.PLOT_MOUNTAIN
	local eTerrainCoast = TerrainTypes.TERRAIN_COAST
	local eTerrainGrass = TerrainTypes.TERRAIN_GRASS	
	local eTerrainPlains = TerrainTypes.TERRAIN_PLAINS
	local eTerrainDesert = TerrainTypes.TERRAIN_DESERT
	local eTerrainTundra = TerrainTypes.TERRAIN_TUNDRA
	local eTerrainSnow = TerrainTypes.TERRAIN_SNOW
	local eTerrainMountain = TerrainTypes.TERRAIN_MOUNTAIN
	local eFeatureNo = FeatureTypes.NO_FEATURE
	local eFeatureForest = FeatureTypes.FEATURE_FOREST
	local eFeatureJungle = FeatureTypes.FEATURE_JUNGLE
	local eFeatureAtoll = GameInfoTypes.FEATURE_ATOLL
	local eFeatureOasis = GameInfoTypes.FEATURE_OASIS
	
	local tDirectionTypes = {
		DirectionTypes.DIRECTION_NORTHEAST,
		DirectionTypes.DIRECTION_EAST,
		DirectionTypes.DIRECTION_SOUTHEAST,
		DirectionTypes.DIRECTION_SOUTHWEST,
		DirectionTypes.DIRECTION_WEST,
		DirectionTypes.DIRECTION_NORTHWEST
	}

	local tDirectionsTop = {
		DirectionTypes.DIRECTION_NORTHWEST,
		DirectionTypes.DIRECTION_NORTHEAST,
		DirectionTypes.DIRECTION_WEST,
		DirectionTypes.DIRECTION_EAST
	}
	local tDirectionsBottomRight = {
		DirectionTypes.DIRECTION_EAST,
		DirectionTypes.DIRECTION_SOUTHEAST,
		DirectionTypes.DIRECTION_SOUTHWEST
	}
	local tDirectionsBottomLeft = {
		DirectionTypes.DIRECTION_SOUTHWEST,
		DirectionTypes.DIRECTION_WEST
	}
	
	local eDirW = DirectionTypes.DIRECTION_WEST
	local eDirNE = DirectionTypes.DIRECTION_NORTHEAST
	local eDirNW = DirectionTypes.DIRECTION_NORTHWEST
	local eDirE = DirectionTypes.DIRECTION_EAST
	local eDirSE = DirectionTypes.DIRECTION_SOUTHEAST
	local eDirSW = DirectionTypes.DIRECTION_SOUTHWEST

	local eFlowN = FlowDirectionTypes.FLOWDIRECTION_NORTH
	local eFlowNE = FlowDirectionTypes.FLOWDIRECTION_NORTHEAST
	local eFlowNW = FlowDirectionTypes.FLOWDIRECTION_NORTHWEST
	local eFlowS = FlowDirectionTypes.FLOWDIRECTION_SOUTH
	local eFlowSE = FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST
	local eFlowSW = FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST
	
	local iW, iH = Map.GetGridSize();
	if method_number == 1 then
		-- This method handles tile changes for the Great Barrier Reef.
		local plot = Map.GetPlot(x, y);
		if not plot:IsWater() then
			plot:SetPlotType(PlotTypes.PLOT_OCEAN, false, false);
		end
		if plot:GetTerrainType() ~= TerrainTypes.TERRAIN_COAST then
			plot:SetTerrainType(TerrainTypes.TERRAIN_COAST, false, false)
		end
		-- The Reef has a longer shape and demands unique handling. Process the extra plots.
		local extra_direction_types = {
			DirectionTypes.DIRECTION_EAST,
			DirectionTypes.DIRECTION_SOUTHEAST,
			DirectionTypes.DIRECTION_SOUTHWEST};
		local SEPlot = Map.PlotDirection(x, y, DirectionTypes.DIRECTION_SOUTHEAST)
		if not SEPlot:IsWater() then
			SEPlot:SetPlotType(PlotTypes.PLOT_OCEAN, false, false);
		end
		if SEPlot:GetTerrainType() ~= TerrainTypes.TERRAIN_COAST then
			SEPlot:SetTerrainType(TerrainTypes.TERRAIN_COAST, false, false)
		end
		if SEPlot:GetFeatureType() ~= FeatureTypes.NO_FEATURE then
			SEPlot:SetFeatureType(FeatureTypes.NO_FEATURE, -1)
		end
		local southeastX = SEPlot:GetX();
		local southeastY = SEPlot:GetY();
		for loop, direction in ipairs(extra_direction_types) do -- The three plots extending another plot past the SE plot.
			local adjPlot = Map.PlotDirection(southeastX, southeastY, direction)
			if adjPlot:GetTerrainType() ~= TerrainTypes.TERRAIN_COAST then
				adjPlot:SetTerrainType(TerrainTypes.TERRAIN_COAST, false, false)
			end
			local adjX = adjPlot:GetX();
			local adjY = adjPlot:GetY();
			local adjPlotIndex = adjY * iW + adjX + 1;
		end
		-- Now check the rest of the adjacent plots.
		local direction_types = { -- Not checking to southeast.
			DirectionTypes.DIRECTION_NORTHEAST,
			DirectionTypes.DIRECTION_EAST,
			DirectionTypes.DIRECTION_SOUTHWEST,
			DirectionTypes.DIRECTION_WEST,
			DirectionTypes.DIRECTION_NORTHWEST
			};
		for loop, direction in ipairs(direction_types) do
			local adjPlot = Map.PlotDirection(x, y, direction)
			if adjPlot:GetTerrainType() ~= TerrainTypes.TERRAIN_COAST then
				adjPlot:SetTerrainType(TerrainTypes.TERRAIN_COAST, false, false)
			end
		end
		-- Now place the Reef's second wonder plot. (The core method will place the main plot).
		local feature_type_to_place;
		for thisFeature in GameInfo.Features() do
			if thisFeature.Type == "FEATURE_REEF" then
				feature_type_to_place = thisFeature.ID;
				break
			end
		end
		SEPlot:SetFeatureType(feature_type_to_place);
	
	elseif method_number == 2 then
		-- This method handles tile changes for the Rock of Gibraltar.
		local plot = Map.GetPlot(x, y);
		plot:SetPlotType(PlotTypes.PLOT_LAND, false, false);
		plot:SetTerrainType(TerrainTypes.TERRAIN_GRASS, false, false)
		local direction_types = {
			DirectionTypes.DIRECTION_NORTHEAST,
			DirectionTypes.DIRECTION_EAST,
			DirectionTypes.DIRECTION_SOUTHEAST,
			DirectionTypes.DIRECTION_SOUTHWEST,
			DirectionTypes.DIRECTION_WEST,
			DirectionTypes.DIRECTION_NORTHWEST};
		for loop, direction in ipairs(direction_types) do
			local adjPlot = Map.PlotDirection(x, y, direction)
			if adjPlot:GetPlotType() == PlotTypes.PLOT_OCEAN then
				if adjPlot:GetTerrainType() ~= TerrainTypes.TERRAIN_COAST then
					adjPlot:SetTerrainType(TerrainTypes.TERRAIN_COAST, false, false)
				end
			else
				if adjPlot:GetPlotType() ~= PlotTypes.PLOT_MOUNTAIN then
					adjPlot:SetPlotType(PlotTypes.PLOT_MOUNTAIN, false, false);
				end
			end
		end

	-- These method numbers are not needed for the core game's natural wonders;
	-- however, this is where a modder could insert more custom methods, as needed.
	-- Any new methods added must be called from Natural_Wonder_Placement in Civ5Features.xml - Sirian, June 2011
	--
	--elseif method_number == 3 then
	--elseif method_number == 4 then
	--elseif method_number == 5 then
	elseif method_number == 6 then
		-- SALAR DE UYUNI
		local pPlot = Map.GetPlot(x, y)

		pPlot:SetPlotType(ePlotFlat, false, false)
		pPlot:SetTerrainType(eTerrainDesert, false, false)
		
		local iRandomMountain, iRandomOasis
		local iLimitMountains = 0

		-- checking for Mountains
		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)

			pAdjacentPlot:SetTerrainType(eTerrainDesert, false, false)
			
			if pAdjacentPlot:GetPlotType() == ePlotMountain then
				iLimitMountains = iLimitMountains + 1
			end
		end
		
		print("--!SALAR: how many mountains?", iLimitMountains)
					
		-- making Desert and cleaning Features and Hills around
		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)

			pAdjacentPlot:SetTerrainType(eTerrainDesert, false, false)
			
			if pAdjacentPlot:GetPlotType() == ePlotHill and iLimitMountains <= 2 then
				iRandomMountain = math.random(3) -- 66%
				print("--!SALAR: hill detected around main tile", pAdjacentPlot:GetX(), pAdjacentPlot:GetY())
				if iRandomMountain ~= 1 then
					pAdjacentPlot:SetPlotType(ePlotMountain, false, false)
					iLimitMountains = iLimitMountains + 1
					print("--!SALAR: hill converted into a mountain", iLimitMountains)
				end
				
				if pAdjacentPlot:GetFeatureType()~=FeatureTypes.FEATURE_FLOOD_PLAINS then
				pAdjacentPlot:SetFeatureType(eFeatureNo)
				end

			elseif pAdjacentPlot:GetPlotType() == ePlotFlat then
				iRandomOasis = math.random(4) -- 25%
				print("--!SALAR: flat detected around main tile", pAdjacentPlot:GetX(), pAdjacentPlot:GetY())
				if iRandomOasis == 1 then
					print("--!SALAR: added oasis around main tile")
					pAdjacentPlot:SetFeatureType(eFeatureOasis)
				else
					print("--!SALAR: deleted any features around main tile")
					if pAdjacentPlot:GetFeatureType()~=FeatureTypes.FEATURE_FLOOD_PLAINS then
					pAdjacentPlot:SetFeatureType(eFeatureNo)
					end
				end
			end	
		end

		-- finding suitable places for SALAR
		local tPossibleSpots = {}
		local pAdjacentPlot

		-- 4 loops to check the hardest condition first
		for j = 1, 4 do
			for i, direction in ipairs(tDirectionTypes) do
				pAdjacentPlot = Map.PlotDirection(x, y, direction)

				if j == 1 then
					if not pAdjacentPlot:IsAdjacentToShallowWater() and not pAdjacentPlot:IsRiver() then
						table.insert(tPossibleSpots, pAdjacentPlot)
					end
				elseif j == 2 then
					if not pAdjacentPlot:IsAdjacentToShallowWater() then	
						table.insert(tPossibleSpots, pAdjacentPlot)
					end
				elseif j == 3 then
					if not pAdjacentPlot:IsRiver() then	
						table.insert(tPossibleSpots, pAdjacentPlot)
					end
				elseif j == 4 then
					table.insert(tPossibleSpots, pAdjacentPlot)
				end		
			end
			print("--!Possible spots for Salar", "iteration #", j, "Spots:", #tPossibleSpots)
			if #tPossibleSpots > 0 then break end
		end
		
		-- choosing plot for SALAR  盐湖
		pChosenPlot = table.remove(tPossibleSpots, math.random(#tPossibleSpots))

		local pChosenPlotX = pChosenPlot:GetX()
		local pChosenPlotY = pChosenPlot:GetY()

		-- cleaning up Hills and Features and setting up Desert
		for j, subdirection in ipairs(tDirectionTypes) do
			local pSecondAdjacentPlot = Map.PlotDirection(pChosenPlotX, pChosenPlotY, subdirection)
			
			pSecondAdjacentPlot:SetTerrainType(eTerrainDesert, false, false)
	
			if pSecondAdjacentPlot:GetFeatureType() ~= GameInfoTypes.FEATURE_SALAR_A then
				if pSecondAdjacentPlot:GetPlotType() == ePlotHill and iLimitMountains < 2 then
					iRandomMountain = math.random(2) -- 50%

					if iRandomMountain ~= 1 then
						pSecondAdjacentPlot:SetPlotType(ePlotMountain, false, false)
						iLimitMountains = iLimitMountains + 1
					end

					if pSecondAdjacentPlot:GetFeatureType()~=FeatureTypes.FEATURE_FLOOD_PLAINS then
					pSecondAdjacentPlot:SetFeatureType(eFeatureNo)
					end

				elseif pAdjacentPlot:GetPlotType() == ePlotFlat or pAdjacentPlot:GetPlotType() == ePlotOcean then
					pSecondAdjacentPlot:SetPlotType(ePlotFlat, false, false)
					iRandomOasis = math.random(3) -- 33%

					if iRandomOasis == 1 then
						pSecondAdjacentPlot:SetFeatureType(eFeatureOasis)
					else
					    if pSecondAdjacentPlot:GetFeatureType()~=FeatureTypes.FEATURE_FLOOD_PLAINS then
						pSecondAdjacentPlot:SetFeatureType(eFeatureNo)
						end
					end
				end	
			end
		end				

		pChosenPlot:SetPlotType(ePlotFlat, false, false)
		pChosenPlot:SetResourceType(-1)		
		pChosenPlot:SetFeatureType(GameInfoTypes.FEATURE_SALAR_B)


	elseif method_number == 9 then
		-- MT. EVEREST  珠穆朗玛
		local pPlot = Map.GetPlot(x, y)
	
		--pPlot:SetPlotType(ePlotFlat, false, false)
		pPlot:SetPlotType(ePlotMountain, false, false)
		pPlot:SetTerrainType(eTerrainSnow, false, false)
		
		-- creating Mountains around
		local iNumMountains = 0

		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			
			if pAdjacentPlot:GetPlotType() == ePlotMountain then
				iNumMountains = iNumMountains + 1
			end	
		end

		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			pAdjacentPlot:SetFeatureType(eFeatureNo)

			if (pAdjacentPlot:GetPlotType() == ePlotHill or pAdjacentPlot:GetPlotType() == ePlotFlat) and iNumMountains < 4 then
				pAdjacentPlot:SetPlotType(ePlotMountain, false, false)
				pAdjacentPlot:SetResourceType(-1)		
				iNumMountains = iNumMountains + 1
			end	
			
			if pAdjacentPlot:GetTerrainType() == eTerrainGrass or pAdjacentPlot:GetTerrainType() == eTerrainPlains then
				pAdjacentPlot:SetTerrainType(eTerrainTundra, false, false)
				pAdjacentPlot:SetResourceType(-1)
			end

			if pAdjacentPlot:GetTerrainType() == eTerrainDesert then
				pAdjacentPlot:SetTerrainType(eTerrainSnow, false, false)
				pAdjacentPlot:SetResourceType(-1)
			end
		end


	elseif method_number == 10 then
		-- LAKE RETBA 瑞特巴湖
		local pPlot = Map.GetPlot(x, y)
		
		pPlot:SetPlotType(ePlotFlat, false, false)
		pPlot:SetTerrainType(eTerrainPlains, false, false)
		pPlot:SetResourceType(-1) ---消除资源

		-- setting up Plains around and cleaning Forests and Jungles
		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)

			if pAdjacentPlot:GetPlotType() ~= ePlotOcean and pAdjacentPlot:GetTerrainType() ~= eTerrainDesert then
				pAdjacentPlot:SetTerrainType(eTerrainPlains, false, false)
				
				if pAdjacentPlot:GetFeatureType() == eFeatureForest or pAdjacentPlot:GetFeatureType() == eFeatureJungle then
					pAdjacentPlot:SetFeatureType(eFeatureNo)
				end
			end
		end


	


	elseif method_number == 15 then
		--巨人堤
		local pPlot = Map.GetPlot(x, y)
		
		pPlot:SetPlotType(ePlotOcean, false, false)
		--pPlot:SetTerrainType(eTerrainPlains, false, false)

		-- setting up Plains around and cleaning Forests and Jungles
		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)

			if pAdjacentPlot:GetPlotType() ~= ePlotOcean 
			--and pAdjacentPlot:GetTerrainType() ~= eTerrainDesert
			 then
				--pAdjacentPlot:SetTerrainType(eTerrainPlains, false, false)
				pAdjacentPlot:SetPlotType(ePlotHill, false, false)

				if pAdjacentPlot:GetFeatureType() == eFeatureForest or pAdjacentPlot:GetFeatureType() == eFeatureJungle then
					pAdjacentPlot:SetFeatureType(eFeatureNo)
				end
			end
		end


elseif method_number == 16 then
		-- 精致拱门
		local pPlot = Map.GetPlot(x, y)
		
		pPlot:SetPlotType(ePlotFlat, false, false)
		pPlot:SetTerrainType(eTerrainDesert, false, false)
		pPlot:SetResourceType(-1) ---消除资源

		-- setting up Plains around and cleaning Forests and Jungles
		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)

			if pAdjacentPlot:GetPlotType() ~= ePlotOcean and pAdjacentPlot:GetTerrainType() ~= eTerrainDesert then
				pAdjacentPlot:SetTerrainType(eTerrainDesert, false, false)
				
				if pAdjacentPlot:GetFeatureType() == eFeatureForest or pAdjacentPlot:GetFeatureType() == eFeatureJungle then
					pAdjacentPlot:SetFeatureType(eFeatureNo)
				end
			end
		end


	elseif method_number == 14 then
		-- BIOLUMINESCENT BAY
		local iJungleChance = 0
		
		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			local pAdjacentTerrainType = pAdjacentPlot:GetTerrainType()

			-- making Grass on all lands around
			if pAdjacentPlot:GetPlotType() ~= ePlotOcean then
				pAdjacentPlot:SetTerrainType(eTerrainGrass, false, false)
				
				iJungleChance = math.random(3)
				
				if iJungleChance > 1 then
					pAdjacentPlot:SetFeatureType(eFeatureJungle)
				end
			end
		end
	end
end
------------------------------------------------------------------------------
