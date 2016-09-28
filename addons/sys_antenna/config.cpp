#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = { "acre_main", "acre_sys_components" };
        version = VERSION;
        AUTHOR;
    };
};

#include "CfgAcreComponents.hpp"
#include "CfgEventhandlers.hpp"
