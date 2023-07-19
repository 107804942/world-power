include( "IconSupport" );
include("InstanceManager")
WelcomeData = Modding.OpenSaveData()
--IconHookup(2, 64, "WONDERS_DLC_ATLAS", Controls.Icon);
SimpleCivIconHookup( Game.GetActivePlayer(), 80, Controls.IconShadow );

function Hide()
	Controls.BGBlock:SetHide(true)
	Controls.EA_Welcome:SetHide(true)
	 WelcomeData.SetValue("bDidPopWelcome", true)
end
Controls.CloseButton:RegisterCallback(Mouse.eLClick, Hide)
if WelcomeData.GetValue("bDidPopWelcome") then Hide() end

g_Tabs = {
	["Welcome"] = {
		Panel = Controls.WelcomeBox,
		SelectHighlight = Controls.WelcomeSelectHighlight,
	},
	["Credits"] = {
		Panel = Controls.CreditsBox,
		SelectHighlight = Controls.CreditsSelectHighlight,
	},
	["Issues"] = {
		Panel = Controls.IssuesBox,
		SelectHighlight = Controls.IssuesSelectHighlight,
	},
}

function TabSelect(tab)
	for i,v in pairs(g_Tabs) do
		local bHide = i ~= tab;
		v.Panel:SetHide(bHide);
		v.SelectHighlight:SetHide(bHide);
	end
end
Controls.TabButtonWelcome:RegisterCallback( Mouse.eLClick, function() TabSelect("Welcome"); end);
Controls.TabButtonCredits:RegisterCallback( Mouse.eLClick, function() TabSelect("Credits"); end);
Controls.TabButtonIssues:RegisterCallback( Mouse.eLClick, function() TabSelect("Issues"); end);

TabSelect("Welcome")





local pCredits = {
Locale.ConvertTextKey( "TXT_KEY_MOD_EMPIRE_RISE_MOD_DETAIL_HELP1"), 
Locale.ConvertTextKey( "TXT_KEY_MOD_EMPIRE_RISE_MOD_DETAIL_HELP2"), 
Locale.ConvertTextKey( "TXT_KEY_MOD_EMPIRE_RISE_MOD_DETAIL_HELP3"), 
Locale.ConvertTextKey( "TXT_KEY_MOD_EMPIRE_RISE_MOD_DETAIL_HELP4"), 
Locale.ConvertTextKey( "TXT_KEY_MOD_EMPIRE_RISE_MOD_DETAIL_HELP5"), 
Locale.ConvertTextKey( "TXT_KEY_MOD_EMPIRE_RISE_MOD_DETAIL_HELP6"), 
Locale.ConvertTextKey( "TXT_KEY_MOD_EMPIRE_RISE_MOD_DETAIL_HELP7"), 
Locale.ConvertTextKey( "TXT_KEY_MOD_EMPIRE_RISE_MOD_DETAIL_HELP8"),
Locale.ConvertTextKey( "TXT_KEY_MOD_EMPIRE_RISE_MOD_DETAIL_HELP9"),  
}

local CreditsInstanceManager = InstanceManager:new("CreditsInstance", "Box", Controls.CreditsStack)
local errMessage = ""
for i, str in ipairs(pCredits) do
    local errMessage =errMessage .. "[NEWLINE]" .. str;
	local pCredit = CreditsInstanceManager:GetInstance()
	pCredit.Label:SetText(errMessage)
	--pCredit.Label:SetToolTipString(str)
end

Controls.CreditsStack:CalculateSize();
Controls.CreditsStack:ReprocessAnchoring();
Controls.CreditsPanel:CalculateInternalSize();




local function InputHandler(uiMsg, wParam, lParam)
    if uiMsg == KeyEvents.KeyDown then
        if wParam == Keys.VK_ESCAPE then
			if not Controls.EA_Welcome:IsHidden() then
				Hide()
				return true
			end
        end
		if wParam == Keys.VK_RETURN then
			if not Controls.EA_Welcome:IsHidden() then
				Hide()
				return true
			end
        end
    end
end
ContextPtr:SetInputHandler(InputHandler);



function OnDisplay()
	Controls.BGBlock:SetHide(false)
	Controls.EA_Welcome:SetHide(false)
end

function OnAdditionalInformationDropdownGatherEntries(additionalEntries)
  table.insert(additionalEntries, {text=Locale.ConvertTextKey("TXT_KEY_MOD_EMPIRE_RISE_MOD_CORNER_HOOK"), call=OnDisplay})
end
LuaEvents.AdditionalInformationDropdownGatherEntries.Add(OnAdditionalInformationDropdownGatherEntries)
LuaEvents.RequestRefreshAdditionalInformationDropdownEntries()
