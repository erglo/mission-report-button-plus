if ( GetLocale() ~= "deDE" ) then
	return;
end

local ns = select(2, ...);

ns.L = {
	TOOLTIP_CLICKTEXT_MINIMAPBUTTON = "Rechtsklicken, um Erweiterung auszuwählen",
	--[[ Slash command descriptions ]]--
	SLASHCMD_DESC_VERSION = "Liest die aktuelle Version dieses Addons aus.",
	SLASHCMD_DESC_CHATMSG = "Chat-Benachrichtigungen ein/aus.",
	-- SLASHCMD_MSG_TYPE_HELP_S = "Mit '%s' mehr Tipps erhalten...",
	-- SLASHCMD_DESC_HELP = "Zeigt diese Hilfe an.",
	-- SLASHCMD_DESC_TOOLTIPBORDER = "Zwischen Tooltip- und Dropdown-Stil wechseln.",
	-- SLASHCMD_DESC_ADDONNAME = "Addonkürzel im Tooltip des Missionsbericht-Buttons ein-/ausblenden.",
	-- SLASHCMD_DESC_MISSIONHINTS = "Icon-Hinweis für fertige Missionen ein/ausblenden.",
	-- SLASHCMD_DESC_MISSIONCOUNT = "Infos zu laufenden Missionen ein/ausblenden.",
	-- SLASHCMD_DESC_NAMES = "Zwischen Erweiterungs- und Missionsbericht-Namen wechseln.",
	-- SLASHCMD_DESC_NAMESORDER = "Zwischen Anzeigereihenfolge der Namen wechseln.",
	-- SLASHCMD_DESC_RESET = "Alle Einstellungen auf Anfangswerte zurücksetzen.",
	--[[ Chat messages ]]--
	CHATMSG_SYNTAX_INFO_S = "Syntax: '%s <argument>'",
	CHATMSG_SILENT_S = "Chat-Benachrichtigungen deaktiviert. Mit '%s' reaktivieren.",
	CHATMSG_VERBOSE_S = "Chat-Benachrichtigungen aktiviert. Mit '%s' deaktivieren.",
	CHATMSG_RESET = "Alle Einstellungen wurden zurückgesetzt.",
	--[[ UI options ]]--
	CFG_ADDONINFOS_VERSION = "Version",
	CFG_ADDONINFOS_AUTHOR = "Entwickler",
	CFG_ADDONINFOS_EMAIL = "E-Mail",
	CFG_ADDONINFOS_HOMEPAGE = "Homepage",
	CFG_ADDONINFOS_LICENSE = "Lizenz",
	CFG_BUTTONTOOLTIP_SHOW_ABBREV_TEXT = "Addonkürzel im Button-Tooltip",
	CFG_BUTTONTOOLTIP_SHOW_ABBREV_TOOLTIP = "Wenn aktiviert, wird das Addonkürzel zusätzlich zur Rechtsklick-Beschreibung im Tooltip des Missionsbericht-Buttons angezeigt, um damit die Herkunft zu verdeutlichen.",
	CFG_CHAT_NOTIFY_TEXT = "Chatbenachrichtigungen",
	CFG_CHAT_NOTIFY_TOOLTIP = "Deaktivieren, um keine Benachrichtigungen im Chat zu erhalten.",
	CFG_DDMENU_SEPARATOR_HEADING = "Dropdownmenü",
	CFG_DDMENU_NAMING_TEXT = "Namen der Erweiterungen bevorzugen",
	CFG_DDMENU_NAMING_TOOLTIP = "Die Einträge des Dropdownmenüs sind standardmäßig die Namen der jeweiligen Erweiterung.|n|nWenn deaktiviert, werden stattdessen die der Missionsberichte angezeigt.",
	CFG_DDMENU_SORTORDER_TEXT = "Namen in umgekehrter Reihenfolge",
	CFG_DDMENU_SORTORDER_TOOLTIP = "Die Einträge des Dropdownmenüs werden standardmäßig nach Erscheinung sortiert; z.B. die aktuelle Erweiterung zuerst, dann die davor, usw.|n|nWenn aktiviert, wird die Reihenfolge umgekehrt.",
	CFG_DDMENU_REPORTICONS_TEXT = "Missionsbericht-Icons anzeigen",
	CFG_DDMENU_REPORTICONS_TOOLTIP = "Wenn deaktiviert, werden die Icons auf der rechten Seite des Dropdownmenüs ausgeblendet.",
	CFG_DDMENU_ICONHINT_TEXT = "Icon-Hinweis hinter Namen",
	CFG_DDMENU_ICONHINT_TOOLTIP = "Hinter jedem Eintrag im Dropdownmenü wird als Hinweis für eine bereits abgeschlossene Mission, ein Icon in Form eines Ausrufezeichens angezeigt.|n|nWenn deaktiviert, wird dieses Icon ausgeblendet.",
	CFG_DDMENU_ICONHINTALL_TEXT = "Erst beim Abschluss ALLER Missionen",
	CFG_DDMENU_ICONHINTALL_TOOLTIP = "Den Icon-Hinweis erst anzeigen, wenn ALLE Missionen abgeschlossen wurden.",
	CFG_DDMENU_ENTRYTOOLTIP_SHOW_TEXT = "Details-Tooltip anzeigen",
	CFG_DDMENU_ENTRYTOOLTIP_SHOW_TOOLTIP = "Bei Maus über einem Menüeintrag werden Details zu Missionen der jeweiligen Erweiterung in einem Tooltip angezeigt.|n|nWenn deaktiviert, wird dieser Tooltip nicht mehr angezeigt.",
	CFG_DDMENU_ENTRYTOOLTIP_INPROGRESS_TEXT = "Laufende Missionen zählen",
	CFG_DDMENU_ENTRYTOOLTIP_INPROGRESS_TOOLTIP = "Die Anzahl der laufenden Missionen werden im Tooltip des jeweiligen Menüeintrags angezeigt.|n|nWenn deaktiviert, werden diese ausgeblendet.",
	CFG_DDMENU_ENTRYSELECTION_LABEL = "Menüeinträge",
	CFG_DDMENU_ENTRYSELECTION_TOOLTIP = "Wählt hier die Einträge des Dropdownmenüs aus. Deaktiviert einfach die Erweiterungen die euch nicht mehr interessieren.",
	CFG_DDMENU_ENTRYSELECTION_TEXT_D = "%d |4Menüeintrag:Menüeinträge; gewählt",
	CFG_DDMENU_ENTRYSELECTION_TEXT_WARNING = "Mind. 1 Menüeintrag nötig",  --> max. 27 chars
	CFG_DDMENU_STYLESELECTION_LABEL = "Menüstil",
	CFG_DDMENU_STYLESELECTION_TOOLTIP = "Wählt hier den Stil des Dropdownmenüs aus der euch am Besten gefällt.|n(Weitere werden folgen.)",
	CFG_DDMENU_STYLESELECTION_VALUE1_TEXT = "Tooltip-Stil",
	CFG_DDMENU_STYLESELECTION_VALUE2_TEXT = "Dropdownmenü-Stil",
};