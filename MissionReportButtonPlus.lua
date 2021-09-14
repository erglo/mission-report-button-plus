--------------------------------------------------------------------------------
--[[ Mission Report Button Plus ]]--
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
--
-- Files used for reference:
-- REF.: <FrameXML/Blizzard_APIDocumentation/GarrisonConstantsDocumentation.lua>
-- REF.: <FrameXML/Blizzard_APIDocumentation/GarrisonInfoDocumentation.lua>
-- REF.: <FrameXML/GarrisonBaseUtils.lua>
-- REF.: <FrameXML/Minimap.lua>
-- REF.: <FrameXML/SharedColorConstants.lua>
-- REF.: <FrameXML/Blizzard_APIDocumentation/CovenantSanctumDocumentation.lua>
-- REF.: <FrameXML/Blizzard_GarrisonTemplates/Blizzard_GarrisonMissionTemplates.lua>
-- (see also the function comments section for more reference)
--
--------------------------------------------------------------------------------

local AddonID, ns = ...;
local L = ns.L;
local _log = ns.dbg_logger;
local util = ns.utilities;

local MRBP_EventMessagesCounter;

----- Main ---------------------------------------------------------------------

local MRBP = CreateFrame("Frame", AddonID.."ListenerFrame");  --> core functions + event listener

MRBP:SetScript("OnEvent", function(self, event, ...)
		-- print("event:", event, ...);
		
		if ( event == "ADDON_LOADED" ) then
			self:UnregisterEvent("ADDON_LOADED");
			
			local isEvent, event, eventMsg = util:IsTodayWorldQuestDayEvent();
			if isEvent then
				ns.cprint(eventMsg);
			end
			
			self:OnLoad();
			
		elseif ( event == "GARRISON_BUILDING_ACTIVATABLE" ) then
			-- REF. <FrameXML/Blizzard_GarrisonUI/Blizzard_GarrisonLandingPage.lua>
			local buildingName, garrisonType = ...;
			_log:debug(event, "buildingName:", buildingName, "garrisonType:", garrisonType);
			-- These messages appear too often, eg. every time the player teleports somewhere. This counter limits
			-- the number of these messages as follows:
			--     1x / log-in session if player was not in garrison zone
			--     1x / garrison
			if ( MRBP_EventMessagesCounter == nil ) then
				MRBP_EventMessagesCounter = {};
			end
			if ( MRBP_EventMessagesCounter[event] == nil ) then
				MRBP_EventMessagesCounter[event] = {};
			end
			if ( MRBP_EventMessagesCounter[event][garrisonType] == nil ) then
				MRBP_EventMessagesCounter[event][garrisonType] = {};
			end
			-----
			local garrInfo = MRBP_GetGarrisonData(garrisonType);
			local buildings = C_Garrison.GetBuildings(garrisonType);
			for i = 1, #buildings do
				local buildingID = buildings[i].buildingID;
				local name, texture, shipmentCapacity = C_Garrison.GetLandingPageShipmentInfo(buildingID);
				if ( name == buildingName ) then
					-- Add icon to building name
					buildingName = util:CreateTextIcon(texture).." "..buildingName;
					if ( MRBP_EventMessagesCounter[event][garrisonType][buildingID] == nil ) then
						MRBP_EventMessagesCounter[event][garrisonType][buildingID] = false;
					end
					if ( C_Garrison.IsPlayerInGarrison(garrisonType) or MRBP_EventMessagesCounter[event][garrisonType][buildingID] == false ) then
						util:cprintEvent(garrInfo.expansionInfo.name, GARRISON_BUILDING_COMPLETE, buildingName, GARRISON_FINALIZE_BUILDING_TOOLTIP);
						MRBP_EventMessagesCounter[event][garrisonType][buildingID] = true;
					else
						_log:debug("Skipped:", event, garrisonType, buildingID, name);
					end
					break;
				end
			end
			-- TODO - Count and show number of other activatable buildings ???
		
		elseif (event == "GARRISON_INVASION_AVAILABLE") then
			_log:debug(event, ...);
			--> Draenor garrison only
			local garrInfo = MRBP_GetGarrisonData(Enum.GarrisonType.Type_6_0);
			util:cprintEvent(garrInfo.expansionInfo.name, GARRISON_LANDING_INVASION, nil, GARRISON_LANDING_INVASION_TOOLTIP);
		
		elseif ( event == "GARRISON_MISSION_FINISHED" ) then
			-- REF.: <FrameXML/Blizzard_GarrisonUI/Blizzard_GarrisonMissionUI.lua>
			local followerTypeID, missionID = ...;
			local eventMsg = GarrisonFollowerOptions[followerTypeID].strings.ALERT_FRAME_TITLE;
			-- local instructionMsg = GarrisonFollowerOptions[followerTypeID].strings.LANDING_COMPLETE;
			local garrTypeID = GarrisonFollowerOptions[followerTypeID].garrisonType;
			local garrInfo = MRBP_GetGarrisonData(garrTypeID);
			local missionInfo = C_Garrison.GetBasicMissionInfo(missionID);
			local missionName = util:CreateTextIcon(missionInfo.typeAtlas).." "..missionInfo.name;
			_log:debug(event, "followerTypeID:", followerTypeID, "missionID:", missionID, missionInfo.name);
			if ( followerTypeID == Enum.GarrisonFollowerType.FollowerType_6_2 ) then
				-- Distinguish shipyard missions from the others
				missionName = missionName.." "..PARENS_TEMPLATE:format(missionInfo.type);
			end
			util:cprintEvent(garrInfo.expansionInfo.name, eventMsg, missionName);  -- , instructionMsg);
			-- TODO - Count and show number of other finished missions ???
			-- TODO - Remove from MRBP_GlobalMissions
		
		elseif (event == "GARRISON_TALENT_COMPLETE") then
			local garrTypeID, doAlert = ...;
			_log:debug(event, "garrTypeID:", garrTypeID, "doAlert:", doAlert);
			local followerTypeID = GetPrimaryGarrisonFollowerType(garrTypeID);
			local garrInfo = MRBP_GetGarrisonData(garrTypeID);
			local eventMsg = GarrisonFollowerOptions[followerTypeID].strings.TALENT_COMPLETE_TOAST_TITLE;
			-- REF. <FrameXML/Blizzard_GarrisonUI/Blizzard_GarrisonLandingPage.lua>
			local talentTreeIDs = C_Garrison.GetTalentTreeIDsByClassID(garrTypeID, select(3, UnitClass("player")));
			local completeTalentID = C_Garrison.GetCompleteTalent(garrTypeID);
			if (talentTreeIDs) then
				for treeIndex, treeID in ipairs(talentTreeIDs) do
					local treeInfo = C_Garrison.GetTalentTreeInfo(treeID);
					for talentIndex, talent in ipairs(treeInfo.talents) do
						if ( talent.isBeingResearched or talent.id == completeTalentID ) then
							-- SetupShipment(shipment, talent.icon, true, talent.name, nil, nil, nil, talent.isBeingResearched and 0 or 1, 1, talent.startTime, talent.researchDuration, SHIPMENT_TYPE_TALENT, shipmentIndex);
							local nameString = util:CreateTextIcon(talent.icon).." "..talent.name;
							util:cprintEvent(garrInfo.expansionInfo.name, eventMsg, nameString); -- [Aus den Trümmern]
						end
					end
				end
			-- elseif (doAlert) then
				-- util:cprintEvent(garrInfo.expansionInfo.name, eventMsg);
			end
			-- TODO - Count and show number of other completed talents ???
			
		elseif (event == "QUEST_TURNED_IN" or event == "QUEST_AUTOCOMPLETE") then
			-- REF.: <FrameXML/Blizzard_APIDocumentation/QuestLogDocumentation.lua>
			-- QUEST_TURNED_IN		  --> questID, xpReward, moneyReward = ...;
			-- QUEST_AUTOCOMPLETE	  --> questID = ...;
			-- local questID = ...;
			local questID = ...;
			local questName = QuestUtils_GetQuestName(questID) or C_QuestLog.GetTitleForQuestID(questID);
			_log:debug(event, questID, questName);
			if MRBP_IsQuestGarrisonRequirement(questID) then
				_log:info("Required quest completed!", questID, questName);
				-- TODO - Add 'is unlocked/complete' info to data table
			end
		end
	end
);

FrameUtil.RegisterFrameForEvents(MRBP, {
	"ADDON_LOADED",
	"GARRISON_BUILDING_ACTIVATABLE",
	"GARRISON_INVASION_AVAILABLE",
	"GARRISON_MISSION_FINISHED",
	"GARRISON_TALENT_COMPLETE",
	"QUEST_TURNED_IN",
	"QUEST_AUTOCOMPLETE",
	"GARRISON_MISSION_STARTED",
	}
);

function MRBP:OnLoad()
	--
	-- Load this add-on's functions when the MR minimap button is ready.
	--
	_log:info(string.format("Loading %s...", ns.AddonColor:WrapTextInColorCode(ns.AddonTitle)));
	
	-- LoadSettings();
	MRBP_InterfaceOptionsPanel:Initialize();

	self:RegisterSlashCommands();
	self:SetButtonHooks();
	
	-- Create the dropdown menu
	MRBP:LoadData();
	self:GarrisonLandingPageDropDown_OnLoad();
	
	_log:info("Addon is ready.");
end

-----[[ Data ]]-----------------------------------------------------------------

local MRBP_GARRISON_TYPE_INFOS = {};

local MRBP_GARRISON_TYPE_INFOS_SORTORDER = {
	Enum.GarrisonType.Type_9_0,
	Enum.GarrisonType.Type_8_0,
	Enum.GarrisonType.Type_7_0,
	Enum.GarrisonType.Type_6_0,
};

local MRBP_COMMAND_TABLE_UNLOCK_QUESTS = {
	-- questID, questName_English (fallback)
	[Enum.GarrisonType.Type_6_0] = {
		["Horde"] = {36614, "My Very Own Fortress"},
		["Alliance"] = {36615, "My Very Own Castle"},
		["reqLevel"] = 40,	--> Source: WoW (2021-09)
	},
	[Enum.GarrisonType.Type_7_0] = {
		["WARRIOR"] = {40585, "Thus Begins the War"},
		["PALADIN"] = {39696, "Rise, Champions"},
		["HUNTER"] = {42519, "Rise, Champions"},
		["ROGUE"] = {42139, "Rise, Champions"},
		["PRIEST"] = {43270, "Rise, Champions"},
		["DEATHKNIGHT"] = {43264, "Rise, Champions"},
		["SHAMAN"] = {42383, "Rise, Champions"},
		["MAGE"] = {42663, "Rise, Champions"},
		["WARLOCK"] = {42608, "Rise, Champions"},
		["MONK"] = {42187, "Rise, Champions"},
		["DRUID"] = {42583, "Rise, Champions"},
		["DEMONHUNTER"] = {42670, "Rise, Champions"},
		["reqLevel"] = 10,  --> Source: Wowhead.com (2021-09)
	},
	[Enum.GarrisonType.Type_8_0] = {
		["Horde"] = {51771, "War of Shadows"},
		["Alliance"] = {51715, "War of Shadows"},
		["reqLevel"] = 35,  --> Source: Wowhead.com (2021-09)
	},
	[Enum.GarrisonType.Type_9_0] = {
		[Enum.CovenantType.Kyrian] = {57878, "Choosing Your Purpose"},
		[Enum.CovenantType.Venthyr] = {57878, "Choosing Your Purpose"},
		[Enum.CovenantType.NightFae] = {57878, "Choosing Your Purpose"},
		[Enum.CovenantType.Necrolord] = {57878, "Choosing Your Purpose"},
		["reqLevel"] = 60,	--> Source: WoW (2021-09)
	},
}

function MRBP:LoadData()
	--
	-- Preparing these data on start-up results sometimes, eg. the covenant
	-- data, in empty (nil) values. So simply load this after the add-on has
	-- been loaded and before the dropdown menu will be created.
	--
	-- REF.: <FrameXML/GarrisonBaseUtils.lua>
	-- 
	_log:info("Preparing data tables...");
	
	local factionGroup = UnitFactionGroup("player");  --> for Draenor and BfA icon
	local _, className = UnitClass("player");  --> for Legion icon
	local covenantData = C_Covenants.GetCovenantData(C_Covenants.GetActiveCovenantID()); --> for Shadowlands icon
	local covenantTex = covenantData and covenantData.textureKit or "kyrian";
	local covenantID = covenantData and covenantData.ID or Enum.CovenantType.Kyrian;

	MRBP_GARRISON_TYPE_INFOS = {
		-----[[ Warlords of Draenor ]]-----
		[Enum.GarrisonType.Type_6_0] = {
			-- ["name"] = GARRISON_LOCATION_TOOLTIP,
			["title"] = GARRISON_LANDING_PAGE_TITLE,
			["description"] = MINIMAP_GARRISON_LANDING_PAGE_TOOLTIP,
			["minimapIcon"] = string.format("GarrLanding-MinimapIcon-%s-Up", factionGroup),
			-- ["atlas"] = "accountupgradebanner-wod",
			["msg"] = {
				["missionsTitle"] = GARRISON_MISSIONS_TITLE,
				["missionsReadyCount"] = GARRISON_LANDING_COMPLETED,  --> "%d/%d Ready for pickup"
				["missionsEmptyProgress"] = GARRISON_EMPTY_IN_PROGRESS_LIST,
				["missionsComplete"] = GarrisonFollowerOptions[Enum.GarrisonFollowerType.FollowerType_6_0].strings.LANDING_COMPLETE,
				["unlockReason"] = string.format(_G["GARRISON_TOWN_HALL_"..strupper(factionGroup).."_UPGRADE_TIER2_TOOLTIP"], '', ''),
			},
			["expansionInfo"] = util:GetExpansionInfo(5),
			["continents"] = {572},  --> Draenor
			["unlockQuest"] = MRBP_COMMAND_TABLE_UNLOCK_QUESTS[Enum.GarrisonType.Type_6_0][factionGroup],
		},
		-----[[ Legion ]]-----
		[Enum.GarrisonType.Type_7_0] = {
			-- ["name"] = _G[string.format("ORDER_HALL_%s", strupper(className))],
			["title"] = ORDER_HALL_LANDING_PAGE_TITLE,
			["description"] = MINIMAP_ORDER_HALL_LANDING_PAGE_TOOLTIP,
			["minimapIcon"] = string.format("legionmission-landingbutton-%s-up", className),
			-- ["atlas"] = "accountupgradebanner-legion",
			["msg"] = {
				["missionsTitle"] = GARRISON_MISSIONS,
				["missionsReadyCount"] = GARRISON_LANDING_COMPLETED,
				["missionsEmptyProgress"] = GARRISON_EMPTY_IN_PROGRESS_LIST,
				["missionsComplete"] = GarrisonFollowerOptions[Enum.GarrisonFollowerType.FollowerType_7_0].strings.LANDING_COMPLETE,
				["unlockReason"] = ORDER_HALL_TALENT_UNAVAILABLE_PLAYER_CONDITION,
			},
			["expansionInfo"] = util:GetExpansionInfo(6),
			["continents"] = {619, 905},  --> Broken Isles + Argus
			["unlockQuest"] = MRBP_COMMAND_TABLE_UNLOCK_QUESTS[Enum.GarrisonType.Type_7_0][className],
		},
		-----[[ Battle for Azeroth ]]-----
		[Enum.GarrisonType.Type_8_0] = {
			-- ["name"] = WAR_CAMPAIGN,
			["title"] = GARRISON_TYPE_8_0_LANDING_PAGE_TITLE,
			["description"] = GARRISON_TYPE_8_0_LANDING_PAGE_TOOLTIP,
			["minimapIcon"] = string.format("bfa-landingbutton-%s-up", factionGroup),
			-- ["atlas"] = "accountupgradebanner-bfa",
			["msg"] = {
				["missionsTitle"] = GARRISON_MISSIONS,
				["missionsReadyCount"] = GARRISON_LANDING_COMPLETED,
				["missionsEmptyProgress"] = GARRISON_EMPTY_IN_PROGRESS_LIST,
				["missionsComplete"] = GarrisonFollowerOptions[Enum.GarrisonFollowerType.FollowerType_8_0].strings.LANDING_COMPLETE,
			},
			["expansionInfo"] = util:GetExpansionInfo(7),
			["continents"] = {876, 875, 1355},  --> Kul'Tiras + Zandalar (+ Nazjatar)
			["unlockQuest"] = MRBP_COMMAND_TABLE_UNLOCK_QUESTS[Enum.GarrisonType.Type_8_0][factionGroup],
		},
		-----[[ Shadowlands ]]-----
		[Enum.GarrisonType.Type_9_0] = {
			-- ["name"] = GARRISON_TYPE_9_0_LANDING_PAGE_TITLE,
			["title"] = GARRISON_TYPE_9_0_LANDING_PAGE_TITLE,
			["description"] = GARRISON_TYPE_9_0_LANDING_PAGE_TOOLTIP,
			["minimapIcon"] = string.format("shadowlands-landingbutton-%s-up", covenantTex),
			-- ["atlas"] = "accountupgradebanner-shadowlands",
			["msg"] = {
				["missionsTitle"] = COVENANT_MISSIONS_TITLE,
				["missionsReadyCount"] = GARRISON_LANDING_COMPLETED,
				["missionsEmptyProgress"] = COVENANT_MISSIONS_EMPTY_IN_PROGRESS,
				["missionsComplete"] = GarrisonFollowerOptions[Enum.GarrisonFollowerType.FollowerType_9_0].strings.LANDING_COMPLETE,
			},
			["expansionInfo"] = util:GetExpansionInfo(8),
			["continents"] = {1550},  --> Shadowlands
			["unlockQuest"] = MRBP_COMMAND_TABLE_UNLOCK_QUESTS[Enum.GarrisonType.Type_9_0][covenantID],
		},
	};
end

function MRBP_GetGarrisonData(garrTypeID)
	--
	-- Return the data table for given garrison type.
	--
	-- Returns: table {name <string>, title <string>, description <string>,
	-- 				   minimapIcon <texture>, msg <table>, expansionInfo <table>,
	-- 				   continents <table>}
	--
	local garrInfo = MRBP_GARRISON_TYPE_INFOS[garrTypeID];
	
	return garrInfo;
end

function MRBP_IsQuestGarrisonRequirement(questID)
	--
	-- Check if given questID is part of the given garrison type
	-- requirements to unlock the command table.
	--
	-- Returns: boolean
	--
	_log:debug("IsQuestGarrisonRequirement?", questID);
	local garrInfo, unlockQuestID;
	
	for _, garrTypeID in ipairs(MRBP_GARRISON_TYPE_INFOS_SORTORDER) do
		garrInfo = MRBP_GetGarrisonData(garrTypeID);
		unlockQuestID = garrInfo.unlockQuest[1];
		if ( questID == unlockQuestID ) then
			ns.cprint("... yes!")
			return true;
		end
	end
	
	_log:debug("... no.")
	return false;
end

function MRBP_IsGarrisonRequirementMet(garrTypeID)
	--
	-- Check if the requirement for the given garrison type is met in order to
	-- unlock the command table.
	--
	-- Returns: boolean
	--
	-- Note: Currently only the required quest is checked for completion and
	--       nothing more. In Shadowlands there would be one more step needed,	-- FIXME - This doesn't work for upgraded characters.
	--       eg. if the talent is completed for unlocking the command table.			 - but works for Deathnight / Demonhunter
	--
	local garrInfo = MRBP_GetGarrisonData(garrTypeID);
	_log:info("IsGarrisonRequirementMet:", garrTypeID, garrInfo.expansionInfo.name);
	
	local hasGarrison = C_Garrison.HasGarrison(garrTypeID);
	
	local minReqLevel = MRBP_COMMAND_TABLE_UNLOCK_QUESTS[garrTypeID].reqLevel;
	local hasReqLevel = UnitLevel("player") >= minReqLevel;
	
	local playerMaxLevelForExpansion = GetMaxLevelForPlayerExpansion();
	local playerOwnsExpansion = garrInfo.expansionInfo.maxLevel <= playerMaxLevelForExpansion;  --> eligibility check
	
	local questID = garrInfo.unlockQuest[1];
	local isQuestCompleted = C_QuestLog.IsQuestFlaggedCompleted(questID);
	
	-- ns.cprint("IsGarrisonRequirementMet:", garrTypeID, garrInfo.expansionInfo.name);
	-- ns.cprint("playerOwnsExpansion:", playerOwnsExpansion);
	-- ns.cprint("hasGarrison:", hasGarrison);
	-- ns.cprint("hasReqLevel:", hasReqLevel);
	-- ns.cprint("isQuestCompleted:", isQuestCompleted);
	
	_log:debug("...", isQuestCompleted);
	return isQuestCompleted;
end
-- MRBP_IsGarrisonRequirementMet(Enum.GarrisonType.Type_9_0)

-----[[ Dropdown Menu ]]--------------------------------------------------------

local function BuildMenuEntryLabelDesc(garrTypeID, isDisabled)
	--
	-- Combines the menu entry text with a icon hint about completed missions
	-- with the user preferences and adds to the menu entry's description tooltip
	-- informations about completed missions according to the user preferences.
	--
	-- Returns: {string, strting}
	--
	local garrInfo = MRBP_GetGarrisonData(garrTypeID);
	local numInProgress, numCompleted = util:GetInProgressMissionCount(garrTypeID);
	
	--[[ Set menu entry text (label) ]]--
	local labelText = ns.settings.preferExpansionName and garrInfo.expansionInfo.name or garrInfo.title;
	if ( ns.settings.showMissionCompletedHint and numCompleted > 0 ) then
		if ( not ns.settings.showMissionCompletedHintOnlyForAll ) then
			labelText = labelText.." |TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0:0:0:0|t";
		end
		if ( ns.settings.showMissionCompletedHintOnlyForAll and numCompleted == numInProgress ) then
			labelText = labelText.." |TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0:0:0:0|t";
		end
	end
	
	--[[ Set the menu entry's tooltip text ]]--  								-- TODO - add numAvailable to mission infos
	local tooltipText = isDisabled and DISABLED_FONT_COLOR:WrapTextInColorCode(garrInfo.description) or garrInfo.description;
	if ( ns.settings.showMissionCountInTooltip and not isDisabled ) then
		-- Add category title for missions
		tooltipText = tooltipText.."|n|n"..garrInfo.msg.missionsTitle;
		
		-- Add mission count info
		tooltipText = tooltipText..HIGHLIGHT_FONT_COLOR_CODE;
		if (numInProgress > 0) then
			tooltipText = tooltipText.."|n"..string.format(garrInfo.msg.missionsReadyCount, numCompleted, numInProgress);
		else
			tooltipText = tooltipText.."|n"..garrInfo.msg.missionsEmptyProgress;
		end
		tooltipText = tooltipText..FONT_COLOR_CODE_CLOSE;
		if (numCompleted > 0) then
			tooltipText = tooltipText.."|n|n"..garrInfo.msg.missionsComplete;
		end
	end
	-- Show requirement for unlocking the given garrison type 					-- TODO - Refine requirement infos
	if isDisabled then
		if garrInfo.msg.unlockReason then
			-- tooltipText = tooltipText.."|n|n"..garrInfo.msg.unlockReason;
			tooltipText = tooltipText.."|n|n"..DIM_RED_FONT_COLOR:WrapTextInColorCode(garrInfo.msg.unlockReason);
		else
			tooltipText = tooltipText.."|n|n"..DIM_RED_FONT_COLOR:WrapTextInColorCode(string.format(UNLOCKS_AT_LEVEL, garrInfo.expansionInfo.maxLevel));
		end
	end
	
	return labelText, tooltipText; 
end

function MRBP:GarrisonLandingPageDropDown_OnLoad()
	--
	-- Creates the dropdown frame.
	--
	_log:info("Creating dropdown menu...");
	
	self.dropdown = CreateFrame("Frame", AddonID.."_GarrisonLandingPageDropDown", UIParent, "UIDropDownMenuTemplate");
	self.dropdown:SetClampedToScreen(true);
	self.dropdown.point = "TOPRIGHT";  --> default: "TOPLEFT"
	self.dropdown.relativePoint = "BOTTOMRIGHT";  --> default: "BOTTOMLEFT"
	
	UIDropDownMenu_Initialize(self.dropdown, self.GarrisonLandingPageDropDown_Initialize, ns.settings.menuStyleID == "1" and "MENU" or '');
end

function MRBP:GarrisonLandingPageDropDown_Initialize(level)
	--
	-- Create the dropdown menu items.
	--
	-- Note: 'self' refers to the dropdown menu frame.
	--
	local info, garrInfo;
	local filename, width, height, txLeft, txRight, txTop, txBottom;
		
	-- Sort display order *only once* per changed setting
	local isInitialSortOrder = max(unpack(MRBP_GARRISON_TYPE_INFOS_SORTORDER)) == MRBP_GARRISON_TYPE_INFOS_SORTORDER[1];
	
	if (ns.settings.reverseSortorder and isInitialSortOrder) then
		local sortFunc = function(a,b) return a<b end;  --> 0-9
		table.sort(MRBP_GARRISON_TYPE_INFOS_SORTORDER, sortFunc);
		_log:debug("Showing reversed display order.");
	end
	if (not ns.settings.reverseSortorder and not isInitialSortOrder) then
		local sortFunc = function(a,b) return a>b end;  --> 9-0 (default)
		table.sort(MRBP_GARRISON_TYPE_INFOS_SORTORDER, sortFunc);
		_log:debug("Showing initial display order.");
	end
	
	local playerLevel = UnitLevel("player");
	local expansionForPlayerLevel = GetExpansionForLevel(playerLevel);
	local playerMaxLevelForExpansion = GetMaxLevelForPlayerExpansion();
	local shouldShowDisabled, playerOwnsExpansion, isActiveEntry;
	
	for i, garrTypeID in ipairs(MRBP_GARRISON_TYPE_INFOS_SORTORDER) do
		garrInfo = MRBP_GetGarrisonData(garrTypeID);
		if ns.settings.showMissionTypeIcons then
			filename, width, height, txLeft, txRight, txTop, txBottom = util:GetAtlasInfo(garrInfo.minimapIcon);
		end
		shouldShowDisabled = not MRBP_IsGarrisonRequirementMet(garrTypeID);
		-- shouldShowDisabled = (not C_Garrison.HasGarrison(garrTypeID) or
							  -- playerLevel < garrInfo.expansionInfo.maxLevel or
							  -- expansionForPlayerLevel < garrInfo.expansionInfo.expansionLevel);
		playerOwnsExpansion = garrInfo.expansionInfo.maxLevel <= playerMaxLevelForExpansion;  --> eligibility check
		isActiveEntry = tContains(ns.settings.activeMenuEntries, tostring(garrInfo.expansionInfo.expansionLevel));  --> user option
		
		_log:debug(string.format("Got %s - owned: %s, disabled: %s",
		   NORMAL_FONT_COLOR:WrapTextInColorCode(garrInfo.expansionInfo.name),
		   NORMAL_FONT_COLOR:WrapTextInColorCode(tostring(playerOwnsExpansion)),
		   NORMAL_FONT_COLOR:WrapTextInColorCode(tostring(shouldShowDisabled)))
		);
		
		if ( playerOwnsExpansion and isActiveEntry ) then
			local labelText, tooltipText = BuildMenuEntryLabelDesc(garrTypeID, shouldShowDisabled);
			
			info = UIDropDownMenu_CreateInfo();
			info.owner = GarrisonLandingPageMinimapButton;
			info.text = labelText;
			info.notCheckable = 1;
			info.tooltipOnButton = ns.settings.showEntryTooltip and 1 or nil;
			info.tooltipTitle = ns.settings.preferExpansionName and garrInfo.title or garrInfo.expansionInfo.name;
			info.tooltipText = tooltipText;
			if ns.settings.showMissionTypeIcons then
				info.icon = filename;
				info.tCoordLeft = txLeft;
				info.tCoordRight = txRight;
				info.tCoordTop = txTop;
				info.tCoordBottom = txBottom;
				info.tSizeX = width;
				info.tSizeY = height;
				-- info.tFitDropDownSizeX = 1;
				-- info.iconOnly = 1;
				-- info.iconInfo = {
					-- tCoordLeft = txLeft,
					-- tCoordRight = txRight,
					-- tCoordTop = txTop,
					-- tCoordBottom = txBottom,
					-- tSizeX = width,
					-- tSizeY = height,
					-- tFitDropDownSizeX = 1,
				-- };
			end
			info.func = function(self)
				if (GarrisonLandingPage and GarrisonLandingPage:IsShown()) then
					HideUIPanel(GarrisonLandingPage);
				end
				ShowGarrisonLandingPage(garrTypeID);
			end;
			info.disabled = shouldShowDisabled;
			info.tooltipWhileDisabled = 1;
			
			UIDropDownMenu_AddButton(info, level);
		end
	end
	if tContains(ns.settings.activeMenuEntries, ns.settingsMenuEntry) then	
		-- Add settings button
		if ns.settings.showMissionTypeIcons then
			filename, width, height, txLeft, txRight, txTop, txBottom = util:GetAtlasInfo("Warfronts-BaseMapIcons-Empty-Workshop-Minimap");
		end
		info = UIDropDownMenu_CreateInfo();
		info.notCheckable = true;
		info.text = SETTINGS;  --> WoW global string
		info.colorCode = NORMAL_FONT_COLOR:GenerateHexColorMarkup();
		if ns.settings.showMissionTypeIcons then
			info.icon = filename;
			info.tSizeX = width;
			info.tSizeY = height;
			info.tCoordLeft = txLeft;
			info.tCoordRight = txRight;
			info.tCoordTop = txTop;
			info.tCoordBottom = txBottom;
		end
		info.func = function(self)
			-- Only works correctly, if you call this twice (!)
			InterfaceOptionsFrame_OpenToCategory(MRBP_InterfaceOptionsPanel);
			InterfaceOptionsFrame_OpenToCategory(MRBP_InterfaceOptionsPanel);
		end;
		info.tooltipOnButton = 1;
		info.tooltipTitle = SETTINGS;  --> WoW global string
		info.tooltipText = BASIC_OPTIONS_TOOLTIP;  --> WoW global string
		
		UIDropDownMenu_AddButton(info);
	end
end

-----[[ Hooks ]]----------------------------------------------------------------

function MRBP:SetButtonHooks()
	--
	-- Hooks some functions related to the GarrisonLandingPage minimap button
	-- and frame (report frame).
	--
	if GarrisonLandingPageMinimapButton then
		_log:info("Hooking into minimap button's tooltip + clicking behaviour...");
		_log:debug("IsShown:", GarrisonLandingPageMinimapButton:IsShown());
		
		if ( not GarrisonLandingPageMinimapButton:IsShown() ) then
			-- Fallback, in case the button is still hidden.
			--> User hasn't unlocked the current expansion's garrison type, yet.
			GarrisonLandingPageMinimapButton_UpdateIcon(GarrisonLandingPageMinimapButton);
		end
		
		-- Tooltip hook
		GarrisonLandingPageMinimapButton:HookScript("OnEnter", MRBP_OnEnter);
		
		-- Mouse button hooks; by default only the left button is registered.
		GarrisonLandingPageMinimapButton:RegisterForClicks("LeftButtonUp", "RightButtonUp"); --, "RightButtonDown");
		-- GarrisonLandingPageMinimapButton:HookScript("OnClick", MRBP_OnClick);  --> safer, but doesn't work properly
		GarrisonLandingPageMinimapButton:SetScript("OnClick", MRBP_OnClick);
	end
	
	-- GarrisonLandingPage (report frame) hook
	hooksecurefunc("ShowGarrisonLandingPage", MRBP_ShowGarrisonLandingPage);
end

function MRBP_OnEnter(self)
	--
	-- Note: 'self' refers to the GarrisonLandingPageMinimapButton, the parent frame.
	-- 
	-- REF.: <FrameXML/Minimap.xml>
	-- REF.: <FrameXML/SharedTooltipTemplates.lua>
	--
	GameTooltip:SetOwner(self, "ANCHOR_LEFT");
	GameTooltip:SetText(self.title, 1, 1, 1);
	GameTooltip:AddLine(self.description, nil, nil, nil, true);
	local tooltipAddonText = L.TOOLTIP_CLICKTEXT_MINIMAPBUTTON;
	if ns.settings.showAddonNameInTooltip then
		tooltipAddonText = GRAY_FONT_COLOR:WrapTextInColorCode(ns.AddonTitleShort).." "..tooltipAddonText;
	end
	local currentDateTime = C_DateAndTime.GetCurrentCalendarTime();
	if ( currentDateTime.month == 12 ) then
		-- Show a Xmas easter egg on december after the minimap tooltip text
		tooltipAddonText = tooltipAddonText.." "..util:CreateTextIcon("Front-Tree-Icon");
	end
	GameTooltip_AddNormalLine(GameTooltip, tooltipAddonText);
	GameTooltip:Show();
end

function MRBP_OnClick(self, button, isDown)
	--
	-- Handles click behaviour of the minimap button.
	-- 
	-- Note: 'self' is the parent frame --> 'GarrisonLandingPageMinimapButton'.
	--
	_log:debug(string.format("Got mouse click: %s, isDown: %s", button, tostring(isDown)));
	
	if (button == "RightButton") then
		UIDropDownMenu_Refresh(MRBP.dropdown);
		ToggleDropDownMenu(1, nil, MRBP.dropdown, self, -14, 5);
	else
		-- Pass-through to original function on LeftButton click.
		GarrisonLandingPageMinimapButton_OnClick(button);
	end
end

function MRBP_ShowGarrisonLandingPage(garrTypeID)
	--
	-- Fixes display errors caused by the Covenant Landing Page Mixin.
	--
	-- REF. <FrameXML/Blizzard_GarrisonUI/Blizzard_GarrisonLandingPage.lua>
	--
	_log:debug("Opening report for garrTypeID:", garrTypeID, MRBP_GARRISON_TYPE_INFOS[garrTypeID].title);
	
	if (garrTypeID ~= Enum.GarrisonType.Type_9_0) then
		-- Quick fix: the covenant missions don't hide some frame parts properly
		GarrisonLandingPageReport.Sections:Hide();
		GarrisonLandingPage.FollowerTab.CovenantFollowerPortraitFrame:Hide();
	else
		GarrisonLandingPageReport.Sections:Show();
	end
	-- Quick fix for the invasion alert badge from WoD garrison on the upper
	-- side of the mission report frame; only shows it for garrison missions.
	if ( garrTypeID ~= Enum.GarrisonType.Type_6_0 and GarrisonLandingPage.InvasionBadge:IsShown() ) then
		GarrisonLandingPage.InvasionBadge:Hide();
	end
end

local function MRBP_ReloadDropdown()
	-- Reloading the dropdown menu
	MRBP.dropdown = nil;
	MRBP:GarrisonLandingPageDropDown_OnLoad();
end
ns.MRBP_ReloadDropdown = MRBP_ReloadDropdown;

-----[[ Slash commands ]]-------------------------------------------------------

local SLASH_CMD_ARGLIST = {
	-- arg, desc, key,
	{"version", L.SLASHCMD_DESC_VERSION},
	{"help", L.SLASHCMD_DESC_HELP},
	{"reset", L.SLASHCMD_DESC_RESET},
	{"chatmsg", L.SLASHCMD_DESC_CHATMSG, "showChatNotifications"},
	{"tooltipborder", L.SLASHCMD_DESC_TOOLTIPBORDER, "menuStyleID"},
	{"addonname", L.SLASHCMD_DESC_ADDONNAME, "showAddonNameInTooltip"},
	{"missionhints", L.SLASHCMD_DESC_MISSIONHINTS, "showMissionCompletedHint"},
	{"missioncount", L.SLASHCMD_DESC_MISSIONCOUNT, "showMissionCountInTooltip"},
	{"names", L.SLASHCMD_DESC_NAMES, "preferExpansionName"},
	{"namesorder", L.SLASHCMD_DESC_NAMESORDER, "reverseSortorder"},
};

-- CHAT_HELP_TEXT_LINE1 = "Chat-Befehle:";

function MRBP:RegisterSlashCommands()
	--
	-- Register basic slash commands for chat frame handling.
	--
	_log:info("Registering slash commands...");
	
	SLASH_MRBP1 = '/mrbp';
	SLASH_MRBP2 = '/missionreportbuttonplus';
	SlashCmdList["MRBP"] = function(msg, editbox)
		if (msg ~= '') then
			_log:debug(string.format("Got slash cmd: '%s'", msg));
						
			if (msg == 'version') then
				local shortVersionOnly = true;
				util:printVersion(shortVersionOnly);
			
			elseif (msg == 'help') then
				util:printVersion();
				print(YELLOW_FONT_COLOR:WrapTextInColorCode(L.CHATMSG_SYNTAX_INFO_S:format(SLASH_MRBP1)).."|n");
				local name, desc;
				for _, info in pairs(SLASH_CMD_ARGLIST) do
					name, desc = info[1], info[2];
					print("   "..YELLOW_FONT_COLOR:WrapTextInColorCode(name)..": "..desc);
				end
			
			elseif (msg == 'show') then
				GarrisonLandingPageMinimapButton:Show()
				-- if ( C_Garrison.GetLandingPageGarrisonType() == Enum.GarrisonType.Type_9_0 ) then
				GarrisonLandingPageMinimapButton_UpdateIcon(GarrisonLandingPageMinimapButton)
				-- end
			
			elseif (msg == 'garrtest') then
				local prev_loglvl = _log.level;
				_log.level = _log.DEBUG;
				_log:info("Current GarrisonType:", C_Garrison.GetLandingPageGarrisonType());
				
				for i, garrTypeID in ipairs(MRBP_GARRISON_TYPE_INFOS_SORTORDER) do
					local garrInfo = MRBP_GetGarrisonData(garrTypeID);
				   _log:debug("HasGarrison:", C_Garrison.HasGarrison(garrTypeID),
							  "- GarrisonType:", garrTypeID,
							  "-", garrInfo.expansionInfo.name);
					-- C_Garrison.HasGarrison(Enum.GarrisonType.Type_9_0)
				end
				
				local playerLevel = UnitLevel("player");
				local expansionForPlayerLevel = GetExpansionForLevel(playerLevel);
				local playerMaxLevelForExpansion = GetMaxLevelForPlayerExpansion();
				
				_log:debug("playerLevel:", playerLevel);
				_log:debug("expansionForPlayerLevel:", expansionForPlayerLevel);
				_log:debug("playerMaxLevelForExpansion:", playerMaxLevelForExpansion);
				
				_log.level = prev_loglvl;
				
			elseif (msg == 'reset') then
				ns.settings = CopyTable(ns.defaultSettings);
				-- Reloading the dropdown menu
				MRBP.dropdown = nil;
				MRBP:GarrisonLandingPageDropDown_OnLoad();
				ns.cprint(L.CHATMSG_RESET);
			
			else
				-- Change (toggle) user settings only if different from default
				for _, arglist in ipairs(SLASH_CMD_ARGLIST) do
					local arg, desc, key = unpack(arglist);
					if (key and msg == arg) then
						_log:debug("Got:", key, "-", ns.defaultSettings[key], ns.settings[key]);
						local defaultValue = ns.defaultSettings[key];
						local currentValue = ns.settings[key];
						if (currentValue ~= defaultValue) then
							ns.settings[key] = defaultValue;
							if (msg == 'chatmsg') then
								_log.level = _log.USER;
								ns.cprint(L.CHATMSG_VERBOSE_S:format(SLASH_MRBP1.." "..SLASH_CMD_ARGLIST[4][1]));
							end
						else
							ns.settings[key] = not defaultValue;
							if (msg == 'chatmsg') then
								ns.cprint(L.CHATMSG_SILENT_S:format(SLASH_MRBP1.." "..SLASH_CMD_ARGLIST[4][1]));
								_log.level = _log.NOTSET;
							end
						end
						_log:debug("New:", "-", ns.defaultSettings[key], ns.settings[key]);
						ns.cprint(arg, "-", ns.settings[key] and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED);
						if (msg == 'tooltipborder') then
							MRBP_ReloadDropdown();
						end
					end
				end				
			end
		else
			local prev_loglvl = _log.level;
			_log.level = _log.USER;
			util:printVersion();
			ns.cprint(L.SLASHCMD_MSG_TYPE_HELP_S:format(YELLOW_FONT_COLOR:WrapTextInColorCode(SLASH_MRBP1.." "..SLASH_CMD_ARGLIST[2][1])));
			_log.level = prev_loglvl;
		end
	end;
end
