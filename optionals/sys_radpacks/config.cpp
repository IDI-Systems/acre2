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
    };
};

class CfgVehicles {
    class Bag_Base;
    class B_RadioBag_01_base_F: Bag_Base {
        maximumLoad = 150;
    };
};
