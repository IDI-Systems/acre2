/*
 * Author: ACRE2Team
 * Handles entering a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit entering a vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, player] call acre_sys_rack_fnc_enterVehicle
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit"];

if (_unit != _vehicle) then {
    private _initialized = _vehicle getVariable [QGVAR(initialized), false];

    if (!_initialized) then {
        //Only initialize if we are first in the crew array - This helps prevent multiple requests if multiple players enter a vehicle around the same time.
        private _crew = crew _vehicle;
        private _firstPlayer = objNull;
        {
            if (!isNull _firstPlayer) exitWith {};
            if (isPlayer _x) exitWith {
                _firstPlayer = _x;
            };
        } forEach _crew;
        if (!isNull _firstPlayer) then {
            if (_unit == _firstPlayer) then {
                [_vehicle] call FUNC(initVehicle);
            };
        } else { // No other players.
            [_vehicle] call FUNC(initVehicle);
        };
    } else {
        if (!(_vehicle getVariable [QGVAR(rackIntercomInitialised), false])) then {
            private _racks = [_vehicle] call FUNC(getVehicleRacks);
            {
                private _intercoms = [_x] call FUNC(getWiredIntercoms);
                private _rackRxTxConfig = _vehicle getVariable [QGVAR(rackRxTxConfig), []];
                if (count _intercoms > 0 && {count _rackRxTxConfig == 0}) exitWith {
                    [_vehicle] call EFUNC(sys_intercom,configRxTxCapabilities);
                    _vehicle setVariable [QGVAR(rackIntercomInitialised), true, true];
                };
            } forEach _racks;
        };
    };

    // Enable the PFH if it is not active. This can only happen if the unit is using an external radio before entering the vehicle
    if (GVAR(rackPFH) != -1) then {
        GVAR(rackPFH) = [DFUNC(rackPFH), 1.1, [_unit, _vehicle]] call CBA_fnc_addPerFrameHandler;
    };
};
