include("PlotIterators.lua")
include("FunctionUtilities.lua")
include("Rog_SaveUtils.lua"); MY_MOD_NAME = "世界强权";
--------------------------------------------------------------
local g_VolcanoEvents = 
	{[0] = "TXT_KEY_VOLCANO_EVENT_1",   
	 [1] = "TXT_KEY_VOLCANO_EVENT_2", 
	 [2] = "TXT_KEY_VOLCANO_EVENT_3"}

local VolcanoPlots ={}

function Volcano()
	local turn =Game.GetGameTurn()
	for i=#VolcanoPlots,1,-1 do
    if VolcanoPlots[i] ~= nil then
        table.remove(VolcanoPlots, i)
        end
    end
	for iPlot = 0, Map.GetNumPlots() - 1 do
		local plot = Map.GetPlotByIndex(iPlot);
		if plot:GetFeatureType()==GameInfoTypes.FEATURE_NEW_VOLCANO
		then
		   table.insert(VolcanoPlots, plot)
		end
	end
end
Events.LoadScreenClose.Add(Volcano)

--------------------------------------------------------------
--Events
--------------------------------------------------------------
 function DoSmallVolcanoEvent(plot)
      local iTileRadius=2
      for iShiftX = -iTileRadius, iTileRadius do
	  for iShiftY = -iTileRadius, iTileRadius do
	  local pTargetPlot = Map.PlotXYWithRangeCheck(plot:GetX(), plot:GetY(), iShiftX, iShiftY, 1)
      if pTargetPlot ~= nil then
	  Game.SetPlotExtraYield(pTargetPlot:GetX(), pTargetPlot:GetY(), GameInfoTypes.YIELD_FOOD, 1)

	  if pTargetPlot:GetImprovementType()~=nil 
	  and not pTargetPlot:IsCity() then
	  pTargetPlot:SetImprovementPillaged(true)
	  end

	  local unitCount = pTargetPlot:GetNumUnits()
      if unitCount > 0 then
      for i = 0, unitCount-1, 1 do
      local pFoundUnit = pTargetPlot:GetUnit(i)
	  if not IsSpaceShip(pFoundUnit) then
	  pFoundUnit:ChangeDamage(50)
	                end
	             end
	         end
	      end
	   end
	end		  
end


 function DoLargeVolcanoEvent(plot)
      local iTileRadius=2
      for iShiftX = -iTileRadius, iTileRadius do
	  for iShiftY = -iTileRadius, iTileRadius do
	  local pTargetPlot = Map.PlotXYWithRangeCheck(plot:GetX(), plot:GetY(), iShiftX, iShiftY, 2)
      if pTargetPlot ~= nil then

	  Game.SetPlotExtraYield(pTargetPlot:GetX(), pTargetPlot:GetY(), GameInfoTypes.YIELD_FOOD, 1)
	  Game.SetPlotExtraYield(pTargetPlot:GetX(), pTargetPlot:GetY(), GameInfoTypes.YIELD_PRODUCTION, 1)
	
	  if pTargetPlot:GetImprovementType()~=nil 
	  and not pTargetPlot:IsCity() then
	  pTargetPlot:SetImprovementPillaged(true)
	  end

	  if pTargetPlot:IsCity() then
	  local city =pTargetPlot:GetPlotCity()
	  city:ChangeDamage(0.25*city:GetMaxHitPoints())
	  end

	  local unitCount = pTargetPlot:GetNumUnits()
      if unitCount > 0 then
      for i = 0, unitCount-1, 1 do
      local pFoundUnit = pTargetPlot:GetUnit(i)
	  if not IsSpaceShip(pFoundUnit) then
	  pFoundUnit:ChangeDamage(99)
	                end
	             end
	         end
	      end
	   end
	end		  
end



 function DoSuperVolcanoEvent(plot)
      local iTileRadius=3
      for iShiftX = -iTileRadius, iTileRadius do
	  for iShiftY = -iTileRadius, iTileRadius do
	  local pTargetPlot = Map.PlotXYWithRangeCheck(plot:GetX(), plot:GetY(), iShiftX, iShiftY, 3)
      if pTargetPlot ~= nil then

	  Game.SetPlotExtraYield(pTargetPlot:GetX(), pTargetPlot:GetY(), GameInfoTypes.YIELD_FOOD,2)
	  Game.SetPlotExtraYield(pTargetPlot:GetX(), pTargetPlot:GetY(), GameInfoTypes.YIELD_PRODUCTION, 2)
	  Game.SetPlotExtraYield(pTargetPlot:GetX(), pTargetPlot:GetY(), GameInfoTypes.YIELD_GOLD, 2)	

	  if pTargetPlot:GetImprovementType()~=nil 
	  and not pTargetPlot:IsCity() then
	  pTargetPlot:SetImprovementType(-1)
	  end

	  if pTargetPlot:IsCity() then
	  local city =pTargetPlot:GetPlotCity()
	  city:ChangeDamage(0.80*city:GetMaxHitPoints())
	  end

	  local unitCount = pTargetPlot:GetNumUnits()
      if unitCount > 0 then
      for i = 0, unitCount-1, 1 do
      local pFoundUnit = pTargetPlot:GetUnit(i)
	  if not IsSpaceShip(pFoundUnit) then
	  pFoundUnit:Kill()
	                end
	             end
	         end
	      end
	   end
	end		  
end


function DoVolcanoEvent(iPlayer)
    local player = Players[iPlayer]
	if player == nil
	or Game.GetGameTurn()<6 
	or (not player:IsHuman()) 
	then return end
	local targetVolcano = {}
	if #VolcanoPlots > 0 then
	for i = 1, #VolcanoPlots do
	local v = VolcanoPlots[i]
	if v:GetFeatureType()==GameInfoTypes.FEATURE_NEW_VOLCANO then
	if load(v, "DoOutBreakTurn")==nil 
	or (load(v, "DoOutBreakTurn")~=nil and ( Game.GetGameTurn() -load(v, "DoOutBreakTurn") ) >= 10) then 
	table.insert(targetVolcano, v)
	         end
	      end
	   end
	end
	if #targetVolcano > 0 then

	local randomNumber = LocalizingRandom(1, #targetVolcano)
	local tPlot = targetVolcano[randomNumber]
	local iVolcanoEvent = ROG_GetTrueRandom(1,1000)
	local i=3

	if iVolcanoEvent<=30 then
	DoSmallVolcanoEvent(tPlot)
	i=0

	elseif
	iVolcanoEvent>300 and iVolcanoEvent<320 then
	DoLargeVolcanoEvent(tPlot)
	i=1
	
	elseif iVolcanoEvent>=990 then
	DoSuperVolcanoEvent(tPlot)
	i=2
	end

	save(tPlot, "DoOutBreakTurn",Game.GetGameTurn())
	print("DoVolcanoEvent", Game.GetGameTurn())


	-- Notification
	if i~=3 then
	local x, y = -1, -1
	local heading = Locale.ConvertTextKey("TXT_KEY_VOLCAN_EVENT_TITLE")
	local text = Locale.ConvertTextKey(g_VolcanoEvents[i])			
    if tPlot:IsRevealed(Game.GetActiveTeam(), false) then
	x, y = tPlot:GetX(), tPlot:GetY()	
	end
    Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, text, heading, x, y); 
	    end				    
	end			
end
GameEvents.PlayerDoTurn.Add(DoVolcanoEvent)






