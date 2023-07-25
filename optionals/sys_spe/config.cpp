#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main","WW2_SPE_Assets_c_Misc_ZZZ_LastLoaded_c"};
        author = ECSTRING(main,Author);
        authors[] = {"Heavy Ordnance Works"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

class CfgAcreWorlds {
    class SPE_normandy {
        wrp = "\idi\acre\addons\sys_spe\SPE_normandy.fakewrp";
    };
};

#include "CfgVehicles.hpp"
