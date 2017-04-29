---
title: SEM 70
---

The SEM 70 (Sender/Empfänger, mobil SEM 70) is a manpack radio for military purposes in the German Army. It was issued in 1984. As a modern radio it can transmit voice and data. The frequency band is from 30 to 79,975 MHz. The channel spacing is 25 KHz by default. It features a manual channel (`Handwahl (HW)`) and an automatic channel (`Automatische Kanalwahl (AKW)`) mode.

## Technical Data

- **Frequency band:** 30,000 to 79,975 MHz
- **Channel spacing:** 25 KHz (default) or 50 kHz
- **Channel presets:** Manual channel and up to 10 memory slots for automatic channel selection
- **Operating mode:** Simplex or Semiduplex
- **Operating voltage:** 16.8 V
- **Transmitting capacity:** 4 W or 0.4 W
- **Antenna:** 0,4 m or 1,03 m

## Primer On Automatic Channel Mode (AKW)

While in automatic channel mode, the operator can select from 10 Channels. Each channels combines 16 different frequencies, which can't be changed by the operator. While no transmission is active, every radio continously scans all 16 frequencies in a loop. If a transmission is initiated, the sending radio randomly selects a frequency on which all receiving radios lock on. In real life this usually takes about 0.7 Seconds, in ACRE2 there is no such delay (may be added at a later point).
However, to establish a valid connection between two or more radios, the following parameters must be the same on all involved radios:
- Channel Setup (Channels/Frequencies must be identical for each radio)
- Memory Slot (Channel)
- Network Identifier (Three digit number)

## Basic Operation

### Interface

{% include image.html file="radios/sem-70_interface.png" alt="SEM 70 Interface" %}

### Volume Knob

Sets the overall volume of the radio, 6 settings are available.

### Power Knob

The radio features two different power settings. On high power setting (`GR`) the output is 4 Watts and on low power setting (`KL`) the output is 0.4 Watts. If the knob is set to off (`AUS`), the radio can't transmit or receive anything.

### Mode Selector Knob

Currently the SEM 70 in ACRE2 features both manual channel (`HW`) and automatic channel (`AKW`) mode. All other settings will be ignored at the moment.

### Frequency Knobs

In manual channel mode, the frequency can be set to a fixed value. This is equivalent to other radios single channel mode. The MHz can be set with the knob on the left side of the display and the kHz with the knob on the right side.

### Memory Slot Knob

In automatic channel mode, there are 10 channels available to be used.

### Network Knobs

In automatic channel mode, the network number must be identical on every radio in order to establish a connection.

### Display Knob

To show the current frequency (manual channel mode) or channel setting (automatic channel mode), the display knob can be depressed.

## Mission Editor Reference

### Adding radio to unit/object cargo inventory space

**Class name: `ACRE_SEM70`**

Can be added using the following methods.

**To a unit's inventory:**

- unit [addItem](https://community.bistudio.com/wiki/addItem){:target="_blank"} "ACRE_SEM70";
- unit [addItemToVest](https://community.bistudio.com/wiki/addItemToVest){:target="_blank"} "ACRE_SEM70";
- unit [addItemToUniform](https://community.bistudio.com/wiki/addItemToUniform){:target="_blank"} "ACRE_SEM70";
- unit [addItemToBackpack](https://community.bistudio.com/wiki/addItemToBackpack){:target="_blank"} "ACRE_SEM70";

**To an object's cargo inventory:**

- object [addItemCargo](https://community.bistudio.com/wiki/addItemCargo){:target="_blank"} ["ACRE_SEM70",1];
- object [addItemCargoGlobal](https://community.bistudio.com/wiki/addItemCargoGlobal){:target="_blank"} ["ACRE_SEM70",1];

## Further Reading / External Links

- [Greenradio.de](http://www.greenradio.de/e_sem70.htm){:target="_blank"}
- [Youtube Instructional Video](https://www.youtube.com/watch?v=kztzUMoBojc){:target="_blank"} (German)
- German Army manual: TDv 5820-135-12 - Funkanlagen A/VHF Funkgerät SEM 70
