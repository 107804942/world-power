-- CONFIRM CITY TASK POPUP
-- This popup occurs when an action needs confirmation.
-- Modified by bc1 from 1.0.3.276 code using Notepad++

if PopupLayouts then
	PopupLayouts[ButtonPopupTypes.BUTTONPOPUP_CONFIRM_CITY_TASK or -1] = function( popupInfo )
		local cityID = popupInfo.Data1
		local taskID = popupInfo.Data2
		SetTopImage( "AncientRuinsPopupTop300.dds", -22 )
		SetTopIcon( "EnemyCity128.dds", 20 )
		if cityID and taskID then
			SetPopupTitle( UI.GetHeadSelectedCity():GetName():upper() ) --TODO change to cityID
			SetPopupText( taskID == TaskTypes.TASK_RAZE and L"TXT_KEY_POPUP_ARE_YOU_SURE_RAZE" or popupInfo.Text or L"TXT_KEY_POPUP_ARE_YOU_SURE" )
			AddButton( L"TXT_KEY_POPUP_YES", function() Network.SendDoTask( cityID, taskID, -1, -1, false, false, false, false ) end )
		end
		AddButton( L"TXT_KEY_POPUP_NO" )
	end
end