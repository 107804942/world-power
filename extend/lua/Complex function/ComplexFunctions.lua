-- DateCreated: 2023
--------------------------------------------------------------
include("Rog_SaveUtils.lua"); MY_MOD_NAME = "世界强权";
include("PlotIterators.lua");
include("FunctionUtilities.lua")
include("FLuaVector.lua")
include("UtilityFunctions")


if Game.IsWPActive() then


local ATBTEnergy = 
	{[0] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA,   [1] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_1, 
	 [2] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_2, [3] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_3,
	 [4] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_4, [5] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_5, 
	 [6] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_6, [7] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_7, 
	 [8] = GameInfoTypes.PROMOTION_SPACE_BATTLECRUISER_MANA_8}

function SomeUnitEffects(iPlayer)
		local player = Players[iPlayer]
		if player==nil then
		return
	         end
		for unit in player:Units() do  

		if unit:GetUnitType() == GameInfoTypes["UNIT_SPACESHIP"] then
		local iSpaceBattleCruiserEnergy = load(unit, "SpaceBattleCruiserEnergy") or 0
		if iSpaceBattleCruiserEnergy< 8 then
				save(unit, "SpaceBattleCruiserEnergy", iSpaceBattleCruiserEnergy + 1)       
				for i = 0, 8 do
				unit:SetHasPromotion(ATBTEnergy[i], (i == load(unit, "SpaceBattleCruiserEnergy")))
				end
		    end
	    end

		if  unit:GetUnitType() == GameInfoTypes["UNIT_NAVALCARRIER03P"] then
	    local iNumFighters = unit:GetCargo()
		local iNumFightersIn =unit:CargoSpace()  
		local pPlot = unit:GetPlot()
	    if iNumFighters-iNumFightersIn >=2  then
		player:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
		player:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
		else
	    player:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
		   end
	    end	

   end
end
GameEvents.PlayerDoTurn.Add(SomeUnitEffects)


-- **********************************************************************************************************************************************
-- 浮石章鱼
-- **********************************************************************************************************************************************
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
	  end
  end
}
LuaEvents.UnitPanelActionAddin(PlagueMissionButton)

-----------------------------------------------------机甲-----------------------------------------------------------------------

MechRiotControlButton = {
  Name = "Mech Control",
  Title = "TXT_KEY_SP_BTNNOTE_UNIT_RIOT_CONTROL_SHORT2", -- or a TXT_KEY
  OrderPriority = 200, -- default is 200
  IconAtlas = "SP_UNIT_ACTION_ATLAS2", -- 45 and 64 variations required
  PortraitIndex = 25,
  ToolTip = "TXT_KEY_SP_BTNNOTE_UNIT_RIOT_CONTROL2", -- or a TXT_KEY_ or a function
  
 
  Condition = function(action, unit)
    return unit:CanMove() and  unit:GetUnitType() == GameInfoTypes.UNIT_MECH and unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_HPMOD1"].ID)
  end, -- or nil or a boolean, default is true
  
 Disabled = function(action, unit) 
    local plot = unit:GetPlot();
    if not plot:IsCity() then return true end;
    local city = plot:GetPlotCity()
    return not city or city:GetOwner() ~= unit:GetOwner() or not city:IsResistance() ;
  end, -- or nil or a boolean, default is false
  
  Action = function(action, unit, eClick) 
	local plot = unit:GetPlot()
    local city = plot:GetPlotCity()
    local player = Players[unit:GetOwner()]
	local citypop = math.ceil(city:GetPopulation()/2)
    if not city then return end
    
    if unit then
    	city:ChangeResistanceTurns(-city:GetResistanceTurns())
		city:SetPopulation(citypop, true) 
		Events.AudioPlay2DSound("AS2D_MECH_POWER")
	   	unit:SetMoves(0)    
    end
  end
};
LuaEvents.UnitPanelActionAddin(MechRiotControlButton);




local lButtonDown = false
local rButtonDown = false
local SpaceBattleCruiserSkill = 0
local highlightedPlots = {}

function CheckSpaceBattleCruiserButtonValidity(unit)
		for i = 0, 3 do
			if unit:IsHasPromotion(ATBTEnergy[i]) then
				return false
			end
		end
	return true;
end

function CheckSpaceBattleCruiserButtonValidity2(unit)
		for i = 0, 1 do
			if unit:IsHasPromotion(ATBTEnergy[i]) then
				return false
			end
		end
	return true;
end


function DisplayCruiserHitArrow()

	local unit = UI.GetHeadSelectedUnit();
	if unit and unit:GetUnitType() == GameInfoTypes["UNIT_SPACESHIP"] then
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
				if unit:GetUnitType() == GameInfoTypes["UNIT_SPACESHIP"] then
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

	if unit and unit:GetUnitType() == GameInfoTypes["UNIT_SPACESHIP"] then
		attacker = unit
	end
	
	if attacker == nil then
		return
	end

	--get bombard end hex
	if  attacker and (Map.PlotDistance(attacker:GetX(), attacker:GetY(), PlotX, PlotY ) <= 30 )  then
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


	if unit and unit:GetUnitType() == GameInfoTypes["UNIT_SPACESHIP"] then
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
				if unit:GetUnitType() == GameInfoTypes["UNIT_SPACESHIP"] then
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
	if unit and unit:GetUnitType() == GameInfoTypes["UNIT_SPACESHIP"] then
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
		if  unit:GetMoves() <= 0 then
			return false
		end
		local pPlayer = Players[Game:GetActivePlayer()];
		if unit:CanMove() and unit:IsHasPromotion(GameInfoTypes.PROMOTION_ANTI_ANTI_MOUNTED_BONUS)
		and unit:GetCurrHitPoints() > 99
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



-- ********************************************************
-- 替换sp
-- ********************************************************	
UnitEVACButton = {
    Name = "Air EVAC",
    Title = "TXT_KEY_SP_BTNNOTE_UNIT_AIREVAC_SHORT", -- or a TXT_KEY
    OrderPriority = 200, -- default is 200
    IconAtlas = "SP_UNIT_ACTION_ATLAS", -- 45 and 64 variations required
    PortraitIndex = 11,
    ToolTip = "TXT_KEY_SP_BTNNOTE_UNIT_AIREVAC", -- or a TXT_KEY_ or a function

    Condition = function(action, unit)
        return unit:CanMove() and (unit:GetUnitType() == GameInfoTypes.UNIT_TASKFORCE_141  or unit:GetUnitType() == GameInfoTypes.UNIT_GHOST) and Players[unit:GetOwner()]:GetCapitalCity() ~= nil;
    end, -- or nil or a boolean, default is true

    Disabled = function(action, unit)
        return false
    end, -- or nil or a boolean, default is false

    Action = function(action, unit, eClick)
        local player = Players[unit:GetOwner()]
        local pCity = player:GetCapitalCity()
        local pPlot = pCity
        unit:SetXY(pPlot:GetX(), pPlot:GetY())
        unit:JumpToNearestValidPlot()
        unit:SetMoves(0)
        print("Evac!")

    end
};
LuaEvents.UnitPanelActionRemove(UnitEVACButton);
LuaEvents.UnitPanelActionAddin(UnitEVACButton);


GlobalStrikeButton = {
    Name = "Global Strike",
    Title = "TXT_KEY_SP_BTNNOTE_GLOBAL_STRIKE_SHORT", -- or a TXT_KEY
    OrderPriority = 200, -- default is 200
    IconAtlas = "SP_UNIT_ACTION_ATLAS", -- 45 and 64 variations required
    PortraitIndex = 10,
    ToolTip = "TXT_KEY_SP_BTNNOTE_GLOBAL_STRIKE", -- or a TXT_KEY_ or a function
    Condition = function(action, unit)
        return unit:CanMove() and unit:GetUnitType() == GameInfoTypes.UNIT_ORBITAL_STRIKE;
    end, -- or nil or a boolean, default is true

    --  Disabled = function(action, unit) 
    --    
    --    return 
    --  end, -- or nil or a boolean, default is false

    Action = function(action, unit, eClick)

        unit:SetMoves(0)

        for playerID, player in pairs(Players) do
            if player and player:IsAlive() and player:GetNumCities() >= 1 then
                if not player:IsHuman() then
                    if PlayerAtWarWithHuman(player) then
                        for city in player:Cities() do
                            local CityMaxHP = city:GetMaxHitPoints()
                            --city:SetDamage(CityMaxHP)
                            city:ChangeDamage(250)
                            Events.AudioPlay2DSound("AS2D_SATELLITE_CANNON")
                            Events.GameplayAlertMessage( Locale.ConvertTextKey( "TXT_KEY_SP_NOTIFICATION_SATELLITE_CANNON"))
                            print("Global Strike!")
                        end
                    end
                end
            end
        end

    end

};
LuaEvents.UnitPanelActionRemove(GlobalStrikeButton);
LuaEvents.UnitPanelActionAddin(GlobalStrikeButton);

MoralBoostButton = {
    Name = "Moral Boost",
    Title = "TXT_KEY_SP_BTNNOTE_UNIT_MORAL_BOOST_SHORT", -- or a TXT_KEY
    OrderPriority = 200, -- default is 200
    IconAtlas = "SP_UNIT_ACTION_ATLAS", -- 45 and 64 variations required
    PortraitIndex = 22,
    ToolTip = "TXT_KEY_SP_BTNNOTE_UNIT_MORAL_BOOST", -- or a TXT_KEY_ or a function

    Condition = function(action, unit)
        return unit:CanMove() 
		and (unit:GetUnitClassType() == GameInfo.UnitClasses.UNITCLASS_GREAT_GENERAL.ID 
		or unit:GetUnitClassType() == GameInfo.UnitClasses.UNITCLASS_GREAT_ADMIRAL.ID 
		--or unit:GetUnitType() == GameInfoTypes["UNIT_POLISH_PZLW3_HELICOPTER"] 
		or unit:GetUnitType() == GameInfoTypes["UNIT_HUN_SHAMAN"]);
    end, -- or nil or a boolean, default is true

    Disabled = function(action, unit)
        return unit:GetPlot() == nil or unit:GetPlot():GetNumUnits() <= 1;
    end, -- or nil or a boolean, default is false

    Action = function(action, unit, eClick)
        if unit:GetPlot() == nil or unit:GetPlot():GetNumUnits() <= 1 then
            return;
        end
        unit:ClearSamePlotPromotions()
        print("Moral Boost!")
        unit:SetMoves(0)
    end
};
LuaEvents.UnitPanelActionRemove(MoralBoostButton);
LuaEvents.UnitPanelActionAddin(MoralBoostButton);

-- ********************************************************
-- end
-- ********************************************************


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
					if pUnit:GetUnitType() == GameInfoTypes["UNIT_SPACESHIP"]  then
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
						save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") - 4)
							Events.AudioPlay2DSound("AS2D_ARCTURUS_YAMATO_CANNON")
							for i = 0, 8 do
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
						if pUnit:GetUnitType() == GameInfoTypes["UNIT_SPACESHIP"] then

						if pPlot~=pUnit:GetPlot()  then
						local plotDistance = Map.PlotDistance(pUnit:GetX(),pUnit:GetY(), pPlot:GetX(), pPlot:GetY());
						if plotDistance <= 30 then
						if load(pUnit, "SpaceBattleCruiserEnergy")~=nil and load(pUnit, "SpaceBattleCruiserEnergy")>=2 then
						save(pUnit, "SpaceBattleCruiserEnergy", load(pUnit, "SpaceBattleCruiserEnergy") - 2)
							for i = 0, 8 do
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
				Events.AddPopupTextEvent(PositionCalculator(pPlot:GetX(), pPlot:GetY()), Locale.ConvertTextKey("TXT_KEY_ALERT_SPY_TRANSPORT",pSelUnit:GetName()),0.1)
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

				local unit  = pPlayer:InitUnit(GameInfoTypes["UNIT_GARIO_BATTLESUIT"], pPlot:GetX(),pPlot:GetY())
				local unit2 = pPlayer:InitUnit(GameInfoTypes["UNIT_GARIO_BATTLESUIT"], pPlot:GetX(),pPlot:GetY())
			
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
						pSUnit:ChangeDamage(99)
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

end
                    

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

  if pUnit:GetDomainType()~=DomainTypes.DOMAIN_AIR and not pUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_SPACESHIP"].ID) then
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
		if pPlayer:HasWonder(GameInfoTypes.BUILDING_SPHINX) then
		pPlayer:ChangeGold(1000)
	end
end
GameEvents.NaturalWonderDiscovered.Add(BuffForNaturalWonderDiscovered)

-- ********************************************************
-- 
-- ********************************************************
function PlayerCompletedQuest(iMajor, iMinor, iQuestType, iStartTurn, iOldInfluence, iNewInfluence)
    local pPlayer = Players[iMajor]
	local MinorPlayer= Players[iMinor]
	if pPlayer== nil then
	 	return
	         end
		if iNewInfluence > iOldInfluence then
        if pPlayer:HasWonder(GameInfoTypes.BUILDING_DIONYSUS) then
		MinorPlayer:ChangeMinorCivFriendshipWithMajor(iMajor,30) 
        end
	end
end
GameEvents.PlayerCompletedQuest.Add(PlayerCompletedQuest) 

-- **********************************************************************************************************************************************
--
-- **********************************************************************************************************************************************
function Denounce_BUFF(PlayerID, OtherPlayerID)
	local player = Players[PlayerID]
	local otherPlayer= Players[OtherPlayerID]
	if player == nil or otherPlayer== nil  then
	return
	end
  ----------------------------------------------------------------------------------
	 if  otherPlayer:HasWonder(GameInfoTypes.BUILDING_AP) then
		 for row in GameInfo.MinorCivilizations() do	
		 if row.Type ~=nil and Players[row.ID]:IsMinorCiv()  then 
		 if Players[row.ID]:IsEverAlive() and Players[row.ID]:IsAlive() then
					--if pPlayer:IsProtectingMinor(row.ID) then
					Players[row.ID]:ChangeMinorCivFriendshipWithMajor(PlayerID,-80) 
                end
			end		
		end
	end
end
GameEvents.DoDenounce.Add(Denounce_BUFF)


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
   if Player:HasWonder(GameInfoTypes.BUILDING_FOREIGN_OFFICE) then
            local iTeamID = Player:GetTeam()
            local iTeam = Teams[iTeamID]
			local iTeamTechs = iTeam:GetTeamTechs()
			local Boost = Player:GetScience()
			Player:ChangeGold(4*Player:CalculateGoldRate()) 	
			ChangeResearchProcess(Player, iTeamID, iTeam, iTeamTechs, iPlayer, 3*Boost)	
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
function RemoveErrorResources()
	-- loop through all plots
	for iPlot = 0, Map.GetNumPlots() - 1 do
		local plot = Map.GetPlotByIndex(iPlot);
		if (plot:IsNaturalWonder() or plot:HasAnyNaturalWonder() )
		then
		   plot:SetResourceType(-1)
		end
	end
end
Events.LoadScreenClose.Add(RemoveErrorResources)


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

function IsUsingDifficult10()
	
		if PreGame.GetHandicap(0)== GameInfoTypes.HANDICAP_IMPOSSIBLE_EXTREM then
			return true
		end

	return false
end
local Difficult9Active = IsUsingDifficult9()
local Difficult10Active = IsUsingDifficult10()

function AI_DIFFICULTY_REDUCE()
	    for i=0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
		local Player = Players[i]
		if Player:IsAlive() and not Player:IsHuman()  then

		Player:SetHasPolicy(GameInfo.Policies["POLICY_AI_REDUCE"].ID,true)

		if Game:GetHandicapType()>8 then
		Player:SetHasPolicy(GameInfo.Policies["POLICY_DIFFICULTY_9"].ID,true)
		end

	    if PreGame.GetHandicap(0)== GameInfoTypes.HANDICAP_IMPOSSIBLE_EXTREM  then
		Player:SetHasPolicy(GameInfo.Policies["POLICY_DIFFICULTY_10"].ID,true)
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



function AiIntoNewEra(ePlayer, eEra, bFirst)
        local handicap = Game:GetHandicapType()
		local pPlayer = Players[ePlayer]
	    if   handicap >= 7 and pPlayer:IsAlive() then
		if pPlayer:IsMajorCiv() and  not pPlayer:IsHuman()  then
		--------------------------------------------------
		if eEra == GameInfoTypes["ERA_INDUSTRIAL"] then
		pPlayer:ChangeNumResourceTotal(GameInfoTypes.RESOURCE_GUNPOWDER,200);
		end
        --------------------------------------------------
		if eEra == GameInfoTypes["ERA_MODERN"] then
		pPlayer:ChangeOverflowResearch(6*pPlayer:GetScience())
		end
		--------------------------------------------------
		if eEra == GameInfoTypes["ERA_POSTMODERN"] then
		pPlayer:ChangeOverflowResearch(9*pPlayer:GetScience())
		end

		--------------------------------------------------
		if Difficult9Active or  Difficult10Active then
		pPlayer:ChangeOverflowResearch(4*pPlayer:GetScience())
		end
		--------------------------------------------------
		pPlayer:ChangeGold(2000*(pPlayer:GetCurrentEra()+1))
		pPlayer:ChangeOverflowResearch(5*pPlayer:GetScience())

		for city in pPlayer:Cities() do
	    local iCurrentBuilding = city:GetProductionBuilding()
		local projectProduction = city:GetProductionProject()

	    if iCurrentBuilding > -1 and (not tWonders[iCurrentBuilding])  then
	    local BuildingPro = city:GetProductionNeeded();
	    city:SetProduction(BuildingPro)
	    SetInvalidateCity()
		--elseif projectProduction ~= -1 then
		--local projectPro = city:GetProductionNeeded();
	   -- city:SetProduction(projectPro)
	    --SetInvalidateCity()
		     end
		  end

	   end
    end
 end
GameEvents.PlayerSetEra.Add(AiIntoNewEra)



if  Difficult10Active then
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



function CanHavePromotion(iPlayer, iUnit, iPromotionType)
  local pUnit = Players[iPlayer]:GetUnitByID(iUnit)


  if iPromotionType == GameInfoTypes.PROMOTION_GUN_2 then
  if pUnit:GetBaseRangedCombatStrength()>0   then 
  return false
     end
  end

  if iPromotionType == GameInfoTypes.PROMOTION_DRILL_4 or iPromotionType == GameInfoTypes.PROMOTION_SHOCK_4 then
  if pUnit:GetUnitClassType() ~=GameInfo.UnitClasses.UNITCLASS_GLADIATOR.ID then
  return false
     end
  end

   return true
end
GameEvents.CanHavePromotion.Add(CanHavePromotion)



function ProduceCopy(iPlayer, iUnit, iGreatWork)
	local player = Players[iPlayer]
	if player == nil or (not player:IsMajorCiv())   then
		return
	end 
	if player:GetNumCities() <= 0 or not player:HasWonder(GameInfoTypes.BUILDING_KARLSTEJN)   then
		return
	end

		local gw
		for i,v in ipairs(player:GetGreatWorks(4)) do
			if load(player,"HaveCopied" .. Game.GetGreatWorkName(v.Index)) == nil and Game.GetGreatWorkCreator(v.Index) == iPlayer then
				gw = v.Index
				save(player,"HaveCopied" .. Game.GetGreatWorkName(v.Index), true)
				break
			end
		end
		if gw then
			local city = player:GetCityOfClosestGreatWorkSlot(player:GetCapitalCity():GetX(), player:GetCapitalCity():GetY(), GameInfoTypes["GREAT_WORK_SLOT_MUSIC"])
			if city then
		        local building = player:GetBuildingOfClosestGreatWorkSlot(player:GetCapitalCity():GetX(), player:GetCapitalCity():GetY(), GameInfoTypes["GREAT_WORK_SLOT_MUSIC"])
		        if  building then
			        building = GameInfo.Buildings[building]
			        local buildingClass = building.BuildingClass
			        local availableSlots = building.GreatWorkCount
					for slot = 0, availableSlots-1, 1 do
						if  city:GetBuildingGreatWork(GameInfoTypes[buildingClass], slot) == -1 then
							city:SetBuildingGreatWork(GameInfoTypes[buildingClass],slot,gw)
							break
						--end
					end
				end
			end
		end
	end
end
GameEvents.GreatWorkCreated.Add(ProduceCopy)




function RemoveJungle(iPlayer, iUnit, iX, iY, iBuild)
   if iBuild == GameInfoTypes.BUILD_REMOVE_JUNGLE 
   or iBuild == GameInfoTypes.BUILD_REMOVE_FOREST then
   local  pPlot = Map.GetPlot(iX, iY)
   if  pPlot:GetResourceType()==GameInfoTypes.RESOURCE_LUMBER then
   pPlot:SetResourceType(-1)
       end
    end
 end
GameEvents.PlayerBuilt.Add(RemoveJungle)



-- **********************************************************************************************************************************************
-- 购买地块
-- **********************************************************************************************************************************************
function GetCultureGain(pPlayer)
	local iEra = pPlayer:GetCurrentEra()
	return (iEra + 1) 
end


function MagaBoughtPlot(iPlayer, iCity, iPlotX, iPlotY, bGold, bCulture)  
	local Player = Players[iPlayer]
	--local plot = Map.GetPlot(iPlotX, iPlotY)
	local city = Player:GetCityByID(iCity)
	if Player:HasTrait(GameInfoTypes["TRAIT_RIVER_EXPANSION"]) then
	--if bGold then
	local iGain = GetCultureGain(Player)
	--city:ChangeProduction(20*iGain)
	city:ChangeOverflowProduction(10*iGain)
	--Player:ChangeJONSCulture(20*iGain)
	  -- end
	end
end
GameEvents.CityBoughtPlot.Add(MagaBoughtPlot)


-- ********************************************************
-- 环球航行
-- ********************************************************
local g_NotificationType = NotificationTypes.NOTIFICATION_GENERIC
function OnMagellanNotificationId(id)
  print(string.format("Setting magellan notification id to %i", id))
  g_NotificationType = id
end
LuaEvents.MagellanNotificationId.Add(OnMagellanNotificationId)

function OnCircumnavigatedGlobe(iTeam)
  local pPlayer = Players[Game.GetActivePlayer()]
  local sHead = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_HEAD")
  local sText = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_TEXT_UNKNOWN")

  local Team = Teams[iTeam]
  local Player = Players[Team:GetLeaderID()];

  local plot =  Player:GetCapitalCity():Plot()
  local Unit  = Player:InitUnit(GameInfoTypes.UNIT_SCIENTIST, plot:GetX(), plot:GetY())

  if (Game.GetActiveTeam() == iTeam) then
    sText = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_TEXT_YOU")
  else
    if (Teams[Game.GetActiveTeam()]:IsHasMet(iTeam)) then
      sText = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_TEXT_KNOWN", Players[Teams[iTeam]:GetLeaderID()]:GetCivilizationShortDescriptionKey())
	end
  end

  pPlayer:AddNotification(g_NotificationType, sText, sHead, -1, -1, -1, -1)
end
GameEvents.CircumnavigatedGlobe.Add(OnCircumnavigatedGlobe)
LuaEvents.MagellanNotificationIdRequest()

-- ********************************************************
-- 
-- ********************************************************  
 function ghostdamage(iPlayer, iUnit, iFromX, iFromY, iToX, iToY) 
   local Player = Players[iPlayer]
   local pUnit = Player:GetUnitByID(iUnit)
   local ToPlot = Map.GetPlot(iToX, iToY)
   if pUnit == nil or (not pUnit:IsHasPromotion(GameInfoTypes.PROMOTION_GHOST_POWER)) then
   return
   end
   for i = 0, 5 do
			local adjPlot = Map.PlotDirection(iToX,iToY, i)
			if adjPlot ~= nil then
			local unitCount = adjPlot:GetNumUnits()
			if unitCount > 0 then
				for i = 0, unitCount - 1, 1 do
				local pFoundUnit = adjPlot:GetUnit(i)
				if Player:IsAtWarWith(pFoundUnit:GetOwner())   then
				pFoundUnit:ChangeDamage(33, Player)
				end
			 end
		 end
	  end
   end
end 	
GameEvents.ParadropAt.Add(ghostdamage)  



local iFreezeCollectionID = GameInfoTypes["PROMOTION_COLLECTION_FREEZE_BOMB"]
local iFreezedCollectionID = GameInfoTypes["PROMOTION_COLLECTION_FREEZE_EFFECT"]
GameEvents.OnTriggerAddEnemyPromotion.Add(function(eThisPromotionType, eThisPromotionCollection, eThisBattleType, iThisPlayer,
 iThisUnit, iThisUnitType, eThatPromotionType,eThatPromotionCollection, iThatPlayer, iThatUnit, iThatUnitType)

    if eThisPromotionCollection ~= iFreezeCollectionID or eThatPromotionCollection ~= iFreezedCollectionID then
        return;
    end

    local pThisPlayer = Players[iThisPlayer];
    local pThatPlayer = Players[iThatPlayer];
    if pThisPlayer == nil or pThatPlayer == nil then
        return;
    end

    local pThisUnit = pThisPlayer:GetUnitByID(iThisUnit);
    local pThatUnit = pThatPlayer:GetUnitByID(iThatUnit);
    if pThisUnit == nil or pThatUnit == nil then
        return;
    end

    if eThatPromotionType == -1 then
        return;
    end

    local thisUnitName = pThisUnit:GetName();
    local thatUnitName = pThatUnit:GetName();
    if pThisPlayer:IsHuman() then
        local text = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_ENEMY_FREEZE", thisUnitName, thatUnitName);
        Events.GameplayAlertMessage(text);
    end
    if pThatPlayer:IsHuman() then
        local text = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_US_FREEZE", thisUnitName, thatUnitName);
        Events.GameplayAlertMessage(text);
    end
end);
              
----------------------------------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------------------------------
-- 根据游戏速度调整升级事件
local iGameSpeed = GameInfo.GameSpeeds[Game.GetGameSpeedType()].GrowthPercent / 100
local TownFortLv1_Threshold = 10 * iGameSpeed
local TownFortLv2_Threshold = 15 * iGameSpeed
local TownFortLv1 = GameInfoTypes["IMPROVEMENT_TRADING_POST"] 
local TownFortLv2 = GameInfoTypes["IMPROVEMENT_TOWN"]  
local TownFortLv3 = GameInfoTypes["IMPROVEMENT_LARGE_TOWN"]  

function GetTownFortXPPerTurn(iX, iY, iImprovementType, iCurrentXP, iOwner, iWorkCity)
	if Players[iOwner] == nil
	or Players[iOwner]:GetCityByID(iWorkCity) == nil 
	or Map.GetPlot(iX, iY) == nil
    then
		return;
	end

	local pPlayer = Players[iOwner];
	local pCity = pPlayer:GetCityByID(iWorkCity);
	local plot = Map.GetPlot(iX, iY);
	-- print("iImprovementType="..iImprovementType);
	if iImprovementType == TownFortLv1 then
		-- 每回合5点经验
		if not plot:IsImprovementPillaged() then
	    	if plot:IsBeingWorked() then
				return 100 / TownFortLv1_Threshold;
				-- return 5;
			end
		end
	elseif iImprovementType == TownFortLv2 then
		if not plot:IsImprovementPillaged() then
	    	if plot:IsBeingWorked() then
				return 100 / TownFortLv2_Threshold;
			end	
		end
		return -50 / TownFortLv2_Threshold;
	elseif iImprovementType == TownFortLv3 then
		if not plot:IsImprovementPillaged() then
	    	if plot:IsBeingWorked() then
				return 5;
			end
		end
		return -2;
	end
	return 0;
end
GameEvents.GetImprovementXPPerTurn.Add(GetTownFortXPPerTurn)







