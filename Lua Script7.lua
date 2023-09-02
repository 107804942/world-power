-- Lua Script7
-- Author: 11585
-- DateCreated: 2023/8/28 21:10:48
--------------------------------------------------------------

function FaithCure(iPlayer, iUnit, iX, iY, bIsGreatPerson)
    local Player = Players[iPlayer]
	local iTileRadius = 3

	--if bIsGreatPerson then
      if Player:HasWonder(GameInfoTypes.BUILDING_PUMA_PUMKU) then
 
      for iShiftX = -iTileRadius, iTileRadius do
	  for iShiftY = -iTileRadius, iTileRadius do
	  local pTargetPlot = Map.PlotXYWithRangeCheck(iX, iY, iShiftX, iShiftY, iTileRadius)
      if pTargetPlot ~= nil  then
      unitCount = pTargetPlot:GetNumUnits()
      if unitCount > 0 then
      for i = 0, unitCount-1, 1 do
      local pFoundUnit = pTargetPlot:GetUnit(i)
      if pFoundUnit:GetOwner()==iPlayer then
	  pFoundUnit:ChangeDamage(-25) 
	                   end
	                end
	             end
	          end 
		   end
	    end
	end

    if Player:HasWonder(GameInfoTypes.BUILDING_OSARAGI) then
	for unit in Player:Units() do
	unit:ChangeDamage(-20) 
	   end
	end

 end
GameEvents.FaithDiscover.Add(FaithCure)



function GUIGU(iPlayer, iUnit, iUnitType, iX, iY)
local pPlayer = Players[iPlayer]
local pUnit = pPlayer:GetUnitByID(iUnit);
if pPlayer == nil or (not pPlayer:IsMajorCiv())   then
	 	return
	         end
 if pUnit == nil  then
	 	return
	         end
if  pPlayer:HasWonder(GameInfoTypes.BUILDING_GUIGU) 
and pPlayer:IsGoldenAge()  then
local randomNumber = ROG_GetTrueRandom(1, 100)
if randomNumber<=20 then
pPlayer:InitUnit(pUnit:GetUnitType(), iX,iY)
if pPlayer:IsHuman() then
	local title = Locale.ConvertTextKey("TXT_KEY_GUIGU_HEAD");
	local descr = Locale.ConvertTextKey("TXT_KEY_GUIGU", pUnit:GetName());
	pPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, descr, title, iX, iY, -1)
	     end
	  end
   end

end
GameEvents.GreatPersonExpended.Add(GUIGU)		  
		  

	
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







function DoSomeEffects(playerID)
    local player = Players[playerID]
    if player==nil
	then return 
	end
	for unit in player:Units() do  

	if  unit:GetUnitType() == GameInfoTypes["UNIT_NAVALCARRIER03P"] then
	    local iNumFighters = unit:GetCargo() 

		local pPlot = unit:GetPlot()
		local iNumFighters = 0
		for iVal = 0,(pPlot:GetNumUnits() - 1) do
		local loopUnit = pPlot:GetUnit(iVal)
		if (loopUnit:GetUnitType() == GameInfoTypes["UNIT_CARRIER_FIGHTER_FUTURE"]
		or loopUnit:GetUnitType() == GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"]) then
		iNumFighters = iNumFighters + 1
			end
		end

	if iNumFighters <= 4  then
		player:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
		player:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
		end
		if iNumFighters == 5  then
	    player:InitUnit(GameInfoTypes["UNIT_CARRIER_FIGHTER_STORM"], pPlot:GetX(), pPlot:GetY())
		end
	end
	

	if unit:IsHasPromotion(GameInfoTypes.PROMOTION_BURNING_EFFECT) ---猛火油柜
	then
	local damage = math.floor(unit:GetCurrHitPoints()*0.4)
	local damagefinal = math.max(20,damage)
		  unit:ChangeDamage(damagefinal)                                  
	end


   end

end
GameEvents.PlayerDoTurn.Add(DoSomeEffects)


-- ****************************************
-- 贝伦塔
-- ****************************************	
function PromotedWonderBuff(iPlayer, iUnit, iPromotionType)
  local player = Players[iPlayer]
  local unit = player:GetUnitByID(iUnit)

  if player == nil or (not player:IsMajorCiv()) then
	 	return
	         end

  if player:HasWonder(GameInfoTypes.BUILDING_BEILUN_TOWER) then 
  if unit:GetDomainType() ==DomainTypes.DOMAIN_SEA and unit:IsCombatUnit() then
	   unit:ChangeDamage(-50)
	   --unit:SetMoves(unit:MaxMoves());
         end
	  end

  if player:HasWonder(GameInfoTypes.BUILDING_KRAK_DES_CHEVALIERS) then  
    if unit:GetDamage() >0 and unit:GetUnitCombatType()==GameInfoTypes["UNITCOMBAT_MOUNTED"] and
	unit:IsHasPromotion(GameInfoTypes.PROMOTION_KNIGHT_COMBAT) then
	unit:ChangeDamage(-50) 
           end
	  end
end    
GameEvents.UnitPromoted.Add(PromotedWonderBuff)










-- ****************************************************************
-- 高德院
-- ****************************************************************	
function BuffForLiberated(iPlayer, iOtherPlayer, iCity) 
	local pPlayer = Players[iPlayer]; 
	if pPlayer == nil or (not pPlayer:IsMajorCiv())  then
	 	return
	         end
			  if pPlayer:HasWonder(GameInfoTypes.BUILDING_OSARAGI)then				
			    for row in GameInfo.MinorCivilizations() do	
				 if row.Type ~=nil then 
				 if Players[row.ID]:IsMinorCiv() then
					if Players[row.ID]:IsEverAlive() and Players[row.ID]:IsAlive() then
					Players[row.ID]:ChangeMinorCivFriendshipWithMajor(iPlayer,50)
					end
				end
			end
		end
	end
end
GameEvents.PlayerLiberated.Add(BuffForLiberated)



	function OnPillageDamageEnemies(iPlayer, iUnit, iImprovement, iGold)
	local pPlayer = Players[iPlayer]
	local pUnit = pPlayer:GetUnitByID(iUnit)
	if pPlayer == nil or (not pPlayer:IsMajorCiv()) or pUnit== nil then
	 	return
	         end 
	------------------------------------------------------------------
	  if pUnit:IsHasPromotion(GameInfoTypes.PROMOTION_PLUNDERED) then
	
		local iGameSpeedModifier1 = GameInfo.GameSpeeds[ Game.GetGameSpeedType() ].FaithPercent / 100
		local iGameSpeedModifier3 = GameInfo.GameSpeeds[ Game.GetGameSpeedType() ].GoldPercent / 100
		local iEraModifier = math.max(pPlayer:GetCurrentEra(), 1)
					
		local iGain1 = math.floor(10 * iGameSpeedModifier1 * iEraModifier)
		local iGain3 = math.floor(15 * iGameSpeedModifier3 * iEraModifier)
					
		pPlayer:ChangeFaith(iGain1)
		pPlayer:ChangeGold(iGain3)
		pUnit:ChangeDamage(-25)
		pUnit:SetMoves(pUnit:MovesLeft()+GameDefines["MOVE_DENOMINATOR"])
		pUnit:SetMadeAttack(false)
					
		if pPlayer:IsHuman() and pPlayer:IsTurnActive() then
			local vUnitPosition = PositionCalculator(pUnit:GetX(), pUnit:GetY())				
			Events.AddPopupTextEvent(vUnitPosition, "[COLOR_WHITE]+"..iGain1.." [ICON_PEACE][ENDCOLOR]", 1)
			Events.AddPopupTextEvent(vUnitPosition, "[COLOR_YIELD_GOLD]+"..iGain3.." [ICON_GOLD][ENDCOLOR]", 1.5)
		end
	end


end
GameEvents.UnitPillageGold.Add(OnPillageDamageEnemies)



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


------------------------------------------------------------------

-- ****************************************
-- 武僧
-- ****************************************
function CanHaveExtraPromotionForMonk(iPlayer, iUnit, iPromotionType)
  local player = Players[iPlayer];
  local pUnit = Players[iPlayer]:GetUnitByID(iUnit);


  if iPromotionType == GameInfoTypes.PROMOTION_DRILL_4
  or iPromotionType == GameInfoTypes.PROMOTION_SHOCK_4 then
  if pUnit:GetUnitClassType() ==GameInfo.UnitClasses.UNITCLASS_MONK.ID then
	return true
  end
  return false
  end
    return true
end
GameEvents.CanHavePromotion.Add(CanHaveExtraPromotionForMonk)


	
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


