/*
 * Author: ACRE2Team
 * Handles the case of a unit switching seats in a vehicle with intercom.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit to be checked <OBJECT>
 *
 * Return Value:
 * Unit is in the given intercom network
 *
 * Example:
 * [cursorTarget, acre_player] call acre_sys_intercom_fnc_seatSwitched
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit"];

private _intercoms = _vehicle getVariable [QGVAR(intercomNames), []];
private _usingLimitedPosition = _unit getVariable [QGVAR(usingLimitedPosition), []];

for "_i" from 0 to ((count _intercoms) - 1) do {
    private _isUsingLimitedPosition = _usingLimitedPosition select _i;
    private _isInLimitedPosition = [_vehicle, _unit, _i] call FUNC(isInLimitedPosition);

    // If switching from a limited connection to a non-limited seat
    if (_isUsingLimitedPosition && {!_isInLimitedPosition}) then {
        private _numLimitedPositions = (_vehicle getVariable [QGVAR(numLimitedPositions), []]);
        private _num = _numLimitedPositions select _i;

        _numLimitedPositions set [_i, _num + 1];
        _vehicle setVariable [QGVAR(numLimitedPositions), _numLimitedPositions, true];

        _usingLimitedPosition set [_i, false];
        _unit setVariable [QGVAR(usingLimitedPosition), _usingLimitedPosition];
    };

    // Keep the settings if the unit switches from a limited connection seat to another limited connection seat and the unit is already
    // in an intercom. Otherwise, seat configuration takes preference.
    if (!(_isUsingLimitedPosition && _isInLimitedPosition)) then {
        [_vehicle, _unit, _i] call acre_sys_intercom_fnc_setIntercomUnits;
    };
};
