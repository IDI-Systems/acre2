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

params["_file", "_namespace"];

private _data = [_file] call FUNC(parseIni);
// diag_log text format["Loaded config: %1", _data];
private _section = "";

{
    if(IS_STRING(_x)) then {
        _section = _x;
    } else {
        _x params ["_key","_val"];

        missionNamespace setVariable ["ACRE" + _namespace + _section + _key, _val];
    };
} forEach _data;
true
