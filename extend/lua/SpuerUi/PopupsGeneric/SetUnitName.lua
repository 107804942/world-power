-- Select Unit Names
-- Modified by bc1 from 1.0.3.276 code using Notepad++

if PopupLayouts then
	local function OnAccept()
		local unit = UI.GetHeadSelectedUnit()
		if unit then
			Network.SendRenameUnit( unit:GetID(), Controls.EditBox:GetText():gsub( "[^ !#$&%(%)%,%.@_%w\128-\254]", "" ):sub(1,15) )
		end
	end
	PopupLayouts[ButtonPopupTypes.BUTTONPOPUP_RENAME_UNIT or -1] = function( popupInfo )
		SetTopImage( "topframe.dds", -33 )
		SetBottomImage( "bottomframe.dds", -109 )
		local unit = UI.GetHeadSelectedUnit()
		if unit then
			SetPopupTitle( L"TXT_KEY_NAME_UNIT_TITLE" )
			Controls.EditBox:SetText( unit:GetNameNoDesc() )
			Controls.Editing:SetHide( false )
			AddButton( L"TXT_KEY_ACCEPT_BUTTON", OnAccept )
			AddButton( L"TXT_KEY_CANCEL_BUTTON" )
			Controls.EditBox:TakeFocus()
		else
			return false
		end
	end
	local VK_RETURN = Keys.VK_RETURN
	local VK_ESCAPE = Keys.VK_ESCAPE
	local KeyDown = KeyEvents.KeyDown
	PopupInputHandlers[ButtonPopupTypes.BUTTONPOPUP_RENAME_UNIT or -1] = function( uiMsg, wParam )
		if uiMsg == KeyDown then
			if wParam == VK_ESCAPE then
				HideWindow()
			elseif wParam == VK_RETURN then
				OnAccept()
			end
			return true
		end
	end
end
