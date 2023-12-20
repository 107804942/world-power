
Controls.OK:RegisterCallback(Mouse.eLClick, function() 
	Events.AudioDebugChangeMusic(true,false,false);
	--print("Music changer: current song skipped")
end);

Controls.OK:RegisterCallback(Mouse.eRClick, function() 
	local select = Controls.Select
	select:SetHide(false)
end);


--[[Controls.CLEAR:RegisterCallback(Mouse.eLClick, function() 
	for i = 0, GameDefines.MAX_CIV_PLAYERS- 1 do

	      if   Players[i]:IsAlive()
		  and  Players[i]~= Players[Game.GetActivePlayer()]   then 
		  --for Unit in Players[i]:Units() do
		  --Unit:Kill(true, -1)
		  Players[i]:KillUnits();
		  --pPlayer:KillCities();
		  --end
		  end
		  end
end);

Controls.CLEAR:RegisterCallback(Mouse.eRClick, function() 
	local select = Controls.Select
	select:SetHide(false)
end);]]