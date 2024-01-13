-- Barbarian Camp Popup
-- Modified by bc1 from 1.0.3.276 code using Notepad++

if PopupLayouts then
	PopupLayouts[ButtonPopupTypes.BUTTONPOPUP_BARBARIAN_CAMP_REWARD or -1] = function( popupInfo )
		SetTopImage( "BarbarianPopupTop300.dds", -22 )
		local row = (GameInfoCache or GameInfo).Units.UNIT_BARBARIAN_WARRIOR
		if row then
			SetTopIcon( 128, row.PortraitIndex, row.IconAtlas, 20 )
		end
		SetPopupTitle( L"TXT_KEY_POP_BARBARIAN_CLEARED" )
		SetPopupText( L( "TXT_KEY_BARB_CAMP_CLEARED", popupInfo.Data1 ) )
		AddButton( L"TXT_KEY_OK_BUTTON" ) --TXT_KEY_CLOSE
	end
end
