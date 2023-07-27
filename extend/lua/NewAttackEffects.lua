include("FLuaVector.lua")
include("PlotIterators.lua")
include("FunctionUtilities.lua")
include( "UtilityFunctions.lua")
include("Rog_SaveUtils.lua"); MY_MOD_NAME = "世界强权";
--------------------------------------------------------------------------------------------------------------------------
--新效果
--------------------------------------------------------------------------------------------------------------------------

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





function PositionCalculator(i1, i2)
	return HexToWorld(ToHexFromGrid(Vector2(i1, i2)))
end



local NewAttackOff = GameInfo.SPNewEffectControler.SP_NEWATTACK_OFF.Enabled
local UnitDeathCounterOff = GameInfo.SPNewEffectControler.UNIT_DEATH_COUNTER_OFF.Enabled

local g_DoExtraAttackEffect = nil;
function ExtraAttackEffectStarted(iType, iPlotX, iPlotY)
	if iType == GameInfoTypes["BATTLETYPE_MELEE"]
	or iType == GameInfoTypes["BATTLETYPE_RANGED"]
	or iType == GameInfoTypes["BATTLETYPE_AIR"]
	or iType == GameInfoTypes["BATTLETYPE_SWEEP"]
	then
		g_DoExtraAttackEffect = {
			attPlayerID = -1,
			attUnitID   = -1,
			defPlayerID = -1,
			defUnitID   = -1,
			attODamage  = 0,
			defODamage  = 0,
			PlotX = iPlotX,
			PlotY = iPlotY,
			bIsCity = false,
			defCityID = -1,
			battleType = iType,
		};
		--print("战斗开始.")
	end
end
GameEvents.BattleStarted.Add(ExtraAttackEffectStarted);

function ExtraAttackEffectJoined(iPlayer, iUnitOrCity, iRole, bIsCity)
	if g_DoExtraAttackEffect == nil
	or Players[ iPlayer ] == nil or not Players[ iPlayer ]:IsAlive()
	or (not bIsCity and Players[ iPlayer ]:GetUnitByID(iUnitOrCity) == nil)
	or (bIsCity and (Players[ iPlayer ]:GetCityByID(iUnitOrCity) == nil or iRole == GameInfoTypes["BATTLEROLE_ATTACKER"]))
	or iRole == GameInfoTypes["BATTLEROLE_BYSTANDER"]
	then
		return;
	end
	if bIsCity then
		g_DoExtraAttackEffect.defPlayerID = iPlayer;
		g_DoExtraAttackEffect.defCityID = iUnitOrCity;
		g_DoExtraAttackEffect.bIsCity = bIsCity;
	elseif iRole == GameInfoTypes["BATTLEROLE_ATTACKER"] then
		g_DoExtraAttackEffect.attPlayerID = iPlayer;
		g_DoExtraAttackEffect.attUnitID = iUnitOrCity;
		g_DoExtraAttackEffect.attODamage = Players[ iPlayer ]:GetUnitByID(iUnitOrCity):GetDamage();
	elseif iRole == GameInfoTypes["BATTLEROLE_DEFENDER"] or iRole == GameInfoTypes["BATTLEROLE_INTERCEPTOR"] then
		g_DoExtraAttackEffect.defPlayerID = iPlayer;
		g_DoExtraAttackEffect.defUnitID = iUnitOrCity;
		g_DoExtraAttackEffect.defODamage = Players[ iPlayer ]:GetUnitByID(iUnitOrCity):GetDamage();

		--------------------------------------------------------------------------------------------------


	-- Prepare for extra effect!
	if not bIsCity and g_DoExtraAttackEffect.battleType ~= GameInfoTypes["BATTLETYPE_AIR"] and g_DoExtraAttackEffect.battleType ~= GameInfoTypes["BATTLETYPE_SWEEP"]
	and Players[g_DoExtraAttackEffect.attPlayerID] ~= nil and Players[g_DoExtraAttackEffect.attPlayerID]:GetUnitByID(g_DoExtraAttackEffect.attUnitID) ~= nil
	and Players[g_DoExtraAttackEffect.defPlayerID] ~= nil and Players[g_DoExtraAttackEffect.defPlayerID]:GetUnitByID(g_DoExtraAttackEffect.defUnitID) ~= nil
	then
		local attPlayer = Players[g_DoExtraAttackEffect.attPlayerID];
		local attUnit   = attPlayer:GetUnitByID(g_DoExtraAttackEffect.attUnitID);
		local defPlayer = Players[g_DoExtraAttackEffect.defPlayerID];
		local defUnit   = defPlayer:GetUnitByID(g_DoExtraAttackEffect.defUnitID);
	    end
	end
end
GameEvents.BattleJoined.Add(ExtraAttackEffectJoined);

function ExtraAttackEffectEffect()
 	 --Defines and status checks
	if g_DoExtraAttackEffect == nil or Players[ g_DoExtraAttackEffect.defPlayerID ] == nil
	or Players[ g_DoExtraAttackEffect.attPlayerID ] == nil or not Players[ g_DoExtraAttackEffect.attPlayerID ]:IsAlive()
	or Players[ g_DoExtraAttackEffect.attPlayerID ]:GetUnitByID(g_DoExtraAttackEffect.attUnitID) == nil
	-- or Players[ g_DoExtraAttackEffect.attPlayerID ]:GetUnitByID(g_DoExtraAttackEffect.attUnitID):IsDead()
	or Map.GetPlot(g_DoExtraAttackEffect.PlotX, g_DoExtraAttackEffect.PlotY) == nil
	then
		return;
	end
	
	local attPlayerID = g_DoExtraAttackEffect.attPlayerID;
	local attPlayer = Players[ attPlayerID ];
	local defPlayerID = g_DoExtraAttackEffect.defPlayerID;
	local defPlayer = Players[ defPlayerID ];
	
	local attUnit = attPlayer:GetUnitByID(g_DoExtraAttackEffect.attUnitID);
	local attPlot = attUnit:GetPlot();
	
	local plotX = g_DoExtraAttackEffect.PlotX;
	local plotY = g_DoExtraAttackEffect.PlotY;
	local batPlot = Map.GetPlot(plotX, plotY);
	local batType = g_DoExtraAttackEffect.battleType;
	
	local bIsCity = g_DoExtraAttackEffect.bIsCity;
	local defUnit = nil;
	local defPlot = nil;
	local defCity = nil;
	
	local attFinalUnitDamage = attUnit:GetDamage();
	local defFinalUnitDamage = 0;
	local attUnitDamage = attFinalUnitDamage - g_DoExtraAttackEffect.attODamage;
	local defUnitDamage = 0;
	
	if not bIsCity and defPlayer:GetUnitByID(g_DoExtraAttackEffect.defUnitID) then
		defUnit = defPlayer:GetUnitByID(g_DoExtraAttackEffect.defUnitID);
		defPlot = defUnit:GetPlot();
		defFinalUnitDamage = defUnit:GetDamage();
		defUnitDamage = defFinalUnitDamage - g_DoExtraAttackEffect.defODamage;
	elseif bIsCity and defPlayer:GetCityByID(g_DoExtraAttackEffect.defCityID) then
		defCity = defPlayer:GetCityByID(g_DoExtraAttackEffect.defCityID);
	end
	
	g_DoExtraAttackEffect = nil;



-- ********************************************************
-- 喷火效果
-- ********************************************************	
if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_FIRE_WEAPON"].ID)  then
      local iTileRadius = 2
      for iShiftX = -iTileRadius, iTileRadius do
	  for iShiftY = -iTileRadius, iTileRadius do
	  local pTargetPlot = Map.PlotXYWithRangeCheck(iX, iY, iShiftX, iShiftY, 1)
      if pTargetPlot ~= nil then
      local unitCount = pTargetPlot:GetNumUnits()
      if unitCount > 0 then
      for i = 0, unitCount-1, 1 do
      local pFoundUnit = pTargetPlot:GetUnit(i)
	  if pFoundUnit:GetDomainType() == DomainTypes.DOMAIN_LAND or pFoundUnit:GetDomainType() == DomainTypes.DOMAIN_SEA  
	  and not pFoundUnit:IsImmuneNegtivePromotions() then 
	  if attPlayer:IsAtWarWith(pFoundUnit:GetOwner())  then 
	  pFoundUnit:SetHasPromotion(GameInfoTypes.PROMOTION_BURNING_EFFECT, true)		 
                         end
				      end
			       end
		        end 
             end
	      end
      end
   end

-- ********************************************************
-- 悬浮毁灭者
-- ********************************************************	
	if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_EMP_BOMB_ON"].ID) then
	for unit in defPlayer:Units() do  
	unit:SetMoves(0)
	end
	for city in defPlayer:Cities() do
	city:ChangeResistanceTurns(1)
	end
    -- Notification
    if     defPlayer:IsHuman() then
    local heading = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_US_LVD_SHORT")
    local text = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_US_LVD")
    defPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC , text, heading, plotX, plotY)
    elseif attPlayer:IsHuman() then
    local heading = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_ENEMY_LVD_SHORT")
    local text = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_ENEMY_LVD")
    attPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC , text, heading, plotX, plotY)
    end
end


-- ********************************************************
-- 粒子炮增强
-- ******************************************************** 
	if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_SUPER_ENERGY_ON"].ID) then  ---技能开启后额外附加20%伤害
		for unit in defPlayer:Units() do
		local plot = unit:GetPlot()
			if  unit and unit ~= defUnit  and not unit:IsTrade()
			then
				local DamageOri = unit:GetMaxHitPoints()
				local ChainDamage = 0.25* DamageOri
				unit:ChangeDamage(ChainDamage, attPlayer);
			end
		end
	end



if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_PLASMA_CANNON"].ID) then
	for unit in defPlayer:Units() do
		local plot = unit:GetPlot()
			if  unit and unit ~= defUnit  and not unit:IsTrade()
			then
				local DamageOri = attUnit:GetRangeCombatDamage(unit,nil,false);
				local ChainDamage = 1 * DamageOri;        
			unit:ChangeDamage(ChainDamage, attPlayer);
		end
	end
end


-- ********************************************************
-- 导弹
-- ******************************************************** 
   if attUnit:IsHasPromotion(GameInfoTypes.PROMOTION_GROUP_AIR) then
   if attUnit:GetUnitClassType() == GameInfo.UnitClasses.UNITCLASS_GUIDED_MISSILE.ID
   or attUnit:GetUnitClassType() == GameInfo.UnitClasses.UNITCLASS_SUPER_MISSILE.ID then
   if not defUnit:IsDead() then
   local unitCount = attPlot:GetNumUnits()
   for i = 0, unitCount - 1, 1 do
   local pFoundUnit = attPlot:GetUnit(i)
   if (pFoundUnit ~=nil and pFoundUnit ~= attUnit and pFoundUnit:IsHasPromotion(GameInfoTypes.PROMOTION_GROUP_AIR)) then
   if pFoundUnit:GetUnitClassType() == GameInfo.UnitClasses.UNITCLASS_GUIDED_MISSILE.ID
   or pFoundUnit:GetUnitClassType() == GameInfo.UnitClasses.UNITCLASS_SUPER_MISSILE.ID then
   if pFoundUnit:CanRangeStrikeAt(defPlot:GetX(), defPlot:GetY(), true, true) 
   and Players[pFoundUnit:GetOwner()] == attPlayer  then
   pFoundUnit:RangeStrike(defPlot:GetX(), defPlot:GetY() )
   pFoundUnit:Kill()
                     end
                  end
               end
            end
         end
      end
   end




-- ********************************************************
-- 蠕虫
-- ******************************************************** 
if  attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_EVIL"].ID) 
and attUnit:GetBaseCombatStrength()<600 then
if defUnit:IsDead() then 
   attUnit:SetBaseCombatStrength(attUnit:GetBaseCombatStrength()+10)
   end
end


	
-- ********************************************************
-- 突击虎本体攻击
-- ******************************************************** 
if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_STURMTIGER"].ID)  then 
if load(attUnit, "DoFireSupport") ==nil  then
save(attUnit, "DoFireSelf",1) 
   end
end



-- ********************************************************
-- 赫梯
-- ******************************************************** 
if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_COMBAT_TO_DEATH"].ID)  then

if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_COMBAT_TO_DEATH_4"].ID)  then
   attUnit:SetHasPromotion(GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_5, true)
   attUnit:SetHasPromotion(GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_4, false)
elseif attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_COMBAT_TO_DEATH_3"].ID) then   
   attUnit:SetHasPromotion(GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_4, true)
   attUnit:SetHasPromotion(GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_3, false)
elseif attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_COMBAT_TO_DEATH_2"].ID) then  
   attUnit:SetHasPromotion(GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_3, true)
   attUnit:SetHasPromotion(GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_2, false)
elseif attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_COMBAT_TO_DEATH_1"].ID) then   
   attUnit:SetHasPromotion(GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_2, true)
   attUnit:SetHasPromotion(GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_1, false)
elseif attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_COMBAT_TO_DEATH_0"].ID) then  
   attUnit:SetHasPromotion(GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_1, true)
   attUnit:SetHasPromotion(GameInfoTypes.PROMOTION_COMBAT_TO_DEATH_0, false)
   end
end

-- ********************************************************
-- 攻击城市
-- ********************************************************  
	if defCity then



-- ********************************************************
-- 乌尔班
-- ********************************************************
	 if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_URBAN"].ID)  then 
        defCity:ChangeResistanceTurns(1)
       end	
   end


-- ********************************************************
-- 负面buff
-- ********************************************************   
    -- Debuff immune unit
	    if defUnit then




-- ********************************************************
-- 海怪
-- ********************************************************
 if attUnit:IsHasPromotion(GameInfoTypes.PROMOTION_NAVAL_MONSTER) and  defUnit  then
        local heal = 0
		--if  defUnit:IsDead() then
		attUnit:ChangeDamage(-50)
		local extraRange = 2	
	    for dx = -extraRange, extraRange - 1, 1 do
	    for dy = -extraRange, extraRange - 1, 1 do
        local adjPlot = Map.PlotXYWithRangeCheck(plotX, plotY, dx, dy, 2);
		if adjPlot ~= nil then
		unitCount = adjPlot:GetNumUnits();
        if unitCount > 0 then
		for i = 0, unitCount-1, 1 do
        local pFoundUnit = adjPlot:GetUnit(i);
        if pFoundUnit~= attUnit   
		and pFoundUnit:IsCombatUnit()
	    and pFoundUnit:GetDomainType() ==DomainTypes.DOMAIN_SEA then
		if Players[pFoundUnit:GetOwner()] == attPlayer then
		heal=heal+1
		end		                       
		if heal>0 then
		if pFoundUnit~=nil then
		pFoundUnit:ChangeDamage(-50)	
						        -- end
						      end
					       end
				        end
			         end
			      end
		       end	
			end			       
		end
     end
		

-- ********************************************************
-- 堡垒克制近战
-- ********************************************************                      
     if  attUnit  and defUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_CITADEL_DEFENSE"].ID) 
	 and batType == GameInfoTypes["BATTLETYPE_MELEE"] then
	 if  not attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_SIEGE6"].ID) 
	 and not attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_ANTI_DEBUFF"].ID) 
	 and not defUnit:IsDead()  then 
		 attUnit:SetMoves(0)
	    end
	end

		
-- ********************************************************
-- 乌尔班效果
-- ******************************************************** 
	if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_URBAN"].ID) then
	        
			local textcount = 0

		    local unitCount = defPlot:GetNumUnits();
		    if unitCount > 0 then
			for i = 0, unitCount-1, 1 do
				local pFoundUnit = defPlot:GetUnit(i)
				if attPlayer:IsAtWarWith(pFoundUnit:GetOwner())   then
				if   not pFoundUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_ANTI_DEBUFF"].ID) then
					pFoundUnit:SetMoves(0);     
		               end
					end
				end
			end

			----------------------------------------------------------------------------------------------------------------------------
			local TileRadius = 2
	        for dx = -TileRadius, TileRadius - 1, 1 do
	        for dy = -TileRadius, TileRadius - 1, 1 do
            local loopPlot = Map.PlotXYWithRangeCheck(defUnit:GetX(), defUnit:GetY(), dx, dy, 1)
			if (loopPlot ~= nil and not loopPlot:IsCity()) then
                unitNum = loopPlot:GetNumUnits();
                if unitNum > 0 then
           for i = 0, unitNum-1, 1 do
           local pFoundUnit = loopPlot:GetUnit(i);
           if    pFoundUnit ~=defUnit and  not pFoundUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_ANTI_DEBUFF"].ID)  then	
	       if attPlayer:IsAtWarWith(pFoundUnit:GetOwner())   then

		   local randomNumber = ROG_GetTrueRandom(1, 100)
		   if randomNumber <=50 then
		   textcount = textcount+1
		   pFoundUnit:SetMoves(0)
		                            end
					            end
				             end
			              end
		               end
					end
				 end
			 end  	    
		 -- Notification
		    if textcount==0 then
		    if    defPlayer:IsHuman() then
			local heading = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_US_URBAN_SHORT")
			local text = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_US_URBAN")
			defPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC , text, heading, defUnit:GetX(), defUnit:GetY())
		    elseif attPlayer:IsHuman() then
			local heading = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_ENEMY_URBAN_SHORT")
			local text = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_ENEMY_URBAN")
			attPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC , text, heading, defUnit:GetX(), defUnit:GetY())
		       end
		    end
		   -- Notification
		    if textcount>0 then
		    if    defPlayer:IsHuman() then
			local heading = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_US_URBAN_SHORT")
			local text = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_US_URBAN2")
			defPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC , text, heading, defUnit:GetX(), defUnit:GetY())
		    elseif attPlayer:IsHuman() then
			local heading = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_ENEMY_URBAN_SHORT")
			local text = Locale.ConvertTextKey("TXT_KEY_SP_NOTIFICATION_UNIT_ENEMY_URBAN2")
			attPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC , text, heading, defUnit:GetX(), defUnit:GetY())
		      end
		   end
		end



-- ********************************************************
-- 突击虎无限次远程火力支援
-- ******************************************************** 
if attUnit:GetDomainType() == DomainTypes.DOMAIN_LAND then
if not attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_STURMTIGER"].ID)  then 
if not defUnit:IsDead()  then

if batType == GameInfoTypes["BATTLETYPE_MELEE"] 
or (batType == GameInfoTypes["BATTLETYPE_RANGED"] and attUnit:IsRangedSupportFire() == false) then

    local uniqueRange = 2
	for dx = -uniqueRange, uniqueRange - 1, 1 do
		for dy = -uniqueRange, uniqueRange - 1, 1 do
            local adjPlot = Map.PlotXYWithRangeCheck(attUnit:GetX(),attUnit:GetY(), dx, dy,1)
            if (adjPlot ~= nil) then
                local unitCount = adjPlot:GetNumUnits();
                if unitCount > 0 then
                    for i = 0, unitCount-1, 1 do
                        local pFoundUnit = adjPlot:GetUnit(i);
                        if pFoundUnit~=attUnit and pFoundUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_STURMTIGER"].ID)  then
						if Players[pFoundUnit:GetOwner()] == attPlayer then
						if Map.PlotDistance(pFoundUnit:GetX(), pFoundUnit:GetY(), defUnit:GetX(), defUnit:GetY()) <= pFoundUnit:Range() then
                        pFoundUnit:SetMadeAttack(false)
						pFoundUnit:ChangeMoves(GameDefines["MOVE_DENOMINATOR"])  

						save(pFoundUnit, "DoFireSupport",1) 

						pFoundUnit:RangeStrike(defUnit:GetX(), defUnit:GetY())

						if load(pFoundUnit, "DoFireSelf") ==nil  then
						pFoundUnit:SetMadeAttack(false)
						              end
						           end         
						       end
						    end
						 end
					  end
				   end
				end
			 end
		  end     
	   end  
    end
 end

-- ********************************************************
-- 魔像
-- ********************************************************
        if not attUnit:IsDead() then
        if batType==GameInfoTypes["BATTLETYPE_RANGED"] then
        if not defUnit:IsDead() and defUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_GOLEM"].ID)  then
		attUnit:ChangeDamage(defUnitDamage,defPlayer)
             end
          end
       end

	end
end	
GameEvents.BattleFinished.Add(ExtraAttackEffectEffect)




--****************************************************************************其他*************************************************************************************************

function UnitNearIronBeddhaKilled(iPlayer, iUnit, iUnitType, iX, iY, bDelay, iByPlayer)

	local pPlayer = Players[iPlayer]
	local pUnit = pPlayer:GetUnitByID(iUnit)		
	
	if iPlayer == -1  then return end -- 被毁灭单位所属文明
	if pUnit == -1  then return end -- 被毁灭单位	
	if not pUnit:IsCombatUnit() then return end ---非战斗单位
	--if iPlayer == iByPlayer  then return end --只能被其他文明摧毁
	--if iByPlayer == -1   then return end
    --local Plot =  pUnit:GetPlot()

	local Plot = Map.GetPlot(iX, iY)		
	for pAdjacentPlot in PlotAreaSweepIterator(Plot, 5, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		for iVal = 0,(pAdjacentPlot:GetNumUnits() - 1) do
			 local loopUnit = pAdjacentPlot:GetUnit(iVal)
			 if   loopUnit:IsHasPromotion(GameInfoTypes.PROMOTION_ANTI_ANTI_MOUNTED_BONUS) 
			 and  loopUnit:GetMoves() < 6*GameDefines["MOVE_DENOMINATOR"] 
			 and  not loopUnit:IsHasPromotion(GameInfoTypes.PROMOTION_NO_CHARGE_BONUS)  then
			   loopUnit:ChangeMoves(0.5*GameDefines["MOVE_DENOMINATOR"])
			   print("Unit Near IronBeddha Killed!")
			end
        end
	end
end
GameEvents.UnitPrekill.Add(UnitNearIronBeddhaKilled)



function CityRangedStrikeDamage(iPlayer,iAttCity,idefPlayer,idefUnit,iX, iY)
            local player = Players[iPlayer]
            local City  = player:GetCityByID(iAttCity)
			local defplayer = Players[idefPlayer]
			local defunit = defplayer:GetUnitByID(idefUnit)
			if	player == nil or City== nil or defplayer== nil or defunit== nil
		    then return 
			end 

			if defunit:IsDead() then
			if player:HasWonder(GameInfoTypes.BUILDING_FW_HELIOS) then
			City:SetMadeAttack(false)
			   end
			end


            if player:GetCurrentEra()>=GameInfo.Eras["ERA_INDUSTRIAL"].ID  then		
            for i = 0, 5 do
			local adjPlot = Map.PlotDirection(iX,iY, i)

			if adjPlot ~= nil then
	        local adjUnit = adjPlot:GetUnit(0)
			if adjUnit~=nil then
			if  adjUnit:GetOwner() ~= iPlayer  then
			if  player:IsAtWarWith(adjUnit:GetOwner())  then
			local CityDamage =City:RangeCombatDamage(adjUnit,nil);
			adjUnit:ChangeDamage(CityDamage,iPlayer)
			          end
			       end
			   end
			end
		end  		 
    end

	if  player:GetCurrentEra()==GameInfoTypes.ERA_FUTURE then
	if  player:HasWonder(GameInfoTypes.BUILDING_FW_HELIOS) then
			if  City:IsHasBuilding(GameInfoTypes["BUILDING_SOLAR_PLANT"])then
				local plot = City:Plot()
				local extraRange = 3	
	            for dx = -extraRange, extraRange - 1, 1 do
	            for dy = -extraRange, extraRange - 1, 1 do
                local loopPlot = Map.PlotXYWithRangeCheck(plot:GetX(), plot:GetY(), dx, dy, 3);
		        if loopPlot ~= nil then
				for iVal = 0,(loopPlot:GetNumUnits() - 1) do
				local loopUnit = loopPlot:GetUnit(iVal)
				if loopUnit:GetOwner() ~= iPlayer then
				if player:IsAtWarWith(loopUnit:GetOwner())  then					
				strikedamage=math.ceil(0.25*City:RangeCombatDamage(loopUnit, nil));
				loopUnit:ChangeDamage(strikedamage)
				                  end
							   end
							end
						end
					end
				end
			end
		end
     end

end
GameEvents.CityRangedStrike.Add(CityRangedStrikeDamage)



-- ****************************************
local woodunits = {};
function IsWoodUnit(unitID)
	for _, v in ipairs(woodunits) do
		if GameInfoTypes[v] == unitID then 
			return true;
		end
	end
	return false;
end

function Init()	
    for row in GameInfo.Unit_ResourceQuantityRequirements("ResourceType = 'RESOURCE_LUMBER'") do
		table.insert(woodunits, row.UnitType);
	end

end
--------------------------------------------------------------
Init();




function ExtraBattleCustomDamage(iBattleUnitType, iBattleType,
	iAttackPlayerID, iAttackUnitOrCityID, bAttackIsCity, iAttackDamage,
	iDefensePlayerID, iDefenseUnitOrCityID, bDefenseIsCity, iDefenseDamage,
	iInterceptorPlayerID, iInterceptorUnitOrCityID, bInterceptorIsCity, iInterceptorDamage)

	local additionalDamage = 0;

	local attPlayer = Players[iAttackPlayerID]
	local defPlayer = Players[iDefensePlayerID]
	if attPlayer == nil or defPlayer == nil then
		return 0
	end

	if iBattleUnitType == GameInfoTypes["BATTLEROLE_ATTACKER"] then
		if bAttackIsCity then
			return 0
		end

		if  bDefenseIsCity then
		return 0
		end

		local attUnit = attPlayer:GetUnitByID(iAttackUnitOrCityID)
	    local defUnit = defPlayer:GetUnitByID(iDefenseUnitOrCityID)

		if attUnit == nil then
			return 0
		end

		if defUnit == nil then
			return 0
		end
		local attUnitCombatType = attUnit:GetUnitCombatType() 

     

        if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_FIRE_WEAPON"].ID)  then 
        if IsWoodUnit(defUnit:GetUnitType())  then
		additionalDamage = additionalDamage+iDefenseDamage
           end
        end


		if attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_BURNING_BOMB"].ID) then
		
			 if not defUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_ANTI_DEBUFF"].ID)  then
			 local firedamage = math.max(15,math.floor(0.2*defUnit:GetCurrHitPoints())) 
			 additionalDamage = additionalDamage+firedamage  
			 end
			   
			 if defUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_FREEZE_EFFECT"].ID) then
				additionalDamage = additionalDamage+30
			end	 	
        end
		------------------------------------------------------------------------------------------
	end
	return additionalDamage
end
GameEvents.BattleCustomDamage.Add(ExtraBattleCustomDamage)