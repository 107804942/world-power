--==========================================================
-- Game View
-- this is the parent of both WorldView and CityView
-- This is the final lua message handler that will be
-- processed in the processing chain, after this is
-- it is in engine side C++
-- Re-written by bc1 using Notepad++
-- WorldView is merged into InGame
--==========================================================

Events.SequenceGameInitComplete.Add(function()

include "UserInterfaceSettings"
local UserInterfaceSettings = UserInterfaceSettings

include "GameInfoCache" -- warning! booleans are true, not 1, and use iterator ONLY with table field conditions, NOT string SQL query
local GameInfoUnits = GameInfoCache.Units
local GameInfoInterfaceModes = GameInfoCache.InterfaceModes

include "FLuaVector"
local g_ColorUnitTile = Color( 1, 1, 0, 1 )
local g_ColorGiftTileImprovement = Color( 1, 0, 1, 1 )

include "StackInstanceManager"

--==========================================================
-- Minor lua optimizations
--==========================================================

local print = print
local debug_print = print
local type = type
local insert = table.insert
local ceil = math.ceil
local max = math.max
local min = math.min
local sqrt = math.sqrt

local ButtonPopupTypes = ButtonPopupTypes
local CITY_UPDATE_TYPE_BANNER = CityUpdateTypes.CITY_UPDATE_TYPE_BANNER
local COMMAND_CANCEL_ALL = CommandTypes.COMMAND_CANCEL_ALL
local ContextPtr = ContextPtr
local Controls = Controls
local DOMAIN_AIR = DomainTypes.DOMAIN_AIR
local DOMAIN_LAND = DomainTypes.DOMAIN_LAND
local DOMAIN_SEA = DomainTypes.DOMAIN_SEA
local Events = Events
local EventsRequestYieldDisplay = Events.RequestYieldDisplay.Call
local EventsClearHexHighlightStyle = Events.ClearHexHighlightStyle.Call
local EventsSerialEventHexHighlight = Events.SerialEventHexHighlight.Call
local EventsSpawnArrowEvent = Events.SpawnArrowEvent.Call
local EventsRemoveAllArrowsEvent = Events.RemoveAllArrowsEvent.Call
local EventsSerialEventMouseOverHex = Events.SerialEventMouseOverHex
local Game = Game
local GameDefines = GameDefines
local CITY_PLOTS_RADIUS = GameDefines.CITY_PLOTS_RADIUS
local GameInfoTypes = GameInfoTypes
local GAMEMESSAGE_PUSH_MISSION = GameMessageTypes.GAMEMESSAGE_PUSH_MISSION
local GAMEMESSAGE_DO_COMMAND = GameMessageTypes.GAMEMESSAGE_DO_COMMAND
local GAMEMESSAGE_DO_TASK = GameMessageTypes.GAMEMESSAGE_DO_TASK
local GAMEVIEW_NONE = GameViewTypes.GAMEVIEW_NONE
local WORLD_ANCHOR_WORKER = GenericWorldAnchorTypes.WORLD_ANCHOR_WORKER
local WORLD_ANCHOR_SETTLER = GenericWorldAnchorTypes.WORLD_ANCHOR_SETTLER
local GetGameViewRenderType = GetGameViewRenderType
local InStrategicView = InStrategicView
local GameData_DIRTY_BIT = InterfaceDirtyBits.GameData_DIRTY_BIT
local InterfaceModeTypes = InterfaceModeTypes
local INTERFACEMODE_SELECTION = InterfaceModeTypes.INTERFACEMODE_SELECTION
local INTERFACEMODE_CITY_RANGE_ATTACK = InterfaceModeTypes.INTERFACEMODE_CITY_RANGE_ATTACK
local KeyEvents = KeyEvents
local Keys = Keys
local GetPlot = Map.GetPlot
local GetPlotXY = Map.GetPlotXY
local PlotDistance = Map.PlotDistance
local GetNumPlots = Map.GetNumPlots
local GetPlotByIndex = Map.GetPlotByIndex
local MissionTypes = MissionTypes
local Mouse = Mouse
local MouseEvents = MouseEvents
local BY_HOST = NetKicked.BY_HOST
local Network = Network
local OptionsManager = OptionsManager
local Players = Players
local InGameMenu = PopupPriority.InGameMenu
local PreGame = PreGame
local ProcessStrategicViewMouseClick = ProcessStrategicViewMouseClick
local BulkHideUI = SystemUpdateUIType.BulkHideUI
local BulkShowUI = SystemUpdateUIType.BulkShowUI
local TASK_RANGED_ATTACK = TaskTypes.TASK_RANGED_ATTACK
local GridToWorld = GridToWorld
--local Teams = Teams
--local ToGridFromHex = ToGridFromHex
local ToHexFromGrid = ToHexFromGrid
local ToggleStrategicView = ToggleStrategicView
local UI = UI
local GetSelectedUnitID = UI.GetSelectedUnitID
local GetHeadSelectedUnit = UI.GetHeadSelectedUnit
local GetHeadSelectedCity = UI.GetHeadSelectedCity
local GetInterfaceMode = UI.GetInterfaceMode
local GetMouseOverHex = UI.GetMouseOverHex
local IsTouchScreenEnabled = UI.IsTouchScreenEnabled
local SetInterfaceMode = UI.SetInterfaceMode
local UIManager = UIManager
local YieldDisplayTypes = YieldDisplayTypes


local gk_mode = Game.GetReligionName ~= nil

local g_IsPathShown, g_IsArrowSpawned, g_IsCityOutlineShown, g_WorkerSuggestHighlightPlots, g_FounderSuggestHighlightPlots, g_showUnitPredictiveStrikeRange, g_showTileRecommendations, g_isFastAutoUnitCycle
--local g_EatNextUp = false
local g_lastUnit

local g_InterfaceModeNames = {} for k,v in pairs(InterfaceModeTypes) do g_InterfaceModeNames[v]=k end
local g_InterfaceModeCursors = {}
local g_InterfaceModeMessageHandler = {}
local g_NewInterfaceModeChangeHandler = {}
local g_OldInterfaceModeChangeHandler = {}

--local FoundCityIcon, MiniMapOptionsPanel
local MiniMapOptionsPanel = ContextPtr:LookUpControl( "WorldView/MiniMapPanel/OptionsPanel" )
local FoundCityIcon = ContextPtr:LookUpControl( "YieldIconManager/CityAnchor" )

--==========================================================
-- Utilities
--==========================================================

--usage1: IndexPlot( plot, hexAreaPlotIndex )
--OR usage2: IndexPlot( plot, ringPlotIndex, ringDistanceFromPlot )
local function IndexPlot( plot, i, r )
	-- determine if input parameters are valid - you can delete this part for a tiny performance boost
	if not plot or not i or i<0 or (r and (r<0 or i>6*r)) then
		return print("IndexPlot error - invalid parameters")
	end
	-- area plot index mode ?
	if not r then
		-- area plot index 0 is a special case
		if i == 0 then
			return plot
		else
			-- which ring are we on ?
			r = ceil( ( sqrt( 12*i + 9 ) - 3 ) / 6 )
			-- determine ring plot index (substract inside area)
			i = i - ( 3 * (r-1) * r ) - 1
		end
	end

	-- determine coordinate offsets corresponding to ring index
	local x, y
	if i <= 2*r then
		x = min( i, r )
	elseif i<= 4*r then
		x = 3*r-i
	else
		x = max( i-6*r, -r )
	end
	if i <= 3*r then
		y = max( r-i, -r )
	else
		y = min( i-4*r, r )
	end

	-- return plot offset from initial plot
	return GetPlotXY( plot:GetX(), plot:GetY(), x, y )
end

-- Returns the number of plots in hexagonal area of specified radius, excluding center plot
local function CountHexPlots( r )
	return (r+1) * r * 3
end

local function CallIfNotNil( f, ... )
	if f then return f( ... ) end
end

local function SetInterfaceModeSelectionTrue()
	SetInterfaceMode( INTERFACEMODE_SELECTION )
	return true
end

local function AssignInterfaceModeMessageHandler( interfaceMode, action )
	local IMMH = {}
	IMMH[ MouseEvents.LButtonUp ] = action
	IMMH[ MouseEvents.RButtonUp ] = action
	if IsTouchScreenEnabled() then
		IMMH[ MouseEvents.PointerUp ] = action
	end
	g_InterfaceModeMessageHandler[ interfaceMode ] = IMMH
end

local function AssignInterfaceMode( interfaceMode, action, new, old )
	if interfaceMode then
		g_NewInterfaceModeChangeHandler[ interfaceMode ] = new
		g_OldInterfaceModeChangeHandler[ interfaceMode ] = old
		local actionType = type(action)
		if actionType == "function" then
			return AssignInterfaceModeMessageHandler( interfaceMode, action )
		elseif actionType == "table" then
			g_InterfaceModeMessageHandler[ interfaceMode ] = action
		end
	end
end

local function ClearUnitMovementRange()
	--debug_print("ClearUnitMovementRange")
	EventsClearHexHighlightStyle( "MovementRangeBorder" )
	return EventsClearHexHighlightStyle( "AMRBorder" )
end

local function ShowUnitMovementRange( unit )
	if unit and unit:CanMove() then
		--debug_print("Events.ShowMovementRange")
		return Events.ShowMovementRange( unit:GetOwner(), unit:GetID() )
	else
		return ClearUnitMovementRange()
	end
end

Events.ClearUnitMoveHexRange.Add( ClearUnitMovementRange )
Events.StartUnitMoveHexRange.Add( ClearUnitMovementRange )
Events.AddUnitMoveHexRangeHex.Add( function( i, j, k, attackMove )
	if attackMove then
		return EventsSerialEventHexHighlight( {x=i, y=j}, true, nil, "AMRBorder" )
	else
		return EventsSerialEventHexHighlight( {x=i, y=j}, true, nil, "MovementRangeBorder" )
	end
end)

local function plotIsLand( plot )
	return not plot:IsWater()
end

local function returnTrue()
	return true
end

local function ClearStrikeRange()
	--debug_print( "ClearStrikeRange" )
	EventsClearHexHighlightStyle( "ValidFireTargetBorder" )
	return EventsClearHexHighlightStyle( "FireRangeBorder" )
end

local function DisplayStrikeRange( attacker, fromPlot, range, isIndirectFireAllowed, isDomainOnly, domainID, isRevealed )
	ClearStrikeRange()
	--debug_print( "DisplayStrikeRange", attacker:GetName(), "x", fromPlot:GetX(), "y", fromPlot:GetY(), "range", range, "isIndirectFireAllowed", isIndirectFireAllowed, "isDomainOnly", isDomainOnly, "isRevealed", isRevealed )
	local plot, x, y, hex
	local team = attacker:GetTeam()
	local testDomain = isDomainOnly and ( (domainID == DOMAIN_LAND and plotIsLand) or (domainID == DOMAIN_SEA and fromPlot.IsWater) ) or returnTrue
	local testCanSeePlot = (isIndirectFireAllowed or domainID == DOMAIN_AIR) and returnTrue or fromPlot.CanSeePlot
	local testVisibility = isRevealed and fromPlot.IsRevealed or fromPlot.IsVisible
	-- highlight the bombardable plots
	for i = 0, CountHexPlots( range ) do
		plot = IndexPlot( fromPlot, i )
		if plot and testVisibility( plot, team ) and testDomain( plot ) and testCanSeePlot( fromPlot, plot, team, range-1, -1 ) then -- -1 = no direction
			x, y = plot:GetX(), plot:GetY()
			hex = ToHexFromGrid{ x=x, y=y }
			EventsSerialEventHexHighlight( hex, true, nil, "FireRangeBorder" )
			if attacker:CanRangeStrikeAt( x, y ) then
				EventsSerialEventHexHighlight( hex, true, nil, "ValidFireTargetBorder" )
			end
		end
	end
end

local function DisplayUnitStrikeRange( unit, plot, isRevealed )
	return DisplayStrikeRange( unit, plot or unit:GetPlot(), unit:Range(), unit:IsRangeAttackIgnoreLOS(), unit:IsRangeAttackOnlyInDomain(), unit:GetDomainType(), isRevealed )
end

local function ClearRangeStrikeArrow()
	if g_IsArrowSpawned then
		EventsRemoveAllArrowsEvent()
		g_IsArrowSpawned = false
	end
end

local function DisplayCityRangeStrikeArrow( x, y )
	local city = GetHeadSelectedCity()
	if city and city:CanRangeStrikeAt( x, y ) then
		g_IsArrowSpawned = true
		return EventsSpawnArrowEvent( city:GetX(), city:GetY(), x, y )
	elseif g_IsArrowSpawned then
		g_IsArrowSpawned = false
		return EventsRemoveAllArrowsEvent()
	end
end

local function DisplayUnitRangeStrikeArrow( x, y )
	local unit = GetHeadSelectedUnit()
	if unit and unit:CanMove() and ( unit:CanRangeStrikeAt( x, y )  or unit:CanNukeAt( x, y ) ) then
		g_IsArrowSpawned = true
		return EventsSpawnArrowEvent( unit:GetX(), unit:GetY(), x, y )
	elseif g_IsArrowSpawned then
		g_IsArrowSpawned = false
		return EventsRemoveAllArrowsEvent()
	end
end

local function EndUnitRangeStrikeAttack()
	EventsSerialEventMouseOverHex.Remove( DisplayUnitRangeStrikeArrow )
	ClearStrikeRange()
	return ClearRangeStrikeArrow()
end

local function BeginUnitRangeStrikeAttack( isAlreadySelectionMode )
	local unit = GetHeadSelectedUnit()
	if unit and not unit:IsOutOfAttacks() and unit:IsCanAttackRanged() then -- or unit:CanNuke()
		DisplayUnitStrikeRange( unit )
		EventsSerialEventMouseOverHex.Add( DisplayUnitRangeStrikeArrow )
		return DisplayUnitRangeStrikeArrow( GetMouseOverHex() )
	elseif isAlreadySelectionMode then
		return EndUnitRangeStrikeAttack()
	else
		return SetInterfaceMode( INTERFACEMODE_SELECTION )
	end
end

local function DoUnitRangeStrikeAttack()
	local x, y = GetMouseOverHex()
	local plot = GetPlot( x, y )
	local unit = GetHeadSelectedUnit()
	--debug_print( "RangedAttack", unit and unit:GetName() )
	-- Don't let the user do a ranged attack on a plot that contains some fighting.
	if not unit or not plot or plot:IsFighting() then
	-- should handle the case of units bombarding tiles when they are already at war
	elseif unit:CanRangeStrikeAt( x, y, true, true ) then -- bNeedWar, bNoncombatAllowed
		Game.SelectionListGameNetMessage( GAMEMESSAGE_PUSH_MISSION, unit:GetDomainType() == DOMAIN_AIR and MissionTypes.MISSION_MOVE_TO or MissionTypes.MISSION_RANGE_ATTACK, x, y, 0, false, UI.ShiftKeyDown() ) -- Air strikes are moves... yep
		ClearRangeStrikeArrow()
	-- Unit Range Strike - special case for declaring war with range strike
	elseif unit:CanRangeStrikeAt( x, y, false, true ) then -- bNeedWar, bNoncombatAllowed
		-- Is there someone here that we COULD bombard, perhaps?
		local rivalTeamID = unit:GetDeclareWarRangeStrike( plot )
		if rivalTeamID ~= -1 then
			UIManager:SetUICursor( 0 )
			Events.SerialEventGameMessagePopup{
				Type  = ButtonPopupTypes.BUTTONPOPUP_DECLAREWARRANGESTRIKE,
				Data1 = rivalTeamID,
				Data2 = x,
				Data3 = y,
			}
		end
	end
	return true
end

local function DisplayCityOutline( x, y )
	--debug_print( "DisplayCityOutline", x, y )
	local unit = GetHeadSelectedUnit()
	local targetPlot = GetPlot( x, y )
	EventsClearHexHighlightStyle( "CityLimits" )
	if targetPlot and ( unit and unit:CanFound( targetPlot ) or Players[Game.GetActivePlayer()]:CanFound( x,y ) ) and targetPlot:IsRevealed( Game.GetActiveTeam() ) then
		EventsRequestYieldDisplay( YieldDisplayTypes.AREA, CITY_PLOTS_RADIUS, x, y )
		if FoundCityIcon then
			local a, b, c = GridToWorld( x, y )
			FoundCityIcon:SetWorldPositionVal( a, b, c )
			FoundCityIcon:SetHide( false  )
		end
		local plot
		for i=0, CountHexPlots( CITY_PLOTS_RADIUS ) do
			plot = IndexPlot( targetPlot, i )
			if plot then
				EventsSerialEventHexHighlight( ToHexFromGrid{ x=plot:GetX(), y=plot:GetY() }, true, nil, "CityLimits" )
			end
		end
	else
		EventsRequestYieldDisplay( YieldDisplayTypes.AREA, 0 )
		if FoundCityIcon then
			FoundCityIcon:SetHide( true )
		end
	end
end

local function ShowCitiesOutline()
	if not g_IsCityOutlineShown then
		g_IsCityOutlineShown = true
		local activeTeamID = Game.GetActiveTeam()
		local activePlayerID = Game.GetActivePlayer()
		local EventsSerialEventHexHighlight = EventsSerialEventHexHighlight
		local ToHexFromGrid = ToHexFromGrid
		local hex, plot, fillType1, fillType2
		local mouseX, mouseY = GetMouseOverHex()
		local distance = PlotDistance
		for playerID, player in pairs(Players) do
			if player:IsAlive() then
				if playerID == activePlayerID then
					fillType1 = "WorkedFill"
					fillType2 = "WorkedOutline"
				else
					fillType1 = "OverlapFill"
					fillType2 = "OverlapOutline"
				end
				for city in player:Cities() do
					if city:Plot():IsRevealed( activeTeamID ) and distance( mouseX, mouseY, city:GetX(), city:GetY() ) < 25 then
						for i=0, city:GetNumCityPlots()-1 do
							plot = city:GetCityIndexPlot( i )
							if plot then
								hex = ToHexFromGrid{ x=plot:GetX(), y=plot:GetY() }
								EventsSerialEventHexHighlight(  hex, true, nil, fillType1 )
								EventsSerialEventHexHighlight(  hex, true, nil, fillType2 )
							end
						end
					end
				end
			end
		end
		EventsSerialEventMouseOverHex.Add( DisplayCityOutline )
		return DisplayCityOutline( GetMouseOverHex() )
	end
end

local function HideCitiesOutline()
	if g_IsCityOutlineShown then
		EventsSerialEventMouseOverHex.Remove( DisplayCityOutline )
		EventsClearHexHighlightStyle( "WorkedFill" )
		EventsClearHexHighlightStyle( "WorkedOutline" )
		EventsClearHexHighlightStyle( "OverlapFill" )
		EventsClearHexHighlightStyle( "OverlapOutline" )
		EventsClearHexHighlightStyle( "CityLimits" )
		if FoundCityIcon then
			FoundCityIcon:SetHide( true )
		end
		g_IsCityOutlineShown = false
		return EventsRequestYieldDisplay( YieldDisplayTypes.AREA, 0 )
	end
end

local function RequestYieldDisplay()
	-- Yield icons off by default
	if OptionsManager.IsCivilianYields() then
		local unit = GetHeadSelectedUnit()
		if ( UI.CanSelectionListWork() or UI.CanSelectionListFound() ) and not( unit and (GameInfoUnits[unit:GetUnitType()]or{}).DontShowYields ) then
			return EventsRequestYieldDisplay( YieldDisplayTypes.EMPIRE )

--		elseif unit and UI.CanSelectionListFound() then
--			return EventsRequestYieldDisplay( YieldDisplayTypes.AREA, CITY_PLOTS_RADIUS, unit:GetX(), unit:GetY() )
		end
	end
	if not UI.IsCityScreenUp() then
		EventsRequestYieldDisplay( YieldDisplayTypes.AREA, 0 )
	end
end

local function DisplayUnitPath( x, y )
	--debug_print( "DisplayUnitPath", x, y )
	UI.SendPathfinderUpdate()
	Events.DisplayMovementIndicator( true )
	if g_showUnitPredictiveStrikeRange or UI.AltKeyDown() then
		local unit = GetHeadSelectedUnit()
		if unit and unit:IsCanAttackRanged() then -- or unit:CanNuke()
			local plot = GetPlot( x, y )
			local domainID = unit:GetDomainType()
			local isWater = plot:IsWater()
			if plot and plot:IsRevealed( unit:GetTeam() ) and ( isWater and domainID ~= DOMAIN_LAND or not isWater and domainID ~= DOMAIN_SEA ) then
				-- DisplayUnitPredictiveStrikeRange
				return DisplayUnitStrikeRange( unit, plot, plot ~= unit:GetPlot() )
			end
			return ClearStrikeRange()
		end
	end
end

local function ShowUnitPath()
	--debug_print( "ShowUnitPath", "g_IsPathShown", g_IsPathShown )
	if not g_IsPathShown then
		g_IsPathShown = true
		if UI.CanSelectionListFound() then
			ShowCitiesOutline()
		end
		EventsSerialEventMouseOverHex.Add( DisplayUnitPath )
		return DisplayUnitPath( GetMouseOverHex() )
	end
end

local function HideUnitPath()
	--debug_print( "HideUnitPath", "g_IsPathShown=", g_IsPathShown )
	if g_IsPathShown then
		g_IsPathShown = false
		EventsSerialEventMouseOverHex.Remove( DisplayUnitPath )
		Events.DisplayMovementIndicator( false )
		HideCitiesOutline()
		return RequestYieldDisplay()
	end
end

local function ClickSelect()
	-- Give the strategic view a chance to process the click first
	if InStrategicView() and ProcessStrategicViewMouseClick() then
	else
		local plot = GetPlot( GetMouseOverHex() )
		if plot then
			UI.LocationSelect( plot, UI.CtrlKeyDown(), UI.AltKeyDown(), UI.ShiftKeyDown() )
			return true
		end
	end
end

--[[
UI.CenterCamera
CameraProjectionChanged; CameraViewChanged;
Events.SerialEventCameraBack; Events.SerialEventCameraCenter; Events.SerialEventCameraForward; Events.SerialEventCameraLeft; Events.SerialEventCameraRight; 
Events.SerialEventCameraSetCenterAndZoom{x=-1280,y=720,z=zoom};
Events.CameraStopPitchingDown(), Events.CameraStartPitchingUp(), Events.CameraStopPitchingUp(), Events.CameraStartPitchingDown()
Events.SerialEventCameraSetCenterAndZoom.Add(
function(...)
	local s = "SerialEventCameraSetCenterAndZoom"
	for _, v in pairs{...} do
		s = s ..", "..tostring(v)
	end
	Events.GameplayAlertMessage( s )
end)
	[Keys.VK_DIVIDE] = function( b )
		local x, y = GridToWorld( GetMouseOverHex() )
		if b then
			Events.SerialEventCameraSetCenterAndZoom{x=x,y=y,z=70}
		else
			Events.SerialEventCameraSetCenterAndZoom{x=x,y=y,z=1800}
		end
	end,
--]]

--==========================================================
-- Default Key Down Handler
--==========================================================
local DefaultKeyDownFunction = {
	[Keys.VK_LEFT] = function( b )
		if b then
			Events.CameraStopRotatingCW()
			return Events.CameraStartRotatingCCW()
		else
			Events.SerialEventCameraStopMovingRight()
			return Events.SerialEventCameraStartMovingLeft()
		end
	end,
	[Keys.VK_RIGHT] = function( b )
		if b then
			Events.CameraStopRotatingCCW()
			return Events.CameraStartRotatingCW()
		else
			Events.SerialEventCameraStopMovingLeft()
			return Events.SerialEventCameraStartMovingRight()
		end
	end,
	[Keys.VK_UP] = function( b )
		if b then
			return Events.SerialEventCameraForward()
		else
			Events.SerialEventCameraStopMovingBack()
			return Events.SerialEventCameraStartMovingForward()
		end
	end,
	[Keys.VK_DOWN] = function( b )
		if b then
			return Events.SerialEventCameraBack()
		else
			Events.SerialEventCameraStopMovingForward()
			return Events.SerialEventCameraStartMovingBack()
		end
	end,
	[Keys.VK_NEXT] = function()
		return Events.SerialEventCameraOut{ x=0, y=0 }
	end,
	[Keys.VK_PRIOR] = function()
		return Events.SerialEventCameraIn{ x=0, y=0 }
	end,
	[Keys.VK_ESCAPE] = function()
		if MiniMapOptionsPanel and not MiniMapOptionsPanel:IsHidden() then
			return MiniMapOptionsPanel:SetHide( true )
		elseif g_IsPathShown or GetInterfaceMode() ~= INTERFACEMODE_SELECTION then
			return SetInterfaceMode( INTERFACEMODE_SELECTION )
		elseif InStrategicView() then
			return ToggleStrategicView()
		else
			return UIManager:QueuePopup( Controls.GameMenu, InGameMenu )
		end
	end,
	[Keys.VK_OEM_3] = function() -- ~ en_us ù fr_azerty
		if UI.DebugFlag() then
			if UI.ShiftKeyDown() and PreGame.IsMultiplayerGame() then
				return Controls.NetworkDebug:SetHide( not Controls.NetworkDebug:IsHidden() )
			elseif not PreGame.IsMultiplayerGame() and not PreGame.IsHotSeatGame() then
				return Controls.DebugMenu:SetHide( not Controls.DebugMenu:IsHidden() )
			end
		end
	end,
	[Keys.Z] = function()
		if UI.CtrlKeyDown() and UI.DebugFlag() and not PreGame.IsMultiplayerGame() and not PreGame.IsHotSeatGame() then
			Game.ToggleDebugMode()
			local plot
			local team = Game.GetActiveTeam()
			local bIsDebug = Game.IsDebugMode()
			for iPlotLoop = 0, GetNumPlots()-1, 1 do
				plot = GetPlotByIndex(iPlotLoop)
				if plot:GetVisibilityCount() > 0 then
					plot:ChangeVisibilityCount( team, -1, -1, true, true )
				end
				plot:SetRevealed( team, false )
				plot:ChangeVisibilityCount( team, 1, -1, true, true )
				plot:SetRevealed( team, bIsDebug )
			end
		end
	end,
	[Keys.G] = UI.ToggleGridVisibleMode,
	[Keys.X] = ShowCitiesOutline,
}
local function DefaultKeyDownHandler( wParam )
	if DefaultKeyDownFunction[ wParam ] then
		DefaultKeyDownFunction[ wParam ]( UI.ShiftKeyDown() )
		return true
	end
end

--==========================================================
-- Default Key Up Handler
--==========================================================
local DefaultKeyUpFunction = {
	[Keys.VK_LEFT] = function()
		Events.CameraStopRotatingCCW()
		return Events.SerialEventCameraStopMovingLeft()
	end,
	[Keys.VK_RIGHT] = function()
		Events.CameraStopRotatingCW()
		return Events.SerialEventCameraStopMovingRight()
	end,
	[Keys.VK_UP] = Events.SerialEventCameraStopMovingForward.Call,
	[Keys.VK_DOWN] = Events.SerialEventCameraStopMovingBack.Call,
	[Keys.X] = HideCitiesOutline,
}
local function DefaultKeyUpHandler( wParam )
	if DefaultKeyUpFunction[ wParam ] then
		DefaultKeyUpFunction[ wParam ]()
		return true
	end
end
-- Emergency key up handler
-- Events.KeyUpEvent.Add( DefaultKeyUpHandler )

--==========================================================
-- Default Input Handler
--==========================================================
local DefaultMessageHandler = { [KeyEvents.KeyDown] = DefaultKeyDownHandler, [KeyEvents.KeyUp] = DefaultKeyUpHandler, [MouseEvents.LButtonUp] = ClickSelect }
if IsTouchScreenEnabled() then
	DefaultMessageHandler[MouseEvents.PointerUp] = SetInterfaceModeSelectionTrue
	DefaultMessageHandler[MouseEvents.PointerDown] = function()
		if UIManager:GetNumPointers() > 1 then
			return SetInterfaceModeSelectionTrue()
		end
	end
end

--==========================================================
-- Default Mission Handler
--==========================================================
for row in GameInfoInterfaceModes() do
	g_InterfaceModeCursors[ row.ID ] = GameInfoTypes[ row.CursorType ]
	local interfaceModeMission = GameInfoTypes[ row.Mission ]
	if interfaceModeMission and interfaceModeMission ~= MissionTypes.NO_MISSION then
		AssignInterfaceModeMessageHandler( row.ID,
		function()
			--debug_print( "DefaultMissionHandler", g_InterfaceModeNames[ GetInterfaceMode() ] )
			local x, y = GetMouseOverHex()
			if GetPlot(x, y) and UI.CanDoInterfaceMode(interfaceModeMission) then
				Game.SelectionListGameNetMessage( GAMEMESSAGE_PUSH_MISSION, interfaceModeMission, x, y, 0, false, UI.ShiftKeyDown() )
			end
			SetInterfaceMode( INTERFACEMODE_SELECTION )
			return true
		end)
	end
end

--==========================================================
-- Debug
--==========================================================
do
	local unitPlopper, resourcePlopper, improvementPlopper
	local plopperSettings =
	{
		Player = -1,
		Plopper = unitPlopper,
		EnabledWhenInTab = false
	}

	unitPlopper =
	{
		UnitType = -1,
		Embarked = false,
		Plop =
		function( plot )
			if plopperSettings.Player ~= -1 and unitPlopper.UnitType ~= -1 then
				local player = Players[plopperSettings.Player]
				if player then
					--debug_print( "plop", unitPlopper.UnitNameOffset, player.InitUnitWithNameOffset )
					local unit

					if unitPlopper.UnitNameOffset and player.InitUnitWithNameOffset then
						unit = player:InitUnitWithNameOffset(unitPlopper.UnitType, unitPlopper.UnitNameOffset, plot:GetX(), plot:GetY())
					else
						unit = player:InitUnit(unitPlopper.UnitType, plot:GetX(), plot:GetY())
					end

					if unitPlopper.Embarked then
						unit:Embark()
					end
				end
			end
		end,
		Deplop =
		function( plot )
			for i = 0, plot:GetNumUnits() - 1 do
				local unit = plot:GetUnit(i)
				if unit then
					unit:Kill( true, -1 )
				end
			end
		end
	}

	resourcePlopper =
	{
		ResourceType = -1,
		ResourceAmount = 1,
		Plop =
		function(plot)
			if resourcePlopper.ResourceType ~= -1 then
				plot:SetResourceType( resourcePlopper.ResourceType, resourcePlopper.ResourceAmount )
			end
		end,
		Deplop =
		function(plot)
			plot:SetResourceType(-1)
		end
	}

	improvementPlopper =
	{
		ImprovementType = -1,
		Pillaged = false,
		HalfBuilt = false,
		Plop =
		function( plot )
			if improvementPlopper.ImprovementType ~= -1 then
				plot:SetImprovementType(improvementPlopper.ImprovementType)
				plot:SetImprovementPillaged( improvementPlopper.Pillaged )
			end
		end,
		Deplop =
		function( plot )
			plot:SetImprovementType(-1)
		end
	}

	g_CityPlopper =
	{
		Plop =
		function( plot )
			if plopperSettings.Player ~= -1 then
				local player = Players[plopperSettings.Player]
				if player then
					player:InitCity(plot:GetX(), plot:GetY())
				end
			end
		end,
		Deplop =
		function( plot )
			local city = plot:GetPlotCity()
			if city then
				city:Kill()
			end
		end
	}

	AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_DEBUG,
		{[MouseEvents.LButtonUp] = function()
			local x, y = GetMouseOverHex()
			local plot = GetPlot( x, y )
			local activePlayer = Players[Game.GetActivePlayer()]
			local debugItem1 = UI.GetInterfaceModeDebugItemID1()
			local debugItem2 = UI.GetInterfaceModeDebugItemID2()
			if debugItem1 == 0 then
				activePlayer:InitCity( x, y )
			elseif debugItem1 == 1 then
				activePlayer:InitUnit( debugItem2, x, y )
			elseif debugItem1 == 2 then
				plot:SetImprovementType( debugItem2 )
			elseif debugItem1 == 3 then
				plot:SetRouteType( debugItem2 )
			elseif debugItem1 == 4 then
				plot:SetFeatureType( debugItem2 )
			elseif debugItem1 == 5 then
				plot:SetResourceType( debugItem2, 5 )
			-- Plopper
			elseif debugItem1 == 6
				and type(plopperSettings) == "table"
				and type(plopperSettings.Plopper) == "table"
				and type(plopperSettings.Plopper.Plop) == "function"
			then
				plopperSettings.Plopper.Plop( plot )
				return true -- Do not allow the interface mode to be set back to INTERFACEMODE_SELECTION
			end
			return SetInterfaceModeSelectionTrue()
		end,
		[MouseEvents.RButtonDown] = function()
			local plot = GetPlot( GetMouseOverHex() )
			local debugItem1 = UI.GetInterfaceModeDebugItemID1()
			-- Plopper
			if debugItem1 == 6
				and type(plopperSettings) == "table"
				and type(plopperSettings.Plopper) == "table"
				and type(plopperSettings.Plopper.Plop) == "function"
			then
				plopperSettings.Plopper.Plop( plot )
			end
			return true
		end,
		[MouseEvents.LButtonDown] = function() return true end, -- Trap LButtonDown
		[MouseEvents.RButtonUp] = function() return true end, -- Trap RButtonUp
	})
	g_PlopperSettings, g_UnitPlopper, g_ResourcePlopper, g_ImprovementPlopper = plopperSettings, unitPlopper, resourcePlopper, improvementPlopper
end
--==========================================================
-- Selection & Moveto
--==========================================================
do
	local function EndMovement()
		--debug_print( "EndMovement" )
	--[[
		if g_EatNextUp == true then
			g_EatNextUp = false
			return
		end
	--]]
		if IsTouchScreenEnabled() then
			SetInterfaceMode( INTERFACEMODE_SELECTION )
		end
		Events.DisplayMovementIndicator( false )
		local shiftKeyDown = UI.ShiftKeyDown()
		local altKeyDown = UI.AltKeyDown()
		local ctrlKeyDown = UI.CtrlKeyDown()
		local x, y = GetMouseOverHex()
		local plot = GetPlot( x, y )
		local unit = GetHeadSelectedUnit()

		if plot and unit then
			if UI.IsCameraMoving() and not Game.GetAllowRClickMovementWhileScrolling() then
				--debug_print( "Blocked by moving camera" )
				--Events.ClearHexHighlights()
	--			HideUnitPath()
				return false
			end

	--		Game.SetEverRightClickMoved( true )

			-- Is there someone here that we COULD bombard perhaps?
			local rivalTeamID = unit:GetDeclareWarRangeStrike( plot )
			if rivalTeamID ~= -1 then
				UIManager:SetUICursor( 0 )
				Events.SerialEventGameMessagePopup{
					Type  = ButtonPopupTypes.BUTTONPOPUP_DECLAREWARRANGESTRIKE,
					Data1 = rivalTeamID,
					Data2 = x,
					Data3 = y
				}
				return true
			-- Visible enemy... bombardment?
			elseif plot:IsVisibleEnemyUnit( unit:GetOwner() ) or plot:IsEnemyCity( unit ) then

				-- Already some combat going on in there, just exit
				if plot:IsFighting() then
					return true
				elseif unit:CanMove() and unit:CanRangeStrikeAt( x, y, true, false ) then -- true = NeedWar, false = isNoncombatAllowed
					Game.SelectionListGameNetMessage( GAMEMESSAGE_PUSH_MISSION, unit:GetDomainType() == DOMAIN_AIR and MissionTypes.MISSION_MOVE_TO or MissionTypes.MISSION_RANGE_ATTACK, x, y, 0, false, shiftKeyDown) -- Air strikes are moves... yep
					return true
				end
			end

			if not gk_mode then
				-- Garrison in a city
				local city = plot:GetPlotCity()
				if city and city:GetOwner() == unit:GetOwner() and unit:IsCanAttack() then
					local cityOwner = Players[city:GetOwner()]
					if not cityOwner:IsMinorCiv() and not city:GetGarrisonedUnit() and unit:GetDomainType() == DOMAIN_LAND then
						Game.SelectionListGameNetMessage( GAMEMESSAGE_PUSH_MISSION, MissionTypes.MISSION_GARRISON, x, y, 0, false, shiftKeyDown )
						return true
					end
				end
			end

			-- Is unit already in target plot ?
			if not shiftKeyDown and unit:AtPlot( plot ) then
				--debug_print("Game.SelectionListGameNetMessage( GAMEMESSAGE_DO_COMMAND, COMMAND_CANCEL_ALL )")
				Game.SelectionListGameNetMessage( GAMEMESSAGE_DO_COMMAND, COMMAND_CANCEL_ALL )
			-- No visible enemy to bombard, just move
			else
				--debug_print("Game.SelectionListMove( plot,", altKeyDown, shiftKeyDown, ctrlKeyDown )
				Game.SelectionListMove( plot, altKeyDown, shiftKeyDown, ctrlKeyDown )
			end
		end
		return true
	end

	AssignInterfaceMode( INTERFACEMODE_SELECTION,
		{
			[MouseEvents.RButtonDown] = ShowUnitPath,
			[MouseEvents.RButtonUp] = function() EndMovement() return HideUnitPath() end,
		},
		function()
			BeginUnitRangeStrikeAttack( true )
			ShowUnitMovementRange( GetHeadSelectedUnit() )
		end,
		function()
			EndUnitRangeStrikeAttack()
			return ClearUnitMovementRange()
		end )

	AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_MOVE_TO,
		{
			[MouseEvents.LButtonUp] = EndMovement,
			[MouseEvents.RButtonUp] = EndMovement,
		},
		function()
			ShowUnitMovementRange( GetHeadSelectedUnit() )
			return ShowUnitPath()
		end,
		function()
			ClearUnitMovementRange()
			return HideUnitPath()
		end)

	if IsTouchScreenEnabled() then
		g_InterfaceModeMessageHandler[InterfaceModeTypes.INTERFACEMODE_MOVE_TO][MouseEvents.PointerUp] = EndMovement
		g_InterfaceModeMessageHandler[INTERFACEMODE_SELECTION][MouseEvents.PointerUp] = ClickSelect
		g_InterfaceModeMessageHandler[INTERFACEMODE_SELECTION][MouseEvents.LButtonDoubleClick] =
		function()
			if GetHeadSelectedUnit() then
				SetInterfaceMode( InterfaceModeTypes.INTERFACEMODE_MOVE_TO )
	--			g_EatNextUp = true
			end
		end
	end
end
--==========================================================
-- Attack
--==========================================================
AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_ATTACK,
	function()
		--debug_print("Calling attack into tile")
		local plot = GetPlot( GetMouseOverHex() )
		if plot and plot:IsVisible( Game.GetActiveTeam() ) then
			local unit = GetHeadSelectedUnit()
			if unit and plot:IsVisibleEnemyUnit( unit:GetOwner() ) or plot:IsEnemyCity( unit ) then
				Game.SelectionListMove( plot, false, false, false )
				return true
			end
		end
		return true
	end,
	function()
		local unit = GetHeadSelectedUnit()
		if unit then
			return Events.ShowAttackTargets( unit:GetOwner(), unit:GetID() )
		else
			return SetInterfaceMode( INTERFACEMODE_SELECTION )
		end
	end,
	function()
		return EventsClearHexHighlightStyle( "GUHB" )
	end)

--==========================================================
-- City Ranged Attack
--==========================================================
AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_CITY_RANGE_ATTACK,
	function()
		--debug_print( "City Ranged Attack" )
		local x, y = GetMouseOverHex()
		local plot = GetPlot( x, y )
		-- Don't let the user do a ranged attack on a plot that contains some fighting.
		if plot and not plot:IsFighting() then
			local city = GetHeadSelectedCity()
			if city and city:CanRangeStrikeAt( x, y, true, true ) then
				Game.SelectedCitiesGameNetMessage( GAMEMESSAGE_DO_TASK, TASK_RANGED_ATTACK, x, y )
				Events.SpecificCityInfoDirty( city:GetOwner(), city:GetID(), CITY_UPDATE_TYPE_BANNER )
				SetInterfaceMode( INTERFACEMODE_SELECTION )
			end
		end
		return true
	end,
	function()
		local city = GetHeadSelectedCity()
		--debug_print("Begin City Range Attack",city and city:GetName())
		if city and city:CanRangeStrike() then
			Events.SerialEventCityInfoDirty.Add( function() if GetHeadSelectedCity() ~= city then return SetInterfaceMode( INTERFACEMODE_SELECTION ) end end) -- Still selected?
			EventsSerialEventMouseOverHex.Add( DisplayCityRangeStrikeArrow )
			DisplayCityRangeStrikeArrow( GetMouseOverHex() )
			return DisplayStrikeRange( city, city:Plot(), GameDefines.CITY_ATTACK_RANGE, GameDefines.CAN_CITY_USE_INDIRECT_FIRE == 1 )
		end
		return SetInterfaceMode( INTERFACEMODE_SELECTION )
	end,
	function()
		--debug_print("End City Range Attack")
		UI.ClearSelectedCities() -- required for events to be processed properly
		Events.SerialEventCityInfoDirty.RemoveAll()
		EventsSerialEventMouseOverHex.Remove( DisplayCityRangeStrikeArrow )
		ClearRangeStrikeArrow()
		return ClearStrikeRange()
	end)

--==========================================================
-- Air Strike
--==========================================================
AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_AIRSTRIKE,
	DoUnitRangeStrikeAttack, BeginUnitRangeStrikeAttack, EndUnitRangeStrikeAttack )

--==========================================================
-- Ranged Attack
--==========================================================
AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_RANGE_ATTACK,
	DoUnitRangeStrikeAttack, BeginUnitRangeStrikeAttack, EndUnitRangeStrikeAttack )

g_InterfaceModeMessageHandler[InterfaceModeTypes.INTERFACEMODE_RANGE_ATTACK][KeyEvents.KeyDown] = function( wParam )
	if wParam == Keys.VK_NUMPAD1 or wParam == Keys.VK_NUMPAD3 or wParam == Keys.VK_NUMPAD4 or wParam == Keys.VK_NUMPAD6 or wParam == Keys.VK_NUMPAD7 or wParam == Keys.VK_NUMPAD8 then
		SetInterfaceMode( INTERFACEMODE_SELECTION )
	end
	return DefaultKeyDownHandler( wParam )
end

--==========================================================
-- Nuke
--==========================================================
AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_NUKE,
	nil,
	function()
		local unit = GetHeadSelectedUnit()
		if unit and unit:CanNuke() and not unit:IsOutOfAttacks() then
			-- highlight nukable plots
			local fromPlot = unit:GetPlot()
			local plot, x, y
			for i = 0, CountHexPlots( unit:Range() ) do
				plot = IndexPlot( fromPlot, i )
				if plot then
					x = plot:GetX()
					y = plot:GetY()
					if unit:CanNukeAt( x, y ) then
						EventsSerialEventHexHighlight( ToHexFromGrid{ x=x, y=y }, true, nil, "FireRangeBorder" )
					end
				end
			end
			EventsSerialEventMouseOverHex.Add( DisplayUnitRangeStrikeArrow )
			return DisplayUnitRangeStrikeArrow( GetMouseOverHex() )
		end
		return SetInterfaceMode( INTERFACEMODE_SELECTION )
	end,
	EndUnitRangeStrikeAttack)

--==========================================================
-- Embark, Disembark
--==========================================================
do
	local function doBark( test, mission )
		--debug_print( "Embark/Disembark", mission )
		local x, y = GetMouseOverHex()
		local plot = GetPlot( x, y )
		local unit = plot and GetHeadSelectedUnit()
		if unit and test( unit, plot ) then
			Game.SelectionListGameNetMessage( GAMEMESSAGE_PUSH_MISSION, mission, x, y, 0, false, UI.ShiftKeyDown() )
		end
		return true
	end
	local function showBark( test )
		local unit = GetHeadSelectedUnit()
		if unit then
			local plot
			local unitPlot = unit:GetPlot()
			local unitTeam = unit:GetTeam()
			for i = 1, 6 do
				plot = IndexPlot( unitPlot, i )
				if plot and plot:IsRevealed( unitTeam ) and test( unit, plot ) then
					EventsSerialEventHexHighlight( ToHexFromGrid{ x=plot:GetX(), y=plot:GetY() }, true, g_ColorUnitTile, "GUHB" )
				end
			end
		else
			return SetInterfaceMode( INTERFACEMODE_SELECTION )
		end
	end
	local function hideBark()
		return EventsClearHexHighlightStyle( "GUHB" )
	end
	local function testEmbark( unit, plot )
		return unit:CanEmbarkOnto( unit:GetPlot(), plot )
	end
	local function testDisembark( unit, plot )
		return unit:CanDisembarkOnto( plot )
	end
	AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_EMBARK,
		function() doBark( testEmbark, MissionTypes.MISSION_EMBARK ) end,
		function() showBark( testEmbark ) end,
		hideBark )
	AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_DISEMBARK,
		function() doBark( testDisembark, MissionTypes.MISSION_DISEMBARK ) end,
		function() showBark( testDisembark ) end,
		hideBark )
end

--==========================================================
-- Place Unit
--==========================================================
AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_PLACE_UNIT,
	function()
		--debug_print( "EjectHandler" )
		local x, y = GetMouseOverHex()
		local plot = GetPlot( x, y )
		--debug_print("INTERFACEMODE_PLACE_UNIT")
		local unit = UI.GetPlaceUnit()
		UI.ClearPlaceUnit()
		if unit and plot then
			--debug_print("INTERFACEMODE_PLACE_UNIT - got placed unit")
			local city = unit:GetPlot():GetPlotCity()
			if city then
				--debug_print("INTERFACEMODE_PLACE_UNIT - not nil city")
				if UI.CanPlaceUnitAt(unit, plot) then
					--debug_print("INTERFACEMODE_PLACE_UNIT - Can eject unit")
					--Network.SendCityEjectGarrisonChoice(city:GetID(), x, y )
				end
			end
		end
		return true
	end)

--==========================================================
-- Gift Unit
--==========================================================
AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_GIFT_UNIT,
	function()
		--debug_print( "GiftUnit" )
		local plot = GetPlot( GetMouseOverHex() )
		local activePlayerID = Game.GetActivePlayer()
		local minorPlayerID = UI.GetInterfaceModeValue()
		if Players[activePlayerID] then
			local unit
			for i = 0, plot:GetNumUnits() - 1 do
				local u = plot:GetUnit(i)
				if u:GetOwner() == activePlayerID then
					unit = u
					break
				end
			end
			if unit and unit:CanDistanceGift(minorPlayerID) then
				--debug_print( "Gift unit player ID", activePlayerID, "Other player ID", UI.GetInterfaceModeValue(), "UnitID", unit:GetID(), unit:GetName() )
				Events.SerialEventGameMessagePopup{
					Type = ButtonPopupTypes.BUTTONPOPUP_GIFT_CONFIRM,
					Data1 = activePlayerID,
					Data2 = minorPlayerID,
					Data3 = unit:GetID(),
				}
				SetInterfaceMode( INTERFACEMODE_SELECTION )
			end
		end
		return true
	end,
	function()
		local activePlayer = Players[Game.GetActivePlayer()]
		if activePlayer then
			local minorPlayerID = UI.GetInterfaceModeValue()
			for unit in activePlayer:Units() do
				if unit:CanDistanceGift(minorPlayerID) then
					EventsSerialEventHexHighlight( ToHexFromGrid{ x=unit:GetX(), y=unit:GetY() }, true, g_ColorUnitTile, "GUHB" )
				end
			end
		else
			return SetInterfaceMode( INTERFACEMODE_SELECTION )
		end
	end,
	function()
		return EventsClearHexHighlightStyle( "GUHB" )
	end)

--==========================================================
-- Gift Tile Improvement
--==========================================================
AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_GIFT_TILE_IMPROVEMENT,
	function()
		local x, y = GetMouseOverHex()
		local plot = GetPlot( x, y )
		if plot then
			local activePlayerID = Game.GetActivePlayer()
			local minorPlayerID = UI.GetInterfaceModeValue()
			local minorPlayer = Players[minorPlayerID]
			if minorPlayer then
				if minorPlayer:CanMajorGiftTileImprovementAtPlot(activePlayerID, x, y) then
					Game.DoMinorGiftTileImprovement(activePlayerID, minorPlayerID, x, y)
				end
				SetInterfaceMode( INTERFACEMODE_SELECTION )
			end
		end
		return true
	end,
	function()
		local activePlayerID = Game.GetActivePlayer()
		local minorPlayer = Players[UI.GetInterfaceModeValue()]
		if minorPlayer then
			local city = minorPlayer:GetCapitalCity()
			if city then
				local cityPlot = city:Plot()
				local plot, x, y
				-- highlight the improvable plots
				for i = 0, CountHexPlots( GameDefines.MINOR_CIV_RESOURCE_SEARCH_RADIUS ) do
					plot = IndexPlot( cityPlot, i )
					if plot then
						x = plot:GetX()
						y = plot:GetY()
						if minorPlayer:CanMajorGiftTileImprovementAtPlot(activePlayerID, x, y) then
							EventsSerialEventHexHighlight( ToHexFromGrid{ x=x, y=y }, true, g_ColorGiftTileImprovement, "GUHB" )
						end
					end
				end
				return
			end
		end
		return SetInterfaceMode( INTERFACEMODE_SELECTION )
	end,
	function()
		return EventsClearHexHighlightStyle( "GUHB" )
	end)

--==========================================================
-- Airlift
--==========================================================
AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_AIRLIFT,
	nil,
	function()
		local unit = GetHeadSelectedUnit()
		if unit then
			local unitPlot = unit:GetPlot()
			if unit:CanAirlift(unitPlot, false) then
				for iPlotLoop = 0, GetNumPlots()-1, 1 do
					local plot = GetPlotByIndex(iPlotLoop)
					local x = plot:GetX()
					local y = plot:GetY()
					if unit:CanAirliftAt(unitPlot, x, y) then
						EventsSerialEventHexHighlight( ToHexFromGrid{ x=x, y=y }, true, nil, "MovementRangeBorder" )
					end
				end
				return
			end
		end
		return SetInterfaceMode( INTERFACEMODE_SELECTION )
	end,
	function()
		return EventsClearHexHighlightStyle( "MovementRangeBorder" )
	end)

--==========================================================
-- Paradrop
--==========================================================
AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_PARADROP,
	nil,
	function()
		local unit = GetHeadSelectedUnit()
		if unit then
			local unitPlot = unit:GetPlot()
			local plot, x, y
			if unit:CanParadrop(unitPlot, false) then
			for i = 0, CountHexPlots( unit:GetDropRange() ) do
					plot = IndexPlot( unitPlot, i )
					if plot then
						x, y = plot:GetX(), plot:GetY()
						if unit:CanParadropAt(unitPlot,x,y) then
							EventsSerialEventHexHighlight( ToHexFromGrid{ x=x, y=y }, true, nil, "MovementRangeBorder" )
						end
					end
				end
				return
			end
		end
		return SetInterfaceMode( INTERFACEMODE_SELECTION )
	end,
	function()
		return EventsClearHexHighlightStyle( "MovementRangeBorder" )
	end)

--==========================================================
-- Airsweep
--==========================================================
AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_AIR_SWEEP,
	nil, BeginUnitRangeStrikeAttack, EndUnitRangeStrikeAttack )

--==========================================================
-- Rebase
--==========================================================
AssignInterfaceMode( InterfaceModeTypes.INTERFACEMODE_REBASE,
	nil,
	function()
		local unit = GetHeadSelectedUnit()
		if unit then
			local unitPlot = unit:GetPlot()
			local plot, x, y, hex
			for i = 0, CountHexPlots( unit:Range() * GameDefines.AIR_UNIT_REBASE_RANGE_MULTIPLIER / 100 ) do
				plot = IndexPlot( unitPlot, i )
				if plot then
					x, y = plot:GetX(), plot:GetY()
					hex = ToHexFromGrid{ x=x, y=y }
					EventsSerialEventHexHighlight( hex, true, nil, "MovementRangeBorder" )
					if unit:CanRebaseAt( unitPlot, x, y ) then
						EventsSerialEventHexHighlight( hex, true, g_ColorUnitTile, "GUHB" )
					end
				end
			end
		else
			return SetInterfaceMode( INTERFACEMODE_SELECTION )
		end
	end,
	function()
		EventsClearHexHighlightStyle( "MovementRangeBorder" )
		return EventsClearHexHighlightStyle( "GUHB" )
	end)

--==========================================================
-- Input Handling
--==========================================================
do
	local uiMsgName = {}
	for k, v in pairs(MouseEvents) do uiMsgName[v]=k end
	for k, v in pairs(KeyEvents) do uiMsgName[v]=k end
	uiMsgName[512]=nil
	local wParamName = {}
	for k, v in pairs(Keys) do wParamName[v]=k end

	ContextPtr:SetInputHandler( function( uiMsg, wParam )
	--	if uiMsgName[uiMsg] then print("input handler:", uiMsgName[uiMsg], uiMsg, wParamName[wParam], wParam ) end
		local currentInterfaceModeHandler = g_InterfaceModeMessageHandler[ GetInterfaceMode() ]
		return CallIfNotNil( currentInterfaceModeHandler and currentInterfaceModeHandler[uiMsg] or DefaultMessageHandler[uiMsg], wParam )
	end)
end

--==========================================================
-- City Screen
--==========================================================
local g_UnitFlagState, g_CityBannerState

Events.SerialEventEnterCityScreen.Add( function()
	-- Can get to city screen by C++ which bypasses lua selection code
	SetInterfaceMode( INTERFACEMODE_SELECTION )
	g_UnitFlagState = Controls.UnitFlagManager:IsHidden()
	g_CityBannerState = Controls.CityBannerManager:IsHidden()
	Controls.UnitFlagManager:SetHide( true )
	Controls.CityBannerManager:SetHide( true )
	Controls.CityView:SetHide( false )
	Controls.WorldView:SetHide( true )
	Controls.ScreenEdgeScrolling:SetHide( true )
	-- Grid is always shown in city screen (even if user currently has it off).
	if not OptionsManager.GetGridOn() then
		Events.SerialEventHexGridOn()
	end
end)

Events.SerialEventExitCityScreen.Add( function()
	-- Just in case...
	SetInterfaceMode( INTERFACEMODE_SELECTION )
	Controls.UnitFlagManager:SetHide( g_UnitFlagState )
	Controls.CityBannerManager:SetHide( g_CityBannerState )
	Controls.CityView:SetHide( true )
	Controls.WorldView:SetHide( false )
	Controls.ScreenEdgeScrolling:SetHide( not OptionsManager.GetFullscreen() )
	-- Grid is hidden when leaving the city screen (unless the user had it turned on when entering the city screen)
	if not OptionsManager.GetGridOn() then
		Events.SerialEventHexGridOff()
	end
	UI.SetDirty( GameData_DIRTY_BIT, true )
	return RequestYieldDisplay()
end)

--==========================================================
-- Process Interface Mode Change
--==========================================================
local function UpdateCursor( interfaceMode )
	-- update the cursor to reflect this mode - these cursor are defined in Civ5CursorInfo.xml
	return UIManager:SetUICursor( g_InterfaceModeCursors[ interfaceMode ] or 0 ) -- 0 is default cursor
end

Events.InterfaceModeChanged.Add( function( oldInterfaceMode, newInterfaceMode )
	--debug_print("Interface Mode Changed from", g_InterfaceModeNames[oldInterfaceMode], "to", g_InterfaceModeNames[newInterfaceMode])
--	if oldInterfaceMode ~= newInterfaceMode or newInterfaceMode == INTERFACEMODE_SELECTION then -- game engine already filters
	CallIfNotNil( g_OldInterfaceModeChangeHandler[oldInterfaceMode] )
	CallIfNotNil( g_NewInterfaceModeChangeHandler[newInterfaceMode] )
	return UpdateCursor( newInterfaceMode )
end)

Events.ActivePlayerTurnEnd.Add( function()
	return UIManager:SetUICursor(1) -- busy
end)

Events.ActivePlayerTurnStart.Add( function()
	return UpdateCursor( GetInterfaceMode() )
end)

local function UpdateRecommendations( isSelected )
	--debug_print("UpdateRecommendations	isSelected", isSelected)
	RequestYieldDisplay()

	local activePlayerID = Game.GetActivePlayer()
	local activePlayer = Players[activePlayerID]

	local EventsGenericWorldAnchor = Events.GenericWorldAnchor.Call
	-- workers - clear old list first
	if g_WorkerSuggestHighlightPlots then
		for _, v in pairs(g_WorkerSuggestHighlightPlots) do
			if v.plot then
				EventsGenericWorldAnchor( WORLD_ANCHOR_WORKER, false, v.plot:GetX(), v.plot:GetY(), v.buildType )
			end
		end
	end
	g_WorkerSuggestHighlightPlots = nil

	-- founders - clear old list first
	if g_FounderSuggestHighlightPlots then
		for _, v in pairs(g_FounderSuggestHighlightPlots) do
			EventsGenericWorldAnchor( WORLD_ANCHOR_SETTLER, false, v:GetX(), v:GetY(), -1 )
		end
	end
	g_FounderSuggestHighlightPlots = nil

	if isSelected then
		if UI.CanSelectionListWork() then
			g_WorkerSuggestHighlightPlots = activePlayer:GetRecommendedWorkerPlots()
			if g_showTileRecommendations then
				for _, v in pairs(g_WorkerSuggestHighlightPlots) do
					if v.plot then
						EventsGenericWorldAnchor( WORLD_ANCHOR_WORKER, true, v.plot:GetX(), v.plot:GetY(), v.buildType )
					end
				end
			end
		end
		if UI.CanSelectionListFound() and activePlayer:GetNumCities() > 0 then
			g_FounderSuggestHighlightPlots = activePlayer:GetRecommendedFoundCityPlots()
			if g_showTileRecommendations then
				for _, v in pairs(g_FounderSuggestHighlightPlots) do
					EventsGenericWorldAnchor( WORLD_ANCHOR_SETTLER, true, v:GetX(), v:GetY(), -1 )
				end
			end
		end
	end
end

local function RefreshUnit()
	--debug_print( "RefreshUnit", g_InterfaceModeNames[GetInterfaceMode()], "GetHeadSelectedCity", GetHeadSelectedCity() and  GetHeadSelectedCity():GetName(), "GetHeadSelectedUnit", GetHeadSelectedUnit()and GetHeadSelectedUnit():GetName(), "Last unit", g_lastUnit and g_lastUnit:GetName() )
	local unit = GetHeadSelectedUnit()
	if unit ~= g_lastUnit then
		g_lastUnit = unit
		local interfaceMode = GetInterfaceMode()
		if interfaceMode == INTERFACEMODE_CITY_RANGE_ATTACK then
		elseif interfaceMode == INTERFACEMODE_SELECTION then
			BeginUnitRangeStrikeAttack( true )
			ShowUnitMovementRange( GetHeadSelectedUnit() )
		else
			SetInterfaceMode( INTERFACEMODE_SELECTION )
		end
		return UpdateRecommendations( unit )
	elseif unit then
		if g_isFastAutoUnitCycle and not unit:CanMove() and not unit:IsPromotionReady() then --not unit:IsBusy() and not unit:IsReadyToMove() and GetAutoUnitCycle() then
			--debug_print("Unit is done")
			SetInterfaceMode( INTERFACEMODE_SELECTION ) -- game engine does nothing if already in selection mode
			return Game.CycleUnits( true, true, false ) -- bool bClear, bool bForward, bool bWorkers
		elseif not UI.CanDoInterfaceMode( GetInterfaceMode() ) then
			SetInterfaceMode( INTERFACEMODE_SELECTION ) -- game engine does nothing if already in selection mode
		end
		--debug_print("RefreshMovementAndStrikeRanges", unit:GetOwner(), unit:GetID(), unit:GetName(), "IsReadyToMove", unit:IsReadyToMove(), "IsCanAttackRanged", unit:IsCanAttackRanged(), "CanNuke", unit:CanNuke(), "CanMove", unit:CanMove(), "CanDoInterfaceMode", UI.CanDoInterfaceMode( GetInterfaceMode() ) )
		if unit:IsCanAttackRanged() then -- or unit:CanNuke()
			if unit:IsOutOfAttacks() then
				EventsSerialEventMouseOverHex.Remove( DisplayUnitRangeStrikeArrow )
				ClearRangeStrikeArrow()
				SetInterfaceMode( INTERFACEMODE_SELECTION ) -- game engine does nothing if already in selection mode
			else
				DisplayUnitRangeStrikeArrow( GetMouseOverHex() ) -- needed for units which may attack multiple times
				DisplayUnitStrikeRange( unit )
			end
		end
		return ShowUnitMovementRange( unit )
	end
end
Events.SerialEventUnitInfoDirty.Add( RefreshUnit )
--Events.UnitShouldDimFlag.Add( RefreshUnit )
Events.UnitShouldDimFlag.Add(
function( playerID, unitID )
	if unitID == GetSelectedUnitID() then
		RefreshUnit()
	end
end)

--[[
Events.UnitSelectionCleared.Add( function()
	--debug_print( "UnitSelectionCleared", g_InterfaceModeNames[GetInterfaceMode()], "GetHeadSelectedCity", GetHeadSelectedCity(), "GetHeadSelectedUnit", GetHeadSelectedUnit()and GetHeadSelectedUnit():GetName()  )
	return UpdateRecommendations( false )
end)
--]]

local function UpdateOptions()
	g_showUnitPredictiveStrikeRange = UserInterfaceSettings.PredictiveRange ~= 0
	g_showTileRecommendations = not OptionsManager.IsNoTileRecommendations()
	g_isFastAutoUnitCycle = OptionsManager.GetAutoUnitCycle() and OptionsManager.GetQuickSelectionAdvanceEnabled()
	UpdateRecommendations( GetHeadSelectedUnit() )
	return SetInterfaceMode( INTERFACEMODE_SELECTION )
end
UpdateOptions()
Events.GameOptionsChanged.Add( UpdateOptions )

--[[
Events.SerialEventUnitDestroyed.Add( function( playerID, unitID )
	if playerID == Game.GetActivePlayer() then
		return RequestYieldDisplay()
	end
end)
--]]
do
	local alertTable = {}
	local mustRefreshAlerts = false
	local g_InstanceManager = StackInstanceManager( "AlertMessageInstance", "AlertMessageLabel", Controls.AlertStack )
	local g_PopupIM = StackInstanceManager( "PopupText", "Anchor", Controls.PopupTextContainer )

	Events.GameplayAlertMessage.Add( function( text )
		local newAlert = { text = text, elapsedTime = 0, shownYet = false }
		insert( alertTable, newAlert )
		mustRefreshAlerts = true
	end)

	Events.GameplaySetActivePlayer.Add( function() --( iActivePlayer, iPrevActivePlayer )
		-- Reset the alert table and display
		alertTable = {}
		g_InstanceManager:ResetInstances()
		-- Kill All PopupText
		g_PopupIM:ResetInstances()
		mustRefreshAlerts = false
	end)

	ContextPtr:SetUpdate( function(fDTime)
		if #alertTable > 0 then
			for _, v in ipairs( alertTable ) do
				if v.shownYet == true then
					v.elapsedTime = v.elapsedTime + fDTime
				end
				if v.elapsedTime >= 8 then
					mustRefreshAlerts = true
				end
			end
			if mustRefreshAlerts then
				local newAlertTable = {}
				g_InstanceManager:ResetInstances()
				for _, v in ipairs( alertTable ) do
					if v.elapsedTime < 8 then
						v.shownYet = true
						insert( newAlertTable, v )
					end
				end
				alertTable = newAlertTable
				for _, v in ipairs( alertTable ) do
					local controlTable = g_InstanceManager:GetInstance()
					controlTable.AlertMessageLabel:SetText( v.text )
					Controls.AlertStack:CalculateSize()
					Controls.AlertStack:ReprocessAnchoring()
				end
			end
		end
		mustRefreshAlerts = false
	end)

	Events.AddPopupTextEvent.Add( function( worldPosition, text, delay )
		local instance = g_PopupIM:GetInstance()
		instance.Anchor:SetWorldPosition( worldPosition )
		instance.Text:SetText( text )
		instance.AlphaAnimOut:RegisterAnimCallback( function() g_PopupIM:ReleaseInstance( instance ) end ) -- KillPopupText
		instance.Anchor:BranchResetAnimation()
		instance.SlideAnim:SetPauseTime( delay )
		instance.AlphaAnimIn:SetPauseTime( delay )
		instance.AlphaAnimOut:SetPauseTime( delay + 0.75 )
	end)
end

--==========================================================
--==========================================================
Controls.ScrollTop:RegisterCallback( Mouse.eMouseEnter, Events.SerialEventCameraStartMovingForward.Call )
Controls.ScrollTop:RegisterCallback( Mouse.eMouseExit, Events.SerialEventCameraStopMovingForward.Call )
Controls.ScrollBottom:RegisterCallback( Mouse.eMouseEnter, Events.SerialEventCameraStartMovingBack.Call )
Controls.ScrollBottom:RegisterCallback( Mouse.eMouseExit, Events.SerialEventCameraStopMovingBack.Call )
Controls.ScrollLeft:RegisterCallback( Mouse.eMouseEnter, Events.SerialEventCameraStartMovingLeft.Call )
Controls.ScrollLeft:RegisterCallback( Mouse.eMouseExit, Events.SerialEventCameraStopMovingLeft.Call )
Controls.ScrollRight:RegisterCallback( Mouse.eMouseEnter, Events.SerialEventCameraStartMovingRight.Call )
Controls.ScrollRight:RegisterCallback( Mouse.eMouseExit, Events.SerialEventCameraStopMovingRight.Call )

--==========================================================
--==========================================================
Events.SystemUpdateUI.Add( function( eType )
	if eType == BulkHideUI then
		Controls.BulkUI:SetHide( true )
	elseif eType == BulkShowUI then
		Controls.BulkUI:SetHide( false )
	end
end)

--==========================================================
ContextPtr:SetShowHideHandler( function( bIsHide )
	if not bIsHide then
		Controls.ScreenEdgeScrolling:SetHide( not OptionsManager.GetFullscreen() )
		Controls.WorldViewControls:SetHide( false )
		-- Check to see if we've been kicked.  It's possible that we were kicked while loading into the game.
		if Network.IsPlayerKicked(Game.GetActivePlayer()) then
			-- Display kicked popup.
			Events.SerialEventGameMessagePopup{ Type = ButtonPopupTypes.BUTTONPOPUP_KICKED, Data1 = BY_HOST }
			return SetInterfaceMode( INTERFACEMODE_SELECTION )
		end
	end
end)

--==========================================================
-- Check to see if the world view controls should be hidden
--==========================================================
Events.GameViewTypeChanged.Add( function() --( eNewType )
	local bWorldViewHide = GetGameViewRenderType() == GAMEVIEW_NONE
	Controls.WorldViewControls:SetHide( bWorldViewHide )
	Controls.StagingRoom:SetHide( not bWorldViewHide )
end)

--==========================================================
-- 'Active' (local human) player has changed
--==========================================================
do
	local g_PerPlayerStrategicViewSettings = {}
	Events.GameplaySetActivePlayer.Add( function(iActivePlayer, iPrevActivePlayer)
		if iPrevActivePlayer ~= -1 then
			g_PerPlayerStrategicViewSettings[ iPrevActivePlayer ] = InStrategicView()
		end
		if iActivePlayer ~= -1 and not g_PerPlayerStrategicViewSettings[ iActivePlayer ] == InStrategicView() then
			ToggleStrategicView()
		end
		return SetInterfaceMode( INTERFACEMODE_SELECTION )
	end)
end

--==========================================================
Events.MultiplayerGameAbandoned.Add( function( eReason )
	Events.SerialEventGameMessagePopup{ Type  = ButtonPopupTypes.BUTTONPOPUP_KICKED, Data1 = eReason }
	return SetInterfaceMode( INTERFACEMODE_SELECTION )
end)

--==========================================================
Events.MultiplayerGameLastPlayer.Add( function()
	UI.AddPopup{ Type = ButtonPopupTypes.BUTTONPOPUP_TEXT, Data1 = 800, Option1 = true, Text = "TXT_KEY_MP_LAST_PLAYER" }
	return SetInterfaceMode( INTERFACEMODE_SELECTION )
end)
end)

--==========================================================
-- Support for Modded Add-in UI's
--==========================================================
do
	g_uiAddins = {}
	local Modding = Modding
	local insert = table.insert
	local uiAddins = g_uiAddins
	for addin in Modding.GetActivatedModEntryPoints("InGameUIAddin") do
		local addinFile = Modding.GetEvaluatedFilePath(addin.ModID, addin.Version, addin.File)
		if addinFile then
			print( "Loading MOD InGameUIAddin\n", Modding.GetModProperty(addin.ModID, addin.Version, "Name"), addin.File )
			insert( uiAddins, ContextPtr:LoadNewContext( addinFile.EvaluatedPath:match("(.*)%..*") ) )
		end
	end
end