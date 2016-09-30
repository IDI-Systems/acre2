#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_sys_radio", "acre_sys_data"};
        version = VERSION;
        AUTHOR;
    };
};

#include "CfgEventhandlers.hpp"

class CfgWeapons {
    class FirstAidKit;
    class ACRE_TestGearDesyncItem: FirstAidKit {
        scopeCurator = 1;
        scope = 1;
        model = "";
    };
};
