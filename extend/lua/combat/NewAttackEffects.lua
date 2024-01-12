include("FLuaVector.lua")
include("PlotIterators.lua")
include("FunctionUtilities.lua")
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
	  local pTargetPlot = Map.PlotXYWithRangeCheck(plotX, plotY, iShiftX, iShiftY, 1)
      if pTargetPlot ~= nil then
      local unitCount = pTargetPlot:GetNumUnits()
      if unitCount > 0 then
      for i = 0, unitCount-1, 1 do
      local pFoundUnit = pTargetPlot:GetUnit(i)
	  if pFoundUnit:GetDomainType() == DomainTypes.DOMAIN_LAND or pFoundUnit:GetDomainType() == DomainTypes.DOMAIN_SEA  then
	  if not pFoundUnit:IsImmuneNegtivePromotions() then 
	  if attPlayer:IsAtWarWith(pFoundUnit:GetOwner())  then 
	  pFoundUnit:SetHasPromotion(GameInfo.UnitPromotions["PROMOTION_BURNING_EFFECT"].ID, true)		
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
	--if defCity then
	
-- ********************************************************
-- 负面buff
-- ********************************************************   
    -- Debuff immune unit
	if defUnit then

-- ********************************************************
-- 铁浮图
-- ********************************************************
   if attUnit and defUnit:IsDead() then
      local iTileRadius = 5
      for iShiftX = -iTileRadius, iTileRadius do
	  for iShiftY = -iTileRadius, iTileRadius do
	  local pTargetPlot = Map.PlotXYWithRangeCheck(defPlot:GetX(), defPlot:GetY(), iShiftX, iShiftY, iTileRadius)
      if pTargetPlot ~= nil  then
      unitCount = pTargetPlot:GetNumUnits()
      if unitCount > 0 then
      for i = 0, unitCount-1, 1 do
      local pFoundUnit = pTargetPlot:GetUnit(i)
      if  pFoundUnit:IsHasPromotion(GameInfoTypes.PROMOTION_ANTI_ANTI_MOUNTED_BONUS)  
	  and pFoundUnit:GetMoves() < 6*GameDefines["MOVE_DENOMINATOR"]   then
	  pFoundUnit:SetMoves(math.floor(pFoundUnit:MovesLeft() +GameDefines["MOVE_DENOMINATOR"]))
	  print("Unit Near IronBeddha Killed!")
		             end
			      end
			   end
		    end
	     end  		 
      end
   end

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
-- 突击虎无限次远程火力支援
-- ******************************************************** 
if attUnit:GetDomainType() == DomainTypes.DOMAIN_LAND then
if not attUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_STURMTIGER"].ID)  then 

if  batType == GameInfoTypes["BATTLETYPE_MELEE"] 
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
                        if pFoundUnit~=attUnit and pFoundUnit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_STURMTIGER"].ID)  
						and  Players[pFoundUnit:GetOwner()] == attPlayer 
						and Map.PlotDistance(pFoundUnit:GetX(), pFoundUnit:GetY(), defUnit:GetX(), defUnit:GetY()) <= pFoundUnit:Range() then

						pFoundUnit:ChangeMoves(GameDefines["MOVE_DENOMINATOR"])

						if  pFoundUnit:GetNumAttacksMadeThisTurn()==0 then  
						    if 	pFoundUnit:CanRangeStrikeAt(defPlot:GetX(), defPlot:GetY()) then	  
						    pFoundUnit:RangeStrike(defPlot:GetX(), defPlot:GetY())
							pFoundUnit:ChangeMadeAttackNum(-1)
							else 
							pFoundUnit:ChangeMoves(-GameDefines["MOVE_DENOMINATOR"])
							end
				        else   
						
						    pFoundUnit:ChangeMadeAttackNum(-1)
						    if 	pFoundUnit:CanRangeStrikeAt(defPlot:GetX(), defPlot:GetY()) then				    	  
						    pFoundUnit:RangeStrike(defPlot:GetX(), defPlot:GetY())
						    else 
						    pFoundUnit:ChangeMoves(-GameDefines["MOVE_DENOMINATOR"])
							pFoundUnit:ChangeMadeAttackNum(1) 
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
GameEvents.BattleFinished.Add(ExtraAttackEffectEffect)




