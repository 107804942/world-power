-- Written by rog


local function TextColor( c, s )
	return c..(s or "???").."[ENDCOLOR]"
end

local function BuildingColor( s )
	return TextColor("[COLOR_YIELD_FOOD]", s)
end


local function GetCivBuilding( civilizationType, buildingClassType )
	if buildingClassType then
		if civilizationType and GameInfo.Civilization_BuildingClassOverrides{ CivilizationType = civilizationType, BuildingClassType = buildingClassType }() then
			local building = GameInfo.Civilization_BuildingClassOverrides{ CivilizationType = civilizationType, BuildingClassType = buildingClassType }()
			return building and GameInfo.Buildings[ building.BuildingType ]
		end
		local buildingClass = GameInfo.BuildingClasses[ buildingClassType ]
		return buildingClass and GameInfo.Buildings[ buildingClass.DefaultBuilding ]
	end
end


------------------------------------------------------
-- Short Unit Tip
function ShortUnitTip( unit )
	local activePlayerID = Game.GetActivePlayer()
	local activeTeamID = Game.GetActiveTeam()
	local activeTeam = Teams[activeTeamID]

	local unitOwnerID = unit:GetOwner()
	local unitOwner = Players[unitOwnerID]
	local unitTeamID = unit:GetTeam()

	local civAdjective = unitOwner:GetCivilizationAdjective()
	local nickName = unitOwner:GetNickName()

	local unitTip
	if activeTeamID == unitTeamID or ( unitOwner:IsMinorCiv() and unitOwner:IsAllies( activePlayerID ) ) then
		unitTip = "[COLOR_POSITIVE_TEXT]"
	elseif activeTeam:IsAtWar( unitTeamID ) then
		unitTip = "[COLOR_NEGATIVE_TEXT]"
	else
		unitTip = "[COLOR_WHITE]"
	end
	unitTip = unitTip .. Locale.ConvertTextKey(unit:GetNameKey()) .. "[ENDCOLOR]"

	-- Player using nickname
	if PreGame.IsMultiplayerGame() and nickName and #nickName > 0 then

		unitTip = Locale.ConvertTextKey( "TXT_KEY_MULTIPLAYER_UNIT_TT", nickName, civAdjective, unitTip )

	elseif activeTeam:IsHasMet( unitTeamID ) then

		unitTip = Locale.ConvertTextKey( "TXT_KEY_PLOTROLL_UNIT_DESCRIPTION_CIV", civAdjective, unitTip )
		if unit:HasName() then
			unitTip = Locale.ConvertTextKey(unit:GetNameNoDesc()) .. " (" .. unitTip .. ")"
		end
	end

	local originalOwnerID = unit:GetOriginalOwner()
	local originalOwner = originalOwnerID and Players[originalOwnerID]
	if originalOwner and originalOwnerID ~= unitOwnerID and activeTeam:IsHasMet( originalOwner:GetTeam() ) then
		unitTip = unitTip .. " (" .. originalOwner:GetCivilizationAdjective() .. ")"
	end

	-- Debug stuff
	if Game.IsDebugMode() then
		unitTip = unitTip .. " (".. tostring(unitOwnerID) ..":" .. tostring(unit:GetID()) .. ")"
	end

	-- Moves & Combat Strength
	local unitMoves = 0
	local unitStrength = unit.GetBaseCombatStrength and unit:GetBaseCombatStrength() or unit:GetCombatStrength() --BE stupid function name change
	-- todo unit:GetMaxDefenseStrength()
	local rangedStrength = unit.GetBaseRangedCombatStrength and unit:GetBaseRangedCombatStrength() or unit:GetRangedCombatStrength() --BE stupid function name change


	----unit hp
	local hp = unit:GetMaxHitPoints();


	if unit:GetDomainType() == DomainTypes.DOMAIN_AIR then
		unitStrength = rangedStrength
		rangedStrength = 0
		unitMoves = unit:Range()
	else
		if unitOwnerID == activePlayerID then
			unitMoves = unit:MovesLeft()
		else
			unitMoves = unit:MaxMoves()
		end
		unitMoves = unitMoves / GameDefines.MOVE_DENOMINATOR
	end

	-- In Orbit?
	if unit.IsInOrbit and unit:IsInOrbit() then
		unitTip = unitTip .. " " .. "[COLOR_CYAN]" .. L"TXT_KEY_PLOTROLL_ORBITING" .. "[ENDCOLOR]"

	else
		-- Moves
		if unitMoves > 0 then
			unitTip = string.format("%s %.3g[ICON_MOVES]", unitTip, unitMoves )
		end

		-- Strength
		if unitStrength > 0 then
			local adjustedUnitStrength = (math.max(100 + unit:GetStrategicResourceCombatPenalty(), 10) * unitStrength) / 100
			--todo other modifiers eg unhappy...
			if adjustedUnitStrength < unitStrength then
			    adjustedUnitStrength = " [COLOR_NEGATIVE_TEXT]" .. adjustedUnitStrength .. "[ENDCOLOR]" 
				--adjustedUnitStrength = string.format(" [COLOR_NEGATIVE_TEXT]%.3g[ENDCOLOR]", adjustedUnitStrength )
			end
			unitTip = unitTip .. " " .. adjustedUnitStrength .. "[ICON_STRENGTH]"
		end

		-- Ranged Strength
		if rangedStrength > 0 then
			unitTip = unitTip .. " " .. rangedStrength .. "[ICON_RANGE_STRENGTH]"..unit:Range().." "
		end

		-- Religious Fervor
		if unit.GetReligion then
			local religionID = unit:GetReligion()
			if religionID > 0 then
				local spreadsLeft = unit:GetSpreadsLeft()
				unitTip = unitTip .. " "
				if spreadsLeft > 0 then
					unitTip = unitTip .. spreadsLeft
				end
				unitTip = unitTip .. ((GameInfo.Religions[ religionID ] or {}).IconString or "?") .. Locale.ConvertTextKey( Game.GetReligionName( religionID ) )
			end
		end

		---new 
		if  not unit:IsTrade() then
				hp = unit:GetCurrHitPoints() .. "/" .. hp
			end
			unitTip = unitTip .. "[NEWLINE]"..Locale.ConvertTextKey("TXT_KEY_PEDIA_MAXHP" )..hp .. "[ICON_HP]"	
	end

	-- Embarked?
	if unit:IsEmbarked() then
		unitTip = unitTip .. " " .. Locale.ConvertTextKey("TXT_KEY_PLOTROLL_EMBARKED" )
	end


	---more
		--can Establish Corps
		if unit:IsCanEstablishCorps() then
			toolTipString = toolTipString .. Locale.ConvertTextKey("TXT_KEY_SP_UNIT_CAN_ESTABLISH_CORPS_OR_ARMEE")
		end
	-- Level, Experience for ActivePlayer
		if  unit:IsCombatUnit() or unit:CanAirAttack()  then
			unitTip = unitTip .."[NEWLINE]".. Locale.ConvertTextKey( "TXT_KEY_UNIT_EXPERIENCE_INFO", unit:GetLevel(), unit:GetExperience(), unit:ExperienceNeeded() ):gsub("%[NEWLINE]"," ")
		end

       ----CombatType
		if unit:IsCombatUnit() then
	     local item =GameInfo.UnitCombatInfos[unit:GetUnitCombatType()]
	     unitTip = unitTip .."[NEWLINE]".. Locale.ConvertTextKey("TXT_KEY_FLAG_UNIT_TYPE") .."[COLOR_CYAN]" .. Locale.ConvertTextKey(item.Description).."[ENDCOLOR]".." ";         
       end
	   
	   -- Drop:
	    if unit:GetDropRange()>0 then
			unitTip = unitTip .."[NEWLINE]".. Locale.ConvertTextKey("TXT_KEY_FLAG_UNIT_DROP_RANGE") .. "[COLOR_CYAN]"..unit:GetDropRange().."[ENDCOLOR]".." "
		end 
	
	--Upgrade:
	    if unit:GetUpgradeUnitType()~=-1 then
	    local iUnitType = unit:GetUpgradeUnitType();
	    local item = GameInfo.Units[iUnitType].Description
	    unitTip = unitTip .."[NEWLINE]".. Locale.ConvertTextKey("TXT_KEY_FLAG_UNIT_UPGRADE") .."[COLOR_YELLOW]"..Locale.ConvertTextKey(item).."[ENDCOLOR]" .." "
	    end	

     local activePlayer = Players[activePlayerID]
	 local productionCost = GameInfo.Units[unit:GetUnitType()].Cost	
	 local city, item, resource
	 local item
     local activeCivilization = activePlayer and GameInfo.Civilizations[ activePlayer:GetCivilizationType() ]
     local activeCivilizationType = activeCivilization and activeCivilization.Type

	 -- unitTip = unitTip .."[NEWLINE]".."------------------------".."[NEWLINE]"

	 if activePlayer then
		productionCost = activePlayer:GetUnitProductionNeeded(unit:GetUnitType())
     end

	 -- Cost:
	local costTip
	if productionCost > 1 then -- Production cost
		if not GameInfo.Units[unit:GetUnitType()].PurchaseOnly then
			costTip = productionCost .. "[ICON_PRODUCTION]"
		end
		
	end -- production cost
		if costTip then
		unitTip = unitTip ..Locale.ConvertTextKey("TXT_KEY_PEDIA_COST_LABEL") .. " " .. ( costTip or Locale.ConvertTextKey("TXT_KEY_FREE") )
	end

	if GameInfo.Units[unit:GetUnitType()].ExtraMaintenanceCost > 0 then -- ExtraMaintenanceCost cost
	   ExtraMaintenanceCost=GameInfo.Units[unit:GetUnitType()].ExtraMaintenanceCost
		unitTip = unitTip .. " " ..Locale.ConvertTextKey("TXT_KEY_PEDIA_MAINT_LABEL") .. ExtraMaintenanceCost .."[ICON_GOLD]"
	end


	-- Resources required:
	
	local OtherResources = {};
		for resource in GameInfo.Resources() do
			item = Game.GetNumResourceRequiredForUnit(GameInfo.Units[unit:GetUnitType()].ID, resource.ID )
			if resource and item ~= 0 then
			table.insert( OtherResources, -item ..resource.IconString);
			end
		end
	
		local resourceText = {};
		for _, resource in pairs(OtherResources) do
			table.insert(resourceText,resource);
		end

		 if #resourceText > 0 then
		 unitTip = unitTip .."[NEWLINE]"..Locale.ConvertTextKey("TXT_KEY_PEDIA_RESOURCES_NEED") ..table.concat( resourceText, "  " )  .." "
	 end

	 -- Required Buildings:
	local buildings = {}
	for row in GameInfo.Unit_BuildingClassRequireds( { UnitType = GameInfo.Units[unit:GetUnitType()].Type }) do
		item = GetCivBuilding( activeCivilizationType, row.BuildingClassType )
		if item then
			table.insert( buildings, BuildingColor( Locale.ConvertTextKey(item.Description) ) )
		end
	end
	item = GameInfo.Units[unit:GetUnitType()].ProjectPrereq and GameInfo.Projects[GameInfo.Units[unit:GetUnitType()].ProjectPrereq ]
	if GameInfo.Units[unit:GetUnitType()].ProjectPrereq then
		table.insert( buildings, BuildingColor( Locale.ConvertTextKey(item.Description) ) )
	end
	if #buildings > 0 then
		unitTip = unitTip .."[NEWLINE]" ..Locale.ConvertTextKey("TXT_KEY_PEDIA_REQ_BLDG_LABEL") .. " " .. table.concat( buildings, ", ")  -- UNIT_REQUIRES_BUILDING
	end


	-- UnitClass B|B Inf for ActivePlayer
		local unitClassText="";
		if unitOwnerID == activePlayerID then
			local unitClassID = unit:GetUnitClassType();
			if unitOwner:GetUnitClassCount( unitClassID ) == 0 and unitOwner:GetUnitClassMaking( unitClassID ) == 0 then
			else
				if unitOwner:GetUnitClassCount( unitClassID ) > 0 then
					unitClassText = Locale.ConvertTextKey( "TXT_KEY_ACTION_CLASS_BUILT_COUNT", unitOwner:GetUnitClassCount( unitClassID ) );
					if unitOwner:GetUnitClassMaking( unitClassID ) > 0 then
						unitClassText = unitClassText .. " <> "  .. Locale.ConvertTextKey( "TXT_KEY_ACTION_CLASS_BUILDING_COUNT", unitOwner:GetUnitClassMaking( unitClassID ) );
					end
				else
					unitClassText = Locale.ConvertTextKey( "TXT_KEY_ACTION_CLASS_BUILDING_COUNT", unitOwner:GetUnitClassMaking( unitClassID ) );
				end
			end
		end

		unitTip = unitTip .."[NEWLINE]"..unitClassText

	return unitTip
end


function UnitPlaneTip( unit )
		local toolTip = ShortUnitTip( unit )
	    toolTip = toolTip .."[NEWLINE]".."------------------------".."[NEWLINE]"..Locale.ConvertTextKey("TXT_KEY_CURRENTLY_SELECTED_UNIT")
	return toolTip
end