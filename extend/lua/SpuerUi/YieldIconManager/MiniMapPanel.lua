--==========================================================
-- Modified by bc1 from 1.0.3.276 code using Notepad++
-- allows minimap resizing
--==========================================================

include "StackInstanceManager"

local pairs = pairs

local ContextPtr = ContextPtr
local Controls = Controls
local Events = Events
local GetActivePlayer = Game.GetActivePlayer
local GameViewTypes = GameViewTypes
local GetGameViewRenderType = GetGameViewRenderType
local GetOverlayLegend = GetOverlayLegend
local InStrategicView = InStrategicView
local Mouse = Mouse
local OptionsManager = OptionsManager
local PreGame = PreGame
local SetGameViewRenderType = SetGameViewRenderType
local SS_OBSERVER = SlotStatus.SS_OBSERVER
local ToggleStrategicView = ToggleStrategicView
local UI = UI
local YieldDisplayTypes = YieldDisplayTypes

local g_LegendIM = StackInstanceManager( "LegendKey", "Item", Controls.LegendStack )

local g_width, g_height;
local g_Overlays = GetStrategicViewOverlays()
local g_IconModes = GetStrategicViewIconSettings()
local g_OptionActions = {
	ShowGrid = UI.SetGridVisibleMode,
	ShowYield = UI.SetYieldVisibleMode,
	ShowResources = UI.SetResourceVisibleMode,
	ShowTrade = Events.Event_ToggleTradeRouteDisplay,
	HideRecommendation = LuaEvents.OnRecommendationCheckChanged.Call,
	ShowFeatures = StrategicViewShowFeatures,
	ShowFogOfWar = StrategicViewShowFogOfWar,
	IconMode = SetStrategicViewIconSetting, -- no check box
	OverlayMode = SetStrategicViewOverlay, -- no check box
	ShowCityBanners = function( isChecked )
		LookUpControl( "/InGame/CityBannerManager" ):SetHide( not isChecked )
	end,
	ShowUnitFlags = function( isChecked )
		LookUpControl( "/InGame/UnitFlagManager" ):SetHide( not isChecked )
		LookUpControl( "/InGame/SelectedUnitContainer" ):SetHide( not isChecked )
	end,
	PlotHelpToolTip = function( isChecked )
		Controls.PlotHelpToolTipGrid:SetHide( isChecked )
		LuaEvents.PlotHelpToolTip( not isChecked and Controls )
	end,
}
local g_SaveOptions = {
	CivilianYields = OptionsManager.SetCivilianYields_Cached,
	HideRecommendation = OptionsManager.SetNoTileRecommendations_Cached,
	ShowResources = OptionsManager.SetResourceOn_Cached,
	ShowYield = OptionsManager.SetYieldOn_Cached,
	ShowTrade = OptionsManager.SetShowTradeOn_Cached,
	ShowGrid = OptionsManager.SetGridOn_Cached,
}
local g_GetOptions = {
	CivilianYields = OptionsManager.IsCivilianYields_Cached,
	HideRecommendation = OptionsManager.IsNoTileRecommendations_Cached,
	ShowResources = OptionsManager.GetResourceOn_Cached,
	ShowYield = OptionsManager.GetYieldOn_Cached,
	ShowTrade = OptionsManager.GetShowTradeOn_Cached,
	ShowGrid = OptionsManager.GetGridOn_Cached,
}
local g_YieldDisplayActions = {
	[YieldDisplayTypes.USER_ALL_ON or -1] = { "ShowYield", true },
	[YieldDisplayTypes.USER_ALL_OFF or -1] = { "ShowYield", false },
	[YieldDisplayTypes.USER_ALL_RESOURCE_ON or -1] = { "ShowResources", true },
	[YieldDisplayTypes.USER_ALL_RESOURCE_OFF or -1] = { "ShowResources", false },
[-1] = nil }

local g_PerPlayerMapOptions = {}
local g_MapOptions
local g_MapOptionDefaults = { IconMode = 1, OverlayMode = 1, ShowFeatures = true, ShowFogOfWar = true, ShowCityBanners = true, ShowUnitFlags = true, PlotHelpToolTip = true }
for k, isOption in pairs( g_GetOptions ) do
	g_MapOptionDefaults[k] = isOption()
end

--==========================================================
Events.MinimapTextureBroadcastEvent.Add( function( uiHandle, width, height )--, paddingX )
	Controls.Minimap:SetTextureHandle( uiHandle );
	if width ~= g_width or height ~= g_height then
		g_width, g_height = width, height;
		Controls.Minimap:SetSizeVal( width, height );
		Controls.MinimapPanel:SetSizeVal( width+35, height+87 );
		local EndTurnButton = ContextPtr:LookUpControl( "../ActionInfoPanel/EndTurnButton" );
		if EndTurnButton then
			EndTurnButton:SetOffsetY( height + 10 );
		end
		local OuterStack = ContextPtr:LookUpControl( "../ActionInfoPanel/NotificationPanel/OuterStack" );
		if OuterStack then
			OuterStack:SetOffsetY( height + 50 );
		end
		Controls.OuterStack:CalculateSize();
		Controls.OuterStack:ReprocessAnchoring();
		Controls.PlotHelpToolTipGrid:SetOffsetX( width+70 )
	end
end)
UI.RequestMinimapBroadcast();

--==========================================================
Controls.Minimap:RegisterCallback( Mouse.eLClick, function( _, _, _, x, y )
	Events.MinimapClickedEvent( x, y )
end)

--==========================================================
local function SetLegend( index )
	local info = InStrategicView() and GetOverlayLegend()
	if info then
		Controls.OverlayTitle:LocalizeAndSetText( g_Overlays[ index ] )
		g_LegendIM:ResetInstances();
		for _, v in pairs( info ) do
			local controlTable = g_LegendIM:GetInstance()
			controlTable.KeyColor:SetColor{ x = v.Color.R, y = v.Color.G, z = v.Color.B, w = 1 }
			controlTable.KeyName:LocalizeAndSetText( v.Name )
		end
		Controls.LegendStack:CalculateSize()
		Controls.LegendStack:ReprocessAnchoring()
		Controls.LegendFrame:SetHide(false)
		Controls.LegendFrame:DoAutoSize()
	else
		Controls.LegendFrame:SetHide(true)
	end
	Controls.SideStack:CalculateSize()
	Controls.SideStack:ReprocessAnchoring()
end

--==========================================================
local function UpdateOptionsPanel()
	for key, isChecked in pairs( g_MapOptions ) do
		local control = Controls[key]
		if control then
			control:SetCheck( isChecked )
		end
	end
	Controls.StrategicStack:SetHide( not InStrategicView() )

	Controls.OverlayDropDown:GetButton():LocalizeAndSetText( g_Overlays[g_MapOptions.OverlayMode] )
	SetLegend( g_MapOptions.OverlayMode )
	Controls.IconDropDown:GetButton():LocalizeAndSetText( g_IconModes[g_MapOptions.IconMode] )

	Controls.StrategicStack:CalculateSize()
	Controls.MainStack:CalculateSize()
	Controls.OptionsPanel:DoAutoSize()

	Controls.SideStack:CalculateSize()
	Controls.SideStack:ReprocessAnchoring()
end

--==========================================================
Controls.StrategicViewButton:RegisterCallback( Mouse.eLClick, function()
	if PreGame.GetSlotStatus( GetActivePlayer() ) == SS_OBSERVER then
		-- Observer gets to toggle the world view completely off.
		local eViewType = GetGameViewRenderType();
		if eViewType == GameViewTypes.GAMEVIEW_NONE then
			SetGameViewRenderType(GameViewTypes.GAMEVIEW_STANDARD);
		elseif eViewType == GameViewTypes.GAMEVIEW_STANDARD then
			SetGameViewRenderType(GameViewTypes.GAMEVIEW_STRATEGIC);
		else
			SetGameViewRenderType(GameViewTypes.GAMEVIEW_NONE);
		end
	else
		ToggleStrategicView();
	end
end)

--==========================================================
local function OpenMapOptions()
	UpdateOptionsPanel()
	Controls.OptionsPanel:SetHide( false );
	Controls.SideStack:CalculateSize();
	Controls.SideStack:ReprocessAnchoring();
end

local function CloseMapOptions()
	Controls.OptionsPanel:SetHide( true );
	Controls.SideStack:CalculateSize();
	Controls.SideStack:ReprocessAnchoring();
end

Controls.MapOptionsButton:RegisterCallback( Mouse.eLClick, function()
	if Controls.OptionsPanel:IsHidden() then
		OpenMapOptions()
	else
		CloseMapOptions()
	end
end)
--TODO open on mouseover / close on mouseexit
--Controls.MapOptionsButton:RegisterCallback( Mouse.eMouseEnter, OpenMapOptions );
--Controls.MapOptionsButton:RegisterCallback( Mouse.eMouseExit, CloseMapOptions );

local function SetMapOptionCheck( key, isChecked )
	Controls[ key ]:SetCheck( isChecked )
	g_MapOptions[ key ] = isChecked
end

local function SetMapOptionAction( key, isChecked )
	g_MapOptions[ key ] = isChecked
	if g_SaveOptions[ key ] then
		g_SaveOptions[ key ]( isChecked )
		OptionsManager.CommitGameOptions( PreGame.IsHotSeatGame() )
	end
	if g_OptionActions[ key ] then
		g_OptionActions[ key ]( isChecked )
	end
end

for k in pairs( g_MapOptionDefaults ) do
	local control = Controls[k]
	if control then
		control:RegisterCheckHandler( function( isChecked ) SetMapOptionAction( k, isChecked ) end )
	end
end

--==========================================================
-- 'Active' (local human) player has changed
--==========================================================
local function OnActivePlayerChanged( ActivePlayerID, PrevActivePlayerID )
	g_PerPlayerMapOptions[ PrevActivePlayerID ] = g_MapOptions
	g_MapOptions = g_PerPlayerMapOptions[ ActivePlayerID ]
	if not g_MapOptions then
		-- Initialize with the defaults
		g_MapOptions = {}
		for k, v in pairs( g_MapOptionDefaults ) do g_MapOptions[k] = v end
		g_PerPlayerMapOptions[ ActivePlayerID ] = g_MapOptions
	end
	-- Take the current options and apply them to the game
	for k, action in pairs( g_OptionActions ) do
		action( g_MapOptions[k] )
	end
	-- Because outside contexted will also want to access the settings, we have to push them back to the OptionsManager
	if PreGame.IsHotSeatGame() then
		local isChanged = false
		for k, isOption in pairs( g_GetOptions ) do
			if isOption() ~= g_MapOptions[k] and g_SaveOptions[k] then
				g_SaveOptions[k]( g_MapOptions[k] )
				isChanged = true
			end
		end
		-- We will tell the manager to not write them out
		if isChanged then
			OptionsManager.CommitGameOptions( true )
		end
	end
	UpdateOptionsPanel()
	CloseMapOptions()
end

local function PopulatePulldown( control, modes, action )
	for i, text in pairs( modes ) do
		local controlTable = {}
		control:BuildEntry( "InstanceOne", controlTable )
		controlTable.Button:SetVoid1( i )
		controlTable.Button:LocalizeAndSetText( text )
	end
	control:GetButton():LocalizeAndSetText( modes[1] )
	control:CalculateInternals()
	control:RegisterSelectionCallback( action )
end
PopulatePulldown( Controls.OverlayDropDown, g_Overlays, function( index )
	SetMapOptionAction( "OverlayMode", index )
	Controls.OverlayDropDown:GetButton():LocalizeAndSetText( g_Overlays[index] )
	SetLegend( index )
end)
PopulatePulldown( Controls.IconDropDown, g_IconModes, function( index )
	SetMapOptionAction( "IconMode", index )
	Controls.IconDropDown:GetButton():LocalizeAndSetText( g_IconModes[index] )
end)

-- UpdateStrategicViewToggleTT
local controlInfo = GameInfo.Controls.CONTROL_TOGGLE_STRATEGIC_VIEW
if type(controlInfo) == "table" then
	local hotKey = controlInfo.HotKey;
	if type(hotKey) == "string" then
		local keyDesc = Locale.GetHotKeyDescription( hotKey, controlInfo.CtrlDown, controlInfo.AltDown, controlInfo.ShiftDown )
		if type(keyDesc) == "string" then
			Controls.StrategicViewButton:SetToolTipString( Locale.ConvertTextKey("TXT_KEY_POP_STRATEGIC_VIEW_TT") .. " (" .. keyDesc .. ")" )
		end
	end
end
Events.SequenceGameInitComplete.Add( function()
	OnActivePlayerChanged( GetActivePlayer(), -1 )
	Events.GameplaySetActivePlayer.Add( OnActivePlayerChanged );
	Events.GameOptionsChanged.Add( UpdateOptionsPanel )
	Events.StrategicViewStateChanged.Add( function(isStrategicView)
		Controls.NormalStack:SetHide(isStrategicView)
		if isStrategicView then
			Controls.StrategicViewButton:SetTexture( "MainWorldButton.dds" );
			Controls.StrategicMO:SetTexture( "MainWorldButton.dds" );
			Controls.StrategicHL:SetTexture( "MainWorldButtonHL.dds" );
		else
			Controls.StrategicViewButton:SetTexture( "MainStrategicButton.dds" );
			Controls.StrategicMO:SetTexture( "MainStrategicButton.dds" );
			Controls.StrategicHL:SetTexture( "MainStrategicButtonHL.dds" );
		end
		UpdateOptionsPanel()
	end)
	Events.SerialEventHexGridOn.Add( function() SetMapOptionCheck( "ShowGrid", true ) end )
	Events.SerialEventHexGridOff.Add( function() SetMapOptionCheck( "ShowGrid", false ) end )
	if Events.Event_ToggleTradeRouteDisplay then
		Events.Event_ToggleTradeRouteDisplay.Add(
		function( isChecked )
			SetMapOptionCheck( "ShowTrade", isChecked )
		end)
	elseif Controls.ShowTrade then
		Controls.ShowTrade:SetHide( true )
	end
	Events.RequestYieldDisplay.Add( function( t )
		t = g_YieldDisplayActions[ t ]
		if t then
			return SetMapOptionCheck( t[1], t[2] )
		end
	end)
end)
