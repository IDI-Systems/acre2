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

params["_unit"];

private _languageId = _unit getVariable [QUOTE(GVAR(languageId)), 0];
private _ret = false;
if(_languageId in ACRE_SPOKEN_LANGUAGES || count GVAR(languages) == 0) then {
    _ret = true;
};
_ret;
