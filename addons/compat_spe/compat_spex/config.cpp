#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"compat_spe","SPEX_TEM_carentan_c","SPEX_TEM_Utah_Beach_c"};
        skipWhenMissingDependencies = 1;
        author = ECSTRING(common,ACETeam);
        authors[] = {"Heavy Ordnance Works", "drofseh"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

class CfgAcreWorlds {
    class SPEX_Carentan {
        wrp = QPATHTOF(SPEX_Carentan.fakewrp);
    };
    class SPEX_Utah_Beach {
        wrp = QPATHTOF(SPEX_Utah_Beach.fakewrp);
    };
};
