/*
 * Author: ACRE2Team
 * Sets the intercom connection status of the vehicle seat the unit is in.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit to be checked <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle acre_player, acre_player] call acre_sys_intercom_fnc_setIntercomConnectionStatus
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit"];

private _inCrewIntercom = [_vehicle, _unit] call FUNC(isInCrewIntercom);
private _inPassengerIntercom = [_vehicle, _unit] call FUNC(isInPassengerIntercom);
private _intercomConnection = NO_INTERCOM;

if (_inCrewIntercom && !_inPassengerIntercom) then {
    _intercomConnection = CREW_INTERCOM;
};

if (!_inCrewIntercom && _inPassengerIntercom) then {
    _intercomConnection = PASSENGER_INTERCOM;
};

if (_inCrewIntercom && _inPassengerIntercom) then {
    _intercomConnection = CREW_AND_PASSENGER_INTERCOM;
};

private _found = false;
private _intercomStatus = _vehicle getVariable [QGVAR(intercomStatus), []];

{
    private _position = _x select 0;
    switch (_position select 0) do {
        case "driver": {
            if (driver _vehicle == _unit) then { _x set [1, _intercomConnection]; _found = true;};
        };
        case "commander": {
            if (commander _vehicle == _unit) then {_x set [1, _intercomConnection]; _found = true;};
        };
        case "gunner": {
            if (gunner _vehicle == _unit) then {_x set [1, _intercomConnection]; _found = true;};
        };
        case "cargo": {
            if (_vehicle getCargoIndex _unit == (_position select 1)) then {_x set [1, _intercomConnection]; _found = true;};
        };
        case "turret": {
            if ((_vehicle turretUnit (_position select 1)) == _unit) then {_x set [1, _intercomConnection]; _found = true;};
        };
    };
    if (_found) exitWith {};
} forEach _intercomStatus;

_vehicle setVariable [QGVAR(intercomStatus), _intercomStatus, true];
