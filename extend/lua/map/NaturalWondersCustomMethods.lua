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

	-- reserved: Mt. Everest
	elseif method_number == 22 then
		
    -- reserved: 乌尤尼盐湖
	elseif method_number == 6 then

	-- reserved: Mt. Paektu 长白山
	elseif method_number == 8 then

	-- reserved: Eye of the Sahara
	elseif method_number == 12 then
	
	-- reserved: 达洛尔火山
	elseif method_number == 13 then
			
	-- HA LONG BAY	
    elseif method_number == 7 then
		
		local pPlot = Map.GetPlot(x, y)
		
		if pPlot == nil then return false end
		if pPlot:IsWater() == false then return false end
		if pPlot:IsLake() then return false end
		
		local iNumLand, iNumCoast, iNumOcean = 0, 0, 0
		local bContinent, bGrass = false, false

		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			
			if pAdjacentPlot == nil then return false end
		
			local sAdjacentPlotType = pAdjacentPlot:GetPlotType()
			local sAdjacentTerrainType = pAdjacentPlot:GetTerrainType()
			
			if sAdjacentPlotType ~= ePlotOcean then
				iNumLand = iNumLand + 1

				local sAdjacentAreaNear = pAdjacentPlot:Area():GetNumTiles()
				
				if sAdjacentAreaNear > 40 then
					bContinent = true
				end

				if sAdjacentTerrainType == eTerrainGrass then
					bGrass = true
				end
			else
				if sAdjacentTerrainType == eTerrainCoast then
					iNumCoast = iNumCoast + 1
				end
			
				if sAdjacentTerrainType == eTerrainOcean then
					iNumOcean = iNumOcean + 1
				end
			end
		end
		
		if iNumLand == 0 or iNumCoast < 2 or iNumOcean < 2 or bContinent == false or bGrass == false then return false end

		return true

  -- reserved: 群岛
	elseif method_number == 9 then
			local pPlot = Map.GetPlot(x, y)
		
		if pPlot == nil then return false end
		if pPlot:IsWater() == false then return false end
		if pPlot:IsLake() then return false end
		
		local iNumCoast, iNumAtoll = 0, 0
		local bLand = false

		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			
			if pAdjacentPlot == nil then return false end
		
			local sAdjacentPlotType = pAdjacentPlot:GetPlotType()
			local sAdjacentFeatureType = pAdjacentPlot:GetFeatureType()
			local sAdjacentTerrainType = pAdjacentPlot:GetTerrainType()
			
			if sAdjacentPlotType ~= ePlotOcean then
				bLand = true
				break
			end

			if sAdjacentFeatureType == eFeatureAtoll then
				iNumAtoll = iNumAtoll + 1
			end

			if sAdjacentTerrainType == eTerrainCoast then
				iNumCoast = iNumCoast + 1
			end
		end
		
		if iNumCoast < 1 or iNumCoast > 4 or iNumAtoll == 0 or bLand then return false end

		return true


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

		-- GREAT BLUE HOLE
         elseif method_number == 11 then
		
		local pPlot = Map.GetPlot(x, y)
		
		if pPlot == nil then return false end
		if pPlot:IsWater() == false then return false end
		if pPlot:IsLake() then return false end
		
		local iNumAtoll, iNumLand, iNumOcean = 0, 0, 0

		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			
			if pAdjacentPlot == nil then return false end
		
			local sAdjacentPlotType = pAdjacentPlot:GetPlotType()
			local sAdjacentFeatureType = pAdjacentPlot:GetFeatureType()
			local sAdjacentTerrainType = pAdjacentPlot:GetTerrainType()
			
			if sAdjacentPlotType ~= ePlotOcean then
				iNumLand = iNumLand + 1
			end
			
			if sAdjacentFeatureType == eFeatureAtoll then
				iNumAtoll = iNumAtoll + 1
			end
			
			if sAdjacentTerrainType == eTerrainOcean then
				iNumOcean = iNumOcean + 1
			end
		end
		
		if iNumAtoll == 0 or iNumLand == 0 or iNumOcean == 0 then return false end

		return true



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


		

		-- 巨人堤
		elseif method_number == 15 then
		
		local pPlot = Map.GetPlot(x, y)
		
		if pPlot == nil then return false end
		if pPlot:IsWater() == false then return false end
		if pPlot:IsLake() then return false end
		--if pPlot:GetTerrainType() ~= eTerrainCoast then return false end
		
        local iNumLand = 0

		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			
			if pAdjacentPlot == nil then return false end
		
			local sAdjacentPlotType = pAdjacentPlot:GetPlotType()
			local sAdjacentTerrainType = pAdjacentPlot:GetTerrainType()
			local sAdjacentFeatureType = pAdjacentPlot:GetFeatureType()
			
			if sAdjacentFeatureType == eFeatureIce then return false end

			if sAdjacentPlotType ~= ePlotOcean then
				if pAdjacentPlot:Area():GetNumTiles() < 5 or pAdjacentPlot:Area():GetNumTiles() > 50 
				or not (sAdjacentTerrainType == eTerrainTundra or sAdjacentTerrainType == eTerrainGrass or sAdjacentTerrainType == eTerrainPlains)
				or sAdjacentFeatureType ~= eFeatureNo then return false end
				
				iNumLand = iNumLand + 1
				
				if iNumLand > 2 then return false end
			end
		end
		
		if iNumLand < 1 then return false end
		
		return true
		-- end


        -- reserved: 精致拱门
        elseif method_number == 16 then
		
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


		-- reserved: 峡谷
		elseif method_number == 24 then
	
		local pMainPlot = Map.GetPlot(x, y)
		
		if pMainPlot == nil then return false end
		---if not pMainPlot:IsAdjacentToShallowWater() then return false end   --必须临近浅水
		if pMainPlot:IsRiver() then return false end  ---不可沿河
		if pMainPlot:GetPlotType() ~= ePlotFlat  then return false end
  
		local pMainTerrainType = pMainPlot:GetTerrainType()

		if pMainTerrainType ~= eTerrainPlains then return false end  
		
		--local pMainAreaNear = pMainPlot:Area():GetNumTiles()

		--if pMainAreaNear < 20 then return false end 

		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			
			if pAdjacentPlot == nil then return false end
		
			local sAdjacentTerrainType = pAdjacentPlot:GetTerrainType()

			if sAdjacentTerrainType ~= eTerrainPlains then return false end  ----附近地块非

			local sAdjacentPlotType = pAdjacentPlot:GetPlotType()
			
			if sAdjacentPlotType == ePlotMountain  then return false end  ---临近地块存在山脉
			--if sAdjacentPlotType:IsNaturalWonder()  then return false end  ---临近地块存在自然奇观

		end

		return true




	
		-- reserved: 丹霞
        elseif method_number == 17 then
		
		local pMainPlot = Map.GetPlot(x, y)
		
		if pMainPlot == nil then return false end
		---if not pMainPlot:IsAdjacentToShallowWater() then return false end   --必须临近浅水
		if pMainPlot:IsRiver() then return false end  ---不可沿河
		if pMainPlot:GetPlotType() ~= ePlotFlat  then return false end

		local pMainTerrainType = pMainPlot:GetTerrainType()
		if pMainTerrainType ~= eTerrainPlains then return false end ---非平原
		
		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			
			if pAdjacentPlot == nil then return false end
		
			local sAdjacentTerrainType = pAdjacentPlot:GetTerrainType()

			if sAdjacentTerrainType ~= eTerrainPlains then return false end  ----附近地块非沙漠

			local sAdjacentPlotType = pAdjacentPlot:GetPlotType()
			
			if sAdjacentPlotType == ePlotMountain  then return false end  ---临近地块存在山脉
		end

		return true



	


		-- BERMUDA TRIANGLE
		elseif method_number == 18 then
	
		local pMainPlot = Map.GetPlot(x, y)		
		
		if pMainPlot == nil then return false end
		if pMainPlot:IsWater() == false then return false end
		if pMainPlot:IsLake() then return false end

		local pSEPlot = Map.PlotDirection(x, y, DirectionTypes.DIRECTION_SOUTHEAST)
		
		if pSEPlot == nil then return false end
		if pSEPlot:IsWater() == false then return false end
		
		local pSWPlot = Map.PlotDirection(x, y, DirectionTypes.DIRECTION_SOUTHWEST)

		if pSWPlot == nil then return false end
		if pSWPlot:IsWater() == false then return false end
		
		local iNumLandN, iNumLandSE, iNumLandSW = 0, 0, 0
		
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

		for i, direction in ipairs(tDirectionsTop) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)

			if pAdjacentPlot == nil then return false end
			if pAdjacentPlot:GetTerrainType() == eTerrainSnow then return false end

			if pAdjacentPlot:GetPlotType() ~= ePlotOcean then
				iNumLandN = iNumLandN + 1
			end
		end

		local iSEX = pSEPlot:GetX()
		local iSEY = pSEPlot:GetY()

		for i, direction in ipairs(tDirectionsBottomRight) do
			local pAdjacentPlot = Map.PlotDirection(iSEX, iSEY, direction)

			if pAdjacentPlot == nil then return false end
			if pAdjacentPlot:GetTerrainType() == eTerrainSnow then return false end

			if pAdjacentPlot:GetPlotType() ~= ePlotOcean  then
				iNumLandSE = iNumLandSE + 1
			end
		end

		local iSWX = pSWPlot:GetX()
		local iSWY = pSWPlot:GetY()

		for i, direction in ipairs(tDirectionsBottomLeft) do
			local pAdjacentPlot = Map.PlotDirection(iSWX, iSWY, direction)

			if pAdjacentPlot == nil then return false end
			if pAdjacentPlot:GetTerrainType() == eTerrainSnow then return false end

			if pAdjacentPlot:GetPlotType() ~= ePlotOcean then
				iNumLandSW = iNumLandSW + 1
			end
		end
		
		if iNumLandN < 1 or iNumLandSE < 1 or iNumLandSW < 1 then return false end

		local iNumLandSum = iNumLandN + iNumLandSE + iNumLandSW
		
		if iNumLandSum < 3 or iNumLandSum > 5 then return false end
		
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

	-- HA LONG BAY
      elseif method_number == 7 then
	
		local tCoastPlots = {}
		local pChosenPlot

		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			
			-- checking features
			if pAdjacentPlot:GetTerrainType() == eTerrainCoast then
				table.insert(tCoastPlots, pAdjacentPlot)
			end
		end
		
		pChosenPlot = table.remove(tCoastPlots, Game.Rand(#tCoastPlots, "Choose plot for Ha Long Bay B") + 1)
		pChosenPlot:SetFeatureType(GameInfoTypes.FEATURE_HA_LONG_B)


    -- MT. EVEREST  珠穆朗玛
	elseif method_number == 22 then
		
		local pPlot = Map.GetPlot(x, y)
	
		pPlot:SetPlotType(ePlotFlat, false, false)
		--pPlot:SetPlotType(ePlotMountain, false, false)
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

    -- LAKE RETBA 瑞特巴湖
	elseif method_number == 10 then
		
		local pPlot = Map.GetPlot(x, y)
		
		pPlot:SetPlotType(ePlotFlat, false, false)
		--pPlot:SetTerrainType(eTerrainPlains, false, false)
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

	-- MT. PAEKTU 长白山
	elseif method_number == 8 then
	
		local pPlot = Map.GetPlot(x, y)
		
		pPlot:SetPlotType(ePlotFlat, false, false)
		pPlot:SetTerrainType(eTerrainTundra, false, false)

		local tPossibleForests = {}
		local iForestsPlanted = 0

		-- changing snow to tundra
		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			if pAdjacentPlot:GetTerrainType() == eTerrainSnow then
				pAdjacentPlot:SetTerrainType(eTerrainTundra, false, false)
			end

			if pAdjacentPlot:GetTerrainType() == eTerrainTundra and pAdjacentPlot:GetFeatureType() == eFeatureNo then
				table.insert(tPossibleForests, pAdjacentPlot)
			end

			if pAdjacentPlot:GetFeatureType() == eFeatureForest then
				iForestsPlanted = iForestsPlanted + 1
			end
		end

		-- placing some forests
		if iForestsPlanted < 2 and #tPossibleForests ~= 0 then
			local pChosenTileForTheForest

			repeat
				pChosenTileForTheForest = table.remove(tPossibleForests, Game.Rand(#tPossibleForests, "Placing a forest around Mt. Paektu") + 1)
				pChosenTileForTheForest:SetFeatureType(eFeatureForest)
				iForestsPlanted = iForestsPlanted + 1
			until(iForestsPlanted >= 2 or #tPossibleForests == 0)
		end

		-- starting plots for rivers
		local pNEPlot = Map.PlotDirection(x, y, eDirNE)
		local pNWPlot = Map.PlotDirection(x, y, eDirNW)
		local pWPlot = Map.PlotDirection(x, y, eDirW)
		
		-- creating 3 random Rivers with start around MT. PAEKTU
		local iRandomRiverTurn, iCase
		local bIsMetRiver = false
		local bIsMetSeaOrLake = false
		local bIsEndOfTheMap = false
		local pCurrentPlot, pSupportPlot, pUltraSupportPlot
		local iNormalCorrection = -4 
		local iNormalCorrectionToMathRandom = math.abs(iNormalCorrection) * 2
		local iHandicapCorrection = 2 
		local iAdditionalOneWayCorrection = 0 
		
		-- NORTH RIVER (SONGHUA)
		pNWPlot:SetWOfRiver(true, eFlowN)
		
		pCurrentPlot = Map.PlotDirection(pNWPlot:GetX(), pNWPlot:GetY(), eDirNE)
		pSupportPlot = nil
		pUltraSupportPlot = nil

		if pCurrentPlot ~= nil then
			iCase = 1

			repeat
				if iCase == 1 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pCurrentPlot:IsNWOfRiver() or pCurrentPlot:IsNEOfRiver() then bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn <= 0 then
							iCase = 6
						
							pCurrentPlot:SetNEOfRiver(true, eFlowNW)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)
							pSupportPlot = nil
							pUltraSupportPlot = nil

							if pCurrentPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map A1")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn > 0 then
							iCase = 2
						
							pCurrentPlot:SetNWOfRiver(true, eFlowNE)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)
							pUltraSupportPlot = nil

							if pCurrentPlot == nil or pSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map A2")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end
				elseif iCase == 2 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pCurrentPlot:IsNEOfRiver() or pSupportPlot:IsWOfRiver() then	bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn - iHandicapCorrection <= 0 then
							iCase = 1
						
							pSupportPlot:SetWOfRiver(true, eFlowN)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)
							pSupportPlot = nil
							pUltraSupportPlot = nil

							if pCurrentPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map A3")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn > 0 then
							iCase = 3
						
							pCurrentPlot:SetNEOfRiver(true, eFlowSE)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirSE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)
							pUltraSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)

							if pCurrentPlot == nil or pSupportPlot == nil or pUltraSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map A4")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end		
				elseif iCase == 3 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pSupportPlot:IsNWOfRiver() or pUltraSupportPlot:IsWOfRiver() then bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn - iHandicapCorrection <= 0 then
							iCase = 2
						
							pSupportPlot:SetNWOfRiver(true, eFlowNE)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)
							pUltraSupportPlot = nil

							if pCurrentPlot == nil or pSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map A5")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn > 0 then
							iCase = 4
						
							pUltraSupportPlot:SetWOfRiver(true, eFlowS)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirSW)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pUltraSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)

							if pCurrentPlot == nil or pSupportPlot == nil or pUltraSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map A6")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end	
				elseif iCase == 4 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pSupportPlot:IsNEOfRiver() or pUltraSupportPlot:IsNWOfRiver() then bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn <= 0 then
							iCase = 3
						
							pSupportPlot:SetNEOfRiver(true, eFlowSE)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)
							pUltraSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)

							if pCurrentPlot == nil or pSupportPlot == nil or pUltraSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map A7")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn > 0 then
							iCase = 5
						
							pUltraSupportPlot:SetNWOfRiver(true, eFlowSW)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pUltraSupportPlot = nil

							if pCurrentPlot == nil or pSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map A8")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end	
				elseif iCase == 5 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pCurrentPlot:IsWOfRiver() or pSupportPlot:IsNEOfRiver() then bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn <= 0 then
							iCase = 4
						
							pCurrentPlot:SetWOfRiver(true, eFlowS)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirSE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pUltraSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)

							if pCurrentPlot == nil or pSupportPlot == nil or pUltraSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map A9")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn + iHandicapCorrection > 0 then
							iCase = 6
						
							pSupportPlot:SetNEOfRiver(true, eFlowNW)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)
							pSupportPlot = nil
							pUltraSupportPlot = nil

							if pCurrentPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map A10")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end	
				elseif iCase == 6 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pCurrentPlot:IsWOfRiver() or pCurrentPlot:IsNWOfRiver() then bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn <= 0 then
							iCase = 5
						
							pCurrentPlot:SetNWOfRiver(true, eFlowSW)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirSW)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pUltraSupportPlot = nil

							if pCurrentPlot == nil or pSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map A11")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn + iHandicapCorrection > 0 then
							iCase = 1
						
							pCurrentPlot:SetWOfRiver(true, eFlowN)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pSupportPlot = nil
							pUltraSupportPlot = nil

							if pCurrentPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map A12")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end	
				end
			until(bIsMetSeaOrLake or bIsMetRiver or bIsEndOfTheMap)
		else
			print("Paketu river at the end of the map X1")
		end

		-- NORTHEAST RIVER (TUMEN)
		bIsMetRiver = false
		bIsMetSeaOrLake = false
		iAdditionalOneWayCorrection = 0

		pNEPlot:SetNWOfRiver(true, eFlowNE)
		
		pCurrentPlot = Map.PlotDirection(pNEPlot:GetX(), pNEPlot:GetY(), eDirE)
		pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)
		pUltraSupportPlot = nil
		
		if pCurrentPlot ~= nil and pSupportPlot ~= nil then
			iCase = 2

			repeat
				if iCase == 1 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pCurrentPlot:IsNWOfRiver() or pCurrentPlot:IsNEOfRiver() then bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn <= 0 then
							iCase = 6
						
							pCurrentPlot:SetNEOfRiver(true, eFlowNW)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)
							pSupportPlot = nil
							pUltraSupportPlot = nil

							if pCurrentPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map B1")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn + iHandicapCorrection > 0 then
							iCase = 2
						
							pCurrentPlot:SetNWOfRiver(true, eFlowNE)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)
							pUltraSupportPlot = nil

							if pCurrentPlot == nil or pSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map B2")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end	
				elseif iCase == 2 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pCurrentPlot:IsNEOfRiver() or pSupportPlot:IsWOfRiver() then	bIsMetRiver = true end
				
					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn <= 0 then
							iCase = 1
						
							pSupportPlot:SetWOfRiver(true, eFlowN)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)
							pSupportPlot = nil
							pUltraSupportPlot = nil

							if pCurrentPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map B3")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn + iHandicapCorrection > 0 then
							iCase = 3
						
							pCurrentPlot:SetNEOfRiver(true, eFlowSE)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirSE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)
							pUltraSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)

							if pCurrentPlot == nil or pSupportPlot == nil or pUltraSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map B4")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end		
				elseif iCase == 3 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pSupportPlot:IsNWOfRiver() or pUltraSupportPlot:IsWOfRiver() then bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn - iHandicapCorrection <= 0 then
							iCase = 2
						
							pSupportPlot:SetNWOfRiver(true, eFlowNE)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)
							pUltraSupportPlot = nil

							if pCurrentPlot == nil or pSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map B5")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn > 0 then
							iCase = 4
						
							pUltraSupportPlot:SetWOfRiver(true, eFlowS)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirSW)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pUltraSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)

							if pCurrentPlot == nil or pSupportPlot == nil or pUltraSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map B6")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end	
				elseif iCase == 4 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pSupportPlot:IsNEOfRiver() or pUltraSupportPlot:IsNWOfRiver() then bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn - iHandicapCorrection <= 0 then
							iCase = 3
						
							pSupportPlot:SetNEOfRiver(true, eFlowSE)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)
							pUltraSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)

							if pCurrentPlot == nil or pSupportPlot == nil or pUltraSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map B7")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn > 0 then
							iCase = 5
						
							pUltraSupportPlot:SetNWOfRiver(true, eFlowSW)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pUltraSupportPlot = nil

							if pCurrentPlot == nil or pSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map B8")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end	
				elseif iCase == 5 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pCurrentPlot:IsWOfRiver() or pSupportPlot:IsNEOfRiver() then bIsMetRiver = true end
				
					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn <= 0 then
							iCase = 4
						
							pCurrentPlot:SetWOfRiver(true, eFlowS)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirSE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pUltraSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)

							if pCurrentPlot == nil or pSupportPlot == nil or pUltraSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map B9")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn > 0 then
							iCase = 6
						
							pSupportPlot:SetNEOfRiver(true, eFlowNW)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)
							pSupportPlot = nil
							pUltraSupportPlot = nil

							if pCurrentPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map B10")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end	
				elseif iCase == 6 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pCurrentPlot:IsWOfRiver() or pCurrentPlot:IsNWOfRiver() then bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn <= 0 then
							iCase = 5
						
							pCurrentPlot:SetNWOfRiver(true, eFlowSW)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirSW)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pUltraSupportPlot = nil

							if pCurrentPlot == nil or pSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map B11")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn > 0 then
							iCase = 1
						
							pCurrentPlot:SetWOfRiver(true, eFlowN)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pSupportPlot = nil
							pUltraSupportPlot = nil

							if pCurrentPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map B12")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end	
				end
			until(bIsMetSeaOrLake or bIsMetRiver or bIsEndOfTheMap)
		else
			print("Paketu river at the end of the map X2")
		end
		
		-- SOUTHWEST RIVER (YALU)
		bIsMetRiver = false
		bIsMetSeaOrLake = false
		iAdditionalOneWayCorrection = 0

		pWPlot:SetNWOfRiver(true, eFlowSW)

		pCurrentPlot = Map.PlotDirection(pWPlot:GetX(), pWPlot:GetY(), eDirSW)
		pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
		pUltraSupportPlot = nil

		if pCurrentPlot ~= nil and pSupportPlot ~= nil then
			iCase = 5

			repeat
				if iCase == 1 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pCurrentPlot:IsNWOfRiver() or pCurrentPlot:IsNEOfRiver() then bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn - iHandicapCorrection <= 0 then
							iCase = 6
						
							pCurrentPlot:SetNEOfRiver(true, eFlowNW)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)
							pSupportPlot = nil
							pUltraSupportPlot = nil

							if pCurrentPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map C1")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn > 0 then
							iCase = 2
						
							pCurrentPlot:SetNWOfRiver(true, eFlowNE)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)
							pUltraSupportPlot = nil

							if pCurrentPlot == nil or pSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map C2")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end	
				elseif iCase == 2 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pCurrentPlot:IsNEOfRiver() or pSupportPlot:IsWOfRiver() then	bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn <= 0 then
							iCase = 1
						
							pSupportPlot:SetWOfRiver(true, eFlowN)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)
							pSupportPlot = nil
							pUltraSupportPlot = nil

							if pCurrentPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map C3")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn > 0 then
							iCase = 3
						
							pCurrentPlot:SetNEOfRiver(true, eFlowSE)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirSE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)
							pUltraSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)

							if pCurrentPlot == nil or pSupportPlot == nil or pUltraSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map C4")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end		
				elseif iCase == 3 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pSupportPlot:IsNWOfRiver() or pUltraSupportPlot:IsWOfRiver() then bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn <= 0 then
							iCase = 2
						
							pSupportPlot:SetNWOfRiver(true, eFlowNE)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)
							pUltraSupportPlot = nil

							if pCurrentPlot == nil or pSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map C5")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn + iHandicapCorrection > 0 then
							iCase = 4
						
							pUltraSupportPlot:SetWOfRiver(true, eFlowS)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirSW)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pUltraSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)

							if pCurrentPlot == nil or pSupportPlot == nil or pUltraSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map C6")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end	
				elseif iCase == 4 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pSupportPlot:IsNEOfRiver() or pUltraSupportPlot:IsNWOfRiver() then bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn <= 0 then
							iCase = 3
						
							pSupportPlot:SetNEOfRiver(true, eFlowSE)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)
							pUltraSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)

							if pCurrentPlot == nil or pSupportPlot == nil or pUltraSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map C7")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn + iHandicapCorrection > 0 then
							iCase = 5
						
							pUltraSupportPlot:SetNWOfRiver(true, eFlowSW)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirW)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pUltraSupportPlot = nil

							if pCurrentPlot == nil or pSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map C8")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end	
				elseif iCase == 5 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pCurrentPlot:IsWOfRiver() or pSupportPlot:IsNEOfRiver() then bIsMetRiver = true end
				
					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn <= 0 then
							iCase = 4
						
							pCurrentPlot:SetWOfRiver(true, eFlowS)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirSE)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pUltraSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)

							if pCurrentPlot == nil or pSupportPlot == nil or pUltraSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map C9")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn > 0 then
							iCase = 6
						
							pSupportPlot:SetNEOfRiver(true, eFlowNW)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNW)
							pSupportPlot = nil
							pUltraSupportPlot = nil

							if pCurrentPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map C10")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end	
				elseif iCase == 6 then
					if pCurrentPlot:GetPlotType() == ePlotOcean then bIsMetSeaOrLake = true	end
					if pCurrentPlot:IsWOfRiver() or pCurrentPlot:IsNWOfRiver() then bIsMetRiver = true end

					if not bIsMetSeaOrLake and not bIsMetRiver then
						iRandomRiverTurn = Game.Rand(iNormalCorrectionToMathRandom, "River turn") + 1 + iNormalCorrection + iAdditionalOneWayCorrection
					
						if iRandomRiverTurn - iHandicapCorrection <= 0 then
							iCase = 5
						
							pCurrentPlot:SetNWOfRiver(true, eFlowSW)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirSW)
							pSupportPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pUltraSupportPlot = nil

							if pCurrentPlot == nil or pSupportPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map C11")
							end

							if iAdditionalOneWayCorrection >= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection + 1
							else
								iAdditionalOneWayCorrection = 0
							end
						elseif iRandomRiverTurn > 0 then
							iCase = 1
						
							pCurrentPlot:SetWOfRiver(true, eFlowN)
						
							pCurrentPlot = Map.PlotDirection(pCurrentPlot:GetX(), pCurrentPlot:GetY(), eDirNE)
							pSupportPlot = nil
							pUltraSupportPlot = nil

							if pCurrentPlot == nil then
								bIsEndOfTheMap = true
								print("Paketu river at the end of the map C12")
							end

							if iAdditionalOneWayCorrection <= 0 then
								iAdditionalOneWayCorrection = iAdditionalOneWayCorrection - 1
							else
								iAdditionalOneWayCorrection = 0
							end
						end
					end	
				end
			until(bIsMetSeaOrLake or bIsMetRiver or bIsEndOfTheMap)
		else
			print("Paketu river at the end of the map X3")
		end


	--巨人堤
	elseif method_number == 15 then
		
		local pPlot = Map.GetPlot(x, y)
		
		pPlot:SetPlotType(ePlotOcean, false, false)
		pPlot:SetTerrainType(eTerrainCoast, false, false)
		
		-- finding suitable places for CAUSEWAY
		local tPossibleSpots = {}
		
		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			
			if pAdjacentPlot:GetPlotType() == ePlotOcean then
				pAdjacentPlot:SetTerrainType(eTerrainCoast, false, false)
			else
				table.insert(tPossibleSpots, pAdjacentPlot)
			end
		end
		
		pChosenPlot = table.remove(tPossibleSpots, Game.Rand(#tPossibleSpots, "Place B tile for Causeway") + 1)
		pChosenPlot:SetPlotType(ePlotFlat, false, false)
		pChosenPlot:SetTerrainType(eTerrainTundra, false, false)
		pChosenPlot:SetFeatureType(GameInfoTypes.FEATURE_CAUSEWAY_B)

       -- 精致拱门
      elseif method_number == 16 then
		
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

		-- 峡谷
		elseif method_number == 24 then
		
		local pPlot = Map.GetPlot(x, y)
		
		pPlot:SetPlotType(ePlotFlat, false, false)
		pPlot:SetTerrainType(eTerrainPlains, false, false)
		pPlot:SetResourceType(-1) ---消除资源

		-- setting up Plains around and cleaning Forests and Jungles
		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)

			if pAdjacentPlot:GetPlotType() ~= ePlotOcean and pAdjacentPlot:GetTerrainType() ~= eTerrainPlains then
				pAdjacentPlot:SetTerrainType(eTerrainPlains, false, false)
				
				if pAdjacentPlot:GetFeatureType() == eFeatureForest or pAdjacentPlot:GetFeatureType() == eFeatureJungle then
					pAdjacentPlot:SetFeatureType(eFeatureNo)
				end
			end
		end


		


    --科隆群岛
    elseif method_number == 9 then

	    local tOceanPlots, tCoastPlots, tPlotsAroundForResources = {}, {}, {}
		local pChosenPlot
		local pPlot = Map.GetPlot(x, y)

		pPlot:SetTerrainType(eTerrainCoast, false, false)

		for i, direction in ipairs(tDirectionTypes) do
			local pAdjacentPlot = Map.PlotDirection(x, y, direction)
			
			pAdjacentPlot:SetTerrainType(eTerrainCoast, false, false)

			if pAdjacentPlot:GetTerrainType() == eTerrainOcean then
				table.insert(tOceanPlots, pAdjacentPlot)
			elseif pAdjacentPlot:GetTerrainType() == eTerrainCoast then
				table.insert(tCoastPlots, pAdjacentPlot)
			end

			table.insert(tPlotsAroundForResources, pAdjacentPlot)
		end
		
		if #tOceanPlots > 0 then
			pChosenPlot = table.remove(tOceanPlots, Game.Rand(#tOceanPlots, "Choose ocean around Galapagos") + 1)
		elseif #tCoastPlots > 0 then
			pChosenPlot = table.remove(tCoastPlots, Game.Rand(#tCoastPlots, "Choose coast around Galapagos") + 1)
		end

		pChosenPlot:SetTerrainType(eTerrainCoast, false, false)
		pChosenPlot:SetFeatureType(GameInfoTypes.FEATURE_GALAPAGOS_B)

		for i, direction in ipairs(tDirectionTypes) do
			local pChosenX = pChosenPlot:GetX()
			local pChosenY = pChosenPlot:GetY()
			local pAdjacentPlot = Map.PlotDirection(pChosenX, pChosenY, direction)

			if pAdjacentPlot:GetX() == x and pAdjacentPlot:GetY() == y then
				-- GALAPAGOS_A
			else
				pAdjacentPlot:SetTerrainType(eTerrainCoast, false, false)
				table.insert(tPlotsAroundForResources, pAdjacentPlot)
			end
		end

		-- placing resources
		local iNumFish = 0

		repeat
			pChosenPlot = table.remove(tPlotsAroundForResources, Game.Rand(#tPlotsAroundForResources, "Choose plot for a resource around Galapagos") + 1)
			eChosenFeature = pChosenPlot:GetFeatureType()
			eChosenResource = pChosenPlot:GetResourceType()
			print(eChosenFeature, eChosenResource)
			if eChosenFeature == eFeatureNo and eChosenResource == -1 then
				pChosenPlot:SetPlotType(ePlotFlat, false, false)
				pChosenPlot:SetTerrainType(eTerrainGrass, false, false)
				pChosenPlot:SetResourceType(GameInfoTypes.RESOURCE_DEER, 1)  ---特殊资源
				iNumFish = iNumFish + 1
			end
		until(#tPlotsAroundForResources == 0 or iNumFish >= 1)
		
		if #tPlotsAroundForResources == 0 then return end

		repeat
			pChosenPlot = table.remove(tPlotsAroundForResources, Game.Rand(#tPlotsAroundForResources, "Choose plot for a resource around Galapagos") + 1)
			eChosenFeature = pChosenPlot:GetFeatureType()
			eChosenResource = pChosenPlot:GetResourceType()
			print(eChosenFeature, eChosenResource)
			if eChosenFeature == eFeatureNo and eChosenResource == -1 then
				pChosenPlot:SetResourceType(GameInfoTypes.RESOURCE_CORAL, 1) ---特殊资源
				iNumFish = iNumFish + 1
			end
		until(#tPlotsAroundForResources == 0 or iNumFish >= 3)




	-- BIOLUMINESCENT BAY
	elseif method_number == 14 then
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

    -- reserved for: Great Blue Hole
	elseif method_number == 11 then
	

	-- 丹霞
	elseif method_number == 17 then
		
		local pPlot = Map.GetPlot(x, y)
		local NEPlot = Map.PlotDirection(x, y, DirectionTypes.DIRECTION_NORTHEAST)
		local SWPlot = Map.PlotDirection(x, y, DirectionTypes.DIRECTION_SOUTHWEST)

		pPlot:SetPlotType(ePlotMountain, false, false)
		NEPlot:SetPlotType(ePlotMountain, false, false)
		SWPlot:SetPlotType(ePlotMountain, false, false)

		pPlot:SetFeatureType(GameInfoTypes.FEATURE_DANXIA)
		NEPlot:SetFeatureType(GameInfoTypes.FEATURE_DANXIA)
		SWPlot:SetFeatureType(GameInfoTypes.FEATURE_DANXIA)
		pPlot:SetResourceType(-1)	
		NEPlot:SetResourceType(-1)	
		SWPlot:SetResourceType(-1)

		for i, direction in ipairs(tDirectionTypes) do
		local pAdjacentNEPlot = Map.PlotDirection( NEPlot:GetX(), NEPlot:GetY(), direction)
		if pAdjacentNEPlot~=nil and pAdjacentNEPlot~=pPlot and pAdjacentNEPlot:GetPlotType()== ePlotMountain then
		pAdjacentNEPlot:SetPlotType(ePlotFlat, false, false)
		   end
		end

		for i, direction in ipairs(tDirectionTypes) do
		local pAdjacentSWPlot = Map.PlotDirection( SWPlot:GetX(), SWPlot:GetY(), direction)
		if pAdjacentSWPlot~=nil and pAdjacentSWPlot~=pPlot and pAdjacentSWPlot:GetPlotType()== ePlotMountain then
		pAdjacentNEPlot:SetPlotType(ePlotFlat, false, false)
		   end
		end



	-- BERMUDA TRIANGLE
	elseif method_number == 18 then
		
		local BERMUDAPlot = Map.GetPlot(x, y)
		local pSEPlot = Map.PlotDirection(x, y, DirectionTypes.DIRECTION_SOUTHEAST)
		local pSWPlot = Map.PlotDirection(x, y, DirectionTypes.DIRECTION_SOUTHWEST)

		BERMUDAPlot:SetTerrainType(eTerrainCoast, false, false)
		pSEPlot:SetTerrainType(eTerrainCoast, false, false)
		pSWPlot:SetTerrainType(eTerrainCoast, false, false)

		--pSEPlot:SetFeatureType(GameInfoTypes.FEATURE_BERMUDA_B)
		--pSWPlot:SetFeatureType(GameInfoTypes.FEATURE_BERMUDA_C)

	
     -- EYE OF THE SAHARA
     elseif method_number == 12 then
		
		local pSAHARAPlot = Map.GetPlot(x, y)
		local pSAHARASEPlot = Map.PlotDirection(x, y, DirectionTypes.DIRECTION_SOUTHEAST)
		local pSAHARASWPlot = Map.PlotDirection(x, y, DirectionTypes.DIRECTION_SOUTHWEST)

		pSAHARAPlot:SetPlotType(ePlotFlat, false, false)
		pSAHARASEPlot:SetPlotType(ePlotFlat, false, false)
		pSAHARASWPlot:SetPlotType(ePlotFlat, false, false)
		pSAHARAPlot:SetTerrainType(eTerrainDesert, false, false)
		pSAHARASEPlot:SetTerrainType(eTerrainDesert, false, false)
		pSAHARASWPlot:SetTerrainType(eTerrainDesert, false, false)

		--pSAHARASEPlot:SetFeatureType(GameInfoTypes.FEATURE_EYE_OF_SAHARA_B)
		---pSAHARASWPlot:SetFeatureType(GameInfoTypes.FEATURE_EYE_OF_SAHARA_C)
		--pSAHARASEPlot:SetResourceType(-1)	
		--pSAHARASWPlot:SetResourceType(-1)		

	end
end
------------------------------------------------------------------------------
