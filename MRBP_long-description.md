Mission Report Button Plus
--------------------------

Adds a right-click menu to the mission report button on the minimap for selecting reports from previous expansions.  
*(See full feature list [below](#features))*  

<!--- Preview images --->
![Button tooltip and right-click menu with expansion names](https://media.forgecdn.net/attachments/thumbnails/364/415/310/172/mbrp_tooltip-dropdown.jpg "Right-click on the Kyrian mission report button on the minimap opens the menu.") 
![The right-click menu with in-progess mission infos](https://media.forgecdn.net/attachments/thumbnails/364/416/310/172/mbrp_dropdown_bfa-missioncount.jpg "Mouse-over a menu entry shows details about running missions.")

### Problem

As soon as a new WoW extension comes out the button on the minimap which opens the mission report frame is disabled until you reach the max. level of that extension and after you meet certain criteria in order to send your little helpers on missions. But only the reports to missions of the current extension can be viewed by the now _replaced_ minimap button, with _no other options_ to view 'older' reports any more unless you visit your old mission tables, and often only to find out that your too early and your missions are _not ready_.  
I was very pleased to see that the WoW Companion app for mobile phones addressed this problem, but the main game still doesn't.

### Solution

It is still possible to access mission reports from previous extensions, but the Blizzard devs still haven't implemented a possibility for users to access it via the graphical interface. So here comes this add-on to work:
+ it adds a right-click menu to the already available minimap button for mission reports,
+ with a selection of mission reports of previous extensions, which are...
+ **anytime and anywhere accessible.**

---

## Features

+ adds a right-click menu to the minimap button
+ a click on an menu entry opens the (read-only) Mission Report Frame of the corresponding expansion
+ get informed in chat on finished missions, talents, buildings (WoD garrison only) or WoD garrison invasions
+ choose from a variety of options and adjust the addon to your liking
+ expansions you (yet) don't own will be hidden in the menu
+ expansions without an unlocked command table will be displayed, but disabled
+ de-/select the menu entries which expansion are no longer of interest to you
+ display the minimap button of the previous expansion as long current command table is yet unlocked
+ more to come...

---

### Interested in helping?

Contributors are most welcome!  
[Report a problem][^issues] when you find any errors on this addon's [issues page][^issues] or [email me][^mymail].  
[Start translating][^l10n] when you're missing your language or simply want to help with localization.  
[Leave a comment][^comments] if you have a *feature request* or *tell me what you think* about this addon.  

<!--- Contributor hyperlinks --->
[^issues]: <https://www.curseforge.com/wow/addons/mission-report-button-plus/issues>
[^mymail]: <mailto:erglo.coder@gmail.com>
[^l10n]: <https://www.curseforge.com/wow/addons/mission-report-button-plus/localization>
[^comments]: <https://www.curseforge.com/wow/addons/mission-report-button-plus#comments>

-----

#### Tools used:

- Microsoft's [Visual Studio Code][^vsc] with ...
  - Ketho's [World of Warcraft API][^ext1] extension
  - Stanzilla's [World of Warcraft TOC Language Support][^ext2]
- Version control management with [Git][^git]

<!--- Tools hyperlinks --->
[^vsc]: <https://code.visualstudio.com/>
[^ext1]: <https://github.com/Ketho/vscode-wow-api>
[^ext2]: <https://github.com/Stanzilla/vscode-wow-toc>
[^git]: <https://git-scm.com/>

#### References:
- Townlong Yak's [FrameXML archive][^framexml]
- WoWpedia's [World of Warcraft API][^wowpedia]
- [Wowhead.com][^wowhead]
- Matt Cone's [The Markdown Guide][^mdguide] *(Buy his [book][^mdbook]!)*
- The Git [Book][^gitbook]
- [Documentation][^vscdoc] for Visual Studio Code

<!--- References hyperlinks --->
[^framexml]: <https://www.townlong-yak.com/framexml/live>
[^wowpedia]: <https://wowpedia.fandom.com/wiki/World_of_Warcraft_API>
[^wowhead]: <https://www.wowhead.com>
[^mdguide]: <https://www.markdownguide.org>
[^mdbook]: <https://www.markdownguide.org/book>
[^gitbook]: <https://git-scm.com/book>
[^vscdoc]: <https://code.visualstudio.com/docs>
