---
title: Vehicle Intercom
---

Both features are currently supported only for vanilla classes and their children to maximize performance. Support for other classes can be added per request on the [issue tracker](https://github.com/IDI-Systems/acre2/issues).

{% include important.html content="Requires ACE3 Interaction Menu!" %}

## Vehicle Intercom

Vehicle intercom is the system where units in a vehicle can easily communicate among each other without noise disturbances. In ACRE2 several intercoms can coexist in a vehicle.

By default, intercom is enabled for the following classes and their children:

- `Wheeled_APC_F`
- `MRAP_02_base_F`
- `Tank`
- `Helicopter`
- `Plane`
- `SDV_01_base_F`

If you are inheriting from one of those classes, no extra configuration is required for vehicle intercom functionality. The basic configuration includes an intercom network for crew members (`"commander"`, `"driver"`, `"gunner"` and those positions labelled as `"turret"` excluding firing from vehicle (FFV) turrets) and another network for cargo positions or passengers in case they are present.

The system can be further modified in order to customise which positions have access to intercom. The following configuration entries illustrate some of the possibilities:

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        class AcreIntercoms {
            class Intercom_1 {                             // Each entry defines a network
                displayName = "Crew intercom";             // Name of the intercom network displayed to the players
                shortName = "Crew";                        // Short name of the intercom network. Maximum of 5 characters
                // Seats with stations configured that have intercom access. In this case, units in commander, driver, gunner and turret (excluding FFV) have access to this intercom
                // If left empty it has the same effect
                allowedPositions[] = {"crew"};
                // In this case the commander turret does not have access to crew intercom (unit is "turned out"). This can be useful for historical vehicles (default: {})
                disabledPositions[] = {{"Turret", {0,0}}};
                // Despite not having regular access to the network, units in cargo positions can have limited connections to communicate with the crew. These positions do not transmit automatically in the limited network; units in this position must toggle the functionality manually. (default: {})
                limitedPositions[] = {{"cargo", "all"}};
                // This is the number of simultaneous connections that units defined in the previous array can have (default: 0)
                numLimitedPositions = 1;
                // Seats with master stations have the possibility of broadcasting a message in that network (default: {})
                masterPositions[] = {"commander"};
                // The intercom initial configuration is enabled upon entering a vehicle (default: 0)
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = "Pax intercom";
                shortName = "Pax";
                // Both crew and cargo positions have access to passenger intercom
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                // The intercom initial configuration is disabled upon entering a vehicle (default behaviour)
                connectedByDefault = 0;
            };
        };
    };
};
```
{% endraw %}

The following example enables an intercom network for only driver and commander positions and the turret positions different from [1] and [2] as well as the commander's turn out turret position. A second intercom network is enabled to all stations except for gunner, cargo index 1 and all FFV turrets, while a third intercom is available for some of the cargo positions. The master position is defined for the commander seat only.

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        class AcreIntercoms {
            class Intercom_1 {                             // Each entry defines a network
                displayName = "Crew intercom";             // Name of the intercom network displayed to the players
                shortName = "Crew";
                // "all" is a wildcard that selects, in this case, all turrets (not including ffv)
                allowedPositions[] = {"driver", "commander", {"turret", "all"}};
                // Commander FFV turret and turret positions [1] and [2] do not have access to crew intercom
                disabledPositions[] = {{"Turret", {0,0}, {1}, {2}}};
                // Noone else can have access to this intercom network
                limitedPositions[] = {};
                masterPositions[] = {"commander"};
                numLimitedPositions = 0;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom 1 {
                displayName = "Passenger intercom";
                shortName = "Pax";
                // Units in crew and in cargo positions have access to the passenger intercom
                allowedPositions[] = {"crew", {"cargo", "all"}};
                // Excludes units from accessing the passenger intercom. In this example, gunner, cargo index 1 and all FFV turrets do not have access to passenger intercom
                disabledPositions[] = {"gunner", {"cargo", 1}, {"ffv", "all"}};
                connectedByDefault = 0;
            };
            class Intercom_3: Intercom 2 {
                displayName = "Cargo intercom";
                shortName = "Crg";
                // Units in cargo positions 1 and 2 and all FFV turrets have access to the passenger intercom
                allowedPositions[] = {{"cargo", 1, 2}, {"ffv", "all"}};
                // Excludes unit in FFV turret [4] to access from accessing passenger intercom, as well as cargo index 1 and turret [1]
                // when they are turned out
                disabledPositions[] = {{"ffv", [4]}, {"turnedOut", 1, {1}}};
            }
        };
    };
};
```
{% endraw %}

## Infantry Telephone

Infantry telephone is the system where infantry can communicate with units inside tanks and IFVs using a telephone mounted on the outside of the vehicle.

By default, infantry telephone is enabled only for `Tank` class and its children.

To add infantry telephone to a vehicle class and configure its properties, use the following config entry:

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        acre_hasInfantryPhone = 1; // 1 - enabled, 0 - disabled (default: 0)
        acre_infantryPhoneDisableRinging = 0;   // If set to 1, the ringing funtionality will not be available (default: 0)
        acre_infantryPhoneCustomRinging[] = {}; // An array used in order to override the default sound for the ringing functionality (default: {})
        // List of intercom names (intercom_1, intercom_2) or "all" in order to specify which intercom networks the phone can connect to
        acre_infantryPhoneIntercom[] = {"all"};
        acre_infantryPhoneControlActions[] = {"intercom_1"}; // Only those units in "intercom_1" can have access to ringing functionality
        // Here a custom function can be defined that is called when the infantry phone is picked up, put back, given to another unit or the intercom network is switched
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
        acre_hasInfantryPhone = 1; // 1 - enabled, 0 - disabled
        acre_infantryPhoneDisableRinging = 0;   // If set to 1, the ringing funtionality will not be available
        acre_infantryPhoneCustomRinging[] = "A3\Sounds_F\sfx\alarm_independent.wss", 5.0, 1.0, 1.0, 50}; // The alarm sound will be played every 5 seconds and will be audible until 50m. Volume and sound pitch are both set to 1
        acre_infantryPhoneIntercom[] = {"all"};
        acre_infantryPhoneControlActions[] = {"intercom_1"}; // Only those units in "intercom_1" can have access to ringing functionality
        // Here a custom function can be defined that is called when the infantry phone is picked up, put back, given to another unit or the intercom network is switched
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
- **Entries**: `"cargo"`, `"commander"`, `"driver"`, `"gunner"`, `"copilot"` (only helicopters and planes), `"turret"` (non FFV), `"ffv"` (FFV turrets) and `"turnedOut"`. The `"turnedOut"` entry is only valid for the `exception` configuration array and it can be combined with any other entries (`"commander"`, `"driver"`, `"gunner"`, `"copilot"`), cargo indexes and turrets. For example `{{"turnedOut", 1, [3], "driver"}}` will prevent access to cargo index 1, driver and turret [3] when they are turned out.
- **Wildcards**:
  - `"crew"`: selects all crew members `"commander"`, `"driver"`, `"gunner"`, `"turret"` (non FFV) and it can be combined with other entries. For example `{"crew", {"cargo", 1}}`.
  - `"inside"`: selects all units inside a vehicle.
  - `"all"` can be combined with  `"cargo"`, `"turret"`, `"ffv"` and `"turnedout"` and selects all entries of this category. For example `{{"cargo", 1}, {"ffv", "all"}}`.
{% endraw %}

## Configuration examples

The following vehicle has crew and passenger intercom as well as infantry telephone.

- Crew intercom is enabled for all the default crew positions (`"commander"`, `"driver"`, `"gunner"` and those positions labelled as `"turret"` excluding firing from vehicle (FFV) turrets) with the exception of `"driver"` and when player is turned out in all positions. Units in cargo positions can access the intercom, but only two units simultaneously.
- Passenger intercom is available for all the previously defined crew members plus all `"cargo"` positions and for the `"driver"` with the exception of the `"commander"`, `"cargo"` index 1, all FFV turrets and turned out positions in the `"driver"`, `"gunner"`, `"cargo"` index 2 and `"turrent"` [2].
- The infantry telephone that can have access to both crew and passenger intercom networks. Units can interact with the infantry telephone at  `{-1.1, -4.86, -0.82}` model space coordinates. Only those units in the crew intercom can make the phone ring.

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = "Crew intercom";
                shortName = "Crew";
                allowedPositions[] = {"crew"};
                disabledPositions[] = {"driver", {"turnedout", "all"}};
                limitedPositions[] = {{"cargo", "all"}};
                numLimitedPositions = 2;
                masterPositions[] = {"commander"};
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom 1 {
                displayName = "Passenger intercom";
                shortName = "Pax";
                allowedPositions[] = {"crew", {"cargo", "all"}};
                disabledPositions[] = {"commander", {"Cargo", 1}, {"ffv", "all"}, {"turnedout", 2, "driver", "gunner", [2]}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };

        // Infantry Phone
        acre_hasInfantryPhone = 1;
        acre_infantryPhoneIntercom[] = {"all"};
        acre_infantryPhoneControlActions[] = {"intercom_1"};
        acre_infantryPhonePosition[] = {-1.1, -4.86, -0.82};
        acre_infantryPhoneDisableRinging = 0; // If set to 1, the ringing funtionality will not be available
        acre_infantryPhoneCustomRinging[] = {"A3\Sounds_F\sfx\alarm_independent.wss", 5.0, 1.0, 1.0, 50}; // The alarm sound will be played every 5 seconds and will be audible until 50m. Volume and sound pitch are both set to 1
    };
};
```
{% endraw %}
