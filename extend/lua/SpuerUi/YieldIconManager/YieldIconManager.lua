--==========================================================
-- Yield Icon Manager
-- Re-written by bc1 using Notepad++
-- compatible with all Civ V and BE versions
-- fix quantity erratic display & make code more efficient
-- add compatibility with "DLL - Various Mod Components" v63
-- show relevant resources in addition to yields
--==========================================================

print("EUI Yield Icon Manager loading...")

include "UserInterfaceSettings"
local UserInterfaceSettings = UserInterfaceSettings

include "GameInfoCache" -- warning! booleans are true, not 1, and use iterator ONLY with table field conditions, NOT string SQL query
local GameInfo = GameInfoCache

include "FLuaVector"
local ColorRed = Color( 1, 0, 0, 1 )
local ColorWhite = Color( 1, 1, 1, 1 )

--==========================================================
-- Minor lua optimizations
--==========================================================

local pairs = pairs
local insert = table.insert
local remove = table.remove
local sort = table.sort
local ceil = math.ceil
local floor = math.floor
local max = math.max

local ContextPtr = ContextPtr
local GridToWorld = GridToWorld
local HexToWorld = HexToWorld
local ToHexFromGrid = ToHexFromGrid
local ToGridFromHex = ToGridFromHex
local GetPlot = Map.GetPlot
local GetPlotByIndex = Map.GetPlotByIndex
local MaxPlotIndex = Map.GetNumPlots() - 1
local RefreshYieldVisibleMode = UI.RefreshYieldVisibleMode
local eRClick = Mouse.eRClick
local Players = Players
local ShiftKeyDown = UI.ShiftKeyDown
local GetActiveTeam = Game.GetActiveTeam
local GetActivePlayer = Game.GetActivePlayer
local InStrategicView = InStrategicView

-- Globals
local Controls = Controls
local g_HiddenControls = Controls.Scrap
local g_VisibleControls = Controls.YieldStore
local g_OptionsPanel = Controls.OptionsPanel
local g_Anchors = {}
local g_SpareYieldIcons = {}
local g_Textures = { "YieldAtlas.dds", "YieldAtlas.dds", "YieldAtlas.dds", "YieldAtlas.dds", "YieldAtlas_128_Culture.dds", "YieldAtlas_128_Faith.dds" } --, "YieldAtlas_128_Tourism.dds" }
local g_Offsets = { 0, 128 , 256, 384, 0, 0, 0 }
-- compatibility with "DLL - Various Mod Components" extra yields
local g_Sort = { "Resources", "Improvements", "Features", "Yields" }
local g_All = { Yields = {}, Resources = {}, Improvements = {}, Features = {} }
local g_Names = { Yields = "TXT_KEY_PEDIA_YIELD_LABEL", Resources = "TXT_KEY_CIV5_RESOURCES_HEADING", Features = "TXT_KEY_CIV5_FEATURES_HEADING", Improvements = "TXT_KEY_CIV5_IMPROVEMENTS_HEADING" }
local p = GetPlotByIndex(0)
local g_CalculateYields = g_All.Yields -- masked by later declaration on purpose
local g_Funcs = { Resources = p.GetResourceType, Improvements = p.GetRevealedImprovementType, Features = p.GetFeatureType,
	Yields = function( plot, _, i )
		if g_CalculateYields[i]( plot, i-1, true ) > 0 then
			return i
		end
	end
}
local g_Controls = {}
local g_PlayerSettings = {}
local g_ActiveSettings, g_CalculateYields, g_Resources, g_Improvements, g_Features, g_CityIcon

for k, all in pairs( g_All ) do
	if k=="Yields" then
		for i = 1, YieldTypes.NUM_YIELD_TYPES do
			all[i] = p.CalculateYield
			local row = GameInfo.Yields[ i-1 ]
			if row then
				if row.ImageTexture then
					g_Textures[i] = row.ImageTexture
				elseif row.ImageOffset then
					g_Offsets[i] = row.ImageOffset
				end
			end
		end
		-- Ugly vanilla kludge
		if p.GetCulture then
			all[5] = p.GetCulture
		end
	else
		for row in GameInfo[k]() do
			all[ row.ID ] = row._Texture or nil
		end
	end
end

local MapIsWrapX = Map.IsWrapX()
local MapIsWrapY = Map.IsWrapY()
local MapXmax, MapYmax = Map.GetGridSize()
local MapHalfXmax = floor(MapXmax/2)
local MapHalfYmax = floor(MapYmax/2)
--usage: returns index of 2nd plot relative to 1st plot
local function PlotIndex( X, Y, x, y )
	-- offset & world wrap
	y = y - Y
	if MapIsWrapY then y = (y+MapHalfYmax) % MapYmax - MapHalfYmax end
	x = x - X - floor( y/2 )
	if MapIsWrapX then x = (x+MapHalfXmax) % MapXmax - MapHalfXmax end
	-- [4r..6r[
	if x<0 and y>=0 then
		local r = max(-x, y)
		return 3*r*r+2*r+1+x+y
	-- [0..2r]
	elseif x>=0 and x>=-y then
		local r = max(x, x+y)
		if r==0 then
			return 0
		end
		return 3*r*r-2*r+1-y
	-- [2r..4r]
	else --if x<=0 and x<=-y then
		local r = max(-y, -x-y)
		return 3*r*r+1-x
	end
end

--==========================================================
-- Update the controls to reflect the current known improvement
-- Assumes valid anchor and plot
local function UpdateImprovement( anchor, plot )
	local iconRow = anchor.Row0
	local icon = anchor.Improvement
	local texture = g_Improvements[ plot:GetRevealedImprovementType( GetActiveTeam() ) ] or plot:IsCity() and g_CityIcon
	if texture then
		if icon then
			icon:SetHide( false )
		else
			if not iconRow then
				ContextPtr:BuildInstanceForControlAtIndex( "Row0", anchor, anchor.Stack, 0 )
				iconRow = anchor.Row0
			end
			ContextPtr:BuildInstanceForControlAtIndex( "Improvement", anchor, iconRow, 0 )
			icon = anchor.Improvement
			icon:SetTextureSizeVal( 256, 256 )
		end
		icon:SetTexture( texture )
		icon:SetColor( plot:IsImprovementPillaged() and ColorRed or ColorWhite )
	elseif icon then
		icon:SetHide( true )
	else
		return
	end
	iconRow:CalculateSize()
	return anchor.Stack:ReprocessAnchoring()
end

--==========================================================
-- Update the controls to reflect the current known resource or feature
-- Assumes valid anchor and plot
local function UpdateResource( anchor, plot )
	local iconRow = anchor.Row0
	local icon = anchor.Resource
	local texture = g_Resources[ plot:GetResourceType( GetActiveTeam() ) ] or g_Features[ plot:GetFeatureType() ]
	if texture then
		if icon then
			icon:SetHide( false )
		else
			if not iconRow then
				ContextPtr:BuildInstanceForControlAtIndex( "Row0", anchor, anchor.Stack, 0 )
				iconRow = anchor.Row0
			end
			ContextPtr:BuildInstanceForControl( "Resource", anchor, iconRow )
			icon = anchor.Resource
			icon:SetTextureSizeVal( 256, 256 )
		end
		icon:SetTexture( texture )
	elseif icon then
		icon:SetHide( true )
	else
		return
	end
	iconRow:CalculateSize()
	return anchor.Stack:ReprocessAnchoring()
end

--==========================================================
-- Update the controls to reflect the current known yields
-- Assumes valid anchor and plot
local function UpdateYields( anchor, plot )

	local j, amount, index, yieldIcon, amountIcon
	local yields = {}

	-- calculate terrain yields
	for i, calculateYield in pairs( g_CalculateYields ) do
		amount = calculateYield( plot, i-1, true )
		-- amount = math.random( 0, 12 )
		if amount > 0 then
			insert( yields, i*1024 + amount )
		end
	end

	-- show yield icons
	local n = #yields
	local i = 1
	local k = 1
	local iconRow = anchor.Row1
	-- must be the same threshold as below
	if n>4 then
		j = ceil( n/2 )
	else
		j = n
	end
	repeat
		for i = i, j do
			index = yields[i]
			amount = index % 1024
			index = (index - amount) / 1024
			yieldIcon = anchor[k]
			if yieldIcon then
				yieldIcon:ChangeParent( iconRow )
			else
				yieldIcon = remove( g_SpareYieldIcons )
				if yieldIcon then
					yieldIcon:ChangeParent( iconRow )
				else
					yieldIcon = {}
					ContextPtr:BuildInstanceForControl( "Yield", yieldIcon, iconRow )
					yieldIcon = yieldIcon.Yield
--					yieldIcon:SetTextureSizeVal( 128, 128 )
				end
				anchor[k] = yieldIcon
			end
			k = k + 1
			yieldIcon:SetTexture( g_Textures[ index ] or "YieldAtlas.dds" )
			yieldIcon:SetTextureOffsetVal( g_Offsets[ index ] or 0, amount > 4 and 512 or (amount - 1) * 128 )

			-- add yield count icon
			if amount > 5 then
				amountIcon = anchor[k]
				if amountIcon then
					amountIcon:ChangeParent( yieldIcon )
				else
					amountIcon = remove( g_SpareYieldIcons )
					if amountIcon then
						amountIcon:ChangeParent( yieldIcon )
					else
						amountIcon = {}
						ContextPtr:BuildInstanceForControl( "Yield", amountIcon, yieldIcon )
						amountIcon = amountIcon.Yield
--						amountIcon:SetTextureSizeVal( 128, 128 )
					end
					anchor[k] = amountIcon
				end
				k = k + 1
				amountIcon:SetTexture( "YieldAtlas.dds" )
				amountIcon:SetTextureOffsetVal( amount > 12 and 256 or ((amount + 2) % 4) * 128, amount > 9  and 768 or 640 )
			end
		end
		if j < n then
			i = j + 1
			j = n
			iconRow = anchor.Row2
			if not iconRow then
				ContextPtr:BuildInstanceForControl( "Row2", anchor, anchor.Stack )
				iconRow = anchor.Row2
			end
		else
			break
		end
	until false
	-- discard unused icons
	for _ = k, #anchor do
		yieldIcon = remove( anchor )
		yieldIcon:ChangeParent( g_HiddenControls )
		insert( g_SpareYieldIcons, yieldIcon )
	end
	-- must be the same threshold as above
	if n > 4 then -- iconRow is row2
		anchor.Row1:CalculateSize()
--	elseif anchor.Row2 then
--		anchor.Row2:CalculateSize()
	end
	iconRow:CalculateSize()
	anchor.YieldsDirty = false
	return anchor.Stack:ReprocessAnchoring()
end

--==========================================================
-- Plot Yield Show / Hide
Events.ShowHexYield.Add(
function( x, y, isShown )
	local plot = GetPlot( x, y )
	if plot then

		local index = plot:GetPlotIndex()
		local anchor = g_Anchors[ index ]

		if isShown and plot:IsRevealed( GetActiveTeam(), false ) then
			if anchor then
				if not anchor.IsVisible then
					if anchor.YieldsDirty then
						UpdateYields( anchor, plot )
					end
					-- make it visible
					anchor.Anchor:ChangeParent( g_VisibleControls )
					anchor.IsVisible = true
				end
			else
				-- set up new anchor: we do this only once per plot
				anchor = {}
				ContextPtr:BuildInstanceForControl( "Anchor", anchor, g_VisibleControls )
				anchor.IsVisible = true
				g_Anchors[ index ] = anchor
				x, y = GridToWorld( x, y )
				anchor.Anchor:SetWorldPositionVal( x, y, 0 )
				UpdateImprovement( anchor, plot )
				UpdateResource( anchor, plot )
				UpdateYields( anchor, plot )
			end

		elseif anchor and anchor.IsVisible then
			-- hide it
			anchor.Anchor:ChangeParent( g_HiddenControls )
			anchor.IsVisible = false
		end
	end
end)

--==========================================================
-- Plot Icons Update Events
do
	Events.HexYieldMightHaveChanged.Add( function( x, y )
		local plot = GetPlot( x, y )
		if plot then
			local anchor = g_Anchors[ plot:GetPlotIndex() ]
			if anchor then
				if anchor.IsVisible then
					UpdateYields( anchor, plot )
				else
					anchor.YieldsDirty = true -- will need to be updated when made visible again
				end
			end
		end
	end)
	local function UpdateImprovementHex( hexPosX, hexPosY )
		local plot = GetPlot( ToGridFromHex( hexPosX, hexPosY ) )
		local anchor = plot and g_Anchors[ plot:GetPlotIndex() ]
		if anchor then
			return UpdateImprovement( anchor, plot )
		end
	end
	Events.SerialEventImprovementIconCreated.Add( UpdateImprovementHex )
	Events.SerialEventImprovementIconDestroyed.Add( UpdateImprovementHex )

	local function UpdateResourceHex( hexPosX, hexPosY )
		local plot = GetPlot( ToGridFromHex( hexPosX, hexPosY ) )
		local anchor = plot and g_Anchors[ plot:GetPlotIndex() ]
		if anchor then
			if anchor.IsVisible then
				UpdateYields( anchor, plot )
			else
				anchor.YieldsDirty = true -- will need to be updated when made visible again
			end
			return UpdateResource( anchor, plot )
		end
	end
	Events.SerialEventRawResourceIconCreated.Add( UpdateResourceHex )
	Events.SerialEventRawResourceIconDestroyed.Add( UpdateResourceHex )
	Events.SerialEventFeatureCreated.Add( UpdateResourceHex )
	Events.SerialEventFeatureDestroyed.Add( UpdateResourceHex )
end

local emptyTable = {}

local function UpdateAllYieldIconsDependingOnView( isStrategicView )
	local t = g_ActiveSettings
	local enables = t.Enable
	g_Resources = not isStrategicView and enables.Resources and t.Resources or emptyTable
	g_CityIcon = not isStrategicView and UserInterfaceSettings.ShowCityIcon ~= 0 and "sv_ancient_africa_medium_city.dds"
	g_Improvements = not isStrategicView and enables.Improvements and t.Improvements or emptyTable
	g_Features = not isStrategicView and enables.Features and t.Features or emptyTable
	g_CalculateYields = isStrategicView and g_All.Yields or (enables.Yields and t.Yields or emptyTable)
	for index, anchor in pairs( g_Anchors ) do
		local plot = GetPlotByIndex( index )
		UpdateImprovement( anchor, plot )
		UpdateResource( anchor, plot )
		if anchor.IsVisible then
			UpdateYields( anchor, plot )
		else
			anchor.YieldsDirty = true
		end
	end
end

local function UpdateAllYieldIcons()
	return UpdateAllYieldIconsDependingOnView( InStrategicView() )
end

--==========================================================
-- Initialize controls
local stack = Controls.OptionsStack
for _, what in pairs( g_Sort ) do
	local all = g_All[ what ]
	local info = GameInfo[ what ]
	local isYield = what == "Yields" and 1 or 0
	local instance = {}
	local list = {}
	ContextPtr:BuildInstanceForControl( "OptionsEnable", instance, stack )
	local check = instance.OptionsEnable
	ContextPtr:BuildInstanceForControl( "OptionsStack", instance, stack )
	local stack = instance.OptionsStack -- !!! local change of destination stack to sub stack
	local controls = { list = list, stack = stack, check = check }
	g_Controls[ what ] = controls
	check:GetTextButton():LocalizeAndSetText( g_Names[ what ] )
	check:RegisterCheckHandler( function( isChecked )
		g_ActiveSettings.Enable[ what ] = isChecked
		stack:SetAlpha( isChecked and 1 or 0.5 )
		UpdateAllYieldIcons()
		if GetActivePlayer() == 0 then
			UserInterfaceSettings[ "MAP_OPTIONS_"..what:upper() ] = isChecked and 1 or 0
		end
	end)
	local function SetSetting( ID, isChecked )
		g_ActiveSettings[ what ][ ID ] = isChecked and all[ ID ] or nil
		if GetActivePlayer() == 0 then
			UserInterfaceSettings[ "MAP_OPTIONS_"..info[ ID-isYield ].Type] = isChecked and 1 or 0
		end
	end
	local function OptionCheckHandler( isChecked, ID )
		if ShiftKeyDown() then
			for ID, control in pairs( list ) do
				SetSetting( ID, isChecked )
				control:SetCheck( isChecked )
			end
		else
			SetSetting( ID, isChecked )
		end
		UpdateAllYieldIcons()
	end
	local func = g_Funcs[ what ]
	local currentID, set, idx
	local function FindOnMap( ID ) -- func, info, isYield
		if currentID ~=ID then
			currentID = ID
			idx = 0
			set = {}
			local activeTeam = GetActiveTeam()
			local GetPlotByIndex = GetPlotByIndex
			local func = func
			local set = set
			local insert = insert
			local plot = GetPlotByIndex(0)
			local IsRevealed = plot.IsRevealed
			for i = 0, MaxPlotIndex do
				plot = GetPlotByIndex(i)
				if IsRevealed( plot, activeTeam, true ) and func( plot, activeTeam, ID ) == ID then
					insert( set, plot )
				end
			end
			local player = Players[GetActivePlayer()]
			local capital = player and player:GetCapitalCity()
			if capital then
				local x = capital:GetX()
				local y = capital:GetY()
				sort( set, function(a,b) return PlotIndex(x,y,a:GetX(),a:GetY()) < PlotIndex(x,y,b:GetX(),b:GetY()) end )
			end
		end
		idx = idx % #set + 1
		local plot = set[idx]
		if plot then
			UI.LookAt( plot )
			local hex = ToHexFromGrid{ x=plot:GetX(), y=plot:GetY() }
			Events.GameplayFX( hex.x, hex.y, -1 )
			local n = plot:GetNumResource()
			return Events.AddPopupTextEvent( HexToWorld( hex ), (n>0 and (n>1 and n or"")..(info[ID-isYield].IconString or " ") or "")..info[ID-isYield]._Name..(#set>1 and"[NEWLINE]"..idx.."/"..#set or ""), 0 )
		else
			Events.AudioPlay2DSound( "AS2D_EVENT_NOTIFICATION_NEUTRAL" )
		end
	end
	local icon, row
	for ID, texture in pairs( all ) do
		ContextPtr:BuildInstanceForControl( "CheckBox", instance, stack )
		check = instance.CheckBox
		icon = instance.Portrait
		if isYield==1 then
			icon:SetTextureOffsetVal( (g_Offsets[ID]or 0)+32, 32 )
			icon:SetTexture( g_Textures[ID] )
		else
			icon:SetTextureSizeVal( 256, 256 )
			icon:SetTexture( texture )
		end
		row = info[ ID-isYield ]
		icon:SetToolTipString( row and row._Name )
		check:SetVoid1( ID )
		check:RegisterCheckHandler( OptionCheckHandler )
		if func then
			check:RegisterCallback( eRClick, FindOnMap )
		end
		list[ ID ] = check
	end
	if isYield~=1 then
		stack:SortChildren( function( a, b ) return a and b and a:GetToolTipString() < b:GetToolTipString() end )
	end
	stack:CalculateSize()
end

--==========================================================
-- Move option controls
Events.SequenceGameInitComplete.Add( function()
	local MiniMapOptionsPanel = LookUpControl( "/InGame/WorldView/MiniMapPanel/OptionsPanel" )
	if MiniMapOptionsPanel then
		stack:CalculateSize()
		local x, y = stack:GetSizeVal()
		if y<64 then y=64 elseif y>300 then y=300 end
		g_OptionsPanel:SetSizeVal( x+46, y+85 )
		g_OptionsPanel:ChangeParent( MiniMapOptionsPanel )
		Controls.OptionsScrollPanel:SetSizeVal( x, y )
		Controls.OptionsScrollPanel:CalculateInternalSize()
		Controls.OptionsScrollPanel:ReprocessAnchoring()
	end
end)

--==========================================================
-- 'Active' (local human) player has changed
local function OnGameplaySetActivePlayer() -- activePlayerID, prevActivePlayerID )
	local t = g_PlayerSettings[ GetActivePlayer() ]
	if not t then
		t = { Enable = {} }
		local i
		for what, all in pairs( g_All ) do
			local tt = {}
			local isYield = what == "Yields" and 1 or 0
			for row in GameInfo[ what ]() do
				i = row.ID+isYield
				tt[ i ] = UserInterfaceSettings[ "MAP_OPTIONS_"..row.Type ] ~= 0 and all[ i ] or nil
			end
			t[ what ] = tt
			t.Enable[ what ] = UserInterfaceSettings[ "MAP_OPTIONS_"..what:upper() ] ~= 0
		end
		g_PlayerSettings[ GetActivePlayer() ] = t
	end
	local enables = t.Enable
	for what, controls in pairs( g_Controls ) do
		controls.check:SetCheck( enables[ what ] )
		controls.stack:SetAlpha( enables[ what ] and 1 or 0.5 )
		local tt = t[ what ]
		for ID, control in pairs( controls.list ) do
			control:SetCheck( tt[ ID ] )
		end
	end
	g_ActiveSettings = t
	UpdateAllYieldIcons()
	return RefreshYieldVisibleMode()
end
Events.GameplaySetActivePlayer.Add( OnGameplaySetActivePlayer )
OnGameplaySetActivePlayer()

if Events.StrategicViewStateChanged then
	Events.StrategicViewStateChanged.Add( function( isStrategicView )
		g_VisibleControls:SetOffsetY( isStrategicView and 60 or -60 )
		g_OptionsPanel:SetHide( isStrategicView )
		return UpdateAllYieldIconsDependingOnView( isStrategicView )
	end)
end

Events.GameOptionsChanged.Add( UpdateAllYieldIcons )

--==========================================================
-- on shutdown we need to get our children back,
-- or they will get duplicated on future hotload
-- and we'll assert clearing the registered button handler
ContextPtr:SetShutdown( function()
	g_OptionsPanel:ChangeParent( g_HiddenControls )
end)

print("EUI Yield Icon Manager load complete")

