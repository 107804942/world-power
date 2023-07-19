-------------------------------------------------
-- Archimedes Icon Manager
-------------------------------------------------
include("Rog_SaveUtils.lua"); MY_MOD_NAME = "世界强权";
include("InstanceManager");
include("IconSupport");

local g_ArchimedesManager = InstanceManager:new( "ArchimedesIcon", "Anchor", Controls.ArchimedesIconContainer );

local g_ArchimedesIconOffsetX = 0; 
local g_ArchimedesIconOffsetY = 0;  
local g_ArchimedesIconOffsetZ = 50;  

local g_bHideResourceIcons = not OptionsManager.GetResourceOn();

local g_bIsStrategicView   = false;

local g_ActiveSet = {};
local g_PerPlayerArchimedesTables = {};

local g_gridWidth, _ = Map.GetGridSize();
------------------------------------------------------------------
------------------------------------------------------------------
function IndexFromGrid( x, y )
    return x + (y * g_gridWidth);
end

------------------------------------------------------------------
------------------------------------------------------------------
function GridFromIndex( index )
	local y = math.floor(index / g_gridWidth);
    return (index - (y * g_gridWidth)), y;
end

------------------------------------------------------------------
------------------------------------------------------------------
function DestroyArchimedes( index )
    local instance = g_ActiveSet[ index ];
    if ( instance ~= nil ) then
		g_ArchimedesManager:ReleaseInstance( instance );
        g_ActiveSet[ index ] = nil;
	end
end

-------------------------------------------------
-------------------------------------------------
function BuildArchimedes( index, gridX, gridY, ImprovementType )

	DestroyArchimedes(index);

	local ImprovementInfo = GameInfo.Improvements[ImprovementType];
	local instance = g_ArchimedesManager:GetInstance();

	local desc = "[COLOR_ENDURANCE]" ..Locale.ConvertTextKey("TXT_KEY_IMPROVEMENT_BEACON").."[ENDCOLOR]";

	--instance.TribeName:SetText(Locale.ConvertTextKey(ImprovementInfo.Description)) ---新增
	instance.TribeName:SetText(desc) ---新增

	instance.NameStack:CalculateSize()
	local bannerWidth = instance.NameStack:GetSizeX() - 44
	instance.BannerButton:SetSizeX(bannerWidth)
	instance.TribeBannerBackground:SetSizeX(bannerWidth)
	instance.TribeBannerBackgroundHL:SetSizeX(bannerWidth)
	instance.TribeBannerBaseFrame:SetSizeX(bannerWidth)
	instance.BannerButton:ReprocessAnchoring()
	instance.NameStack:ReprocessAnchoring() ---新增

	instance.BannerButton:RegisterCallback(Mouse.eLClick, OnArchimedesClicked)

    	
	g_ActiveSet[ index ] = instance;
		
	local x, y, z = GridToWorld( gridX, gridY );
	instance.Anchor:SetWorldPositionVal( x + g_ArchimedesIconOffsetX,
										 y + g_ArchimedesIconOffsetY,
										 z + g_ArchimedesIconOffsetZ );
										 										 	
	--IconHookup(75, 64, "ROBOT_ICON_ATLAS2", instance.ResourceIcon);
	IconHookup(5, 32, "ARCHIMEDES_ATLAS", instance.TribeIcon)

	-- Tool Tip
	--local plot = Map.GetPlot( gridX, gridY );
	local strToolTip = Locale.ConvertTextKey(ImprovementInfo.Help);
	if( strToolTip ~= nil ) then
		instance.BannerButton:SetToolTipString(strToolTip);
	end
end

-------------------------------------------------
-------------------------------------------------
function OnArchimedesAdded( iHexX, iHexY  )

		local gridX, gridY  = ToGridFromHex( iHexX, iHexY);
        local plot = Map.GetPlot( gridX, gridY );
		local ImprovementType = plot:GetImprovementType()

	    if (ImprovementType == GameInfoTypes["IMPROVEMENT_BEACON"] ) then

		local activePlayerID = Game.GetActivePlayer()
        local activePlayer	 = Players[activePlayerID]

		save(activePlayer, "ArchimedesStack", 1)

		save(plot, "Archimedesplot", 1)

		if ( PreGame.IsHotSeatGame() ) then
			local bIsBuilt = false;
			for iPlayerID = 0, GameDefines.MAX_PLAYERS do
				local pPlayer = Players[iPlayerID];
				if( pPlayer ~= nil and pPlayer:IsHuman() ) then
					if( plot:IsRevealed( pPlayer:GetTeam(), false ) ) then
						-- Build the icon
						local index = IndexFromGrid( gridX, gridY );
						-- Only need to build the resource if the active team can see this
						if( not bIsBuilt and pPlayer:GetTeam() == Game.GetActiveTeam() ) then
							BuildArchimedes( index, gridX, gridY, ImprovementType );
							bIsBuilt = true;
						end
						
						-- Store the resource for the player
						if (g_PerPlayerArchimedesTables[ iPlayerID ] == nil) then
							g_PerPlayerArchimedesTables[ iPlayerID ] = {};
						end
						
						local playerResourceTable = g_PerPlayerArchimedesTables[ iPlayerID ];		
						playerResourceTable[index] = ImprovementType;
					end
				end
			end
		else
			if( not plot:IsRevealed( Game.GetActiveTeam(), false ) ) then
				return;
			end

			-- Build the icon
			local index = IndexFromGrid( gridX, gridY );
			BuildArchimedes( index, gridX, gridY, ImprovementType );
			
			-- Store the resource for the current player
			local iPlayerID = Game.GetActivePlayer();		
			if (g_PerPlayerArchimedesTables[ iPlayerID ] == nil) then
				g_PerPlayerArchimedesTables[ iPlayerID ] = {};
			end
			
			local playerResourceTable = g_PerPlayerArchimedesTables[ iPlayerID ];		
			playerResourceTable[index] = ImprovementType;			
		end

		Controls.ArchimedesIconContainer:SetHide(false)
    end
end
Events.SerialEventImprovementCreated.Add(OnArchimedesAdded);


function OnArchimedesDestroyed( iHexX, iHexY  )
        local gridX, gridY  = ToGridFromHex( iHexX, iHexY);
        local plot = Map.GetPlot( gridX, gridY );

		if  load(plot, "Archimedesplot") ~= nil 
		and load(plot, "Archimedesplot") > 0 then

        save(plot, "Archimedesplot", 0)

		for index, ImprovementType in pairs( g_ActiveSet ) do
        DestroyArchimedes( index );
   	  end
	  Controls.ArchimedesIconContainer:SetHide(false)
   end
end
Events.SerialEventImprovementDestroyed.Add(OnArchimedesDestroyed)



-------------------------------------------------
-------------------------------------------------
function OnStrategicViewStateChanged2( bStrategicView )
    g_bIsStrategicView = bStrategicView;
    if( bStrategicView ) then
        Controls.ArchimedesIconContainer:SetHide( true );
    else
        Controls.ArchimedesIconContainer:SetHide( g_bHideResourceIcons );
    end
end
Events.StrategicViewStateChanged.Add(OnStrategicViewStateChanged2);

----------------------------------------------------------------
-- 'Active' (local human) player has changed
----------------------------------------------------------------
function  ActivePlayerChanged(playerID)
	local pPlayer = Players[playerID]

	if pPlayer == nil or pPlayer:IsMinorCiv() or pPlayer:IsBarbarian() then
	 	return
	         end
    if pPlayer:IsHuman() then 
    Controls.ArchimedesIconContainer:SetHide(true)
	end
end	
GameEvents.PlayerDoneTurn.Add(ActivePlayerChanged)


function  ArchimedesPlayerStart(playerID)
   local activePlayerID = Game.GetActivePlayer()
   local activePlayer	 = Players[activePlayerID]
   if activePlayer:IsHuman() then 
   Controls.ArchimedesIconContainer:SetHide(false)
   end
end
Events.ActivePlayerTurnStart.Add( ArchimedesPlayerStart)



function EnterCityScreen()
	Controls.ArchimedesIconContainer:SetHide(true)
end
Events.SerialEventEnterCityScreen.Add(EnterCityScreen)


function ExitCityScreen()
	Controls.ArchimedesIconContainer:SetHide(false)
end
Events.SerialEventExitCityScreen.Add(ExitCityScreen)



function SkynetResistanceRemove(iPlayer)
  local player = Players[iPlayer]
  if player == nil or player:IsMinorCiv() or player:IsBarbarian() then
	 	return
	         end
        if  load(player, "ArchimedesStack") ~= nil 
		and load(player, "ArchimedesStack") == 0 then
		  save(player, "ArchimedesStack", 1)

	   g_ArchimedesManager:ResetInstances();

	   local instance = g_ArchimedesManager:GetInstance();

	   local Description = "[COLOR_ENDURANCE]" ..Locale.ConvertTextKey("TXT_KEY_IMPROVEMENT_BEACON").."[ENDCOLOR]";

	   instance.TribeName:SetText(Description) ---新增

		end
	end
GameEvents.PlayerDoTurn.Add(SkynetResistanceRemove)



function OnArchimedesClicked()
     
        local activePlayerID = Game.GetActivePlayer()
        local activePlayer	 = Players[activePlayerID]

		if  load(activePlayer, "ArchimedesStack") ~= nil 
		and load(activePlayer, "ArchimedesStack") > 0 
		and activePlayer:HasWonder(GameInfoTypes.BUILDING_ARCHIMEDES) then
		 
		for iPlayerID = 0, GameDefines.MAX_PLAYERS do
				local pPlayer = Players[iPlayerID];
				if( pPlayer ~= nil and  pPlayer~=activePlayer ) then

				if Teams[activePlayer:GetTeam()]:IsAtWar(pPlayer:GetTeam()) then
					for Unit in pPlayer:Units() do

					if Unit:GetDomainType()==DomainTypes.DOMAIN_LAND    then 
					local pPlot = Unit:GetPlot()

			if  pPlot:IsHills() then  --丘陵
			    if pPlot:IsRiver()then  --河流
			    Unit:ChangeDamage(50)
			   else
			    Unit:ChangeDamage(25)  --非河流
				end
			else   --非丘陵
                if pPlot:IsRiver() then  --河流
			    Unit:ChangeDamage(25)
				        end
				     end
		          end
	           end
            end
         end
     end
  
	   g_ArchimedesManager:ResetInstances();
	   local instance = g_ArchimedesManager:GetInstance();

	   local Description = "[COLOR_SAVAGE]" ..Locale.ConvertTextKey("TXT_KEY_IMPROVEMENT_BEACON").."[ENDCOLOR]";

	   instance.TribeName:SetText(Description) ---新增


	  -- Controls.ResourceIconContainer:SetHide( true );

	  Events.AudioPlay2DSound("AS2D_ARCTURUS_YAMATO_CANNON")

	  save(activePlayer, "ArchimedesStack", load(activePlayer, "ArchimedesStack") - 1)

   end 
end


