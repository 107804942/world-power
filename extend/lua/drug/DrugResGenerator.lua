
include("DrugResGeneratorFunctions.lua");





function IsUsingTNLWORLD()
	local TNLWORLDID = "4e394966-aec9-4473-807f-0ddf8c1dddc1"
	for _, mod in pairs(Modding.GetActivatedMods()) do
		if (mod.ID == TNLWORLDID) then
			return true
		end
	end
	return false
end


local TNLWORLDModActive = IsUsingTNLWORLD()


-- ====================== Regions Boundaries ========================.
-- The map will be divided into regions of equal areas, Minimum Number of Regions = 1, Max Number of Regions = 320. 
-- Each resource is distributed by 1 resource per region, so that nomber of regions = number of resources to distribute.
-- Let K = nomber of divisions, the map is divided into K equal rectangular areas represented by R = rectangle (x1,y1,x2,y2) 
--[[ Boundaries_table = { K1 : R1 
							K2 : R1,R2
							.     .
							.     .
							Kn : R1,R2,..,Rn
--]]

-- values in boundary tables are ratios of Xmax,Ymax. (example: map size=20x20 , boundery(0,0,1/2,1) = rectangle[ (0,0)-(10,20) ]

local Boundaries_Table = {};  -- 3 dimensional array

-- The following bounddaries represent the optimal solution to divide a rectangle in K divisions of equal areas,
-- althoug there are many ways to divide a rectangle but no need to modify this beacuse this is the optimal solution.
-- For K = 1
Boundaries_Table[1] = { {0,0,1,1} };
-- For K = 2
Boundaries_Table[2] = { {0,0,1/2,1} , {1/2,0,1,1} };
-- For K = 3
Boundaries_Table[3] = {	{0,0,1,1/3} , {0,1/3,1/2,1} , {1/2,1/3,1,1} };
-- For K = 4
Boundaries_Table[4] = {	{0,0,1/2,1/2} , {1/2,0,1,1/2} , {0,1/2,1/2,1} , {1/2,1/2,1,1} };
-- For K = 5
Boundaries_Table[5] = {	{0,0,1/2,2/5} , {1/2,0,1,2/5} , {0,2/5,1/3,1} , {1/3,2/5,1,7/10} ,
						{1/3,7/10,1,1} };
-- For K = 6
Boundaries_Table[6] = {	{0,0,1/3,1/2} , {1/3,0,2/3,1/2} , {2/3,0,1,1/2} , {0,1/2,1/3,1} ,
						{1/3,1/2,2/3,1} , {2/3,1/2,1,1} };
-- For K = 7
Boundaries_Table[7] = {	{0,0,5/14,2/5} , {5/14,0,5/7,2/5} , {5/7,0,1,1/2} , {0,2/5,5/21,1} ,
						{5/21,2/5,5/7,7/10} , {5/21,7/10,5/7,1} , {5/7,1/2,1,1} };
-- For K = 8
Boundaries_Table[8] = {	{0,0,3/8,1/3} , {3/8,0,3/4,1/3} , {3/4,0,1,1/2} , {0,1/3,3/8,2/3} ,
						{3/8,1/3,3/4,2/3} , {0,2/3,3/8,1} , {3/8,2/3,3/4,1} , {3/4,1/2,1,1} };
-- For K = 9
Boundaries_Table[9] = {	{0,0,1/3,1/3} , {1/3,0,2/3,1/3} , {2/3,0,1,1/3} , {0,1/3,1/3,2/3} ,
						{1/3,1/3,2/3,2/3} , {2/3,1/3,1,2/3} , {0,2/3,1/3,1} , {1/3,2/3,2/3,1} ,
						{2/3,2/3,1,1} };

-- For K = 10 to K = 320
-- Higher level boundaries are construted from lower level boundaries for example:
-- [K=10] = [K=5][k=5]  divide map by 2 then divide each half by 5
-- [k=20] = [k=10][k=10]
-- [k=37] = [k=18][k=19]
-- and so on..
-- I cant explain the method below in in details just take it as it is.

local x1=0;
local y1=0;
local x2=0;
local y2=0;
local v1=0;
local v2=0;
local K; -- number of divisions
local select_axis = 1;  -- 1: x_axis , 2: y_axis
local i;
local A;
local B;

for K = 10,320 do
	Boundaries_Table[K] = {};
	if (K % 2) == 0 then
		A = K/2;
		B = A;
	else
		A = (K-1)/2;
		B = A+1;
	end
	for i=1,A do
		x1 = Boundaries_Table[A][i][1];
		y1 = Boundaries_Table[A][i][2];
		x2 = Boundaries_Table[A][i][3];
		y2 = Boundaries_Table[A][i][4];
		table.insert(Boundaries_Table[K], {x1,y1,x2,y2});
	end
	for i=A+1,K do
		x1 = Boundaries_Table[B][i-A][1];
		y1 = Boundaries_Table[B][i-A][2];
		x2 = Boundaries_Table[B][i-A][3];
		y2 = Boundaries_Table[B][i-A][4];
		table.insert(Boundaries_Table[K], {x1,y1,x2,y2});
	end
	-- For the following ranges the halving is switched between X_axis and Y_axis to avoid very narrow regions.
	if K>=10 and K<=20 then 
		select_axis = 1;	         -- Halving on X axis
	elseif K>=21 and K<=40 then	
		select_axis = 2;             -- Halving on Y axis
	elseif K>=41 and K<=80 then 
		select_axis = 1;             -- Halving on X axis
	elseif K>=81 and K<=160 then    
		select_axis = 2;             -- Halving on Y axis
	elseif K>=161 and K<=320 then
		select_axis = 1;			 -- Halving on X axis
	end

	for i=1,K do
	    -- Dividion is not by 1/2 but by A/K to cover situations when K is odd
		if i<=A then
			v1= Boundaries_Table[K][i][select_axis] * (A/K);     -- IF X_Axis: select_axis=1 , select_axis+2=3 => 1,3 are indexes for x1,x2
			v2= Boundaries_Table[K][i][select_axis+2] * (A/K);   -- IF Y_Axis: select_axis=2 , select_axis+2=4 => 2,4 are indexes for y1,y2
			Boundaries_Table[K][i][select_axis] = v1;				
			Boundaries_Table[K][i][select_axis+2] = v2;
		else
			v1 = (A/K) + (Boundaries_Table[K][i][select_axis] * (B/K));
			v2 = (A/K) + (Boundaries_Table[K][i][select_axis+2] * (B/K));
			Boundaries_Table[K][i][select_axis] = v1;    
			Boundaries_Table[K][i][select_axis+2] = v2;
		end
	end

end

--======================== Main Function ============================
--======================== 无真实世界 ============================



function OnMapResourceGenerator(New_ResourceType , ExecludesTable )
	 if not TNLWORLDModActive then
	print("Resource Generator V2.0");
	print("-----------------------");

	--Get Resource Class and ID:
	local iResourceFound = false;
	local New_Resource_ID;
	local New_Resource_Class;
	for m_Resource in GameInfo.Resources() do
		if m_Resource.Type == New_ResourceType then 
			New_Resource_ID = m_Resource.ID;
			New_Resource_Class = m_Resource.ResourceClassType;
			iResourceFound = true;
		end
	end
	-- Error handling 
	if iResourceFound == false then
		print("Resource type (" .. New_ResourceType .. ") was not found! check resource type in xml file.. script aborted");
		return;
	end
	-- Grid and Map area
	local Xmax, Ymax = Map.GetGridSize();
	local iMapArea = Xmax*Ymax;

	------------------------ Resource Quantity ---------------------------------
	
	local iQuantity;

	--[[ Base Quantity:

		 A) For Luxury Resources:
			From statistics the formula for Luxury Resources Quantity = 0.0008*iMapArea + 2
	
		 B) For Bonus Resources:
			From statistics the formula for Bonus Resources Quantity = 0.0046*iMapArea + 1

		 C) For Strategic Resources:
			from statistics the formula for Strategic Resources Quantity = 0.019*iMapArea + 9
	--]]


	if New_Resource_Class == "RESOURCECLASS_LUXURY" then	-- Luxury Resources			
		iQuantity =  0.0008*iMapArea + 2 ;
	elseif New_Resource_Class == "RESOURCECLASS_BONUS" then	-- Bonus Resources
		iQuantity =  0.004*iMapArea + 1;
	elseif New_Resource_Class == "RESOURCECLASS_RUSH" or New_Resource_Class == "RESOURCECLASS_MODERN" then	--Strategic Resources			
		iQuantity =  0.010*iMapArea + 9;
	else
		-- Error handling
		print("Error: Unkown Resource Class (" .. New_Resource_Class .. ") ! please check ResourceClassType in custom resource xml file ... script aborted");
		return;
	end

	--[[ Resource Options:								------- Modifiers -------	
							OptionName			Value	Luxury	Strtg.	Bonus
							Sparse				1		0.75	0.75	0.75
							Standard			2		1		1		1
							Abundant			3		1.2		1.5		1.2
							Legendary Start		4		1.1		1		1.1				
							Strategic Balance	5		1		1.2		1
							Random				6
	--]]
	--Note: These values are taken from in game statistics

	local resource_option = PreGame.GetMapOption(5);   --PreGame.GetMapOption(option.ID) , option.ID for resources option = 5
	local option_modifier;

	if resource_option == 6 then
		resource_option = math.random(5);
	end

	if New_Resource_Class == "RESOURCECLASS_LUXURY" then
		if resource_option == 1 then option_modifier = 0.75;
		elseif resource_option == 2 then option_modifier = 1;
		elseif resource_option == 3 then option_modifier = 1.2; 
		elseif resource_option == 4 then option_modifier = 1.1;
		elseif resource_option == 5 then option_modifier = 1;
		end
	elseif New_Resource_Class == "RESOURCECLASS_RUSH" or New_Resource_Class == "RESOURCECLASS_MODERN" then
		if resource_option == 1 then option_modifier = 0.75;
		elseif resource_option == 2 then option_modifier = 1;
		elseif resource_option == 3 then option_modifier = 1.5; 
		elseif resource_option == 4 then option_modifier = 1;
		elseif resource_option == 5 then option_modifier = 1.2;
		end
	elseif New_Resource_Class == "RESOURCECLASS_BONUS" then
		if resource_option == 1 then option_modifier = 0.75;
		elseif resource_option == 2 then option_modifier = 1;
		elseif resource_option == 3 then option_modifier = 1.2; 
		elseif resource_option == 4 then option_modifier = 1.1;
		elseif resource_option == 5 then option_modifier = 1;
		end
	end
	
	--[[ Nomber of Civs modifier:

		 Quantity is increased with more civs in the game, the forumla from statistics is:

		 -For Luxury and Bonus Resources:   modifier = 1 + 0.03*NomberOfCivs

		 -For Strategic Resources:          modifier = 1 + 0.03*NomberOfCivs (when option="Strategic Balance")
		  (strategic resources are only affected by NomberOfCivs when strategic balance option is selected)
	--]]

	local NumCivs_modifier;
	local civs_number = Game.CountCivPlayersAlive() - PreGame.GetNumMinorCivs() ; 
	
	if New_Resource_Class == "RESOURCECLASS_RUSH" or New_Resource_Class == "RESOURCECLASS_MODERN" then
		if resource_option == 5 then
			NumCivs_modifier = 1 + (0.03*civs_number);
		else
			NumCivs_modifier =1;
		end
	else
		NumCivs_modifier = 1 + (0.03*civs_number);
	end
	
	-- Now multiply quantity with modifiers
	iQuantity = iQuantity * option_modifier *NumCivs_modifier;

	-- Now ceil function to get integer quantity value:
	iQuantity = math.ceil( iQuantity );

	--[[ Strategic Quantity Types:
		 If strategic resource then distribute the quantity according to Resource_QuantityTypes in xml file.
		 iQuantityTypes: this table will be used to store all quantity types for a resource (example: for iron iQuantityTypes={2,6})
		 Strategic_Distribution: this table will be used to store randomly generated quantities from quantity types 
		                         (example: for iron Strategic_Distribution={2,6,6,2,2,2,6,2,6,6, ... etc))
	--]]
	
	local iQuantityTypes = {};    
	local Strategic_Distribution = {}; 
	local L=0;
	local N;
	local Quantity_Left;

	if New_Resource_Class == "RESOURCECLASS_RUSH" or New_Resource_Class == "RESOURCECLASS_MODERN" then

		for iRow in GameInfo.Resource_QuantityTypes() do
			if iRow.ResourceType == New_ResourceType then
				table.insert(iQuantityTypes,iRow.Quantity);
			end
		end

		L = #iQuantityTypes;

		if L==1 then  -- if only one quantity type then just quantity/quantity_type

			iQuantity =  math.ceil(iQuantity / iQuantityTypes[1]);

		else  -- else alternate distribution randomly between quantity types

			Quantity_Left = iQuantity;
			 
			while Quantity_Left > 0 do
				N = iQuantityTypes[math.random(L)]; 
				if (Quantity_Left - N)<0 then N=Quantity_Left; end   --when go in minus put remaining quantity
				table.insert( Strategic_Distribution , N );
				Quantity_Left = Quantity_Left - N;
			end

			iQuantity = #Strategic_Distribution;  --Number of resources to place on map = number of elements in Strategic_Distribution
		
		end

	end

	--Last Step - Max Limit: Maximum number of resources allowed on any map = 320 
	if iQuantity > 320 then 
		iQuantity = 320;     -- Warning: dont change max limit because it will conflict with regions calculations.
	end

	if iQuantity == 0 then	-- if 0 resources then exit the script no need to continue
		print("Quantity=0 , No resources were placed");
		return;
	end 

	print(New_ResourceType .. " Quantity to distribut = " .. iQuantity);

	--======================= Distributing Resource on the map =======================

	local iPlot;
	local Rx = {}; -- random x after shuffling x grid
	local Ry = {}; -- random y after shuffling y grid
	local is_Done = false;

	K = iQuantity; --  #reigions = #Resources

	-- Get all allowed terrain types and feature types for the resource:
	GetAllowedPlotTypes(New_ResourceType , ExecludesTable);

	-- Main loop
	local test_sum=0;
	local test_q=0;
	if K>0 then
		for i = 1,K do
			is_Done = false;
			x1 = 1+ math.floor ( (Xmax-1) * Boundaries_Table[K][i][1] );
			y1 = 1+ math.floor ( (Ymax-1) * Boundaries_Table[K][i][2] );
			x2 = math.floor ( (Xmax-1) * Boundaries_Table[K][i][3] );
			y2 = math.floor ( (Ymax-1) * Boundaries_Table[K][i][4] );
			Rx = Shuffle_Function(x1,x2);   --Random x axis series
			Ry = Shuffle_Function(y1,y2);   --Random y axis series

			for x= 1,(x2-x1+1) do 
				for y= 1,(y2-y1+1) do
					iPlot = Map.GetPlot(Rx[x], Ry[y]);
					--check terrains,feautures ,,, etc then set the resource:
					is_Done = isSuitable_Plot_Check( iPlot);
					if is_Done then
						if New_Resource_Class == "RESOURCECLASS_RUSH" or New_Resource_Class == "RESOURCECLASS_MODERN" then
							N = Strategic_Distribution[i];   -- if strategic then get quantity to place
						else
							N = 1;
						end
						-- Resource placed at plot
						iPlot:SetResourceType(New_Resource_ID, N);
						print(N .. " " .. New_ResourceType .. " Placed at X,Y = " .. Rx[x] .. "," .. Ry[y]);
						test_sum = test_sum + 1;
						test_q = test_q + N;
						break;
					end
				end
				if is_Done then break; end
			end
		  end
	   end
	end




	if  TNLWORLDModActive  then
	print("Resource Generator V2.0");
	print("-----------------------");

	--Get Resource Class and ID:
	local iResourceFound = false;
	local New_Resource_ID;
	local New_Resource_Class;
	for m_Resource in GameInfo.Resources() do
		if m_Resource.Type == New_ResourceType then 
			New_Resource_ID = m_Resource.ID;
			New_Resource_Class = m_Resource.ResourceClassType;
			iResourceFound = true;
		end
	end
	-- Error handling 
	if iResourceFound == false then
		print("Resource type (" .. New_ResourceType .. ") was not found! check resource type in xml file.. script aborted");
		return;
	end
	-- Grid and Map area
	local Xmax, Ymax = Map.GetGridSize();
	local iMapArea = Xmax*Ymax;

	------------------------ Resource Quantity ---------------------------------
	
	local iQuantity;

	--[[ Base Quantity:

		 A) For Luxury Resources:
			From statistics the formula for Luxury Resources Quantity = 0.0008*iMapArea + 2
	
		 B) For Bonus Resources:
			From statistics the formula for Bonus Resources Quantity = 0.0046*iMapArea + 1

		 C) For Strategic Resources:
			from statistics the formula for Strategic Resources Quantity = 0.019*iMapArea + 9
	--]]


	if New_Resource_Class == "RESOURCECLASS_LUXURY" then	-- Luxury Resources			
		iQuantity =  0.0008*iMapArea + 2 ;
	elseif New_Resource_Class == "RESOURCECLASS_BONUS" then	-- Bonus Resources
		iQuantity =  0.0035*iMapArea + 1;
	elseif New_Resource_Class == "RESOURCECLASS_RUSH" or New_Resource_Class == "RESOURCECLASS_MODERN" then	--Strategic Resources			
		iQuantity =  0.010*iMapArea + 9;
	else
		-- Error handling
		print("Error: Unkown Resource Class (" .. New_Resource_Class .. ") ! please check ResourceClassType in custom resource xml file ... script aborted");
		return;
	end

	--[[ Resource Options:								------- Modifiers -------	
							OptionName			Value	Luxury	Strtg.	Bonus
							Sparse				1		0.75	0.75	0.75
							Standard			2		1		1		1
							Abundant			3		1.2		1.5		1.2
							Legendary Start		4		1.1		1		1.1				
							Strategic Balance	5		1		1.2		1
							Random				6
	--]]
	--Note: These values are taken from in game statistics

	local resource_option = 5;   --PreGame.GetMapOption(option.ID) , option.ID for resources option = 5
	local option_modifier;

	if resource_option == 5 then
		resource_option = 5;
	end

	if New_Resource_Class == "RESOURCECLASS_LUXURY" then
		if resource_option == 5 then option_modifier = 1;
		--elseif resource_option == 2 then option_modifier = 1;
		--elseif resource_option == 3 then option_modifier = 1.2; 
		--elseif resource_option == 4 then option_modifier = 1.1;
		--elseif resource_option == 5 then option_modifier = 1;
		end
	elseif New_Resource_Class == "RESOURCECLASS_RUSH" or New_Resource_Class == "RESOURCECLASS_MODERN" then
		if resource_option == 5 then option_modifier = 1.5;
		--elseif resource_option == 2 then option_modifier = 1;
		--elseif resource_option == 3 then option_modifier = 1.5; 
		--elseif resource_option == 4 then option_modifier = 1;
		--elseif resource_option == 5 then option_modifier = 1.2;
		end
	elseif New_Resource_Class == "RESOURCECLASS_BONUS" then
		if resource_option == 5 then option_modifier = 0.75;
		--elseif resource_option == 2 then option_modifier = 1;
		--elseif resource_option == 3 then option_modifier = 1.2; 
		--elseif resource_option == 4 then option_modifier = 1.1;
		--elseif resource_option == 5 then option_modifier = 1;
		end
	end
	
	--[[ Nomber of Civs modifier:

		 Quantity is increased with more civs in the game, the forumla from statistics is:

		 -For Luxury and Bonus Resources:   modifier = 1 + 0.03*NomberOfCivs

		 -For Strategic Resources:          modifier = 1 + 0.03*NomberOfCivs (when option="Strategic Balance")
		  (strategic resources are only affected by NomberOfCivs when strategic balance option is selected)
	--]]

	local NumCivs_modifier;
	local civs_number = Game.CountCivPlayersAlive() - PreGame.GetNumMinorCivs() ; 
	
	if New_Resource_Class == "RESOURCECLASS_RUSH" or New_Resource_Class == "RESOURCECLASS_MODERN" then
		if resource_option == 5 then
			NumCivs_modifier = 1 + (0.03*civs_number);
		else
			NumCivs_modifier =1;
		end
	else
		NumCivs_modifier = 1 + (0.03*civs_number);
	end
	
	-- Now multiply quantity with modifiers
	iQuantity = iQuantity * option_modifier *NumCivs_modifier;

	-- Now ceil function to get integer quantity value:
	iQuantity = math.ceil( iQuantity );

	--[[ Strategic Quantity Types:
		 If strategic resource then distribute the quantity according to Resource_QuantityTypes in xml file.
		 iQuantityTypes: this table will be used to store all quantity types for a resource (example: for iron iQuantityTypes={2,6})
		 Strategic_Distribution: this table will be used to store randomly generated quantities from quantity types 
		                         (example: for iron Strategic_Distribution={2,6,6,2,2,2,6,2,6,6, ... etc))
	--]]
	
	local iQuantityTypes = {};    
	local Strategic_Distribution = {}; 
	local L=0;
	local N;
	local Quantity_Left;

	if New_Resource_Class == "RESOURCECLASS_RUSH" or New_Resource_Class == "RESOURCECLASS_MODERN" then

		for iRow in GameInfo.Resource_QuantityTypes() do
			if iRow.ResourceType == New_ResourceType then
				table.insert(iQuantityTypes,iRow.Quantity);
			end
		end

		L = #iQuantityTypes;

		if L==1 then  -- if only one quantity type then just quantity/quantity_type

			iQuantity =  math.ceil(iQuantity / iQuantityTypes[1]);

		else  -- else alternate distribution randomly between quantity types

			Quantity_Left = iQuantity;
			 
			while Quantity_Left > 0 do
				N = iQuantityTypes[math.random(L)]; 
				if (Quantity_Left - N)<0 then N=Quantity_Left; end   --when go in minus put remaining quantity
				table.insert( Strategic_Distribution , N );
				Quantity_Left = Quantity_Left - N;
			end

			iQuantity = #Strategic_Distribution;  --Number of resources to place on map = number of elements in Strategic_Distribution
		
		end

	end

	--Last Step - Max Limit: Maximum number of resources allowed on any map = 320 
	if iQuantity > 320 then 
		iQuantity = 320;     -- Warning: dont change max limit because it will conflict with regions calculations.
	end

	if iQuantity == 0 then	-- if 0 resources then exit the script no need to continue
		print("Quantity=0 , No resources were placed");
		return;
	end 

	print(New_ResourceType .. " Quantity to distribut = " .. iQuantity);

	--======================= Distributing Resource on the map =======================

	local iPlot;
	local Rx = {}; -- random x after shuffling x grid
	local Ry = {}; -- random y after shuffling y grid
	local is_Done = false;

	K = iQuantity; --  #reigions = #Resources

	-- Get all allowed terrain types and feature types for the resource:
	GetAllowedPlotTypes(New_ResourceType , ExecludesTable);

	-- Main loop
	local test_sum=0;
	local test_q=0;
	if K>0 then
		for i = 1,K do
			is_Done = false;
			x1 = 1+ math.floor ( (Xmax-1) * Boundaries_Table[K][i][1] );
			y1 = 1+ math.floor ( (Ymax-1) * Boundaries_Table[K][i][2] );
			x2 = math.floor ( (Xmax-1) * Boundaries_Table[K][i][3] );
			y2 = math.floor ( (Ymax-1) * Boundaries_Table[K][i][4] );
			Rx = Shuffle_Function(x1,x2);   --Random x axis series
			Ry = Shuffle_Function(y1,y2);   --Random y axis series

			for x= 1,(x2-x1+1) do 
				for y= 1,(y2-y1+1) do
					iPlot = Map.GetPlot(Rx[x], Ry[y]);
					--check terrains,feautures ,,, etc then set the resource:
					is_Done = isSuitable_Plot_Check( iPlot);
					if is_Done then
						if New_Resource_Class == "RESOURCECLASS_RUSH" or New_Resource_Class == "RESOURCECLASS_MODERN" then
							N = Strategic_Distribution[i];   -- if strategic then get quantity to place
						else
							N = 1;
						end
						-- Resource placed at plot
						iPlot:SetResourceType(New_Resource_ID, N);
						print(N .. " " .. New_ResourceType .. " Placed at X,Y = " .. Rx[x] .. "," .. Ry[y]);
						test_sum = test_sum + 1;
						test_q = test_q + N;
						break;
					end
				end
				if is_Done then break; end
			end
		end
	end
	print("----------------------------------------------------");
	print("Total " .. New_ResourceType .. " Placed = " .. test_sum);
	print("Quantity " .. New_ResourceType .. " Placed = " .. test_q);
	print("----------------------------------------------------");
end
end








