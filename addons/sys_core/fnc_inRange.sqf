#include "script_component.hpp"
/*
 * Author: Brett Mayson, ACRE2 Team
 * Checks if a unit is within range of the player's ears.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * In range <BOOL>
 *
 * Example:
 * [_unit] call acre_sys_core_fnc_inRange
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]]];

private _position = getPosASL _unit;

// Check if the position is in range of the unit or the camera
private _check = {
    if (call FUNC(inZeus) && {_this distance (getPosASL curatorCamera) < MAX_DIRECT_RANGE}) exitWith { true };
    _this distance ACRE_LISTENER_POS < MAX_DIRECT_RANGE
};

// Check the position of the remote zeus camera and remote unit
if (_unit getVariable [QEGVAR(sys_zeus,inZeus), false] && {((_unit getVariable [QEGVAR(sys_zeus,zeusPosition), [[0, 0, 0], [0, 0, 0]]]) select 0) call _check}) exitWith { true };

_position call _check
