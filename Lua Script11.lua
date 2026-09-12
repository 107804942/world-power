-- Lua Script11
-- Author: 11585
-- DateCreated: 2026/9/13 0:51:01
--------------------------------------------------------------
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
   end
end
GameEvents.PlayerDoTurn.Add(SomeUnitEffects)


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
