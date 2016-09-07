#include "script_component.hpp"

class CfgPatches
{
    class ADDON
    {
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_sys_core", "acre_api"};
        units[] = {};
        weapons[] = {};
        version = VERSION;
        AUTHOR;
        authors[] = {"Snippers"};
        authorUrl = URL;
    };
};

#include "CfgVehicles.hpp"
#include "CfgEventHandlers.hpp"
