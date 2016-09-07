#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = { "acre_main", "acre_sys_core" };
        version = VERSION;
        AUTHOR;
    };
};

#include "CfgFontFamilies.hpp"
