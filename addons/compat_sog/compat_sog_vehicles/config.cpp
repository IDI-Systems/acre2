#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "loadorder_f_vietnam"};
        skipWhenMissingDependencies = 1;
        author = ECSTRING(main,Author);
        authors[] = {"Savage Game Design", "veteran29"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

// TODO move to sys_attenuate
class CfgSoundEffects {
    class AttenuationsEffects {
        class vn_tank_attenuation {
            acreAttenuation = 0.7;
            acreAttenuationTurnedOut = 0.25;
        };
        class vn_car_attenuation {
            acreAttenuation = 0.5;
            acreAttenuationTurnedOut = 0.25;
        };
    };
};

class CfgVehicles {
    class vn_armor_tank_base;
    class vn_armor_m48_base: vn_armor_tank_base {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 0;
                    Compartment2 = 0.8;
                };
                class Compartment2  {
                    Compartment1 = 0.8;
                    Compartment2 = 0;
                };
            };
            class attenuationTurnedOut {
                class Compartment1  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                };
                class Compartment2  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                };
            };
        };
    };

    class vn_wheeled_truck_base;
    class vn_wheeled_m54_base: vn_wheeled_truck_base {
        class AcreRacks {
            class Rack_1 {
                allowedPositions[] = {"driver", {"ffv", {0}}};
            };
        };
    };

    class vn_wheeled_car_base;
    class vn_wheeled_m151_base: vn_wheeled_car_base {
        class AcreRacks {
            class Rack_1 {
                allowedPositions[] = {"driver", {"ffv", {0}}, "external"};
            };
        };
    };
    // Armored M151
    class vn_wheeled_m151_mg_04_base: vn_wheeled_m151_base {
        class AcreRacks: AcreRacks {
            class Rack_1: Rack_1 {
                allowedPositions[] = {"driver", {"cargo", 0}};
            };
        };
    };
};
