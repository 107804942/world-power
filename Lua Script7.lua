

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


