
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


