#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "CSLA"};
        skipWhenMissingDependencies = 1;
        author = ECSTRING(main,Author);
        authors[] = {"CSLA Studio"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

class CfgAcreWorlds {
    class stozec {
        wrp = QPATHTOF(stozec.fakewrp);
    };
};
