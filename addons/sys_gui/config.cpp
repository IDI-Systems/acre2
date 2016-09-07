#include "script_component.hpp"

class CfgPatches
{
    class ADDON
    {
        units[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = { "acre_main", "acre_sys_core" };
        version = VERSION;
        AUTHOR;
        authors[] = {"Jaynus", "Nou"};
        authorUrl = URL;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVolumeControl.hpp"
