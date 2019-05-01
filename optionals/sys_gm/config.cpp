#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_sys_core"};
        author = ECSTRING(main,Author);
        authors[] = {"GlobalMobilization"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

class CfgAcreWorlds {
    class gm_weferlingen_summer {
        wrp = "\idi\acre\addons\sys_gm\gm_weferlingen.fakewrp";
    };

    class gm_weferlingen_winter : gm_weferlingen_summer {};
};
