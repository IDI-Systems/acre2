#include "script_component.hpp"

if (!hasInterface) exitWith {};

private _components = configProperties [configFile >> "CfgAcreComponents", "isClass _x", true];

{
    private _type = getNumber (_x >> "type");
    if (_type == ACRE_COMPONENT_ANTENNA) then {
        private _binaryGainFile = getText (_x >> "binaryGainFile");
        if (_binaryGainFile != "") then {
            private _configName = configName _x;
            private _res = ["load_antenna", [_configName, _binaryGainFile]] call EFUNC(sys_core,callExt);
            INFO_3("Loaded Binary Antenna Data for %1 [%2]: %3",_configName,_binaryGainFile,_res);
        };
    };
} forEach _components;
