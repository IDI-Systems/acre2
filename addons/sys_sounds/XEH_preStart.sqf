#include "script_component.hpp"

#include "XEH_PREP.hpp"

if (!hasInterface) exitWith {};

INFO("Loading CfgAcreSounds");
{
    private _classname = configName _x;
    private _file = getText (_x >> "file");
    if (_file != "") then {
        private _ret = ["copy_to_temp",[_file,_classname]] call EFUNC(sys_core,callExt);
        if (_ret != "") then { ERROR_2("Error loading sound [%1: %2]",_classname,_ret); };
    } else {
        ERROR_1("No sound file in config [%1]",_classname);
    }
} forEach ("true" configClasses (configFile >> "CfgAcreSounds"));
