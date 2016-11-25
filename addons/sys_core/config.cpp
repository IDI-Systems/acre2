#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {"ACRE_TestLoader"};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_sys_rpc", "acre_sys_data"};
        author = ECSTRING(main,Author);
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};
#include "CfgEventHandlers.hpp"
#include "CfgSounds.hpp"
#include "CfgVehicles.hpp"
#include "dialogs.hpp"

class CfgAcreWorlds {

};


// class CfgFunctions
// {
    // class ACRE
    // {
        // class steam
        // {
            // class boot_copy
            // {
                // preStart = 1;//"call compile preprocessFileLineNumbers  ""idi\acre\addons\sys_core\steam_boot.sqf""; 1"; // 1 to call the function upon game start, before title screen, but after all addons are loaded.
                // file = "idi\acre\addons\sys_core\steam_ghost.sqf";
                // headerType = "call compile preprocessFileLineNumbers  ""idi\acre\addons\sys_core\steam_boot.sqf""; -1"
            // };
        // };
    // };
// };


// THIS IS A MASSIVE ANNOYING HACK BUT ITS THE ONLY RELIABLE WAY TO DO THIS
// AND NOT GET GRAPHICAL GLITCHES WITH FULLSCREEN IF THERE IS AN ERROR!
tooltipDelay = "call compile preprocessFileLineNumbers  ""idi\acre\addons\sys_core\steam_boot.sqf""; 0;";
