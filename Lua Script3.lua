


local g_UnitTooltipControls = {}
TTManager:GetTypeControlTable( "EUI_UnitTooltip", g_UnitTooltipControls )

local g_PromotionIconIM = StackInstanceManager( "PromotionIcon", "Image", g_UnitTooltipControls.IconStack )



Controls.UnitTooltipTimer:SetToBeginning()
Controls.UnitTooltipTimer:SetPauseTime( GetTooltip2Seconds() / 100 )

local function UnitToolTip( unit )
	if unit then
		local controls = g_UnitTooltipControls
		local toolTipString = ShortUnitTip( unit )
		local playerID = unit:GetOwner()
		if playerID == GetActivePlayer() then
			toolTipString = toolTipString .. "[NEWLINE]".. L("TXT_KEY_UNIT_EXPERIENCE_INFO", unit:GetLevel(), unit:GetExperience(), unit:ExperienceNeeded() ) .. L"TXT_KEY_UPANEL_CLICK_TO_SELECT"
		end
		controls.Text:SetText( toolTipString )

		local iconIndex, iconAtlas = GetUnitPortraitIcon( unit )
		IconHookup( iconIndex, 256, iconAtlas, controls.UnitPortrait )
		CivIconHookup( playerID, 64, controls.CivIcon, controls.CivIconBG, controls.CivIconShadow, false, true )
		local i = 0
		local promotionText = {}
		local promotionIcon
		g_PromotionIconIM:ResetInstances()
		if not( unit.IsTrade and unit:IsTrade() ) then
			for unitPromotion in GameInfo.UnitPromotions() do
				if unit:IsHasPromotion(unitPromotion.ID) and unitPromotion.ShowInUnitPanel ~= 0 then
					promotionIcon = g_PromotionIconIM:GetInstance()
					IconHookup( unitPromotion.PortraitIndex, 32, unitPromotion.IconAtlas, promotionIcon.Image )
					insert( promotionText, unitPromotion._Name )
				end
			end
		end
		controls.PortraitFrame:SetAnchor( GetMousePos() > 300 and "L,T" or "R,T" )
		controls.PromotionText:SetText( concat( promotionText, "[NEWLINE]" ) )
		controls.PromotionText:SetHide( #promotionText ~= 1 )
		controls.IconStack:SetWrapWidth( ceil( i / ceil( i / 10 ) ) * 26 )
		controls.IconStack:CalculateSize()
		controls.Box:DoAutoSize()
		Controls.UnitTooltipTimer:SetToBeginning()
		Controls.UnitTooltipTimer:Reverse()
	end
end
LuaEvents.UnitToolTip.Add( UnitToolTip )




--==========================================================
-- Tech Tooltips
--==========================================================

function GetHelpTextForUnit2( unitID ) -- isIncludeRequirementsInfo )
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
	local thisUnitClass =  { UnitClassType = unit.Class }

	---local freePromotions = {}

	local city, item, resource



	------------------------------------------------新增晋升显示------------------------------------------------
   -- for row in GameInfo.Unit_FreePromotions( thisUnitType ) do
		--item = GameInfo.UnitPromotions[ row.PromotionType ]
		--if item then
		--HitModifier= HitModifier + item.MaxHitPointsModifier
		--HitChange= HitChange + item.MaxHitPointsChange
		--unitRange = unitRange + (item.RangeChange or 0)
		--unitMoves = unitMoves + (item.MovesChange or 0)
		--unitSight = unitSight + (item.VisibilityChange or 0)
		--if  item.ShowInUnitPanel ~= 0 and item.ShowInTooltip ~= 0 then
			--insert( freePromotions, item.IconString2.. L(item.Description) )
			--end
		--end
	--end

	local unitName = unit.Description

	if activePlayer then
		productionCost = activePlayer:GetUnitProductionNeeded( unitID )
		city = GetHeadSelectedCity()
		if city and city:GetOwner() ~= activePlayerID then
			city = nil
		end
		city = city or activePlayer:GetCapitalCity() or activePlayer:Cities()(activePlayer)
	end

	-- Name
	item = unit.CombatClass and GameInfo.UnitCombatInfos[ unit.CombatClass ]
	local tip =  format( "%s %s", ( unit.Special and unit.Special == "SPECIALUNIT_PEOPLE" and GreatPeopleIcon( unit.Type ) or "" ), UnitColor( Locale_ToUpper( unitName ) ) )
	if item then
		tip = tip .. " (" .. L(item.Description or "???") .. ")"
	end

	local tips = { tip }
	
	insert( tips, "----------------" )

	if unitDomainType ~= "DOMAIN_AIR" then
		-- Movement:
		insert( tips, L"TXT_KEY_PEDIA_MOVEMENT_LABEL" .. " " .. unitMoves .. "[ICON_MOVES]" )
	end

		-- Combat:
	if combatStrength > 0 then
		insert( tips, format( "%s %g[ICON_STRENGTH]", L"TXT_KEY_PEDIA_COMBAT_LABEL", combatStrength ) )
	end

	-- maxhp:
	if unit.MaxHitPoints~=nil then--最大血量

	if HitModifier==0 then
	maxhp = unit.MaxHitPoints + HitChange
	insert( tips, L"TXT_KEY_PEDIA_MAXHP_LABEL".. maxhp .. "[ICON_SILVER_FIST]")
	else
	maxhp = ((unit.MaxHitPoints)*HitModifier/100)+ HitChange
		insert( tips, L"TXT_KEY_PEDIA_MAXHP_LABEL".. maxhp .. "[ICON_SILVER_FIST]")
		
		end
	end



	-- Ranged Combat:
	if rangedStrength > 0 then
		insert( tips, L"TXT_KEY_PEDIA_RANGEDCOMBAT_LABEL" .. " " .. rangedStrength .. "[ICON_RANGE_STRENGTH]" .. unitRange )
	end

	-- workrate:
	if workrate ~=nil then
		insert( tips, L"TXT_KEY_PEDIA_WORKRATE_LABEL" ..workrate  )
	end

	-----新增Sight:视野--------------------------------------------------- 
	if unitSight > 0 then
		insert( tips, L"TXT_KEY_PEDIA_SIGHT_LABEL" .. " " .. unitSight .. "[ICON_PROMOTION_SIGHT_1]" )
	end

	-- 新增Abilities:	--TXT_KEY_PEDIA_FREEPROMOTIONS_LABEL
	if #freePromotions > 0 then
		insert( tips, L"TXT_KEY_FREEPROMOTIONS".."".."[NEWLINE]" .. concat( freePromotions,"[NEWLINE]" ).."[NEWLINE]----------------" )
	end

	-- Ability to create building in city (e.g. vanilla great general)
	for row in GameInfo.Unit_Buildings( thisUnitType ) do
		item = GameInfo.Buildings[ row.BuildingType ]
		if item then
			insert( tips, "[ICON_BULLET]"..L"TXT_KEY_MISSION_CONSTRUCT".." " .. BuildingColor( L(item.Description) ) )
		end
	end

	-- Actions	--TXT_KEY_PEDIA_WORKER_ACTION_LABEL
	for row in GameInfo.Unit_Builds( thisUnitType ) do
		local build = GameInfo.Builds[ row.BuildType ]
		if build then
			item = build.ImprovementType and GameInfo.Improvements[ build.ImprovementType ]
			if not item or not item.SpecificCivRequired or not activePlayer or GameInfoTypes[ GameInfo.Civilizations[ item.CivilizationType ] ] == activePlayer:GetCivilizationType() then -- GameInfoTypes not available pregame: works because activePlayer is also nil
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
	--y	RequiresFaithPurchaseEnabled = L"TXT_KEY_NOTIFICATION_SUMMARY_ENOUGH_FAITH_FOR_MISSIONARY",
	--y	PurchaseOnly = L("TXT_KEY_RO_AUTO_FAITH_PURCHASE_GREAT_PERSON", L"TXT_KEY_POPUP_GREAT_PERSON_UNIT"),
		MoveAfterPurchase = L"TXT_KEY_MOVE_AFTER_PC",			-- TODO, LANDSKNECHT
		Immobile = L"TXT_KEY_DOMAIN_IMMOBILE",				-- bombs, missiles, aircraft etc...
	--y	Food = L"TXT_KEY_CITYVIEW_STAGNATION_TEXT" .. " (" .. L"TXT_KEY_POPULATION_SUPPLY" .. ")",	-- build using food / stop city growth
	--n	NoBadGoodies = "",						-- scout, does it have any in-game effect ?
		RivalTerritory = "[ICON_PROMOTION_GOLDEN_AGE_POINTS]" .. L"TXT_KEY_PROMOTION_RIVAL_TERRITORY",		-- unused
	--n	MilitarySupport = "",
	--n	MilitaryProduction = "",
	--	Pillage = L"TXT_KEY_MISSION_PILLAGE",				-- not very informative
		Found = "[ICON_PROMOTION_SIEGE_3]" .. L"TXT_KEY_MISSION_BUILD_CITY",
		FoundAbroad = "[ICON_PROMOTION_SIEGE_2]" .. L"TXT_KEY_MISSION_BUILD_CITY" .. " <> " .. L"TXT_KEY_PGSCREEN_CONTINENTS",
	--u	IgnoreBuildingDefense = "",					-- TODO, important
	--n	PrereqResources = "",						-- workboat only, not informative
	--n	Mechanized = "",						-- art only ?
		Suicide = "[ICON_PROMOTION_AMBUSH_1]" .. L"TXT_KEY_SUICIDE",	-- TODO, although obvious for base game may be less so in mods
	--u	CaptureWhileEmbarked = "",					-- unused
		RushBuilding = L"TXT_KEY_MISSION_HURRY_PRODUCTION",
		SpreadReligion = "[ICON_MISSIONARY]" .. L"TXT_KEY_MISSION_SPREAD_RELIGION",
		RemoveHeresy = L"TXT_KEY_MISSION_REMOVE_HERESY",
		FoundReligion = "[ICON_PROPHET]" .. L"TXT_KEY_MISSION_FOUND_RELIGION",
		RequiresEnhancedReligion = L"TXT_KEY_REQUIRES_E",			-- TODO (inquisitors)
		ProhibitsSpread = "[ICON_INQUISITOR]" .. L"TXT_KEY_PROHIBITS_SPREAD",	-- TODO (inquisitors)
		CanBuyCityState = "[ICON_PROMOTION_TRADE_MISSION_BONUS]" .. L"TXT_KEY_MISSION_BUY_CITY_STATE",
	--n	RangeAttackOnlyInDomain = "",					-- used only for subs
		RangeAttackIgnoreLOS = "[ICON_PROMOTION_INDIRECT_FIRE]" .. L"TXT_KEY_PROMOTION_INDIRECT_FIRE",
		Trade = "[ICON_TRADE]" .. L"TXT_KEY_MISSION_ESTABLISH_TRADE_ROUTE",
		NoMaintenance = L"TXT_KEY_PEDIA_MAINT_LABEL" .. " 0",
	--n	UnitArtInfoCulturalVariation = "",
	--n	UnitArtInfoEraVariation = "",
	--n	DontShowYields = "",
	--n	ShowInPedia = "",
	}
	local unitData = {
	--y	Combat = L"TXT_KEY_PEDIA_COMBAT_LABEL".." %i",
	--y	RangedCombat = L"TXT_KEY_PEDIA_RANGEDCOMBAT_LABEL".." %i[ICON_RANGE_STRENGTH]",
	--y	Cost = "",
	--y	FaithCost = "",
	--y	Moves = L"TXT_KEY_PEDIA_MOVEMENT_LABEL".." %i[ICON_MOVES]",
	--y	Range = L"TXT_KEY_PEDIA_RANGE_LABEL" .. " [ICON_RANGE_STRENGTH]%i",
	--y	BaseSightRange = L"TXT_KEY_COMBAT_LINEOFSIGHT_HEADING3_TITLE" .. " [ICON_RANGE_STRENGTH]%i",
		CultureBombRadius = L"TXT_KEY_MISSION_CULTURE_BOMB" .. " ([ICON_RANGE_STRENGTH]%i)",	-- unused
		GoldenAgeTurns = L"TXT_KEY_MISSION_START_GOLDENAGE" .. " (%i " .. L"TXT_KEY_TURNS"..")",	-- Artist
		FreePolicies = L"TXT_KEY_MISSION_GIVE_POLICIES" .. " (%ix[ICON_CULTURE])",	-- unused
		OneShotTourism = L"TXT_KEY_MISSION_ONE_SHOT_TOURISM" .. " (%ix[ICON_TOURISM])",	-- Musician
	--n	OneShotTourismPercentOthers = "",				-- Musician
	--y	HurryCostModifier = "",
	--n	AdvancedStartCost = "",
	--n	MinAreaSize = "",
		AirInterceptRange = L"TXT_KEY_MISSION_INTERCEPT" .. " [ICON_RANGE_STRENGTH]%i",
	--n	AirUnitCap = "",
	--n	NukeDamageLevel = "",
	--n	WorkRate = "", --L"TXT_KEY_WORKERACTION_TEXT" L"TXT_KEY_MISSION_BUILD_IMPROVEMENT" L"TXT_KEY_MISSION_CONSTRUCT"
		NumFreeTechs = L"TXT_KEY_MISSION_DISCOVER_TECH" .. " (%i)",
		BaseBeakersTurnsToCount = L"TXT_KEY_MISSION_DISCOVER_TECH" .. " (%i " .. L"TXT_KEY_TURNS"..")", -- Scientist
		BaseCultureTurnsToCount = L"TXT_KEY_MISSION_GIVE_POLICIES" .. " (%i " .. L"TXT_KEY_TURNS"..")",	-- Writer
	--y	BaseHurry = "",
	--y	HurryMultiplier = "",
	--y	BaseGold = L"TXT_KEY_MISSION_CONDUCT_TRADE_MISSION" .. " %i[ICON_INFLUENCE] %i" .. g_currencyIcon, -- base gold provided by great merchand
	--y	NumGoldPerEra = "", -- gold increment
		ReligionSpreads = L"TXT_KEY_UPANEL_SPREAD_RELIGION_USES" .. ": %i",
		ReligiousStrength = L"TXT_KEY_REL_STR" .. " %i", -- TODO
	--n	CombatLimit = "",
		NumExoticGoods = L"TXT_KEY_MISSION_SELL_EXOTIC_GOODS" .. ": %i",
	--n	RangedCombatLimit = "",
	--n	XPValueAttack = "",
	--n	XPValueDefense = "",
	--n	Conscription = "",
		ExtraMaintenanceCost = L"TXT_KEY_PEDIA_MAINT_LABEL" .. " -%i" .. g_currencyIcon,
	--u	Unhappiness = L"2": %i[ICON_HAPPINESS_3]",
	--n	LeaderExperience = "", --unused
	--n	UnitFlagIconOffset = "",
	--n	PortraitIndex = "",
	}
	
	for k,v in pairs( unit ) do
		if v and v ~= 0 and v~=-1 then
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
		if item and (row.Moves or 0)~=0 then
			insert( tips, format( "[ICON_BULLET]%s %+i[ICON_MOVES]", TechColor( L(item.Description) ), row.Moves ) )
		end
	end
--TODO Technology_TradeRouteDomainExtraRange

	-- Ability to generate tourism upon spawn
	if IsCiv5BNW then
		for row in GameInfo.Policy_TourismOnUnitCreation( thisUnitClass ) do
			item = GameInfo.Policies[ row.PolicyType ]
			if item and (row.Tourism or 0)~=0 then
				insert( tips, format( "[ICON_BULLET]%s %+i[ICON_TOURISM]", PolicyColor( L(item.Description) ), row.Tourism ) )
			end
		end
	end

	-- Resources required:
	if Game then
		for resource in GameInfo.Resources() do
			item = Game.GetNumResourceRequiredForUnit( unitID, resource.ID )
			if resource and item ~= 0 then
				insert( tips, ResourceQuantity( resource, -item ) )
			end
		end
	else
		for row in GameInfo.Unit_ResourceQuantityRequirements( thisUnitType ) do
			resource = GameInfo.Resources[ row.ResourceType ]
			if resource and (row.Cost or 0)~=0 then
				insert( tips, ResourceQuantity( resource, -row.Cost ) )
			end
		end
	end

	insert( tips, "----------------" )

	-- Cost:
	local costTip
	if productionCost > 1 then -- Production cost
		if not unit.PurchaseOnly then
			costTip = productionCost .. "[ICON_PRODUCTION]"
		end
		local goldCost = 0
		if city then
			goldCost = city:GetUnitPurchaseCost( unitID )
		elseif (unit.HurryCostModifier or 0) > 0 then
			goldCost = (productionCost * GameDefines.GOLD_PURCHASE_GOLD_PER_PRODUCTION ) ^ GameDefines.HURRY_GOLD_PRODUCTION_EXPONENT
			goldCost = (unit.HurryCostModifier + 100) * goldCost / 100
			goldCost = goldCost - ( goldCost % GameDefines.GOLD_PURCHASE_VISIBLE_DIVISOR )
		end
		if goldCost > 0 then
			if costTip then
				costTip = costTip .. ("(%i%%)"):format(productionCost*100/goldCost)
				if IsCiv5Vanilla then
					costTip = costTip .. " / " .. goldCost .. g_currencyIcon
				else
					costTip = L("TXT_KEY_PEDIA_A_OR_B", costTip, goldCost .. g_currencyIcon )
				end
			else
				costTip = goldCost .. g_currencyIcon
			end
		end
	end -- production cost
	if g_isReligionEnabled then -- Faith cost
		local faithCost = 0
		if city then
			faithCost = city:GetUnitFaithPurchaseCost( unitID, true )
		elseif Game then
			faithCost = Game.GetFaithCost( unitID )
		elseif unit.RequiresFaithPurchaseEnabled and unit.FaithCost then
			faithCost = unit.FaithCost
		end
		if ( faithCost or 0 ) > 0 then
			if costTip then
				costTip = L("TXT_KEY_PEDIA_A_OR_B", costTip, faithCost .. "[ICON_PEACE]" )
			else
				costTip = faithCost .. "[ICON_PEACE]"
			end
		end
	end --faith cost
	if costTip then
		insert( tips, L"TXT_KEY_PEDIA_COST_LABEL" .. " " .. ( costTip or L"TXT_KEY_FREE" ) )
	end

	-- build using food / stop city growth
	if unit.Food then
		insert( tips, L"TXT_KEY_CITYVIEW_STAGNATION_TEXT" .. " (" .. L"TXT_KEY_POPULATION_SUPPLY" .. ")" )
	end
	-- Settler Specifics
	if unit.Found or unit.FoundAbroad then
		append( tips, L("TXT_KEY_NO_ACTION_SETTLER_SIZE_LIMIT", GameDefines.CITY_MIN_SIZE_FOR_SETTLERS) )
	end

	-- Civilization:
	local civs = {}
	for requiredCivilizationType in GameInfo.Civilization_UnitClassOverrides( thisUnitType ) do
		item = GameInfo.Civilizations[ requiredCivilizationType.CivilizationType ]
		if item then
			insert( civs, L(item.ShortDescription) )
		end
	end
	if #civs > 0 then
		insert( tips, L"TXT_KEY_PEDIA_CIVILIZATIONS_LABEL".." "..concat( civs, ", ") )
	end

	-- Replaces:
	item = unitClass and GameInfo.Units[ unitClass.DefaultUnit ]
	if item and item ~= unit then
		insert( tips, L"TXT_KEY_PEDIA_REPLACES_LABEL".." "..format( "%s %s", ( item.Special and item.Special == "SPECIALUNIT_PEOPLE" and GreatPeopleIcon( item.Type ) or "" ), UnitColor( L(item.Description) ) ) )--!!! row
	end



	-- Required Policies:
	item = unit.PolicyType and GameInfo.Policies[ unit.PolicyType ]
	if unit.PolicyType then
		insert( tips, L"TXT_KEY_PEDIA_PREREQ_POLICY_LABEL" .. " " .. PolicyColor( L(item.Description) ) )
	end

	-- Required Buildings:
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
		insert( tips, L"TXT_KEY_PEDIA_REQ_BLDG_LABEL" .. " " .. concat( buildings, ", ") ) -- TXT_KEY_NO_ACTION_UNIT_REQUIRES_BUILDING
	end

	-- Prerequisite Techs:
	item = unit.PrereqTech and GameInfo.Technologies[ unit.PrereqTech ]
	if item and item.ID > 0 then
		insert( tips, L"TXT_KEY_PEDIA_PREREQ_TECH_LABEL" .. " " .. TechColor( L(item.Description) ) )
	end

	-- Upgrade from:
	local unitClassUpgrades = {}
	for unitUpgrade in GameInfo.Unit_ClassUpgrades( thisUnitClass ) do
		unitUpgrade = GameInfo.Units[ unitUpgrade.UnitType ]
		SetKey( unitClassUpgrades, unitUpgrade and unitUpgrade.Class )
	end
	local unitUpgrades = {}
	for unitToUpgrade in pairs( unitClassUpgrades ) do
		item = GetCivUnit( activeCivilizationType, unitToUpgrade )
		if item then
			insert( unitUpgrades, format( "%s %s", ( item.Special and item.Special == "SPECIALUNIT_PEOPLE" and GreatPeopleIcon( item.Type ) or "" ), UnitColor( L(item.Description) ) ) .. " ("..unitUpgradePrice( item, unit, activePlayer and activePlayer:GetUnitProductionNeeded( item.ID ), productionCost )..g_currencyIcon..")" )
		end
	end
	if #unitUpgrades > 0 then
		insert( tips, L"TXT_KEY_GOLD_UPGRADE_UNITS_HEADING3_TITLE" .. ": " .. concat( unitUpgrades, ", ") )
	end

	-- Becomes Obsolete with:
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
			insert( tips, L"TXT_KEY_COMMAND_UPGRADE" .. ": " .. format( "%s %s", ( item.Special and item.Special == "SPECIALUNIT_PEOPLE" and GreatPeopleIcon( item.Type ) or "" ), UnitColor( L(item.Description) ) ) .. " ("..unitUpgradePrice( unit, item, productionCost, activePlayer:GetUnitProductionNeeded( item.ID ) )..g_currencyIcon..")" )
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
				insert( unitUpgrades, UnitColor( L(item.Description) ) .. " ("..unitUpgradePrice( unit, item, productionCost )..g_currencyIcon..")" )
			end
		end
		if #unitUpgrades > 0 then
			insert( tips, L"TXT_KEY_COMMAND_UPGRADE" .. ": " .. concat( unitUpgrades, ", ") )
		end
	end

	-- Built <> Buiding Class Count
	local countText = {};
	if activePlayer then
	    if activePlayer:GetUnitClassCount( unitClassID ) == 0 and activePlayer:GetUnitClassMaking( unitClassID ) == 0 then
	    else
		if activePlayer:GetUnitClassCount( unitClassID ) > 0 then
			insert( countText, "[NEWLINE]" .. L( "TXT_KEY_ACTION_CLASS_BUILT_COUNT", activePlayer:GetUnitClassCount( unitClassID ) ) );
			if activePlayer:GetUnitClassMaking( unitClassID ) > 0 then
				append( countText, " <> "  .. L( "TXT_KEY_ACTION_CLASS_BUILDING_COUNT", activePlayer:GetUnitClassMaking( unitClassID ) ) );
			end
		else
			insert( countText, "[NEWLINE]" .. L( "TXT_KEY_ACTION_CLASS_BUILDING_COUNT", activePlayer:GetUnitClassMaking( unitClassID ) ) );
		end
	    end
	end
	if #countText > 0 then
		insert( tips, concat( countText, "") );
	end

	-- Limited number can be built
	if #countText == 0 and (maxGlobalInstances > 0 or maxTeamInstances > 0 or maxPlayerInstances > 0) then
		append( tips, "[NEWLINE]" );
	end
	if maxGlobalInstances > 0 then
		append( tips, "[COLOR_YELLOW]" .. L( "TXT_KEY_NO_ACTION_GAME_COUNT_MAX", maxGlobalInstances ) .. "[ENDCOLOR]" );
	end
	if maxTeamInstances > 0 then
		append( tips, "[COLOR_YELLOW]" .. L( "TXT_KEY_NO_ACTION_TEAM_COUNT_MAX", maxTeamInstances ) .. "[ENDCOLOR]" );
	end
	if maxPlayerInstances > 0 then
		append( tips, "[COLOR_YELLOW]" .. L( "TXT_KEY_NO_ACTION_PLAYER_COUNT_MAX", maxPlayerInstances ) .. "[ENDCOLOR]" );
	end

	-- Pre-written Help text
	return AddPreWrittenHelpTextAndConcat( tips, unit )
end



local g_ItemTooltipControls = {}
TTManager:GetTypeControlTable( "EUI_ItemTooltip", g_ItemTooltipControls )


local function ShowTextToolTipAndPicture( tip, index, altlas )
	local controls = g_ItemTooltipControls
	controls.Text:SetText( tip )
	controls.PortraitFrame:SetHide( not ( altlas and IconHookup( index, 256, altlas, controls.Portrait ) ) )
	controls.PortraitFrame:SetAnchor( GetMousePos() > 300 and "L,T" or "R,T" )
	controls.Box:DoAutoSize()
end
LuaEvents.ShowTextToolTipAndPicture.Add( ShowTextToolTipAndPicture )

local function ShowTextToolTip( ... )
	return ShowTextToolTipAndPicture( ... and concat( {...}, "[NEWLINE]----------------[NEWLINE]" ) )
end

local g_PromotionIconIM = StackInstanceManager( "PromotionIcon", "Image", g_UnitTooltipControls.IconStack )


	Controls.UnitTooltipTimer2:RegisterAnimCallback( function()
		---local controls = g_UnitTooltipControls
		g_ItemTooltipControls.PortraitFrame:SetHide( false )
		--g_ItemTooltipControls.Details:SetHide( false )
		g_ItemTooltipControls.IconStack2:SetWrapWidth( 32 )
		g_ItemTooltipControls.IconStack2:CalculateSize()
		g_ItemTooltipControls.PromotionText2:SetHide( false )
		g_ItemTooltipControls.Box:ReprocessAnchoring()
		g_ItemTooltipControls.Box:DoAutoSize()
	end)



function ShowTextToolTipAndPicture2( tip,itemID ,index, altlas )
	    local controls = g_ItemTooltipControls

		controls.Text:SetText( tip ) 
		local unit = GameInfo.Units[itemID]

		local i = 0
		local unitPromotion
		local promotionText = {}
		local promotionIcon
		g_PromotionIconIM:ResetInstances()

		--if not( unit.Trade ) then
		local thisUnitType = { UnitType = unit.Type }
        for row in GameInfo.Unit_FreePromotions( thisUnitType ) do
		unitPromotion = GameInfo.UnitPromotions[ row.PromotionType ]
		if unitPromotion then
		if  unitPromotion.ShowInUnitPanel ~= 0 and unitPromotion.ShowInTooltip ~= 0 then
		    promotionIcon = g_PromotionIconIM:GetInstance()
			IconHookup( unitPromotion.PortraitIndex, 32, unitPromotion.IconAtlas, promotionIcon.Image )
			table.insert( promotionText, Locale.ConvertTextKey( unitPromotion.Description) )
			 end
		  end
	   end
	--end

	
   ---iconIndex, iconAtlas = GetUnitPortraitIcon( itemID, GetActivePlayer() )


	controls.PortraitFrame:SetHide( not ( altlas and IconHookup( index, 256, altlas, controls.Portrait ) ) )
	controls.PortraitFrame:SetAnchor( GetMousePos() > 300 and "L,T" or "R,T" )
	----controls.Box:DoAutoSize()


		----controls.Details:SetHide( true )
		controls.PromotionText2:SetText( table.concat( promotionText, "[NEWLINE]" ) )
		controls.PromotionText2:SetHide( #promotionText ~= 1 )

		controls.IconStack2:SetWrapWidth( math.ceil( i / math.ceil( i / 10 ) ) * 26 )
		controls.IconStack2:CalculateSize()

		controls.Box:ReprocessAnchoring()
		controls.Box:DoAutoSize()

		Controls.UnitTooltipTimer2:SetToBeginning()
        Controls.UnitTooltipTimer2:SetPauseTime(0) ---决定晋升图标出现的延迟时间

		Controls.UnitTooltipTimer2:Reverse()	

end




LuaEvents.TechButtonTooltip.Add( function( orderID, itemID )  -------所有信息分类获取
	local tip = "no tip found"
	local item, iconIndex, iconAtlas
	if orderID == ORDER_TRAIN then

	
		iconIndex, iconAtlas = GetUnitPortraitIcon( itemID, GetActivePlayer() )
		tip = GetHelpTextForUnit2(itemID)
	    return ShowTextToolTipAndPicture2( tip,itemID ,iconIndex, iconAtlas )


	elseif orderID == ORDER_CONSTRUCT then
		iconIndex, iconAtlas = GetItemPortraitIcon( GameInfo.Buildings, itemID )
		tip = GetHelpTextForBuilding( itemID )
		return ShowTextToolTipAndPicture( tip, iconIndex, iconAtlas )



	elseif orderID == ORDER_CREATE then
		iconIndex, iconAtlas = GetItemPortraitIcon( GameInfo.Projects, itemID )
		tip = GetHelpTextForProject( itemID, true )
		return ShowTextToolTipAndPicture( tip, iconIndex, iconAtlas )


	elseif orderID == ORDER_MAINTAIN then
		iconIndex, iconAtlas = GetItemPortraitIcon( GameInfo.Processes, itemID )
		tip = GetHelpTextForProcess( itemID, true )
		return ShowTextToolTipAndPicture( tip, iconIndex, iconAtlas )


	elseif orderID == 11 then
		iconIndex, iconAtlas = GetItemPortraitIcon( GameInfo.Resources, itemID )
		tip = L("TXT_KEY_REVEALS_RESOURCE_ON_MAP", GameInfo.Resources[itemID]._Name)
		return ShowTextToolTipAndPicture( tip, iconIndex, iconAtlas )


	elseif orderID == 12 then
		local build = GameInfo.Builds[ itemID ]
		if build then
			tip = build._Name
			item = GameInfo.Improvements[ build.ImprovementType ]
			if item then
				tip = GetHelpTextForImprovement( item.ID )
			else
				item = GameInfo.Routes[ build.RouteType ]
				if not item then
					item = GameInfo.BuildFeatures{ BuildType = build.Type }()
					item = item and GameInfo.Features[ item.FeatureType ]
				end
			end
			if item then
				iconIndex, iconAtlas = item.PortraitIndex, item.IconAtlas
			end
		end
		return ShowTextToolTipAndPicture( tip, iconIndex, iconAtlas )

	elseif orderID == 13 then
		item = GameInfo.Missions[ itemID ]
		if item then
			local entry = item.Type
			if entry == "MISSION_EMBARK" then
				item = GameInfo.Concepts.CONCEPT_MOVEMENT_EMBARKING
			elseif entry == "MISSION_ROUTE_TO" then
				item = GameInfo.Concepts.CONCEPT_WORKERS_ROADS_TRADE_ROUTES
			elseif entry == "MISSION_ESTABLISH_TRADE_ROUTE" then
				item = GameInfo.Concepts.CONCEPT_TRADE_ROUTES
			end
			if item then
				tip = item._Name
			end
		end
		return ShowTextToolTipAndPicture( tip, iconIndex, iconAtlas )


	elseif orderID == 14 then
		item = GameInfo.Terraform[ itemID ]
		if item then
			local entry = item.Type
			if entry == "TERRAFORM_ADD_MIASMA" then
				item = GameInfo.Concepts.CONCEPT_WORKERS_PLACE
			elseif entry == "TERRAFORM_CLEAR_MIASMA" then
				item = GameInfo.Concepts.CONCEPT_WORKERS_REMOVE
			else
				item = GameInfo.Features[ item.FeatureTypeChange ] or GameInfo.Terrains[ item.TerrainTypeChange ]
			end
			if item then
				tip = item._Name
			end
		end
		return ShowTextToolTipAndPicture( tip, iconIndex, iconAtlas )


	elseif orderID == 15 then
		tip = GetHelpTextForPlayerPerk( itemID, true )
		return ShowTextToolTipAndPicture( tip, iconIndex, iconAtlas )
	end


	---return ShowTextToolTipAndPicture( tip, iconIndex, iconAtlas )
--	return ShowTextToolTipAndPicture( "This is button tooltip for order "..orderID.." item "..itemID.." icon "..tostring(iconIndex)..":"..tostring(iconAtlas).."[NEWLINE]"..tip, iconIndex, iconAtlas )
end)

LuaEvents.TechTooltip.Add( function( techID )
	return ShowTextToolTipAndPicture( GetHelpTextForTech( techID, Players[ GetActivePlayer() ]:CanResearch( techID ) ), GetItemPortraitIcon( GameInfo.Technologies, techID ) )
end)





----文本中关于晋升部分
	---<!--=======================================================================================================================-->
	--<!--    Instance of a promotion button  -->
	--<!--=======================================================================================================================-->
	--<Instance Name="PromotionInstance">
		--<Button Anchor="L,T" Size="64,64" Offset="0,0" Texture="64x64FrameButtons.dds" ToolTip="TXT_KEY_PEDIA_PROMOTION_NAME" ID="PromotionButton">
			--<ShowOnMouseOver>
				--<AlphaAnim Anchor="R,C" AnchorSide="O.O" Offset="-9,0" Size="16,32" TextureOffset="16.0" Texture="buttonsidesglow.dds" Pause="0" Cycle="Bounce" Speed="1" AlphaStart=".99" AlphaEnd=".25" Hidden="0"/>
				---<AlphaAnim Anchor="L,C" AnchorSide="O.O" Offset="-9,0" Size="16,32" TextureOffset="0.0" Texture="buttonsidesglow.dds" Pause="0" Cycle="Bounce" Speed="1" AlphaStart=".99" AlphaEnd=".25" Hidden="0"/>
				--<Image Anchor="R,C" Offset="-9,0" TextureOffset="8,0" AnchorSide="O.O" Texture="buttonsides.dds" Size="8,16"/>
				---<Image Anchor="L,C" Offset="-9,0" TextureOffset="0,0" AnchorSide="O.O" Texture="buttonsides.dds" Size="8,16"/>
			---</ShowOnMouseOver>
			--<Image Anchor="C,C" Texture="WonderAtlas512.dds" Size="64,64" ID="PromotionImage"/>
		--</Button>
	---</Instance>


local g_PromotionsManager = InstanceManager:new( "PromotionInstance", "PromotionButton", Controls.FreePromotionsInnerFrame );





	-- update the free promotions
		g_PromotionsManager:ResetInstances();
		buttonAdded = 0;

		local condition = "UnitType = '" .. thisUnit.Type .. "'";
		for row in GameInfo.Unit_FreePromotions( condition ) do
			local promotion = GameInfo.UnitPromotions[row.PromotionType];
			if promotion then
				local thisPromotionInstance = g_PromotionsManager:GetInstance();
				if thisPromotionInstance then
					local textureOffset, textureSheet = IconLookup( promotion.PortraitIndex, buttonSize, promotion.IconAtlas );				
					if textureOffset == nil then
						textureSheet = defaultErrorTextureSheet;
						textureOffset = nullOffset;
					end				
					UpdateSmallButton( buttonAdded, thisPromotionInstance.PromotionImage, thisPromotionInstance.PromotionButton, textureSheet, textureOffset, CategoryPromotions, Locale.ConvertTextKey( promotion.Description ), promotion.ID );
					buttonAdded = buttonAdded + 1;
				end
			end	
		end
		UpdateButtonFrame( buttonAdded, Controls.FreePromotionsInnerFrame, Controls.FreePromotionsFrame );