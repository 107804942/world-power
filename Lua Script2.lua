-- Sets Bonus Icons

local g_traitsQueryRog, g_uniqueUnitsQueryRog, g_uniqueBuildingsQueryRog, g_uniqueImprovementsQueryRog;


-----------------
-- Pedia Callback
-----------------
local getPedia;
local function getPediaB( ... )
	Events.SearchForPediaEntry( ... )
end
local function getPediaA( ... )
	UIManager:QueuePopup( LookUpControl( CivilopediaControl ), PopupPriority.eUtmost );
	getPedia = getPediaB;
	getPedia( ... )
end
getPedia = CivilopediaControl and getPediaA;


function initializePopulateCivilizationUniquesRog()

	g_traitsQueryRog = DB.CreateQuery([[SELECT Description, ShortDescription FROM Traits inner join
					Leader_Traits ON Traits.Type = Leader_Traits.TraitType
					WHERE Leader_Traits.LeaderType = ? LIMIT 1]]);

	g_uniqueUnitsQueryRog = DB.CreateQuery([[SELECT ID, Description, PortraitIndex, IconAtlas from Units INNER JOIN
					Civilization_UnitClassOverrides ON Units.Type = Civilization_UnitClassOverrides.UnitType
					WHERE Civilization_UnitClassOverrides.CivilizationType = ? AND
					Units.ShowInPedia IS NOT 0 AND
					Civilization_UnitClassOverrides.UnitType IS NOT NULL]]);

	g_uniqueBuildingsQueryRog = DB.CreateQuery([[SELECT ID, Description, PortraitIndex, IconAtlas from Buildings INNER JOIN
					Civilization_BuildingClassOverrides ON Buildings.Type = Civilization_BuildingClassOverrides.BuildingType
					WHERE Civilization_BuildingClassOverrides.CivilizationType = ? AND
					Civilization_BuildingClassOverrides.BuildingType IS NOT NULL]]
					.. ( bnw_mode and " AND Buildings.GreatWorkCount IS NOT -1" or "" ) );

	g_uniqueImprovementsQueryRog = DB.CreateQuery([[SELECT ID, Description, PortraitIndex, IconAtlas from Improvements
					WHERE CivilizationType = ?]]);
end


				initializePopulateCivilizationUniquesRog();
				Controls.SubStack:DestroyAllChildren();
				--PopulateUniquesForGameLoad( Controls.SubStack, civ.Type );
				PopulateUniquesForGameLoadRog( Controls.SubStack, civ.Type );




----------------
-- Icon Creation
----------------

function PopulateUniquesForGameLoadRog( parentControl, civType )
	-- UU icons
	for unit in g_uniqueUnitsQueryRog( civType ) do
	---newItemIcon( parentControl, unit, pcall( GetHelpTextForUnit, unit.ID, true ) );
	local iconControls = {};
	    ContextPtr:BuildInstanceForControl( "IconInstance", iconControls, parentControl );

		---populateIcon( iconControls, unit, pcall( GetHelpTextForUnit, unit.ID, true ) );
		--------------------------------------------------------------
		local textureOffset, textureAtlas = IconLookup( unit.PortraitIndex, iconControls.Portrait:GetSizeX(), unit.IconAtlas );
		if textureAtlas then
		iconControls.Portrait:SetTexture( textureAtlas );
		iconControls.Portrait:SetTextureOffset( textureOffset );
	    end
		
		iconControls.Portrait:SetVoid2(unit.ID)
		iconControls.Portrait:SetToolTipCallback(ToolTipHandler)
        iconControls.Portrait:SetToolTipType( "City_UnitTooltip" ) 

		--PopulateUniquesForGameLoad( Controls.SubStack, civ.Type );

		---iconControls.Portrait:SetToolTipString( tip )

	    -- set the item description
	    if  iconControls.Text and unit.Description then
		iconControls.Text:LocalizeAndSetText( unit.Description );
	    end
	    -- set the pedia callback
	    pedia = CivilopediaControl and ( pedia or unit.Description);
	    if pedia then
		iconControls.Portrait:RegisterCallback( Mouse.eRClick, function() getPedia( pedia ) end );
	    end
		--------------------------------------------------------------

	end
	-- UB icons
	for building in g_uniqueBuildingsQueryRog( civType ) do
		---newItemIcon( parentControl, building, pcall( GetHelpTextForBuilding, building.ID ) );
		local iconControls = {};
	    ContextPtr:BuildInstanceForControl( "IconInstance", iconControls, parentControl );
		populateIconRog( iconControls,  building, pcall( GetHelpTextForBuilding, building.ID ) )
	end
	-- UI icons
	for improvement in g_uniqueImprovementsQueryRog( civType ) do
		--newItemIcon( parentControl, improvement, pcall( GetHelpTextForImprovement, improvement.ID ) );
		local iconControls = {};
	    ContextPtr:BuildInstanceForControl( "IconInstance", iconControls, parentControl );
		populateIconRog( iconControls,  improvement, pcall( GetHelpTextForImprovement, improvement.ID ) )
	end

end

function populateIconRog( controls, item, isTip, tip, pedia )
	-- set the item picture
	local textureOffset, textureAtlas = IconLookup( item.PortraitIndex, controls.Portrait:GetSizeX(), item.IconAtlas );
	if textureAtlas then
		controls.Portrait:SetTexture( textureAtlas );
		controls.Portrait:SetTextureOffset( textureOffset );
	end
	-- set the item tooltip
	if isTip then
		controls.Portrait:SetToolTipString( tip )
	elseif item.Description then
		controls.Portrait:LocalizeAndSetToolTip( item.Description );
	end
	-- set the item description
	if  controls.Text and item.Description then
		controls.Text:LocalizeAndSetText( item.Description );
	end
	-- set the pedia callback
	pedia = CivilopediaControl and ( pedia or item.Description);
	if pedia then
		controls.Portrait:RegisterCallback( Mouse.eRClick, function() getPedia( pedia ) end );
	end
end
