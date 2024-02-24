include("Crime_UI.lua");
include("FLuaVector" );
include("FunctionUtilities.lua");
include("Rog_SaveUtils.lua"); MY_MOD_NAME = "世界强权";
--------------------------------------------------------------------
--crime_PlayerDoTurn
function Crime_PlayerDoTurn(playerID)
	local player = Players[playerID]
	if (not player:IsAlive()) then return end
	if (not player:IsMajorCiv())  then return end 
	for city in player:Cities() do
		local totalCrime = city:GetYieldRate(GameInfoTypes["YIELD_CRIME"])
		city:SetYieldFromCrime(GameInfoTypes["YIELD_PRODUCTION"], 0)
		city:SetYieldModifierFromCrime(GameInfoTypes["YIELD_PRODUCTION"],0)
		--if (not city:IsResistance()) then  
		if totalCrime>0 then  
		city:SetYieldFromCrime(GameInfoTypes["YIELD_PRODUCTION"], -totalCrime)
		city:SetYieldModifierFromCrime(GameInfoTypes["YIELD_PRODUCTION"],-totalCrime)
		end
	end
end
--GameEvents.PlayerDoTurn.Add(Crime_PlayerDoTurn)







	