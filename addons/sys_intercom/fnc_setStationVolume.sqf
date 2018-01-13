/*
 * Author: ACRE2Team
 * Sets the intercom volume status of the vehicle seat the unit is in.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Volume [0...1] <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle acre_player, 0.7] call acre_sys_intercom_fnc_setStationVolume
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit", "_volume"];

private _found = false;
private _intercomStatus = _vehicle getVariable [QGVAR(intercomStatus), []];

{
    private _position = _x select 0;
    switch (_position select 0) do {
        case "driver": {
            if (driver _vehicle == _unit) then { _x set [2, _volume]; _found = true;};
        };
        case "commander": {
            if (commander _vehicle == _unit) then {_x set [2, _volume]; _found = true;};
        };
        case "gunner": {
            if (gunner _vehicle == _unit) then {_x set [2, _volume]; _found = true;};
        };
        case "cargo": {
            if (_vehicle getCargoIndex _unit == (_position select 1)) then {_x set [2, _volume]; _found = true;};
        };
        case "turret": {
            if ((_vehicle turretUnit (_position select 1)) == _unit) then {_x set [2, _volume]; _found = true;};
        };
    };
    if (_found) exitWith {};
} forEach _intercomStatus;

_vehicle setVariable [QGVAR(intercomStatus), _intercomStatus, true];
