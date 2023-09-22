---
title: Vehicle Racks
---

Both features are currently supported only for vanilla classes and their children to maximize performance. Support for other classes can be added per request on the [issue tracker](https://github.com/IDI-Systems/acre2/issues).

{% include important.html content="Requires ACE3 Interaction Menu!" %}

## Vehicle Racks and Intercom

Vehicle racks is the system where units inside a vehicle can use mounted radios or mount personal radios in order to increase the transmission power.

By default, vehicle racks are enabled for the following classes and their children:

- `MRAP_01_base_F`
- `Helicopter_Base_F`
- `Plane_Base_F`
- `Tank_F`
- `Wheeled_APC_F`

If you are inheriting from one of those classes, no extra configuration is required for vehicle racks functionality. The default positions where the racks can be configured and can be used for transmitting and receiving incoming transmissions include `"commander"`, `"driver"`, `"gunner"` and those positions labelled as `"turret"` excluding firing from vehicle (FFV) turrets. Other seats in the intercom network will not be able to configure it. By default, turned out positions have the open radio GUI functionality disabled. For those racks without access to intercom, one can use the keyword `"none"` in the `intercom[]` configuration entry.

The system can be further modified in order to customise the type of racks, the amount of them, which positions can open and configure the radio and to what intercoms the rack is connected to. The following configuration entries illustrate some of the possibilities. The first example configures two racks on an MRAP, a *VRC110* which allows mounting a *PRC152* for the `"driver"` and front seat passenger (`"cargo"` 0) and, a *VRC103* with a *PRC117F* mounted by default that cannot be removed accessible from `"driver"`, `"commander"` and `"gunner"` positions.

{% raw %}
```cpp
class CfgVehicles {
    class Car_F;
    class MRAP_01_base_F : Car_F {
        class AcreRacks {
            class Rack_1 {
                displayName = "Dashboard Upper";      // Name displayed in the interaction menu
                shortName = "D.Up";                   // Short name displayed on the HUD. Maximum of 5 characters
                componentName = "ACRE_VRC110";        // Able to mount a PRC152
                allowedPositions[] = {"driver", {"cargo", 1}}; // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows transmitting/receiving
                disabledPositions[] = {};             // Who cannot access the radio (default: {})
                defaultComponents[] = {};             // Use this to attach simple components like Antennas, they will first attempt to fill empty connectors but will overide existing connectors. Not yet fully implemented. (default: {})
                mountedRadio = "";                    // Predefined mounted radio (default: "", meaning none)
                isRadioRemovable = 1;                 // Radio can be removed (default: 0)
                intercom[] = {};                      // Radio not wired to any intercom. All units in intercom can receive/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface) (default: {})
            };
            class Rack_2 {
                displayName = "Dashboard Lower";      // Name displayed in the interaction menu
                shortName = "D.Low";                  // Short name displayed on the HUD. Maximum of 5 characters
                componentName = "ACRE_VRC103";        // Rack type (able to mount a PRC117F)
                allowedPositions[] = {"driver", "commander", "gunner"}; // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows transmitting/receiving
                disabledPositions[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";        // Predefined mounted radio
                isRadioRemovable = 0;                 // Radio cannot be removed
                intercom[] = {};                      // Radio not wired to any intercom. All units in intercom can receive/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
            };
        };
    };
};
```
{% endraw %}

The next example configures a rack with a *PRC117F* already mounted and with full access (open GUI and transmitting/receiving functionality) to the `"driver"`, `"commander"` and `"gunner"`, while other members in `"intercom_1"` mesh can only receive incoming transmissions.

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        class AcreRacks {
           class Rack_1 {
               displayName = "Dash"; // Name is displayed in the interaction menu.
               shortName = "Dash";
               componentName = "ACRE_VRC103";
               allowedPositions[] = {"driver", "commander", "gunner"}; // Who has access. "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
               disabledPositions[] = {};
               defaultComponents[] = {};
               mountedRadio = "ACRE_PRC117F";                 // Predefined mounted radio
               isRadioRemovable = 0;
               intercom[] = {"intercom_1"};                   // All units in intercom can receive/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface).
           };
       }
    };
};
```
{% endraw %}

This last example configures a single *VRC103* rack with a mounted *PRC117F* for the pilot and copilot and with access to the intercom network `"intercom_1"` intercom.

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        class AcreRacks {
           class Rack_1 {
               displayName = "Dash"; // Name is displayed in the interaction menu.
               shortName = "Dash";
               componentName = "ACRE_VRC103";
               allowedPositions[] = {"driver", "copilot"}; // Who has access. "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
               disabledPositions[] = {};
               defaultComponents[] = {};
               mountedRadio = "ACRE_PRC117F";                 // Predefined mounted radio
               isRadioRemovable = 0;
               intercom[] = {"intercom_1"};                   // All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
           };
       }
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
- **Racks**:
  - `"ACRE_VRC64"`: Can mount a `"ACRE_PRC77"`.
  - `"ACRE_VRC103"`: Can mount a `"ACRE_PRC117F"`.
  - `"ACRE_VRC110"`: Can mount a `"ACRE_PRC152"`.
  - `"ACRE_VRC111"`: Can mount a `"ACRE_PRC148"` (20W version).
  - `"ACRE_SEM90"`: Can mount a `"ACRE_SEM70"` (4W on low power and 40W on high).
{% endraw %}

## Configuration examples

The following vehicle has crew and passenger intercom as well as infantry telephone and Three radio racks are mounted: two *VRC110* (one for the `"driver"` and `"commander"` and the other for `"cargo"` positions) and a *VRC103* with a mounted *PRC117F* with full access to `"commander"` and `"driver"` and receive functionality for those in other crew positions or units connected to the passenger intercom, except those in `"ffv" positions`.

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
                masterPositions[] = {"commander"};
                limitedPositions[] = {{"cargo", "all"}};
                numLimitedPositions = 2;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
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

        class AcreRacks {
            class Rack_1 {
                displayName = "Dashboard Upper";             // Name displayed in the interaction menu
                shortName = "D.Up";
                componentName = "ACRE_VRC110";        // Able to mount a PRC152
                allowedPositions[] = {"driver", "commander", "gunner"}; // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows transmitting/receiving
                disabledPositions[] = {};
                defaultComponents[] = {};             // Use this to attach simple components like Antennas. Not yet fully implemented
                mountedRadio = "";                    // Predefined mounted radio
                isRadioRemovable = 1;                 // Radio can be removed
                intercom[] = {};                      // No access to intercoms. All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
            };
            class Rack_2 {
                displayName = "Dashboard Upper";             // Name displayed in the interaction menu
                shortName = "D.Up";
                componentName = "ACRE_VRC110";        // Able to mount a PRC152
                allowedPositions[] = {{"cargo", "all"}};       // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows transmitting/receiving
                disabledPositions[] = {{"ffv", "all"}};
                defaultComponents[] = {};             // Use this to attach simple components like Antennas. Not yet fully implemented
                mountedRadio = "";                    // Predefined mounted radio
                isRadioRemovable = 1;                 // Radio can be removed
                intercom[] = {};                      // No access to intercoms. All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
            };
            class Rack_3 {
                displayName = "Dashboard Lower";             // Name displayed in the interaction menu
                shortName = "D.Low";
                componentName = "ACRE_VRC103";        // Rack type (able to mount a PRC117F)
                allowedPositions[] = {"driver", "commander", "gunner"}; // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows transmitting/receiving
                disabledPositions[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";        // Predefined mounted radio
                isRadioRemovable = 0;                 // Radio cannot be removed
                intercom[] = {"intercom_1", "intercom_2"}; // All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
            };
        };
    };
};
```
{% endraw %}

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
