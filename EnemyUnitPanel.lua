function GetHelpTextForUnit( unitID, bIncludeRequirements, city )
	local unit = GameInfo.Units[ unitID ]
	if not unit then
		return "<Unit undefined in game database>"
	end

	-- Unit XML stats
	local unitClass = GameInfo.UnitClasses[ unit.Class ]
	local unitClassID = unitClass and unitClass.ID
	local maxGlobalInstances = unitClass and tonumber(unitClass.MaxGlobalInstances) or -1
	local maxTeamInstances = unitClass and tonumber(unitClass.MaxTeamInstances) or -1
	local maxPlayerInstances = unitClass and tonumber(unitClass.MaxPlayerInstances) or -1
	local productionCost = unit.Cost
	local rangedStrength = unit.RangedCombat
	local unitRange = unit.Range
	local combatStrength = unit.Combat
	local workrate = unit.WorkRate
	local unitMoves = unit.Moves
	local unitSight = unit.BaseSightRange
	local unitDomainType = unit.Domain

	local HitModifier = 0
	local HitChange = 0

	local thisUnitType = { UnitType = unit.Type }
	local thisUnitClass = { UnitClassType = unit.Class }
	local freePromotions = {}
	local item, resource

	------------------------------------------------
	-- 免费晋升 (同时累加战斗/移动/视野修正)
	------------------------------------------------
	for row in GameInfo.Unit_FreePromotions( thisUnitType ) do
		item = GameInfo.UnitPromotions[ row.PromotionType ]
		if item then
			HitModifier = HitModifier + (item.MaxHitPointsModifier or 0)
			HitChange = HitChange + (item.MaxHitPointsChange or 0)
			unitRange = unitRange + (item.RangeChange or 0)
			unitMoves = unitMoves + (item.MovesChange or 0)
			unitSight = unitSight + (item.VisibilityChange or 0)
			if item.ShowInUnitPanel ~= 0 and item.ShowInTooltip ~= 0 then
				insert( freePromotions, L(item.Description) )
			end
		end
	end

	local unitName = unit.Description

	if activePlayer then
		productionCost = activePlayer:GetUnitProductionNeeded( unitID )
		city = city or GetHeadSelectedCity()
		if city and city:GetOwner() ~= activePlayerID then
			city = nil
		end
		city = city or activePlayer:GetCapitalCity() or activePlayer:Cities()(activePlayer)
	end

	-- Name
	item = unit.CombatClass and GameInfo.UnitCombatInfos[ unit.CombatClass ]
	local tip = format( "%s %s", ( unit.Special and unit.Special == "SPECIALUNIT_PEOPLE" and GreatPeopleIcon( unit.Type ) or "" ), UnitColor( Locale_ToUpper( unitName ) ) )
	if item then
		tip = tip .. " (" .. L(item.Description or "???") .. ")"
	end

	local tips = { tip }
	insert( tips, "----------------" )

	if unitDomainType ~= "DOMAIN_AIR" then
		insert( tips, L"TXT_KEY_PEDIA_MOVEMENT_LABEL" .. " " .. unitMoves .. "[ICON_MOVES]" )
	end

	if combatStrength > 0 then
		insert( tips, format( "%s %g[ICON_STRENGTH]", L"TXT_KEY_PEDIA_COMBAT_LABEL", combatStrength ) )
	end

	-- maxhp: 最大血量
	if unit.MaxHitPoints ~= nil then
		local maxhp
		if HitModifier == 0 then
			maxhp = unit.MaxHitPoints + HitChange
		else
			maxhp = ((unit.MaxHitPoints) * HitModifier / 100) + HitChange
		end
		insert( tips, L"TXT_KEY_PEDIA_MAXHP_LABEL" .. maxhp .. "[ICON_SILVER_FIST]" )
	end

	if rangedStrength > 0 then
		insert( tips, L"TXT_KEY_PEDIA_RANGEDCOMBAT_LABEL" .. " " .. rangedStrength .. "[ICON_RANGE_STRENGTH]" .. unitRange )
	end

	if workrate ~= 0 then
		insert( tips, L"TXT_KEY_PEDIA_WORKRATE_LABEL" .. workrate )
	end

	if unitSight > 0 then
		insert( tips, L"TXT_KEY_PEDIA_SIGHT_LABEL" .. " " .. unitSight .. "[ICON_PROMOTION_SIGHT_1]" )
	end

	-- Abilities (免费晋升列表)
	--if #freePromotions > 0 then
		--insert( tips, L"TXT_KEY_FREEPROMOTIONS" .. "" .. "[NEWLINE][ICON_BULLET]" .. concat( freePromotions, "[NEWLINE][ICON_BULLET]" ) .. "[NEWLINE]----------------" )
	--end



	-- Ability to create building in city (e.g. vanilla great general)
	for row in GameInfo.Unit_Buildings( thisUnitType ) do
		item = GameInfo.Buildings[ row.BuildingType ]
		if item then
			insert( tips, "[ICON_BULLET]" .. L"TXT_KEY_MISSION_CONSTRUCT" .. " " .. BuildingColor( L(item.Description) ) )
		end
	end

	-- Actions
	for row in GameInfo.Unit_Builds( thisUnitType ) do
		local build = GameInfo.Builds[ row.BuildType ]
		if build then
			item = build.ImprovementType and GameInfo.Improvements[ build.ImprovementType ]
			if not item or not item.SpecificCivRequired or not activePlayer or GameInfoTypes[ GameInfo.Civilizations[ item.CivilizationType ] ] == activePlayer:GetCivilizationType() then
				item = build.PrereqTech and GameInfo.Technologies[ build.PrereqTech ]
				insert( tips, "[ICON_BULLET]" .. (item and TechColor( L(item.Description) ) .. " " or "") .. BuildColor( L(build.Description) ) )
			end
		end
	end

	-- Great Engineer
	if (unit.BaseHurry or 0) > 0 then
		insert( tips, format( "[ICON_BULLET]%s %i[ICON_PRODUCTION]%+i[ICON_PRODUCTION]/[ICON_CITIZEN]", L"TXT_KEY_MISSION_HURRY_PRODUCTION", unit.BaseHurry, unit.HurryMultiplier or 0 ) )
	end

	-- Great Merchant
	if (unit.BaseGold or 0) > 0 then
		insert( tips, format( "[ICON_BULLET]%s %i%s%+i[ICON_INFLUENCE]", L"TXT_KEY_MISSION_CONDUCT_TRADE_MISSION", unit.BaseGold + ( unit.NumGoldPerEra or 0 ) * ( Game and Teams[Game.GetActiveTeam()]:GetCurrentEra() or PreGame.GetEra() ), g_currencyIcon, GameDefines.MINOR_FRIENDSHIP_FROM_TRADE_MISSION or 0 ) )
	end

	-- Other tags
	local unitFlag = {
		MoveAfterPurchase = L"TXT_KEY_MOVE_AFTER_PC",
		Immobile = L"TXT_KEY_DOMAIN_IMMOBILE",
		RivalTerritory = "[ICON_PROMOTION_GOLDEN_AGE_POINTS]" .. L"TXT_KEY_PROMOTION_RIVAL_TERRITORY",
		Found = "[ICON_PROMOTION_SIEGE_3]" .. L"TXT_KEY_MISSION_BUILD_CITY",
		FoundAbroad = "[ICON_PROMOTION_SIEGE_2]" .. L"TXT_KEY_MISSION_BUILD_CITY" .. " <> " .. L"TXT_KEY_PGSCREEN_CONTINENTS",
		Suicide = "[ICON_PROMOTION_AMBUSH_1]" .. L"TXT_KEY_SUICIDE",
		RushBuilding = L"TXT_KEY_MISSION_HURRY_PRODUCTION",
		SpreadReligion = "[ICON_MISSIONARY]" .. L"TXT_KEY_MISSION_SPREAD_RELIGION",
		RemoveHeresy = L"TXT_KEY_MISSION_REMOVE_HERESY",
		FoundReligion = "[ICON_PROPHET]" .. L"TXT_KEY_MISSION_FOUND_RELIGION",
		RequiresEnhancedReligion = L"TXT_KEY_REQUIRES_E",
		ProhibitsSpread = "[ICON_INQUISITOR]" .. L"TXT_KEY_PROHIBITS_SPREAD",
		CanBuyCityState = "[ICON_PROMOTION_TRADE_MISSION_BONUS]" .. L"TXT_KEY_MISSION_BUY_CITY_STATE",
		RangeAttackIgnoreLOS = "[ICON_PROMOTION_INDIRECT_FIRE]" .. L"TXT_KEY_PROMOTION_INDIRECT_FIRE",
		Trade = "[ICON_TRADE]" .. L"TXT_KEY_MISSION_ESTABLISH_TRADE_ROUTE",
		NoMaintenance = L"TXT_KEY_PEDIA_MAINT_LABEL" .. " 0",
	}
	local unitData = {
		CultureBombRadius = L"TXT_KEY_MISSION_CULTURE_BOMB" .. " ([ICON_RANGE_STRENGTH]%i)",
		GoldenAgeTurns = L"TXT_KEY_MISSION_START_GOLDENAGE" .. " (%i " .. L"TXT_KEY_TURNS" .. ")",
		FreePolicies = L"TXT_KEY_MISSION_GIVE_POLICIES" .. " (%ix[ICON_CULTURE])",
		OneShotTourism = L"TXT_KEY_MISSION_ONE_SHOT_TOURISM" .. " (%ix[ICON_TOURISM])",
		AirInterceptRange = L"TXT_KEY_MISSION_INTERCEPT" .. " [ICON_RANGE_STRENGTH]%i",
		NumFreeTechs = L"TXT_KEY_MISSION_DISCOVER_TECH" .. " (%i)",
		BaseBeakersTurnsToCount = L"TXT_KEY_MISSION_DISCOVER_TECH" .. " (%i " .. L"TXT_KEY_TURNS" .. ")",
		BaseCultureTurnsToCount = L"TXT_KEY_MISSION_GIVE_POLICIES" .. " (%i " .. L"TXT_KEY_TURNS" .. ")",
		ReligionSpreads = L"TXT_KEY_UPANEL_SPREAD_RELIGION_USES" .. ": %i",
		ReligiousStrength = L"TXT_KEY_REL_STR" .. " %i",
		NumExoticGoods = L"TXT_KEY_MISSION_SELL_EXOTIC_GOODS" .. ": %i",
		ExtraMaintenanceCost = L"TXT_KEY_PEDIA_MAINT_LABEL" .. " -%i" .. g_currencyIcon,
	}

	for k, v in pairs( unit ) do
		if v and v ~= 0 and v ~= -1 then
			tip = unitFlag[k]
			if tip then
				insert( tips, "[ICON_BULLET]" .. tip )
			else
				tip = unitData[k]
				v = tonumber(v) or 0
				if tip and v > 0 then
					if #tip == 0 then
						tip = k .. " %i"
					end
					insert( tips, "[ICON_BULLET]" .. format( tip, v ) )
				end
			end
		end
	end

	-- Technology_DomainExtraMoves
	for row in GameInfo.Technology_DomainExtraMoves{ DomainType = unitDomainType } do
		item = GameInfo.Technologies[ row.TechType ]
		if item and (row.Moves or 0) ~= 0 then
			insert( tips, format( "[ICON_BULLET]%s %+i[ICON_MOVES]", TechColor( L(item.Description) ), row.Moves ) )
		end
	end

	-- Ability to generate tourism upon spawn
	if IsCiv5BNW then
		for row in GameInfo.Policy_TourismOnUnitCreation( thisUnitClass ) do
			item = GameInfo.Policies[ row.PolicyType ]
			if item and (row.Tourism or 0) ~= 0 and item.Dummy ~= 1 then
				insert( tips, format( "[ICON_BULLET]%s %+i[ICON_TOURISM]", PolicyColor( L(item.Description) ), row.Tourism ) )
			end
		end
	end

	-- Resources required
	if Game then
		for resource in GameInfo.Resources() do
			item = Game.GetNumResourceRequiredForUnit( unitID, resource.ID )
			if item ~= 0 then
				insert( tips, ResourceQuantity( resource, -item ) )
			end
		end
	else
		for row in GameInfo.Unit_ResourceQuantityRequirements( thisUnitType ) do
			resource = GameInfo.Resources[ row.ResourceType ]
			if resource and (row.Cost or 0) ~= 0 then
				insert( tips, ResourceQuantity( resource, -row.Cost ) )
			end
		end
	end

	insert( tips, "----------------" )

	-- Cost
	local costTip
	if productionCost > 1 then
		if not unit.PurchaseOnly then
			costTip = productionCost .. "[ICON_PRODUCTION]"
		end
		local goldCost = 0
		if city then
			goldCost = city:GetUnitPurchaseCost( unitID )
		elseif (unit.HurryCostModifier or 0) > 0 then
			goldCost = (productionCost * GameDefines.GOLD_PURCHASE_GOLD_PER_PRODUCTION) ^ GameDefines.HURRY_GOLD_PRODUCTION_EXPONENT
			goldCost = (unit.HurryCostModifier + 100) * goldCost / 100
			goldCost = goldCost - (goldCost % GameDefines.GOLD_PURCHASE_VISIBLE_DIVISOR)
		end
		if goldCost > 0 then
			if costTip then
				costTip = costTip .. ("(%i%%)"):format(productionCost * 100 / goldCost)
				if IsCiv5Vanilla then
					costTip = costTip .. " / " .. goldCost .. g_currencyIcon
				else
					costTip = L("TXT_KEY_PEDIA_A_OR_B", costTip, goldCost .. g_currencyIcon)
				end
			else
				costTip = goldCost .. g_currencyIcon
			end
		end
	end
	if g_isReligionEnabled then
		local faithCost = 0
		if city then
			faithCost = city:GetUnitFaithPurchaseCost( unitID, true )
		elseif Game then
			faithCost = Game.GetFaithCost( unitID )
		elseif unit.RequiresFaithPurchaseEnabled and unit.FaithCost then
			faithCost = unit.FaithCost
		end
		if (faithCost or 0) > 0 then
			if costTip then
				costTip = L("TXT_KEY_PEDIA_A_OR_B", costTip, faithCost .. "[ICON_PEACE]" )
			else
				costTip = faithCost .. "[ICON_PEACE]"
			end
		end
	end
	if costTip then
		insert( tips, L"TXT_KEY_PEDIA_COST_LABEL" .. " " .. (costTip or L"TXT_KEY_FREE") )
	end

	-- build using food / stop city growth
	if unit.Food then
		insert( tips, L"TXT_KEY_CITYVIEW_STAGNATION_TEXT" .. " (" .. L"TXT_KEY_POPULATION_SUPPLY" .. ")" )
	end

	-- Settler Specifics
	if unit.Found or unit.FoundAbroad then
		append( tips, L("TXT_KEY_NO_ACTION_SETTLER_SIZE_LIMIT", GameDefines.CITY_MIN_SIZE_FOR_SETTLERS) )
	end

	-- Civilization
	local civs = {}
	for requiredCivilizationType in GameInfo.Civilization_UnitClassOverrides( thisUnitType ) do
		item = GameInfo.Civilizations[ requiredCivilizationType.CivilizationType ]
		if item then
			insert( civs, L(item.ShortDescription) )
		end
	end
	if #civs > 0 then
		insert( tips, L"TXT_KEY_PEDIA_CIVILIZATIONS_LABEL" .. " " .. concat( civs, ", ") )
	end

	-- Replaces
	item = unitClass and GameInfo.Units[ unitClass.DefaultUnit ]
	if item and item ~= unit then
		insert( tips, L"TXT_KEY_PEDIA_REPLACES_LABEL" .. " " .. format( "%s %s", ( item.Special and item.Special == "SPECIALUNIT_PEOPLE" and GreatPeopleIcon( item.Type ) or "" ), UnitColor( L(item.Description) ) ) )
	end

	-- Required Policies
	item = unit.PolicyType and GameInfo.Policies[ unit.PolicyType ]
	if unit.PolicyType and (not item.Dummy or item.Dummy ~= 1) then
		insert( tips, L"TXT_KEY_PEDIA_PREREQ_POLICY_LABEL" .. " " .. PolicyColor( L(item.Description) ) )
	end

	-- Required Social Policy
	item = unit.PolicyBranchType and GameInfo.PolicyBranchTypes[ unit.PolicyBranchType ]
	if item then
		insert( tips, L"TXT_KEY_PEDIA_PREREQ_POLICY_LABEL" .. " " .. PolicyColor( L(item.Description) ) )
	end

	-- Required Buildings
	local buildings = {}
	for row in GameInfo.Unit_BuildingClassRequireds( thisUnitType ) do
		item = GetCivBuilding( activeCivilizationType, row.BuildingClassType )
		if item then
			insert( buildings, BuildingColor( L(item.Description) ) )
		end
	end
	item = unit.ProjectPrereq and GameInfo.Projects[ unit.ProjectPrereq ]
	if unit.ProjectPrereq then
		insert( buildings, BuildingColor( L(item.Description) ) )
	end
	if #buildings > 0 then
		insert( tips, L"TXT_KEY_PEDIA_REQ_BLDG_LABEL" .. " " .. concat( buildings, ", ") )
	end

	-- Prerequisite Techs
	item = unit.PrereqTech and GameInfo.Technologies[ unit.PrereqTech ]
	if item and item.ID > 0 then
		insert( tips, L"TXT_KEY_PEDIA_PREREQ_TECH_LABEL" .. " " .. TechColor( L(item.Description) ) )
	end

	-- Upgrade from
	local unitClassUpgrades = {}
	for unitUpgrade in GameInfo.Unit_ClassUpgrades( thisUnitClass ) do
		unitUpgrade = GameInfo.Units[ unitUpgrade.UnitType ]
		SetKey( unitClassUpgrades, unitUpgrade and unitUpgrade.Class )
	end
	local unitUpgrades = {}
	for unitToUpgrade in pairs( unitClassUpgrades ) do
		item = GetCivUnit( activeCivilizationType, unitToUpgrade )
		if item then
			insert( unitUpgrades, format( "%s %s", ( item.Special and item.Special == "SPECIALUNIT_PEOPLE" and GreatPeopleIcon( item.Type ) or "" ), UnitColor( L(item.Description) ) ) .. " (" .. unitUpgradePrice( item, unit, activePlayer and activePlayer:GetUnitProductionNeeded( item.ID ), productionCost ) .. g_currencyIcon .. ")" )
		end
	end
	if #unitUpgrades > 0 then
		insert( tips, L"TXT_KEY_GOLD_UPGRADE_UNITS_HEADING3_TITLE" .. ": " .. concat( unitUpgrades, ", ") )
	end

	-- Becomes Obsolete with
	item = unit.ObsoleteTech and GameInfo.Technologies[ unit.ObsoleteTech ]
	if item then
		insert( tips, L"TXT_KEY_PEDIA_OBSOLETE_TECH_LABEL" .. " " .. TechColor( L(item.Description) ) )
	end

	-- Upgrade unit
	if Game then
		local item = Game.GetUnitUpgradesTo( unit.ID )
		item = item and GameInfo.Units[ Game.GetUnitUpgradesTo( unit.ID ) ]
		if item and activeCivilizationType then
			item = GetCivUnit( activeCivilizationType, item.Class )
			insert( tips, L"TXT_KEY_COMMAND_UPGRADE" .. ": " .. format( "%s %s", ( item.Special and item.Special == "SPECIALUNIT_PEOPLE" and GreatPeopleIcon( item.Type ) or "" ), UnitColor( L(item.Description) ) ) .. " (" .. unitUpgradePrice( unit, item, productionCost, activePlayer:GetUnitProductionNeeded( item.ID ) ) .. g_currencyIcon .. ")" )
		end
	else
		local unitClassUpgrades = {}
		for unitClassUpgrade in GameInfo.Unit_ClassUpgrades( thisUnitType ) do
			SetKey( unitClassUpgrades, unitClassUpgrade.UnitClassType )
		end
		local unitUpgrades = {}
		for unitUpgrade in pairs( unitClassUpgrades ) do
			item = GetCivUnit( activeCivilizationType, unitUpgrade )
			if item then
				insert( unitUpgrades, UnitColor( L(item.Description) ) .. " (" .. unitUpgradePrice( unit, item, productionCost ) .. g_currencyIcon .. ")" )
			end
		end
		if #unitUpgrades > 0 then
			insert( tips, L"TXT_KEY_COMMAND_UPGRADE" .. ": " .. concat( unitUpgrades, ", ") )
		end
	end

	-- Built <> Building Class Count
	local countText = {}
	if activePlayer then
		if activePlayer:GetUnitClassCount( unitClassID ) > 0 then
			insert( countText, "[NEWLINE]" .. L( "TXT_KEY_ACTION_CLASS_BUILT_COUNT", activePlayer:GetUnitClassCount( unitClassID ) ) )
			if activePlayer:GetUnitClassMaking( unitClassID ) > 0 then
				append( countText, " <> " .. L( "TXT_KEY_ACTION_CLASS_BUILDING_COUNT", activePlayer:GetUnitClassMaking( unitClassID ) ) )
			end
		elseif activePlayer:GetUnitClassMaking( unitClassID ) > 0 then
			insert( countText, "[NEWLINE]" .. L( "TXT_KEY_ACTION_CLASS_BUILDING_COUNT", activePlayer:GetUnitClassMaking( unitClassID ) ) )
		end
	end
	if #countText > 0 then
		insert( tips, concat( countText, "" ) )
	end

	-- Limited number can be built
	if #countText == 0 and (maxGlobalInstances > 0 or maxTeamInstances > 0 or maxPlayerInstances > 0) then
		append( tips, "[NEWLINE]" )
	end
	if maxGlobalInstances > 0 then
		append( tips, "[COLOR_YELLOW]" .. L( "TXT_KEY_NO_ACTION_GAME_COUNT_MAX", maxGlobalInstances ) .. "[ENDCOLOR]" )
	end
	if maxTeamInstances > 0 then
		append( tips, "[COLOR_YELLOW]" .. L( "TXT_KEY_NO_ACTION_TEAM_COUNT_MAX", maxTeamInstances ) .. "[ENDCOLOR]" )
	end
	if maxPlayerInstances > 0 then
		append( tips, "[COLOR_YELLOW]" .. L( "TXT_KEY_NO_ACTION_PLAYER_COUNT_MAX", maxPlayerInstances ) .. "[ENDCOLOR]" )
	end

	-- === 合并点：可选追加 CanTrain 检查 (仅当调用方显式传入 city 时) ===
	if bIncludeRequirements and city and not city:CanTrain( unitID ) then
		append( tips, "[COLOR_WARNING_TEXT]" .. city:CanTrainTooltip( unitID ) .. "[ENDCOLOR]" )
	end


		if #freePromotions > 0 then
		insert( tips, "<<PROMOTION_SPLIT>>" )
	end


-- 清理多余换行，并返回
	local finalTip = AddPreWrittenHelpTextAndConcat( tips, unit )
	finalTip = finalTip:gsub( "%[NEWLINE%]+%[NEWLINE%]+", "[NEWLINE]" )
	finalTip = finalTip:gsub( "^%[NEWLINE%]+", "" )
	finalTip = finalTip:gsub( "%[NEWLINE%]+$", "" )
	return finalTip
	

	-- Pre-written Help text
	--return AddPreWrittenHelpTextAndConcat( tips, unit )
end