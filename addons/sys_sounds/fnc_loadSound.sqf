/*
 * Author: AUTHOR
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params["_className",["_returnFunction",nil],["_force",false]];

if(!(_className in GVAR(loadedSounds)) && {!_force}) then {
    private _fileName = getText(configFile >> "CfgAcreSounds" >> _className >> "sound");
    if(_fileName != "") then {
        [] call (compile loadFile _fileName);
        if(!isNil "ACRE_B64_FILE") then {
            TRACE_2("Lounding Sound File", _className, _fileName);
            if(!isNil "_returnFunction") then {
                HASH_SET(GVAR(callBacks),_className,_returnFunction);
            };
            {
                ["loadSound", [_className, _forEachIndex+1, count(ACRE_B64_FILE), _x]] call EFUNC(sys_rpc,callRemoteProcedure);
            } forEach ACRE_B64_FILE;
            ACRE_B64_FILE = nil;
            TRACE_2("Sound File Sent", _className, _fileName);
        };
    };
};
