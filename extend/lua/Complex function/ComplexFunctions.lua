-- DateCreated: 2023
--------------------------------------------------------------
include("Rog_SaveUtils.lua"); MY_MOD_NAME = "世界强权";
include("PlotIterators.lua");
include("FunctionUtilities.lua")
include("FLuaVector.lua")
include("IconSupport.lua");
include("InstanceManager")


function IsUsingWP()
	local WPID = "41450919-c52c-406f-8752-5ea34be32b2d"
	for _, mod in pairs(Modding.GetActivatedMods()) do
		if (mod.ID == WPID) then
			return true
		end
	end
	return false
end


local WpModActive = IsUsingWP()

if    WpModActive  then

local ANGEnergy = 
	{[0] = GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_0, [1] = GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_1, 
	 [2] = GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_2, [3] = GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_3,
	 [4] = GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_4, [5] = GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_5}


local BattleCruiser = GameInfoTypes["UNIT_SPACESHIP"]


	local ATBTEnergy = 
	{[0] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA,   [1] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_1, 
	 [2] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_2, [3] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_3,
	 [4] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_4, [5] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_5, 
	 [6] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_6, [7] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_7, 
	 [8] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_8, [9] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_9, 
	 [10]= GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_10, [11] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_11,
	 [12]= GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_12, [13] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_13, 
	 [14]= GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_14, [15] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_15,
	 [16]= GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_16, [17] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_17, 
	 [18]= GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_18}


	function SpaceBattleCruiserMana(iPlayer, iUnit)
	local pPlayer = Players[iPlayer];
	if pPlayer == nil  or pPlayer:IsBarbarian() then
	 	return
	         end
	local pUnit = pPlayer:GetUnitByID(iUnit)
	if pUnit == nil  then
	 	return
	        end
			if pUnit:GetUnitType() == BattleCruiser and load(pUnit, "SpaceBattleCruiserEnergy") == nil then
			save(pUnit, "SpaceBattleCruiserEnergy", 4)
			pUnit:SetHasPromotion(GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_4, true)
		end
	end
Events.SerialEventUnitCreated.Add(SpaceBattleCruiserMana)



function SpaceBattleCruiserManaForHuman(iPlayer, iUnit, iPlotX, iPlotY)
		local pPlayer = Players[iPlayer]
		local pUnit = pPlayer:GetUnitByID(iUnit)
		if not 	pPlayer:IsHuman() then
		return
	         end

		if  pPlayer:HasWonder(GameInfoTypes.BUILDING_SPACE_FORTRESS) then

				if pUnit:GetUnitType() == BattleCruiser and load(pUnit, "SpaceBattleCruiserEnergy") < 8 then

					local city = pUnit:GetPlot():GetPlotCity() or pUnit:GetPlot():GetWorkingCity();
					  if city == nil then 
					    save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 1)
		                end

						  if city ~= nil then 
						  if city:GetOwner()~=iPlayer  or (not city:IsHasBuilding(GameInfoTypes["BUILDING_WAR_MACHINE_FACTORY"]))    then 
					    save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 1)
		                   end
						end
						
					if city ~= nil and city:IsHasBuilding(GameInfoTypes["BUILDING_WAR_MACHINE_FACTORY"]) and city:GetOwner()==iPlayer then
					 if load(pUnit, "SpaceBattleCruiserEnergy") == 7 then 
				  	save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 1)
					end
					  if load(pUnit, "SpaceBattleCruiserEnergy") <7 then 
					save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 2)
					   end
					end

					for i = 0, 8 do
						pUnit:SetHasPromotion(ATBTEnergy[i], (i == load(pUnit, "SpaceBattleCruiserEnergy")))
					end
				end
			end

   --------------------------------------------------------------------------------------------------------------------------------------------
           if  pPlayer:HasWonder(GameInfoTypes.BUILDING_SPACE_FORTRESS) then

				if pUnit:GetUnitType() == BattleCruiser and load(pUnit, "SpaceBattleCruiserEnergy") < 18 then

					local city = pUnit:GetPlot():GetPlotCity() or pUnit:GetPlot():GetWorkingCity();
					  if city == nil then 
					    save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 1)
		                end

						  if city ~= nil then 
						  if city:GetOwner()~=iPlayer  or (not city:IsHasBuilding(GameInfoTypes["BUILDING_WAR_MACHINE_FACTORY"]))    then 
					    save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 1)
		                   end
						end
						
					if city ~= nil and city:IsHasBuilding(GameInfoTypes["BUILDING_WAR_MACHINE_FACTORY"]) and city:GetOwner()==iPlayer then
					  if load(pUnit, "SpaceBattleCruiserEnergy") == 17 then 
				  	save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 1)
					end
					  if load(pUnit, "SpaceBattleCruiserEnergy") <17 then 
					save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") + 2)
					   end
					end
	
					for i = 0, 18 do
				pUnit:SetHasPromotion(ATBTEnergy[i], (i == load(pUnit, "SpaceBattleCruiserEnergy")))
		     end
	     end
     end
end
 GameEvents.UnitDoTurn.Add(SpaceBattleCruiserManaForHuman)




	local lButtonDown = false
	local rButtonDown = false
	local SpaceBattleCruiserSkill = 0;
	local highlightedPlots = {};
	function CheckSpaceBattleCruiserButtonValidity(unit)
		for i = 0, 7 do
			if unit:IsHasPromotion(ATBTEnergy[i]) then
				return false;
			end
		end
		return true;
	end

	function CheckSpaceBattleCruiserButtonValidity2(unit)
		for i = 0, 3 do
			if unit:IsHasPromotion(ATBTEnergy[i]) then
				return false;
			end
		end
		return true;
	end


function DisplayCruiserHitArrow()

	local unit = UI.GetHeadSelectedUnit();
	if unit and unit:GetUnitType() == BattleCruiser then
		attacker = unit
	end
	
	if attacker == nil then
		return
	end

    if SpaceBattleCruiserSkill == 1 then
	Events.ClearHexHighlights()
	local DisplayPlot = Map.GetPlot(UI.GetMouseOverHex())
	--get bombard end hex
	for iPlot in PlotAreaSpiralIterator(DisplayPlot, 1, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(iPlot:GetX(), iPlot:GetY())), true, Vector4(0.0, 1.0, 1.0, 1.0))
		Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(DisplayPlot:GetX(), DisplayPlot:GetY())), true, Vector4(0.0, 1.0, 1.0, 1.0))	
		end
	end
end	
Events.SerialEventMouseOverHex.Add(DisplayCruiserHitArrow);

local SpaceBattleCruiserMissionButton = {
		Name = "TXT_KEY_NAME_SPACE_BATTLECRUISER",
		Title = "TXT_KEY_TITLE_SPACE_BATTLECRUISER",
		OrderPriority = 300,
		IconAtlas = "SP_UNIT_ACTION_ATLAS2",
		PortraitIndex = 7,
		ToolTip = function(action, unit)
			local sTooltip;
			local pPlayer = Players[Game:GetActivePlayer()];
			local bIsValid = CheckSpaceBattleCruiserButtonValidity( unit);
			if bIsValid then
				sTooltip = Locale.ConvertTextKey( "TXT_KEY_COND_SPACE_BATTLECRUISER");
			else
				sTooltip = Locale.ConvertTextKey( "TXT_KEY_COND_SPACE_BATTLECRUISER_2" );
			end
			return sTooltip
		end, -- or a TXT_KEY_ or a function
		Condition = function(action, unit)
			if unit:GetMoves() <= 0 then
				return false
			end
				if unit:GetUnitType() == BattleCruiser then
					return true
				else
					return false
			end
			
		end, -- or nil or a boolean, default is true
		Disabled = function(action, unit)
			local bIsValid = CheckSpaceBattleCruiserButtonValidity(unit);
			if bIsValid then
				return false
			end
			return true;
		end, -- or nil or a boolean, default is false
		Action = function(action, unit, eClick)
		if eClick == Mouse.eRClick then
		    Events.ClearHexHighlights()
	        Events.SerialEventMouseOverHex.Remove(DisplayCruiserHitArrow)
			return
		end
		    SpaceBattleCruiserSkill = 1
	        Events.SerialEventMouseOverHex.Add(DisplayCruiserHitArrow)		
	    end
}
LuaEvents.UnitPanelActionAddin(SpaceBattleCruiserMissionButton)

function ShowNukeArrow( PlotX, PlotY )
	--find the selected attacker
	local unit = UI.GetHeadSelectedUnit();

	if unit and unit:GetUnitType() == BattleCruiser then
		attacker = unit
	end
	
	if attacker == nil then
		return
	end

	--get bombard end hex
	if  attacker 	and (Map.PlotDistance(attacker:GetX(), attacker:GetY(), PlotX, PlotY ) <= 30 )  then
		Events.SpawnArrowEvent( attacker:GetX(), attacker:GetY(),PlotX, PlotY );
	else
		Events.RemoveAllArrowsEvent();
	end
	
end

function ShowNukeHitPlot()
	--find the selected attacker
	local unit = UI.GetHeadSelectedUnit();

	local pFromPlot = Map.GetPlot(UI.GetMouseOverHex())
	local hexID = ToHexFromGrid( Vector2( pFromPlot:GetX(), pFromPlot:GetY()) );


	if unit and unit:GetUnitType() == BattleCruiser then
		Cruiser = unit
	end
	
	if Cruiser == nil then
		return
	end

	if SpaceBattleCruiserSkill == 2 then

	Events.ClearHexHighlights()
	--get bombard end hex
	if  (Map.PlotDistance(Cruiser:GetX(), Cruiser:GetY(), pFromPlot:GetX(), pFromPlot:GetY()) <= 30 )  then
		Events.SerialEventHexHighlight( hexID, true, Vector4( 0.7, 0, 0, 1 ), "ValidFireTargetBorder");
	--else
		--Events.ClearHexHighlights()
	    end
	end
end

local SpaceBattleCruiserMissionButton2 = {
		Name = "TXT_KEY_NAME_SPACE_BATTLECRUISER_NUKE",
		Title = "TXT_KEY_TITLE_SPACE_BATTLECRUISER_NUKE",
		OrderPriority = 300,
		IconAtlas = "UNIT_ACTION_ATLAS",
		PortraitIndex = 17,
		ToolTip = function(action, unit)
			local sTooltip;
			local pPlayer = Players[Game:GetActivePlayer()];
			local bIsValid = CheckSpaceBattleCruiserButtonValidity2(unit);
			if bIsValid then
				sTooltip = Locale.ConvertTextKey( "TXT_KEY_COND_SPACE_BATTLECRUISER_NUKE");
			else
				sTooltip = Locale.ConvertTextKey( "TXT_KEY_COND_SPACE_BATTLECRUISER_CANT_NUKE" );
			end
			return sTooltip
		end, -- or a TXT_KEY_ or a function
		Condition = function(action, unit)
			if unit:GetMoves() <= 0 then
				return false
			end
				if unit:GetUnitType() == BattleCruiser then
					return true
				else
					return false
			end
			
		end, -- or nil or a boolean, default is true
		Disabled = function(action, unit)
			local bIsValid = CheckSpaceBattleCruiserButtonValidity2(unit);
			if bIsValid then
				return false
			end
			return true;
		end, -- or nil or a boolean, default is false
		Action = function(action, unit, eClick)
		if eClick == Mouse.eRClick then
		Events.RemoveAllArrowsEvent()
		Events.SerialEventMouseOverHex.Remove(ShowNukeArrow)
		Events.SerialEventMouseOverHex.Remove(ShowNukeHitPlot)
			return
		end

		SpaceBattleCruiserSkill = 2
		Events.SerialEventMouseOverHex.Add(ShowNukeArrow);
		Events.SerialEventMouseOverHex.Add(ShowNukeHitPlot);		 
	end
	}
LuaEvents.UnitPanelActionAddin(SpaceBattleCruiserMissionButton2)

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






local FranceCruiserMissionButton = {
	Name = "TXT_KEY_NAME_FRANCE_TRANSPORT",
	Title = "TXT_KEY_TITLE_FRANCE_TRANSPORT",
	OrderPriority = 200,
	IconAtlas = "UNIT_ACTION_ATLAS",
	PortraitIndex = 15,


	ToolTip = function(action, unit)
		local sTooltip;
		local pPlayer = Players[Game:GetActivePlayer()];
		local goldneed =pPlayer:GetCapitalCity():GetUnitPurchaseCost(GameInfo.Units.UNIT_MECHANIZED_INFANTRY.ID) 
			local IsValid = FranceCruiserMissionButtonValidity(unit);
			if IsValid then
				sTooltip = Locale.ConvertTextKey( "TXT_KEY_COND_FRANCE_TRANSPORT", goldneed);
			else
				sTooltip = Locale.ConvertTextKey( "TXT_KEY_COND_FRANCE_TRANSPORT_2", goldneed);
			end
			return sTooltip
		end, -- or a TXT_KEY_ or a function

	Condition = function(action, unit)
		if unit:GetMoves() <= 0 then
			return false
		end
		local pPlayer = Players[Game:GetActivePlayer()];
		local pTeam = Teams[pPlayer:GetTeam()]
		local plot=unit:GetPlot()
		if unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_FRANCE"].ID)
		  then
			return true
		else
			return false
		end
	end, -- or nil or a boolean, default is true


	Disabled = function(action, unit)
	    local IsValid = FranceCruiserMissionButtonValidity(unit);
		--local pPlayer = Players[Game:GetActivePlayer()];
	    if IsValid then
				return false
			end
			return true;
		end, -- or nil or a boolean, default is false
	Action = function(action, unit, eClick)
	if eClick == Mouse.eRClick then
		return
	end

	local pPlayer = Players[Game:GetActivePlayer()];
	if pPlayer:IsHuman() then

	local plot=unit:GetPlot()

		for iPlot in PlotAreaSpiralIterator(plot, 2, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		if  not iPlot:IsMountain() then
		if  not iPlot:IsWater() then
		if  not iPlot:IsCity() then
		if  iPlot:GetNumUnits()==0  
		then
			Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(iPlot:GetX(), iPlot:GetY())), true, Vector4(0.0, 1.0, 1.0, 1.0))
			          end	
			       end
			    end
			 end		   
		    SpaceBattleCruiserSkill = 4
		end
	end
end
}
LuaEvents.UnitPanelActionAddin(FranceCruiserMissionButton)



	function  CheckAngryButtonValidity(unit)
		for i = 0, 4 do
			if unit:IsHasPromotion(ANGEnergy[i]) then
				return false;
			end
		end
		return true;
	end




local UnitAngryButton = {
		Name = "ANGRY",
		Title = "TXT_KEY_TITLE_ANGRY",
		OrderPriority = 300,
		IconAtlas = "SP_UNIT_ACTION_ATLAS",
		PortraitIndex = 44,
		ToolTip = function(action, unit)
			local sTooltip;
			local bIsValid = CheckAngryButtonValidity(unit)
			if bIsValid then
				sTooltip = Locale.ConvertTextKey( "TXT_KEY_SP_BTNNOTE_UNIT_ANGRY");
			else
				sTooltip = Locale.ConvertTextKey( "TXT_KEY_SP_BTNNOTE_UNIT_CANT_ANGRY" );
			end
			return sTooltip
		end, -- or a TXT_KEY_ or a function
		Condition = function(action, unit)
			if unit:GetMoves() <= 0 then
				return false
			end
				if unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_COMBAT_TO_DEATH"].ID) then
					return true
				else
					return false
			end
			
		end, -- or nil or a boolean, default is true
		Disabled = function(action, unit)
			local bIsValid = CheckAngryButtonValidity(unit)
			if bIsValid then
				return false
			end
			return true;
		end, -- or nil or a boolean, default is false
		Action = function(action, unit, eClick)
		if eClick == Mouse.eRClick then
			return
		end

		local pPlayer = Players[Game:GetActivePlayer()];
		local pTeam = Teams[pPlayer:GetTeam()]
		if pPlayer:IsHuman() then
		local plot=unit:GetPlot()

		for iPlot in PlotAreaSpiralIterator(plot, 2, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		if  not iPlot:IsMountain() then
		if  not iPlot:IsWater() then
		if  not iPlot:IsCity() then
		if  iPlot:GetNumUnits()==0  
		then
			Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(iPlot:GetX(), iPlot:GetY())), true, Vector4(0.0, 1.0, 1.0, 1.0))
			          end	
			       end
			    end
			 end		   
		    SpaceBattleCruiserSkill = 5
		end
	end
end
}
LuaEvents.UnitPanelActionAddin(UnitAngryButton)



----Plot Hit Mode Switch

local PlotHitMissionButton = {
  Name = "Plot Hit",
  Title = "TXT_KEY_SP_BTNNOTE_UNIT_LEVDESTROYER_ON_SHORT", -- or a TXT_KEY
  OrderPriority = 200, -- default is 200
  IconAtlas = "SP_UNIT_ACTION_ATLAS2", -- 45 and 64 variations required
  PortraitIndex = 18,
  ToolTip = "TXT_KEY_SP_BTNNOTE_UNIT_LEVDESTROYER_HIT", -- or a TXT_KEY_ or a function
  
  
  Condition = function(action, unit)
    return unit:CanMove() and unit:GetUnitType()==GameInfoTypes.UNIT_LEVDESTROYER
  end, -- or nil or a boolean, default is true
  
  Disabled = function(action, unit)   
    return false;
  end, -- or nil or a boolean, default is false
  
  Action = function(action, unit, eClick) 
  	if eClick == Mouse.eRClick then
	Events.ClearHexHighlights()
	Events.SerialEventMouseOverHex.Remove(DisplayBombardHitArrow)
		return
	end

	SpaceBattleCruiserSkill = 6
	Events.SerialEventMouseOverHex.Add( DisplayBombardHitArrow )
   	print ("Hit On!")
 
  end
};
LuaEvents.UnitPanelActionAddin(PlotHitMissionButton);



function ShowNukeArrow( PlotX, PlotY )
	--find the selected attacker
	local unit = UI.GetHeadSelectedUnit();
	if unit and unit:GetUnitType() == BattleCruiser then
		attacker = unit
	end
	
	if attacker == nil then
		return
	end
	--get bombard end hex
	if  attacker 	and (Map.PlotDistance(attacker:GetX(), attacker:GetY(), PlotX, PlotY ) <= 30 )  then
		Events.SpawnArrowEvent( attacker:GetX(), attacker:GetY(),PlotX, PlotY );
	else
		Events.RemoveAllArrowsEvent();
	end
	
end

function DisplayBombardHitArrow()
    --Events.ClearHexHighlights()

	local unit = UI.GetHeadSelectedUnit();
	if unit and unit:GetUnitType()==GameInfoTypes.UNIT_LEVDESTROYER then
		attacker = unit
	end
	
	if attacker == nil then
		return
	end

    if SpaceBattleCruiserSkill == 6 then
	Events.ClearHexHighlights()
	local HitPlot = Map.GetPlot(UI.GetMouseOverHex())
	--get bombard end hex
	for iPlot in PlotAreaSpiralIterator(HitPlot, 2, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(iPlot:GetX(), iPlot:GetY())), true, Vector4(1.0, 0.0, 0.0, 1.0))
		Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(HitPlot:GetX(), HitPlot:GetY())), true, Vector4(1.0, 0.0, 0.0, 1.0))	
		end
	end
end	
Events.SerialEventMouseOverHex.Add( DisplayBombardHitArrow );


local IronPagodaChargeArray = {}

local IronPagodaChargeArrayDirection = {}
for i = 0, 5 do
	IronPagodaChargeArrayDirection[i] = {}
end

local IronPagodaChargeButton = {
	Name = "IRON PAGODA ",
	Title = "TXT_KEY_TITLE_IRON_BUDDHA_CHARGE",
	OrderPriority = 200,
	IconAtlas = "ROBOT_ICON_ATLAS4",
	PortraitIndex = 59,
	ToolTip = function(action, unit)
		local sTooltip;
		local pPlayer = Players[Game:GetActivePlayer()];
		sTooltip = Locale.ConvertTextKey( "TXT_KEY_COND_IRON_BUDDHA_CHARGE");
		return sTooltip
	end, -- or a TXT_KEY_ or a function
	Condition = function(action, unit)
		if unit:IsHasPromotion(IronPagodaHumanID) and unit:GetMoves() <= 0 then
			return false
		end
		local pPlayer = Players[Game:GetActivePlayer()];
		if unit:CanMove() and unit:IsHasPromotion(GameInfoTypes.PROMOTION_ANTI_ANTI_MOUNTED_BONUS)
		and unit:GetCurrHitPoints() > 150
		then
			return true
		end
	end, -- or nil or a boolean, default is true
	Disabled = function(action, unit)
		return false
	end, -- or nil or a boolean, default is false
	Action = function(action, unit, eClick)
	if eClick == Mouse.eRClick then
		return
	end
	local pPlayer = Players[Game:GetActivePlayer()];
	local ii = 0
	if pPlayer:IsHuman() then
		-- local unithex = ToHexFromGrid({unit:GetX(), unit:GetY()})
		-- local unitx, unity = unithex.x, unithex.y
		
		for i = 0, 5 do
			-- 所在单元格为中心，向四周延伸，半径为5
			local uniqueRange = 5
			-- 保证冲锋路线上没有山脉、城市、水域阻隔
			local oPlotX, oPlotY = unit:GetX(), unit:GetY()
			while (uniqueRange > 0) do
				local iPlot = Map.PlotDirection(oPlotX, oPlotY, i)
				if iPlot
				and (not iPlot:IsMountain())
				and (not iPlot:IsWater()) 
				and (not iPlot:IsCity())
				and uniqueRange > 0
				then
					Events.SerialEventHexHighlight(ToHexFromGrid(Vector2(iPlot:GetX(), iPlot:GetY())), true, Vector4(0.847, 0.611, 	0.192, 	1))
					uniqueRange = uniqueRange - 1
					-- print("IronPagodaChargePlot + "..i.."rr"..uniqueRange)
					oPlotX, oPlotY = iPlot:GetX(), iPlot:GetY()
					table.insert(IronPagodaChargeArray, GetPlotKey(iPlot))
					table.insert(IronPagodaChargeArrayDirection[i], GetPlotKey(iPlot))
					ii = ii + 1	
				else
					break
				end
			end
		end

	end
	SpaceBattleCruiserSkill = 7
end
}
LuaEvents.UnitPanelActionAddin(IronPagodaChargeButton)


function InputHandler( uiMsg, wParam, lParam )
		if SpaceBattleCruiserSkill ~= 0 then
			if uiMsg == MouseEvents.LButtonDown then
				lButtonDown = true
				local pPlot = Map.GetPlot(UI.GetMouseOverHex())
				local pPlayer = Players[Game:GetActivePlayer()]
				local num=0
				local attack=0
				--------------------------------------------------
				if SpaceBattleCruiserSkill == 1 then
				  local pUnit = UI.GetHeadSelectedUnit()
					if pUnit:GetUnitType() == BattleCruiser  then
                    -------------------------------------------------- 
					if pPlot:GetNumUnits()>0 and not pPlot:IsCity() then
                    for i = 0, pPlot:GetNumUnits() - 1 do
					local aUnit = pPlot:GetUnit(i);

					if aUnit:IsCombatUnit() and Teams[pPlayer:GetTeam()]:IsAtWar(Players[aUnit:GetOwner()]:GetTeam()) then
					aUnit:Kill(true, -1)
					num = num + 1
					attack =attack+ 1
						end
					end
                               
                   if num>0 then
	               for ePlot  in PlotAreaSpiralIterator(pPlot, 1, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do

				   for iVal = 0,(ePlot:GetNumUnits() - 1) do
	               local loopUnit = ePlot:GetUnit(iVal)
	  	           if   Teams[pPlayer:GetTeam()]:IsAtWar(Players[loopUnit:GetOwner()]:GetTeam()) then
		           loopUnit:Kill(true, -1)
					  end
		    	   end
                   if  ePlot:IsCity() then
					if  not ePlot:GetPlotCity():IsOriginalCapital() then
					local hexpos = ToHexFromGrid(Vector2(ePlot:GetX(),ePlot:GetY()));
					local cityID = ePlot:GetPlotCity():GetID()
					local iplay= ePlot:GetPlotCity():GetOwner()
					ePlot:GetPlotCity():SetPopulation(0, true)
		            ePlot:GetPlotCity():Kill()
	                Events.SerialEventCityDestroyed(hexpos, iplay, cityID, -1)
		            Events.SerialEventGameDataDirty()
						           end
								end
						     end
						end
	          --------------------------------------------------------------------------------------------------
	                   	if  pPlot:IsCity() then
						if not pPlot:GetPlotCity():IsOriginalCapital() then
						local hexpos = ToHexFromGrid(Vector2(pPlot:GetX(),pPlot:GetY()));
						local cityID = pPlot:GetPlotCity():GetID()
						pPlot:GetPlotCity():SetPopulation(0, true)
		                pPlot:GetPlotCity():Kill()
	                    Events.SerialEventCityDestroyed(hexpos, Game:GetActivePlayer(), cityID, -1)
		                Events.SerialEventGameDataDirty()
						end

						if  pPlot:GetNumUnits()>0 then
                        for i = 0, pPlot:GetNumUnits() - 1 do
						local aUnit = pPlot:GetUnit(i);
					    if aUnit:IsCombatUnit() and Teams[pPlayer:GetTeam()]:IsAtWar(Players[aUnit:GetOwner()]:GetTeam()) then
					    aUnit:Kill(true, -1)
					    num = num + 1
					    attack =attack+ 1
									end
								end
						   end
                        if num>0 then
	                    for ePlot  in PlotAreaSpiralIterator(pPlot, 1, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
					   	for iVal = 0,(ePlot:GetNumUnits() - 1) do
	                           local loopUnit = ePlot:GetUnit(iVal)
	  	                   if  Teams[pPlayer:GetTeam()]:IsAtWar(Players[loopUnit:GetOwner()]:GetTeam()) then
		                       loopUnit:Kill(true, -1)
		    	                               	end
											end
										end
                                    end
                               end

                        if attack>0 then
						Events.AddPopupTextEvent(PositionCalculator(pPlot:GetX(), pPlot:GetY()), Locale.ConvertTextKey("TXT_KEY_ALERT_SPACE_BATTLECRUISER"),0.1)
						save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") - 8)
							Events.AudioPlay2DSound("AS2D_ARCTURUS_YAMATO_CANNON")
							for i = 0, 18 do
						    pUnit:SetHasPromotion(ATBTEnergy[i], (i == load(pUnit, "SpaceBattleCruiserEnergy")))
						 end
					  end 
			       end 
				end
				Events.ClearHexHighlights()
				SpaceBattleCruiserSkill = 0

				--------------------------------------------------------------------------------------
				elseif SpaceBattleCruiserSkill == 2 then
					    local pUnit = UI.GetHeadSelectedUnit()
						if pUnit:GetUnitType() == BattleCruiser then

						if pPlot~=pUnit:GetPlot()  then
						local plotDistance = Map.PlotDistance(pUnit:GetX(),pUnit:GetY(), pPlot:GetX(), pPlot:GetY());
						if plotDistance <= 30 then
						if load(pUnit, "SpaceBattleCruiserEnergy")~=nil and load(pUnit, "SpaceBattleCruiserEnergy")>=4 then
						save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") - 4)
							for i = 0, 18 do
						    pUnit:SetHasPromotion(ATBTEnergy[i], (i == load(pUnit, "SpaceBattleCruiserEnergy")))
							end
								local unit = pPlayer:InitUnit(GameInfoTypes["UNIT_ICBM_MISSILE"], pUnit:GetX(), pUnit:GetY())
				                unit:PushMission(MissionTypes.MISSION_NUKE, pPlot:GetX(), pPlot:GetY(), 0, 0, 1, MissionTypes.MISSION_NUKE, unit:GetPlot(), unit)
						 	end
						end
					end
                end
				Events.RemoveAllArrowsEvent();
	            Events.SerialEventMouseOverHex.Remove(ShowNukeArrow);
				Events.SerialEventMouseOverHex.Remove(ShowNukeHitPlot);
                Events.ClearHexHighlights()
				SpaceBattleCruiserSkill = 0
				--------------------------------------------------------------------------------------
		        elseif SpaceBattleCruiserSkill == 3 then
		        local pSelUnit = UI.GetHeadSelectedUnit()		    
				if IsCanTransPortPlot(pSelUnit,pPlot)  then
				pSelUnit:SetXY(pPlot:GetX(), pPlot:GetY());
                pSelUnit:SetMoves(0)
				Events.AddPopupTextEvent(PositionCalculator(pPlot:GetX(), pPlot:GetY()), Locale.ConvertTextKey("TXT_KEY_ALERT_SUPER_TRANSPORT",pSelUnit:GetName()),0.1)
				Events.AudioPlay2DSound("AS2D_SPACE_TRANSPORT") 
				end
		
				Events.ClearHexHighlights()
				SpaceBattleCruiserSkill = 0

				--------------------------------------------------------------------------------------
			
				elseif SpaceBattleCruiserSkill == 4 then
		        local pSUnit = UI.GetHeadSelectedUnit()
		        local sUnitPlot = pSUnit:GetPlot()
				local pPlayer = Players[Game:GetActivePlayer()]			
				--if  pSUnit:GetMoves() ~= 0 and  pPlot:GetNumUnits() == 0 and ( pPlot:IsWater()) then
				local distance = Map.PlotDistance(pPlot:GetX(), pPlot:GetY(), sUnitPlot:GetX(), sUnitPlot:GetY())
				if distance <= 2 and distance > 0 
				and pSUnit:GetMoves() ~= 0 
				and (not pPlot:IsMountain()) 
				and (not pPlot:IsWater()) 
				and (not pPlot:IsCity()) 
				and pPlot:GetNumUnits() == 0  then
				
				if pSUnit:GetUnitType() == GameInfoTypes["UNIT_FRANCE_MISTRAL"] then
							
				local unit  = pPlayer:InitUnit(GameInfoTypes["UNIT_MECHANIZED_INFANTRY"], pPlot:GetX(),pPlot:GetY())
				local unit2 = pPlayer:InitUnit(GameInfoTypes["UNIT_MECHANIZED_INFANTRY"], pPlot:GetX(),pPlot:GetY())
			
			    SetAbilityForFranceMistralUnit(unit)
				SetAbilityForFranceMistralUnit(unit2)

                else 

				local unit  = pPlayer:InitUnit(GameInfoTypes["UNIT_FW_BATTLESUIT"], pPlot:GetX(),pPlot:GetY())
				local unit2 = pPlayer:InitUnit(GameInfoTypes["UNIT_FW_BATTLESUIT"], pPlot:GetX(),pPlot:GetY())
			
			    SetAbilityForFranceMistralUnit2(unit)
				SetAbilityForFranceMistralUnit2(unit2)
				end
				--unit:JumpToNearestValidPlot() 
				 pSUnit:SetMoves(0)
				 local goldCost = 0
			     goldCost = pPlayer:GetCapitalCity():GetUnitPurchaseCost(GameInfo.Units.UNIT_MECHANIZED_INFANTRY.ID) 
				 pPlayer:ChangeGold(-4*goldCost) 				  
				 end		
				 Events.ClearHexHighlights()
				 SpaceBattleCruiserSkill = 0
				 --------------------------------------------------------------------------------------
			   
				elseif SpaceBattleCruiserSkill == 5 then
		        local pSUnit = UI.GetHeadSelectedUnit()
		        local sUnitPlot = pSUnit:GetPlot()
				local pPlayer = Players[Game:GetActivePlayer()]		
				local distance = Map.PlotDistance(pPlot:GetX(), pPlot:GetY(), sUnitPlot:GetX(), sUnitPlot:GetY())
				if distance <= 2 and distance > 0 
				and pSUnit:GetMoves() ~= 0 
				and (not pPlot:IsMountain()) 
				and (not pPlot:IsWater()) 
				and (not pPlot:IsCity()) 
				and pPlot:GetNumUnits() == 0  then
				
				if pSUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_COMBAT_TO_DEATH"].ID)  then							
                GetUniqueFreeMeleeUnit(pPlayer, pPlot)

				end

				 pSUnit:ChangeMoves(-GameDefines["MOVE_DENOMINATOR"])
				 pSUnit:SetHasPromotion(GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_0, true)
		         pSUnit:SetHasPromotion(GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_5, false)

				 end		
				 Events.ClearHexHighlights()
				 SpaceBattleCruiserSkill = 0
				 --------------------------------------------------------------------------------------    
	            elseif SpaceBattleCruiserSkill == 6 then
		        local pSUnit = UI.GetHeadSelectedUnit();
				local pPlayer = Players[Game:GetActivePlayer()]
				local NumEnemy=0
				-- Plots that have been done
				if pSUnit:GetUnitType()==GameInfoTypes.UNIT_LEVDESTROYER
				and pPlot~=pSUnit:GetPlot() then

				if  pPlot:GetNumUnits()>0 then
                    for i = 0, pPlot:GetNumUnits() - 1 do
				    local aUnit = pPlot:GetUnit(i);
					if  Teams[pPlayer:GetTeam()]:IsAtWar(Players[aUnit:GetOwner()]:GetTeam()) then					
					local damage= math.floor(pSUnit:GetRangeCombatDamage(aUnit,nil,false));
		             aUnit:ChangeDamage(damage, pPlayer)
					 NumEnemy=NumEnemy+1				 
					  end
				   end
				end

				for pTargetPlot in PlotAreaSpiralIterator(pPlot, 2, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
					       for iVal = 0,(pTargetPlot:GetNumUnits() - 1) do
	                           local loopUnit = pTargetPlot:GetUnit(iVal)
	  	                   if  Teams[pPlayer:GetTeam()]:IsAtWar(Players[loopUnit:GetOwner()]:GetTeam()) then
						       local damage= math.floor(pSUnit:GetRangeCombatDamage(loopUnit,nil,false));
							   NumEnemy=NumEnemy+1
		                       loopUnit:ChangeDamage(damage, pPlayer)
							           end
							        end
							    end
						
				          if NumEnemy>0 then
				          pSUnit:SetMoves(0)
						  Events.AudioPlay2DSound("AS2D_SPACESHIP_CANNON")
		    	     end
                 end

				 SpaceBattleCruiserSkill = 0
				 Events.ClearHexHighlights()					 
				 --------------------------------------------------------------------------------------


				 elseif SpaceBattleCruiserSkill == 7 then
			     local uniqueRange = 5
			     local pPlayer = Players[Game:GetActivePlayer()]
			     local num = 0
			     local pSUnit = UI.GetHeadSelectedUnit()
			     local sUnitPlot = pSUnit:GetPlot()
			     if pSUnit:IsHasPromotion(GameInfoTypes.PROMOTION_ANTI_ANTI_MOUNTED_BONUS)
			     and isInArray(IronPagodaChargeArray, GetPlotKey(pPlot))
			     then 
				 for i = 0, 5 do
					if isInArray(IronPagodaChargeArrayDirection[i], GetPlotKey(pPlot)) then
						
						-- 所经之处敌人掉血
						for _, v in pairs(IronPagodaChargeArrayDirection[i]) do
							local plotkey = v
							local plotX, plotY = GetPlotXYFromKey(plotkey)
							local plot = GetPlotFromKey(plotkey)
						
							local unitCount = plot:GetNumUnits();
							if unitCount > 0 then
								for i = 0, unitCount-1, 1 do
    					            local pFoundUnit = plot:GetUnit(i);
    					            if pFoundUnit then 
										if not (iPlayer == pPlayer) and pPlayer:IsAtWarWith(pFoundUnit:GetOwner())then

										local attUnitStrength = pSUnit:GetMaxAttackStrength(sUnitPlot, plot, pFoundUnit);
			                            local pFoundUnitStrength = pFoundUnit:GetMaxDefenseStrength(plot, pSUnit);
			                            local DamageOri = math.floor(3*pSUnit:GetCombatDamage(attUnitStrength, pFoundUnitStrength, pSUnit:GetDamage(), false, false, false));

										    pSUnit:SetHasPromotion(GameInfoTypes.PROMOTION_NO_CHARGE_BONUS, true)
										    pFoundUnit:ChangeDamage(DamageOri) -- 敌方单位掉血
												
											--end
										end
									end
								end
							end	
						end
						-- 铁浮屠掉血失去移动力
						pSUnit:SetXY(pPlot:GetX(), pPlot:GetY())
						pSUnit:SetMoves(0)
						pSUnit:ChangeDamage(150)
						local hex = ToHexFromGrid(Vector2(pPlot:GetX(), pPlot:GetY()))		
						--Events.AudioPlay2DSound("AS2D_HORSE")
						Events.AddPopupTextEvent(HexToWorld(hex), Locale.ConvertTextKey("TXT_KEY_TITLE_IRON_BUDDHA_CHARGE"))
						Events.GameplayFX(hex.x, hex.y, -1)
						break
					end
				end
			end
			IronPagodaChargeArray = {}

			IronPagodaChargeArrayDirection = {}
			for i = 0, 5 do
				IronPagodaChargeArrayDirection[i] = {}
			end

			Events.ClearHexHighlights()
			SpaceBattleCruiserSkill = 0
			---------------------------------------------------------------------------------------------------------------------------------
			end

			elseif uiMsg == MouseEvents.LButtonUp then
				if lButtonDown then
				   lButtonDown = false
				end
			elseif uiMsg == MouseEvents.RButtonDown then
				   rButtonDown = true
			elseif uiMsg == MouseEvents.RButtonUp then
				if rButtonDown and SpaceBattleCruiserSkill > 0 then
					rButtonDown = false
					SpaceBattleCruiserSkill = 0

					Events.ClearHexHighlights()
					Events.RemoveAllArrowsEvent();
	                Events.SerialEventMouseOverHex.Remove(ShowNukeArrow);
					Events.SerialEventMouseOverHex.Remove(ShowNukeHitPlot);
				end
			end
		end
		return false;
	end
ContextPtr:SetInputHandler( InputHandler )



	
 function AI_HITTITE_WAR_CHARIOT(iPlayer)
    local HittiteProj = GameInfoTypes["PROJECT_HITTITE_WAR_CHARIOT"]
    local Player = Players[iPlayer]
	if Player==nil or Player:IsHuman() 
	or (not Player:IsMajorCiv())
	then 
	return end 

	    if Player:HasProject(HittiteProj) then

	    for pUnit in Player:Units() do
	    if  pUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_COMBAT_TO_DEATH"].ID) 
		and pUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_COMBAT_TO_DEATH_5"].ID) then
		 GetUniqueFreeMeleeUnit(Player, pUnit:GetPlot())
		 pUnit:SetHasPromotion(GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_0, true)
		 pUnit:SetHasPromotion(GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_5, false)
		 end
	  end
   end
end	
GameEvents.PlayerDoTurn.Add(AI_HITTITE_WAR_CHARIOT)	




-- **********************************************************************************************************************************************
-- 
-- **********************************************************************************************************************************************
function GolemActivate(playerID, unitID, bTestAllAllies)
	local pPlayer = Players[playerID]
	local pUnit = pPlayer:GetUnitByID(unitID)
	if not pUnit then return end
	if bTestAllAllies then
		for pUnit  in pPlayer:Units() do
			if pUnit:GetUnitType() ~= GameInfoTypes["UNIT_GOLEM"]   then
				if  pUnit:IsWithinDistanceOfUnit(GameInfoTypes["UNIT_GOLEM"], 2, true, false) then
					pUnit:SetHasPromotion(GameInfoTypes["PROMOTION_NUKE_IMMUNE2"], true)
				else
					pUnit:SetHasPromotion(GameInfoTypes["PROMOTION_NUKE_IMMUNE2"], false)
				end
			end
		end
	else
		 if pUnit:GetUnitType() ~= GameInfoTypes["UNIT_GOLEM"] then
			if  pUnit:IsWithinDistanceOfUnit(GameInfoTypes["UNIT_GOLEM"], 2, true, false) then
				pUnit:SetHasPromotion(GameInfoTypes["PROMOTION_NUKE_IMMUNE2"], true)
			else
				pUnit:SetHasPromotion(GameInfoTypes["PROMOTION_NUKE_IMMUNE2"], false)
			end
		end
	end
end
GameEvents.UnitSetXY.Add(GolemActivate)



function OnCanParadropFrom(iPlayer, iUnit, iPlotX, iPlotY)

  local pPlayer = Players[iPlayer]
  local pUnit = pPlayer:GetUnitByID(iUnit)

   local pPlot = Map.GetPlot(iPlotX, iPlotY)
		
		if (pUnit~=nil  and pUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_XCOM_WEAPON_BASE"].ID)) then

		  return true
		end
  return false
end
GameEvents.CanParadropFrom.Add(OnCanParadropFrom)

-- **********************************************************************************************************************************************
-- 浮石章鱼
-- **********************************************************************************************************************************************
--local NoPlagues	 = (PreGame.GetGameOption("GAMEOPTION_PLAGUE_DISABLED") == 1)  
--local AbandonCity	 = (PreGame.GetGameOption("GAMEOPTION_PLAGUE_DESTROYS_CITIES") == 1)  

local PlagueMissionButton = {
		Name = "TXT_KEY_NAME_CREAT_PLAGUE",
		Title = "TXT_KEY_TITLE_CREAT_PLAGUE",
		OrderPriority = 300,
		IconAtlas = "SP_UNIT_ACTION_ATLAS2",
		PortraitIndex = 25,
		ToolTip = function(action, unit)
			local sTooltip;
			local pPlayer = Players[Game:GetActivePlayer()];
			local bIsValid = CheckPlagueMissionButtonValidity( unit);
			if bIsValid then
				sTooltip = Locale.ConvertTextKey( "TXT_KEY_COND_CREAT_PLAGUE");
			else
				sTooltip = Locale.ConvertTextKey( "TXT_KEY_COND_CREAT_PLAGUE_2" );
			end
			return sTooltip
		end, -- or a TXT_KEY_ or a function
		Condition = function(action, unit)
			if unit:GetMoves() <= 0 then
				return false
			end
				if unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_HOVER_WORM"].ID) then
					return true
				else
					return false
			end
			
		end, -- or nil or a boolean, default is true
		Disabled = function(action, unit)
			local bIsValid = CheckPlagueMissionButtonValidity(unit);
			if bIsValid then
				return false
			end
			return true;
		end, -- or nil or a boolean, default is false
		Action = function(action, unit, eClick)
		if eClick == Mouse.eRClick then
			return
		end
		    local city = unit:GetPlot():GetPlotCity() or unit:GetPlot():GetWorkingCity()
			if 	city~=nil then
			unit:SetMoves(0)
			local zombie = Players[63]:InitUnit(GameInfoTypes["UNIT_ZOMBIE"], city:GetX()+1, city:GetY())
			zombie:JumpToNearestValidPlot()

			if  city:HasPlague() then   ----有瘟疫则延长持续
				city:ChangePlagueTurns(city:GetPlagueTurns()+8)
				Events.AudioPlay2DSound("AS2D_PLAGUE")
			else
			    city:SetPlagueCounter(0)
			    Health_PlagueBegins(city)
			    city:ChangeDamage(100+gCityHeal)
			    DiseaseUnits(city)			    
		 end
	  end
  end
}
LuaEvents.UnitPanelActionAddin(PlagueMissionButton)
end
                    

-- **********************************************************************************************************************************************
-- **********************************************************************************************************************************************
local iMissionFire  = GameInfoTypes.MISSION_FIRE_GUNS

local CUSTOM_MISSION_NO_ACTION		 = 0
local CUSTOM_MISSION_ACTION			 = 1


function OnFireMissionPossible(playerID, unitID, missionID, data1, data2, _, _, plotX, plotY, bTestVisible)
	local pPlayer = Players[playerID]
	local pUnit = pPlayer:GetUnitByID(unitID)
	
	if (pPlayer:IsAlive() and not pPlayer:IsBarbarian() and missionID == iMissionFire and pUnit:CanMove()) then
	
		if (pUnit:GetUnitType() == GameInfoTypes.UNIT_HORSE_ARTILLERY_MOVE ) then
			return true
		end
	end
	
	return false
end
GameEvents.CustomMissionPossible.Add(OnFireMissionPossible)


function OnFireMissionStart(iPlayer, iUnit, iMission, iData1, iData2, iFlags, iTurn)
	local pPlayer = Players[iPlayer]
	local pUnit = pPlayer:GetUnitByID(iUnit)
	local pMoves = GameDefines.MOVE_DENOMINATOR
	
	if (pPlayer:IsAlive() and (not pPlayer:IsBarbarian()) and iMission == iMissionFire and pUnit:CanMove()) then
	
		if (pUnit:GetUnitType() == GameInfoTypes.UNIT_HORSE_ARTILLERY_MOVE) then
			local pUnitCannon = pPlayer:InitUnit(GameInfoTypes["UNIT_HORSE_ARTILLERY"], pUnit:GetX(), pUnit:GetY())
			
			pUnitCannon:SetEmbarked(pUnit:IsEmbarked())
			pUnitCannon:SetDamage(pUnit:GetDamage())
			pUnitCannon:SetExperience(pUnit:GetExperience())
			pUnitCannon:SetLevel(pUnit:GetLevel())
			pUnitCannon:SetMoves(pUnitCannon:MaxMoves())
			pUnitCannon:PushMission(MissionTypes.MISSION_SET_UP_FOR_RANGED_ATTACK, pUnitCannon:GetX(), pUnitCannon:GetY(), 0, 0, 1, MissionTypes.MISSION_SET_UP_FOR_RANGED_ATTACK, pUnitCannon:GetPlot(), pUnitCannon)
			
			for unitPromotion in GameInfo.UnitPromotions() do
				local iPromotionID = unitPromotion.ID;
					
				if (pUnit:IsHasPromotion(iPromotionID)) then
					if (pUnitCannon:IsPromotionValid(iPromotionID)) then
						pUnitCannon:SetHasPromotion(iPromotionID, true)
					end
				end
			end	
			pUnit:Kill(true)		
		end
	end
	
	return CUSTOM_MISSION_NO_ACTION
end
GameEvents.CustomMissionStart.Add(OnFireMissionStart)

function OnFireMissionCompleted(iPlayer, iUnit, iMission, iData1, iData2, iFlags, iTurn)
	local pPlayer = Players[iPlayer]
	
	if (pPlayer:IsAlive() and not pPlayer:IsBarbarian() and iMission == iMissionFire) then
		return true
	end
	
	return false
end
GameEvents.CustomMissionCompleted.Add(OnFireMissionCompleted)



local iMissionLimber  = GameInfoTypes.MISSION_LIMBER_GUNS

local CUSTOM_MISSION_NO_ACTION = 0
local CUSTOM_MISSION_ACTION    = 1


function OnLimberMissionPossible(iPlayer, iUnit, iMission, iData1, iData2, _, _, iPlotX, iPlotY, bTestVisible)
	local pPlayer = Players[iPlayer]
	local pUnit = pPlayer:GetUnitByID(iUnit)
	
	if (pPlayer:IsAlive() and not pPlayer:IsBarbarian() and iMission == iMissionLimber and not pUnit:HasMoved()) then
	
		if (pUnit:GetUnitType() == GameInfoTypes.UNIT_HORSE_ARTILLERY) then
			return true
		end
	end
	
	return false
end
GameEvents.CustomMissionPossible.Add(OnLimberMissionPossible)

function OnLimberMissionStart(iPlayer, iUnit, iMission, iData1, iData2, iFlags, iTurn)
	local pPlayer = Players[iPlayer]
	local pUnit = pPlayer:GetUnitByID(iUnit)
	local pMoves = GameDefines.MOVE_DENOMINATOR
	
	if (pPlayer:IsAlive() and not pPlayer:IsBarbarian() and iMission == iMissionLimber and not pUnit:HasMoved()) then
	
		if (pUnit:GetUnitType() == GameInfoTypes.UNIT_HORSE_ARTILLERY) then
			local pUnitLimber = pPlayer:InitUnit(GameInfoTypes["UNIT_HORSE_ARTILLERY_MOVE"], pUnit:GetX(), pUnit:GetY())
			
			pUnitLimber:SetEmbarked(pUnit:IsEmbarked())
			pUnitLimber:SetDamage(pUnit:GetDamage())
			pUnitLimber:SetExperience(pUnit:GetExperience())
			pUnitLimber:SetLevel(pUnit:GetLevel())
			pUnitLimber:SetMoves(pUnitLimber:MaxMoves() - pMoves)
			
			for unitPromotion in GameInfo.UnitPromotions() do
				local iPromotionID = unitPromotion.ID;
					
				if (pUnit:IsHasPromotion(iPromotionID)) then
					if (pUnitLimber:IsPromotionValid(iPromotionID)) then
						pUnitLimber:SetHasPromotion(iPromotionID, true)
					end
				end
			end			
			pUnit:Kill(true)
		end
		return CUSTOM_MISSION_ACTION
	end	
	return CUSTOM_MISSION_NO_ACTION
end
GameEvents.CustomMissionStart.Add(OnLimberMissionStart)

function OnLimberMissionCompleted(iPlayer, iUnit, iMission, iData1, iData2, iFlags, iTurn)
	local pPlayer = Players[iPlayer]
	
	if (pPlayer:IsAlive() and not pPlayer:IsBarbarian() and iMission == iMissionLimber) then
		return true
	end
	
	return false
end
GameEvents.CustomMissionCompleted.Add(OnLimberMissionCompleted)


-- ********************************************************
-- 
-- ******************************************************** 
function UnitCanRangeAttackPlot(iPlayer, iUnit, iPlotX, iPlotY, bNeedWar)
  local pUnit = Players[iPlayer]:GetUnitByID(iUnit)
  local plot = Map.GetPlot(iPlotX, iPlotY)

  if pUnit:GetDomainType()==DomainTypes.DOMAIN_AIR then
  if NotEnemyAngelPlot(pUnit,plot) then
	 return true
  end
  return false
  end

  if pUnit:GetDomainType()~=DomainTypes.DOMAIN_AIR then
  if IsNotEnemySpaceShipPlot(pUnit,plot) then
	 return true
  end
  return false
  end

    return true
end
GameEvents.UnitCanRangeAttackPlot.Add(UnitCanRangeAttackPlot)

-- ********************************************************
-- 
-- ******************************************************** 
function BuffForNaturalWonderDiscovered(iTeam, iFeature, iX, iY, bFirst)
    local pTeam = Teams[iTeam]
	local iPlayer = pTeam:GetLeaderID()
	local pPlayer = Players[iPlayer]
    if pPlayer == nil or (not pPlayer:IsMajorCiv()) then
	 	return
	         end
		if pPlayer:CountNumBuildings(GameInfoTypes.BUILDING_SPHINX) > 0  then
		pPlayer:ChangeGold(300)
	end
end
GameEvents.NaturalWonderDiscovered.Add(BuffForNaturalWonderDiscovered)

-- ********************************************************
-- 
-- ******************************************************** 
local iTileRadius = 7
function NukeBuff(iPlayer,iUnit,iX, iY, bWar, bBystanders)
local player = Players[iPlayer];
local plot = Map.GetPlot(iX, iY)
local pUnit = player:GetUnitByID(iUnit)
		
if pUnit~=nil then
if pUnit:GetUnitType() ==GameInfoTypes["UNIT_ANTIMATTER_EXPLOSION"]  then
pUnit:Kill(true, -1) 
	  for iShiftX = -iTileRadius, iTileRadius do
	  for iShiftY = -iTileRadius, iTileRadius do
	  local pTargetPlot = Map.PlotXYWithRangeCheck(iX, iY, iShiftX, iShiftY, iTileRadius)
      if pTargetPlot ~= nil then

------------------------------------------------
      local unitCount = pTargetPlot:GetNumUnits();
      if unitCount > 0 then
      for i = 0, unitCount-1, 1 do
      local pFoundUnit = pTargetPlot:GetUnit(i);
	  pFoundUnit:Kill(true, -1) 		 
                     end
	              end
------------------------------------------------
      if pTargetPlot:IsCity() then 

	  if (not pTargetPlot:GetPlotCity():IsOriginalCapital()) then  
	  pTargetPlot:GetPlotCity():SetPopulation(0, true)
	  local playerID = pTargetPlot:GetPlotCity():GetOwner()
	  local hexpos = ToHexFromGrid(Vector2(pTargetPlot:GetX(), pTargetPlot:GetY()))
	  local cityID = pTargetPlot:GetPlotCity():GetID()
	  pTargetPlot:GetPlotCity():Kill()
	  Events.SerialEventCityDestroyed(hexpos, playerID, cityID, -1)
	  Events.SerialEventGameDataDirty()
	  else  
	  pTargetPlot:GetPlotCity():SetPopulation(1, true)
	  pTargetPlot:GetPlotCity():ChangeDamage(pTargetPlot:GetPlotCity():GetMaxHitPoints())
					 end
                  end
               end
            end
         end
	  end
   end
end
GameEvents.NuclearDetonation.Add(NukeBuff)

-- ********************************************************
-- 
-- ******************************************************** 
local iLatifundium = GameInfoTypes.BUILD_LATIFUNDIUM
local iBuildingSilkroadClass = GameInfo.BuildingClasses.BUILDINGCLASS_SILKROAD.ID  
function LatifundiumCheck(iPlayer, iUnit, iX, iY, iBuild)
   if iBuild == iLatifundium  then
   local pPlayer = Players[iPlayer]
   if pPlayer:GetBuildingClassCount(iBuildingSilkroadClass) > 0 then
     return true
		 end   
	 return false
	  end
	  return true
 end
GameEvents.PlayerCanBuild.Add(LatifundiumCheck)


function Building_EmpireReourceAnds_Check(playerID, buildingID)
	local player = Players[playerID];

	local condition = "BuildingType = '" .. GameInfo.Buildings[buildingID].Type .. "'";
	for row in GameInfo.Building_EmpireResourceAnds(condition) do
		if(player:GetNumResourceAvailable(GameInfoTypes[row.ResourceType], row.AllowsImport) <= 0) then
			return false; -- 列出玩家未拥有的资源
		end
	end

	return true;
end
GameEvents.PlayerCanConstruct.Add(Building_EmpireReourceAnds_Check);



function Building_EmpireReourceOrs_Check(playerID, buildingID)
	local player = Players[playerID];
	local buildingNotInTable = true;
	
	local condition = "BuildingType = '" .. GameInfo.Buildings[buildingID].Type .. "'";
	for row in GameInfo.Building_EmpireResourceOrs(condition) do
		buildingNotInTable = false; -- 建筑需要资源才可建造
			
		if(player:GetNumResourceAvailable(GameInfoTypes[row.ResourceType], row.AllowsImport) > 0) then
			return true; -- 列出玩家拥有的资源
		end
	end

	return buildingNotInTable;
end
GameEvents.PlayerCanConstruct.Add(Building_EmpireReourceOrs_Check);


local retVal = {};
LuaEvents.Building_EmpireResources_IsInitialized(retVal);


if (retVal.isInitialized == nil) then
	LuaEvents.Building_EmpireResources_IsInitialized.Add(function (retVal) retVal.isInitialized = true; end);
	-- 置入代码
	GameEvents.PlayerCanConstruct.Add(Building_EmpireReourceAnds_Check);
	GameEvents.PlayerCanConstruct.Add(Building_EmpireReourceOrs_Check);
end



function OnCanHavePromotion(iPlayer, iUnit, iPromotion)
  local iGroup = GameInfo.UnitPromotions[iPromotion].MutuallyExclusiveGroup
  
  if (iGroup ~= -1) then
    local pUnit = Players[iPlayer]:GetUnitByID(iUnit)
	
	for row in DB.Query("SELECT ID FROM UnitPromotions WHERE MutuallyExclusiveGroup = ? AND ID != ?", iGroup, iPromotion) do
	  if (pUnit:IsHasPromotion(row.ID)) then
	    return false
	  end
	end
  end
  
  return true
end
GameEvents.CanHavePromotion.Add(OnCanHavePromotion)




function Processes_CanMaintain(playerID, cityID, processID)
	local player = Players[playerID]
	--local process = GameInfo.Processes[processID]
	local city = player:GetCityByID(cityID)
	if processID == GameInfoTypes["PROCESS_FAITH"] 
	or processID == GameInfoTypes["PROCESS_GOLDEN_AGE"]
	    then
		return city:IsCapital()
	end	
	return true
end
GameEvents.CityCanMaintain.Add(Processes_CanMaintain)


-- ********************************************************
-- 删除地图错误资源
-- ********************************************************
function RemoveErrorResources()
	-- loop through all plots
	for iPlot = 0, Map.GetNumPlots() - 1 do
		local plot = Map.GetPlotByIndex(iPlot);
		if plot:GetResourceType()== GameInfoTypes.RESOURCE_TROOPS
		or plot:GetResourceType()== GameInfoTypes.RESOURCE_ELECTRICITY
		or plot:GetResourceType()== GameInfoTypes.RESOURCE_MANPOWER
		or plot:GetResourceType()== GameInfoTypes.RESOURCE_CONSUMER
		or plot:GetResourceType()== GameInfoTypes.RESOURCE_FOIEGRAS
		or (plot:GetResourceType()== GameInfoTypes.RESOURCE_NATRUALGAS		   
		and not (plot:GetTerrainType()==GameInfoTypes.TERRAIN_OCEAN 
		or plot:GetTerrainType()==GameInfoTypes.TERRAIN_COAST ))
		then
		   plot:SetResourceType(-1)
		end
	end
end
Events.SequenceGameInitComplete.Add(RemoveErrorResources);
--Events.LoadScreenClose.Add(RemoveErrorResources)


-- ********************************************************
-- 
-- ********************************************************
function PlayerCompletedQuest(iMajor, iMinor, iQuestType, iStartTurn, iOldInfluence, iNewInfluence)
    local pPlayer = Players[iMajor]
	if pPlayer== nil then
	 	return
	         end
        if pPlayer:HasWonder(GameInfoTypes.BUILDING_DIONYSUS) then
	    for row in GameInfo.MinorCivilizations() do	
				if row.Type ~=nil then 
					if Players[row.ID]:IsMinorCiv() then
					Players[row.ID]:ChangeMinorCivFriendshipWithMajor(iMajor,30) 
				 end
			 end
		 end
     end
end
GameEvents.PlayerCompletedQuest.Add(PlayerCompletedQuest) 

-- ****************************************
-- 
-- ****************************************
local BletchleyEraUnits = {[0] = GameInfoTypes.UNIT_SUMERIAN_SPEARMAN,[1] = GameInfoTypes.UNIT_SWORDSMAN,
 [2] = GameInfoTypes.UNIT_LONGSWORDSMAN, [3] = GameInfoTypes.UNIT_MUSKETMAN, [4] = GameInfoTypes.UNIT_RIFLEMAN,
 [5] = GameInfoTypes.UNIT_GREAT_WAR_INFANTRY, [6] = GameInfoTypes.UNIT_INFANTRY,[7] = GameInfoTypes.UNIT_MOTORISED_INFANTRY,
 [8] = GameInfoTypes.UNIT_MECHANIZED_INFANTRY,[9] = GameInfoTypes.UNIT_FW_AUTOMATON};

function BLETCHLEY_PARK(playerID) 
	local pPlayer = Players[playerID] 
	if pPlayer == nil or (not pPlayer:IsMajorCiv())  then
	 	return
	         end

  	if pPlayer:GetNumSpies() < 1  or (not pPlayer:HasWonder(GameInfoTypes.BUILDING_BLETCHLEY_PARK)) then
			return
		end

	         local production = 0
			 local gold = 0
			 local science = 0
			 for city in pPlayer:Cities() do
			 if  city:IsHasBuilding(GameInfoTypes["BUILDING_BLETCHLEY_PARK"]) then

			 for k, v in pairs(pPlayer:GetEspionageSpies()) do
			 local pSpyPlot = Map.GetPlot(v.CityX, v.CityY)

			 if pSpyPlot ~= nil then

			 local ecity = pSpyPlot:GetPlotCity()
			 
			 if ecity ~= nil then

			 if ecity:GetOwner() ~= pPlayer:GetID() then

				 science = science + math.max(0,ecity:GetYieldRate(YieldTypes.YIELD_SCIENCE))
				 gold = gold + math.max(0,ecity:GetYieldRate(YieldTypes.YIELD_GOLD))
				 production = production + math.max(0,ecity:GetYieldRate(YieldTypes.YIELD_PRODUCTION)) 
				           end
				        end
				    end
				 end

                 pPlayer:ChangeGold(gold)					 		 
				 city:ChangeProduction(production)

				 local iTeamID = pPlayer:GetTeam()
			     local iTeam = Teams[iTeamID]
			     local iTeamTechs = iTeam:GetTeamTechs()
			     local iPlayerID = pPlayer:GetID()

				 ChangeResearchProcess(pPlayer, iTeamID, iTeam, iTeamTechs, iPlayerID, science)
		       end
	       end

end
GameEvents.PlayerDoneTurn.Add(BLETCHLEY_PARK)



function BLETCHLEY_PARK_SPY(iPlayer, iSpy, iResult, iCityX, iCityY) 
   local Player = Players[iPlayer]

   local CityPlot = Map.GetPlot(iCityX,iCityY )
   local City=CityPlot:GetPlotCity()

   if Player == nil or (not pPlayer:IsMajorCiv()) 
   or (not Player:HasWonder(GameInfoTypes.BUILDING_BLETCHLEY_PARK))   then
      return
   end

   if  iResult then

   local plotX = iCityX+1
   local plotY = iCityY

   local era = Players[City:GetOwner()]:GetCurrentEra()
   local unitType = BletchleyEraUnits[era]

   local Unit  = Players[63]:InitUnit(unitType, plotX, plotY)
   local Unit2 = Players[63]:InitUnit(unitType, plotX, plotY)
   local Unit3 = Players[63]:InitUnit(unitType, plotX, plotY)

   Unit:ChangeExperience(120)
   Unit2:ChangeExperience(120)
   Unit3:ChangeExperience(120)

   Unit:JumpToNearestValidPlot()
   Unit2:JumpToNearestValidPlot()
   Unit3:JumpToNearestValidPlot()
 
   City:ChangeDamage(50)

   --City:ChangeResistanceTurns(2)
   end
end 	
 GameEvents.EspionageResult.Add(BLETCHLEY_PARK_SPY)  



-- **********************************************************************************************************************************************
--
-- **********************************************************************************************************************************************
function AG_BUFF(iPlayer)
	local player = Players[iPlayer]
	if player == nil 
	or (not player:IsMajorCiv()) 
	or (not player:IsAlive()) then
	 	return
	         end
  ----------------------------------------------------------------------------------
			 if  player:HasWonder(GameInfoTypes.BUILDING_AP) then
			 for otherPlayerID = 0, 64 - 1 do
                local otherPlayer = Players[otherPlayerID]
                if otherPlayer:IsAlive() then
                    --if otherPlayer:IsDenouncedPlayer(playerID) then
					if  otherPlayer:IsDenouncingPlayer(iPlayer) then			
			        for row in GameInfo.MinorCivilizations() do	
				    if row.Type ~=nil and Players[row.ID]:IsMinorCiv()  then 
					if Players[row.ID]:IsEverAlive() and Players[row.ID]:IsAlive() then
						--if pPlayer:IsProtectingMinor(row.ID) then
						Players[row.ID]:ChangeMinorCivFriendshipWithMajor(otherPlayerID,-80) 
						    end
                        end
                    end
                end
			end		
		end
	end

	----------------------------------------------------------------------------------
	if  player:CountNumBuildings(GameInfoTypes.BUILDING_FOREIGN_OFFICE) > 0 
	and player:GetNumSpies() >0 then
	            local sum= 0
				local agents = player:GetEspionageSpies()
				for i,v in ipairs(agents) do
					local iAgent = v
					if (v.IsDiplomat) then -- Only for diplomat!
						local pPlot = Map.GetPlot(iAgent.CityX, iAgent.CityY)
						local pCity = nil
						if(pPlot ~= nil) then
							pCity = pPlot:GetPlotCity()
							if(pCity ~= nil) then
								 local pOwner = Players[pCity:GetOwner()]
								 local science= math.max(0,pCity:GetYieldRateTimes100(YieldTypes.YIELD_SCIENCE) / 100)
				                 local gold= math.max(0,pCity:GetYieldRateTimes100(YieldTypes.YIELD_GOLD) / 100)
				                 local faith= pCity:GetFaithPerTurn()
								 local Culture= pCity:GetBaseJONSCulturePerTurn()
								--if (not pOwner:IsMinorCiv()) then -- Not for city states
									if  pOwner:IsDoF(iPlayer) then -- If not friend then begins attack
									    sum = 0.15
										else 
										sum = 0.25
									    end
					                    player:ChangeGold(gold*sum)
	                                    player:ChangeJONSCulture(Culture*sum)
					 					player:ChangeFaith(faith*sum)
					 					local iTeamID = player:GetTeam()
                     					local iTeam = Teams[iTeamID]
			         					local iTeamTechs = iTeam:GetTeamTechs()
			         					--local Boost = player:GetScience()

										if CanGetResearch(player, iTeamID, iTeam, iTeamTechs, iPlayer) then
									    iTeamTechs:ChangeResearchProgress(player:GetCurrentResearch(),sum*science, iPlayer)
			                            end

										if not CanGetResearch(player, iTeamID, iTeam, iTeamTechs, iPlayer)then
									    player:ChangeOverflowResearch(sum*science)
			        					end
                					 end
		      					 end
           					 end
        				end
	 				end
	 ----------------------------------------------------------------------------------

end
GameEvents.PlayerDoTurn.Add(AG_BUFF)



-- **********************************************************************************************************************************************
--/* Current assignments of members of popupInfo
--Data1 is the player id 
--Data2 is the gift "value" (Gold/Culture/Faith/Food amount, UnitId)
--Data3 is the friendship boost
--Option1 is first met (unchanged)
--Option2 is nil (unchanged)
--Text is suffix for the TXT_KEY_ to format with
-- **********************************************************************************************************************************************
function GiftBonus(iPlayer, iCS, iGold, iUnitType, iPlotX, iPlotY) 
   local Player = Players[iPlayer]
   local MinorPlayer=Players[iCS]

   if Player == nil or MinorPlayer== nil   then
      return
   end

    if  Player:CountNumBuildings(GameInfoTypes["BUILDING_FOREIGN_OFFICE"]) > 0 then
		MinorPlayer:ChangeMinorCivFriendshipWithMajor(iPlayer,50)  
    end
end 	
GameEvents.PlayerGifted.Add(GiftBonus)  


-- **********************************************************************************************************************************************
--
-- **********************************************************************************************************************************************
local SPY_RESULT_UNDETECTED = 0  --spy was not detected
local SPY_RESULT_DETECTED   = 1  --a spy was detected in the city, but the defensive player can't tell which player
local SPY_RESULT_IDENTIFIED = 2  --a spy was detected and identified in the city
local SPY_RESULT_KILLED     = 3  --a spy was detected, identified, and killed in the city
local SPY_RESULT_ELIMINATED = 4  --a spy was detected, identified, and killed in the city, in such an embarrassing way that another spy won't be recruited!

function EspionageStateResult(iPlayer, iSpy, iState, iCityX, iCityY) 
   local Player = Players[iPlayer]
   local CityPlot = Map.GetPlot(iCityX,iCityY )
  
   if Player== nil then
      return
   end

   if CityPlot== nil then
      return
   end

   local City=CityPlot:GetPlotCity()
   local otherPlayer=Players[City:GetOwner()]

   if otherPlayer == nil 
   or otherPlayer:IsMinorCiv() then
      return
   end

   if  (iState==5 or iState==7)
   and otherPlayer~= Player then

   ----------------------------------------------------------------
   if Player:HasWonder(GameInfoTypes.BUILDING_KGB) then
            local iTeamID = Player:GetTeam()
            local iTeam = Teams[iTeamID]
			local iTeamTechs = iTeam:GetTeamTechs()
			local Boost = Player:GetScience()
			Player:ChangeGold(4*Player:CalculateGoldRate()) 	

			if CanGetResearch(Player, iTeamID, iTeam, iTeamTechs, iPlayer) then
			iTeamTechs:ChangeResearchProgress(Player:GetCurrentResearch(),3*Boost, iPlayer)
			end

		    if not CanGetResearch(Player, iTeamID, iTeam, iTeamTechs, iPlayer)then
		    Player:ChangeOverflowResearch(3*Boost)
		    end
        end
    end
end 	
GameEvents.EspionageState.Add(EspionageStateResult)  

function LOCKUP(iPlayer, iSpy, iResult, iCityX, iCityY) 
   local Player = Players[iPlayer]
   local CityPlot = Map.GetPlot(iCityX,iCityY )
   local City=CityPlot:GetPlotCity()
   local otherPlayer=Players[City:GetOwner()]
   local rank=iSpy+1

   if otherPlayer == nil or otherPlayer:IsMinorCiv() or Player== nil  then
      return
   end

   if  iResult==SPY_RESULT_KILLED 
   and otherPlayer~= Player then

   ----------------------------------------------------------------
   if Player:HasWonder(GameInfoTypes.BUILDING_KGB)  then
         local iTeamID = Player:GetTeam()
         local iTeam = Teams[iTeamID]
		 local iTeamTechs = iTeam:GetTeamTechs()
		 local NumSciencePerTotal = 3*Player:GetScience()

		 ChangeResearchProcess(Player, iTeamID, iTeam, iTeamTechs, iPlayer, NumSciencePerTotal)
   end

   ----------------------------------------------------------------
   if City:IsHasBuilding(GameInfoTypes["BUILDING_LOCKUP"]) then
   local sum= math.floor(0.4*rank*otherPlayer:GetTotalJONSCulturePerTurn())
   local goldlose =Player:CalculateGoldRate()
   
   otherPlayer:ChangeJONSCulture(sum)
   Player:ChangeGold(-4*goldlose)
      end
   end
   ----------------------------------------------------------------
end 	
 GameEvents.EspionageResult.Add(LOCKUP)  


-- USER SETTINGS
--==========================================================================================================================
--GetUserSetting (DIFFICULTY_9!)
----------------------------------------------------------------------------------------------------------------------------
local gHandicap				= PreGame.GetHandicap(0)  ---难度等级
local Difficult				= Game:GetHandicapType()
local info = GameInfo.HandicapInfos[PreGame.GetHandicap(0)];
--iModifier = GameInfo.HandicapInfos[Game:GetHandicapType()].BarbarianBonus;
--slotInstance.HandicapLabel:LocalizeAndSetText( GameInfo.HandicapInfos( "ID = '" .. PreGame.GetHandicap( playerID ) .. "'" )().Description );

function IsUsingDifficult9()
	
		if PreGame.GetHandicap(0)== GameInfoTypes.HANDICAP_IMPOSSIBLE then
			return true
		end

	return false
end
local Difficult9Active = IsUsingDifficult9()

function AI_DIFFICULTY_REDUCE()
	 for i=0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
		local Player = Players[i]
		if Player:IsAlive() and Player:IsMajorCiv() then

	    if not Player:IsHuman()  then
		Player:SetHasPolicy(GameInfo.Policies["POLICY_AI_REDUCE"].ID,true)
		if Difficult9Active then
		Player:SetHasPolicy(GameInfo.Policies["POLICY_DIFFICULTY_9"].ID,true)
		--Player:ChangeGold(3000)
		       end
		   end

		end
	end
end
Events.SequenceGameInitComplete.Add(AI_DIFFICULTY_REDUCE)



local tWonders = {}
for row in DB.Query("SELECT ID FROM Buildings WHERE BuildingClass IN (SELECT Type FROM BuildingClasses WHERE MaxGlobalInstances = 1 OR MaxTeamInstances = 1 OR MaxPlayerInstances = 1)") do
	tWonders[row.ID] = true
end


function SetInvalidateCity()
	if city then
		local cityID = city:GetID();
		local playerID = city:GetOwner();
		Events.SpecificCityInfoDirty(playerID, cityID, CityUpdateTypes.CITY_UPDATE_TYPE_BANNER);
		Events.SpecificCityInfoDirty(playerID, cityID, CityUpdateTypes.CITY_UPDATE_TYPE_PRODUCTION);
	end
	Events.SerialEventGameDataDirty();
end

function AiIntoNewEra(eTeam, eEra, bFirst)
        local handicap = Game:GetHandicapType();
	    if   handicap > 5 then
	    for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
	    local pPlayer = Players[iPlayer]
	   	if pPlayer:IsAlive() then
	    if pPlayer:GetTeam() == eTeam then

		 if pPlayer:IsMajorCiv() and  not pPlayer:IsHuman()  then

		 pPlayer:ChangeGold(2000*(pPlayer:GetCurrentEra()+1));
		 pPlayer:ChangeOverflowResearch(3*pPlayer:GetScience())

		 for city in pPlayer:Cities() do
	     local iCurrentBuilding = city:GetProductionBuilding();
	     if iCurrentBuilding > -1 and (not tWonders[iCurrentBuilding])  then
	     local prod = city:GetProductionNeeded();
	     city:SetProduction(prod);
	     SetInvalidateCity();
		              end
		           end
		        end
		     end
		  end
	   end
    end
 end
GameEvents.TeamSetEra.Add(AiIntoNewEra)




function Volcano_CanFound(iPlayer, iX, iY)
	local pPlot = Map.GetPlot(iX, iY)
	if pPlot:GetFeatureType() == FeatureTypes.FEATURE_NEW_VOLCANO then 
		return false
	end
	return true
end
GameEvents.PlayerCanFoundCity.Add(Volcano_CanFound)




if Difficult9Active  then

function CanHaveInstaHeal(iPlayer, iUnit, iPromotionType)
  local Player = Players[iPlayer]
  if iPromotionType == GameInfoTypes.PROMOTION_INSTA_HEAL then
  if Player:IsMajorCiv() and (not Player:IsHuman()) then
  return true
  end
  return false
  end
  return true
end
GameEvents.CanHavePromotion.Add(CanHaveInstaHeal)



function UpdateGreatPerson(eTeam, eEra, bFirst)
       local TookSomething = 0	
	   if  (bFirst) then
	   for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
	   local pPlayer = Players[iPlayer]
	   if pPlayer:IsAlive() then
	
	   if pPlayer:GetTeam() == eTeam then
    	---------------------------------------
		 if pPlayer:IsMajorCiv() and (not pPlayer:IsHuman())  then
		 local capital = pPlayer:GetCapitalCity() 
		 local capitalX = capital:GetX()
		 local capitalY = capital:GetY()

		 pPlayer:InitUnit(GameInfoTypes.UNIT_ENGINEER, capitalX, capitalY)
		 pPlayer:InitUnit(GameInfoTypes.UNIT_WRITER, capitalX, capitalY)
		 pPlayer:InitUnit(GameInfoTypes.UNIT_ARTIST, capitalX, capitalY)
         pPlayer:ChangeOverflowResearch(2*pPlayer:GetScience())
		 end

		     end
		  end
	   end
    end
 end
GameEvents.TeamSetEra.Add(UpdateGreatPerson)


function IsAiMajorCiv(Player)
    if  Player:IsMajorCiv() 
	and not  Player:IsHuman() 
	then
        return true 
    else
        return false
    end
end


function StealTech(iPlayer)
local pPlayer = Players[iPlayer]
if pPlayer == nil or (not pPlayer:IsMajorCiv()) or pPlayer:IsHuman() then
	 	return
	         end
local iTeam = pPlayer:GetTeam()
local pTeam = Teams[iTeam]

for i=0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
	local pOtherPlayer = Players[i]
	if pOtherPlayer:IsHuman() then
	local iOtherTeam = pOtherPlayer:GetTeam()
		local pOtherTeam = Teams[iOtherTeam]
		for tech in GameInfo.Technologies() do
			if  pPlayer:CanResearch(tech.ID) and pOtherTeam:IsHasTech(tech.ID) then
				pTeam:SetHasTech(tech.ID, true, iPlayer, false, true)
	         end 
	      end	
       end
    end
 end	
GameEvents.PlayerDoTurn.Add(StealTech)

end







