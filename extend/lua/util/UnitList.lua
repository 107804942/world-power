print("This is the modded UnitList from 'UI - Unit List Enhancements'")

-------------------------------------------------
-- UnitList
-------------------------------------------------
include( "InstanceManager" );
include( "SupportFunctions" );
local m_MilitaryIM = InstanceManager:new( "UnitInstance", "Root", Controls.MilitaryStack );
local m_CivilianIM = InstanceManager:new( "UnitInstance", "Root", Controls.CivilianStack );

local m_SortTable;
local eName       = 0;
local eStatus     = 1;
local eExperience = 2;
local eDamage     = 3;
local eUpgrade    = 4;
local eMovement   = 5;

local m_SortMode = eName;
local m_bSortReverse = false;


-------------------------------------------------
-------------------------------------------------
function ShowHideHandler( bIsHide )
    if( not bIsHide ) then
        UpdateDisplay();
    end
end
ContextPtr:SetShowHideHandler( ShowHideHandler );


-------------------------------------------------
-------------------------------------------------
function OnClose( )
    ContextPtr:SetHide( true );
    Events.OpenInfoCorner( InfoCornerID.None );
end
Controls.CloseButton:RegisterCallback( Mouse.eLClick, OnClose );


----------------------------------------------------------------
-- Key Down Processing
----------------------------------------------------------------
function InputHandler( uiMsg, wParam, lParam )
	if uiMsg == KeyEvents.KeyDown then
		if wParam == Keys.VK_ESCAPE then --or wParam == Keys.VK_RETURN then
			OnClose();
			return true;
		end
    end
end
ContextPtr:SetInputHandler( InputHandler );


-------------------------------------------------
-------------------------------------------------
function UnitClicked( unitID )
    local pSelectedUnit = UI:GetHeadSelectedUnit();
    if( pSelectedUnit ~= nil and
        pSelectedUnit:GetID() == unitID ) then
        UI.LookAtSelectionPlot(0);
    else
        Events.SerialEventUnitFlagSelected( Game:GetActivePlayer(), unitID );
        UI.LookAt(Players[Game.GetActivePlayer()]:GetUnitByID(unitID):GetPlot(), 0)
    end
end

function OnUnitUpgrade( unitID )
	local pUnit = Players[Game.GetActivePlayer()]:GetUnitByID(unitID)
	Events.SerialEventUnitFlagSelected(Game.GetActivePlayer(), unitID)
	UI.LookAt(pUnit:GetPlot(), 0)
	
	if (pUnit.Upgrade) then
		pUnit:Upgrade()
	end
end

-------------------------------------------------
-------------------------------------------------
function OpenOverview()
	Events.SerialEventGameMessagePopup( { Type = ButtonPopupTypes.BUTTONPOPUP_MILITARY_OVERVIEW } );
end
Controls.OpenOverviewButton:RegisterCallback( Mouse.eLClick, OpenOverview );


-------------------------------------------------
-------------------------------------------------
function OnChangeEvent()
    if( ContextPtr:IsHidden() == false ) then
        UpdateDisplay();
    end
end
Events.SerialEventUnitDestroyed.Add( OnChangeEvent );
Events.SerialEventUnitSetDamage.Add( OnChangeEvent );
Events.UnitStateChangeDetected.Add( OnChangeEvent );
Events.SerialEventUnitCreated.Add( OnChangeEvent );
Events.UnitSelectionChanged.Add( OnChangeEvent );
Events.UnitActionChanged.Add( OnChangeEvent );
Events.UnitFlagUpdated.Add( OnChangeEvent );
Events.UnitGarrison.Add( OnChangeEvent );
Events.UnitEmbark.Add( OnChangeEvent );
Events.SerialEventUnitMoveToHexes.Add( OnChangeEvent );
Events.SerialEventUnitMove.Add( OnChangeEvent );
Events.SerialEventUnitTeleportedToHex.Add( OnChangeEvent );
Events.GameplaySetActivePlayer.Add(OnChangeEvent);

-------------------------------------------------
-------------------------------------------------
function UpdateDisplay()

    m_SortTable = {};

    local pPlayer = Players[ Game.GetActivePlayer() ];
    
    local bFoundMilitary = false;
    local bFoundCivilian = false;
    
    local pSelectedUnit = UI:GetHeadSelectedUnit();
    local iSelectedUnit = -1;
    if( pSelectedUnit ~= nil ) then
        iSelectedUnit = pSelectedUnit:GetID();
    end
    
    m_MilitaryIM:ResetInstances();
    m_CivilianIM:ResetInstances();
   
    for unit in pPlayer:Units()
    do
        local instance;
        local iUnit = unit:GetID();
        
        if( unit:IsCombatUnit() or unit:GetDomainType() == DomainTypes.DOMAIN_AIR) then
            instance = m_MilitaryIM:GetInstance();
            bFoundMilitary = true;
        else
            instance = m_CivilianIM:GetInstance();
            bFoundCivilian = true;
        end
        
        local sortEntry = {};
        m_SortTable[ tostring( instance.Root ) ] = sortEntry;
        
        instance.Button:RegisterCallback( Mouse.eLClick, UnitClicked );
        instance.Button:SetVoid1( unit:GetID() );
        
        sortEntry.name = Locale.ConvertTextKey( unit:GetNameKey() );
        TruncateString( instance.UnitName, 110, sortEntry.name );
        
        if( unit:MovesLeft() > 0 ) then
            instance.Button:SetAlpha( 1.0 );
        else
            instance.Button:SetAlpha( 0.6 );
        end
        
        instance.SelectionFrame:SetHide( not (iSelectedUnit == iUnit) );
       
        ---------------------------------------------------------
        -- Status field
        local buildType = unit:GetBuildType();
        local activityType = unit:GetActivityType();
        instance.Status:SetToolTipString(nil)
        if( unit:IsEmbarked() ) then
            sortEntry.status = "TXT_KEY_UNIT_STATUS_EMBARKED";
            instance.Status:SetHide( false );
        elseif( unit:IsGarrisoned()) then
            sortEntry.status = "TXT_KEY_MISSION_GARRISON";
            instance.Status:SetHide( false );
        elseif( unit:IsAutomated()) then
            if(unit:IsWork()) then
                sortEntry.status = "TXT_KEY_ACTION_AUTOMATE_BUILD";
                instance.Status:SetHide( false );
            elseif(unit.IsTrade ~= nil and unit:IsTrade()) then
                sortEntry.status = "TXT_KEY_ACTION_AUTOMATE_TRADE";
                instance.Status:SetHide( false );
                
                -- Extra stuff if the Trade Route API is available from the DLL mod
                if (Game.GetTradeRoute) then
                    local iRoute = unit:GetTradeRouteIndex()
                    if (iRoute ~= -1) then
                        local route = Game.GetTradeRoute(iRoute)
                        if (route) then
                            local sRecall = ""
                            if (unit:IsRecalledTrader()) then
                                if (route.MovingForward) then
                                    sRecall = Locale.Lookup("TXT_KEY_UNIT_STATUS_RECALLING_TT")
                                else
                                    sRecall = Locale.Lookup("TXT_KEY_UNIT_STATUS_RECALLED_TT")
                                end
                            end
                            instance.Status:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_UNIT_STATUS_TRADING_TT", route.FromCityName, route.ToCityName, sRecall))
                        end
                    end
                end
            else
                sortEntry.status = "TXT_KEY_ACTION_AUTOMATE_EXPLORE";
                instance.Status:SetHide( false );
            end
        elseif( activityType == ActivityTypes.ACTIVITY_HEAL ) then
            sortEntry.status = "TXT_KEY_MISSION_HEAL";
            instance.Status:SetHide( false );
        elseif( activityType == ActivityTypes.ACTIVITY_SENTRY ) then
            sortEntry.status = "TXT_KEY_MISSION_ALERT";
            instance.Status:SetHide( false );
        elseif( unit:GetFortifyTurns() > 0 ) then
            sortEntry.status = "TXT_KEY_UNIT_STATUS_FORTIFIED";
            instance.Status:SetHide( false );
        elseif( activityType == ActivityTypes.ACTIVITY_SLEEP ) then
            sortEntry.status = "TXT_KEY_MISSION_SLEEP";
            instance.Status:SetHide( false );
        elseif( buildType ~= -1) then -- this is a worker who is actively building something
            local thisBuild = GameInfo.Builds[buildType];
            local civilianUnitStr = "";
            local skip = {};
            for word in string.gmatch(Locale.ConvertTextKey("TXT_KEY_UNIT_STATUS_BUILD_SKIP_WORDS"), "[^%s]+") do 
                skip[word] = true;
            end
            
            local bStart = true;
            for word in string.gmatch(Locale.ConvertTextKey(thisBuild.Description), "[^%s]+") do 
                if (not (bStart and skip[word])) then
                    civilianUnitStr = civilianUnitStr .. " " .. word; 
                    bStart = false;
                end
            end

    		local iTurnsLeft = unit:GetPlot():GetBuildTurnsLeft(buildType, 0, 0);	
    		local iTurnsTotal = unit:GetPlot():GetBuildTurnsTotal(buildType);	
    		if (iTurnsLeft < 4000 and iTurnsLeft > 0) then
    			civilianUnitStr = civilianUnitStr.." ("..tostring(iTurnsLeft)..")";
    		end
            sortEntry.status = civilianUnitStr:sub(2);
            instance.Status:SetHide( false );
            
    	else
            sortEntry.status = "";
            instance.Status:SetHide( true );
        end
        
        if( sortEntry.status ~= "" ) then
		    instance.Status:LocalizeAndSetText( sortEntry.status );
	    else
		    instance.Status:SetText( "" );
	    end
	    
	    local statusY = instance.Status:GetSizeY();
	    statusY = statusY + 10;
	    --print(statusY);
	    if(statusY > 24)then
		   instance.ExperienceBox:SetSizeY(statusY); 
		   instance.StatusBox:SetSizeY(statusY); 
		   instance.SelectionFrame:SetSizeY(statusY);
		   instance.Root:SetSizeY(statusY);
		   instance.SelectHL:SetSizeY(statusY);
		   instance.SelectAnim:SetSizeY(statusY);
        end
	    local move_denominator = GameDefines["MOVE_DENOMINATOR"];
	    local moves_left = unit:MovesLeft() / move_denominator;
	    local max_moves = unit:MaxMoves() / move_denominator;
        sortEntry.movement = moves_left;
        
        if( moves_left == max_moves ) then
            instance.MovementPip:SetTextureOffsetVal( 0, 0 );
        elseif( moves_left == 0 ) then
            instance.MovementPip:SetTextureOffsetVal( 0, 96 );
        else
            instance.MovementPip:SetTextureOffsetVal( 0, 32 );
        end  
        
        ---------------------------------------------------------
        -- Upgrade field
		local iUpgradeCost = 0;
		
		if (unit:CanUpgradeRightNow()) then
			iUpgradeCost = unit:UpgradePrice(unit:GetUpgradeUnitType())
	        instance.Upgrade:SetToolTipString(Locale.ConvertTextKey( "TXT_KEY_UNIT_STATUS_UPGRADE_TT", GameInfo.Units[unit:GetUpgradeUnitType()].Description, iUpgradeCost ));
			instance.Upgrade:SetText("[ICON_GOLD]");
			instance.UpgradeButton:RegisterCallback(Mouse.eLClick, OnUnitUpgrade)
			instance.UpgradeButton:SetVoid1(unit:GetID())
		end
		
        sortEntry.upgrade = iUpgradeCost;
        instance.Upgrade:SetHide( iUpgradeCost == 0 );

        ---------------------------------------------------------
        -- Damage field
        if (unit:IsCombatUnit() or (unit:GetDomainType() == DomainTypes.DOMAIN_AIR and GameInfo.Units[unit:GetUnitType()].Suicide == false)) then
	local damage = unit:GetDamage();
	local MaxDamage = unit:GetMaxHitPoints();
	local health = MaxDamage - damage;
	local healthTimes100 =  math.floor(100 * (health/MaxDamage) + 0.5);
		
if (healthTimes100 > 66) then
  sTextColour = "[COLOR_GREEN]"
elseif (healthTimes100 > 33) then
  sTextColour = "[COLOR_YELLOW]"
else
  sTextColour = "[COLOR_RED]"
end

            sortEntry.damage = health;
            instance.Damage:SetHide( false );
  	    instance.Damage:SetText(string.format("%s%i[ENDCOLOR]", sTextColour, health));

	    instance.Damage:SetToolTipString(Locale.ConvertTextKey( "TXT_KEY_UPANEL_SET_HITPOINTS_TT",(MaxDamage-damage), MaxDamage ));
    	else
            sortEntry.damage = 0;
            instance.Damage:SetHide( false );
  	    instance.Damage:SetText("");
        end
        
        ---------------------------------------------------------
        -- Experience field
        if (unit:IsCombatUnit() or (unit:GetDomainType() == DomainTypes.DOMAIN_AIR and GameInfo.Units[unit:GetUnitType()].Suicide == false)) then
            local experience = unit:GetExperience();
            sortEntry.experience = experience;
            instance.Experience:SetHide( false );
  	    instance.Experience:SetText(experience);

		-- MOD - if we have support for XP times 100, show that in the tooltip instead
		local iActualXp = experience
		local iNeededXp = unit:ExperienceNeeded()
		if (unit.GetExperienceTimes100) then
			iActualXp = unit:GetExperienceTimes100()
			iNeededXp = iNeededXp * 100
		end
		
	    instance.Experience:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_UNIT_EXPERIENCE_INFO", unit:GetLevel(), iActualXp, iNeededXp));
    	else
            sortEntry.experience = 0;
            instance.Experience:SetHide( false );
  	    instance.Experience:SetText("");
        end
        
		instance.UnitStack:CalculateSize();
		instance.UnitStack:ReprocessAnchoring();
        
        sortEntry.unit = unit;
    end


    if( bFoundMilitary and bFoundCivilian ) then
        Controls.CivilianSeperator:SetHide( false );
    else
        Controls.CivilianSeperator:SetHide( true );
    end
     
    Controls.MilitaryStack:SortChildren( SortFunction );
    Controls.CivilianStack:SortChildren( SortFunction );
    
    Controls.MilitaryStack:CalculateSize();
    Controls.MilitaryStack:ReprocessAnchoring();
    Controls.CivilianStack:CalculateSize();
    Controls.CivilianStack:ReprocessAnchoring();
    
    Controls.MainStack:CalculateSize();
    Controls.MainStack:ReprocessAnchoring();
    Controls.ScrollPanel:CalculateInternalSize();
    
    Controls.ScrollPanel:ReprocessAnchoring();
end


-------------------------------------------------
-------------------------------------------------
function SortFunction( a, b )
    local valueA, valueB;
    local entryA = m_SortTable[ tostring( a ) ];
    local entryB = m_SortTable[ tostring( b ) ];
	
    if (entryA == nil) or (entryB == nil) then 
		if entryA and (entryB == nil) then
			return false;
		elseif (entryA == nil) and entryB then
			return true;
		else
			if( m_bSortReverse ) then
				return tostring(a) > tostring(b); -- gotta do something deterministic
			else
				return tostring(a) < tostring(b); -- gotta do something deterministic
			end
        end;
    else
		if( m_SortMode == eName ) then
			valueA = entryA.name;
			valueB = entryB.name;
		elseif( m_SortMode == eStatus ) then
			valueA = entryA.status;
			valueB = entryB.status;
		elseif( m_SortMode == eDamage ) then
			valueA = entryB.damage;
			valueB = entryA.damage;
		elseif( m_SortMode == eExperience ) then
			valueA = entryB.experience;
			valueB = entryA.experience;
		elseif( m_SortMode == eUpgrade ) then
			valueA = entryB.upgrade;
			valueB = entryA.upgrade;
		else -- movement
			valueA = entryA.movement;
			valueB = entryB.movement;
		end
	    
		if( valueA == valueB ) then
			valueA = entryA.unit:GetID();
			valueB = entryB.unit:GetID();
		end
	    
	   
		if( m_bSortReverse ) then
			return valueA > valueB;
		else
			return valueA < valueB;
		end
    end
end


-------------------------------------------------
-------------------------------------------------
function OnSort( type )
    if( m_SortMode == type ) then
        m_bSortReverse = not m_bSortReverse;
    else
        m_bSortReverse = false;
    end

    m_SortMode = type;
    Controls.MilitaryStack:SortChildren( SortFunction );
    Controls.CivilianStack:SortChildren( SortFunction );
end
Controls.SortName:RegisterCallback( Mouse.eLClick, OnSort );
Controls.SortStatus:RegisterCallback( Mouse.eLClick, OnSort );
Controls.SortDamage:RegisterCallback( Mouse.eLClick, OnSort );
Controls.SortExperience:RegisterCallback( Mouse.eLClick, OnSort );
Controls.SortUpgrade:RegisterCallback( Mouse.eLClick, OnSort );
Controls.SortMovement:RegisterCallback( Mouse.eLClick, OnSort );
Controls.SortName:SetVoid1( eName );
Controls.SortStatus:SetVoid1( eStatus );
Controls.SortDamage:SetVoid1( eDamage );
Controls.SortExperience:SetVoid1( eExperience );
Controls.SortUpgrade:SetVoid1( eUpgrade );
Controls.SortMovement:SetVoid1( eMovement );

	
-------------------------------------------------
-------------------------------------------------
function OnOpenInfoCorner( iInfoType )
    if( iInfoType == InfoCornerID.Units ) then
        ContextPtr:SetHide( false );
        OnSort( m_SortMode );
    else
        ContextPtr:SetHide( true );
    end
end
Events.OpenInfoCorner.Add( OnOpenInfoCorner );
