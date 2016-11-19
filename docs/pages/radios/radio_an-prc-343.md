---
title: AN/PRC-343 PRR
permalink: radio_an-prc-343.html
folder: radios
---

The AN/PRC-343 PRR is short range lightweight intra-squad personal role radio originally known as
Marconi H4855 in British service. It is designed to be carried by every squad member and features 16
channel in 16 blocks (256 channels in total) with a range up to 500 meters.

## Operation

### Interface

![AN/PRC-343 Interface](images/radios/an-prc-343_interface.jpg)

The interface in ACRE 2 can be reached via two different ways:
+ double click the AN/PRC-343 in your inventory
- press the "Open Radio" key as it is defined in the ACRE 2 keyboard controls (Default : Ctrl+Alt+CapsLock)

For the second option you need the AN/PRC-343 as your active radio. If another radio opens instead,
use the ”Cycle Radio” key until the 343 is your active radio.

### Volume Control

Left clicking the volume knob increases the radio’s volume by 20 % to a maximum of 100 % while right
clicking decreases it to a minimum of 0 %.

### Channel Control

Left clicking the channel knob increases the channel by 1 while right clicking decreases it. The current
channel will also be shown in the lower left when you start transmitting. The channel knob has 16
different channels. If you want to access the other channels you have to left click the handle which offers
you the following view:

![AN/PRC-343 Channel Control](images/radios/an-prc-343_channel-control.jpg)

Left clicking the channel block knob increases the block by one to a maximum of 16 while right clicking
decreases it. The current block will be shown while transmitting. Changing the block has no influence
on the volume and channel knob setting. If you are on block 1 channel 13 and change your block by one,
you will be on block 2 channel 13 which is a different channel.

## Mission Editor Reference

### Adding radio to unit/object cargo inventory space

**Class name: `ACRE_PRC343`**

Can be added using the following methods.

**To a unit's inventory:**

```
unit [addItem](https://community.bistudio.com/wiki/addItem) "ACRE_PRC343";
unit [addItemToVest](https://community.bistudio.com/wiki/addItemToVest) "ACRE_PRC343";
unit [addItemToUniform](https://community.bistudio.com/wiki/addItemToUniform) "ACRE_PRC343";
unit [addItemToBackpack](https://community.bistudio.com/wiki/addItemToBackpack) "ACRE_PRC343";
```

**To an object's cargo inventory:**

```
object [addItemCargo](https://community.bistudio.com/wiki/addItemCargo) ["ACRE_PRC343",1];
object [addItemCargoGlobal](https://community.bistudio.com/wiki/addItemCargoGlobal) ["ACRE_PRC343",1];
```

### Channel Preset Data Fields

| Field name | Description |
| -------- | -------- | -------- |
| frequencyTX | Transmit Frequency |
| frequencyRX | Receive Frequency   |

{% include links.html %}
