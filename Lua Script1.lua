-- Lua Script1
-- Author: 11585
-- DateCreated: 2023/7/26 0:13:52
--------------------------------------------------------------\
function UpdateUnitPortrait( unit )
	if not unit then return end
	
	local name;
	if(unit:IsGreatPerson()) or unit:GetUnitCombatType() == GameInfoTypes.UNITCOMBAT_MAGICALGIRL then
		name = unit:GetNameNoDesc();
		if(name == nil or #name == 0) then
			name = unit:GetName();
		end
	else
		name = unit:GetName();
	end
	
	name = Locale.ToUpper(name);
	
	-- 精英单位/特殊单位名字前缀（保留你原有的逻辑）
	if unit:GetUnitType() ~= GameInfoTypes["UNIT_SPACESHIP"] 
		and unit:GetUnitType() ~= GameInfoTypes["UNIT_MECH"]
		and unit:GetUnitType() ~= GameInfoTypes["UNIT_GOLEM"]
		and unit:GetUnitType() ~= GameInfoTypes["UNIT_GHOST"]
		and unit:GetUnitType() ~= GameInfoTypes["UNIT_SIEGE04H"]
		and unit:GetUnitType() ~= GameInfoTypes["UNIT_LEVDESTROYER"]
		and unit:GetUnitType() ~= GameInfoTypes["UNIT_NAVALCARRIER03P"]
		and unit:GetUnitType() ~= GameInfoTypes["UNIT_ANGEL"]
		and unit:GetUnitType() ~= GameInfoTypes["UNIT_NAVAL_MONSTER"]
		and unit:GetUnitType() ~= GameInfoTypes["UNIT_ALIEN_SIEGE_WORM"]
		and unit:GetUnitType() ~= GameInfoTypes["UNIT_PARTICLE_CANNON"] then
		if unit:GetMaxHitPoints() > 1000 then
			name = "[ICON_PROMOTION_GROUP_EXTRA][ICON_PROMOTION_GROUP_EXTRA][ICON_PROMOTION_GROUP_EXTRA][ICON_PROMOTION_ELITE_EXTRA]" .. name;
		elseif unit:GetMaxHitPoints() > 900 then
			name = "[ICON_PROMOTION_GROUP_EXTRA][ICON_PROMOTION_GROUP_EXTRA][ICON_PROMOTION_ELITE_EXTRA][ICON_PROMOTION_ELITE_EXTRA]" .. name;
		elseif unit:GetMaxHitPoints() > 800 then
			name = "[ICON_PROMOTION_GROUP_EXTRA][ICON_PROMOTION_GROUP_EXTRA][ICON_PROMOTION_GROUP_EXTRA]" .. name;
		elseif unit:GetMaxHitPoints() > 700 then
			name = "[ICON_PROMOTION_GROUP_EXTRA][ICON_PROMOTION_GROUP_EXTRA][ICON_PROMOTION_ELITE_EXTRA]" .. name;
		elseif unit:GetMaxHitPoints() > 600 then
			name = "[ICON_PROMOTION_GROUP_EXTRA][ICON_PROMOTION_ELITE_EXTRA][ICON_PROMOTION_ELITE_EXTRA]" .. name;
		elseif unit:GetMaxHitPoints() > 500 then
			name = "[ICON_PROMOTION_GROUP_EXTRA][ICON_PROMOTION_GROUP_EXTRA]" .. name;
		elseif unit:GetMaxHitPoints() > 400 then
			name = "[ICON_PROMOTION_GROUP_EXTRA][ICON_PROMOTION_ELITE_EXTRA]" .. name;
		elseif unit:GetMaxHitPoints() > 300 then
			name = "[ICON_PROMOTION_ELITE_EXTRA][ICON_PROMOTION_ELITE_EXTRA]" .. name;
		elseif unit:GetMaxHitPoints() > 200 then
			name = "[ICON_PROMOTION_GROUP_EXTRA]" .. name;
		elseif unit:GetMaxHitPoints() > 100 then
			name = "[ICON_PROMOTION_ELITE_EXTRA]" .. name;
		end
	end

	if unit:GetUnitType() == GameInfoTypes["UNIT_SPACESHIP"] then
		name = "[ICON_PROMOTION_ELITE_EXTRA][ICON_PROMOTION_ELITE_EXTRA]" .. name.. "[ICON_PROMOTION_ELITE_EXTRA][ICON_PROMOTION_ELITE_EXTRA]";
	end
	if unit:IsHasPromotion(GameInfoTypes["PROMOTION_CAN_RANGE_ATTACK"]) then
		name = name .. "[ICON_RANGE_STRENGTH]";
	end
	
	local convertedKey = Locale.ConvertTextKey(name);
	convertedKey = Locale.ToUpper(convertedKey);
	Controls.UnitName:SetText(convertedKey);    
	Controls.UnitName:SetFontByName("TwCenMT24");   
	
	local name_length = Controls.UnitName:GetSizeVal();
	local box_length = Controls.UnitNameButton:GetSizeVal();
	if (name_length > (box_length - 50)) then
		Controls.UnitName:SetFontByName("TwCenMT20");   
	end
	name_length = Controls.UnitName:GetSizeVal();
	if(name_length > (box_length - 50)) then
		Controls.UnitName:SetFontByName("TwCenMT14");
	end
	
	-- Tool tip（XP 显示）
	local strToolTip = Locale.ConvertTextKey("TXT_KEY_CURRENTLY_SELECTED_UNIT");
	if unit:IsCombatUnit() or unit:GetDomainType() == DomainTypes.DOMAIN_AIR then
		local iExperience = unit:GetExperience();
		local iLevel = unit:GetLevel();
		local iExperienceNeeded = unit:ExperienceNeeded();
		local xpString = Locale.ConvertTextKey("TXT_KEY_UNIT_EXPERIENCE_INFO", iLevel, iExperience, iExperienceNeeded);
		Controls.XPMeter:SetToolTipString( xpString );
		Controls.XPMeter:SetPercent( iExperience / iExperienceNeeded );
		Controls.XPFrame:SetHide( false );
	else
		Controls.XPFrame:SetHide( true );
	end

	-- 立绘（先清空，再用 IconLookup 处理像素偏移和纹理名）
	Controls.UnitPortrait:SetTexture( "" );
	local portraitOffset, portraitAtlas = UI.GetUnitPortraitIcon(unit);
	
	local textureOffset, textureAtlas = IconLookup( portraitOffset, unitPortraitSize, portraitAtlas );
	if textureOffset == nil then
		textureOffset = nullOffset;
		textureAtlas = defaultErrorTextureSheet;
	end
	Controls.UnitPortrait:SetTexture( textureAtlas );
	Controls.UnitPortrait:SetTextureOffset( textureOffset );

	Controls.CycleLeft:SetHide(false);
	Controls.CycleRight:SetHide(false);
end



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



function OnCircumnavigatedGlobe(iTeam)
  local pPlayer = Players[Game.GetActivePlayer()]
  local sHead = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_HEAD")
  local sText = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_TEXT_UNKNOWN")

  local Team = Teams[iTeam]
  local Player = Players[Team:GetLeaderID()];

  local plot =  Player:GetCapitalCity():Plot()
  ---local Unit  = Player:InitUnit(GameInfoTypes.UNIT_SCIENTIST, plot:GetX(), plot:GetY())

  if (Game.GetActiveTeam() == iTeam) then
    sText = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_TEXT_YOU")
  else
    if (Teams[Game.GetActiveTeam()]:IsHasMet(iTeam)) then
      sText = Locale.ConvertTextKey("TXT_KEY_MAGELLAN_TEXT_KNOWN", Players[Teams[iTeam]:GetLeaderID()]:GetCivilizationShortDescriptionKey())
	end
  end
  ---Player:SetNumFreeTechs(1)
  Player:ChangeFreePromotionCount(GameInfoTypes.PROMOTION_CIRCUMNAVIGATED,1)
  pPlayer:AddNotification(g_NotificationType, sText, sHead, -1, -1, -1, -1)
end
GameEvents.CircumnavigatedGlobe.Add(OnCircumnavigatedGlobe)


function ClusterRocketInit(iPlayer, iUnit, ePromotion)
	local pPlayer = Players[iPlayer]
	local pUnit = pPlayer:GetUnitByID(iUnit)
	if pPlayer == nil  then
		return
	end 
	if  ePromotion== GameInfoTypes.PROMOTION_CLUSTER_ROCKET_3 then
		pUnit:SetHasPromotion(GameInfoTypes.PROMOTION_CLUSTER_ROCKET_INIT, true)
	end

end
GameEvents.UnitPromoted.Add(ClusterRocketInit)


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

-- ********************************************************
-- 
-- ******************************************************** 
function LatifundiumCheck(iPlayer, iUnit, iX, iY, iBuild)
   if iBuild == GameInfoTypes.BUILD_LATIFUNDIUM  then
   local pPlayer = Players[iPlayer]
   if pPlayer:HasWonder(GameInfoTypes.BUILDING_SILKROAD) then
     return true
		 end   
	 return false
	  end
	  return true
 end
GameEvents.PlayerCanBuild.Add(LatifundiumCheck)





function TourismToGold(iPlayer, iUnit, iX, iY, bIsGreatPerson)
local pPlayer = Players[iPlayer]
local pUnit = pPlayer:GetUnitByID(iUnit)
if bIsGreatPerson 
and pPlayer:HasWonder(GameInfoTypes.BUILDING_KARLSTEJN) then
local gold = pPlayer:CalculateGoldRate()
pPlayer:ChangeGold(3*gold)
   end
end
GameEvents.TourismDiscover.Add(TourismToGold)





function AG_BUFF(iPlayer)
	local player = Players[iPlayer]
	if player == nil 
	or (not player:IsMajorCiv()) 
	or (not player:IsAlive()) then
	 	return
	         end

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
								 local science= math.max(0,pCity:GetYieldRate(YieldTypes.YIELD_SCIENCE))
				                 local gold= math.max(0,pCity:GetYieldRate(YieldTypes.YIELD_GOLD))
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
				                         ChangeResearchProcess(player, iTeamID, iTeam, iTeamTechs, iPlayer, science*sum)									
                					 end
		      					 end
           					 end
        				end
	 				end
	 ----------------------------------------------------------------------------------

end
GameEvents.PlayerDoTurn.Add(AG_BUFF)





local UathachPromotion = GameInfoTypes["PROMOTION_NUKE_IMMUNE2"]
local iRadius = 2

function UathachActivate(playerID, unitID, bTestAllAllies)
	local pPlayer = Players[playerID]
	local pUnit = pPlayer:GetUnitByID(unitID)
	if not pUnit then return end
	if bTestAllAllies then
		for pUnit  in pPlayer:Units() do
			if pUnit :GetUnitType() ~= GameInfoTypes["UNIT_GOLEM"]  and not IsHugeUnit(pUnit )   then
				local bThisUnitStaysBuffed = UathachLoop(pPlayer, pUnit ,pUnit :GetPlot())
				if bThisUnitStaysBuffed then
					pUnit:SetHasPromotion(UathachPromotion, true)
				else
					pUnit:SetHasPromotion(UathachPromotion, false)
				end
			end
		end
	else
		if pUnit :GetUnitType() ~= GameInfoTypes["UNIT_GOLEM"]  and not IsHugeUnit(pUnit )  then
			local bThisUnitStaysBuffed = UathachLoop(pPlayer, pUnit, pUnit:GetPlot())
			if bThisUnitStaysBuffed then
				pUnit:SetHasPromotion(UathachPromotion, true)
			else
				pUnit:SetHasPromotion(UathachPromotion, false)
			end
		end
	end
end

function UathachLoop(pPlayer, pUnit, pPlot)
	if pPlot then
		for c = 0, pPlot:GetNumUnits() - 1 do
			local pPlotUnit = pPlot:GetUnit(c)
			if pPlotUnit and pPlotUnit ~= pUnit then
				if pPlotUnit:GetOwner() == pPlayer:GetID() and pPlotUnit:GetUnitType() == GameInfoTypes["UNIT_GOLEM"] then
					return true
				end
			end
		end
		if iRadius > 0 then
			for pAreaPlot in PlotAreaSpiralIterator(pPlot, iRadius, 2, true, true, true) do
				if pAreaPlot:IsUnit() then
					for c = 0, pAreaPlot:GetNumUnits() - 1 do
						local pPlotUnit = pAreaPlot:GetUnit(c)
						if pPlotUnit then
							if pPlotUnit:GetOwner() == pPlayer:GetID() and pPlotUnit:GetUnitType() == GameInfoTypes["UNIT_GOLEM"] then
								return true
							end
						end
					end
				end
			end
		end
	end
	return false
end
GameEvents.UnitSetXY.Add(UathachActivate)












function SpaceBattleCruiserManaForHuman(iPlayer)
		local pPlayer = Players[iPlayer]
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
GameEvents.PlayerDoTurn.Add(SpaceBattleCruiserManaForHuman)


-- One City Challenge Achievement: For Those Who Bitch About The Civ Not Being OCC Like In Civ 6 ! !
-- AA_MHC15_TEOTIHUACAN_SPECIAL
function AA_MHC15_Teotihuacan_OneCityAchievo(type, team)
	if IsAAUnlocked('AA_MHC15_TEOTIHUACAN_SPECIAL') then return end
		if team == Game:GetActiveTeam() then
		local iPlayer = Game:GetActivePlayer()
		local pPlayer = Players[iPlayer]
		local iNumCities = pPlayer:GetNumCities()
			if HasTrait(pPlayer) and iNumCities == 1 then
				UnlockAA('AA_MHC15_TEOTIHUACAN_SPECIAL');
			end
		end
	end

Events.EndGameShow.Add(AA_MHC15_Teotihuacan_OneCityAchievo);	