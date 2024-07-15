
--------------------------------------------------------------------
---对单位造成伤害
function DiseaseUnits(city)
	local iX=city:GetX()
	local iY=city:GetY()
	   	local extraRange = 2	
	    for dx = -extraRange, extraRange - 1, 1 do
	    for dy = -extraRange, extraRange - 1, 1 do
        local adjPlot = Map.PlotXYWithRangeCheck(iX, iY, dx, dy, 1);
		if adjPlot ~= nil then
		local unitCount = adjPlot:GetNumUnits();
        if unitCount > 0 then
		for i = 0, unitCount-1, 1 do
        local pFoundUnit = adjPlot:GetUnit(i);
		if  pFoundUnit~=nil 
		and not pFoundUnit:IsPlagueImmune() then
		          pFoundUnit:ChangeDamage(50)  
		          pFoundUnit:SetHasPromotion(GameInfoTypes.PROMOTION_PLAGUED, true) 
				  end
			   end
			end
	     end
      end
   end
end

function CitySetDoctor(iPlayer)
    local player = Players[iPlayer]
	if player == nil or player:IsMinorCiv() or player:IsBarbarian() or player:IsHuman() or not player:IsAlive() 
	then return end

	local plaguecityTAB ={}
	local DoctorTAB ={}	
	local GreatDoctorTAB ={}	
	------Auto add doctor to cure
	for city in player:Cities() do		
	if  city:HasPlague()  then 
	table.insert(plaguecityTAB, city)
		end
	end
	for unit in player:Units() do	
	if  unit:GetUnitType() ==GameInfoTypes["UNIT_DOCTOR"] then 
	table.insert(DoctorTAB, unit)
	   end
	end
	for unit in player:Units() do	 
	if  unit:GetUnitClassType() == GameInfoTypes["UNITCLASS_GREAT_DOCTOR"] then 
	table.insert(GreatDoctorTAB, unit)
		end
	end
	---------------------------------------------区分不同情况----------------------------------
	if  #plaguecityTAB > 0 then  

	if  #DoctorTAB > 0  then 
	    if  #GreatDoctorTAB == 0 then  
		local randomNumber  = ROG_GetTrueRandom(1,#plaguecityTAB)
		local randomNumber2 = ROG_GetTrueRandom(1,#DoctorTAB)
		local tCITY = plaguecityTAB[randomNumber]
		local tUNIT = DoctorTAB[randomNumber2]
		PlagueEnds(tCITY) 
		tUNIT:Kill()
		 print (" doctor cure health for ai !")
		 else  
		 local randomNumber3 =  ROG_GetTrueRandom(1,#GreatDoctorTAB)
		 local tUNIT2 = GreatDoctorTAB[randomNumber3]
		 GREAT_DOCTOR_CURE_Mission(iPlayer, tUNIT2)
		 print ("great doctor cure health for ai !")
		 end
	 end

	 if  #DoctorTAB == 0 then  
	     if  #GreatDoctorTAB > 0  then 
		 local randomNumber4 = ROG_GetTrueRandom(1,#GreatDoctorTAB)  	 
		 local tUNIT3 = GreatDoctorTAB[randomNumber4]
		 GREAT_DOCTOR_CURE_Mission(iPlayer, tUNIT3)
		 print ("great doctor cure health for ai !")
		 end
	 end
	
	 else  
	 if  #GreatDoctorTAB > 0  then   
	 local randomNumber5 = ROG_GetTrueRandom(1,#GreatDoctorTAB) 
	 local tUNIT4 = GreatDoctorTAB[randomNumber5]
	 local city = tUNIT4:GetPlot():GetPlotCity() or tUNIT4:GetPlot():GetWorkingCity();
	 if city~=nil 
	 and city:GetOwner()==iPlayer 
	 and not city:IsHasBuilding(GameInfoTypes.BUILDING_LOCAL_HOSPITAL) then 
	 city:SetNumRealBuilding(GameInfoTypes["BUILDING_LOCAL_HOSPITAL"], 1)
	 tUNIT4:Kill() 
	    end
	 end
	     
	end
end
GameEvents.PlayerDoneTurn.Add(CitySetDoctor)

local insert			= table.insert 
local concat			= table.concat
local ceil				= math.ceil
local floor				= math.floor
local condition			= "YieldType = 'YIELD_CRIME'"
local mathMax		 = math.max
local mathMin		 = math.min



int CvLuaCity::lIsResistance(lua_State* L)
{
	return BasicLuaMethod(L, &CvCity::IsResistance);
}
//int GetResistanceTurns();
int CvLuaCity::lGetResistanceTurns(lua_State* L)
{
	return BasicLuaMethod(L, &CvCity::GetResistanceTurns);
}
//int ChangeResistanceTurns();
int CvLuaCity::lChangeResistanceTurns(lua_State* L)
{
	return BasicLuaMethod(L, &CvCity::ChangeResistanceTurns);
}