#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {
            "SPE_M4A1_75_Command",
            "SPE_M4A1_75_Command_DVL",
            "SPE_FR_M4A1_75_Command",
            "SPE_FR_M4A1_75_Command_DVL",
            "SPE_M4A1_76_Command",
            "SPE_M4A1_76_Command_DVL",
            "SPE_FR_M4A1_76_Command",
            "SPE_FR_M4A1_76_Command_DVL",
            "SPE_M4A0_75_Early_Command",
            "SPE_M4A0_75_Early_Command_DVL",
            "SPE_M4A0_75_Command",
            "SPE_M4A0_75_Command_DVL",
            "SPE_FR_M4A0_75_Early_Command",
            "SPE_FR_M4A0_75_Early_Command_DVL",
            "SPE_FR_M4A0_75_mid_Command",
            "SPE_FR_M4A0_75_mid_Command_DVL",
            "SPE_PzBefWgIII_K",
            "SPE_PzBefWgIII_K_DLV",
            "SPE_ST_PzBefWgIII_K",
            "SPE_ST_PzBefWgIII_K_DLV",
            "SPE_PzBefWgIV",
            "SPE_PzBefWgIV_DLV",
            "SPE_ST_PzBefWgIV",
            "SPE_ST_PzBefWgIV_DLV",
            "SPE_PzBefWgVI",
            "SPE_PzBefWgVI_DLV",
            "SPE_ST_PzBefWgVI",
            "SPE_ST_PzBefWgVI_DLV"
        };
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_api", "WW2_SPE_Assets_c_Vehicles_ZZZ_LastLoaded_c"};
        skipWhenMissingDependencies = 1;
        author = ECSTRING(main,Author);
        authors[] = {"Heavy Ordnance Works", "drofseh"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

class CfgAcreWorlds {
    class SPE_normandy {
        wrp = QPATHTOF(SPE_normandy.fakewrp);
    };
};

#include "CfgVehicles.hpp"
