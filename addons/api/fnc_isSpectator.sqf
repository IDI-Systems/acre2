#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks whether the provided unit (or by default local player) is spectating.
 *
 * Arguments:
 * 0: Unit <OBJECT>(default:acre_player)
 *
 * Return Value:
 * Spectating <BOOLEAN>
 *
 * Example:
 *  _isSpectator = [] call acre_api_fnc_isSpectator;
 * _isSpectator = [player] call acre_api_fnc_isSpectator;
 *
 * Public: Yes
 */

params [
    ["_unit", acre_player, [objNull]]
];

if (_unit == acre_player) then {
    ACRE_IS_SPECTATOR
} else {
    _unit in ACRE_SPECTATORS_LIST
};
