----------------------------------------------------------------
-- Add a button based on the item info
----------------------------------------------------------------

--==========================================================
-- 夏皮罗的棒子
-- Compatible with EUI v1.29i using switches
--==========================================================
include "GameInfoActualCache"
local GameInfo = GameInfoCache

include "StackInstanceManager"
include "IconHookup"
include "ShortUnitTip"



local g_TooltipControls = {}
TTManager:GetTypeControlTable( "NEW_UnitTooltip", g_TooltipControls )


Controls.UnittipTimer:RegisterAnimCallback( function()
		local controls = g_TooltipControls
		controls.PortraitFrame2:SetHide( false )
		controls.Details2:SetHide( false )
		controls.IconStack2:SetWrapWidth( 32 )
		controls.IconStack2:CalculateSize()
		controls.PromotionText2:SetHide( false )
		controls.Grid2:ReprocessAnchoring()
		controls.Grid2:DoAutoSize()
end)


local N_PromotionIconIM = StackInstanceManager( "PromotionIcon2", "Image", g_TooltipControls.IconStack2 )


--==========================================================
-- Unit Tooltips
--==========================================================
function ToolTipHandler( id )
    --local player = Players[ button:GetVoid1()]
	--local unit = UI.GetHeadSelectedUnit()
		
		local controls = g_TooltipControls

		tip = GetHelpTextForUnit2(id)
        local thisUnitInfo = GameInfo.Units[id]
		---local playerID = unit:GetOwner()

		controls.Text2:SetText( tip )
		local i = 0
		local promotionText = {}
		local promotionIcon
		N_PromotionIconIM:ResetInstances()
		
		if not( thisUnitInfo.IsTrade ) then
		local thisUnitType = { UnitType = thisUnitInfo.Type }
		
        for row in GameInfo.Unit_FreePromotions( thisUnitType ) do
		unitPromotion = GameInfo.UnitPromotions[ row.PromotionType ]
		if unitPromotion~=nil  then
		if  unitPromotion.ShowInUnitPanel ~= 0 and unitPromotion.ShowInTooltip ~= 0 then
		    promotionIcon = N_PromotionIconIM:GetInstance()
			IconHookup( unitPromotion.PortraitIndex, 32, unitPromotion.IconAtlas, promotionIcon.Image2 )
			table.insert( promotionText, Locale.ConvertTextKey( unitPromotion.Description) )
			    end
			end
		end
		end

		local iconIndex, iconAtlas = UI.GetUnitPortraitIcon( id, Game.GetActivePlayer())
		IconHookup( iconIndex, 256, iconAtlas, controls.UnitPortrait2 )
		controls.PortraitFrame2:SetAnchor( UIManager.GetMousePos() > 300 and "L,T" or "R,T" )
	
		controls.Details2:SetHide( true )
		controls.PromotionText2:SetText( table.concat( promotionText, "[NEWLINE]" ) )
		controls.PromotionText2:SetHide( #promotionText ~= 1 )
		controls.IconStack2:SetWrapWidth( math.ceil( i / math.ceil( i / 10 ) ) * 26 )
		controls.IconStack2:CalculateSize()
		controls.Grid2:ReprocessAnchoring()
		controls.Grid2:DoAutoSize()
		Controls.UnittipTimer:SetToBeginning()
        Controls.UnittipTimer:SetPauseTime(0) 
		--g_TooltipControls.PortraitFrame2:SetHide( false )
		Controls.UnittipTimer:Reverse()
		
end
--==========================================================






function AddProductionButton( id, description, orderType, turnsLeft, column, isDisabled, ePurchaseYield )
local controlTable;

local pCity = GetCurrentCity();
if (pCity == nil) then
return;
end

local abAdvisorRecommends = {false, false, false, false};
local iUnit = -1;
local iBuilding = -1;
local iProject = -1;
local iProcess = -1;

if column == 1 then -- we are a unit
iUnit = id;
controlTable = g_UnitInstanceManager:GetInstance();
local thisUnitInfo = GameInfo.Units[id];

-- Portrait
local portraitOffset, portraitAtlas = UI.GetUnitPortraitIcon(id, pCity:GetOwner());
local textureOffset, textureSheet = IconLookup( portraitOffset, 45, portraitAtlas );
if textureOffset == nil then
textureSheet = defaultErrorTextureSheet;
textureOffset = nullOffset;
end
controlTable.ProductionButtonImage:SetTexture(textureSheet);
controlTable.ProductionButtonImage:SetTextureOffset(textureOffset);

-- Tooltip
local bIncludeRequirementsInfo = false;
local strToolTip = Locale.ConvertTextKey(GetHelpTextForUnit(id, bIncludeRequirementsInfo));

-- Disabled help text
if (isDisabled) then
if (g_IsProductionMode) then
local strDisabledInfo = pCity:CanTrainTooltip(id);
if (strDisabledInfo ~= nil and strDisabledInfo ~= "") then
strToolTip = strToolTip .. "[NEWLINE][COLOR_WARNING_TEXT]" .. strDisabledInfo .. "[ENDCOLOR]";
end
else
local strDisabledInfo;
if (ePurchaseYield == YieldTypes.YIELD_GOLD) then
strDisabledInfo = pCity:GetPurchaseUnitTooltip(id);
else
strDisabledInfo = pCity:GetFaithPurchaseUnitTooltip(id);
end
if (strDisabledInfo ~= nil and strDisabledInfo ~= "") then
strToolTip = strToolTip .. "[NEWLINE][COLOR_WARNING_TEXT]" .. strDisabledInfo .. "[ENDCOLOR]";
end
end
end

-----controlTable.Button:SetToolTipString(strToolTip);  替换原有
 controlTable.Button:SetVoid2( iUnit)
 controlTable.Button:SetToolTipCallback(ToolTipHandler(iUnit));---新增
controlTable.Button:SetToolTipType( "NEW_UnitTooltip" ) ---新增



elseif column == 2 or column == 3 then -- we are a building, wonder, or project
if column == 2 then
controlTable = g_BuildingInstanceManager:GetInstance();
elseif column == 3 then
controlTable = g_WonderInstanceManager:GetInstance();
end

local thisInfo;

local strToolTip = "";

if orderType == OrderTypes.ORDER_MAINTAIN then
print("SCRIPTING ERROR: Got a Process when a Building was expected");
else
local bBuilding;
if orderType == OrderTypes.ORDER_CREATE then
bBuilding = false;
thisInfo = GameInfo.Projects[id];
iProject = id;
elseif orderType == OrderTypes.ORDER_CONSTRUCT then
bBuilding = true;
thisInfo = GameInfo.Buildings[id];
iBuilding = id;
end

local textureOffset, textureSheet = IconLookup( thisInfo.PortraitIndex, 45, thisInfo.IconAtlas );
if textureOffset == nil then
textureSheet = defaultErrorTextureSheet;
textureOffset = nullOffset;
end
controlTable.ProductionButtonImage:SetTexture(textureSheet);
controlTable.ProductionButtonImage:SetTextureOffset(textureOffset);

-- Tooltip
if (bBuilding) then
local bExcludeName = false;
local bExcludeHeader = false;
strToolTip = GetHelpTextForBuilding(id, bExcludeName, bExcludeHeader, false, pCity);
else
local bIncludeRequirementsInfo = false;
strToolTip = GetHelpTextForProject(id, bIncludeRequirementsInfo, pCity);
end

-- Disabled help text
if (isDisabled) then
if (g_IsProductionMode) then
local strDisabledInfo = pCity:CanConstructTooltip(id);
if (strDisabledInfo ~= nil and strDisabledInfo ~= "") then
strToolTip = strToolTip .. "[NEWLINE][COLOR_WARNING_TEXT]" .. strDisabledInfo .. "[ENDCOLOR]";
end
else
local strDisabledInfo;
if (ePurchaseYield == YieldTypes.YIELD_GOLD) then
strDisabledInfo = pCity:GetPurchaseBuildingTooltip(id);
else
strDisabledInfo = pCity:GetFaithPurchaseBuildingTooltip(id);
end
if (strDisabledInfo ~= nil and strDisabledInfo ~= "") then
strToolTip = strToolTip .. "[NEWLINE][COLOR_WARNING_TEXT]" .. strDisabledInfo .. "[ENDCOLOR]";
end
end
end

end

controlTable.Button:SetToolTipString(strToolTip);

elseif column == 4 then -- processes

iProcess = id;
controlTable = g_ProcessInstanceManager:GetInstance();
local thisProcessInfo = GameInfo.Processes[id];

-- Portrait
local textureOffset, textureSheet = IconLookup( thisProcessInfo.PortraitIndex, 45, thisProcessInfo.IconAtlas );
if textureOffset == nil then
textureSheet = defaultErrorTextureSheet;
textureOffset = nullOffset;
end
controlTable.ProductionButtonImage:SetTexture(textureSheet);
controlTable.ProductionButtonImage:SetTextureOffset(textureOffset);

-- Tooltip
local bIncludeRequirementsInfo = false;
local strToolTip = Locale.ConvertTextKey(GetHelpTextForProcess(id, bIncludeRequirementsInfo));

-- Disabled help text
if (isDisabled) then

end

controlTable.Button:SetToolTipString(strToolTip);

else
return
end

local nameString = Locale.ConvertTextKey( description );

listOfStrings[tostring(controlTable.Button)] = nameString;

controlTable.UnitName:SetText( nameString );
if g_IsProductionMode then
controlTable.NumTurns:SetText(turnsLeft);
else
if (ePurchaseYield == YieldTypes.YIELD_GOLD) then
controlTable.NumTurns:SetText( turnsLeft.." [ICON_GOLD]" );
else
controlTable.NumTurns:SetText( turnsLeft.." [ICON_PEACE]" );
end
end

local ePurchaseEnum;
if g_IsProductionMode then
if (orderType == OrderTypes.ORDER_TRAIN) then
ePurchaseEnum = g_CONSTRUCT_UNIT;
elseif (orderType == OrderTypes.ORDER_CONSTRUCT) then
ePurchaseEnum = g_CONSTRUCT_BUILDING;
elseif (orderType == OrderTypes.ORDER_CREATE) then
ePurchaseEnum = g_CONSTRUCT_PROJECT;
elseif (orderType == OrderTypes.ORDER_MAINTAIN) then
ePurchaseEnum = g_MAINTAIN_PROCESS;
end
else
if (orderType == OrderTypes.ORDER_TRAIN) then
if (ePurchaseYield == YieldTypes.YIELD_GOLD) then
ePurchaseEnum = g_PURCHASE_UNIT_GOLD;
elseif (ePurchaseYield == YieldTypes.YIELD_FAITH) then
ePurchaseEnum = g_PURCHASE_UNIT_FAITH;
end
elseif (orderType == OrderTypes.ORDER_CONSTRUCT) then
if (ePurchaseYield == YieldTypes.YIELD_GOLD) then
ePurchaseEnum = g_PURCHASE_BUILDING_GOLD;
elseif (ePurchaseYield == YieldTypes.YIELD_FAITH) then
ePurchaseEnum = g_PURCHASE_BUILDING_FAITH;
end
elseif (orderType == OrderTypes.ORDER_CREATE) then
if (ePurchaseYield == YieldTypes.YIELD_GOLD) then
ePurchaseEnum = g_PURCHASE_PROJECT_GOLD;
elseif (ePurchaseYield == YieldTypes.YIELD_FAITH) then
ePurchaseEnum = g_PURCHASE_PROJECT_FAITH;
end
elseif (orderType == OrderTypes.ORDER_MAINTAIN) then
print("SCRIPTING ERROR: Processes are not allowed to be purchased");
end
end

controlTable.Button:SetVoid1( ePurchaseEnum );
controlTable.Button:SetVoid2( id );
controlTable.Button:RegisterCallback( Mouse.eRClick, GetProdHelp );
controlTable.Button:ClearCallback(Mouse.eLClick);
if(isDisabled) then
controlTable.DisabledBox:SetHide(false);
else
controlTable.Button:RegisterCallback( Mouse.eLClick, ProductionSelected );
controlTable.DisabledBox:SetHide(true);
end

if (iUnit >= 0) then
for iAdvisorLoop = 0, AdvisorTypes.NUM_ADVISOR_TYPES - 1, 1 do
abAdvisorRecommends[iAdvisorLoop] = Game.IsUnitRecommended(iUnit, iAdvisorLoop);
end
elseif (iBuilding >= 0) then
for iAdvisorLoop = 0, AdvisorTypes.NUM_ADVISOR_TYPES - 1, 1 do
abAdvisorRecommends[iAdvisorLoop] = Game.IsBuildingRecommended(iBuilding, iAdvisorLoop);
end
elseif (iProject >= 0) then
for iAdvisorLoop = 0, AdvisorTypes.NUM_ADVISOR_TYPES - 1, 1 do
abAdvisorRecommends[iAdvisorLoop] = Game.IsProjectRecommended(iProject, iAdvisorLoop);
end
elseif (iProcess >= 0) then
-- Advisors will not recommend Processes
end

for iAdvisorLoop = 0, AdvisorTypes.NUM_ADVISOR_TYPES - 1, 1 do
local pControl = nil;
if (iAdvisorLoop == AdvisorTypes.ADVISOR_ECONOMIC) then
pControl = controlTable.EconomicRecommendation;
elseif (iAdvisorLoop == AdvisorTypes.ADVISOR_MILITARY) then
pControl = controlTable.MilitaryRecommendation;
elseif (iAdvisorLoop == AdvisorTypes.ADVISOR_SCIENCE) then
pControl = controlTable.ScienceRecommendation;
elseif (iAdvisorLoop == AdvisorTypes.ADVISOR_FOREIGN) then
pControl = controlTable.ForeignRecommendation;
end

if (pControl) then
pControl:SetHide(not abAdvisorRecommends[iAdvisorLoop]);
end
end
end
