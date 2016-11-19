---
title: AN/PRC-117F
permalink: radio_an-prc-117f.html
folder: radios
---

_Work in progress, this radio and the documentation is not yet final._

See [AN/PRC-152](radio_an-prc-152) for general operation guidelines.

## Interface

![AN/PRC-117F Interface](images/radios/an-prc-117f_interface.png)


## Mission Editor Reference

### Adding radio to unit/object cargo inventory space

**Class name: `ACRE_PRC117F`**

Can be added using the following methods.

**To a unit's inventory:**

As the PRC-117F is a manpack radio a unit is required to have a backpack to carry this.
Additionally, the PRC-117F can only be added to a unit's backpack.

```
unit [addItemToBackpack](https://community.bistudio.com/wiki/addItemToBackpack) "ACRE_PRC117F";
```

**To an object's cargo inventory:**

```
object [addItemCargo](https://community.bistudio.com/wiki/addItemCargo) ["ACRE_PRC117F",1];
object [addItemCargoGlobal](https://community.bistudio.com/wiki/addItemCargoGlobal) ["ACRE_PRC117F",1];
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
| active |  |

{% include links.html %}
