-- Lua Script10
-- Author: 11585
-- DateCreated: 2026/8/30 19:43:41
--------------------------------------------------------------
--==========================================================
-- Unit Tooltips
--==========================================================
local g_usedPromotions = {}  ---新增
local g_sparePromotions = {} ---新增


--do
local function UnitToolTip( unit )
	if unit then
		---local controls = g_UnitTooltipControls ----和eui不同之处，本次改为eui便于模仿
		local toolTipString = ShortUnitTip( unit )
		local playerID = unit:GetOwner()
		if playerID == GetActivePlayer() then
			toolTipString = toolTipString .. "[NEWLINE]".. L("TXT_KEY_UNIT_EXPERIENCE_INFO", unit:GetLevel(), unit:GetExperience(), unit:ExperienceNeeded() ) .. L"TXT_KEY_UPANEL_CLICK_TO_SELECT"
		end
		g_UnitTooltipControls.Text:SetText( toolTipString )

		local iconIndex, iconAtlas = GetUnitPortraitIcon( unit )
		IconHookup( iconIndex, 256, iconAtlas, g_UnitTooltipControls.UnitPortrait )  ----都切换为eui的写法controls
		CivIconHookup( playerID, 64, g_UnitTooltipControls.CivIcon, g_UnitTooltipControls.CivIconBG, g_UnitTooltipControls.CivIconShadow, false, true )
		local i = 0
		local promotionText = {}
		local promotionIcon

		if not( unit.IsTrade and unit:IsTrade() ) then
	
		---g_PromotionIconIM:ResetInstances()

			for unitPromotion in GameInfo.UnitPromotions() do
			     --- local unitPromotionID = unitPromotion.ID;
				if (unit:IsHasPromotion(unitPromotion.ID) and unitPromotion.ShowInUnitPanel ~= 0  and unitPromotion.ShowInTooltip ~= 0 ) then
				
				i = i + 1
				local instance = g_usedPromotions[i]----新增
				if not instance then----新增
					instance = table.remove( g_sparePromotions )----新增
					if instance then  ----新增
							instance.Promotion:ChangeParent( g_UnitTooltipControls.IconStack) ----新增 
						else ----新增
							instance = {}  ----新增
							ContextPtr:BuildInstanceForControl( "Promotion", instance, g_UnitTooltipControls.IconStack )----新增
						end ----新增
						g_usedPromotions[i] = instance ----新增
                     end ----新增

					---promotionIcon = g_PromotionIconIM:GetInstance()
					---IconHookup( unitPromotion.PortraitIndex, 32, unitPromotion.IconAtlas, promotionIcon.Image )

					IconHookup( unitPromotion.PortraitIndex, 32, unitPromotion.IconAtlas, instance.Promotion )
					table.insert( promotionText, unitPromotion._Name )
				end
			end
		end

		for j = i+1, #g_usedPromotions do ----新增
			table.insert( g_sparePromotions, g_usedPromotions[j] ) ----新增
			g_usedPromotions[j].Promotion:ChangeParent( g_ScrapControls )----新增
			g_usedPromotions[j] = nil
		end----新增


		g_UnitTooltipControls.PortraitFrame:SetAnchor( GetMousePos() > 300 and "L,T" or "R,T" )
		g_UnitTooltipControls.PromotionText:SetText( concat( promotionText, "[NEWLINE]" ) )
		g_UnitTooltipControls.PromotionText:SetHide( #promotionText ~= 1 )
		g_UnitTooltipControls.IconStack:SetWrapWidth( ceil( i / ceil( i / 10 ) ) * 26 )
		g_UnitTooltipControls.IconStack:CalculateSize()
		g_UnitTooltipControls.Box:DoAutoSize()
		--g_UnitTooltipControls.UnitTooltipTimer:SetToBeginning()
		---g_UnitTooltipControls.UnitTooltipTimer:Reverse()
	end
end
LuaEvents.UnitToolTip.Add( UnitToolTip )


-----------------------强权原始未修改版本
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
			       local unitPromotionID = unitPromotion.ID;
				if (unit:IsHasPromotion(unitPromotionID) and unitPromotion.ShowInUnitPanel ~= 0  and unitPromotion.ShowInTooltip ~= 0 ) then
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

        -- ========== 修改开始：晋升排序逻辑 ==========
        local promotionList = {}  -- 临时表，存放 { id, name }
        if not( unit.IsTrade and unit:IsTrade() ) then
            for unitPromotion in GameInfo.UnitPromotions() do
                local unitPromotionID = unitPromotion.ID
                if (unit:IsHasPromotion(unitPromotionID) and unitPromotion.ShowInUnitPanel ~= 0 and unitPromotion.ShowInTooltip ~= 0) then
                    table.insert(promotionList, {
                        id = unitPromotionID,
                        name = unitPromotion._Name
                    })
                end
            end
        end

        -- 自定义排序规则（这里以名称为例，按字母升序）
        table.sort(promotionList, function(a, b)
            return 
                  a.id
                   < 
                  b.id
                     -- 按名称字母顺序
            -- 如果想按自定义优先级，可改为按预设表索引排序（见下方注释）
        end)

		--🔧 自定义排序的几种常见方式

--你可以替换 table.sort 中的比较函数：

--· 按晋升等级（层级）排序（需自行定义优先级表）：
  --```lua
 -- local priorityOrder = { "PROMOTION_DRILL_1", "PROMOTION_SHOCK_1", ... } -- 按你想要的顺序
 -- table.sort(promotionList, function(a, b)
     -- local idxA = priorityOrder[a.id] or 999
      --local idxB = priorityOrder[b.id] or 999
      --return idxA < idxB
 -- end)
 -- ```
--· 按 ID 升序（原始顺序，但可保证稳定）：
  --```lua
  --table.sort(promotionList, function(a, b) return  a.id  <  b.id  end)
 -- ```


        -- 生成最终的晋升文本和图标
        local promotionText = {}
        g_PromotionIconIM:ResetInstances()
        for _, promo in ipairs(promotionList) do
            local promotionIcon = g_PromotionIconIM:GetInstance()
            -- 根据ID获取对应的Promotion信息（需要重新查询）
            local promoRow = GameInfo.UnitPromotions[promo.id]
            if promoRow then
                IconHookup(promoRow.PortraitIndex, 32, promoRow.IconAtlas, promotionIcon.Image)
                table.insert(promotionText, promo.name)
            end
        end
        -- ========== 修改结束 ==========

        controls.PortraitFrame:SetAnchor( GetMousePos() > 300 and "L,T" or "R,T" )
        controls.PromotionText:SetText( concat( promotionText, "[NEWLINE]" ) )
        controls.PromotionText:SetHide( #promotionText ~= 1 )  -- 注意原逻辑可能想让1个或更多时显示，但这里写的是~=1，即不等于1时隐藏？原意可能是只有1个时隐藏？但保持原样不变。
        -- 原代码中 i 未定义，这里用 #promotionList 替代
        local i = #promotionList
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
Controls.UnitTooltipTimer2:RegisterAnimCallback( function()
		g_ItemTooltipControls.PortraitFrame2:SetHide( false )
		g_ItemTooltipControls.IconStack2:SetWrapWidth( 32 )
		g_ItemTooltipControls.IconStack2:CalculateSize()
		g_ItemTooltipControls.PromotionText2:SetHide( false )
		g_ItemTooltipControls.Box:ReprocessAnchoring()
		g_ItemTooltipControls.Box:DoAutoSize()
end)



function ShowTextToolTipAndPicture2( tip,orderID,itemID ,index, altlas )
	    local controls = g_ItemTooltipControls
		

		controls.Text2:SetText( tip )  ----在第一个上部显示
		------------------------------------------------新增晋升显示------------------------------------------------
		local unit = GameInfo.Units[itemID]
		local i = 0
		local unitPromotion
		local promotionText = {}
		local promotionIcon
		g_PromotionIconIM2:ResetInstances()

		--if not( unit.Trade ) then
		local thisUnitType = { UnitType = unit.Type }
        for row in GameInfo.Unit_FreePromotions( thisUnitType ) do
		unitPromotion = GameInfo.UnitPromotions[ row.PromotionType ]

		if  unitPromotion~=nil  then
		    if  unitPromotion.ShowInUnitPanel ~= 0 and unitPromotion.ShowInTooltip ~= 0 then
		    promotionIcon = g_PromotionIconIM2:GetInstance()
			IconHookup( unitPromotion.PortraitIndex, 32, unitPromotion.IconAtlas, promotionIcon.Image2 )
			table.insert( promotionText, Locale.ConvertTextKey( unitPromotion.Description) )
			    end
			end
		end
	
	    controls.PortraitFrame2:SetHide( not ( altlas and IconHookup( index, 256, altlas, controls.Portrait2 ) ) )
	    controls.PortraitFrame2:SetAnchor( GetMousePos() > 300 and "L,C" or "R,C" )

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

	if orderID == OrderTypes.ORDER_TRAIN then	
		iconIndex, iconAtlas = GetUnitPortraitIcon( itemID, GetActivePlayer() )
		tip = GetHelpTextForUnit2(itemID)

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


	local freePromotions = {}  ----新增

	local city, item, resource

	------------------------------------------------新增晋升显示------------------------------------------------
    for row in GameInfo.Unit_FreePromotions( thisUnitType ) do
		item = GameInfo.UnitPromotions[ row.PromotionType ]
		if item then
		HitModifier= HitModifier + item.MaxHitPointsModifier
		HitChange= HitChange + item.MaxHitPointsChange
		unitRange = unitRange + (item.RangeChange or 0)
		unitMoves = unitMoves + (item.MovesChange or 0)
		unitSight = unitSight + (item.VisibilityChange or 0)
		if  item.ShowInUnitPanel ~= 0 and item.ShowInTooltip ~= 0 then  ----新增
			insert( freePromotions, L(item.Description) ) ----新增
			end
		end
	end

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
	if workrate ~=0 then
		insert( tips, L"TXT_KEY_PEDIA_WORKRATE_LABEL" ..workrate  )
	end

	-----新增Sight:视野--------------------------------------------------- 
	if unitSight > 0 then
		insert( tips, L"TXT_KEY_PEDIA_SIGHT_LABEL" .. " " .. unitSight .. "[ICON_PROMOTION_SIGHT_1]" )
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
		MoveAfterPurchase = L"TXT_KEY_MOVE_AFTER_PC",			-- TODO, LANDSKNECHT
		Immobile = L"TXT_KEY_DOMAIN_IMMOBILE",				-- bombs, missiles, aircraft etc...
		RivalTerritory = "[ICON_PROMOTION_GOLDEN_AGE_POINTS]" .. L"TXT_KEY_PROMOTION_RIVAL_TERRITORY",		-- unused
		Found = "[ICON_PROMOTION_SIEGE_3]" .. L"TXT_KEY_MISSION_BUILD_CITY",
		FoundAbroad = "[ICON_PROMOTION_SIEGE_2]" .. L"TXT_KEY_MISSION_BUILD_CITY" .. " <> " .. L"TXT_KEY_PGSCREEN_CONTINENTS",
		Suicide = "[ICON_PROMOTION_AMBUSH_1]" .. L"TXT_KEY_SUICIDE",	-- TODO, although obvious for base game may be less so in mods
		RushBuilding = L"TXT_KEY_MISSION_HURRY_PRODUCTION",
		SpreadReligion = "[ICON_MISSIONARY]" .. L"TXT_KEY_MISSION_SPREAD_RELIGION",
		RemoveHeresy = L"TXT_KEY_MISSION_REMOVE_HERESY",
		FoundReligion = "[ICON_PROPHET]" .. L"TXT_KEY_MISSION_FOUND_RELIGION",
		RequiresEnhancedReligion = L"TXT_KEY_REQUIRES_E",			-- TODO (inquisitors)
		ProhibitsSpread = "[ICON_INQUISITOR]" .. L"TXT_KEY_PROHIBITS_SPREAD",	-- TODO (inquisitors)
		CanBuyCityState = "[ICON_PROMOTION_TRADE_MISSION_BONUS]" .. L"TXT_KEY_MISSION_BUY_CITY_STATE",
		RangeAttackIgnoreLOS = "[ICON_PROMOTION_INDIRECT_FIRE]" .. L"TXT_KEY_PROMOTION_INDIRECT_FIRE",
		Trade = "[ICON_TRADE]" .. L"TXT_KEY_MISSION_ESTABLISH_TRADE_ROUTE",
		NoMaintenance = L"TXT_KEY_PEDIA_MAINT_LABEL" .. " 0",
	}
	local unitData = {
		CultureBombRadius = L"TXT_KEY_MISSION_CULTURE_BOMB" .. " ([ICON_RANGE_STRENGTH]%i)",	-- unused
		GoldenAgeTurns = L"TXT_KEY_MISSION_START_GOLDENAGE" .. " (%i " .. L"TXT_KEY_TURNS"..")",	-- Artist
		FreePolicies = L"TXT_KEY_MISSION_GIVE_POLICIES" .. " (%ix[ICON_CULTURE])",	-- unused
		OneShotTourism = L"TXT_KEY_MISSION_ONE_SHOT_TOURISM" .. " (%ix[ICON_TOURISM])",	-- Musician
		AirInterceptRange = L"TXT_KEY_MISSION_INTERCEPT" .. " [ICON_RANGE_STRENGTH]%i",
		NumFreeTechs = L"TXT_KEY_MISSION_DISCOVER_TECH" .. " (%i)",
		BaseBeakersTurnsToCount = L"TXT_KEY_MISSION_DISCOVER_TECH" .. " (%i " .. L"TXT_KEY_TURNS"..")", -- Scientist
		BaseCultureTurnsToCount = L"TXT_KEY_MISSION_GIVE_POLICIES" .. " (%i " .. L"TXT_KEY_TURNS"..")",	-- Writer
		ReligionSpreads = L"TXT_KEY_UPANEL_SPREAD_RELIGION_USES" .. ": %i",
		ReligiousStrength = L"TXT_KEY_REL_STR" .. " %i", -- TODO
		NumExoticGoods = L"TXT_KEY_MISSION_SELL_EXOTIC_GOODS" .. ": %i",
		ExtraMaintenanceCost = L"TXT_KEY_PEDIA_MAINT_LABEL" .. " -%i" .. g_currencyIcon,
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
			if item and (row.Tourism or 0)~=0 
			and item.Dummy~=1  --New
			then
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
	if unit.PolicyType 
	and GameInfo.Policies[ unit.PolicyType].Dummy~=1  --New 
	then
		insert( tips, L"TXT_KEY_PEDIA_PREREQ_POLICY_LABEL" .. " " .. PolicyColor( L(item.Description) ) )
	end

	-- Required Social Policy:
	item = unit.PolicyBranchType and GameInfo.PolicyBranchTypes[ unit.PolicyBranchType ]
	if item then
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

	if city~=nil then
	if not city:CanTrain(unitID) then
		append( tips, "[COLOR_WARNING_TEXT]" .. city:CanTrainTooltip(unitID) .. "[ENDCOLOR]" );
		end
	end

	-- Pre-written Help text
	return AddPreWrittenHelpTextAndConcat( tips, unit )

	   -- return ShowTextToolTipAndPicture2( tip,orderID,itemID ,iconIndex, iconAtlas )

	    local controls = g_ItemTooltipControls
		

		controls.Text2:SetText( tip )  ----在第一个上部显示
		------------------------------------------------新增晋升显示------------------------------------------------
		local unit = GameInfo.Units[itemID]
		local i = 0
		local unitPromotion
		local promotionText = {}
		local promotionIcon
		g_PromotionIconIM2:ResetInstances()

		--if not( unit.Trade ) then
		local thisUnitType = { UnitType = unit.Type }
        for row in GameInfo.Unit_FreePromotions( thisUnitType ) do
		unitPromotion = GameInfo.UnitPromotions[ row.PromotionType ]

		if  unitPromotion~=nil  then
		    if  unitPromotion.ShowInUnitPanel ~= 0 and unitPromotion.ShowInTooltip ~= 0 then
		    promotionIcon = g_PromotionIconIM2:GetInstance()
			IconHookup( unitPromotion.PortraitIndex, 32, unitPromotion.IconAtlas, promotionIcon.Image2 )
			table.insert( promotionText, Locale.ConvertTextKey( unitPromotion.Description) )
			    end
			end
		end
	
	    controls.PortraitFrame2:SetHide( not ( altlas and IconHookup( index, 256, altlas, controls.Portrait2 ) ) )
	    controls.PortraitFrame2:SetAnchor( GetMousePos() > 300 and "L,C" or "R,C" )

		controls.PromotionText2:SetText( table.concat( promotionText, "[NEWLINE]" ) )
		controls.PromotionText2:SetHide( #promotionText ~= 1 )

		controls.IconStack2:SetWrapWidth( math.ceil( i / math.ceil( i / 10 ) ) * 26 )
		controls.IconStack2:CalculateSize()

		controls.Box:ReprocessAnchoring()
		controls.Box:DoAutoSize()

		Controls.UnitTooltipTimer2:SetToBeginning()
        Controls.UnitTooltipTimer2:SetPauseTime(0) ---决定晋升图标出现的延迟时间
		Controls.UnitTooltipTimer2:Reverse()	


-----------------------------------------------------------------------------------------
	elseif orderID == OrderTypes.ORDER_CONSTRUCT then
		iconIndex, iconAtlas = GetItemPortraitIcon( GameInfo.Buildings, itemID )
		tip = GetHelpTextForBuilding( itemID )
		return ShowTextToolTipAndPicture( tip, iconIndex, iconAtlas )



	elseif orderID ==  OrderTypes.ORDER_CREATE then
		iconIndex, iconAtlas = GetItemPortraitIcon( GameInfo.Projects, itemID )
		tip = GetHelpTextForProject( itemID, true )
		return ShowTextToolTipAndPicture( tip, iconIndex, iconAtlas )


	elseif orderID == OrderTypes.ORDER_MAINTAIN then
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

	end

end)


LuaEvents.TechTooltip.Add( function( techID )
	return ShowTextToolTipAndPicture( GetHelpTextForTech( techID, Players[ GetActivePlayer() ]:CanResearch( techID ) ), GetItemPortraitIcon( GameInfo.Technologies, techID ) )
end)