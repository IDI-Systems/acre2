#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {"ACRE_DeployedRadioBase"};
        weapons[] = {"ACRE_BaseRadio"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_sys_core", "acre_sys_antenna", "acre_sys_components", "acre_sys_data", "acre_sys_sounds"};
        author = ECSTRING(main,Author);
        authors[] = {"Jaynus", "Nou"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

PRELOAD_ADDONS;

#include "CfgVehicles.hpp"
#include "CfgEventHandlers.hpp"
