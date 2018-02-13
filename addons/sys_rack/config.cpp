#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_sys_core", "acre_sys_antenna", "acre_sys_components", "acre_sys_data", "acre_sys_intercom", "acre_sys_sounds"}; // TODO: setup
        author = ECSTRING(main,Author);
        authors[] = {"Snippers", "TheMagnetar"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

PRELOAD_ADDONS;

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "CfgAcreRacks.hpp"
