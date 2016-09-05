#include "script_component.hpp"
class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = { "acre_main", "acre_sys_core" };
        version = VERSION;
        AUTHOR;
    };
};
#include "cfgEventhandlers.hpp"

class JNET_Events {
    class RscDisplayRemoteMissions {
        acre = QUOTE([] call (compile preprocessFileLineNumbers 'idi\clients\acre\addons\sys_jvon\JNET_load.sqf'););
    };
    
    class RscDisplayMultiplayerSetup {
        acre = QUOTE([] call (compile preprocessFileLineNumbers 'idi\clients\acre\addons\sys_jvon\JNET_load.sqf'););
    };
};