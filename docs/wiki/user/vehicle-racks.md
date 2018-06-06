---
title: Vehicle Racks
---

{% include note.html content="Development Build only!" %}
{% include important.html content="Requires ACE3 Interaction Menu!" %}

ACRE2 allows the possibility of using racks in vehicles in order to increase the transmission power of a particular radio. There are different types of vehicle racks:

- **AN/VRC 103**: Allows mounting an *AN/PRC 117F*. Such radio will see its transmitting power increase from 20W to 50W.
- **AN/VRC 110**: Allows mounting an *AN/PRC 152*. A mounted radio will see its transmitting power increased from 5W to 50W.
- **AN/VRC 111**: Allows mounting an *AN/PRC 148*. A mounted radio will see its transmitting power increased from 5W to 20W.
- **SEM 90**: Allows mounting a *SEM 70*. This will increase transmitting power to 4W on low power and 40W on high power for the SEM 70.

In order to use and mount and unmount (when possible) a vehicle rack, ACE3 Interaction Menu is needed: simply interact with the vehicle when being in a seat with access to vehicle racks and select *use radio*. Multiple players will be able to use the radio simultaneously, except for the case of sending a transmission when the radio is already transmitting! Some vehicle racks, however, can be also accessed from outside the vehicle.

Configuring the vehicle rack (opening the radio GUI) is disabled for *turned out* positions.

## Vehicle intercom

In addition, vehicle racks are integrated into the intercom system. A rack with access to *crew* or *passenger* intercom allows players without access to the rack to hear incoming transmissions. These players however, will not be able to configure the radio nor transmit through it in the current implementation.

## Assigning presets to vehicle racks

It is now possible to assign a specific radio preset to a racked radio. This can be done using the API function `acre_api_fnc_setVehicleRacksPreset` before racks are initialised or calling it in the init field in the editor: `[this, "myCustomPreset"] call acre_api_fnc_setVehicleRacksPreset`.

## Assigning racks mid-mission or to non-enterable vehicles

Racks can also be dynamically added, removed or initialised using API functions.

- `acre_api_fnc_addRackToVehicle` allows adding a rack to the vehicle. The following line adds a AN/VRC-103 with an AN/PRC 117F connected to `intercom_1`. The rack can be accessed from outside only:
{% raw %}

```cpp
[cursorTarget, ["ACRE_VRC103", "Upper Dash", "Dash", false, ["external"], [], "ACRE_PRC117F", [], ["intercom_1"]], false, {}] call acre_api_fnc_addRackToVehicle
```
{% endraw %}

It is possible through this API function to add and initialise a rack on non-enterable objects like drones or communication tables.

- `acre_api_fnc_removeRackFromVehicle` allows removing a rack with a unique ID from a vehicle.
- `acre_api_fnc_initVehicleRacks` initialises all racks in a vehicle. This API function can be used to initialise racks on non-enterable vehicles. 
