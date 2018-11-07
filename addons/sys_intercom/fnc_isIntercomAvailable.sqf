#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if the seat the unit is in has intercom access.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Intercom network <NUMBER>
 *
 * Return Value:
 * Intercom is available <BOOL>
 *
 * Example:
 * [vehicle player, player, 0] call acre_sys_intercom_fnc_isIntercomAvailable
 *
 * Public: No
 */

params ["_vehicle", "_unit", "_intercomNetwork"];

private _isAvailable = true;
{
    private _condition = [_vehicle, _unit, _intercomNetwork, _x] call FUNC(getStationConfiguration);
    switch (_x) do {
        case INTERCOM_STATIONSTATUS_HASINTERCOMACCESS: {
            _isAvailable = _condition;
        };
        case INTERCOM_STATIONSTATUS_CONNECTION: {
            _isAvailable = _condition > INTERCOM_DISCONNECTED;
        };
        case INTERCOM_STATIONSTATUS_TURNEDOUTALLOWED: {
            if (isTurnedOut _unit) then {
                _isAvailable = _condition;
            };
        };
    };
    if (!_isAvailable) exitWith {};
} forEach [INTERCOM_STATIONSTATUS_HASINTERCOMACCESS, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_STATIONSTATUS_TURNEDOUTALLOWED];

_isAvailable
