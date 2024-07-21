include("Crime_UI.lua");
include("FLuaVector" );
include("FunctionUtilities.lua");
include("PlotIterators.lua");
include("Rog_SaveUtils.lua"); MY_MOD_NAME = "世界强权";
--------------------------------------------------------------------

local EraEnemyUnits = {[0] = GameInfoTypes.UNIT_SPEARMAN,[1] = GameInfoTypes.UNIT_SWORDSMAN,[2] = GameInfoTypes.UNIT_LONGSWORDSMAN, [3] = GameInfoTypes.UNIT_MUSKETMAN, 
[4] = GameInfoTypes.UNIT_RIFLEMAN, [5] = GameInfoTypes.UNIT_GREAT_WAR_INFANTRY, [6] = GameInfoTypes.UNIT_INFANTRY
 ,[7] = GameInfoTypes.UNIT_MOTORISED_INFANTRY,[8] = GameInfoTypes.UNIT_MECHANIZED_INFANTRY,[9] = GameInfoTypes.UNIT_AEGIS};

--crime_PlayerDoTurn
function Crime_PlayerDoTurn(playerID)
	local player = Players[playerID]
	local era = player:GetCurrentEra()
	local unitType = EraEnemyUnits[era]
	local EnemyTAB ={}	
	if (not player:IsAlive()) then return end
	if (not player:IsMajorCiv())  then return end 
	for city in player:Cities() do
	    city:SetYieldModifierFromCrime(GameInfoTypes["YIELD_PRODUCTION"], 0)
		local totalCrime = city:GetYieldRate(GameInfoTypes["YIELD_CRIME"])	
		local CrimeCounter, CrimeThreshold, CrimeTurns = player:GetCityCrimeCounterDetails(city, true, true)
		local CrimeMod = city:GetYieldRateModifier(GameInfoTypes["YIELD_PRODUCTION"])

		--------------------------------------------------------------------
	    if totalCrime < 0 then    ----犯罪率优秀
				if CrimeCounter > 0 then     
				    if CrimeCounter> -totalCrime then
					city:ChangeResistanceCounter(totalCrime) 
					else 
					city:SetResistanceCounter(0) 
				    end
                end 

	    else       ----犯罪率糟糕

	            if totalCrime>35 then

				if CrimeMod>0 then
				city:SetYieldModifierFromCrime(GameInfoTypes["YIELD_PRODUCTION"], -CrimeMod*0.25)
				else
				city:SetYieldModifierFromCrime(GameInfoTypes["YIELD_PRODUCTION"], -25)
				end

				local CheckNumber = LocalizingRandom(0, 100)
				if CheckNumber<50 then
	            local enemy = Players[63]:InitUnit(unitType, city:GetX()+1, city:GetY())
				local enemy2 = Players[63]:InitUnit(unitType, city:GetX()+1, city:GetY())
				local enemy3 = Players[63]:InitUnit(unitType, city:GetX()+1, city:GetY())
			    enemy:JumpToNearestValidPlot()
				--enemy:SetLevel(7)
				enemy2:JumpToNearestValidPlot()
				--enemy2:SetLevel(7)
				enemy3:JumpToNearestValidPlot()
				--enemy3:SetLevel(7)
	               end
				end

				if totalCrime>70 then

				if CrimeMod>0 then
				city:SetYieldModifierFromCrime(GameInfoTypes["YIELD_PRODUCTION"], -CrimeMod*0.5)
				else
				city:SetYieldModifierFromCrime(GameInfoTypes["YIELD_PRODUCTION"], -33)
				end

				local CheckNumber2 = LocalizingRandom(0, 100)
				if CheckNumber2>75 then
				if not city:IsResistance() then
				      city:ChangeResistanceTurns(4)
					  end
	               end
				end

				city:ChangeResistanceCounter(totalCrime)
				CrimeCounter, CrimeThreshold, CrimeTurns = player:GetCityCrimeCounterDetails(city, true, true)


				if CrimeCounter >= CrimeThreshold then 
					city:SetResistanceCounter(0)
		
					---加入叛变效果
					for loopPlot in PlotAreaSpiralIterator(city:Plot(), 10, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
					if loopPlot:IsCity() and  loopPlot:GetPlotCity()~=city then
					local loopCity=loopPlot:GetPlotCity()
					local otherPlayer=Players[loopCity:GetOwner()]
					if otherPlayer~=player and otherPlayer:IsMajorCiv() and player:IsAtWarWith(loopCity:GetOwner()) then
				
					table.insert(EnemyTAB, otherPlayer)
					      end
					   end
					end

					if not city:IsCapital() then 
					if not city:IsOriginalCapital()  then

					 if  #EnemyTAB > 0  then
						local randomNumber  = ROG_GetTrueRandom(1,#EnemyTAB)
		                local tPlayer = EnemyTAB[randomNumber]
						tPlayer:AcquireCity(city)
					 else
					     Players[63]:AcquireCity(city)
					 end
	              end
			   end
			end
		end


	end
end
GameEvents.PlayerDoTurn.Add(Crime_PlayerDoTurn)







	