/*
 * Author: ACRE2Team
 * Gets the intercom connection status of the vehicle seat the unit is in.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit to be checked <OBJECT>
 *
 * Return Value:
 * Intercom connection status <NUMBER>
 *  - 0: no intercom
 *  - 1: crew intercom
 *  - 2: passenger intercom
 *  - 3: crew and passenger intercoms
 *
 * Example:
 * [vehicle acre_player, acre_player] call acre_sys_intercom_getIntercomConnectionStatus
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit"];

private _intercomStatus = NO_INTERCOM;
private _found = false;

{
    private _position = _x select 0;
    switch (_position select 0) do {
        case "driver": {
            if (driver _vehicle == _unit) then {_intercomStatus = _x select 1; _found = true;};
        };
        case "commander": {
            if (commander _vehicle == _unit) then {_intercomStatus = _x select 1; _found = true;};
        };
        case "gunner": {
            if (gunner _vehicle == _unit) then {_intercomStatus = _x select 1; _found = true;};
        };
        case "cargo": {
            if (_vehicle getCargoIndex _unit == (_position select 1)) then {_intercomStatus = _x select 1; _found = true;};
        };
        case "turret": {
            if ((_vehicle turretUnit (_position select 1)) == _unit) then {_intercomStatus = _x select 1; _found = true;};
        };
    };
    if (_found) exitWith {};
} forEach (_vehicle getVariable [QGVAR(intercomStatus), []]);

_intercomStatus
