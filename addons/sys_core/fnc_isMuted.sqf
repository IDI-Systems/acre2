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

params["_player"];

// if(_player in GVAR(muting)) exitWith {
    // true
// };

private _ret = false;

if(!isNull _player) then {
    private _alive = [_player] call FUNC(getAlive);
    if(_alive != 1) then {
        _ret = true;
    };
};

_ret
