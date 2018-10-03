/*
 * Author: SynixeBrett
 * Returns true if a position is within range of the player's ears
 * returns true for both player's unit and zeus camera
 *
 * Arguments:
 * 0: Position ASL <VECTOR>
 * 1: Range <NUMBER> (default: 300)
 * 2: Check Zeus <BOOLEAN> (default: true)
 *
 * Return Value:
 * In range <BOOL>
 *
 * Example:
 * [getPosASL _unit, 300] call acre_sys_core_fnc_inRange
 *
 * Public: No
 */
#include "script_component.hpp"

params [
    ["_position", [0, 0, 0], [[]]],
    ["_range", 300],
    ["_checkZeus", true]
];

if (_checkZeus && {call FUNC(inZeus)}) exitWith {
    (_position distance (getPosASL curatorCamera) < _range)
};
(_position distance ACRE_LISTENER_POS < _range)
