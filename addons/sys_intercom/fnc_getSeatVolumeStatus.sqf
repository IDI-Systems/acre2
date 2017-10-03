/*
 * Author: ACRE2Team
 * Gets the intercom volume status of the vehicle seat the unit is in.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit to be checked <OBJECT>
 * 2: Intercom network <NUMBER>
 *
 * Return Value:
 * Intercom volume status <NUMBER>
 *
 * Example:
 * [vehicle acre_player, acre_player] call acre_sys_intercom_fnc_getIntercomVolumeStatus
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit", "_intercomNetwork"];

private _intercomStatus = INTERCOM_DEFAULT_VOLUME;
private _found = false;

{
    private _position = _x select 0;
    switch (_position select 0) do {
        case "driver": {
            if (driver _vehicle == _unit) then {_intercomStatus = (_x select 2) select _intercomNetwork; _found = true;};
        };
        case "commander": {
            if (commander _vehicle == _unit) then {_intercomStatus = (_x select 2) select _intercomNetwork; _found = true;};
        };
        case "gunner": {
            if (gunner _vehicle == _unit) then {_intercomStatus = (_x select 2) select _intercomNetwork; _found = true;};
        };
        case "cargo": {
            if (_vehicle getCargoIndex _unit == (_position select 1)) then {(_x select 2) select _intercomNetwork; _found = true;};
        };
        case "turret": {
            if ((_vehicle turretUnit (_position select 1)) == _unit) then {(_x select 2) select _intercomNetwork; _found = true;};
        };
    };
    if (_found) exitWith {};
} forEach (_vehicle getVariable [QGVAR(intercomStatus), []]);

_intercomStatus
