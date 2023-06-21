#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        addonRootClass = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "loadorder_f_vietnam"};
        skipWhenMissingDependencies = 1;
        VERSION_CONFIG;
    };
};
