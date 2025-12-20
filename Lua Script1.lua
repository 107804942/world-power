-- Lua Script1
-- Author: 11585
-- DateCreated: 2023/7/26 0:13:52
--------------------------------------------------------------\

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