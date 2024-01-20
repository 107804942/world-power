   controlTable.Button:SetVoid2(iUnit)
         controlTable.Button:SetToolTipCallback(ToolTipHandler);---新增
         controlTable.Button:SetToolTipType( "City_UnitTooltip" ) ---新增



		 if unitProduction ~= -1 then
		 	Controls.ProductionPortrait:SetVoid2(unitProduction)
			Controls.ProductionPortrait:SetToolTipCallback(ToolTipHandler);---新增
            Controls.ProductionPortrait:SetToolTipType( "City_UnitTooltip" ) ---新增
		else
		    Controls.ProductionPortrait:SetToolTipString( strToolTip );
		end





		controlTable = g_UnitInstanceManager:GetInstance(); ----新建控件


		self.m_Instance

			 if unitProduction ~= -1 then
		 	Controls.ProductionPortraitButton.Button::SetVoid2(unitProduction)
			Controls.ProductionPortraitButton.Button:SetToolTipCallback(ToolTipHandler);---新增
            Controls.ProductionPortraitButton.Button:SetToolTipType( "City_UnitTooltip" ) ---新增
		else
		    Controls.ProductionPortrait:SetToolTipString( strToolTip );
		end



	local UnitToolTipCall = LuaEvents.UnitToolTip.Call
	Controls.UnitPortraitButton:SetToolTipCallback( function( control )
    control:SetToolTipCallback( function() return UnitToolTipCall( UI.GetHeadSelectedUnit(), Locale.ConvertTextKey("TXT_KEY_CURRENTLY_SELECTED_UNIT"), "----------------" ) end )
	control:SetToolTipType( "EUI_UnitTooltip" )
	end)