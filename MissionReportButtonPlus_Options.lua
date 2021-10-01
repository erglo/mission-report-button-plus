--------------------------------------------------------------------------------
--[[ Mission Report Button Plus - Interface Options ]]--
--
-- by erglo <erglo.coder@gmail.com>
--
-- Copyright (C) 2021  Erwin D. Glockner (aka erglo)
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see http://www.gnu.org/licenses.
--
-- Files used for reference:
-- REF.: <FrameXML/InterfaceOptionsFrame.lua>
-- REF.: <FrameXML/InterfaceOptionsPanels.lua>
-- REF.: <FrameXML/OptionsPanelTemplates.lua>
-- REF.: <FrameXML/UIDropDownMenu.lua>
-- 
--------------------------------------------------------------------------------

local AddonID, ns = ...;
local L = ns.L;
local _log = ns.dbg_logger;

----- User settings ------------------------------------------------------------

ns.settings = {};  --> user settings
ns.defaultSettings = {  --> default + fallback settings
	["showAddonNameInTooltip"] = true,
	["showChatNotifications"] = true,
	["menuStyleID"] = "1",
	["preferExpansionName"] = true,
	["showMissionCompletedHint"] = true,
	["showMissionCompletedHintOnlyForAll"] = false,
	["showEntryTooltip"] = true,
	["showMissionCountInTooltip"] = true,
	["reverseSortorder"] = false,
	["showMissionTypeIcons"] = true,
	-- ["preferGlobalSettings"] = true,						--> TODO
	["activeMenuEntries"] = {"5", "6", "7", "8", "9"},
	["showWorldmapBounties"] = true,
	["showWorldmapThreats"] = true,
};

local function LoadSettings()
	--
	-- Loads the global or character-specific settings.
	--
	-- REF.: <FrameXML/TableUtil.lua>
	--
	_log:info("Loading settings...");
	if (MRBP_GlobalSettings == nil) then
		MRBP_GlobalSettings = CopyTable(ns.defaultSettings);
	end
	-- if (not MRBP_GlobalSettings.preferGlobalSettings) then
		-- -- Load character-specific settings
		-- if (MRBP_PerCharSettings == nil) then
			-- MRBP_PerCharSettings = CopyTable(MRBP_GlobalSettings);
		-- end
		-- ns.settings = MRBP_PerCharSettings;
		-- _log:debug("--> character-specific");
	-- else
	-- Load global settings
	ns.settings = MRBP_GlobalSettings;
	_log:debug("--> account-specific (global)");
	-- end
	
	--[[ Settings table maintenance ]]--
	
	-- Fill missing settings with default settings
	for key, value in pairs(ns.defaultSettings) do
		if ( ns.settings[key] == nil ) then
			ns.settings[key] = value;
			_log:debug("Added new default setting:", key);
		end
	end
	
	-- Clean-up old settings from the saved variables
	for key, value in pairs(ns.settings) do
		if ( ns.defaultSettings[key] == nil ) then
			ns.settings[key] = nil;
			_log:debug("Removed old setting:", key);
		end
	end
end

local function printOption(text, isEnabled)
	-- Print a user-friendly chat message about the currently selected setting.
	ns.cprint(text, "-", NORMAL_FONT_COLOR:WrapTextInColorCode(isEnabled and 
		   VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED)
	); 	   --> WoW global strings
end

local function CheckButton_SetValue(control, value, isRefreshing)
	--
	-- Set given value to a checkbutton, but only on manual change.
	-- Note:
	-- 'value' is for some reason a binary string value. This function changes
	-- it into a real boolean value.
	--
	local booleanValue = value and value ~= "0";
	control.newValue = booleanValue;
	control:SetChecked(booleanValue);
	
	_log:debug("value:", value, "-->", booleanValue, control:GetValue());
	-- print("value:", value, "-->", booleanValue, control:GetValue());
	
	if ( ns.settings.showChatNotifications and not isRefreshing ) then
		printOption(control.text:GetText(), booleanValue);
	end
	if ( control.varname == "showChatNotifications" and not isRefreshing ) then
		if not booleanValue then
			printOption(control.text:GetText(), booleanValue);
			_log.level = _log.NOTSET;  --> silent
		else
			_log.level = _log.USER;  --> verbose
			printOption(control.text:GetText(), booleanValue);
		end
	end
	
	ns.settings[control.varname] = booleanValue;
	--> for user preview only; this will be undone, when user clicks "Cancel".
end

local function CheckButton_GetValue(control)
	--
	-- Converts binary string values to real boolean values.
	--
	local binaryStringValue = BlizzardOptionsPanel_CheckButton_GetSetting(control);
	local booleanValue = binaryStringValue and binaryStringValue ~= "0";
	
	_log:debug("GetValue:", binaryStringValue, type(binaryStringValue), "-->", booleanValue, type(booleanValue));
	
	return booleanValue;
end

--[[ Interface options ]]--

MRBP_InterfaceOptionsPanel = CreateFrame("Frame", "MissionReportButtonPlusInterfaceOptionsFrame");

function MRBP_InterfaceOptionsPanel:Initialize()
	----------------------------------------------------------------------------
	-- Main Interface Options
	-- 
	-- REF.: <FrameXML/InterfaceOptionsFrame.lua>
	----------------------------------------------------------------------------
	local _, addonTitle, addonNotes = GetAddOnInfo(AddonID);
	local panelContainerWidth = InterfaceOptionsFramePanelContainer:GetWidth() - 32;
	
	self.name = addonTitle;
	self.labelTitle = addonTitle;
	self.labelDesc = addonNotes;
	self.okay = 
		function(self)
			-- Optional function
			-- This method will run when the player clicks "okay" in the Interface Options.
			_log:info("Applying changed options...", #self.controls);
			
			for i, control in ipairs(self.controls) do
				if ( control.newValue ) then
					control.value = control.newValue;
					control.newValue = nil;
					_log:debug(i, "Ok:", control:GetValue(), control.newValue);
				end
			end
			MRBP_GlobalSettings = ns.settings;  --> save changes
		end
	self.cancel =
		function (self)
			-- Optional function
			-- This method will run when the player clicks "cancel" in the Interface Options.
			-- Use this to revert their changes.
			_log:info("Restoring changed options...", #self.controls);
			
			for i, control in ipairs(self.controls) do
				if ( control.newValue ) then
					ns.settings[control.varname] = control.value;  --> previous value
					control.newValue = nil;
					_log:debug(i, "N-Ok:", control:GetValue(), control.newValue);
				end
			end
			ns.settings = MRBP_GlobalSettings;
		end
	self.default = 
		function(self)
			-- Optional function
			-- This method will run when the player clicks "defaults". Use this to revert their changes to your defaults.
			_log:info("Using default options...", #self.controls);
			
			MRBP_GlobalSettings = nil;
			ns.settings = {};
			LoadSettings();
		end
	self.refresh = 
		function(self)
			-- Optional function
			-- This method will run when the Interface Options frame calls its OnShow function and after defaults
			-- have been applied via the panel.default method described above.
			-- Use this to refresh your panel's UI in case settings were changed without player interaction.
			_log:info("Refreshing options...", #self.controls);
			
			local isRefreshing = true;
			for i, control in ipairs(self.controls) do
				if ( control.type == CONTROLTYPE_CHECKBOX ) then
					control.value = ns.settings[control.varname];
					control:SetValue(control.value, isRefreshing);
					_log:debug(i, control.varname, ns.settings[control.varname], control.value);
					if control.dependentControls then
						-- BlizzardOptionsPanel_SetDependentControlsEnabled(control, control:GetChecked());
						for _, subcontrol in ipairs(control.dependentControls) do
							if control:GetChecked() then
								local isWhiteColor = true;
								BlizzardOptionsPanel_CheckButton_Enable(subcontrol, isWhiteColor);
							else
								BlizzardOptionsPanel_CheckButton_Disable(subcontrol);
							end
						end
					end
				elseif ( control.type == CONTROLTYPE_DROPDOWN ) then
					ns.settings[control.varname] = ns.settings[control.varname];
					control:RefreshValue();
					-- BlizzardOptionsPanel_DropDown_Refresh(control);
				end
			end
		end
	
	InterfaceOptions_AddCategory(self);
	
	LoadSettings();
	
	--[[ Add-on infos ]]--
	
	local mainTitle = self:CreateFontString(self:GetName().."Title", "ARTWORK", "GameFontNormalLarge");
	mainTitle:SetJustifyH("LEFT");
	mainTitle:SetJustifyV("TOP");
	mainTitle:SetPoint("TOPLEFT", 16, -16);
	mainTitle:SetText(self.labelTitle);
	
	local mainSubText = self:CreateFontString(self:GetName().."SubText", "ARTWORK", "GameFontHighlightSmall");
	mainSubText:SetJustifyH("LEFT");
	mainSubText:SetJustifyV("TOP");
	mainSubText:SetHeight(22);
	mainSubText:SetNonSpaceWrap(true);
	mainSubText:SetMaxLines(2);
	mainSubText:SetPoint("TOPLEFT", mainTitle, "BOTTOMLEFT", 0, -8);
	mainSubText:SetPoint("RIGHT", -32, 0);
	mainSubText:SetText(string.gsub(self.labelDesc, "[|\\]n", " "));  --> replace line break with space
	
	-- Show user some infos about this add-on.
	local addonInfos = {
		--> label, tag
		{L.CFG_ADDONINFOS_VERSION, "Version"},
		{L.CFG_ADDONINFOS_AUTHOR, "Author"},
		{L.CFG_ADDONINFOS_EMAIL, "X-Email"},
		{L.CFG_ADDONINFOS_HOMEPAGE, "X-Project-Homepage"},
		{L.CFG_ADDONINFOS_LICENSE, "X-License"},
	};
	local parentFrame = mainSubText;
	local labelText, infoLabel;
	
	for _, infos in ipairs(addonInfos) do
		labelText, infoLabel = infos[1], infos[2];
		local metaLabel = self:CreateFontString(self:GetName()..infoLabel.."Label", "ARTWORK", "GameFontNormalSmall");
		metaLabel:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 0, -8);
		metaLabel:SetWidth(panelContainerWidth/4);
		metaLabel:SetJustifyH("RIGHT");
		metaLabel:SetText( NORMAL_FONT_COLOR:WrapTextInColorCode(labelText..HEADER_COLON) );  --> WoW global string
		
		local metaValue = self:CreateFontString(self:GetName()..infoLabel.."Value", "ARTWORK", "GameFontHighlightSmall");
		metaValue:SetPoint("LEFT", metaLabel, "RIGHT", 4, 0);
		metaValue:SetWidth(panelContainerWidth/1.5);
		metaValue:SetJustifyH("LEFT");
		metaValue:SetText( GetAddOnMetadata(AddonID, infoLabel) );

		parentFrame = metaLabel;
	end
	
	-- --[[ Individual / Account-wide option settings ]]--
	
	-- -- TODO - Separate settings; global vs. per-char
	
	-- -- <Interface/AddOns/Blizzard_BindingUI/Blizzard_BindingUI.xml#L158>
	-- local perCharButton = CreateFrame("CheckButton", self:GetName().."perCharButton", self, "UICheckButtonTemplate");
	-- perCharButton:SetSize(20, 20);
	-- perCharButton:SetPoint("TOPLEFT", self, "TOPRIGHT", -245, 20);
	-- perCharButton:SetHitRectInsets(0, -100, 0, 0);
	-- perCharButton.text = _G[perCharButton:GetName().."Text"];
	-- perCharButton.text:SetText( HIGHLIGHT_FONT_COLOR:WrapTextInColorCode("Individuelle Addon-Einstellungen") );
	-- perCharButton:SetScript("OnClick", function(self, button, isDown)
		-- if (self.enabled) then
			-- PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		-- else
			-- PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		-- end
	-- end);
	-- perCharButton:SetScript("OnEnter", function(self)
		-- GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		-- GameTooltip:SetText(CHARACTER_SPECIFIC_KEYBINDING_TOOLTIP.."|n(Not yet implemented!)", nil, nil, nil, nil, true);	--> TODO
	-- end);
	-- perCharButton:SetScript("OnLeave", GameTooltip_Hide);
		
	local separatorTexture = self:CreateTexture(self:GetName().."Separator", "ARTWORK");
	separatorTexture:SetSize(panelContainerWidth, 1);
	separatorTexture:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 0, -16);
	separatorTexture:SetColorTexture(0.25, 0.25, 0.25);
		
	--[[ General settings ]]--
	
	local addonNameCB = CreateFrame("CheckButton", self:GetName().."AddonNameCB", self, "InterfaceOptionsCheckButtonTemplate");
	addonNameCB:SetPoint("TOPLEFT", separatorTexture, "BOTTOMLEFT", 0, -16);
	addonNameCB.type = CONTROLTYPE_CHECKBOX;
	addonNameCB.text = _G[addonNameCB:GetName().."Text"];
	addonNameCB.text:SetText(L.CFG_BUTTONTOOLTIP_SHOW_ABBREV_TEXT);
	addonNameCB.tooltipText = L.CFG_BUTTONTOOLTIP_SHOW_ABBREV_TOOLTIP;
	addonNameCB.varname = "showAddonNameInTooltip";  --> Links this checkbutton with a saved variable
	addonNameCB.value = ns.settings[addonNameCB.varname];
	addonNameCB.GetValue = CheckButton_GetValue;
	addonNameCB.SetValue = CheckButton_SetValue;
	BlizzardOptionsPanel_RegisterControl(addonNameCB, self);
	
	local chatMsgCB = CreateFrame("CheckButton", self:GetName().."ChatMsgCB", self, "InterfaceOptionsCheckButtonTemplate");
	chatMsgCB:SetPoint("TOPLEFT", addonNameCB, "BOTTOMLEFT", 0, -8);
	chatMsgCB.type = CONTROLTYPE_CHECKBOX;
	chatMsgCB.text = _G[chatMsgCB:GetName().."Text"];
	chatMsgCB.text:SetText(L.CFG_CHAT_NOTIFY_TEXT);
	chatMsgCB.tooltipText = L.CFG_CHAT_NOTIFY_TOOLTIP;
	chatMsgCB.varname = "showChatNotifications";
	chatMsgCB.value = ns.settings[chatMsgCB.varname];
	chatMsgCB.GetValue = CheckButton_GetValue;
	chatMsgCB.SetValue = CheckButton_SetValue;
	BlizzardOptionsPanel_RegisterControl(chatMsgCB, self);

	-- TODO - Hide WoD garrison invasion badge (GarrisonLandingPage.InvasionBadge)
	
	--[[ Dropdown menu settings ]]--
	
	local dropdownHeading = self:CreateFontString(self:GetName().."DropdownHeading", "ARTWORK", "GameFontNormal");
	dropdownHeading:SetPoint("TOPLEFT", chatMsgCB, "BOTTOMLEFT", 0, -16);
	dropdownHeading:SetJustifyH("LEFT");
	dropdownHeading:SetJustifyV("TOP");
	dropdownHeading:SetText(L.CFG_DDMENU_SEPARATOR_HEADING);
	
	local sepTexDropdown = self:CreateTexture(self:GetName().."DropdownSeparator", "ARTWORK");
	sepTexDropdown:SetSize(panelContainerWidth-dropdownHeading:GetWidth()-8, 1);
	sepTexDropdown:SetPoint("LEFT", dropdownHeading, "RIGHT", 8, 0);
	sepTexDropdown:SetColorTexture(0.25, 0.25, 0.25);
	
	local entryNameCB = CreateFrame("CheckButton", self:GetName().."EntryNameCB", self, "InterfaceOptionsCheckButtonTemplate");
	entryNameCB:SetPoint("TOPLEFT", dropdownHeading, "BOTTOMLEFT", 0, -16);
	entryNameCB.type = CONTROLTYPE_CHECKBOX;
	entryNameCB.text = _G[entryNameCB:GetName().."Text"];
	entryNameCB.text:SetText(L.CFG_DDMENU_NAMING_TEXT);
	entryNameCB.tooltipText = L.CFG_DDMENU_NAMING_TOOLTIP;
	entryNameCB.varname = "preferExpansionName";
	entryNameCB.value = ns.settings[entryNameCB.varname];
	entryNameCB.GetValue = CheckButton_GetValue;
	entryNameCB.SetValue = CheckButton_SetValue;
	BlizzardOptionsPanel_RegisterControl(entryNameCB, self);
	
	local sortorderCB = CreateFrame("CheckButton", self:GetName().."SortorderCB", self, "InterfaceOptionsCheckButtonTemplate");
	sortorderCB:SetPoint("TOPLEFT", entryNameCB, "BOTTOMLEFT", 0, -8);
	sortorderCB.type = CONTROLTYPE_CHECKBOX;
	sortorderCB.text = _G[sortorderCB:GetName().."Text"];
	sortorderCB.text:SetText(L.CFG_DDMENU_SORTORDER_TEXT);
	sortorderCB.tooltipText = L.CFG_DDMENU_SORTORDER_TOOLTIP;
	sortorderCB.varname = "reverseSortorder";
	sortorderCB.value = ns.settings[sortorderCB.varname];
	sortorderCB.GetValue = CheckButton_GetValue;
	sortorderCB.SetValue = CheckButton_SetValue;
	BlizzardOptionsPanel_RegisterControl(sortorderCB, self);
	
	local missionReportIconCB = CreateFrame("CheckButton", self:GetName().."MissionReportIconCB", self, "InterfaceOptionsCheckButtonTemplate");
	missionReportIconCB:SetPoint("TOPLEFT", sortorderCB, "BOTTOMLEFT", 0, -8);
	missionReportIconCB.type = CONTROLTYPE_CHECKBOX;
	missionReportIconCB.text = _G[missionReportIconCB:GetName().."Text"];
	missionReportIconCB.text:SetText(L.CFG_DDMENU_REPORTICONS_TEXT);
	missionReportIconCB.tooltipText = L.CFG_DDMENU_REPORTICONS_TOOLTIP;
	missionReportIconCB.varname = "showMissionTypeIcons";
	missionReportIconCB.value = ns.settings[missionReportIconCB.varname];
	missionReportIconCB.GetValue = CheckButton_GetValue;
	missionReportIconCB.SetValue = CheckButton_SetValue;
	BlizzardOptionsPanel_RegisterControl(missionReportIconCB, self);
	
	local entryHintCB = CreateFrame("CheckButton", self:GetName().."EntryHintCB", self, "InterfaceOptionsCheckButtonTemplate");
	entryHintCB:SetPoint("TOPLEFT", missionReportIconCB, "BOTTOMLEFT", 0, -8);
	entryHintCB.type = CONTROLTYPE_CHECKBOX;
	entryHintCB.text = _G[entryHintCB:GetName().."Text"];
	entryHintCB.text:SetText(L.CFG_DDMENU_ICONHINT_TEXT);
	entryHintCB.tooltipText = L.CFG_DDMENU_ICONHINT_TOOLTIP;
	entryHintCB.varname = "showMissionCompletedHint";
	entryHintCB.value = ns.settings[entryHintCB.varname];
	entryHintCB.GetValue = CheckButton_GetValue;
	entryHintCB.SetValue = CheckButton_SetValue;
	BlizzardOptionsPanel_RegisterControl(entryHintCB, self);
	
	local entryHintAllCB = CreateFrame("CheckButton", self:GetName().."EntryHintAllCB", self, "InterfaceOptionsCheckButtonTemplate");
	entryHintAllCB:SetPoint("TOPLEFT", entryHintCB, "BOTTOMLEFT", 16, -8);
	entryHintAllCB.type = CONTROLTYPE_CHECKBOX;
	entryHintAllCB.text = _G[entryHintAllCB:GetName().."Text"];
	entryHintAllCB.text:SetText(L.CFG_DDMENU_ICONHINTALL_TEXT);
	entryHintAllCB.tooltipText = L.CFG_DDMENU_ICONHINTALL_TOOLTIP;
	entryHintAllCB.varname = "showMissionCompletedHintOnlyForAll";
	entryHintAllCB.value = ns.settings[entryHintAllCB.varname];
	entryHintAllCB.GetValue = CheckButton_GetValue;
	entryHintAllCB.SetValue = CheckButton_SetValue;
	BlizzardOptionsPanel_RegisterControl(entryHintAllCB, self);
	BlizzardOptionsPanel_SetupDependentControl(entryHintCB, entryHintAllCB);
	
	local entryTooltipCB = CreateFrame("CheckButton", self:GetName().."EntryTooltipCB", self, "InterfaceOptionsCheckButtonTemplate");
	entryTooltipCB:SetPoint("TOPLEFT", entryHintAllCB, "BOTTOMLEFT", -16, -8);
	entryTooltipCB.type = CONTROLTYPE_CHECKBOX;
	entryTooltipCB.text = _G[entryTooltipCB:GetName().."Text"];
	entryTooltipCB.text:SetText(L.CFG_DDMENU_ENTRYTOOLTIP_SHOW_TEXT);
	entryTooltipCB.tooltipText = L.CFG_DDMENU_ENTRYTOOLTIP_SHOW_TOOLTIP;
	entryTooltipCB.varname = "showEntryTooltip";
	entryTooltipCB.value = ns.settings[entryTooltipCB.varname];
	entryTooltipCB.GetValue = CheckButton_GetValue;
	entryTooltipCB.SetValue = CheckButton_SetValue;
	BlizzardOptionsPanel_RegisterControl(entryTooltipCB, self);
	
	local entryTooltipInProgressCB = CreateFrame("CheckButton", self:GetName().."EntryTooltipInProgressCB", self, "InterfaceOptionsCheckButtonTemplate");
	entryTooltipInProgressCB:SetPoint("TOPLEFT", entryTooltipCB, "BOTTOMLEFT", 16, -8);
	entryTooltipInProgressCB.type = CONTROLTYPE_CHECKBOX;
	entryTooltipInProgressCB.text = _G[entryTooltipInProgressCB:GetName().."Text"];
	entryTooltipInProgressCB.text:SetText(L.CFG_DDMENU_ENTRYTOOLTIP_INPROGRESS_TEXT);
	entryTooltipInProgressCB.tooltipText = L.CFG_DDMENU_ENTRYTOOLTIP_INPROGRESS_TOOLTIP;
	entryTooltipInProgressCB.varname = "showMissionCountInTooltip";
	entryTooltipInProgressCB.value = ns.settings[entryTooltipInProgressCB.varname];
	entryTooltipInProgressCB.GetValue = CheckButton_GetValue;
	entryTooltipInProgressCB.SetValue = CheckButton_SetValue;
	BlizzardOptionsPanel_RegisterControl(entryTooltipInProgressCB, self);
	BlizzardOptionsPanel_SetupDependentControl(entryTooltipCB, entryTooltipInProgressCB);

	local entryTooltipBountiesCB = CreateFrame("CheckButton", self:GetName().."EntryTooltipBountiesCB", self, "InterfaceOptionsCheckButtonTemplate");
	entryTooltipBountiesCB:SetPoint("TOPLEFT", entryTooltipInProgressCB, "BOTTOMLEFT", 0, -8);
	entryTooltipBountiesCB.type = CONTROLTYPE_CHECKBOX;
	entryTooltipBountiesCB.text = _G[entryTooltipBountiesCB:GetName().."Text"];
	entryTooltipBountiesCB.text:SetText("Show active bounties");
	entryTooltipBountiesCB.tooltipText = "Aactive bounties tooltip...";  	-- TODO - L10n
	entryTooltipBountiesCB.varname = "showWorldmapBounties";
	entryTooltipBountiesCB.value = ns.settings[entryTooltipBountiesCB.varname];
	entryTooltipBountiesCB.GetValue = CheckButton_GetValue;
	entryTooltipBountiesCB.SetValue = CheckButton_SetValue;
	BlizzardOptionsPanel_RegisterControl(entryTooltipBountiesCB, self);
	BlizzardOptionsPanel_SetupDependentControl(entryTooltipCB, entryTooltipBountiesCB);
	
	local entryTooltipThreatsCB = CreateFrame("CheckButton", self:GetName().."EntryTooltipThreatsCB", self, "InterfaceOptionsCheckButtonTemplate");
	entryTooltipThreatsCB:SetPoint("TOPLEFT", entryTooltipBountiesCB, "BOTTOMLEFT", 0, -8);
	entryTooltipThreatsCB.type = CONTROLTYPE_CHECKBOX;
	entryTooltipThreatsCB.text = _G[entryTooltipThreatsCB:GetName().."Text"];
	entryTooltipThreatsCB.text:SetText("Show active threats");
	entryTooltipThreatsCB.tooltipText = "Active threats tooltip...";  		-- TODO - L10n
	entryTooltipThreatsCB.varname = "showWorldmapThreats";
	entryTooltipThreatsCB.value = ns.settings[entryTooltipThreatsCB.varname];
	entryTooltipThreatsCB.GetValue = CheckButton_GetValue;
	entryTooltipThreatsCB.SetValue = CheckButton_SetValue;
	BlizzardOptionsPanel_RegisterControl(entryTooltipThreatsCB, self);
	BlizzardOptionsPanel_SetupDependentControl(entryTooltipCB, entryTooltipThreatsCB);
	
	--[[ Meny entries selection dropdown ]]--
	
	local menuEntriesDD = CreateFrame("Frame", self:GetName().."MenuEntriesDropDown", self, "UIDropDownMenuTemplate");
	menuEntriesDD.type = CONTROLTYPE_DROPDOWN;
	menuEntriesDD.label = menuEntriesDD:CreateFontString(menuEntriesDD:GetName().."Label", "BACKGROUND", "GameFontNormal");
	menuEntriesDD.label:SetPoint("TOPLEFT", entryNameCB.text, "TOPLEFT", panelContainerWidth/2, 0);
	menuEntriesDD.label:SetText(L.CFG_DDMENU_ENTRYSELECTION_LABEL);
	menuEntriesDD.tooltipText = L.CFG_DDMENU_ENTRYSELECTION_TOOLTIP;
	menuEntriesDD:SetPoint("TOPLEFT", menuEntriesDD.label, "BOTTOMLEFT", -16, -3);
	menuEntriesDD.varname = "activeMenuEntries";  --> Links checkbutton with saved variable
	-- menuEntriesDD.defaultValue = ns.defaultSettings[menuEntriesDD.varname];
	-- menuEntriesDD.oldValue = ns.settings[menuEntriesDD.varname];
	menuEntriesDD.value = ns.settings[menuEntriesDD.varname];
	-- menuEntriesDD.GetValue = function(self) return ns.settings[self.varname]; end;
	-- menuEntriesDD.SetValue = function (self, value) ns.settings[self.varname] = CopyTable(value); end;
	menuEntriesDD.RefreshValue =
		function(self)
			UIDropDownMenu_Initialize(self, MenuEntriesSelectionDropDown_Initialize);
			UIDropDownMenu_SetText(self, format(L.CFG_DDMENU_ENTRYSELECTION_TEXT_D, #ns.settings[self.varname]));
		end
	menuEntriesDD:SetScript("OnEnter", function(self)
		if ( not self.isDisabled ) then
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true);
		end
	end);
	menuEntriesDD:SetScript("OnLeave", GameTooltip_Hide);
	BlizzardOptionsPanel_RegisterControl(menuEntriesDD, self);
	-- menuEntriesDD:RegisterEvent("PLAYER_ENTERING_WORLD");
	-- BlizzardOptionsPanel_SetupDependentControl(entryTooltipCB, menuEntriesDD);
		
	local expansionNames = {
	          -- placeholder,   --> "Classic"
		nil,  -- placeholder1,  --> "The Burning Crusade"
		nil,  -- placeholder2,  --> "Wrath of the Lich King"
		nil,  -- placeholder3,  --> "Cataclysm"
		nil,  -- placeholder4,  --> "Mists of Pandaria"
		EXPANSION_NAME5,  --> "Warlords of Draenor"
		EXPANSION_NAME6,  --> "Legion"
		EXPANSION_NAME7,  --> "Battle for Azeroth"
		EXPANSION_NAME8,  --> "Shadowlands"
		"[ "..SETTINGS.." ]",  --> Additional "Settings" menu entry; WoW global string
	};
	--> Do NOT remove the placeholders! The position (index) of each expansion
	--  name is equal to the expansion ID which is used in the core file. The
	--  "Settings" entry is the extra value (latest expansion ID + 1) .
	ns.settingsMenuEntry = tostring(#expansionNames);
	
	local function MenuEntriesSelectionDropDown_OnClick(self)
		--
		-- Note: 'self' refers to the currently clicked menu entry frame.
		--
		local selectedValue = self.value;
		
		if ( not tContains(ns.settings.activeMenuEntries, selectedValue) ) then
			-- Add to the selection list
			tinsert(ns.settings.activeMenuEntries, selectedValue);
		else
			-- Remove value from the selection list
			for i, value in pairs(ns.settings.activeMenuEntries) do
				if (selectedValue == value) then
					tremove(ns.settings.activeMenuEntries, i);
				end
			end
		end
		
		printOption(expansionNames[tonumber(selectedValue)], self.checked);
		_log:debug("selectedMenuEntries:", unpack(ns.settings.activeMenuEntries));
		
		if ( #ns.settings.activeMenuEntries < 1 ) then
			-- Without any menu items the dropdown menu won't show up, so inform user
			local warningText = RED_FONT_COLOR:WrapTextInColorCode(L.CFG_DDMENU_ENTRYSELECTION_TEXT_WARNING);
			ns.cprint(warningText);
			UIDropDownMenu_SetText(menuEntriesDD, warningText);
		else
			UIDropDownMenu_SetText(menuEntriesDD, format(L.CFG_DDMENU_ENTRYSELECTION_TEXT_D, #ns.settings.activeMenuEntries));
		end
	end
	
	local function MenuEntriesSelectionDropDown_Initialize(self)
		--
		-- Create the selection dropdown for the menu entries
		--
		local info = UIDropDownMenu_CreateInfo();
		
		for i, name in pairs(expansionNames) do
			if name then  --> ignore placeholders
				info.text = name;
				info.func = MenuEntriesSelectionDropDown_OnClick;
				info.value = tostring(i);
				info.isNotRadio = 1;
				info.keepShownOnClick = 1;
				if tContains(ns.settings.activeMenuEntries, info.value) then
					info.checked = 1;
				else
					info.checked = nil;
				end
				UIDropDownMenu_AddButton(info);
			end
		end
		UIDropDownMenu_AddSeparator()
		-- TODO - Add un-/checking options
		info.text = CHECK_ALL;  --> WoW global string
		info.value = "all";
		info.notCheckable = 1;
		info.keepShownOnClick = 1;
		info.justifyH = "CENTER";
		info.colorCode = NORMAL_FONT_COLOR:GenerateHexColorMarkup();
		info.func = function(self)
			self.checked = nil;
			-- MenuEntriesSelectionDropDown_OnClick(self)
		end;
		UIDropDownMenu_AddButton(info);
		
		info.text = UNCHECK_ALL;  --> WoW global string
		info.func = nil;
		info.value = "none";
		info.notCheckable = 1;
		info.keepShownOnClick = 1;
		info.justifyH = "CENTER";
		info.colorCode = NORMAL_FONT_COLOR:GenerateHexColorMarkup();
		UIDropDownMenu_AddButton(info);
	end
	
	UIDropDownMenu_SetWidth(menuEntriesDD, panelContainerWidth/3);
	UIDropDownMenu_Initialize(menuEntriesDD, MenuEntriesSelectionDropDown_Initialize);
	-- UIDropDownMenu_SetText(menuEntriesDD, format(L.CFG_DDMENU_ENTRYSELECTION_TEXT_D, #ns.settings.activeMenuEntries));
	
	--[[ Border type selection dropdown ]]--
		
	local menuStyleDD = CreateFrame("Frame", self:GetName().."MenuStyleDropDown", self, "UIDropDownMenuTemplate");
	menuStyleDD.type = CONTROLTYPE_DROPDOWN;
	menuStyleDD.label = menuStyleDD:CreateFontString(menuStyleDD:GetName().."Label", "BACKGROUND", "GameFontNormal");
	menuStyleDD.label:SetPoint("TOPLEFT", menuEntriesDD, "BOTTOMLEFT", 16, -16);
	menuStyleDD.label:SetText(L.CFG_DDMENU_STYLESELECTION_LABEL);
	menuStyleDD.tooltipText = L.CFG_DDMENU_STYLESELECTION_TOOLTIP;
	menuStyleDD:SetPoint("TOPLEFT", menuStyleDD.label, "BOTTOMLEFT", -16, -3);
	menuStyleDD.varname = "menuStyleID";  --> Links checkbutton with saved variable
	-- menuStyleDD.defaultValue = ns.defaultSettings[menuStyleDD.varname];
	menuStyleDD.value = ns.settings[menuStyleDD.varname];
	menuStyleDD.RefreshValue =
		function(self)
			-- BlizzardOptionsPanel_DropDown_Refresh(self);
			-- UIDropDownMenu_Initialize(self, BorderSelectionDropDown_Initialize);
			-- UIDropDownMenu_SetSelectedValue(self, ns.settings[self.varname]);
			-- UIDropDownMenu_SetSelectedValue(self, self.value);
			-- print("RefreshValue:", ns.settings[self.varname], self.value);
		end
	menuStyleDD:SetScript("OnEnter", function(self)
		if ( not self.isDisabled ) then
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true);
		end
	end);
	menuStyleDD:SetScript("OnLeave", GameTooltip_Hide);
	BlizzardOptionsPanel_RegisterControl(menuStyleDD, self);
	
	local menuStyleNames = {
		L.CFG_DDMENU_STYLESELECTION_VALUE1_TEXT..GRAY_FONT_COLOR:WrapTextInColorCode(" ("..DEFAULT..")"),  --> WoW global string
		L.CFG_DDMENU_STYLESELECTION_VALUE2_TEXT,
	};
	
	local function BorderSelectionDropDown_OnClick(self)
		--
		-- Note: 'self' refers to the currently clicked menu entry frame.
		--
		ns.settings.menuStyleID = self.value;
		UIDropDownMenu_SetSelectedValue(menuStyleDD, self.value);
		ns.MRBP_ReloadDropdown();
		
		printOption(UIDropDownMenu_GetText(menuStyleDD), true);
		_log:debug("Menu style ID selected:", self.value);
	end
	
	local function BorderSelectionDropDown_Initialize(self)
		-- Create the border selection dropdown menu
		local selectedValue = UIDropDownMenu_GetSelectedValue(self) or ns.settings.menuStyleID;
		local info = UIDropDownMenu_CreateInfo();
		
		for i, styleName in ipairs(menuStyleNames) do
			info.text = styleName;
			info.func = BorderSelectionDropDown_OnClick;
			info.value = tostring(i);
			if (info.value == selectedValue) then
				info.checked = 1;
			else
				info.checked = nil;
			end			
			UIDropDownMenu_AddButton(info);
		end
	end
	
	UIDropDownMenu_SetWidth(menuStyleDD, panelContainerWidth/3);
	UIDropDownMenu_Initialize(menuStyleDD, BorderSelectionDropDown_Initialize);
	UIDropDownMenu_SetSelectedValue(menuStyleDD, ns.settings.menuStyleID);
end
