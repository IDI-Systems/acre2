---
title: AN/PRC-152
permalink: radio_an-prc-152.html
sidebar: acre2_sidebar
folder: radio
---

The AN/PRC-152 Multiband Handheld Radio (Harris Falcon III) is a portable, compact, tactical software-defined combat-net radio manufactured by Harris Corporation.

## Basic Operation

### Interface

![AN/PRC-152 Interface](images/radio/an-prc-152_interface.png)


## Basic Use

### Function Switch

Left and right clicking the function switch will cycle between the 1st 6 preset channels on the radio. 
Additionally this can be used to turn off the radio by placing the switch in the left most position, turning it back to any of the channel positions will turn the radio back on.

### Volume Control

The radio volume can be adjusted using the volume control button on the left hand side of the radio, above the large press to talk key.

Left clicking on this will increase the volume, while right clicking will decrease the radio volume.
The volume setting will be displayed on the LCD screen when you use this button.

### Changing Channels

Click PRE +/- to change between channels. Alternatively, you can use the top knob to switch between channels 1-6.


## In-depth Operation

### Programming Instructions

The Farris radio operating system follows a standard across all farris radios for operational programming, usage, and menu navigation. 

#### Navigation

Menus and items are navigated with either the UP-DOWN or LEFT-RIGHT arrows; depending on the menu type. CLR will take you back at any time, and ENT is generally used for saving values. If you use CLR to back out of a menu, those settings are not saved. As you navigate through a series of menus, those values are not saved to the radio until the cycle is complete.


#### Entering values

Numerical values are entered with the number pad, clicking left and right to navigate the digit. Alphanumeric values are entered the same way, by repeatedly pressing the given button and cycling through letter options. Upon pressing a different button, that value is entered and the menu is moved to the next digit.


### Operational Programming

All operational programming modes are accessible through pressing 7-OPT button. Once entering this menu, you'll receive the operational programming menu. Operational changes to a radio are erased when the current channel is changed, unless auto-saving is on.

![AN/PRC-152 OPT Menu](images/radio/an-prc-152_opt-menu.png)

### Preset Programming

All operational programming modes are accessible through pressing 8-PGM->System Presets menu. Once entering this menu, you'll receive the operational programming menu. Operational changes to a radio are erased when the current channel is changed, unless auto-saving is on.

#### Programming a NET Preset

Press PGM, select System Preset Settings, select System Presets, use UP/DOWN to navigate the preset to modify. Begin changing settings.

![AN/PRC-152 PGM Menu](images/radio/an-prc-152_pgm-menu.png)
![AN/PRC-152 Preset Menu](images/radio/an-prc-152_preset-menu.png)

## Mission Editor Reference

### Adding radio to unit/object cargo inventory space

**Class name: `ACRE_PRC152`**

Can be added using the following methods.

**To a unit's inventory:**

```
unit [addItem](https://community.bistudio.com/wiki/addItem) "ACRE_PRC152";
unit [addItemToVest](https://community.bistudio.com/wiki/addItemToVest) "ACRE_PRC152";
unit [addItemToUniform](https://community.bistudio.com/wiki/addItemToUniform) "ACRE_PRC152";
unit [addItemToBackpack](https://community.bistudio.com/wiki/addItemToBackpack) "ACRE_PRC152";
```

**To an object's cargo inventory:**

```
object [addItemCargo](https://community.bistudio.com/wiki/addItemCargo) ["ACRE_PRC152",1];
object [addItemCargoGlobal](https://community.bistudio.com/wiki/addItemCargoGlobal) ["ACRE_PRC152",1];
```

### Channel Preset Data Fields

| Field name | Description |
| -------- | -------- | -------- |
| frequencyTX |  |
| frequencyRX |    | 
| power|  |
| encryption |  | 
| channelMode |  |
| name |  |
| CTCSSTx |  | 
| CTCSSRx |  |
| modulation |  |
| TEK |  | 
| trafficRate |  |
| syncLength |  |
| squelch |  | 
| deviation | |
| optioncode |  |
| rxOnly |  |

{% include links.html %}
