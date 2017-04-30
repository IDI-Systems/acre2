---
title: Vehicle Racks
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

If you are inheriting from one of those classes, no extra configuration is required for vehicle racks functionality. The default positions where the racks can be configured and can be used for transmitting and receiving incoming transmissions include `"commander"`, `"driver"`, `"gunner"` and those positions labelled as `"turret"` excluding firing from vehicle (FFV) turrets. Other seats in *crew intercom* will not be able to configure it and, for the time being will only be able to receive but not transmit. By default, turned out positions have the open radio GUI functionality disabled.

The system can be further modified in order to customise the type of racks, the amount of them, which positions can open and configure the radio and to what intercoms the rack is connected to. The following configuration entries illustrate some of the possibilities. The first example configures two racks on an MRAP, a *VRC110* which allows mounting a *PRC152* for the `"driver"` and front seat passenger (`"cargo"` 0) and, a *VRC103* with a *PRC117F* mounted by default that cannot be removed accessible from `"driver"`, `"commander"` and `"gunner"` positions.

{% raw %}
```cpp
class CfgVehicles {
    class Car_F;
    class MRAP_01_base_F : Car_F {
        class AcreRacks {
            class Rack_1 {
                name = "Dashboard Upper";             // Name displayed in the interaction menu.
                componentname = "ACRE_VRC110";        // Able to mount a PRC152.
                allowed[] = {"driver", {"cargo", 1}}; // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows Transmitting/receiving.
                disabled[] = {};
                defaultComponents[] = {};             // Use this to attach simple components like Antennas. Not yet fully implemented.
                mountedRadio = "";                    // Predefined mounted radio.
                isRadioRemovable = 1;                 // Radio can be removed.
                intercom[] = {};                      // Radio wired to intercoms. Intercom access only grants Receive capabilities at the moment. Later units in intercom will be able to select if they want to transmit, receive or both on a particular rack.
            };
            class Rack_2 {
                name = "Dashboard Lower";             // Name displayed in the interaction menu
                componentname = "ACRE_VRC103";        // Rack type (able to mount a PRC117F)
                allowed[] = {"driver", "commander", "gunner"}; // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows Transmitting/receiving.
                disabled[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";        // Predefined mounted radio.
                isRadioRemovable = 0;                 // Radio cannot be removed.
                intercom[] = {};                      // Radio wired to intercoms. Intercom access only grants Receive capabilities at the moment. Later units in intercom will be able to select if they want to transmit, receive or both on a particular rack.
            };
        };
    };
};
```
{% endraw %}

The next example configures a rack with a *PRC117F* already mounted and with full access (open GUI and transmitting/receiving functionality) to the `"driver"`, `"commander"` and `"gunner"`, while other members in `"crew"` intercom can only receive incoming transmissions.

{% raw %}
```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        class AcreRacks {
           class Rack_1 {
               name = "Dash"; // Name is displayed in the interaction menu.
               componentname = "ACRE_VRC103";
               allowed[] = {"driver", "commander", "gunner"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
               disabled[] = {};
               defaultComponents[] = {};
               mountedRadio = "ACRE_PRC117F";                 // Predefined mounted radio
               isRadioRemovable = 0;
               intercom[] = {"crew"};                         // All units in intercom will be able to hear transmittions (ACE interaction menu). Later units in intercom will be able to select if they want to transmit, receive or both on a particular rack.
           };
       }
    };
};
```
{% endraw %}

This last example configures a single *VRC103* rack with a mounted *PRC117F* for the pilot and copilot and with access to `crew` intercom.

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
- **Racks**:
  - `"ACRE_VRC103"`: Can mount a `"ACRE_PRC117F"`.
  - `"ACRE_VRC110"`: Can mount a `"ACRE_PRC152"`.
  - `"ACRE_VRC111"`: Can mount a `"ACRE_PRC148"` (20W version).
  - `"ACRE_SEM90"`: Can mount a `"ACRE_SEM70"` (4W on low power and 40W on high).
{% endraw %}

## Configuration examples

The following vehicle has crew and passenger intercom as well as infantry telephone and Three radio racks are mounted: two *VRC110* (one for the `"driver"` and `"commander"` and the other for `"cargo"` positions) and a *VRC103* with a mounted *PRC117F* with full access to `"commander"` and `"driver"` and receive functionality for those in other crew positions or units connected to the passenger intercom, except those in `"ffv" positions`.

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
        acre_crewIntercomExceptions[] = {{"turnedout", "all"}};

        // Passenger intercom
        acre_hasPassengerIntercom = 1;
        acre_passengerIntercomPositions[] = {{"cargo", "all"}, "driver"};
        acre_passengerIntercomExceptions[] = {"commander", {"Cargo", 1}, {"ffv", "all"}, {"turnedout", 2, "driver", "gunner", [2]}};
        acre_passengerIntercomConnections = 2;

        // Infantry Phone
        acre_hasInfantryPhone = 1;
        acre_infantryPhoneIntercom[] = {"crew", "passenger"};
        acre_infantryPhonePosition[] = {-1.1, -4.86, -0.82};
        class AcreRacks {
            class Rack_1 {
                name = "Dashboard Upper";             // Name displayed in the interaction menu.
                componentname = "ACRE_VRC110";        // Able to mount a PRC152.
                allowed[] = {"driver", "commander", "gunner"}; // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows Transmitting/receiving.
                disabled[] = {};
                defaultComponents[] = {};             // Use this to attach simple components like Antennas. Not yet fully implemented.
                mountedRadio = "";                    // Predefined mounted radio.
                isRadioRemovable = 1;                 // Radio can be removed.
                intercom[] = {};                      // No access to intercoms.
            };
            class Rack_2 {
                name = "Dashboard Upper";             // Name displayed in the interaction menu.
                componentname = "ACRE_VRC110";        // Able to mount a PRC152.
                allowed[] = {{"cargo", "all"}};       // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows Transmitting/receiving.
                disabled[] = {{"ffv", "all"}};
                defaultComponents[] = {};             // Use this to attach simple components like Antennas. Not yet fully implemented.
                mountedRadio = "";                    // Predefined mounted radio.
                isRadioRemovable = 1;                 // Radio can be removed.
                intercom[] = {};                      // No access to intercoms.
            };
            class Rack_3 {
                name = "Dashboard Lower";             // Name displayed in the interaction menu
                componentname = "ACRE_VRC103";        // Rack type (able to mount a PRC117F)
                allowed[] = {"driver", "commander", "gunner"}; // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows Transmitting/receiving.
                disabled[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";        // Predefined mounted radio.
                isRadioRemovable = 0;                 // Radio cannot be removed.
                intercom[] = {"crew", "passenger"};   // Radio wired to intercoms. Intercom access only grants Receive capabilities at the moment. Later units in intercom will be able to select if they want to transmit, receive or both on a particular rack.
            };
        };
    };
};
```
{% endraw %}
