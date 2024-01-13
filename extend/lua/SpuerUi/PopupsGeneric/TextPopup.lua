-- TEXT POPUP
-- Simple Text Popup
-- Modified by bc1 from 1.0.3.276 code using Notepad++

if PopupLayouts then
	PopupLayouts[ButtonPopupTypes.BUTTONPOPUP_TEXT or -1] = function( popupInfo )
		-- show/hide the flare
		SetTopImage( popupInfo.Option1 and "topframe.dds", -33 )
		SetBottomImage( popupInfo.Option1 and "bottomframe.dds", -109 )
		SetPopupText( L(popupInfo.Text), popupInfo.Data1 )
		AddButton( L"TXT_KEY_OK_BUTTON" )
	end
end