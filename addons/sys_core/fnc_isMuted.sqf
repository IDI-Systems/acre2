#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if the unit should be muted (not heard at all).
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * should the unit be muted <BOOL>
 *
 * Example:
 * [acre_player] call acre_sys_core_fnc_isMuted
 *
 * Public: No
 */

params ["_player"];

// if (_player in GVAR(muting)) exitWith {
    // true
// };

private _ret = false;

if (!isNull _player) then {
    private _alive = [_player] call FUNC(getAlive);
    if (_alive != 1) then {
        _ret = true;
    };
};

_ret
