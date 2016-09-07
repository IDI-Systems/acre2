#include "script_component.hpp"
class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        #ifdef PLATFORM_A2
        requiredAddons[] = { "acre_main", "acre_sys_core" };
        #endif
        #ifdef PLATFORM_A3
        requiredAddons[] = { "A3_UI_F", "acre_main", "acre_sys_core" };
        AUTHOR;
        #endif
        version = VERSION;
    };
};
#include "cfgEventhandlers.hpp"

#include "CfgVehicles.hpp"
// #include "CfgAcreAttenuation.hpp"

#include "CfgSoundEffects.hpp"
