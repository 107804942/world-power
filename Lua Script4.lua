

local TransPortMissionButton = {
	Name = "TXT_KEY_NAME_SUPER_TRANSPORT",
	Title = "TXT_KEY_TITLE_SUPER_TRANSPORT",
	OrderPriority = 200,
	IconAtlas = "SP_UNIT_ACTION_ATLAS2",
	PortraitIndex = 15,
	ToolTip = function(action, unit)
		local sTooltip;
		local pPlayer = Players[Game:GetActivePlayer()];
		sTooltip = Locale.ConvertTextKey( "TXT_KEY_COND_SUPER_TRANSPORT");
		return sTooltip
	end, -- or a TXT_KEY_ or a function
	Condition = function(action, unit)
		if unit:GetMoves() <= 0 then
			return false
		end
		local pPlayer = Players[Game:GetActivePlayer()];
		local pTeam = Teams[pPlayer:GetTeam()]
		if  pPlayer:GetBuildingClassCount(GameInfo.BuildingClasses.BUILDINGCLASS_HELIOS_BUILDING.ID) > 0 
		and  unit:IsCombatUnit()
		 and not unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_SPACESHIP"].ID)
		 and not unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_CITADEL_DEFENSE"].ID)
		  then
			return true
		else
			return false
		end
	end, -- or nil or a boolean, default is true
	Disabled = function(action, unit)
		local pPlayer = Players[Game:GetActivePlayer()];
		if pPlayer:GetBuildingClassCount(GameInfo.BuildingClasses.BUILDINGCLASS_HELIOS_BUILDING.ID) > 0 then
			return false
		end
		return true;
	end, -- or nil or a boolean, default is false
	Action = function(action, unit, eClick)
	if eClick == Mouse.eRClick then
		return
	end
	local pPlayer = Players[Game:GetActivePlayer()];
	if  pPlayer:IsHuman() then

	---------------------------------------------------------------------------------------------------------------------------------------
	if  unit:GetDomainType()==DomainTypes.DOMAIN_LAND then
		for iPlot in PlotAreaSpiralIterator(unit:GetPlot(), 20, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		if  iPlot:GetNumUnits() == 0  and (not iPlot:IsMountain()) and (not iPlot:IsWater()) and (not iPlot:IsCity()) 
		and ((iPlot:GetOwner()== -1) 
	or  (iPlot:GetOwner()~= -1 and   pPlayer== Players[iPlot:GetOwner()]) 
	or  (iPlot:GetOwner()~= -1 and   pPlayer~= Players[iPlot:GetOwner()]  and (not Players[iPlot:GetOwner()]:IsMajorCiv())) 
	or  (iPlot:GetOwner()~= -1 and   pPlayer~= Players[iPlot:GetOwner()]  and  Players[iPlot:GetOwner()]:IsMajorCiv() and pPlayer:IsAtWarWith(iPlot:GetOwner()) 
	or  (iPlot:GetOwner()~= -1 and   pPlayer~= Players[iPlot:GetOwner()]  and  Players[iPlot:GetOwner()]:IsMajorCiv() and Teams[iPlot:GetTeam()]:IsAllowsOpenBordersToTeam(pPlayer:GetTeam()) ))) then
			  Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(iPlot:GetX(), iPlot:GetY())), true, Vector4(0.0, 1.0, 1.0, 1.0))
			  end
		   end
    if  pPlayer:GetNumSpies() >0  then
		for k, v in pairs(pPlayer:GetEspionageSpies()) do
	        local Plot = Map.GetPlot(v.CityX, v.CityY)
			if Plot~=nil then
				 for spyPlot in PlotAreaSpiralIterator(Plot, 3, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		         if  spyPlot:GetOwner()~= -1 and spyPlot:GetWorkingCity()~=nil and spyPlot:GetWorkingCity()==Plot:GetPlotCity() 
				 and (not spyPlot:IsMountain()) 
				 and (spyPlot:GetNumUnits() == 0)
				 and (not spyPlot:IsWater()) 
				 and (not spyPlot:IsCity()) then
				 if pPlayer== Players[spyPlot:GetOwner()] 
				 or pPlayer:IsAtWarWith(spyPlot:GetOwner()) 
				 or (not Players[spyPlot:GetOwner()]:IsMajorCiv())
				 or (Players[spyPlot:GetOwner()]:IsMajorCiv() and Teams[spyPlot:GetTeam()]:IsAllowsOpenBordersToTeam(pPlayer:GetTeam())) 
				 then
				  Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(spyPlot:GetX(), spyPlot:GetY())), true, Vector4(0.0, 1.0, 1.0, 1.0)) 
				            end 
				         end 
				      end  
			       end
			    end
			end
		end
		---------------------------------------------------------------------------------------------------------------------------------------

	if  unit:GetDomainType()==DomainTypes.DOMAIN_SEA then
		for iPlot in PlotAreaSpiralIterator(unit:GetPlot(), 20, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		if  iPlot:GetNumUnits() == 0  and iPlot:IsWater()  and (not iPlot:IsCity())  
		and ((iPlot:GetOwner()== -1) 
	or  (iPlot:GetOwner()~= -1 and   pPlayer== Players[iPlot:GetOwner()]) 
	or  (iPlot:GetOwner()~= -1 and   pPlayer~= Players[iPlot:GetOwner()]  and (not Players[iPlot:GetOwner()]:IsMajorCiv())) 
	or  (iPlot:GetOwner()~= -1 and   pPlayer~= Players[iPlot:GetOwner()]  and  Players[iPlot:GetOwner()]:IsMajorCiv() and pPlayer:IsAtWarWith(iPlot:GetOwner())  
	or  (iPlot:GetOwner()~= -1 and   pPlayer~= Players[iPlot:GetOwner()]  and  Players[iPlot:GetOwner()]:IsMajorCiv() and Teams[iPlot:GetTeam()]:IsAllowsOpenBordersToTeam(pPlayer:GetTeam()) ))) then
			  Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(iPlot:GetX(), iPlot:GetY())), true, Vector4(0.0, 1.0, 1.0, 1.0))
			     --end
			  end
		   end
    if  pPlayer:GetNumSpies() >0  then
		for k, v in pairs(pPlayer:GetEspionageSpies()) do
	        local Plot = Map.GetPlot(v.CityX, v.CityY)
			if Plot~=nil then
				 for spyPlot in PlotAreaSpiralIterator(Plot, 3, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		         if  spyPlot:GetOwner()~= -1 and spyPlot:GetWorkingCity()~=nil and  spyPlot:GetWorkingCity()==Plot:GetPlotCity() 
				 and spyPlot:IsWater() and spyPlot:GetNumUnits() == 0 
				 and (not spyPlot:IsCity()) then
				 if pPlayer== Players[spyPlot:GetOwner()] 
				 or pPlayer:IsAtWarWith(spyPlot:GetOwner()) 
				 or (not Players[spyPlot:GetOwner()]:IsMajorCiv())
				 or (Players[spyPlot:GetOwner()]:IsMajorCiv() and Teams[spyPlot:GetTeam()]:IsAllowsOpenBordersToTeam(pPlayer:GetTeam())) 
				 then
				  Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(spyPlot:GetX(), spyPlot:GetY())), true, Vector4(0.0, 1.0, 1.0, 1.0)) 
				            end 
				         end 
				      end  
			       end
			    end
			end
		end
		---------------------------------------------------------------------------------------------------------------------------------------
		SpaceBattleCruiserSkill = 3
	end
end
}
LuaEvents.UnitPanelActionAddin(TransPortMissionButton)


	      ---  elseif SpaceBattleCruiserSkill == 3 then
		        local pSelUnit = UI.GetHeadSelectedUnit()		    
				if IsCanTransPortPlot(pSelUnit,pPlot)  then
				pSelUnit:SetXY(pPlot:GetX(), pPlot:GetY());
                pSelUnit:SetMoves(0)
				Events.AddPopupTextEvent(PositionCalculator(pPlot:GetX(), pPlot:GetY()), Locale.ConvertTextKey("TXT_KEY_ALERT_SPY_TRANSPORT",pSelUnit:GetName()),0.1)
				Events.AudioPlay2DSound("AS2D_SPACE_TRANSPORT") 
				end
		
				Events.ClearHexHighlights()
				SpaceBattleCruiserSkill = 0


		--<Row Tag='TXT_KEY_TITLE_SUPER_TRANSPORT'>
			---<Text>[COLOR_MANA]相位传送[ENDCOLOR]</Text>
		--</Row>
		----<Row Tag='TXT_KEY_COND_SUPER_TRANSPORT'>
			--<Text>消耗本回合内所有剩余[ICON_MOVES]移动力进行传送，可瞬移至[COLOR_MIGHT]指定地块[ENDCOLOR](以单位为中心半径20格内可进入的领域地块，或者任意的存在我方间谍的城市附近三格内的可进入的领域地块）。</Text>
		--</Row>

		--<Row Tag='TXT_KEY_ALERT_SPY_TRANSPORT'>
			--<Text>[COLOR_NEGATIVE_TEXT]{@1_name}[ENDCOLOR]传送至此地块！</Text>
		--</Row>
		
		



