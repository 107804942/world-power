-- CONFIRM COMMAND POPUP
-- This popup occurs when a unit action needs confirmation
-- Modified by bc1 from 1.0.3.276 code using Notepad++

if PopupLayouts then
	local GameInfo = GameInfoCache or GameInfo
	local g_infoSource = {
			[ ActionSubTypes.ACTIONSUBTYPE_PROMOTION or -1 ] = GameInfo.UnitPromotions,
			[ ActionSubTypes.ACTIONSUBTYPE_INTERFACEMODE or -1 ] = GameInfo.InterfaceModes,
			[ ActionSubTypes.ACTIONSUBTYPE_MISSION or -1 ] = GameInfo.Missions,
			[ ActionSubTypes.ACTIONSUBTYPE_COMMAND or -1 ] = GameInfo.Commands,
			[ ActionSubTypes.ACTIONSUBTYPE_AUTOMATE or -1 ] = GameInfo.Automates,
			[ ActionSubTypes.ACTIONSUBTYPE_BUILD or -1 ] = GameInfo.Builds,
			[ ActionSubTypes.ACTIONSUBTYPE_CONTROL or -1 ] = GameInfo.Controls,
			[-1] = nil
	}
	PopupLayouts[ButtonPopupTypes.BUTTONPOPUP_CONFIRMCOMMAND or -1] = function( popupInfo )
		local action = GameInfoActions[ popupInfo.Data1 ]
		local unit = UI.GetHeadSelectedUnit()
		if unit then
			SetPopupTitle( "[COLOR_UNIT_TEXT]"..unit:GetName():upper() )
			SetImage( 256, UI.GetUnitPortraitIcon( unit ) )
		end
		if action then
			local info = ( g_infoSource[ action.SubType ] or {} )[ action.Type ]
			if info then
				SetTopIcon( 64, info.IconIndex or info.PortraitIndex, info.IconAtlas )
			end
			SetPopupText( L("TXT_KEY_POPUP_ARE_YOU_SURE_ACTION", action.TextKey ) )
			AddButton( L"TXT_KEY_POPUP_YES", function() Game.SelectionListGameNetMessage( GameMessageTypes.GAMEMESSAGE_DO_COMMAND, action.CommandType, action.CommandData, -1, 0, popupInfo.Option1 ) end )
		end
		AddButton( L"TXT_KEY_POPUP_NO" )
	end
end
