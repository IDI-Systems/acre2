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
 * [cursorTarget, player, CREW_INTERCOM] call acre_sys_intercom_isIntercomAvailable
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit", "_intercomType"];

if (_vehicle != vehicle _unit) exitWith {false};

if ([_vehicle] call FUNC(areIntercomsDisabled)) exitWith {false};

private _availableIntercomPos = [];
private _exceptionsIntercomPos = [];
switch (_intercomType) do {
    case CREW_INTERCOM: {
        _availableIntercomPos = _vehicle getVariable [QGVAR(crewIntercomPositions), []];
        _exceptionsIntercomPos = _vehicle getVariable [QGVAR(crewIntercomExceptions), []];
    };
    case PASSENGER_INTERCOM: {
        _availableIntercomPos = _vehicle getVariable [QGVAR(passengerIntercomPositions), []];
        _exceptionsIntercomPos = _vehicle getVariable [QGVAR(passengerIntercomExceptions), []];
    };
};

private _inIntercom = false;
{
    switch (_x select 0) do {
        case "inside": {
            if (_vehicle == vehicle _unit) then {_inIntercom = true;};
        };
        case "driver": {
            if (driver _vehicle == _unit) then {_inIntercom = true;};
        };
        case "commander": {
            if (commander _vehicle == _unit) then {_inIntercom = true;};
        };
        case "gunner": {
            if (gunner _vehicle == _unit) then {_inIntercom = true;};
        };
        case "cargo": {
            if (_vehicle getCargoIndex _unit == (_x select 1)) then {_inIntercom = true;};
        };
        case "turret": {
            if ((_vehicle turretUnit (_x select 1)) == _unit) then {_inIntercom = true;};
        };
    };

    if (_inIntercom) exitWith {};
} forEach _availableIntercomPos;

if (_inIntercom) then {
    {
        switch (_x select 0) do {
            case "inside": {
                if (_vehicle == vehicle _unit) then {_inIntercom = false;};
            };
            case "turnedout": {
                switch (typeName (_x select 1)) do {
                    case "STRING": {
                        if ((_x select 1) isEqualTo "all") then {
                            if (isTurnedOut _unit) then {_inIntercom = false;};
                        } else {
                            switch (_x select 1) do {
                                case "driver": {
                                    if (driver _vehicle == _unit && {isTurnedOut _unit}) then {_inIntercom = false;};
                                };
                                case "commander": {
                                    if (commander _vehicle == _unit && {isTurnedOut _unit}) then {_inIntercom = false;};
                                };
                                case "gunner": {
                                    if (gunner _vehicle == _unit && {isTurnedOut _unit}) then {_inIntercom = false;};
                                };
                                case "copilot": {
                                    private _turret = (allTurrets [_vehicle, false]) select {getNumber ([_vehicle, _x] call CBA_fnc_getTurret >> "isCopilot") == 1};
                                    {
                                        if ((_vehicle turretUnit (_x select 1)) == _unit && {isTurnedOut (_vehicle turretUnit (_x select 1))}) then {_inIntercom = false;};
                                    } forEach _turret;
                                };
                            };
                        };
                    };
                    case "ARRAY": {
                        if ((_vehicle turretUnit (_x select 1)) == _unit && {isTurnedOut (_vehicle turretUnit (_x select 1))}) then {_inIntercom = false;};
                    };
                    case "SCALAR": {
                        if (_vehicle getCargoIndex _unit == (_x select 1)) then {_inIntercom = false;};
                    };
                };
            };
            case "driver": {
                if (driver _vehicle == _unit) then {_inIntercom = false;};
            };
            case "commander": {
                if (commander _vehicle == _unit) then {_inIntercom = false;};
            };
            case "gunner": {
                if (gunner _vehicle == _unit) then {_inIntercom = false;};
            };
            case "cargo": {
                if (_vehicle getCargoIndex _unit == (_x select 1)) then {_inIntercom = false;};
            };
            case "turret": {
                if ((_vehicle turretUnit (_x select 1)) == _unit) then {_inIntercom = false;};
            };
        };
        if (!_inIntercom) exitWith {};
    } forEach _exceptionsIntercomPos;
};

_inIntercom
