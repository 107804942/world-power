
iTerrain_Types = {};
iFeature_Types = {};
TerrainExecludes = {};
FeatureExecludes = {};
iPlot_Hill = 0;
Flat_Land = false;
Only_Hills = false;
Max_Latitude = -1;

function ResetAllowedPlotTypes()

-- Value=0 means the type is disabled, the values will be set later according to the xml file.

-- Terrain types:
iTerrain_Types = {	Grass = 0,
					Plains = 0,
					Desert = 0,
					Tundra = 0,
					Snow = 0,
					Coast = 0,
					Ocean = 0,
				};

-- Feature types:
iFeature_Types = {	Oasis = 0,
					Flood_Plains = 0,
					Forest = 0,
					Jungle = 0,
					Marsh = 0,
				};

iPlot_Hill = 0;

Flat_Land = false;
Only_Hills = false;
TerrainExecludes = {};
FeatureExecludes = {};
Max_Latitude = -1;
end


-- Terrain types:

function GetAllowedPlotTypes(iRes_Type , ExecludesTable)

	local pTerrain;
	local pFeature;

	ResetAllowedPlotTypes();

	-- The allowed terrain and feature types are set from the xml file, so if you want to change allowed types change in xml not here.
	for pTerrain in GameInfo.Resource_TerrainBooleans() do
		if pTerrain.ResourceType == iRes_Type then
			if pTerrain.TerrainType == "TERRAIN_GRASS" then
				iTerrain_Types.Grass = 1;
			elseif pTerrain.TerrainType == "TERRAIN_PLAINS" then
				iTerrain_Types.Plains = 1;
			elseif pTerrain.TerrainType == "TERRAIN_DESERT" then
				iTerrain_Types.Desert = 1;
			elseif pTerrain.TerrainType == "TERRAIN_TUNDRA" then
				iTerrain_Types.Tundra = 1;
			elseif pTerrain.TerrainType == "TERRAIN_SNOW" then
				iTerrain_Types.Snow = 1;
			elseif pTerrain.TerrainType == "TERRAIN_COAST" then
				iTerrain_Types.Coast = 1;	
			elseif pTerrain.TerrainType == "TERRAIN_OCEAN" then
				iTerrain_Types.Ocean = 1;	
			elseif pTerrain.TerrainType == "TERRAIN_HILL" then
				iPlot_Hill = 1;
			end
		end

	end

	for pFeature in GameInfo.Resource_FeatureBooleans() do
		if pFeature.ResourceType == iRes_Type then
			if pFeature.FeatureType == "FEATURE_OASIS" then
				iFeature_Types.Oasis = 1;
			elseif pFeature.FeatureType == "FEATURE_FLOOD_PLAINS" then
				iFeature_Types.Flood_Plains = 1;
			elseif pFeature.FeatureType == "FEATURE_FOREST" then
				iFeature_Types.Forest = 1;
			elseif pFeature.FeatureType == "FEATURE_JUNGLE" then
				iFeature_Types.Jungle = 1;
			elseif pFeature.FeatureType == "FEATURE_MARSH" then
				iFeature_Types.Marsh = 1;
			end
		end
	end

	-- Other Conditions:
	Only_Hills = GameInfo.Resources[iRes_Type].Hills;
	Flat_Land = GameInfo.Resources[iRes_Type].Flatlands;
	Max_Latitude = GameInfo.Resources[iRes_Type].MaxLatitude;
	--- Terrain And Feature Execludes:
	if ExecludesTable ~= nil then
		if type(ExecludesTable) == "table" then
			Z = #ExecludesTable;
			for i=1,Z do
				-- Terrain Execludes
				if ExecludesTable[i] == "TERRAIN_GRASS" then
					TerrainExecludes[GameInfo.Terrains["TERRAIN_GRASS"].ID] = 1;
				elseif ExecludesTable[i] == "TERRAIN_PLAINS" then
					TerrainExecludes[GameInfo.Terrains["TERRAIN_PLAINS"].ID] = 1;
				elseif ExecludesTable[i] == "TERRAIN_DESERT" then
					TerrainExecludes[GameInfo.Terrains["TERRAIN_DESERT"].ID] = 1;
				elseif ExecludesTable[i] == "TERRAIN_TUNDRA" then
					TerrainExecludes[GameInfo.Terrains["TERRAIN_TUNDRA"].ID] = 1;
				elseif ExecludesTable[i] == "TERRAIN_SNOW" then
					TerrainExecludes[GameInfo.Terrains["TERRAIN_SNOW"].ID] = 1;
				elseif ExecludesTable[i] == "TERRAIN_COAST" then
					TerrainExecludes[GameInfo.Terrains["TERRAIN_COAST"].ID] = 1;
				elseif ExecludesTable[i] == "TERRAIN_OCEAN" then
					TerrainExecludes[GameInfo.Terrains["TERRAIN_OCEAN"].ID] = 1;

				-- Features Execludes
				elseif ExecludesTable[i] == "FEATURE_OASIS" then
					FeatureExecludes[GameInfo.Features["FEATURE_OASIS"].ID] = 1;
				elseif ExecludesTable[i] == "FEATURE_FLOOD_PLAINS" then
					FeatureExecludes[GameInfo.Features["FEATURE_FLOOD_PLAINS"].ID] = 1;
				elseif ExecludesTable[i] == "FEATURE_FOREST" then
					FeatureExecludes[GameInfo.Features["FEATURE_FOREST"].ID] = 1;
				elseif ExecludesTable[i] == "FEATURE_JUNGLE" then
					FeatureExecludes[GameInfo.Features["FEATURE_JUNGLE"].ID] = 1;
				elseif ExecludesTable[i] == "FEATURE_MARSH" then
					FeatureExecludes[GameInfo.Features["FEATURE_MARSH"].ID] = 1;
				end
			end

		else
			print("Defined Terrain & Feature Execludes are ignored... (Must be a table format)");
		end
	end


end


--===================================================================

function isSuitable_Plot_Check( pPlot)

	--First Check Max Latitude:
	if pPlot:GetLatitude() > Max_Latitude then
		return false;
	end

	--========================== Main Suitable Plot Function ==========================
	local iTerrain = pPlot:GetTerrainType();
	local iFeature = pPlot:GetFeatureType();
	local pPlotType = pPlot:GetPlotType()
	--[[ this is simply a switch on or off operation, depending on defined 0 or 1 conditions in iTerrain_Types and iFeature_Types
	   the conditions are evaluated in this way:
	   if type_id * Condition == type_id then ... (condition is 0 or 1)
	   Exmaple: if Grass = 0 in iTerrain_Types then the condition for grass will be:
	            if iTerrain * 0 == TerrainTypes.TERRAIN_GRASS then ...the value will be 0 and the result will be false
	   +1 was added to all IDs to avoid problem when ID=0 where 0*0 = 0 gives wrong condition result 
	--]]

	if pPlot:GetResourceType(-1) == -1 and not pPlot:IsImpassable() and not pPlot:IsCity() and not pPlot:IsGoody()  
	and not pPlot:HasAnyNaturalWonder()   then

		if  (iTerrain +1) * iTerrain_Types.Grass == TerrainTypes.TERRAIN_GRASS +1 or
			(iTerrain +1) * iTerrain_Types.Plains == TerrainTypes.TERRAIN_PLAINS +1 or
			(iTerrain +1) * iTerrain_Types.Desert == TerrainTypes.TERRAIN_DESERT +1 or
			(iTerrain +1) * iTerrain_Types.Tundra == TerrainTypes.TERRAIN_TUNDRA +1 or
			(iTerrain +1) * iTerrain_Types.Snow == TerrainTypes.TERRAIN_SNOW +1 or
			(iTerrain +1) * iTerrain_Types.Coast == TerrainTypes.TERRAIN_COAST +1 or
			(iTerrain +1) * iTerrain_Types.Ocean == TerrainTypes.TERRAIN_OCEAN +1 or
			-- now features
			(iFeature +1) * iFeature_Types.Oasis == FeatureTypes.FEATURE_OASIS +1 or
			(iFeature +1) * iFeature_Types.Flood_Plains == FeatureTypes.FEATURE_FLOOD_PLAINS +1 or
			(iFeature +1) * iFeature_Types.Forest == FeatureTypes.FEATURE_FOREST +1 or
			(iFeature +1) * iFeature_Types.Jungle == FeatureTypes.FEATURE_JUNGLE +1 or
			(iFeature +1) * iFeature_Types.Marsh == FeatureTypes.FEATURE_MARSH +1 or
			-- Hill condition
			(pPlotType +1) * iPlot_Hill == PlotTypes.PLOT_HILLS +1 then
			-- Now check the Execludes
			if TerrainExecludes[iTerrain] ~= 1 and FeatureExecludes[iFeature] ~= 1 then
				-- Only Flat Land Condition
				if Flat_Land and pPlot:IsFlatlands() then
					return true;
				elseif Flat_Land and not pPlot:IsFlatlands() then
					return false;
				end
				-- Only Hills Condition
				if Only_Hills and pPlot:IsHills() then
					return true;
				elseif Only_Hills and not pPlot:IsHills() then
					return false;
				end
				-- All other conditions were checked-> return true
				return true;
			else
				return false;
			end
		end	
	end
	return false;
end
--===================================================================

function Shuffle_Function(n1,n2)

	-- This function shuffles a series of values between n1 and n2.
	-- Example n1=1,n2=5 , Series={1,2,3,4,5] , shuffled example={2,4,5,1,3]
	local N = {};
	local Shuffled_N = {};
	local L;
	local a;
	local t;

	if n2>n1 then
		t = n1;
	elseif n2<n1 then
		t = n2;
	elseif n2==n1 then
		N[1] = n1;
		return N;
	end 

	for i= 1, math.abs(n2-n1)+1 do
		N[i] = i+t-1;
	end
	
	L = math.abs(n2-n1)+1;
	for i=1,math.abs(n2-n1)+1 do			
		a = math.random(L);
		Shuffled_N[i] = N[a];
		if a < L then
			N[a] = N[L];
		end
		L = L - 1;		
	end
	
	return Shuffled_N;

end

