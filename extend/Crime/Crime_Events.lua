include("Crime_UI.lua");
include("FLuaVector" );
include("FunctionUtilities.lua");
include("Rog_SaveUtils.lua"); MY_MOD_NAME = "世界强权";
--------------------------------------------------------------------
function GetNumCrime (num)
    local e=log(num, 1.2)  
	if ( e>21 and e<25)  then
	e= 50
	elseif (e>25 and e<29)  then
	e= 65
	elseif e>30 then
	e= 90
	end
	return e
end

--crime_PlayerDoTurn
function Crime_PlayerDoTurn(playerID)
	local player = Players[playerID]
	if (not player:IsAlive()) then return end
	if (not player:IsMajorCiv())  then return end 
	for city in player:Cities() do
		local totalCrime = city:GetYieldRate(GameInfoTypes["YIELD_CRIME"])
		city:SetYieldFromCrime(GameInfoTypes["YIELD_SCIENCE"], 0)
		city:SetYieldModifierFromCrime(GameInfoTypes["YIELD_SCIENCE"], 0)
		city:SetYieldFromCrime(GameInfoTypes["YIELD_PRODUCTION"], 0)
		city:SetYieldModifierFromCrime(GameInfoTypes["YIELD_PRODUCTION"],0)
		--if (not city:IsResistance()) then  
		if totalCrime>0 then  
	    local buff = GetNumCrime (totalCrime)
		city:SetYieldFromCrime(GameInfoTypes["YIELD_SCIENCE"], -buff)
		city:SetYieldModifierFromCrime(GameInfoTypes["YIELD_SCIENCE"],-buff)
		city:SetYieldFromCrime(GameInfoTypes["YIELD_PRODUCTION"], -buff)
		city:SetYieldModifierFromCrime(GameInfoTypes["YIELD_PRODUCTION"],-buff)
		end
	end
end
GameEvents.PlayerDoTurn.Add(Crime_PlayerDoTurn)







	