#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main"};
        author = ECSTRING(main,Author);
        authors[] = {"Rotators Collective"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
        skipWhenMissingDependencies = 1;
    };
};

class CfgAcreWorlds {
    class SefrouRamal {
        wrp = QPATHTOF(SefrouRamal.fakewrp);
    };
};
