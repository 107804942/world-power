-- Golden Age Popup
-- Modified by bc1 from 1.0.3.276 code using Notepad++

if PopupLayouts then
	PopupLayouts[ButtonPopupTypes.BUTTONPOPUP_GOLDEN_AGE_REWARD or -1] = function( popupInfo )
		SetTopImage( "GoldenAgePopupTop300.dds", -28 )
		Controls.GoldenAgeAnim:SetHide( false )
		SetPopupTitle( "[COLOR:255:221:0:255]" .. L"TXT_KEY_POP_GOLDEN_AGE_BEGIN" )
		SetPopupText( L"TXT_KEY_GOLDEN_AGE_FLAVOR" )
		AddButton( L"TXT_KEY_OK_BUTTON" ) --TXT_KEY_CLOSE
	end
end
