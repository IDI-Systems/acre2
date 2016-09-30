#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_sys_rpc", "acre_sys_data", "acre_sys_core"};
        version = VERSION;
        AUTHOR;
    };
};

#include "cfgEventhandlers.hpp"
