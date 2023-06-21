#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        addonRootClass = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "loadorder_f_vietnam"};
        skipWhenMissingDependencies = 1;
        VERSION_CONFIG;
    };
};

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
};
