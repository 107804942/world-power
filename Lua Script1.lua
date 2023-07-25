-- Lua Script1
-- Author: 11585
-- DateCreated: 2023/7/26 0:13:52
--------------------------------------------------------------

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
