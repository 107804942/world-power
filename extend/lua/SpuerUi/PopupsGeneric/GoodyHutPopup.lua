-- Goody Hut Popup
-- Modified by bc1 from 1.0.3.276 code using Notepad++

if PopupLayouts then
	PopupLayouts[ButtonPopupTypes.BUTTONPOPUP_GOODY_HUT_REWARD or -1] = function( popupInfo )
		SetTopImage( "AncientRuinsPopupTop300.dds", -22 )
		SetTopIcon( 128, 0, "NW_ATLAS", 20 )
		SetPopupTitle( L"TXT_KEY_POP_RUINS_EXPLORED" )
		local row = (GameInfoCache or GameInfo).GoodyHuts[ popupInfo.Data1 ]
		if row then
			SetPopupText( L( row.Description, popupInfo.Data2 or -1 ) )
		end
		AddButton( L"TXT_KEY_OK_BUTTON" ) --TXT_KEY_CLOSE
	end
end