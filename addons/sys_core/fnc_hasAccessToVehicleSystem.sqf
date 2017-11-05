/*
 * Author: ACRE2Team
 * Checks if the given unit can have access to a vehicle system like intercom or vehicle racks.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Allowed positions <ARRAY>
 * 3: Forbidden positions <ARRAY>
 * 4: Maximum distance for external use <NUMBER> (default: 0)
 *
 * Return Value:
 * True if the system is available, false otherwise <BOOL>
 *
 * Example:
 * [cursorTarget, player, [["driver"], ["commander"]], [["gunner"]]] call acre_sys_core_fnc_hasAccessToVehicleSystem
 *
 * Public: No
 */

params ["_vehicle", "_unit", "_allowedPositions", "_forbiddenPositions", ["_maxDistance", 0]];

private _systemAvailable = false;

if (!alive _vehicle) exitWith {_systemAvailable};

{
    switch (_x select 0) do {
        case "external": {
            if (_vehicle != vehicle _unit && {_vehicle distance _unit <= _maxDistance}) exitWith {_systemAvailable = true;};
        };
        case "inside": {
            if (_vehicle == vehicle _unit) then {_systemAvailable = true;};
        };
        case "driver": {
            if (driver _vehicle == _unit) then {_systemAvailable = true;};
        };
        case "commander": {
            if (commander _vehicle == _unit) then {_systemAvailable = true;};
        };
        case "gunner": {
            if (gunner _vehicle == _unit) then {_systemAvailable = true;};
        };
        case "cargo": {
            if (_vehicle getCargoIndex _unit == (_x select 1)) then {_systemAvailable = true;};
        };
        case "turret": {
            if ((_vehicle turretUnit (_x select 1)) == _unit) then {_systemAvailable = true;};
        };
    };

    if (_systemAvailable) exitWith {};
} forEach _allowedPositions;

if (_systemAvailable) then {
    {
        switch (_x select 0) do {
            case "inside": {
                if (_vehicle == vehicle _unit) then {_systemAvailable = false;};
            };
            case "turnedout": {
                switch (typeName (_x select 1)) do {
                    case "STRING": {
                        if ((_x select 1) isEqualTo "all") then {
                            if (isTurnedOut _unit) then {_systemAvailable = false;};
                        } else {
                            switch (_x select 1) do {
                                case "driver": {
                                    if (driver _vehicle == _unit && {isTurnedOut _unit}) then {_systemAvailable = false;};
                                };
                                case "commander": {
                                    if (commander _vehicle == _unit && {isTurnedOut _unit}) then {_systemAvailable = false;};
                                };
                                case "gunner": {
                                    if (gunner _vehicle == _unit && {isTurnedOut _unit}) then {_systemAvailable = false;};
                                };
                                case "copilot": {
                                    private _turret = (allTurrets [_vehicle, false]) select {getNumber ([_vehicle, _x] call CBA_fnc_getTurret >> "isCopilot") == 1};
                                    {
                                        if ((_vehicle turretUnit (_x select 1)) == _unit && {isTurnedOut (_vehicle turretUnit (_x select 1))}) then {_systemAvailable = false;};
                                    } forEach _turret;
                                };
                            };
                        };
                    };
                    case "ARRAY": {
                        if ((_vehicle turretUnit (_x select 1)) == _unit && {isTurnedOut (_vehicle turretUnit (_x select 1))}) then {_systemAvailable = false;};
                    };
                    case "SCALAR": {
                        if (_vehicle getCargoIndex _unit == (_x select 1)) then {_systemAvailable = false;};
                    };
                };
            };
            case "driver": {
                if (driver _vehicle == _unit) then {_systemAvailable = false;};
            };
            case "commander": {
                if (commander _vehicle == _unit) then {_systemAvailable = false;};
            };
            case "gunner": {
                if (gunner _vehicle == _unit) then {_systemAvailable = false;};
            };
            case "cargo": {
                if (_vehicle getCargoIndex _unit == (_x select 1)) then {_systemAvailable = false;};
            };
            case "turret": {
                if ((_vehicle turretUnit (_x select 1)) == _unit) then {_systemAvailable = false;};
            };
        };
        if (!_systemAvailable) exitWith {};
    } forEach _forbiddenPositions;
};

_systemAvailable
