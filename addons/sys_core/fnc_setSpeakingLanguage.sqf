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

params["_languageKey"];

private _ret = false;
{
    if((_x select 0) == _languageKey) exitWith {
        ACRE_CURRENT_LANGUAGE_ID = _forEachIndex;
        _ret = true;
    };
} forEach GVAR(languages);

_ret;
