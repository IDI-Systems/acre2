#include "script_component.hpp"

class CfgPatches
{
    class ADDON
    {
        units[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = { "acre_main", "acre_sys_rpc", "acre_sys_core", "acre_sys_io" };
        version = VERSION;
        AUTHOR;
        authors[] = {"Jaynus", "Nou"};
        authorUrl = URL;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgAcreSounds.hpp"
