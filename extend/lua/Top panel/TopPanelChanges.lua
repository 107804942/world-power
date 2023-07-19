
-- SCIENCE: adds the name of currently researched technology and number of turns for it to be discovered
function UpdateScienceData(strScienceText)
	local pPlayer = Players[Game.GetActivePlayer()];
	local pTeam = Teams[pPlayer:GetTeam()];
	local pTeamTechs = pTeam:GetTeamTechs();
	local eCurrentTech = pPlayer:GetCurrentResearch();
	local eRecentTech = pTeamTechs:GetLastTechAcquired();
	local eTechTurnsLeft = 0;
	local eTechName = "";
	local strText = "";

	if (eCurrentTech ~= -1) then
		eTechName = Locale.ConvertTextKey(GameInfo.Technologies[eCurrentTech].Description);
		eTechTurnsLeft = pPlayer:GetResearchTurnsLeft(eCurrentTech, true);
		strText = eTechName .. string.format(" (%i) ", eTechTurnsLeft);
	else
		eTechName = Locale.ConvertTextKey(GameInfo.Technologies[eRecentTech].Description);
		TechTurnsLeft = 0;
		strText = eTechName .. string.format(" (%i) ", eTechTurnsLeft);
	end

	strText = "[COLOR:33:190:247:255]" .. strText .. "[/COLOR]" .. strScienceText;
	return strText
end

