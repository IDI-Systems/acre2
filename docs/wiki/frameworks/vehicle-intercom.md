---
title: Vehicle Intercom
---

Both features are currently supported only for `Car_F` and `Tank` classes and their children to maximize performance. Support for other classes can be added per request on the [issue tracker](https://github.com/IDI-Systems/acre2/issues).

## Vehicle intercom

Vehicle intercom is the system where crew inside vehicle can easily communicate among each other without noise disturbances.

By default, intercom is enabled for the following classes and their children:

- `Wheeled_APC_F`
- `MRAP_02_base_F`
- `Tank`
- `Helicopter`
- `Plane`
- `SDV_01_base_F`

If you are inheriting from one of those classes, no extra configuration is required for vehicle intercom functionality.

Otherwise, you can enable the intercom system for a class using the following config entry:

```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        acre_hasIntercom = 1; // 1 - enabled, 0 - disabled
    };
};
```

## Infantry telephone

Infantry telephone is the system where infantry can communicate with the crew inside tanks and IFVs using a telephone mounted on the outside of the vehicle.

{% include important.html content="Requires ACE3 Interaction Menu!" %}

By default, infantry telephone is enabled only for `Tank` class and its children.

To add infantry telephone to a vehicle class, use the following config entry:

```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        acre_hasInfantryPhone = 1; // 1 - enabled, 0 - disabled
    };
};
```

### Position

Additionally, infantry telephone interaction is put on the main interaction node (center of vehicle) if no custom position is defined in config. Custom position can be set using a config entry to put the interaction node anywhere on the hull of the vehicle. This position will also be used as a sound source for the ringing functionality.

```cpp
class CfgVehicles {
    class ParentVehicle;
    class MyVehicle: ParentVehicle {
        acre_infantryPhonePosition[] = {-1.1, -4.86, -0.82}; // Coordinates in model space
    };
};
```

ACRE2 provides helper functions for retrieving the position and quickly making sure they are correct. If you build ACRE2 locally, you can uncomment defines in `sys_intercom/script_component.hpp`:

- `DRAW_INFANTRYPHONE_INFO` draws text with class name of the vehicle and current position at the current position on the model (when pointing at the vehicle).
- `DRAW_CURSORPOS_INFO` draws an arrow where your cursor is pointing to. Current position is saved in `xPosModel` variable which can easily be watched in the debug console to retrieve precise coordinates in model space for direct use in config.
