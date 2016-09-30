#include "script_component.hpp"
class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = { "A3_UI_F", "acre_main", "acre_sys_core" };
        AUTHOR;
        version = VERSION;
    };
};

#include "cfgEventhandlers.hpp"
#include "CfgVehicles.hpp"
#include "CfgSoundEffects.hpp"
