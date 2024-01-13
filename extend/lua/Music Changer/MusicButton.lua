
Controls.OK:RegisterCallback(Mouse.eLClick, function() 
	Events.AudioDebugChangeMusic(true,false,false);
	--print("Music changer: current song skipped")
end);

Controls.OK:RegisterCallback(Mouse.eRClick, function() 
	local select = Controls.Select
	select:SetHide(false)
end);


Controls.CLEAR:RegisterCallback(Mouse.eLClick, function() 
	for i = 0, GameDefines.MAX_CIV_PLAYERS- 1 do

	      if   Players[i]:IsAlive()
		  and  Players[i]~= Players[Game.GetActivePlayer()]   then 
		  Players[i]:KillUnits();
		  end
		  end
end);

Controls.CLEAR:RegisterCallback(Mouse.eRClick, function() 
	local select = Controls.Select
	select:SetHide(false)
end);