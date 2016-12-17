---
title: AN/PRC-148
---

The AN/PRC-148 Multiband Inter/Intra Team Radio (MBITR) is a secure handheld multiband, tactical software-defined radio. It was developed in the 1990’s entering service in 2000 with the US Army.

## Basic Operation

### Interface

{% include image.html file="radios/an-prc-148_interface.png" alt="AN/PRC-148 Interface" %}

### Power/Volume Control Knob

Left clicking will increase the radio’s volume to a maximum of 100%. Right clicking will decrease the radio’s volume to a minimum of 20%.

You can turn the radio off by holding control and right clicking the volume knob while it is at the minimum setting of 20%. To turn the radio back on simply left click the volume knob.

### Channel Knob

Left clicking the knob will increment the current channel selection through the 16 settings on the knob.

Right clicking will decrement the current channel selection through the 16 settings on the knob.

The channel knob has 16 settings, the channels available is dependant upon the current group selected.
By default: Group 1: Channels 1 - 16, Group 2: Channels 17 - 32, etc.

### LCD Display Screen

The LCD display screen is where all menus and information will be displayed. The primary/default display screen has two 'modes'. These are detailed in the graphic above.

The primary default display shows the current Group label, channel label, audio mode icon, battery indicator, operating mode, and encryption mode.

The alternate default display shows the current receiving (RX) and transmitting (TX) frequencies, current receiving (R) and transmitting (T) squelch tones, encryption key, data/traffic rate, and operating mode.

### Keypad

| Keypad | Function | ALT Function
| -------- | -------- | -------- |
| ALT   | Press and hold your keyboard ALT key for alternate functions  | Not Applicable |
| MODE  | Opens Mode Select screen | Opens Programming Menus screen |
| GR | Opens Group Select screen   | Opens Scan Operation screen |
| ESC | Closest current screen / Returns to previous screen   | Lock / Unlock keypad |
| ▼ | Decrement selection or value   | Highlights character to left of current selection |
| ▲ | Increment selection or value   | Highlights character to right of current selection |


## In-Depth Operation

### Group Select

The channel knob on the AN/PRC-148 can access 16 of the 100 programmable channels.
These are organized into groups of 16 channels. The channels available through the channel knob depend on the currently selected group.

Press the **GR** key to open the group select menu.

This menu displays the label of the currently selected group. To select a new group, press the **▼** or **▲** keys.

With the desired group highlighted, press **ENT** to select the new group and return to the default screen.

### Mode Menu

To change the radio Operating Mode, press the **MODE** key on the keypad.

The menu of available parameters appears on the display. To move the selection outline, use the **▼** or **▲**.

To change the selected parameter, first press **ENT** to select the currently highlighted menu item and use the **▼** or **▲** to change the selection value. Press **ENT** to confirm the change and move the outline to the next line.

The first line selects the audio path: internal audio, external audio, or external audio with sidetones enabled (INT/EXT AUDIO, SIDETONE).

The INT AUDIO setting will enable the internal speakers of the radio, all other settings currently use the external headset. None of the other MODE Select options, such as Emergency Beacon, are currently implemented.

### Programming Menu

To manually alter channel data for any of the AN/PRC-148's 100 channels the Programming Menu needs to be accessed.

The Programming Menu screen is accessed by pressing and holding the **ALT** keyboard key and pressing the **MODE** button on the keypad.

To select a sub-menu of the Programming Menu use the **▼** or **▲** keys and press **ENT** to select the desired menu. Currently the only implemented Sub-Menu is the "Program" menu, all other will return "ACCESS DENIED".

Within the Program menu there are a number of other options, currently the only functional option is the Channel programming menu, to enter this select Channel in the programming menu.

The Program Menu allows for the programming of a variety of radio functions. Currently only the "CHANNEL" sub-menu is implemented, which can be selected through the **▼** or **▲** and **ENT**.

### Channel Programming

The "Channel" Menu allows the user to program general channel data (channel number, encryption mode, channel label, transmission power, etc.) and select the operating mode (the type of radio operation to be programmed in a channel).

The screen opens with the Channel Number outlined. To change the channel use the Channel Knob. To navigate the channel programming menu use the **▼** and **▲** keys, and **ENT** to select a channel setting you would like to change.

#### Encryption Mode

To change the encryption mode setting use the **▼** or **▲** keys to toggle between "PLAIN" and "SECURE", press **ENT** to confirm.

#### Channel Label

The Channel Label setting allows the user to give the Channel a custom label.

When entering the Channel Label setting, the rightmost character will be in reverse video.
To select a new character, scroll up or down using the **▼** or **▲** keys.

Holding the **ALT** key and pressing **▲** will move to the character to the right of the current selection.
Holding the **ALT** key and pressing **▼** will move to the character to the left of the current selection.

When all the characters of the new label have been selected, press **ENT** to confirm.

#### Output Power

The Output Power ("PWE") can be set to: 0.1W, 0.5W, 1.0W, 3.0W or 5.0).
Use the **▼** or **▲** keys to scroll through the available power settings. Press **ENT** to confirm.

#### Operating Mode

WIP

#### RX & TX - Receive & Transmit Frequencies

The Receive Frequency (RX) is the frequency the radio will receive on when using the channel being edited.
The Transmit Frequency (TX) is the frequency the radio will transmit on when using the channel being edited.

To change the frequency, press **ENT**. To change the selected value, scroll up or down using the **▼** or **▲** keys.
To change the selected digit, hold the **ALT** key and press **▼** or **▲** to move selection left and right.

Note that the TX frequency automatically matches the RX frequency unless it is manually changed.

#### R & T - Receive & Transmit CTCSS Subtones

#### Modulation

#### Traffic Rate

#### Encryption Key

#### RPTR - Repeater Delay

#### FADE - Fade Bridge

#### PHASE - Crypto Synchronization

#### SQUELCH - Squelch Level

The squelch level determines the signal quality required to "break squelch" and activate the receiver.


## Mission Editor Reference

### Adding radio to unit/object cargo inventory space

**Class name: `ACRE_PRC148`**

Can be added using the following methods.

**To a unit's inventory:**

- unit [addItem](https://community.bistudio.com/wiki/addItem){:target="_blank"} "ACRE_PRC148";
- unit [addItemToVest](https://community.bistudio.com/wiki/addItemToVest){:target="_blank"} "ACRE_PRC148";
- unit [addItemToUniform](https://community.bistudio.com/wiki/addItemToUniform){:target="_blank"} "ACRE_PRC148";
- unit [addItemToBackpack](https://community.bistudio.com/wiki/addItemToBackpack){:target="_blank"} "ACRE_PRC148";

**To an object's cargo inventory:**

- object [addItemCargo](https://community.bistudio.com/wiki/addItemCargo){:target="_blank"} ["ACRE_PRC148",1];
- object [addItemCargoGlobal](https://community.bistudio.com/wiki/addItemCargoGlobal){:target="_blank"} ["ACRE_PRC148",1];

### Channel Preset Data Fields

| Field name | Description |
| -------- | -------- | -------- |
| power | Power Setting  |
| frequencyTX | Transmit Frequency |
| frequencyRX | Receive Frequency   |
| encryption | Encryption Mode |
| channelMode | Operating Mode |
| label | Channel Label |
| CTCSSTx | RX CTCSS Subtone |
| CTCSSRx | TX CTCSS Subtone |
| modulation | Modulation Type |
| trafficRate | Traffic / Data Rate |
| TEK | Encryption Key |
| RPTR | Repeater Delay |
| fade | Fade Bridge |
| phase | Crypto Synchronization |
| squelch | Squelch Level |


## Further Reading / External Links

- [United Operations Text Guide](http://www.unitedoperations.net/wiki/AN/PRC-148)
- [Youtube Instructional Video](https://www.youtube.com/watch?v=io3uzbYO0iU)
