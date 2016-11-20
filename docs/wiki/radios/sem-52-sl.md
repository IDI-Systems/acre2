---
title: SEM 52 SL
---

The SEM 52 SL (Sender/Empfänger, mobil SEM 52 SL) is a small power radio for military purposes in the German Army. It was issued in 1995 and succeeds the SEM 52 S. As a modern radio it can transmit voice and data. To transmit voice a built-in loudspeaker / microphone is used. An external microphone can also be connected. The frequency band is from 46 to 65,975 MHz. The channel spacing is 25 KHz. 800 channels are available.

## Technical Data

- **Frequency band:** 46,000 to 65,975 MHz
- **Channel spacing:** 25 KHz (default)
- **Channel presets:** 12 permanent + 1 volatiles (Channel H)
- **Operating mode:** Simplex or Semiduplex
- **Operating voltage:** 8 to 15 V
- **Transmitting capacity:** 1 W (selectable internally 0,3 – 2 W)
- **Antenna:** 0,4 m (modelled) or 0,9 m


## Basic Operation:

### Interface

![SEM 52 SL Interface](/images/radios/sem-52-sl_interface.jpg)

### Volume Control Knob

The volume control knob has 16 settings and is divided in volume control with (filled volume arrow) and without squelch (open volume arrow). Operating the radio without squelch is not modelled. Right and left clicking will decrease / increase the radio volume by 12.5%. The minimum volume is 0%.

### Channel Knob

The radio can be turned on (EIN) and off (AUS). Left clicking the knob will increment the current channel presets. Right clicking will decrement the current channel presets. If you turn the radio to on (EIN) the last selected channel preset is displayed in the LCD.

The SEM 52 SL has 12 + 1 (Channel H) programmable channel presets. Channel H is volatile and the programmed frequency will be lost if you turn off your radio.

If a channel has been active for more than 3 seconds it will become the active one. If you turn your radio to on (EIN) this channel will bee shown in the LCD.

Channel P is used for programming the radio.

### LCD Display Screen

The LCD display shows the current frequency if you have a channel preset selected. If the radio is turned to on (EIN) the current preset number is shown. If you have channel H selected and the channel is not programmed noFr (no Frequency) is shown in the display.


## In-Depth Operation

### Programming

The SEM 52 SL can be programmed by turning the channel preset knob to P.

Upon selecting channel P, the to be programmed channel can be selected by turning the volume knob one step to the right to increase the preset number or one step to the left to decrease it. The channel preset will increment / decrement automatically.

If your desired Channel is flashing in the display, press the PTT button once to enter the frequency. The MHz digits will start to flash. You can increase / decrease the MHz by turning the volume knob one step to the left or right. The MHz will change in 1 MHz steps. If you have reached your desired MHz press the PTT button once. The KHz will start to flash. You can now select the desired KHz accordingly. The KHz are set in 25 KHz steps. If you are finished press the PTT button once to save and exit the programming mode for the selected channel.


## Mission Editor Reference

### Adding radio to unit/object cargo inventory space

**Class name: `ACRE_SEM52SL`**

Can be added using the following methods.

**To a unit's inventory:**

- unit [addItem](https://community.bistudio.com/wiki/addItem){:target="_blank"} "ACRE_SEM52SL";
- unit [addItemToVest](https://community.bistudio.com/wiki/addItemToVest){:target="_blank"} "ACRE_SEM52SL";
- unit [addItemToUniform](https://community.bistudio.com/wiki/addItemToUniform){:target="_blank"} "ACRE_SEM52SL";
- unit [addItemToBackpack](https://community.bistudio.com/wiki/addItemToBackpack){:target="_blank"} "ACRE_SEM52SL";

**To an object's cargo inventory:**

- object [addItemCargo](https://community.bistudio.com/wiki/addItemCargo){:target="_blank"} ["ACRE_SEM52SL",1];
- object [addItemCargoGlobal](https://community.bistudio.com/wiki/addItemCargoGlobal){:target="_blank"} ["ACRE_SEM52SL",1];

## Further Reading / External Links

[Greenradio.de](http://www.greenradio.de/e_sem52sl.htm){:target="_blank"}

[Youtube Instructional Video](https://www.youtube.com/watch?v=TPzkBB-UWBg){:target="_blank"} (German)

German Army manual: TDv 5820/357-13 - Funkgerätesatz VHF (tragbar) SEM 52-SL
