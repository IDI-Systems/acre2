#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_api", "data_f_vietnam"};
        author = ECSTRING(main,Author);
        authors[] = {"Savage Game Design", "veteran29"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

class CfgAcreWorlds {
    class cam_lao_nam {
        wrp = "\idi\acre\addons\sys_sog\cam_lao_nam.fakewrp";
    };
};
