local ns = select( 2, ... );

-- default / fallback locale

ns.L = {
	TOOLTIP_CLICKTEXT_MINIMAPBUTTON = "Right-click to select expansion",
	--[[ Slash command descriptions ]]--
	SLASHCMD_DESC_VERSION = "Prints this add-on's current version info",
	SLASHCMD_DESC_CHATMSG = "Toggles chat notifications",
	--[[ Chat messages ]]--
	CHATMSG_SYNTAX_INFO_S = "Usage: '%s <argument>'",
	CHATMSG_SILENT_S = "Chat notifications disabled. Re-enable with '%s'.",
	CHATMSG_VERBOSE_S = "Chat notifications enabled. Disable with '%s'.",
	CHATMSG_RESET = "Settings have been reset to default values.",
	--[[ UI options ]]--
	CFG_ADDONINFOS_VERSION = "Version",
	CFG_ADDONINFOS_AUTHOR = "Author",
	CFG_ADDONINFOS_EMAIL = "Email",
	CFG_ADDONINFOS_HOMEPAGE = "Homepage",
	CFG_ADDONINFOS_LICENSE = "License",
	CFG_BUTTONTOOLTIP_SHOW_ABBREV_TEXT = "Show Add-on Abbreviation in Button Tooltip",
	CFG_BUTTONTOOLTIP_SHOW_ABBREV_TOOLTIP = "If disabled, the add-on's abbreviation will be displayed in the mission report button's tooltip.",
	CFG_CHAT_NOTIFY_TEXT = "Toggle Chat Notifications",
	CFG_CHAT_NOTIFY_TOOLTIP = "Deactivate to turn chat notifications off.",
	CFG_DDMENU_SEPARATOR_HEADING = "Dropdown Menu",
	CFG_DDMENU_NAMING_TEXT = "Prefer Expansion Names",
	CFG_DDMENU_NAMING_TOOLTIP = "The dropdown menu items are by default the names of each expansion.|n|nIf disabled, the name of each mission report will be displayed instead.",
	CFG_DDMENU_SORTORDER_TEXT = "Reverse Names Order",
	CFG_DDMENU_SORTORDER_TOOLTIP = "The dropdown menu items are by default sorted by expansion release; eg. the current expansion comes first, the one before that next, etc.|n|nIf enabled, the sorting order will be reversed.",
	CFG_DDMENU_REPORTICONS_TEXT = "Show Report-specific Icons",
	CFG_DDMENU_REPORTICONS_TOOLTIP = "If disabled, the right sided report icons will be hidden.",
	CFG_DDMENU_ICONHINT_TEXT = "Show Icon Hint after Names",
	CFG_DDMENU_ICONHINT_TOOLTIP = "After each menu item an exclamation icon appears as soon as an in-progress mission is finished.|n|nIf disabled, this icon will be hidden.",
	CFG_DDMENU_ICONHINTALL_TEXT = "Only after ALL Missions",
	CFG_DDMENU_ICONHINTALL_TOOLTIP = "The icon hint will only show up after ALL in-progress missions were finished.",
	CFG_DDMENU_ENTRYTOOLTIP_SHOW_TEXT = "Show Details Tooltip",
	CFG_DDMENU_ENTRYTOOLTIP_SHOW_TOOLTIP = "On mouse-over each menu item details about the corresponding expansion are shown in a tooltip.|n|nIf disabled, this tooltip will not pop up.",
	CFG_DDMENU_ENTRYTOOLTIP_INPROGRESS_TEXT = "Show In-Progress Missions",
	CFG_DDMENU_ENTRYTOOLTIP_INPROGRESS_TOOLTIP = "The numbers of the in-progress missions are shown in the tooltip of each menu item.|n|nIf disabled, these numbers will be hidden.",
	CFG_DDMENU_ENTRYTOOLTIP_BOUNTIES_TEXT = "Show Bounty Board Quests",
	CFG_DDMENU_ENTRYTOOLTIP_BOUNTIES_TOOLTIP = "Lists the currently active Emissary Quests of each expansion which supports these, if they were unlocked by the player.|n|nAvailable since Legion.",
	CFG_DDMENU_ENTRYTOOLTIP_THREATS_TEXT = "Show World Map Threats",
	CFG_DDMENU_ENTRYTOOLTIP_THREATS_TOOLTIP = "Lists the currently active world map threats (eg. N'Zoth or Covenant assaults) of each expansion which supports these, if they were unlocked by the player.|n|nAvailable since Battle for Azeroth.",
	CFG_DDMENU_ENTRYSELECTION_LABEL = "Menu Items",
	CFG_DDMENU_ENTRYSELECTION_TOOLTIP = "Choose which dropdown menu should be displayed. Simply uncheck those expansions which are no longer of interest to you.",
	CFG_DDMENU_ENTRYSELECTION_TEXT_D = "%d |4menu item:menu items; selected",
	CFG_DDMENU_ENTRYSELECTION_TEXT_WARNING = "Need at least 1 menu item",  --> max. 27 chars
	CFG_DDMENU_STYLESELECTION_LABEL = "Menu Style",
	CFG_DDMENU_STYLESELECTION_TOOLTIP = "Choose your favorite dropdown menu style.|n|n(More to come.)",
	CFG_DDMENU_STYLESELECTION_VALUE1_TEXT = "Tooltip Style",
	CFG_DDMENU_STYLESELECTION_VALUE2_TEXT = "Dropdown Menu Style",
};