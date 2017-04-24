---
title: Vehicle Intercom
---

{% include important.html content="API still WIP. May change in the future!" %}

Both features are currently supported only for `Car_F` and `Tank` classes and their children to maximize performance. Support for other classes can be added per request on the [issue tracker](https://github.com/IDI-Systems/acre2/issues).

## Vehicle crew intercom

Vehicle crew intercom is the system where crew inside vehicle can easily communicate among each other without noise disturbances.

By default, intercom is enabled for the following classes and their children:

- `Wheeled_APC_F`
- `MRAP_02_base_F`
- `Tank`
- `Helicopter`
- `Plane`
- `SDV_01_base_F`

If you are inheriting from one of those classes, no extra configuration is required for vehicle intercom functionality. The default positions where crew intercom is enabled include `"commander"`, `"driver"`, `"gunner"` and those positions labelled as `"turret"` excluding firing from vehicle (FFV) turrets.

The system can be further modified in orther to customise which positions have access to crew intercom. The following configuration entries illustrate some of the possibilities:

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

## Vehicle passenger Intercom

Passenger intercom is the system where non crew members inside vehicle can easily communicate among each other without noise disturbances. Crew members can also be part of passenger intercom.
By default passenger intercom is disabled by default.

{% include important.html content="Requires ACE3 Interaction Menu!" %}

The system can be enabled and configured using the following configuration entries:

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        acre_hasPassengerIntercom = 1; // 1 - enabled, 0 - disabled
        // The default configuration is used. Units in crew intercom and in cargo positions have access to the passenger intercom. If left empty it has the same effect.
        acre_passengerIntercomPositions[] = {"default"};
        // Excludes units from accessing the passenger intercom. In this example, gunner, cargo index 1 and all FFV turrets do not have access to passenger intercom.
        acre_passengerIntercomExceptions[] = {"gunner", {"cargo", 1}, {"ffv", "all"}};
        // -1 to set the number of connections equal to the amount of passenger intercom positions. A number greater
        // than 0 limits the number of available connections for passengers. Crew members do not use this number.
        acre_passengerIntercomConnections = -1;
    };
};
```
{% endraw %}

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        acre_hasPassengerIntercom = 1; // 1 - enabled, 0 - disabled
        // Units in crew intercom, in cargo positions 1 and 2 and all FFV turrets have access to the passenger intercom.
        acre_passengerIntercomPositions[] = {{"Cargo", 1, 2}, {"ffv", "all"}};
        // Excludes unit in FFV turret [4] to access from accessing passenger intercom.
        acre_passengerIntercomExceptions[] = {{"ffv", [4]}};
        // -1 to set the number of connections equal to the amount of passenger intercom positions. A number greater
        // than 0 limits the number of available connections for passengers. Crew members do not use this number.
        acre_passengerIntercomConnections = 2; // Only two units with access to passenger intercom can connect simultaneously.
    };
};
```
{% endraw %}

## Infantry telephone

Infantry telephone is the system where infantry can communicate with the crew inside tanks and IFVs using a telephone mounted on the outside of the vehicle.

{% include important.html content="Requires ACE3 Interaction Menu!" %}

By default, infantry telephone is enabled only for `Tank` class and its children.

To add infantry telephone to a vehicle class and configure its properties, use the following config entry:

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        acre_hasInfantryPhone = 1; // 1 - enabled, 0 -
        // Intercom the infantry phone can connect to. If left empty, the infantry phone is able to connect to all available intercom networks. Supported entries are "crew" and "passenger".
        acre_infantryPhoneDisableRinging = 0;   // If set to 1, the ringing funtionality will not be available.
        acre_infantryPhoneCustomRinging[] = {}; // An array used in order to override the default sound for the ringing functionality.
        acre_infantryPhoneIntercom[] = {"crew", "passenger"};
        // Here a custom function can be defined that is called when the infantry phone is picked up, put back, given to another unit or the intercom network is switched.
        acre_eventInfantryPhone = QFUNC(noApiFunction);
    };
};
```
{% endraw %}

### Ringing and ringing sound

The infantry phone has the ringing functionality configured by default. However, it can be disabled by setting `acre_infantryPhoneDisableRinging` to 1. In addition, the default ringing sound in ACRE2 can be also overwritten, on a class basis, through the `acre_infantryPhoneCustomRinging` entry. This entry consists of an array of five elements and it will do nothing if left blank. The five entries are mandatory in order for the function `playSound3D` to work as intended in ACRE2.

- 0: Path to sound file <STRING>
- 1: Duration (sound is a PFH so we need to specify a duration) <NUMBER>
- 2: Volume the sound plays at <NUMBER>
- 3: Sound pitch <NUMBER>
- 4: How far the sound is audible <NUMBER>

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        acre_hasInfantryPhone = 1; // 1 - enabled, 0 -
        // Intercom the infantry phone can connect to. If left empty, the infantry phone is able to connect to all available intercom networks. Supported entries are "crew" and "passenger".
        acre_infantryPhoneDisableRinging = 0;   // If set to 1, the ringing funtionality will not be available.
        acre_infantryPhoneCustomRinging[] = "A3\Sounds_F\sfx\alarm_independent.wss", 5.0, 1.0, 1.0, 50}; // The alarm sound will be played every 5 seconds and will be audible until 50m. Volume and sound pitch are both set to 1.
        acre_infantryPhoneIntercom[] = {"crew"};
        // Here a custom function can be defined that is called when the infantry phone is picked up, put back, given to another unit or the intercom network is switched.
        acre_eventInfantryPhone = QFUNC(noApiFunction);
    };
};
```
{% endraw %}

### Position

Additionally, infantry telephone interaction is put on the main interaction node (center of vehicle) if no custom position is defined in config. Custom position can be set using a config entry to put the interaction node anywhere on the hull of the vehicle. This position will also be used as a sound source for the ringing functionality.

```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        acre_infantryPhonePosition[] = {-1.1, -4.86, -0.82}; // Coordinates in model space or a string with a memory point.
    };
};
```

ACRE2 provides helper functions for retrieving the position and quickly making sure they are correct. If you build ACRE2 locally, you can uncomment defines in `sys_intercom/script_component.hpp`:

- `DRAW_INFANTRYPHONE_INFO` draws text with class name of the vehicle and current position at the current position on the model (when pointing at the vehicle).
- `DRAW_CURSORPOS_INFO` draws an arrow where your cursor is pointing to. Current position is saved in `xPosModel` variable which can easily be watched in the debug console to retrieve precise coordinates in model space for direct use in config.

### Custom function

An entry is provided in order to be able to execute a custom function if the infantry phone is picked up, put back, given to another unit or the intercom network is switched. By default a dummy function is called, but any other function could be defined instead on a class basis. This can be useful if the vehicle has a hatch that gets opened when the infantry phone is picked up for example. The arguments passed to this function are:

- 0: Vehicle with infantry phone (OBJECT)
- 1: Infantry phone unit (OBJECT)
- 2: Infantry phone action (1: return, 2: pick-up, 3: give, 4: switch network) (NUMBER)

The following configuration would execute, in a **unscheduled enviroment**, `myCustomFunction`:

```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        acre_hasInfantryPhone = 1;
        acre_infantryPhonePosition[] = {-1.1, -4.86, -0.82};
        acre_eventInfantryPhone = "myCustomFunction";
    };
};
```

## Entries and wildcards

The framework recognises the following entries and wildcards for the configuration files:

{% raw %}
- **Entries**: `"cargo"`, `"commander"`, `"driver"`, `"gunner"`, `"turret"` (non FFV) and `"ffv"` (FFV turrets).
- **Wildcards**:
  - `"crew"`: selects all crew members `"commander"`, `"driver"`, `"gunner"`, `"turret"` (non FFV) and it can be combined with other entries. For example `{"crew", {"cargo", 1}}`.
  - `"all"` can be combined with  `"cargo"`, `"turret"` and `"ffv"` and selects all entries of this category. For example `{{"cargo", 1}, {"ffv", "all"}}`.
  - `"default"` selects all crew members in `acre_crewIntercomPositions` or all the cargo entries if defined in `acre_passengerIntercomPositions`. It cannot be combined with any other entry.
{% endraw %}

## Configuration examples

The following vehicle has crew and passenger intercom as well as infantry telephone.

- Crew intercom is enabled for all the default crew positions (`"commander"`, `"driver"`, `"gunner"` and those positions labelled as `"turret"` excluding firing from vehicle (FFV) turrets) with the exception of `"driver"` and `"commander"` FFV turret.
- Passenger intercom is available for all the previously defined crew members plus all `"cargo"` positions and for the `"driver"` with the exception of the `"commander"`, `"cargo"` index 1 and all FFV turrets. Additionally only two non-crew units can connect simultaneously.
- The infantry telephone that can have access to both crew and passenger intercom networks. Units can interact with the infantry telephone at  `{-1.1, -4.86, -0.82}` model space coordinates.

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        // Crew Intercom
        acre_hasCrewIntercom = 1;
        acre_crewIntercomPositions[] = {"default"};
        acre_crewIntercomExceptions[] = {"driver", {"turret", {0,0}}};

        // Passenger intercom
        acre_hasPassengerIntercom = 1;
        acre_passengerIntercomPositions[] = {{"cargo", "all"}, "driver"};
        acre_passengerIntercomExceptions[] = {"commander", {"Cargo", 1}, {"ffv", "all"}};
        acre_passengerIntercomConnections = 2;

        // Infantry Phone
        acre_hasInfantryPhone = 1;
        acre_infantryPhoneIntercom[] = {"crew", "passenger"};
        acre_infantryPhonePosition[] = {-1.1, -4.86, -0.82};
        acre_infantryPhoneDisableRinging = 0; // If set to 1, the ringing funtionality will not be available.
        acre_infantryPhoneCustomRinging[] = {"A3\Sounds_F\sfx\alarm_independent.wss", 5.0, 1.0, 1.0, 50}; // The alarm sound will be played every 5 seconds and will be audible until 50m. Volume and sound pitch are both set to 1.
    };
};
```
{% endraw %}
