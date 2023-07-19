print("This is the modded TechButtonInclude from 'UI - Tech Enhancement Icons'")

-------------------------------------------------
-- Include file that has handy stuff for the tech tree and other screens that need to show a tech button
-------------------------------------------------
include( "IconSupport" );
include( "InfoTooltipInclude" );

--
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--
-- Mods to support Tech Enhancement specific icons
--

-- Do we have the TechEnhancementIcons table (and by implication the extensions to the Improvements, Routes and Domains tables)
local bTechEnhIcons = false
for row in DB.Query("SELECT name FROM sqlite_master WHERE type='table' AND name='TechEnhancementIcons'") do
	bTechEnhIcons = true
end

-- Construct the list of Tech Enhancement Icons ...
local TechEnhancementIcons
if (bTechEnhIcons) then
	-- ... either from the database table
	TechEnhancementIcons = {}
	for row in DB.Query("SELECT * FROM TechEnhancementIcons") do
		table.insert(TechEnhancementIcons, row)
	end
else
	-- ... or from a list of known enhancements (using the same format as the database table)
	TechEnhancementIcons = {
		{Enhancement="EmbarkedMoveChange",              Tip="TXT_KEY_FASTER_EMBARKED_MOVEMENT",             BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="AllowsEmbarking",                 Tip="TXT_KEY_ALLOWS_EMBARKING",                     BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="AllowsDefensiveEmbarking",        Tip="TXT_KEY_ABLTY_DEFENSIVE_EMBARK_STRING",        BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="EmbarkedAllWaterPassage",         Tip="TXT_KEY_ALLOWS_CROSSING_OCEANS",               BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="UnitFortificationModifier",       Tip="TXT_KEY_UNIT_FORTIFICATION_MOD",     Param=1,  BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="UnitBaseHealModifier",            Tip="TXT_KEY_UNIT_BASE_HEAL_MOD",         Param=1,  BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="AllowEmbassyTradingAllowed",      Tip="TXT_KEY_ALLOWS_EMBASSY",                       BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="OpenBordersTradingAllowed",       Tip="TXT_KEY_ALLOWS_OPEN_BORDERS",                  BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="DefensivePactTradingAllowed",     Tip="TXT_KEY_ALLOWS_DEFENSIVE_PACTS",               BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="ResearchAgreementTradingAllowed", Tip="TXT_KEY_ALLOWS_RESEARCH_AGREEMENTS",           BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="TradeAgreementTradingAllowed",    Tip="TXT_KEY_ALLOWS_TRADE_AGREEMENTS",              BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="BridgeBuilding",                  Tip="TXT_KEY_ALLOWS_BRIDGES",                       BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="MapVisible",                      Tip="TXT_KEY_REVEALS_ENTIRE_MAP",                   BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="InternationalTradeRoutesChange",  Tip="TXT_KEY_ADDITIONAL_INTERNATIONAL_TRADE_ROUTE", BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="InfluenceSpreadModifier",         Tip="TXT_KEY_DOUBLE_TOURISM",                       BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="AllowsWorldCongress",             Tip="TXT_KEY_ALLOWS_WORLD_CONGRESS",                BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0},
		{Enhancement="ExtraVotesPerDiplomat",           Tip="TXT_KEY_EXTRA_VOTES_FROM_DIPLOMATS", Param=1,  BoostAtlas="GENERIC_FUNC_ATLAS", BoostIndex=0}
	}
end

--
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--
-- Mods to support ShowInTechTree entries on the following tables (in addition to Builds)
--
-- Buildings, Eras, Improvements, Processes, Projects, Resources, Routes, Technologies, UnitPromotions and Units
--
-- Use SQL to add the ShowInTechTree column to the required table(s), eg
--   ALTER TABLE Buildings ADD ShowInTechTree INTEGER DEFAULT 1;
-- (It is recommended to place each ALTER TABLE statement in its own .sql file, in case of conflicts.)
-- Use XML/SQL to set ShowInTechTree to 0 for entries you don't want to appear on the Tech Tree, eg
--   <ShowInTechTree>0</ShowInTechTree>
--

--
-- Helper function to ascertain if this row from the specified table should be shown
--

local gShowInTechTreeShowSupport = {Builds=true}

function ShowInTechTreeShow(table, data)
	if (gShowInTechTreeShowSupport[table] == nil) then
		gShowInTechTreeShowSupport[table] = false

		-- Note that we can't use pcall() to trap errors as we may be inside a coroutine
		for row in DB.Query("SELECT * FROM " .. table .. " LIMIT 1") do
			for col, _ in pairs(row) do
				if (col == "ShowInTechTree") then
					gShowInTechTreeShowSupport[table] = true
					break
				end
			end
		end
	end
	
	if (gShowInTechTreeShowSupport[table] == false) then
		-- The default is to show all items on the Tech Tree for tables that don't have a ShowInTechTree column
		return true
	end

	-- As the ShowInTechTree columns are added by altering the table with SQL, the game core doesn't know about them
	-- so we can't use data.ShowInTechTree, hence we need to execute a DB.Query() to get the value directly and check it
	for row in DB.Query("SELECT ShowInTechTree FROM " .. table .. " WHERE ID=" .. data.ID) do
		-- Explicit check for ShowInTechTree required, as in Lua the number 0 is also "true"
		return (row.ShowInTechTree == 1 or row.ShowInTechTree == true)
	end

	return false
end

--
-- Replacement GameInfo iterator
--
--   for thisPromotion in GameInfo.Buildings() do ... end
--   for thisPromotion in ShowInTechTreeIterator("Buildings") do ... end
--
--   for policy in GameInfo.Buildings(string.format("PreReqTech = '%s'", techType)) do ... end
--   for policy in ShowInTechTreeIterator("Buildings", string.format("PreReqTech = '%s'", techType)) do ... end
--

function ShowInTechTreeIterator(table, condition)
	local next = coroutine.create(function ()
		for row in GameInfo[table](condition or "ID=ID") do
			if ShowInTechTreeShow(table, row) then
				coroutine.yield(row)
			end
		end

		return nil
	end)

	return function ()
		local success, row = coroutine.resume(next)
		return success and row or nil
	end
end

--
-- Replacement GameInfo lookup
--
--  local freePolicy = GameInfo.UnitPromotions[row.PromotionType]
--  local freePolicy = ShowInTechTreeLookup("UnitPromotions", row.PromotionType)
--
-- MUST always be followed by a check for nil
--

function ShowInTechTreeLookup(table, key)
	local row = GameInfo[table][key]

	if not(ShowInTechTreeShow(table, row)) then
		return nil
	end

	if (table == "Improvements" and row.SpecificCivRequired) then
		if (GameInfoTypes[row.CivilizationType] ~= Players[Game.GetActivePlayer()]:GetCivilizationType()) then
			return nil
		end
	end

	return row
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

------------------------------------------列出我们所需要的图标------------------------------------------
local defaultErrorTextureSheet;

techPediaSearchStrings = {};
techToolTips = {};

if g_UseSmallIcons then
	defaultErrorTextureSheet = "UnitActions360.dds";
else
	defaultErrorTextureSheet = "UnitActions.dds";
end

local validUnitBuilds = nil;
local validBuildingBuilds = nil;
local validImprovementBuilds = nil;

turnsString = Locale.ConvertTextKey("TXT_KEY_TURNS");
freeString = Locale.ConvertTextKey("TXT_KEY_FREE");
lockedString = "[ICON_LOCKED]"; --Locale.ConvertTextKey("TXT_KEY_LOCKED");

function GetTechPedia( void1, void2, button )
	local searchString = techPediaSearchStrings[tostring(button)];
	Events.SearchForPediaEntry( searchString );		
end

function GatherInfoAboutUniqueStuff( civType )

	validUnitBuilds = {};
	validBuildingBuilds = {};
	validImprovementBuilds = {};

	-- put in the default units for any civ
	for thisUnitClass in GameInfo.UnitClasses() do
		validUnitBuilds[thisUnitClass.Type]	= thisUnitClass.DefaultUnit;	
	end

	-- put in my overrides
	for thisOverride in GameInfo.Civilization_UnitClassOverrides() do
 		if thisOverride.CivilizationType == civType then
			validUnitBuilds[thisOverride.UnitClassType]	= thisOverride.UnitType;
 		end
	end

	-- put in the default buildings for any civ
	for thisBuildingClass in GameInfo.BuildingClasses() do
		validBuildingBuilds[thisBuildingClass.Type]	= thisBuildingClass.DefaultBuilding;	
	end

	-- put in my overrides
	for thisOverride in GameInfo.Civilization_BuildingClassOverrides() do
 		if thisOverride.CivilizationType == civType then
			validBuildingBuilds[thisOverride.BuildingClassType]	= thisOverride.BuildingType;	
 		end
	end
	
	-- 改良设施
	for thisImprovement in GameInfo.Improvements() do
		if thisImprovement.CivilizationType == civType or thisImprovement.CivilizationType == nil then
			validImprovementBuilds[thisImprovement.Type] = thisImprovement.Type;	
		else
			validImprovementBuilds[thisImprovement.Type] = nil;	
		end
	end
	
end


function AddSmallButtonsToTechButton( thisTechButtonInstance, tech, maxSmallButtons, textureSize )
	-- This has a few assumptions, the main one being that the small buttons are named "B1", "B2", "B3"... and that GatherInfoAboutUniqueStuff() has been called before this

	-- first, hide the ones we aren't using
	for buttonNum = 1, maxSmallButtons, 1 do
		local buttonName = "B"..tostring(buttonNum);
		thisTechButtonInstance[buttonName]:SetHide(true);
	end
	
	if tech == nil then
		return;
	end

	local buttonNum = 1;
	local techType = tech.Type;

	-- Units
--	for thisUnitInfo in GameInfo.Units(string.format("PreReqTech = '%s'", techType)) do
	for thisUnitInfo in ShowInTechTreeIterator("Units", string.format("PreReqTech = '%s'", techType)) do
 		-- if this tech grants this player the ability to make this unit
		if validUnitBuilds[thisUnitInfo.Class] == thisUnitInfo.Type then
			local thisButton = thisTechButtonInstance["B"..tostring(buttonNum)];
			if thisButton then
				AdjustArtOnGrantedUnitButton( thisButton, thisUnitInfo, textureSize );
				buttonNum = buttonNum + 1;
			end
		end
 	end

	-- Buildings
-- 	for thisBuildingInfo in GameInfo.Buildings(string.format("PreReqTech = '%s'", techType)) do
 	for thisBuildingInfo in ShowInTechTreeIterator("Buildings", string.format("PreReqTech = '%s'", techType)) do
 		-- if this tech grants this player the ability to construct this building
		if validBuildingBuilds[thisBuildingInfo.BuildingClass] == thisBuildingInfo.Type then
			local thisButton = thisTechButtonInstance["B"..tostring(buttonNum)];
			if thisButton then
				AdjustArtOnGrantedBuildingButton( thisButton, thisBuildingInfo, textureSize );
				buttonNum = buttonNum + 1;
			end
		end
 	end

	-- Revealed Resources
-- 	for thisResourceInfo in GameInfo.Resources(string.format("TechReveal = '%s'", techType)) do
 	for thisResourceInfo in ShowInTechTreeIterator("Resources", string.format("TechReveal = '%s'", techType)) do
 		-- if this tech grants this player the ability to reveal this resource
		local thisButton = thisTechButtonInstance["B"..tostring(buttonNum)];
		if thisButton then
			AdjustArtOnGrantedResourceButton( thisButton, thisResourceInfo, textureSize );
			buttonNum = buttonNum + 1;
		end
 	end

	-- Projects
-- 	for thisProjectInfo in GameInfo.Projects(string.format("TechPrereq = '%s'", techType)) do
 	for thisProjectInfo in ShowInTechTreeIterator("Projects", string.format("TechPrereq = '%s'", techType)) do
 		-- if this tech grants this player the ability to build this project
		local thisButton = thisTechButtonInstance["B"..tostring(buttonNum)];
 		if thisButton then
			AdjustArtOnGrantedProjectButton( thisButton, thisProjectInfo, textureSize );
 			buttonNum = buttonNum + 1;
 		end
	end

	-- Improvements (Builds)
--	for thisBuildInfo in GameInfo.Builds{PrereqTech = techType, ShowInTechTree  = 1} do
	for thisBuildInfo in ShowInTechTreeIterator("Builds", string.format("PrereqTech = '%s'", techType)) do
		if thisBuildInfo.ImprovementType then
			if validImprovementBuilds[thisBuildInfo.ImprovementType] == thisBuildInfo.ImprovementType then
				local buttonName = "B"..tostring(buttonNum);
				local thisButton = thisTechButtonInstance[buttonName];
				if thisButton then
					AdjustArtOnGrantedActionButton( thisButton, thisBuildInfo, textureSize );
 					buttonNum = buttonNum + 1;
 				end
 			end
		else
			local buttonName = "B"..tostring(buttonNum);
			local thisButton = thisTechButtonInstance[buttonName];
			if thisButton then
				AdjustArtOnGrantedActionButton( thisButton, thisBuildInfo, textureSize );
 				buttonNum = buttonNum + 1;
 			end
		end
	end
	
	-- Processes
	local processCondition = "TechPrereq = '" .. techType .. "'";
--	for row in GameInfo.Processes(processCondition) do
	for row in ShowInTechTreeIterator("Processes", processCondition) do
		local thisButton = thisTechButtonInstance["B"..tostring(buttonNum)];
		if thisButton then
			IconHookup( row.PortraitIndex, textureSize, row.IconAtlas, thisButton );
			thisButton:SetHide( false );
			local strPText = Locale.ConvertTextKey( row.Description );
			thisButton:SetToolTipString( Locale.ConvertTextKey( "TXT_KEY_ENABLE_PRODUCITON_CONVERSION", strPText) );
		end
		buttonNum = buttonNum + 1;
	end	
		
 	-- Other Enhancements
	local condition = "TechType = '" .. techType .. "'";

	-- Movement Boosts
	for row in GameInfo.Route_TechMovementChanges(condition) do
		local route = ShowInTechTreeLookup("Routes", row.RouteType);
		if (route) then

		local thisButton = thisTechButtonInstance["B"..tostring(buttonNum)];
		if thisButton then
			if (bTechEnhIcons) then
				IconHookup( route.MovementBoostIndex, textureSize, route.MovementBoostAtlas, thisButton );
			else
				IconHookup( 0, textureSize, "GENERIC_FUNC_ATLAS", thisButton );
			end
			thisButton:SetHide( false );
			thisButton:SetToolTipString( Locale.ConvertTextKey("TXT_KEY_FASTER_MOVEMENT", GameInfo.Routes[row.RouteType].Description ) );
			buttonNum = buttonNum + 1;
		else
			break
		end
		
		end
	end	
	
	-- Improvement Yield Boosts
	local yieldChanges = {};
	for row in GameInfo.Improvement_TechYieldChanges(condition) do
		local improvement = ShowInTechTreeLookup("Improvements", row.ImprovementType);
		if (improvement) then

		local improvementType = row.ImprovementType;
		
		if(yieldChanges[improvementType] == nil) then
			yieldChanges[improvementType] = {};
		end
		
		local yield = GameInfo.Yields[row.YieldType];
		table.insert(yieldChanges[improvementType], Locale.Lookup( "TXT_KEY_YIELD_IMPROVED", improvement.Description , yield.Description, row.Yield));

		end
	end
	
	local sortedYieldChanges = {};
	for k,v in pairs(yieldChanges) do
		table.insert(sortedYieldChanges, {k,v});
	end
	table.sort(sortedYieldChanges, function(a,b) return Locale.Compare(a[1], b[1]) == -1 end); 
	
	for i,v in pairs(sortedYieldChanges) do
		local thisButton = thisTechButtonInstance["B"..tostring(buttonNum)];
		if(thisButton ~= nil) then
			table.sort(v[2], function(a,b) return Locale.Compare(a,b) == -1 end);
		
			if (bTechEnhIcons) then
				local improvement = GameInfo.Improvements[v[1]]
				IconHookup( improvement.YieldBoostIndex, textureSize, improvement.YieldBoostAtlas, thisButton );
			else
				IconHookup( 0, textureSize, "GENERIC_FUNC_ATLAS", thisButton );
			end
			thisButton:SetHide( false );
			thisButton:SetToolTipString(table.concat(v[2], "[NEWLINE]"));
			buttonNum = buttonNum + 1;
		else
			break;
		end
	end	

	-- Improvement No Fresh Water Boosts
	for row in GameInfo.Improvement_TechNoFreshWaterYieldChanges(condition) do
		local improvement = ShowInTechTreeLookup("Improvements", row.ImprovementType);
		if (improvement) then

		local buttonName = "B"..tostring(buttonNum);
		local thisButton = thisTechButtonInstance[buttonName];
		if thisButton then
			if (bTechEnhIcons) then
				IconHookup( improvement.YieldBoostIndex, textureSize, improvement.YieldBoostAtlas, thisButton );
			else
				IconHookup( 0, textureSize, "GENERIC_FUNC_ATLAS", thisButton );
			end
			thisButton:SetHide( false );
			thisButton:SetToolTipString( Locale.ConvertTextKey("TXT_KEY_NO_FRESH_WATER", GameInfo.Improvements[row.ImprovementType].Description , GameInfo.Yields[row.YieldType].Description, row.Yield));
			buttonNum = buttonNum + 1;
		else
			break;
		end
		
		end
	end	

	-- Improvement Fresh Water Boosts
	for row in GameInfo.Improvement_TechFreshWaterYieldChanges(condition) do
		local improvement = ShowInTechTreeLookup("Improvements", row.ImprovementType);
		if (improvement) then

		local thisButton = thisTechButtonInstance["B"..tostring(buttonNum)];
		if thisButton then
			if (bTechEnhIcons) then
				IconHookup( improvement.YieldBoostIndex, textureSize, improvement.YieldBoostAtlas, thisButton );
			else
				IconHookup( 0, textureSize, "GENERIC_FUNC_ATLAS", thisButton );
			end
			thisButton:SetHide( false );
			thisButton:SetToolTipString( Locale.ConvertTextKey("TXT_KEY_FRESH_WATER", GameInfo.Improvements[row.ImprovementType].Description , GameInfo.Yields[row.YieldType].Description, row.Yield));
			buttonNum = buttonNum + 1;
		else
			break;
		end
		
		end
	end	

	

	-- Trade Route Range Boosts
	for row in GameInfo.Technology_TradeRouteDomainExtraRange(condition) do
		if (row.TechType == techType and row.Range > 0) then
			local thisButton = thisTechButtonInstance["B"..tostring(buttonNum)];
			if thisButton then
				local domain = GameInfo.Domains[row.DomainType];
				if (bTechEnhIcons) then
					IconHookup( domain.TradeBoostIndex, textureSize, domain.TradeBoostAtlas, thisButton );
				else
					IconHookup( 0, textureSize, "GENERIC_FUNC_ATLAS", thisButton );
				end
				thisButton:SetHide( false );
				if (domain.ID == DomainTypes.DOMAIN_LAND) then
					thisButton:SetToolTipString( Locale.ConvertTextKey( "TXT_KEY_EXTENDS_LAND_TRADE_ROUTE_RANGE" ) );
				elseif (domain.ID == DomainTypes.DOMAIN_SEA) then
					thisButton:SetToolTipString( Locale.ConvertTextKey( "TXT_KEY_EXTENDS_SEA_TRADE_ROUTE_RANGE" ) );
				end
				buttonNum = buttonNum + 1;
			end	
		end
	end

	-- Specific Enhancements
	for _, enh in ipairs(TechEnhancementIcons) do
		local val = tech[enh.Enhancement];
		if ((type(val) == "boolean" and val == true) or (type(val) == "number" and val > 0)) then
			local thisButton = thisTechButtonInstance["B"..tostring(buttonNum)];
			if thisButton then
				IconHookup( enh.BoostIndex, textureSize, enh.BoostAtlas, thisButton );
				thisButton:SetHide( false );
				if (enh.Param == 1) then
					thisButton:SetToolTipString( Locale.ConvertTextKey( enh.Tip, val ) );
				else
					thisButton:SetToolTipString( Locale.ConvertTextKey( enh.Tip ) );
				end
				buttonNum = buttonNum + 1;
			end
		end
	end

	-- Free Promotions
	for row in GameInfo.Technology_FreePromotions(condition) do
--		local promotion = GameInfo.UnitPromotions[row.PromotionType];
		local promotion = ShowInTechTreeLookup("UnitPromotions", row.PromotionType);
		if (promotion) then
		
		local thisButton = thisTechButtonInstance["B"..tostring(buttonNum)];
		if thisButton and promotion ~= nil then
			IconHookup( promotion.PortraitIndex, textureSize, promotion.IconAtlas, thisButton );
			thisButton:SetHide( false );
			thisButton:SetToolTipString( Locale.ConvertTextKey("TXT_KEY_FREE_PROMOTION_FROM_TECH", promotion.Description, promotion.Help) );
			buttonNum = buttonNum + 1;
		else
			break;
		end

		end
	end
	
	-- Scenario Specific
	for i=1, 4 do
		if (tech.ScenarioTechButton == i) then
			local thisButton = thisTechButtonInstance["B"..tostring(buttonNum)];
			if thisButton then
				IconHookup( 0, textureSize, "GENERIC_FUNC_ATLAS", thisButton );
				thisButton:SetHide( false );
				thisButton:SetToolTipString( Locale.ConvertTextKey( string.format("TXT_KEY_SCENARIO_TECH_BUTTON_%i", i) ) );
				buttonNum = buttonNum + 1;
			end
		end
	end
	
	return buttonNum;
	
end


function AddCallbackToSmallButtons( thisTechButtonInstance, maxSmallButtons, void1, void2, thisEvent, thisCallback )
	for buttonNum = 1, maxSmallButtons, 1 do
		local buttonName = "B"..tostring(buttonNum);
		thisTechButtonInstance[buttonName]:SetVoids(void1, void2);
		thisTechButtonInstance[buttonName]:RegisterCallback(thisEvent, thisCallback);
	end
end


function AdjustArtOnGrantedUnitButton( thisButton, thisUnitInfo, textureSize )
	-- if we have one, update the unit picture
	if thisButton then
		
		local portraitOffset, portraitAtlas = UI.GetUnitPortraitIcon(thisUnitInfo.ID);
		local textureOffset, textureSheet = IconLookup( portraitOffset, textureSize, portraitAtlas );
		if textureOffset == nil then
			textureSheet = defaultErrorTextureSheet;
			textureOffset = nullOffset;
		end
		thisButton:SetTexture( textureSheet );
		thisButton:SetTextureOffset( textureOffset );
		thisButton:SetHide( false );
		techPediaSearchStrings[tostring(thisButton)] = Locale.ConvertTextKey(thisUnitInfo.Description);
		thisButton:RegisterCallback( Mouse.eRClick, GetTechPedia );
		
		-- Tooltip
		local bIncludeRequirementsInfo = true;
		if g_UseItemTooltip then
			techToolTips[tostring(thisButton)] = {portraitOffset, portraitAtlas, GetHelpTextForUnit(thisUnitInfo.ID, bIncludeRequirementsInfo)};
			thisButton:SetToolTipType( "ItemTooltip" );
			thisButton:SetToolTipCallback( TipHandler );
		else
			thisButton:SetToolTipString( GetHelpTextForUnit(thisUnitInfo.ID, bIncludeRequirementsInfo) );
		end
	end
end


function AdjustArtOnGrantedBuildingButton( thisButton, thisBuildingInfo, textureSize )
	-- if we have one, update the building (or wonder) picture
	if thisButton then
		
		local textureOffset, textureSheet = IconLookup( thisBuildingInfo.PortraitIndex, textureSize, thisBuildingInfo.IconAtlas );				
		if textureOffset == nil then
			textureSheet = defaultErrorTextureSheet;
			textureOffset = nullOffset;
		end
		thisButton:SetTexture( textureSheet );
		thisButton:SetTextureOffset( textureOffset );
		thisButton:SetHide( false );
		techPediaSearchStrings[tostring(thisButton)] = Locale.ConvertTextKey(thisBuildingInfo.Description);
		thisButton:RegisterCallback( Mouse.eRClick, GetTechPedia );
		
		-- Tooltip
		local bExcludeName = false;
		local bExcludeHeader = false;
		if g_UseItemTooltip then
			techToolTips[tostring(thisButton)] = {thisBuildingInfo.PortraitIndex, thisBuildingInfo.IconAtlas, GetHelpTextForBuilding(thisBuildingInfo.ID, bExcludeName, bExcludeHeader, false, nil)};
			thisButton:SetToolTipType( "ItemTooltip" );
			thisButton:SetToolTipCallback( TipHandler );
		else
			thisButton:SetToolTipString( GetHelpTextForBuilding(thisBuildingInfo.ID, bExcludeName, bExcludeHeader, false, nil) );
		end
	end
end


function AdjustArtOnGrantedProjectButton( thisButton, thisProjectInfo, textureSize )
	-- if we have one, update the project picture
	if thisButton then

		local textureOffset, textureSheet = IconLookup( thisProjectInfo.PortraitIndex, textureSize, thisProjectInfo.IconAtlas );
		if textureOffset == nil then
			textureSheet = defaultErrorTextureSheet;
			textureOffset = nullOffset;
		end
		thisButton:SetTexture( textureSheet );
		thisButton:SetTextureOffset( textureOffset );
		thisButton:SetHide( false );
		techPediaSearchStrings[tostring(thisButton)] = Locale.ConvertTextKey(thisProjectInfo.Description);
		thisButton:RegisterCallback( Mouse.eRClick, GetTechPedia );
		
		-- Tooltip
		local bIncludeRequirementsInfo = true;
		if g_UseItemTooltip then
			techToolTips[tostring(thisButton)] = {thisProjectInfo.PortraitIndex, thisProjectInfo.IconAtlas, GetHelpTextForProject(thisProjectInfo.ID, bIncludeRequirementsInfo)};
			thisButton:SetToolTipType( "ItemTooltip" );
			thisButton:SetToolTipCallback( TipHandler );
		else
			thisButton:SetToolTipString( GetHelpTextForProject(thisProjectInfo.ID, bIncludeRequirementsInfo) );
		end
	end
end


function AdjustArtOnGrantedResourceButton( thisButton, thisResourceInfo, textureSize )
	if thisButton then

		local textureOffset, textureSheet = IconLookup( thisResourceInfo.PortraitIndex, textureSize, thisResourceInfo.IconAtlas );
		if textureOffset == nil then
			textureSheet = defaultErrorTextureSheet;
			textureOffset = nullOffset;
		end
		thisButton:SetTexture( textureSheet );
		thisButton:SetTextureOffset( textureOffset );
		thisButton:SetHide( false );
		techPediaSearchStrings[tostring(thisButton)] =  Locale.Lookup(thisResourceInfo.Description);
		thisButton:RegisterCallback( Mouse.eRClick, GetTechPedia );
		
		-- Tooltip
		if g_UseItemTooltip then
			techToolTips[tostring(thisButton)] = {thisResourceInfo.PortraitIndex, thisResourceInfo.IconAtlas, Locale.ConvertTextKey("TXT_KEY_REVEALS_RESOURCE_ON_MAP", thisResourceInfo.Description)};
			thisButton:SetToolTipType( "ItemTooltip" );
			thisButton:SetToolTipCallback( TipHandler );
		else
			thisButton:SetToolTipString( Locale.ConvertTextKey("TXT_KEY_REVEALS_RESOURCE_ON_MAP", thisResourceInfo.Description) );
		end
	end
end

function AdjustArtOnGrantedActionButton( thisButton, thisBuildInfo, textureSize )
	if thisButton then
		local textureOffset, textureSheet = IconLookup( thisBuildInfo.IconIndex, textureSize, thisBuildInfo.IconAtlas );
		if textureOffset == nil then
			textureSheet = defaultErrorTextureSheet;
			textureOffset = nullOffset;
		end
		thisButton:SetTexture( textureSheet );
		thisButton:SetTextureOffset( textureOffset );
		thisButton:SetHide(false);
		
		local thisBuildType;
		local sToolTip = Locale.ConvertTextKey( thisBuildInfo.Description );
		if thisBuildInfo.RouteType then
			techPediaSearchStrings[tostring(thisButton)] = Locale.ConvertTextKey( GameInfo.Routes[thisBuildInfo.RouteType].Description );
			thisBuildType = GameInfo.Routes[thisBuildInfo.RouteType];
		elseif thisBuildInfo.ImprovementType then
			techPediaSearchStrings[tostring(thisButton)] = Locale.ConvertTextKey( GameInfo.Improvements[thisBuildInfo.ImprovementType].Description );
			thisBuildType = GameInfo.Improvements[thisBuildInfo.ImprovementType];
			sToolTip = GetHelpTextForImprovement( thisBuildType.ID );
		else -- we are a choppy thing
			techPediaSearchStrings[tostring(thisButton)] = Locale.ConvertTextKey( GameInfo.Concepts["CONCEPT_WORKERS_CLEARINGLAND"].Description );
		end
		thisButton:RegisterCallback( Mouse.eRClick, GetTechPedia );
		--techPediaSearchStrings[tostring(thisButton)] = Locale.ConvertTextKey( thisBuildInfo.Description );
		--thisButton:RegisterCallback( Mouse.eRClick, GetTechPedia );
		
		-- Tooltip
		if g_UseItemTooltip and thisBuildType then
			techToolTips[tostring(thisButton)] = {thisBuildType.PortraitIndex, thisBuildType.IconAtlas, sToolTip};
			thisButton:SetToolTipType( "ItemTooltip" );
			thisButton:SetToolTipCallback( TipHandler );
		else
			thisButton:SetToolTipString( sToolTip );
		end
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
local tipControlTable = {};
TTManager:GetTypeControlTable( "ItemTooltip", tipControlTable );
function TipHandler( Button )
	local controls = tipControlTable;
	if controls.Text == nil then
		return;
	end
	local iconIndex = techToolTips[tostring(Button)][1];
	local iconAtlas = techToolTips[tostring(Button)][2];
	local sTooltip  = techToolTips[tostring(Button)][3];
	
	controls.Text:SetText( sTooltip );
	
	local textureOffset, textureSheet;
	if iconAtlas then
		textureOffset, textureSheet = IconHookup( iconIndex, 256, iconAtlas, controls.Portrait );
	end
	controls.PortraitFrame:SetHide( textureOffset == nil );
	controls.PortraitFrame:SetAnchor( UIManager.GetMousePos() > 300 and "L,T" or "R,T" );
	controls.Grid:DoAutoSize();
end