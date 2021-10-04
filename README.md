Mission Report Button Plus
--------------------------

Adds a right-click menu to the mission report button on the minimap for selecting reports from previous expansions. 
*(See full feature list [below](#features))*  

![Button tooltip and right-click menu with expansion names](https://media.forgecdn.net/attachments/thumbnails/364/415/310/172/mbrp_tooltip-dropdown.jpg "Right-click on the Kyrian mission report button on the minimap opens the menu.") 
![The right-click menu with in-progess mission infos](https://media.forgecdn.net/attachments/thumbnails/364/416/310/172/mbrp_dropdown_bfa-missioncount.jpg "Mouse-over a menu entry shows details about running missions.")  
(More images on this [project's screenshots page](https://www.curseforge.com/wow/addons/mission-report-button-plus/screenshots))

### Problem  

As soon as a new WoW extension comes out the button on the minimap which opens the mission report frame is hidden until you reach the max. level of that extension and after you meet certain criteria in order to send your little helpers on missions. But only the reports to missions of the current extension can be viewed by the now _replaced_ minimap button, with _no other options_ to view other reports any more unless you visit your those other mission tables, and often only to find out that your too early and your missions are _not ready_.  
I was very pleased to see that the WoW Companion app for mobile phones finally addressed this problem, but the main game still doesn't.

### Solution  

It is still possible to access mission reports from previous extensions, but the Blizzard devs still haven't implemented a possibility for users to access those via the graphical interface. So here comes this add-on to work:  
+ it adds a right-click menu to the already available minimap button for mission reports,  
+ which gives you a selection and quick infos to reports of previous extensions, which are...  
+ **anytime and anywhere accessible.**  

---

## Features {#features}  

+ adds a right-click menu to the minimap button,
+ a click on an menu entry opens the (read-only) Mission Report Frame (aka. the `GarrisonLandingPage` frame) of the corresponding expansion,
+ informes you in chat about finished missions, talents, buildings (WoD garrison only) or garrison invasions,
+ choose from a variety of options and adjust the addon to your liking,
+ expansions you (yet) don't own will be hidden in the menu,
+ expansions without an unlocked command table will be displayed, but disabled, optionally showing you the requirement to unlock it,
+ de-/select the menu entries which expansion are no longer of interest to you,
+ display the minimap button of the previous expansion as long current command table is yet unlocked (still _experimental_),
+ or hide the minimap button if you don't use it (still _experimental_),
+ more to come...

---

### Interested in helping?  

Contributors are most welcome!  
[Report a problem](https://github.com/erglo/mission-report-button-plus/issues) when you find any errors on this project's issues page.  
[Start translating](https://www.curseforge.com/wow/addons/mission-report-button-plus/localization) when you're missing your language or simply want to help with localization.  
[Leave a comment](https://www.curseforge.com/wow/addons/mission-report-button-plus#comments) if you have a *feature request* or *tell me what you think* about this addon.  

---

### Tools used:  

- Microsoft's [Visual Studio Code](https://code.visualstudio.com) with ...
    - Ketho's [World of Warcraft API](https://github.com/Ketho/vscode-wow-api) extension
    - Stanzilla's [World of Warcraft TOC Language Support](https://github.com/Stanzilla/vscode-wow-toc)
- Version control management with [Git](https://git-scm.com)

### References:  

- Townlong Yak's [FrameXML archive](https://www.townlong-yak.com/framexml/live)
- WoWpedia's [World of Warcraft API](https://wowpedia.fandom.com/wiki/World_of_Warcraft_API)
- [Wowhead.com](https://www.wowhead.com)
- Matt Cone's [The Markdown Guide](https://www.markdownguide.org) *(Buy his [book](https://www.markdownguide.org/book)!)*
- [The Git Book](https://git-scm.com/book)
- [Documentation](https://code.visualstudio.com/docs) for Visual Studio Code
