#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = { "acre_main" };
        version = VERSION;
    };
};

#include "CfgEventhandlers.hpp"
//#include "CfgPerFrame.hpp"

PRELOAD_ADDONS;
