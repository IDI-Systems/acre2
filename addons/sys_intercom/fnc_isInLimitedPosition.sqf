/*
 * Author: ACRE2Team
 * Checks if the player can have access to a limited intercom position.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Intercom network <NUMBER>
 *
 * Return Value:
 * True if the player is in a limited position, false otherwise
 *
 * Example:
 * [cursorTarget, player, 0] call acre_sys_intercom_fnc_isInLimitedPosition
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit", "_intercomNetwork"];

if (_vehicle != vehicle _unit) exitWith {false};

private _limitedPositions = (_vehicle getVariable [QGVAR(limitedPositions), []]) select _intercomNetwork;

private _limitedPositionAvailable = false;
{
    switch (_x select 0) do {
        case "inside": {
            if (_vehicle == vehicle _unit) then {_limitedPositionAvailable = true;};
        };
        case "driver": {
            if (driver _vehicle == _unit) then {_limitedPositionAvailable = true;};
        };
        case "commander": {
            if (commander _vehicle == _unit) then {_limitedPositionAvailable = true;};
        };
        case "gunner": {
            if (gunner _vehicle == _unit) then {_limitedPositionAvailable = true;};
        };
        case "cargo": {
            if (_vehicle getCargoIndex _unit == (_x select 1)) then {_limitedPositionAvailable = true;};
        };
        case "turret": {
            if ((_vehicle turretUnit (_x select 1)) == _unit) then {_limitedPositionAvailable = true;};
        };
    };

    if (_limitedPositionAvailable) exitWith {};
} forEach _limitedPositions;

_limitedPositionAvailable
