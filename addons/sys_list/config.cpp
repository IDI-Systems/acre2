#include "script_component.hpp"
class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = { "acre_main", "acre_sys_core", "acre_sys_fonts" };
        version = VERSION;
        AUTHOR;
    };
};
#include "list_dialog.hpp"
#include "CfgEventhandlers.hpp"
