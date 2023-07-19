include("Rog_SaveUtils.lua"); MY_MOD_NAME = "世界强权";
include("PlotIterators.lua");
include("FunctionUtilities.lua")
include("IconSupport")
include("FLuaVector.lua")


-- ********************************************************
-- 硅谷
-- ********************************************************   	
local buildingGUIGUID = GameInfoTypes["BUILDING_GUIGU"]
local buildingIconAtlas = "ROBOT_ICON_ATLAS3" 
local buildingIconIndex = 225 

function GetSpecialistCultureNeed(player)
 local numneed =3000
 local n =1
 if load(player, "UseForBuySpecialist") ~= nil then
 n= load(player, "UseForBuySpecialist")
 numneed =math.floor(3000*math.pow(1.2,n))
     end
 return numneed
end	 

-------------------------------------------------------------------------------------------------------------------------

function DoSpecialistCultureBuy(player, city)
    local tSpecialists2 ={}
	local numCulture = GetSpecialistCultureNeed(player)
	local iX, iY = city:GetX(),city:GetY() 
	--pPlayer:GetTourism()

	if  player:IsHuman() and player:IsTurnActive() 
	and player:GetJONSCulture() >=numCulture  then
	    player:ChangeJONSCulture(-numCulture)
		Events.AudioPlay2DSound("AS2D_INTERFACE_CITY_SCREEN_PURCHASE")
       
        for row in GameInfo.Units() do
        if  row.Special=='SPECIALUNIT_PEOPLE' then
	    table.insert(tSpecialists2, row.ID)
		   end
		end
		   if #tSpecialists2 > 0 then
			  local randomNumber = ROG_GetTrueRandom(1, #tSpecialists2)
			  local tSpecialist = tSpecialists2[randomNumber]
			  Specialistinfo = GameInfo.Units{ID=tSpecialist}() 			     
              local SpecialistUnit = player:InitUnit(Specialistinfo.ID, iX,iY)
			  SpecialistUnit:JumpToNearestValidPlot() 
			  SpecialistUnit:SetHasPromotion(GameInfoTypes["PROMOTION_CULTURE_GREAT_PEOPLE"], true) 
		      local title = Locale.ConvertTextKey("TXT_KEY_GUIGU_HEAD");
	          local descr = Locale.ConvertTextKey("TXT_KEY_GUIGU_CITY",SpecialistUnit:GetName(), city:GetName())
	          player:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, descr, title, iX, iY , -1)

			  if load(player, "UseForBuySpecialist")~=nil then
			  save( player, "UseForBuySpecialist", load(player, "UseForBuySpecialist") + 1)
			  else
			  save( player, "UseForBuySpecialist",1)
			        --end
			    --end	
             end	
         end	
	end

end


local isCityViewOpen = false
-- UpdateButton
function GUIGU_UpdateButton()
	Controls.SRBBox:SetHide(true)
	Controls.SRBImage:SetHide(true)
	Controls.SRBButton:SetDisabled(true)
	Controls.SRBButton:LocalizeAndSetToolTip(nil)
	local city = UI.GetHeadSelectedCity()
	if  city then
		local cityID = city:GetID()
		local player = Players[city:GetOwner()]
		if  city:IsHasBuilding(buildingGUIGUID) 
		and Game.GetActivePlayer()==city:GetOwner()  then
			local numCulture = GetSpecialistCultureNeed(player)
			
			if (player:GetJONSCulture() < numCulture ) then  ---文化不足
				Controls.SRBButton:SetDisabled(true)
				Controls.SRBButton:LocalizeAndSetText("TXT_KEY_CULYURE_BUY")
				Controls.SRBButton:LocalizeAndSetToolTip("TXT_KEY_CULYURE_BUY_DISABLED_TT", numCulture)
			else
				Controls.SRBButton:LocalizeAndSetText("TXT_KEY_CULYURE_BUY")
				Controls.SRBButton:LocalizeAndSetToolTip("TXT_KEY_CULYURE_BUY_TT", numCulture)
				Controls.SRBButton:SetDisabled(false)
			end
			IconHookup(buildingIconIndex, 64, buildingIconAtlas, Controls.SRBImage)
			Controls.SRBBox:SetHide(false)
			Controls.SRBImage:SetHide(false)
		end
	end
end

-- Button
function SRBButton()
    local activePlayerID = Game.GetActivePlayer()
	local activePlayer = Players[activePlayerID]
	local city = UI.GetHeadSelectedCity()
	if city then
		if  city:IsHasBuilding(buildingGUIGUID) 
		and Game.GetActivePlayer()==city:GetOwner() then
		local numCulture = GetSpecialistCultureNeed(Players[city:GetOwner()])
			DoSpecialistCultureBuy(activePlayer, city)
		end
	end
end
Controls.SRBButton:RegisterCallback(Mouse.eLClick, SRBButton)

-- SerialEventEnterCityScreen
function SerialEventEnterCityScreen()
	isCityViewOpen = true
	GUIGU_UpdateButton()
end

-- SerialEventExitCityScreen
function SerialEventExitCityScreen()
	isCityViewOpen = false
	GUIGU_UpdateButton()
end

-- SerialEventCityScreenDirty
function SerialEventCityScreenDirty()
	if isCityViewOpen then
		GUIGU_UpdateButton()
	end
end
Events.SerialEventEnterCityScreen.Add(SerialEventEnterCityScreen)
Events.SerialEventExitCityScreen.Add(SerialEventExitCityScreen)
Events.SerialEventCityScreenDirty.Add(SerialEventCityScreenDirty)
Events.SerialEventCityInfoDirty.Add(SerialEventEnterCityScreen)



if  (OptionsManager.GetSmallUIAssets()) 
or  not(OptionsManager.GetSmallUIAssets()) then Controls.SRBBox:SetOffsetX(-24) end

SpecialistUnitConvert = {
  Name = "SpecialistUnitConvert",
  Title = "TXT_KEY_SP_BTNNOTE_UNIT_SPECIALIST_CONVERT", -- or a TXT_KEY
  OrderPriority = 200, -- default is 200
  IconAtlas = "SP_UNIT_ACTION_ATLAS2", -- 45 and 64 variations required
  PortraitIndex = 11,
  ToolTip = "TXT_KEY_SP_BTNNOTE_SPECIALIST_CONVERT", -- or a TXT_KEY_ or a function
  
 
  
  Condition = function(action, unit)
    return unit:CanMove() and  unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_CULTURE_GREAT_PEOPLE"].ID)
  end, -- or nil or a boolean, default is true
  
 Disabled = function(action, unit)
    local player = Players[unit:GetOwner()] 
    if player:GetJONSCulture()<300 then
	return true
	  end;
    --local city = plot:GetPlotCity()
    return player:GetJONSCulture()<300;
  end, -- or nil or a boolean, default is false
  
  Action = function(action, unit, eClick) 
	local plot = unit:GetPlot()
    local player = Players[unit:GetOwner()]
    if player:GetJONSCulture()<300
	then 
	return 
	end

	local tSpecialists3 ={}
	 
        for row in GameInfo.Units() do
        if  row.Special=='SPECIALUNIT_PEOPLE'
		and row.Class~= GameInfo.Units[unit:GetUnitType()].Class   then
	    table.insert(tSpecialists3, row.ID)
		   end
		end
		   if #tSpecialists3 > 0 then
			  local randomNumber = ROG_GetTrueRandom(1, #tSpecialists3)
			  local tSpecialist = tSpecialists3[randomNumber]
			  Specialistinfo = GameInfo.Units{ID=tSpecialist}() 			     
              local SpecialistUnit = player:InitUnit(Specialistinfo.ID,unit:GetX(), unit:GetY())
			  --SpecialistUnit:JumpToNearestValidPlot()
			  --unit:Kill() 
			  SpecialistUnit:Convert(unit)    
			  SpecialistUnit:SetHasPromotion(GameInfoTypes["PROMOTION_CULTURE_GREAT_PEOPLE"], true)  
	          player:ChangeJONSCulture(-300)
		      --Events.AudioPlay2DSound("AS2D_MECH_POWER")
         end
  end
};
LuaEvents.UnitPanelActionAddin(SpecialistUnitConvert)

                                                                          