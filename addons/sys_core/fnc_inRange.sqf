#include "script_component.hpp"
/*
 * Author: SynixeBrett
 * Checks if unit is within range of the player's ears.
 *
 * Arguments:
 * 0: Unit <VECTOR>
 *
 * Return Value:
 * In range <BOOL>
 *
 * Example:
 * _unit call acre_sys_core_fnc_inRange
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]]];

private _position = getPosASL _unit;

private _check = {
    if (call FUNC(inZeus)) exitWith {
        _this distance (getPosASL curatorCamera) < MAX_DIRECT_RANGE
    };
    _this distance ACRE_LISTENER_POS < MAX_DIRECT_RANGE
};

if (_unit getVariable [QEGVAR(sys_zeus,inZeus), false]) exitWith {
    ((_unit getVariable [QEGVAR(sys_zeus,zeusPosition), [0,0,0]]) select 0) call _check
};
_position call _check
