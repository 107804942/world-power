-------------------------------------------------
-- created by bc1 / compatible with 1.0.3.144 code
-------------------------------------------------
if not EUI then
	include( "EUI_utilities" )
end

local math_max = math.max
local math_ceil = math.ceil

local IconLookup = EUI.IconLookup
local IconHookup = EUI.IconHookup

include( "InfoTooltipInclude" )
local GetHelpTextForUnit = GetHelpTextForUnit
local GetHelpTextForBuilding = GetHelpTextForBuilding
local GetHelpTextForImprovement = GetHelpTextForImprovement

include "StackInstanceManager"

local bnw_mode = ContentManager.IsActive("6DA07636-4123-4018-B643-6575B4EC336B", ContentType.GAMEPLAY);
local g_traitsQuery, g_uniqueUnitsQuery, g_uniqueBuildingsQuery, g_uniqueImprovementsQuery;
local g_questionMark =	{ PortraitIndex = 23, IconAtlas = "CIV_COLOR_ATLAS" };
local g_questionMarkTip = Locale.ConvertTextKey( "TXT_KEY_MISC_UNKNOWN" );
local g_randomTrait =	{ Description = "TXT_KEY_RANDOM_LEADER_HELP", ShortDescription = "TXT_KEY_MISC_RANDOMIZE" };
local g_randomCiv =	{	ID=-1,
				LeaderPortraitIndex = 22,
				LeaderIconAtlas = "LEADER_ATLAS",
				LeaderDescription = "TXT_KEY_RANDOM_LEADER",
				ShortDescription = "TXT_KEY_RANDOM_CIV",
			};--g_randomCiv

local function initializePopulateCivilizationUniques()

	g_traitsQuery = DB.CreateQuery([[SELECT Description, ShortDescription FROM Traits inner join
					Leader_Traits ON Traits.Type = Leader_Traits.TraitType
					WHERE Leader_Traits.LeaderType = ? LIMIT 1]]);

	g_uniqueUnitsQuery = DB.CreateQuery([[SELECT ID, Description, PortraitIndex, IconAtlas from Units INNER JOIN
					Civilization_UnitClassOverrides ON Units.Type = Civilization_UnitClassOverrides.UnitType
					WHERE Civilization_UnitClassOverrides.CivilizationType = ? AND
					Units.ShowInPedia IS NOT 0 AND
					Civilization_UnitClassOverrides.UnitType IS NOT NULL]]);

	g_uniqueBuildingsQuery = DB.CreateQuery([[SELECT ID, Description, PortraitIndex, IconAtlas from Buildings INNER JOIN
					Civilization_BuildingClassOverrides ON Buildings.Type = Civilization_BuildingClassOverrides.BuildingType
					WHERE Civilization_BuildingClassOverrides.CivilizationType = ? AND
					Civilization_BuildingClassOverrides.BuildingType IS NOT NULL]]
					.. ( bnw_mode and " AND Buildings.GreatWorkCount IS NOT -1" or "" ) );

	g_uniqueImprovementsQuery = DB.CreateQuery([[SELECT ID, Description, PortraitIndex, IconAtlas from Improvements
					WHERE CivilizationType = ?]]);
end

-----------------
-- Pedia Callback
-----------------
local getPedia;
local function getPediaB( ... )
	Events.SearchForPediaEntry( ... )
end
local function getPediaA( ... )
	UIManager:QueuePopup( LookUpControl( CivilopediaControl ), PopupPriority.eUtmost );
	getPedia = getPediaB;
	getPedia( ... )
end
getPedia = CivilopediaControl and getPediaA;

----------------
-- Icon Creation
----------------

local function newBlankIcon( parentControl )
	local iconControls = {};
	ContextPtr:BuildInstanceForControl( "IconInstance", iconControls, parentControl );
	return iconControls;
end

local function populateIcon( controls, item, isTip, tip, pedia )
	-- set the item picture
	local textureOffset, textureAtlas = IconLookup( item.PortraitIndex, controls.Portrait:GetSizeX(), item.IconAtlas );
	if textureAtlas then
		controls.Portrait:SetTexture( textureAtlas );
		controls.Portrait:SetTextureOffset( textureOffset );
	end
	-- set the item tooltip
	if isTip then
		controls.Portrait:SetToolTipString( tip )
	elseif item.Description then
		controls.Portrait:LocalizeAndSetToolTip( item.Description );
	end
	-- set the item description
	if  controls.Text and item.Description then
		controls.Text:LocalizeAndSetText( item.Description );
	end
	-- set the pedia callback
	pedia = CivilopediaControl and ( pedia or item.Description);
	if pedia then
		controls.Portrait:RegisterCallback( Mouse.eRClick, function() getPedia( pedia ) end );
	end
end

local function newItemIcon( parentControl, ... )
	populateIcon( newBlankIcon( parentControl ), ... )
end


local function populateUniques( parentControl, civType )
	-- UU icons
	for unit in g_uniqueUnitsQuery( civType ) do
	---newItemIcon( parentControl, unit, pcall( GetHelpTextForUnit, unit.ID, true ) );
	local iconControls = {};
	    ContextPtr:BuildInstanceForControl( "IconInstance", iconControls, parentControl );

		---populateIcon( iconControls, unit, pcall( GetHelpTextForUnit, unit.ID, true ) );
		--------------------------------------------------------------
		local textureOffset, textureAtlas = IconLookup( unit.PortraitIndex, iconControls.Portrait:GetSizeX(), unit.IconAtlas );
		if textureAtlas then
		iconControls.Portrait:SetTexture( textureAtlas );
		iconControls.Portrait:SetTextureOffset( textureOffset );
	    end
		
		iconControls.Portrait:SetVoid2(unit.ID)
		iconControls.Portrait:SetToolTipCallback(ToolTipHandler)
        iconControls.Portrait:SetToolTipType( "City_UnitTooltip5" ) 

		--PopulateUniquesForGameLoad( Controls.SubStack, civ.Type );

		---iconControls.Portrait:SetToolTipString( tip )

	    -- set the item description
	    if  iconControls.Text and unit.Description then
		iconControls.Text:LocalizeAndSetText( unit.Description );
	    end
	    -- set the pedia callback
	    local pedia = CivilopediaControl and ( pedia or unit.Description);
	    if pedia then
		iconControls.Portrait:RegisterCallback( Mouse.eRClick, function() getPedia( pedia ) end );
	    end
		--------------------------------------------------------------

	end
	-- UB icons
	for building in g_uniqueBuildingsQuery( civType ) do
		newItemIcon( parentControl, building, pcall( GetHelpTextForBuilding, building.ID ) );
	end
	-- UI icons
	for improvement in g_uniqueImprovementsQuery( civType ) do
		newItemIcon( parentControl, improvement, pcall( GetHelpTextForImprovement, improvement.ID ) );
	end
end


-----------------
-- Populate Entry
-----------------
local function populateCivilizationUniquesInitialized( civControls, civKeys )

	local trait;
	local civ = {};
	local iconParentControl = civControls.Icons;
	if civKeys then
		for k, v in pairs(civKeys) do
			civ[k] = v;
		end
		-- Civ icon
		newItemIcon( iconParentControl, civ, nil, nil, civ.Pedia or civ.ShortDescription );
		-- UU, UB, UI icons
		populateUniques( iconParentControl, civ.Type )
		-- Leader
		local pedia = CivilopediaControl and ( civ.LeaderPedia or civ.LeaderDescription );
		if pedia then
			civControls.Button:RegisterCallback( Mouse.eRClick, function() getPedia( pedia ) end );
		end
		trait = g_traitsQuery( civ.LeaderType )();
--		trait = GameInfo.Traits[ GameInfo.Leader_Traits{ LeaderType = civ.LeaderType )().TraitType ];
	else
		-- Question mark icons
		for i = 1, 3 do
			newItemIcon( iconParentControl, g_questionMark, true, g_questionMarkTip );
		end
		trait = g_randomTrait;
		civ = g_randomCiv;
	end
	local n = iconParentControl:GetNumChildren()
	iconParentControl:SetWrapWidth( math_ceil( n / math_ceil( n / 4 ) ) * 56 )
	iconParentControl:CalculateSize();
	iconParentControl:ReprocessAnchoring();
	civControls.Button:SetVoid1( civ.ID );
	civControls.Description:LocalizeAndSetText( trait.Description );
	civControls.Title:SetText( string.format("%s (%s)",
	Locale.ConvertTextKey( "TXT_KEY_RANDOM_LEADER_CIV", civ.LeaderDescription, civ.ShortDescription ),
	Locale.ConvertTextKey( trait.ShortDescription ) ) );
	IconHookup( civ.LeaderPortraitIndex, civControls.Portrait:GetSizeX(), civ.LeaderIconAtlas, civControls.Portrait );
	local height = math_max( 100, iconParentControl:GetSizeY() + 8 );
	civControls.Button:SetSizeY( height );
	civControls.Anim:SetSizeY( height + 4 );
	civControls.Button:ReprocessAnchoring();
end

-------------------
-- Export Functions
-------------------
InitializePopulateUniques = initializePopulateCivilizationUniques;
PopulateUniquesForSelectCivilization = populateCivilizationUniquesInitialized;
PopulateUniquesForGameSetup = populateCivilizationUniquesInitialized;
PopulateUniquesForGameLoad = populateUniques;




-------------------
-- TOOL TIP
-------------------
local g_TooltipControls5 = {}
TTManager:GetTypeControlTable( "City_UnitTooltip5", g_TooltipControls5 )

	Controls.UnittipTimer5:RegisterAnimCallback( function()
		local controls = g_TooltipControls5
		controls.Details5:SetHide( false )
		controls.IconStack5:SetWrapWidth( 32 )
		controls.IconStack5:CalculateSize()
		controls.PromotionText5:SetHide( false )
		controls.Grid5:ReprocessAnchoring()
		controls.Grid5:DoAutoSize()
	end)

local City_PromotionIconIM5 = StackInstanceManager( "PromotionIcon5", "Image5", g_TooltipControls5.IconStack5 )

--==========================================================
-- city Tooltips
--==========================================================
function ToolTipHandler( button )

		local id = button:GetVoid2()
		local controls = g_TooltipControls5

		tip = GetHelpTextForUnit2(id)
        local thisUnitInfo = GameInfo.Units[id]
		---local playerID = unit:GetOwner()

		controls.Text5:SetText( tip )
		local i = 0
		local promotionText = {}
		local promotionIcon
		City_PromotionIconIM5:ResetInstances()
		
		local thisUnitType = { UnitType = thisUnitInfo.Type }
		
       for row in GameInfo.Unit_FreePromotions( thisUnitType ) do
		unitPromotion = GameInfo.UnitPromotions[ row.PromotionType ]
		if unitPromotion~=nil  then
		if  unitPromotion.ShowInUnitPanel ~= 0 and unitPromotion.ShowInTooltip ~= 0 then
		    promotionIcon = City_PromotionIconIM5:GetInstance()
			IconHookup( unitPromotion.PortraitIndex, 32, unitPromotion.IconAtlas, promotionIcon.Image5 )
			table.insert( promotionText, Locale.ConvertTextKey( unitPromotion.Description) )
			    end
		    end
		end

		controls.Details5:SetHide( true )
		controls.PromotionText5:SetText( table.concat( promotionText, "[NEWLINE]" ) )
		controls.PromotionText5:SetHide( #promotionText ~= 1 )
		controls.IconStack5:SetWrapWidth( math.ceil( i / math.ceil( i / 10 ) ) * 26 )
		controls.IconStack5:CalculateSize()
		controls.Grid5:ReprocessAnchoring()
		controls.Grid5:DoAutoSize()
		Controls.UnittipTimer5:SetToBeginning()
        Controls.UnittipTimer5:SetPauseTime(0) 
		Controls.UnittipTimer5:Reverse()		
end