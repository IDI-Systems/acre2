#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_api", "loadorder_f_vietnam"};
        skipWhenMissingDependencies = 1;
        author = ECSTRING(main,Author);
        authors[] = {"Savage Game Design", "veteran29"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"

class CfgAcreWorlds {
    class cam_lao_nam {
        wrp = QPATHTOF(cam_lao_nam.fakewrp);
    };
    class vn_khe_sanh {
        wrp = QPATHTOF(vn_khe_sanh.fakewrp);
    };
    class vn_the_bra {
        wrp = QPATHTOF(vn_the_bra.fakewrp);
    };
};
