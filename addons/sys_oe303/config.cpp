#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_sys_radio"};
        version = VERSION;
        AUTHOR;
    };
};

#include "CfgVehicles.hpp"
