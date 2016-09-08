#include "script_component.hpp"
class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_game"};
        AUTHOR;
        VERSION_CONFIG;
    };
};

class CfgMods {
    class ACRE2
    {
        dir = "@ACRE2";
        picture = "idi\acre\addons\main\acre2_large-logo.paa";
        action = "https://github.com/IDI-Systems/acre2";
        hideName = 0;
        hidePicture = 0;
        name = "ACRE 2!";
    };
};

#include "CfgRscStd.hpp"
#include "Dialog.hpp"

//#include "CfgEventHandlers.hpp"
