
		-- Update Production icon
		if controls.CityBannerProductionImage then
			local unitProduction = city:GetProductionUnit();
			local buildingProduction = city:GetProductionBuilding();
			local projectProduction = city:GetProductionProject();
			local processProduction = city:GetProductionProcess();
			local noProduction = false;

			if unitProduction ~= -1 then
				local portraitOffset, portraitAtlas = UI.GetUnitPortraitIcon(unitProduction, city:GetOwner());			
				if IconHookup( portraitOffset, 45, portraitAtlas, controls.CityBannerProductionImage ) then
					controls.CityBannerProductionImage:SetHide( false );
					   if isActivePlayerCity then
					   controlTable.Button:SetVoid2(unitProduction)
					   controls.CityBannerProductionButton:SetToolTipCallback(ToolTipHandler);---新增
                       controls.CityBannerProductionButton:SetToolTipType( "City_Tooltip" ) ---新增
					   end
				else
					controls.CityBannerProductionImage:SetHide( true );
				end
			elseif buildingProduction ~= -1 then
				local thisBuildingInfo = GameInfo.Buildings[buildingProduction];
				if IconHookup( thisBuildingInfo.PortraitIndex, 45, thisBuildingInfo.IconAtlas, controls.CityBannerProductionImage ) then
					controls.CityBannerProductionImage:SetHide( false );
				else
					controls.CityBannerProductionImage:SetHide( true );
				end
			elseif projectProduction ~= -1 then
				local thisProjectInfo = GameInfo.Projects[projectProduction];
				if IconHookup( thisProjectInfo.PortraitIndex, 45, thisProjectInfo.IconAtlas, controls.CityBannerProductionImage ) then
					controls.CityBannerProductionImage:SetHide( false );
				else
					controls.CityBannerProductionImage:SetHide( true );
				end
			elseif processProduction ~= -1 then
				local thisProcessInfo = GameInfo.Processes[processProduction];
				if IconHookup( thisProcessInfo.PortraitIndex, 45, thisProcessInfo.IconAtlas, controls.CityBannerProductionImage ) then
					controls.CityBannerProductionImage:SetHide( false );
				else
					controls.CityBannerProductionImage:SetHide( true );
				end
			else -- really should have an error texture
				controls.CityBannerProductionImage:SetHide(true);
			end
			
			if isActivePlayerCity then
    			controls.CityBannerProductionButton:RegisterCallback( Mouse.eLClick, OnProdClick ); ------按钮
    			controls.CityBannerProductionButton:SetVoids( city:GetID(), nil );
    			controls.BannerButton:SetDisabled( false );
			end

		end



		 -- controls.CityBannerProductionButton:SetVoid2(iUnit)
       



--==========================================================
-- 
-- 
--==========================================================
include "GameInfoActualCache"
local GameInfo = GameInfoCache

include "StackInstanceManager"
include "IconHookup"


local g_TooltipControls = {}
TTManager:GetTypeControlTable( "City_Tooltip", g_TooltipControls )

Controls.UnittipTimer4:RegisterAnimCallback
( function()
		local controls = g_TooltipControls
		controls.Details4:SetHide( false )
		controls.IconStack4:SetWrapWidth( 32 )
		controls.IconStack4:CalculateSize()
		controls.PromotionText4:SetHide( false )
		controls.Grid4:ReprocessAnchoring()
		controls.Grid4:DoAutoSize()
end)

local City_PromotionIconIM = StackInstanceManager( "PromotionIcon4", "Image4", g_TooltipControls.IconStack4 )

--==========================================================
-- city Tooltips
--==========================================================
function ToolTipHandler( button )

		local id = button:GetVoid2()
		local controls = g_TooltipControls

		tip = GetHelpTextForUnit2(id)
        local thisUnitInfo = GameInfo.Units[id]

		controls.Text4:SetText( tip )
		local i = 0
		local promotionText = {}
		local promotionIcon
		City_PromotionIconIM:ResetInstances()
		
		if not( thisUnitInfo.IsTrade ) then
		local thisUnitType = { UnitType = thisUnitInfo.Type }
		
        for row in GameInfo.Unit_FreePromotions( thisUnitType ) do
		unitPromotion = GameInfo.UnitPromotions[ row.PromotionType ]
		if unitPromotion~=nil  then
		if  unitPromotion.ShowInUnitPanel ~= 0 and unitPromotion.ShowInTooltip ~= 0 then
		    promotionIcon = City_PromotionIconIM:GetInstance()
			IconHookup( unitPromotion.PortraitIndex, 32, unitPromotion.IconAtlas, promotionIcon.Image4 )
			table.insert( promotionText, Locale.ConvertTextKey( unitPromotion.Description) )
			      end
			   end
		    end
		end
	
		controls.Details4:SetHide( true )
		controls.PromotionText4:SetText( table.concat( promotionText, "[NEWLINE]" ) )
		controls.PromotionText4:SetHide( #promotionText ~= 1 )
		controls.IconStack4:SetWrapWidth( math.ceil( i / math.ceil( i / 10 ) ) * 26 )
		controls.IconStack4:CalculateSize()
		controls.Grid4:ReprocessAnchoring()
		controls.Grid4:DoAutoSize()
		Controls.UnittipTimer4:SetToBeginning()
        Controls.UnittipTimer4:SetPauseTime(0) 
		Controls.UnittipTimer4:Reverse()
		
end







             if city:IsProductionUnit() then
				 controls.CityBannerProductionButton:SetVoid2(city:GetProductionUnit())
				 controls.CityBannerProductionButton:SetToolTipCallback(ToolTipHandler);---新增
                 controls.CityBannerProductionButton:SetToolTipType( "City_Tooltip" ) ---新增
			else
			     controls.CityBannerProductionButton:SetToolTipCallback(ToolTipHandler2);---新增
                 controls.CityBannerProductionButton:SetToolTipType( "City_Tooltip" ) ---新增
            end



            elseif city:IsProductionBuilding() then
			     --controls.CityBannerProductionButton:SetVoid2(city:GetProductionBuilding())
				 controls.CityBannerProductionButton:SetToolTipCallback(ToolTipHandler2);---新增
                 controls.CityBannerProductionButton:SetToolTipType( "City_Tooltip" ) ---新增
           elseif city:IsProductionProject() then
			     --controls.CityBannerProductionButton:SetVoid2(city:GetProductionProject())
				 controls.CityBannerProductionButton:SetToolTipCallback(ToolTipHandler2);---新增
                 controls.CityBannerProductionButton:SetToolTipType( "City_Tooltip" ) ---新增
		   elseif city:IsProductionProcess() then
		         --controls.CityBannerProductionButton:SetVoid2(city:GetProductionProcess())
				 controls.CityBannerProductionButton:SetToolTipCallback(ToolTipHandler2);---新增
                 controls.CityBannerProductionButton:SetToolTipType( "City_Tooltip" ) ---新增