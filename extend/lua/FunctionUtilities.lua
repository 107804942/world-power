
include("FLuaVector.lua")

--Game.IsModActive
function Game.IsModActive(modID)
	for _, mod in pairs(Modding.GetActivatedMods()) do
			if mod.ID == modID then
			return true
		end
	end
	return false
end

--Game.IsWPActive
function Game.IsWPActive()
		return Game.IsModActive("41450919-c52c-406f-8752-5ea34be32b2d")
end

--Game.IsTNLActive
function Game.IsTNLActive()
		return Game.IsModActive("4e394966-aec9-4473-807f-0ddf8c1dddc1")
end

function PositionCalculator(i1, i2)
	return HexToWorld(ToHexFromGrid(Vector2(i1, i2)))
end


function IsNotEnemySpaceShipPlot(pUnit,plot)
        if plot == nil then
        return false
		end

		 for iVal = 0,(plot:GetNumUnits() - 1) do
	     local loopUnit = plot:GetUnit(iVal)
		 if  loopUnit:GetOwner() ~= pUnit:GetOwner() 
		 and Players[pUnit:GetOwner()]:IsAtWarWith(loopUnit:GetOwner())  then
	     if  loopUnit:IsHasPromotion(GameInfoTypes["PROMOTION_SPACESHIP"]) or 
		 loopUnit:IsHasPromotion(GameInfoTypes["PROMOTION_HOVER_WORM"]) then
		 return false
		   end
	    end
	end

  return true 
end

function IsSpaceShip(pUnit)
	     if  pUnit:IsHasPromotion(GameInfoTypes["PROMOTION_SPACESHIP"]) or 
		 pUnit:IsHasPromotion(GameInfoTypes["PROMOTION_HOVER_WORM"]) then
		 return true 
	end

  return false 
end

function GetPlotKey ( plot )                   ------获取地块的KEY
	-- set the key string used in cultureMap
	-- structure : g_CultureMap[plotKey] = { { ID = CIV_CULTURAL_ID, Value = cultureForThisCiv }, }
	local x = plot:GetX()
	local y = plot:GetY()
	local plotKey = x..","..y
	return plotKey
end

-- return the plot refered by the key string
function GetPlotFromKey ( plotKey )            -----从KEY获取地块
	local pos = string.find(plotKey, ",")
	local x = string.sub(plotKey, 1 , pos -1)
	local y = string.sub(plotKey, pos +1)
	local plot = Map:GetPlotXY(y,x)
	return plot
end

function GetPlotXYFromKey ( plotKey )     -------获取key对应XY
	local pos = string.find(plotKey, ",")
	local x = string.sub(plotKey, 1 , pos -1)
	local y = string.sub(plotKey, pos +1)
	return x, y
end

function isInArray(t, val)
	for _, v in pairs(t) do
		if v == val then
			return true
		end
	end
	return false
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               --function IsCityBordering(playerID, city)

function FranceCruiserMissionButtonValidity(unit)
local plot=unit:GetPlot()
local player=Players[unit:GetOwner()]  
		if  unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_FRANCE"].ID)
		and IsCoastalplot(plot) 
		and player:GetGold()>= player:GetCapitalCity():GetUnitPurchaseCost(GameInfo.Units.UNIT_MECHANIZED_INFANTRY.ID)  then
	    return true
		   end
		--end
	-- end
	return false
end

function IsCoastalplot(plot)
  if plot:GetTerrainType()== GameInfoTypes.TERRAIN_OCEAN or plot:GetTerrainType()==GameInfoTypes.TERRAIN_COAST then
  for i = 0, 5 do
			local adjPlot = Map.PlotDirection(plot:GetX(), plot:GetY(), i)
            if adjPlot:GetPlotType() == PlotTypes.PLOT_LAND or adjPlot:GetPlotType() == PlotTypes.PLOT_HILLS 
			--and (not adjPlot:IsMountain()) 
			-- and (not adjPlot:IsCity())
			  then
			  return true
		   end
		end
	end
	return false
end


function IsCanTransPortPlot(pSelUnit,pPlot)
   local possible=0
   local selUnitPlot = pSelUnit:GetPlot()
   local pPlayer=Players[pSelUnit:GetOwner()] 
   local distance = Map.PlotDistance(selUnitPlot:GetX(),selUnitPlot:GetY(),pPlot:GetX(),pPlot:GetY())

    if pSelUnit:GetMoves() ~= 0  then
	---------------------------------------------------------------------------------------------------------------------------------------
	if  pSelUnit:GetDomainType()==DomainTypes.DOMAIN_LAND then

	if  distance <= 20 and distance>0 and  pPlot:GetNumUnits() == 0 
	and (not pPlot:IsMountain())
	and (not pPlot:IsWater()) 
	and (not pPlot:IsCity()) 
	and ((pPlot:GetOwner()== -1) 
	or  (pPlot:GetOwner()~= -1 and   pPlayer== Players[pPlot:GetOwner()]) 
	or  (pPlot:GetOwner()~= -1 and   pPlayer~= Players[pPlot:GetOwner()]  and (not Players[pPlot:GetOwner()]:IsMajorCiv())) 
	or  (pPlot:GetOwner()~= -1 and   pPlayer~= Players[pPlot:GetOwner()]  and  Players[pPlot:GetOwner()]:IsMajorCiv() and pPlayer:IsAtWarWith(pPlot:GetOwner())
	or  (pPlot:GetOwner()~= -1 and   pPlayer~= Players[pPlot:GetOwner()]  and  Players[pPlot:GetOwner()]:IsMajorCiv() and Teams[pPlot:GetTeam()]:IsAllowsOpenBordersToTeam(pPlayer:GetTeam()) ))) then
	possible=possible+1 
	end
    if  pPlayer:GetNumSpies() >0  then
		for k, v in pairs(pPlayer:GetEspionageSpies()) do
	        local Plot = Map.GetPlot(v.CityX, v.CityY)
			if Plot~=nil then
				 for spyPlot in PlotAreaSpiralIterator(Plot, 3, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		         if  spyPlot:GetOwner()~= -1 and spyPlot:GetWorkingCity()~=nil and spyPlot:GetWorkingCity()==Plot:GetPlotCity() 
				 and spyPlot==pPlot
				 and (not spyPlot:IsMountain()) 
				 and (not spyPlot:IsWater()) 
				 and (not spyPlot:IsCity())  then
				 if pPlayer== Players[spyPlot:GetOwner()] 
				 or pPlayer:IsAtWarWith(spyPlot:GetOwner())
				 or (not Players[spyPlot:GetOwner()]:IsMajorCiv())
				 or (spyPlot:GetOwner()~= -1 and Players[spyPlot:GetOwner()]:IsMajorCiv() and Teams[spyPlot:GetTeam()]:IsAllowsOpenBordersToTeam(pPlayer:GetTeam())) 
				 then
				  possible=possible+1 
				               end
				            end 
				         end 
				      end  
			       end
			    end
			end
    ---------------------------------------------------------------------------------------------------------------------------------------    
	if  pSelUnit:GetDomainType()==DomainTypes.DOMAIN_SEA then

	if  distance <= 20 and distance>0 and  pPlot:GetNumUnits() == 0 
	and pPlot:IsWater() 
	and (not pPlot:IsCity()) 
	and ((pPlot:GetOwner()== -1) 
	or  (pPlot:GetOwner()~= -1 and   pPlayer== Players[pPlot:GetOwner()]) 
	or  (pPlot:GetOwner()~= -1 and   pPlayer~= Players[pPlot:GetOwner()]  and (not Players[pPlot:GetOwner()]:IsMajorCiv())) 
	or  (pPlot:GetOwner()~= -1 and   pPlayer~= Players[pPlot:GetOwner()]  and  Players[pPlot:GetOwner()]:IsMajorCiv() and pPlayer:IsAtWarWith(pPlot:GetOwner())
	or  (pPlot:GetOwner()~= -1 and   pPlayer~= Players[pPlot:GetOwner()]  and  Players[pPlot:GetOwner()]:IsMajorCiv() and Teams[pPlot:GetTeam()]:IsAllowsOpenBordersToTeam(pPlayer:GetTeam()) ))) then
	possible=possible+1 
	end
    if  pPlayer:GetNumSpies() >0  then
		for k, v in pairs(pPlayer:GetEspionageSpies()) do
	        local Plot = Map.GetPlot(v.CityX, v.CityY)
			if Plot~=nil then
				 for spyPlot in PlotAreaSpiralIterator(Plot, 3, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
		         if  spyPlot:GetOwner()~= -1 and spyPlot:GetWorkingCity()~=nil and spyPlot:GetWorkingCity()==Plot:GetPlotCity() 
				 and spyPlot==pPlot
				 and spyPlot:IsWater() 
				 and (not spyPlot:IsCity()) then
				 if pPlayer== Players[spyPlot:GetOwner()] 
				 or pPlayer:IsAtWarWith(spyPlot:GetOwner())  
				 or (not Players[spyPlot:GetOwner()]:IsMajorCiv())
				 or (spyPlot:GetOwner()~= -1 and Players[spyPlot:GetOwner()]:IsMajorCiv() and Teams[spyPlot:GetTeam()]:IsAllowsOpenBordersToTeam(pPlayer:GetTeam())) 
				 then
				  possible=possible+1 
				               end
				            end 
				         end 
				      end  
			       end
			    end
			end
	
		---------------------------------------------------------------------------------------------------------------------------------------
         end
		if possible == 0 then
		 return false
	else
		 return true
	  end
end








function maximum (a)
    local mi = 1             -- maximum index
    local m = a[mi]          -- maximum value
    for i,val in ipairs(a) do
       if val > m then
           mi = i
           m = val
       end
    end
    return m
end
--print(maximum({8,10,23,12,5}))     --> 23   3

-- ****************************************
-- 判断是否精英单位
-- ****************************************	
function IsEliteUnit(defUnit)
    local HurryCostMod =GameInfo.Units[defUnit:GetUnitType()].HurryCostModifier
	local Project =GameInfo.Units[defUnit:GetUnitType()].ProjectPrereq
    if  HurryCostMod == -1 
	and Project ~= nil 
	 then
        return true 
    else
        return false
    end
end


function isFriendlyCity(pUnit, pCity)
  local bFriendly = (pCity:GetTeam() == pUnit:GetTeam())
  bFriendly = (bFriendly and not pCity:IsPuppet())
  bFriendly = (bFriendly and not pCity:IsResistance())
  bFriendly = (bFriendly and not pCity:IsRazing())
  bFriendly = (bFriendly and not (pCity:IsOccupied() and not pCity:IsNoOccupiedUnhappiness()))
  return bFriendly
end

-- ****************************************
-- 可获得科技
-- ****************************************	
function CanAdvanceResearch(pPlayer, iTeamID, iTeam, iTeamTechs, iPlayerID)
if pPlayer and iTeamID and iTeam and iTeamTechs and iPlayerID then
		if pPlayer:IsMinorCiv() 
		or (pPlayer:GetHandicapType() == nil ) 
		or pPlayer:GetHandicapType() == -1 
		or not pPlayer
		or iTeam == nil 
		or iTeam == -1 
		or iTeamID == nil 
		or iTeamID == -1 
		or iTeamTechs == nil 
		or iTeamTechs == -1 
		or iPlayerID == nil 
		or iPlayerID == -1 
		or iPlayerID == 63
		or pPlayer:GetCurrentResearch() == nil 
		or pPlayer:GetCurrentResearch() == -1 
		or pPlayer:GetResearchProgress() == nil 
		or pPlayer:GetResearchProgress() == -1 then 
		return false 
		else 
		return true 
		end
	end
end

function ChangeResearchProcess(pPlayer, iTeamID, iTeam, iTeamTechs, iPlayerID, NumSciencePerTotal)
        if CanAdvanceResearch(pPlayer, iTeamID, iTeam, iTeamTechs, iPlayerID) then
		local iCanBeAdded = pPlayer:GetResearchCost(pPlayer:GetCurrentResearch()) - pPlayer:GetResearchProgress(pPlayer:GetCurrentResearch())
		if iCanBeAdded > NumSciencePerTotal then
		iTeamTechs:ChangeResearchProgress(pPlayer:GetCurrentResearch(),NumSciencePerTotal, iPlayerID)
		else
		iTeamTechs:ChangeResearchProgress(pPlayer:GetCurrentResearch(),iCanBeAdded, iPlayerID)
		pPlayer:ChangeOverflowResearch(NumSciencePerTotal-iCanBeAdded)
		   end
		end
		if not CanAdvanceResearch(pPlayer, iTeamID, iTeam, iTeamTechs, iPlayerID) then
		pPlayer:ChangeOverflowResearch(NumSciencePerTotal)
	    end

end



-- ****************************************
-- 随机数
-- ****************************************	
function ROG_GetTrueRandom(min, max)
local strTime=tostring(os.time())
local strRev=string.reverse(strTime)
local strRandomTime=string.sub(strRev,1,6)
math.randomseed(strRandomTime)
    return math.random(min, max)
end


function LocalizingRandom(lower, upper)
    return (Game.Rand((upper + 1) - lower, "")) + lower
end


function city_Random(city)
if Players[city:GetOwner()]:GetCurrentEra()<=GameInfoTypes.ERA_RENAISSANCE then 
	randomNum = ROG_GetTrueRandom(23,38)
    else 
	randomNum = ROG_GetTrueRandom(1,22)
	end 
    return randomNum
end
-- ****************************************
-- 独特单位
-- ****************************************	
function GetUnitReqiredResources(sKey)
	if IsUnitReqiredResources(sKey) == true then
	local i = nil	
		for row in GameInfo.Unit_ResourceQuantityRequirements() do
			if row.UnitType == sKey.Type then
				i = GameInfoTypes[row.ResourceType]
			else 
				i = i
			end
		end
		return i;
		
	else
		return nil;
	end
end


function GetNumUnitReqiredResources(sKey, Resource)
	local i = 0
	if IsUnitReqiredResources(sKey) == true then
		
		
		for row in GameInfo.Unit_ResourceQuantityRequirements() do
			if row.UnitType == sKey.Type and Resource == GameInfoTypes[row.ResourceType] then
				if row.Cost == nil then
				i = i + 1
				else
				i = i + row.Cost
				end
			else
				i = i
			end
		end

		return i;


	else
		return 0;
	end
end


function IsUnitReqiredResources(sKey)
	local i = 0
	for row in GameInfo.Unit_ResourceQuantityRequirements() do
		if row.UnitType == sKey.Type then
			i = i +1
		end
	end
	if i == 0 then
		return false
	else
		return true
		
	end
end



function GetUniqueFreeMeleeUnit(pPlayer, pPlot)
			local TeamID = pPlayer:GetTeam();
		    local pTeam = Teams[TeamID];
		    local pTeamTech = pTeam:GetTeamTechs();
			local basecombat =  GameInfo.Units{Type="UNIT_SPEARMAN"}().Combat  
			local UnitType =GameInfo.Units.UNIT_SPEARMAN.ID 
	
				for row in GameInfo.Units() do
					
				if GameInfoTypes[row.CombatClass] == GameInfoTypes["UNITCOMBAT_MELEE"]  then
						if row.PrereqTech == nil 
						--or pTeamTech:HasTech(GameInfoTypes[row.PrereqTech]) 
						or pPlayer:GetCurrentEra()==GameInfo.Eras[GameInfo.Technologies[row.PrereqTech].Era].ID
						then
						if  row.Combat >= basecombat and row.PolicyType == nil 
						and row.ProjectPrereq==nil and row.Cost~=-1 then
						UnitType =pPlayer:GetCivUnit(GameInfo.UnitClasses{Type=row.Class}().ID)					
					end
				end
			end
		end
		local freeUnit = pPlayer:InitUnit(UnitType, pPlot:GetX(), pPlot:GetY())
		freeUnit:ChangeExperience(60)
		freeUnit:SetPromotionReady(true)
end


-- ****************************************
-- 未来时代精英（幽灵除外）
-- ****************************************	
function IsHugeUnit(pUnit)

if pUnit:GetUnitType()==GameInfoTypes["UNIT_GHOST"] then
return false
end

if pUnit:GetUnitType()~=GameInfoTypes["UNIT_GHOST"]
and GameInfo.Units[pUnit:GetUnitType()].HurryCostModifier == -1
and GameInfo.Units[pUnit:GetUnitType()].ProjectPrereq ~= nil  
and GameInfo.UnitClasses[GameInfo.Units[pUnit:GetUnitType()].Class].MaxPlayerInstances ==1
and GameInfo.Eras[GameInfo.Technologies[GameInfo.Units[pUnit:GetUnitType()].PrereqTech].Era].ID == GameInfoTypes.ERA_FUTURE 
then
return true
end

return false
end



function IsEverEliteUnit(Unit)
    local elite =0
    local HurryCostMod =GameInfo.Units[Unit:GetUnitType()].HurryCostModifier
	local Project =GameInfo.Units[Unit:GetUnitType()].ProjectPrereq
    if  HurryCostMod == -1 and Project ~= nil then
	elite =elite+1
	    end
	if 	Unit:IsHasPromotion(GameInfoTypes["PROMOTION_ELITE_UNIT"]) then 
	elite =elite+1
	    end
       if elite > 0 then
		return true
	else
		return false
	end

end

-- ****************************************
-- 获取最近的城市
-- ****************************************	
function ROG_GetNearestCity(player, plotX, plotY)
	local iDistance = nil
	local pTargetCity = nil
	for city in player:Cities() do
		if not(iDistance) or iDistance > Map.PlotDistance(plotX, plotY, city:GetX(), city:GetY()) then
			pTargetCity = city
			iDistance = Map.PlotDistance(plotX, plotY, city:GetX(), city:GetY())
		end
	end
	return(pTargetCity)
end


-- ****************************************
-- 为西北风招募的单位设置晋升
-- ****************************************	
function SetAbilityForFranceMistralUnit(unit)
	            unit:SetHasPromotion(GameInfoTypes.PROMOTION_SHOCK_1, true)
			    unit:SetHasPromotion(GameInfoTypes.PROMOTION_SHOCK_2, true)
			    unit:SetHasPromotion(GameInfoTypes.PROMOTION_SHOCK_3, true)
			    unit:SetHasPromotion(GameInfoTypes.PROMOTION_COVER_1, true)
                unit:SetHasPromotion(GameInfoTypes.PROMOTION_COVER_2, true)
                unit:SetHasPromotion(GameInfoTypes.PROMOTION_COVER_3, true)
			    unit:SetHasPromotion(GameInfoTypes.PROMOTION_DRILL_1, true)
			    unit:SetHasPromotion(GameInfoTypes.PROMOTION_DRILL_2, true)
                unit:SetHasPromotion(GameInfoTypes.PROMOTION_DRILL_3, true)
			    unit:SetHasPromotion(GameInfoTypes.PROMOTION_SIEGE, true)
			    unit:SetHasPromotion(GameInfoTypes.PROMOTION_AMPHIBIOUS, true)
                unit:SetHasPromotion(GameInfoTypes.PROMOTION_BLITZ, true)
				unit:SetHasPromotion(GameInfoTypes.PROMOTION_MARCH, true)
				unit:SetHasPromotion(GameInfoTypes.PROMOTION_DESERT_EXTRA, true)
                unit:SetHasPromotion(GameInfoTypes.PROMOTION_JUNJLE_EXTRA, true)
				unit:SetHasPromotion(GameInfoTypes.PROMOTION_SNOW_EXTRA, true)
				unit:SetLevel(16)
				unit:ChangeExperience(1250)
				unit:SetPromotionReady(true)
end



function SetAbilityForFranceMistralUnit2(unit)
	            unit:SetHasPromotion(GameInfoTypes.PROMOTION_SHOCK_1, true)
			    unit:SetHasPromotion(GameInfoTypes.PROMOTION_SHOCK_2, true)
			    unit:SetHasPromotion(GameInfoTypes.PROMOTION_SHOCK_3, true)
			    unit:SetHasPromotion(GameInfoTypes.PROMOTION_COVER_1, true)
                unit:SetHasPromotion(GameInfoTypes.PROMOTION_COVER_2, true)
                unit:SetHasPromotion(GameInfoTypes.PROMOTION_COVER_3, true)
			    unit:SetHasPromotion(GameInfoTypes.PROMOTION_DRILL_1, true)
			    unit:SetHasPromotion(GameInfoTypes.PROMOTION_DRILL_2, true)
                unit:SetHasPromotion(GameInfoTypes.PROMOTION_DRILL_3, true)
			    unit:SetHasPromotion(GameInfoTypes.PROMOTION_SIEGE, true)
			    unit:SetHasPromotion(GameInfoTypes.PROMOTION_AMPHIBIOUS, true)
                unit:SetHasPromotion(GameInfoTypes.PROMOTION_BLITZ, true)
				unit:SetHasPromotion(GameInfoTypes.PROMOTION_MARCH, true)
				unit:SetHasPromotion(GameInfoTypes.PROMOTION_DESERT_EXTRA, true)
                unit:SetHasPromotion(GameInfoTypes.PROMOTION_JUNJLE_EXTRA, true)
				unit:SetHasPromotion(GameInfoTypes.PROMOTION_SNOW_EXTRA, true)

				unit:SetLevel(16)
				unit:ChangeExperience(1250)
				unit:SetPromotionReady(true)
end




function CheckPlagueMissionButtonValidity(unit)
local player=Players[unit:GetOwner()] 
local city = unit:GetPlot():GetPlotCity() or unit:GetPlot():GetWorkingCity()
        if  city~=nil and  Players[city:GetOwner()]:IsMajorCiv() then
		if  player:IsAtWarWith(city:GetOwner())  then
		if  unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_HOVER_WORM"].ID) then
	    return true
		   end
		end
	 end
	return false
end
		


	   
-- ****************************************
-- 主要宗教
-- ****************************************		 		   
function Rog_GetMajorReligion(pPlayer)
	local iReligion = nil
	if (pPlayer:HasCreatedReligion()) then
		iReligion = pPlayer:GetReligionCreatedByPlayer()
	else
		for pReligion in GameInfo.Religions() do
			if (pPlayer:HasReligionInMostCities(pReligion)) then
				iReligion = pReligion
				break
			end
		end
	end
	return iReligion
end		   
	
		   
-- 城市范围内有圣地设施
function CityHasHolySite(pCity)
      local check =0
	  local n = pCity:GetNumCityPlots() - 1
	  for i = 1, n, 1 do
		local plot = pCity:GetCityIndexPlot( i )
		if (plot ~= nil) then
		if (plot:GetImprovementType() ~= -1)
		and(plot:GetImprovementType() == GameInfoTypes["IMPROVEMENT_HOLY_SITE"]) then
             check=check+1
          end
       end
	end
	if check>0 then
	    return true
	else
		return false
	end
end	

-- 被封锁的地块数
function GetNumBlockadedPlots(city)
      local numBlockadedPlots = 0
	  local n = pCity:GetNumCityPlots() - 1
	  for i = 1, n, 1 do
		   for i = 0, city:GetNumCityPlots() - 1, 1 do
                  local plot = city:GetCityIndexPlot(i)
                  if plot:IsVisibleEnemyUnit(playerID) or city:IsPlotBlockaded(plot) then
                  numBlockadedPlots = numBlockadedPlots + 1
              end
           end
	   end
	return numBlockadedPlots
end	






------主力战斗单位
function IsMainCombatUnit(pUnit)
         if not pUnit:IsCombatUnit() then
         return false
		 end

		 if pUnit:IsCombatUnit() then 
		 if pUnit:GetUnitCombatType()==GameInfoTypes["UNITCOMBAT_RECON"] or
		    pUnit:IsHasPromotion(GameInfoTypes["PROMOTION_MILITIA_COMBAT"])  then
		    return false
		   end
	    end
  return true 
end





------天使机甲
function NotEnemyAngelPlot(pUnit,plot) 
 local NumEnemyAngel=0

 local ExtraRange = 20
 for dx = -ExtraRange, ExtraRange - 1, 1 do
 for dy = -ExtraRange, ExtraRange - 1, 1 do
 local adjPlot = Map.PlotXYWithRangeCheck(plot:GetX(),plot:GetY(), dx, dy,ExtraRange);
 if  adjPlot ~= nil  then
 for iVal = 0,(adjPlot:GetNumUnits() - 1) do
 local loopUnit = adjPlot:GetUnit(iVal)	
 if  loopUnit~=nil and loopUnit:GetOwner()~=pUnit:GetOwner() 
 and loopUnit:IsHasPromotion(GameInfoTypes["PROMOTION_INTERCEPTION_EXTREME"]) then
 if  Players[pUnit:GetOwner()]:IsAtWarWith(loopUnit:GetOwner())  then
 NumEnemyAngel = NumEnemyAngel + 1
			                 end
			              end
			           end
					end
				end
			end
 if NumEnemyAngel == 0 then
		return true 
	else
		return false
	end
end



function GetBonusEffect(Unit)
      local tUnits  ={}
      local iTileRadius = GameDefines["GREAT_GENERAL_MAX_RANGE"]
      for iShiftX = -iTileRadius, iTileRadius do
	  for iShiftY = -iTileRadius, iTileRadius do
	  local pTargetPlot = Map.PlotXYWithRangeCheck(Unit:GetX(), Unit:GetY(), iShiftX, iShiftY, iTileRadius)
      if pTargetPlot ~= nil  then
      unitCount = pTargetPlot:GetNumUnits()
      if unitCount > 0 then
      for i = 0, unitCount-1, 1 do
      local pFoundUnit = pTargetPlot:GetUnit(i)
      if pFoundUnit:GetOwner()==Unit:GetOwner() and pFoundUnit:GetDomainType()== Unit:GetDomainType() then
	  if Map.PlotDistance(pFoundUnit:GetX(), pFoundUnit:GetY(), Unit:GetX(), Unit:GetY()) <= GameDefines["GREAT_GENERAL_RANGE"] + pFoundUnit:GetAuraRange() then
	  table.insert(tUnits, {AuraEffectChange=pFoundUnit:GetAuraEffect(), Unit=pFoundUnit})
	                    end
	                 end
	              end
	           end
	        end
	     end
	  end
	  if #tUnits > 0 then
	  table.sort(tUnits, function(x,y) return (x.AuraEffectChange > y.AuraEffectChange) end)
	  end
	  return  tUnits[1].AuraEffectChange 	     
end







                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           