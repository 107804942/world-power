--=======================================================================================================================
-- Modified from NewSaveUtils.lua
--=======================================================================================================================
--=======================================================================================================================
if not MapModData.Sukritact_SaveUtils_V2_Activated then
	MapModData.Sukritact_SaveUtils_V2_Activated = true
	MapModData.Sukritact_SaveUtils_V2 = {}
	Events.SequenceGameInitComplete.Add(function() MapModData.Sukritact_SaveUtils_V2_Activated = nil end)
end
--=======================================================================================================================
gbLogSaveData = false;

-- Connection to the Modding save data.  Keep one global connection, rather than opening/closing, to speed up access
g_SaveData = Modding.OpenSaveData();
g_Properties = MapModData.Sukritact_SaveUtils_V2;
if not(Suk_SaveUtils_IsGlobal) then g_Properties = nil end
-------------------------------------------------------------- 
-- Access the modding database entries through a locally cached table
function GetPersistentProperty(name)
	if(g_Properties == nil) then
		g_Properties = {};
	end
	
	if(g_Properties[name] == nil) then
		g_Properties[name] = g_SaveData.GetValue(name);
	end
	
	return g_Properties[name];
end
--------------------------------------------------------------
-- Access the modding database entries through a locally cached table
function SetPersistentProperty(name, value)
	if(g_Properties == nil) then
		g_Properties = {};
	end
	
	if (g_Properties[name] ~= value) then
		g_SaveData.SetValue(name, value);
		g_Properties[name] = value;
	end
end
--=======================================================================================================================
-- Utility Functions
--=======================================================================================================================
function InitializeInstances()
	--print(Player)
	--print(Player)
	--print(Team)
	--print(Team)
	--print(Plot)
	local pPlot = Map.GetPlotByIndex(0)
	--print(Plot)
	--print(Unit)
	local pPlayer = Players[0]
	for pUnit in pPlayer:Units() do
		break
	end

	for pCity in pPlayer:Cities() do
		break
	end	
	--print(Unit)
end
InitializeInstances()

function InitCities(iPlayer, iX, iY)
	local pPlot = Map.GetPlot(iX, iY)
	local pCity = pPlot:GetPlotCity()
	--GameEvents.PlayerCityFounded.Remove(InitCities)
end
if not City then
	GameEvents.PlayerCityFounded.Add(InitCities)	
end

function CompileUnitID(pUnit)
	local iOwner = pUnit:GetOwner()
	local iUnit = pUnit:GetID()
	local iTurn = pUnit:GetGameTurnCreated()
	return(iOwner .. "_ID" .. iUnit .. "_T" .. iTurn)
end

function CompilePlotID(pPlot)
	local iX = pPlot:GetX()
	local iY = pPlot:GetY()
	return(iX .. "_Y" .. iY)
end

function CompileCityID(pCity)
	local iX = pCity:GetX()
	local iY = pCity:GetY()
	local iTurn = pCity:GetGameTurnFounded()
	return(iX .. "Y" .. iY .. "T" .. iTurn)
end
--=======================================================================================================================
-- Save/Load Functions
--=======================================================================================================================
function save(pObject, sKey, Val)
	
	--Booleans must be converted to strings
	if Val == true then
		Val = "bTrue"
	elseif Val == false then
		Val = "bFalse"
	end
	
	local sTrueKey = nil
	--if pObject == "GAME" or variants save without other ID
	if (type(pObject) == "string") then
		if string.upper(pObject) == "GAME" then
			sTrueKey = (MY_MOD_NAME .. "_" .. sKey)
		else
			--print("Error on Save: Invalid type")
			return
		end
	--Else ensure pObject is an Object
	elseif (pObject == nil or type(pObject) ~= "table") then
		--print("Error on Save: Invalid type")
		return
	end
	
	--Player
	if (getmetatable(pObject).__index == Player) then
		sTrueKey = (MY_MOD_NAME .. "_Player" .. pObject:GetID() .. "_" .. sKey)
	--Team
	elseif (getmetatable(pObject).__index == Team) then
		sTrueKey = (MY_MOD_NAME .. "_Team" .. pObject:GetID() .. "_" .. sKey)
	--Unit
	elseif (getmetatable(pObject).__index == Unit) then
		sTrueKey = (MY_MOD_NAME .. "_Unit".. CompileUnitID(pObject) .. "_" .. sKey)
	--Plot
	elseif (getmetatable(pObject).__index == Plot) then
		sTrueKey = (MY_MOD_NAME .. "_Plot".. CompilePlotID(pObject) .. "_" .. sKey)
	--City
	elseif (getmetatable(pObject).__index == City) then
		sTrueKey = (MY_MOD_NAME .. "_City".. CompileCityID(pObject) .. "_" .. sKey)
	end	
	
	--Save Data
	if	sTrueKey ~= nil then
		--print("Save", sTrueKey, Val)
		SetPersistentProperty(sTrueKey, Val)
	else
		--print("Error on Save: Key Creation Failed")
	end
end

function Load_Booleanfy(Val)
	--Booleans must be converted from strings
	if Val == "bTrue" then
		Val = true
	elseif Val == "bFalse" then
		Val = false
	end
	return Val
end

function load(pObject, sKey)
	
	local sTrueKey = nil
	--if pObject == "GAME" or variants save without other ID
	if (type(pObject) == "string") then
		if string.upper(pObject) == "GAME" then
			sTrueKey = (MY_MOD_NAME .. "_" .. sKey)
		else
			--print("Error on Load: Invalid type")
			return
		end
	--Else ensure pObject is an Object
	elseif (pObject == nil or type(pObject) ~= "table") then
		--print("Error on Load: Invalid type")
		return
	end
	
	--Player
	if (getmetatable(pObject).__index == Player) then
		sTrueKey = (MY_MOD_NAME .. "_Player" .. pObject:GetID() .. "_" .. sKey)
	--Team
	elseif (getmetatable(pObject).__index == Team) then
		sTrueKey = (MY_MOD_NAME .. "_Team" .. pObject:GetID() .. "_" .. sKey)
	--Unit
	elseif (getmetatable(pObject).__index == Unit) then
		sTrueKey = (MY_MOD_NAME .. "_Unit".. CompileUnitID(pObject) .. "_" .. sKey)
	--Plot
	elseif (getmetatable(pObject).__index == Plot) then
		sTrueKey = (MY_MOD_NAME .. "_Plot".. CompilePlotID(pObject) .. "_" .. sKey)
	--City
	elseif (getmetatable(pObject).__index == City) then
		sTrueKey = (MY_MOD_NAME .. "_City".. CompileCityID(pObject) .. "_" .. sKey)
	end
	
	--Load Data
	if	sTrueKey ~= nil then
		Val = Load_Booleanfy(GetPersistentProperty(sTrueKey))
		--print("Load", sTrueKey, Val)
		return Val
	else
		--print("Error on Load: Key Creation Failed")
	end
end