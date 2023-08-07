#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "CSLA"};
        author = ECSTRING(main,Author);
        authors[] = {"CSLA Studio"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
        skipWhenMissingDependencies = 1;
    };
};

class CfgAcreWorlds {
    class stozec {
        wrp = QPATHTOF(stozec.fakewrp);
    };
};
