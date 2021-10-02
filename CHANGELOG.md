Changelog
=========

v2021.10.02 (beta)
-------------------
- *Initial `beta` release with __Git__ on [CurseForge.com][^cf] and [GitHub.com][^gh].*
<!--- Hyperlinks --->
[^cf]: <https://www.curseforge.com/wow/addons/mission-report-button-plus>
[^gh]: <https://github.com/erglo/mission-report-button-plus>

v2021.09.30 (beta)
-------------------
- *Added* both to the UI options.
- *Added* worldmap threat infos to menu item's tooltip.
- *Added* bounty board infos to menu item's tooltip.

v2021.09.20 (beta)
-------------------
- *Added* a chat notification for the worldquest calendar event.

v2021.09.15 (beta)
-------------------
- *Changed* project status to `beta`. __Testers wanted!__
- *Added* version control management with __Git__, including meta files.
- *Added* calendar world quest event week watcher.

v2021.09.10 (alpha)
-------------------
- *Added* a new file for utility functions in order to keep the core file clear.
- *Added* slash command `show` to show the minimap button, when not displayed. (experimental)
- *Added* requirement checks for each expansion; instead of player level check (unreliable due to level squish) the quests are used as shown in the mobile app.

v2021.08.21 (alpha)
-------------------
- *Changed* and refined UI options for live change preview.

v2021.07.10 (alpha)
-------------------
- *Added* graphical interface options.
- *Added* locale strings for options. 
- *Added* functionality to de-/select menu items. 
- *Added* menu item for quickly accessing the settings. 

v2021.05.15 (alpha)
-------------------
- *Second public release* of alpha version.
- *Added* locale strings for slash command descriptions and chat messages.

v2021.05.12 (alpha)
-------------------
- *Added* slash commands for all currently available settings.

v2021.05.10 (alpha)
-------------------
- *Added* reversable display order of the drop-down menu entries.

v2021.04.28 (alpha)
-------------------
- *Added* icon hint on menu entries on completed missions.
- *Added* tooltip infos about in-progress missions.
- *Changed* expansion eligibility check; entries for expansions the user doesn't
  (yet) own don't appear in the drop-down menu (optional); if the user decides
  to see them anyway, they appear as disabled entries in order to avoid
  UI errors.
- *Changed* player level check for better filtering; entries of garrison types 
  not yet available for the user are now disabled in order to avoid UI errors.
- *Added* tooltip hint over disabled menu entries about activation requirements,
  eg. name of required expansion or required player level (experimental feature).

v2021.04.20 (alpha)
-------------------
- *Changed* post hooks to pre-hooks to catch and redirect mouse clicks more 
  efficient; mission reports from different garrison types can now be changed 
  while the report frame is open.

v2021.03.31 (alpha)
-------------------
- *Added* expansion eligibility check; unavailable entries will now be hidden.
- *Added* player level check; unavailable entries will now be disabled.
- *Added* expansion names to be shown as entry label in the drop-down menu; the
  garrison landing page name is now in the tooltip of each entry instead.

v2021.03.26 (alpha)
-------------------
- *Initial public release* of `alpha` version.
- *Added* copyright infos and long description.
- *Added* locale files (enUS + deDE).
- *Added* add-on page at 
  [curseforge.com](https://www.curseforge.com/wow/addons/mission-report-button-plus).

v2021.03.19 (alpha)
-------------------
- *Initial tests*
- *Added* right-click behaviour and menu to the
  `GarrisonLandingPageMinimapButton`.
- *Added* slash commands for version infos and help.
- *Added* additional tooltip info to the `GarrisonLandingPageMinimapButton`.
- *Added* logging functions to simplify debugging.
