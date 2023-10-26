---
title: Vehicle Racks
---

{% include important.html content="Requires ACE3 Interaction Menu if no Intercom is configured for a given vehicle!" %}

ACRE2 allows the possibility of using racks in vehicles in order to increase the transmission power of a particular radio. There are different types of vehicle racks:

- **AN/VRC 64**: Allows mounting an *AN/PRC 77*, increasing its transmitting power from 3.5W to 50W.
- **AN/VRC 103**: Allows mounting an *AN/PRC 117F*, increasing its transmitting power from 20W to 50W.
- **AN/VRC 110**: Allows mounting an *AN/PRC 152*, increasing its transmitting power from 5W to 20W.
- **AN/VRC 111**: Allows mounting an *AN/PRC 148*, increasing its transmitting power from 5W to 20W.
- **SEM 90**: Allows mounting a *SEM 70*, maintaining its transmitting power at 4W on low power or increasing it to 40W on high power.

In order to use and mount and unmount (when possible) a vehicle rack, ACE3 Interaction Menu is needed: simply interact with the vehicle when being in a seat with access to vehicle racks and select *use radio*. Multiple players will be able to use the radio simultaneously, except for the case of sending a transmission when the radio is already transmitting! Some vehicle racks, however, can be also accessed from outside the vehicle.

Configuring the vehicle rack (opening the radio GUI) is disabled for *turned out* positions.

## Vehicle intercom

In addition, vehicle racks are integrated into the intercom system. A rack with access to *crew* or *passenger* intercom allows players without access to the rack to hear incoming transmissions. These players however, will not be able to configure the radio nor transmit through it in the current implementation.

Radios that are connected to an intercom cannot be accessed using the ACE Interaction Menu. Instead, one must open the Intercom UI (default <kbd>⇧&nbsp;Shift</kbd>+<kbd>Ctrl</kbd>+<kbd>Tab&nbsp;⇥</kbd>) and select the desired radio(s) using the upper two knobs as described in the [intercom section](/wiki/user/vehicle-intercom#full-functional-crew-station-ffcs)
