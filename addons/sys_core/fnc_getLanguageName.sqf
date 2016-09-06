/*
 * Author: ACRE2Team
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

params["_languageKey"];

private _ret = "";
if(IS_NUMBER(_languageKey)) then {
    _ret = (GVAR(languages) select _languageKey) select 1;
} else {
    {
        if((_x select 0) == _languageKey) exitWith {
            _ret = _x select 1;
        };
    } forEach GVAR(languages);
};
_ret
