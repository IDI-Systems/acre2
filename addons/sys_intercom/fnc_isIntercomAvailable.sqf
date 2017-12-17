/*
 * Author: ACRE2Team
 * Configures the initial intercom connectivity (disconnected/connected) for all allowed seats.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Allowed positions <ARRAY>
 * 2: Forbidden positions <ARRAY>
 * 3: Positions with limited connectivity <ARRAY>
 * 4: Initial intercom configuration
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle player] call acre_sys_intercom_fnc_isIntercomAvailable
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit", "_intercomNetwork"];

private _varName = [_vehicle, _unit] call FUNC(getStationVariableName);

private _isAvailable = true;

{
    private _condition = [_vehicle, _unit, _intercomNetwork, _x] call FUNC(getStationConfiguration);
    switch (_x) do {
        case INTERCOM_STATIONSTATUS_HASINTERCOMACCESS: {
            _isAvailable =  _condition;
        };
        case INTERCOM_STATIONSTATUS_CONNECTION: {
            _isAvailable = _condition > INTERCOM_DISCONNECTED;
        };
        case INTERCOM_STATIONSTATUS_TURNEDOUTALLOWED: {
            _isAvailable = _condition && {isTurnedOut _unit};
        };
    };
    if (!isAvailable) exitWith {};
} forEach [INTERCOM_STATIONSTATUS_HASINTERCOMACCESS, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_STATIONSTATUS_TURNEDOUTALLOWED];

_isAvailable
