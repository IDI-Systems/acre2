---
title: Vehicle Racks (WIP)
---

{% include important.html content="API still WIP. May change in the future!" %}

Both features are currently supported only for vanilla classes and their children to maximize performance. Support for other classes can be added per request on the [issue tracker](https://github.com/IDI-Systems/acre2/issues).

## Vehicle crew intercom

Vehicle racks is the system where crew inside vehicle can use mounted radios or mount personal radios in order to increase the transmission power.

By default, vehicle racks are enabled for the following classes and their children:

- `MRAP_01_base_F`
- `Helicopter_Base_F`
- `Plane_Base_F`
- `Tank_F`
- `Wheeled_APC_F`

If you are inheriting from one of those classes, no extra configuration is required for vehicle racks functionality. The default positions where racks are accesible include `"commander"`, `"driver"`, `"gunner"` and those positions labelled as `"turret"` excluding firing from vehicle (FFV) turrets.

The system can be further modified in orther to customise which positions have access to vehicle racks. The following configuration entries illustrate some of the possibilities:

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        acre_hasCrewIntercom = 1; // 1 - enabled, 0 - disabled
        // The default configuration is used. Units in commander, driver, gunner and turret (excluding FFV) have access to crew intercom.
        // If left empty it has the same effect.
        acre_crewIntercomPositions[] = {"default"};
        // In this case the commander turret does not have access to crew intercom (unit is "turned out"). This can be useful for historical vehicles.
        acre_crewIntercomExceptions[] = {{"Turret", {0,0}}};
    };
};
```
{% endraw %}

The following example enables crew intercom for only driver and commander positions and the turret positions different from [1] and [2] as well as the commander's turn out turret position.

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        acre_hasCrewIntercom = 1; // 1 - enabled, 0 - disabled
        // "all" is a wildcard that selects, in this case, all turrets (not including ffv).
        acre_crewIntercomPositions[] = {"driver", "commander", {"turret", "all"}};
        // Commander FFV turret and turret positions [1] and [2] do not have access to crew intercom.
        acre_crewIntercomExceptions[] = {{"Turret", {0,0}, {1}, {2}}};
    };
};
```
{% endraw %}

## Entries and wildcards

The framework recognises the following entries and wildcards for the configuration files:

{% raw %}
- **Entries**: `"cargo"`, `"commander"`, `"driver"`, `"gunner"`, `"copilot"` (only helicopters and planes), `"turret"` (non FFV), `"ffv"` (FFV turrets) and `"turnedOut"`. The `"turnedOut"` entry is only valid for the `exception` configuration array and it can be combined with any other entries (`"commander"`, `"driver"`, `"gunner"`, `"copilot"`), cargo indexes and turrets. For example `{{"turnedOut", 1, [3], "driver"}}` will prevent access to cargo index 1, driver and turret [3] when they are turned out.
- **Wildcards**:
  - `"crew"`: selects all crew members `"commander"`, `"driver"`, `"gunner"`, `"turret"` (non FFV) and it can be combined with other entries. For example `{"crew", {"cargo", 1}}`.
  - `"inside"`: selects all units inside a vehicle.
  - `"external"`: rack can be used only externally.
  - `"all"` can be combined with  `"cargo"`, `"turret"`, `"ffv"` and `"turnedout"` and selects all entries of this category. For example `{{"cargo", 1}, {"ffv", "all"}}`.
  - `"default"` selects all crew members in `acre_crewIntercomPositions` or all the cargo entries if defined in `acre_passengerIntercomPositions`. It cannot be combined with any other entry.
{% endraw %}

## Configuration examples

The following vehicle has crew and passenger intercom as well as infantry telephone.

- Crew intercom is enabled for all the default crew positions (`"commander"`, `"driver"`, `"gunner"` and those positions labelled as `"turret"` excluding firing from vehicle (FFV) turrets) with the exception of `"driver"` and when player is turned out in all positions.
- Passenger intercom is available for all the previously defined crew members plus all `"cargo"` positions and for the `"driver"` with the exception of the `"commander"`, `"cargo"` index 1, all FFV turrets and turned out positions in the `"driver"`, `"gunner"`, `"cargo"` index 2 and `"turrent"` [2]. Additionally only two non-crew units can connect simultaneously.
- The infantry telephone that can have access to both crew and passenger intercom networks. Units can interact with the infantry telephone at  `{-1.1, -4.86, -0.82}` model space coordinates.

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        // Crew Intercom
        acre_hasCrewIntercom = 1;
        acre_crewIntercomPositions[] = {"default"};
        acre_crewIntercomExceptions[] = {"driver", {"turnedout", "all"}};

        // Passenger intercom
        acre_hasPassengerIntercom = 1;
        acre_passengerIntercomPositions[] = {{"cargo", "all"}, "driver"};
        acre_passengerIntercomExceptions[] = {"commander", {"Cargo", 1}, {"ffv", "all"}, {"turnedout", 2, "driver", "gunner", [2]}};
        acre_passengerIntercomConnections = 2;

        // Infantry Phone
        acre_hasInfantryPhone = 1;
        acre_infantryPhoneIntercom[] = {"crew", "passenger"};
        acre_infantryPhonePosition[] = {-1.1, -4.86, -0.82};
    };
};
```
{% endraw %}
