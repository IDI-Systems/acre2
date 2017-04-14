/*
 * Author: ACRE2Team
 * Returns if an individual rack is accessible to a unit specific unit.
 *
 * Arguments:
 * 0: Rack ID <STRING>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * Accessible <BOOLEAN>
 *
 * Example:
 * ["acre_vrc110_id_1",acre_player] call acre_sys_rack_fnc_isRackAccessible;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_rackId", "_unit", ["_vehicle", objNull]];

if (isNull _vehicle) then {
    _vehicle = [_rackId] call FUNC(getVehicleFromRack);
};
private _isRackAccessible = false;

private _allowed = [_rackId, "getState", "allowed"] call EFUNC(sys_data,dataEvent);
{
    switch (_x select 0) do {
        case "external": {
            if (_vehicle != vehicle _unit) exitWith {_isRackAccessible = true;};
        };
        case "inside": {
            if (_vehicle == vehicle _unit) exitWith {_isRackAccessible = true;};
        };
        case "driver": {
            if (driver _vehicle == _unit) exitWith {_isRackAccessible = true;};
        };
        case "commander": {
            if (commander _vehicle == _unit) exitWith {_isRackAccessible = true;};
        };
        case "gunner": {
            if (gunner _vehicle == _unit) exitWith {_isRackAccessible = true;};
        };
        case "cargo": {
            if (_vehicle getCargoIndex _unit == (_x select 1)) exitWith {_isRackAccessible = true;};
        };
        case "turret": {
            if ((_vehicle turretUnit (_x select 1)) == _unit) exitWith {_isRackAccessible = true;};
        };
    };
} forEach _allowed;

private _disabled = [_rackId, "getState", "disabled"] call EFUNC(sys_data,dataEvent);
{
    switch (_x select 0) do {
        case "external": {
            if (_vehicle != vehicle _unit) exitWith {_isRackAccessible = false;};
        };
        case "inside": {
            if (_vehicle == vehicle _unit) exitWith {_isRackAccessible = false;};
        };
        case "turnedout": {
            switch (typeName (_x select 1)) do {
                case "STRING": {
                    if ((_x select 1) isEqualTo "all") then {
                        if (isTurnedOut _unit) then {_inIntercom = false;};
                    } else {
                        switch (_x select 1) do {
                            case "driver": {
                                if (driver _vehicle == _unit && {isTurnedOut _unit}) exitWith {_inIntercom = false;};
                            };
                            case "commander": {
                                if (commander _vehicle == _unit && {isTurnedOut _unit}) exitWith {_inIntercom = false;};
                            };
                            case "gunner": {
                                if (gunner _vehicle == _unit && {isTurnedOut _unit}) exitWith {_inIntercom = false;};
                            };
                            case "copilot": {
                                private _turret = (allTurrets [_vehicle, false]) select {getNumber ([_vehicle, _x] call CBA_fnc_getTurret >> "isCopilot") == 1};
                                {
                                    if ((_vehicle turretUnit (_x select 1)) == _unit && {isTurnedOut (_vehicle turretUnit (_x select 1))}) exitWith {_inIntercom = false;};
                                } forEach _turret;
                            };
                        };
                    };
                };
                case "ARRAY": {
                    if ((_vehicle turretUnit (_x select 1)) == _unit && {isTurnedOut (_vehicle turretUnit (_x select 1))}) exitWith {_inIntercom = false;};
                };
                case "SCALAR": {
                    if (_vehicle getCargoIndex _unit == (_x select 1)) exitWith {_inIntercom = false;};
                };
            };
        };
        case "driver": {
            if (driver _vehicle == _unit) exitWith {_isRackAccessible = false;};
        };
        case "commander": {
            if (commander _vehicle == _unit) exitWith {_isRackAccessible = false;};
        };
        case "gunner": {
            if (gunner _vehicle == _unit) exitWith {_isRackAccessible = false;};
        };
        case "cargo": {
            if (_vehicle getCargoIndex _unit == (_x select 1)) exitWith {_isRackAccessible = false;};
        };
        case "turret": {
            if ((_vehicle turretUnit (_x select 1)) == _unit) exitWith {_isRackAccessible = false;};
        };
    };
} forEach _disabled;

_isRackAccessible
