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
