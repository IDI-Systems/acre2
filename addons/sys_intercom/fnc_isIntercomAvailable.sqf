/*
 * Author: ACRE2Team
 * Checks if a intercom network (crew or passenger) is available for a given position.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Intercom network <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, player, CREW_INTERCOM] call acre_sys_intercom_fnc_isIntercomAvailable
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit", "_intercomType"];

if (_vehicle != vehicle _unit) exitWith {false};

private _allowedPositions = (_vehicle getVariable [QGVAR(allowedPositions), []]) select _intercomType;
private _forbiddenPositions = (_vehicle getVariable [QGVAR(forbiddenPositions), []]) select _intercomType;
private _restrictedPositions = (_vehicle getVariable [QGVAR(restrictedPositions), []]) select _intercomType;

private _intercomAvailable = false;
{
    switch (_x select 0) do {
        case "inside": {
            if (_vehicle == vehicle _unit) then {_intercomAvailable = true;};
        };
        case "driver": {
            if (driver _vehicle == _unit) then {_intercomAvailable = true;};
        };
        case "commander": {
            if (commander _vehicle == _unit) then {_intercomAvailable = true;};
        };
        case "gunner": {
            if (gunner _vehicle == _unit) then {_intercomAvailable = true;};
        };
        case "cargo": {
            if (_vehicle getCargoIndex _unit == (_x select 1)) then {_intercomAvailable = true;};
        };
        case "turret": {
            if ((_vehicle turretUnit (_x select 1)) == _unit) then {_intercomAvailable = true;};
        };
    };

    if (_intercomAvailable) exitWith {};
} forEach (_allowedPositions + _restrictedPositions);

if (_intercomAvailable) then {
    {
        switch (_x select 0) do {
            case "inside": {
                if (_vehicle == vehicle _unit) then {_intercomAvailable = false;};
            };
            case "turnedout": {
                switch (typeName (_x select 1)) do {
                    case "STRING": {
                        if ((_x select 1) isEqualTo "all") then {
                            if (isTurnedOut _unit) then {_intercomAvailable = false;};
                        } else {
                            switch (_x select 1) do {
                                case "driver": {
                                    if (driver _vehicle == _unit && {isTurnedOut _unit}) then {_intercomAvailable = false;};
                                };
                                case "commander": {
                                    if (commander _vehicle == _unit && {isTurnedOut _unit}) then {_intercomAvailable = false;};
                                };
                                case "gunner": {
                                    if (gunner _vehicle == _unit && {isTurnedOut _unit}) then {_intercomAvailable = false;};
                                };
                                case "copilot": {
                                    private _turret = (allTurrets [_vehicle, false]) select {getNumber ([_vehicle, _x] call CBA_fnc_getTurret >> "isCopilot") == 1};
                                    {
                                        if ((_vehicle turretUnit (_x select 1)) == _unit && {isTurnedOut (_vehicle turretUnit (_x select 1))}) then {_intercomAvailable = false;};
                                    } forEach _turret;
                                };
                            };
                        };
                    };
                    case "ARRAY": {
                        if ((_vehicle turretUnit (_x select 1)) == _unit && {isTurnedOut (_vehicle turretUnit (_x select 1))}) then {_intercomAvailable = false;};
                    };
                    case "SCALAR": {
                        if (_vehicle getCargoIndex _unit == (_x select 1)) then {_intercomAvailable = false;};
                    };
                };
            };
            case "driver": {
                if (driver _vehicle == _unit) then {_intercomAvailable = false;};
            };
            case "commander": {
                if (commander _vehicle == _unit) then {_intercomAvailable = false;};
            };
            case "gunner": {
                if (gunner _vehicle == _unit) then {_intercomAvailable = false;};
            };
            case "cargo": {
                if (_vehicle getCargoIndex _unit == (_x select 1)) then {_intercomAvailable = false;};
            };
            case "turret": {
                if ((_vehicle turretUnit (_x select 1)) == _unit) then {_intercomAvailable = false;};
            };
        };
        if (!_intercomAvailable) exitWith {};
    } forEach _forbiddenPositions;
};

_intercomAvailable
