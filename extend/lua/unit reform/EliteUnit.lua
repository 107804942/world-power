include("IconSupport")
include("InstanceManager")


--------------------------------------------------------------------
local g_ProductionManager = InstanceManager:new("EliteUnit", "Unit", Controls.EliteStack)

local g_SortTable = {}
local g_ActiveSort = "Move"
local g_ReverseSort = false

local g_MoveIcons = {"", "[ICON_MOVES]"}


--------------------------------------------------------------------
function OnSort(sort)
  if (sort == g_ActiveSort) then
    g_ReverseSort = not g_ReverseSort
  else
    g_ReverseSort = not (sort == "Name" or sort == "Move")
    g_ActiveSort = sort
  end

  Controls.EliteStack:SortChildren(SortByValue)
end
Controls.SortMove:RegisterCallback(Mouse.eLClick, function() OnSort("Move") end)
Controls.SortName:RegisterCallback(Mouse.eLClick, function() OnSort("Name") end)
Controls.SortBaseCombatStrength:RegisterCallback(Mouse.eLClick, function() OnSort("BaseCombatStrength") end)
Controls.SortBaseRangedCombatStrength:RegisterCallback(Mouse.eLClick, function() OnSort("BaseRangedCombatStrength") end)
--------------------------------------------------------------------
function SortByValue(a, b)
  local entryA = g_SortTable[tostring(a)]
  local entryB = g_SortTable[tostring(b)]

  if (entryA == nil or entryB == nil) then
    return tostring(a) < tostring(b)
  end

  local valueA = entryA[g_ActiveSort]
  local valueB = entryB[g_ActiveSort]

  if (valueA == valueB) then
    valueA = entryA.name
    valueB = entryB.name
  elseif (g_ReverseSort) then
    valueA = entryB[g_ActiveSort]
    valueB = entryA[g_ActiveSort]
  end

  if (valueA == nil or valueB == nil) then
    return tostring(a) < tostring(b)
  end

  return valueA < valueB
end
--------------------------------------------------------------------





function OnUnitClick( x,iUnit )
    local unit = Players[Game.GetActivePlayer()]:GetUnitByID(iUnit)
	local plot = unit:GetPlot()
    --local plot = Map.GetPlot( x, y );
    if( plot ~= nil ) then
    	UI.LookAt( plot );
		Events.SerialEventUnitFlagSelected( Game:GetActivePlayer(),iUnit);
	end
end




--------------------------------------------------------------------
function UpdateData()
   local pPlayer = Players[ Game.GetActivePlayer() ];

  g_ProductionManager:ResetInstances()
  g_SortTable = {}


  	if pPlayer:IsHuman() then
    for pUnit in pPlayer:Units() do

	if pUnit:IsHasPromotion(GameInfoTypes["PROMOTION_ELITE_UNIT"]) then 

	--local iUnit = pUnit:GetID();

    local instance = g_ProductionManager:GetInstance()
    local sort = {}
    g_SortTable[tostring(instance.Unit)] = sort


    ------------------------------------------------------------------
    local iMove = pUnit:MovesLeft()
    sort.Move = math.floor(iMove/GameDefines["MOVE_DENOMINATOR"])
    instance.Move:SetText(sort.Move)

  
	--------------------------------------------------------------------

	local iName = pUnit:GetName()

    sort.Name = iName

	instance.Name:SetText(Locale.ConvertTextKey(sort.Name))

	instance.Name:RegisterCallback(Mouse.eLClick,OnUnitClick)
	instance.Name:SetVoids( pUnit:GetX(),pUnit:GetID());
	--instance.Name:SetVoid1(pUnit);
	--------------------------------------------------------------------


	local iStrength = pUnit:GetBaseCombatStrength()

    sort.BaseCombatStrength = iStrength

    instance.BaseCombatStrength:SetText(sort.BaseCombatStrength)
	--------------------------------------------------------------------

	
	local iStrengthRanged = pUnit:GetBaseRangedCombatStrength()>0 and pUnit:GetBaseRangedCombatStrength() or 0

	sort.BaseRangedCombatStrength = iStrengthRanged
    instance.BaseRangedCombatStrength:SetText(sort.BaseRangedCombatStrength)
	    end
	 end
  end
  
  Controls.EliteStack:SortChildren(SortByValue)
  Controls.EliteStack:CalculateSize()
  Controls.EliteScrollPanel:CalculateInternalSize()
end


function OnChangeEvent()
    if( ContextPtr:IsHidden() == false ) then
        UpdateData();
    end
end
Events.SerialEventUnitDestroyed.Add( OnChangeEvent );
Events.SerialEventUnitSetDamage.Add( OnChangeEvent );
Events.UnitStateChangeDetected.Add( OnChangeEvent );
Events.SerialEventUnitCreated.Add( OnChangeEvent );
Events.UnitSelectionChanged.Add( OnChangeEvent );
Events.UnitActionChanged.Add( OnChangeEvent );
Events.UnitFlagUpdated.Add( OnChangeEvent );
Events.UnitGarrison.Add( OnChangeEvent );
Events.UnitEmbark.Add( OnChangeEvent );
Events.SerialEventUnitMoveToHexes.Add( OnChangeEvent );
Events.SerialEventUnitMove.Add( OnChangeEvent );
Events.SerialEventUnitTeleportedToHex.Add( OnChangeEvent );
Events.GameplaySetActivePlayer.Add(OnChangeEvent);

--------------------------------------------------------------------
function OnClose()
  ContextPtr:SetHide(true)
end
Controls.CloseButton:RegisterCallback(Mouse.eLClick, OnClose)
--------------------------------------------------------------------
function InputHandler(uiMsg, wParam, lParam)
  if (uiMsg == KeyEvents.KeyDown) then
    if (wParam == Keys.VK_ESCAPE) then
      OnClose()
      return true
    end
  end
end
ContextPtr:SetInputHandler(InputHandler)

local wasHidden
function OnEnterCityScreen()
  wasHidden = ContextPtr:IsHidden()
  ContextPtr:SetHide(true);
end
Events.SerialEventEnterCityScreen.Add(OnEnterCityScreen)
--------------------------------------------------------------------
function OnExitCityScreen()
  ContextPtr:SetHide(wasHidden)
end
Events.SerialEventExitCityScreen.Add(OnExitCityScreen)

function OnUnitMoveListPopup()
	ContextPtr:SetHide(false)
end
LuaEvents.EliteUnit_ListPopup.Add( OnUnitMoveListPopup )
--------------------------------------------------------------------
Events.GameplaySetActivePlayer.Add(OnClose)




EliteSelectButton = {
  Name = "Elite Select",
  Title = "TXT_KEY_SP_BTNNOTE_ELITE_SELECT_SHORT", -- or a TXT_KEY
  OrderPriority = 200, -- default is 200
  IconAtlas = "SP_UNIT_ACTION_ATLAS2", -- 45 and 64 variations required
  PortraitIndex = 29,
  ToolTip = "TXT_KEY_SP_BTNNOTE_ELITE_SELECT", -- or a TXT_KEY_ or a function
  Condition = function(action, unit)
    return unit:CanMove() and unit:IsHasPromotion(GameInfoTypes["PROMOTION_ELITE_UNIT"]);
  end, -- or nil or a boolean, default is true
  

  Action = function(action, unit, eClick) 
    
	LuaEvents.EliteUnit_ListPopup()
	UpdateData()
     --unit:SetMoves(0)
  end
  
};
LuaEvents.UnitPanelActionAddin(EliteSelectButton);



function EliteOnDisplay()
    ContextPtr:SetHide(false)
	UpdateData()
	--Controls.BGBlock:SetHide(false)
	--Controls.EA_Welcome:SetHide(false)
end

function OnAdditionalInformationDropdownGatherEntries(additionalEntries)
  table.insert(additionalEntries, {text=Locale.ConvertTextKey("TXT_KEY_SP_BTNNOTE_ELITE"), call=EliteOnDisplay})
end
LuaEvents.AdditionalInformationDropdownGatherEntries.Add(OnAdditionalInformationDropdownGatherEntries)
LuaEvents.RequestRefreshAdditionalInformationDropdownEntries()
