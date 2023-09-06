#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "gm_core"};
        skipWhenMissingDependencies = 1;
        author = ECSTRING(main,Author);
        authors[] = {"Vertexmacht"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

class CfgAcreWorlds {
    class gm_weferlingen_summer {
        wrp = QPATHTOF(gm_weferlingen.fakewrp);
    };

    class gm_weferlingen_winter: gm_weferlingen_summer {};
};
