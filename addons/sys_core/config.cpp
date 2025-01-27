#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_sys_rpc", "acre_sys_data"};
        author = ECSTRING(main,Author);
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};
#include "CfgEden.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgSounds.hpp"
#include "CfgVehicles.hpp"

class CfgAcreWorlds {

};


// THIS IS A MASSIVE ANNOYING HACK BUT ITS THE ONLY RELIABLE WAY TO DO THIS
// AND NOT GET GRAPHICAL GLITCHES WITH FULLSCREEN IF THERE IS AN ERROR!
tooltipDelay = "call compile preprocessFileLineNumbers  ""idi\acre\addons\sys_core\steam_boot.sqf""; 0;";
