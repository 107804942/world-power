
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



local insert			= table.insert 
local concat			= table.concat
local ceil				= math.ceil
local floor				= math.floor
local condition			= "YieldType = 'YIELD_CRIME'"
local mathMax		 = math.max
local mathMin		 = math.min
