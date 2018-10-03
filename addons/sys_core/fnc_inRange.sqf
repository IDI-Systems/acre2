/*
 * Author: SynixeBrett
 * Returns true if a unit is within range of the player's ears
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
#include "script_component.hpp"

params [
    ["_unit", objNull, [objNull]]
];

private _position = getPosASL _unit;

private _check = {
    if (call FUNC(inZeus)) exitWith {
        (_this distance (getPosASL curatorCamera) < 300)
    };
    (_this distance ACRE_LISTENER_POS < 300)
};

if (_unit getVariable [QEGVAR(zeus,inZeus), false]) exitWith {
    ((_unit getVariable [QEGVAR(zeus,zeusPosition), [0,0,0]]) call _check)
};
(_position call _check)
