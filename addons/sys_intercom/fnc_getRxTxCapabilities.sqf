/*
 * Author: ACRE2Team
 * Returns the configuration (No use, TX Ony, RX only or TX/RX) for the given unit of a rack that is connected to an intercom.
 *
 * Arguments:
 * 0: Unique rack ID <STRING>
 * 1: Vehicle where the radio rack is <OBJECT>
 * 2: Unit <OBJECT>
 *
 * Return Value:
 * Radio functionality: 0 (Not Monitoring), 1 (Receive only), 2 (Transmit only) and 3 (Receive and Transmit) <NUMBER>
 *
 * Example:
 * ["acre_vrc110_id_1", vehicle acre_player, acre_player] call acre_sys_intercom_fnc_getRxTxCapabilities
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "_vehicle", "_unit", ["_rackId", ""]];

private _functionality = RACK_NO_MONITOR;
private _found = false;

if (_rackId isEqualTo "") then {
    _rackId = [_radioId] call EFUNC(sys_rack,getRackFromRadio);
};

{
    if (_x select 0 == _rackId) then {
        private _radioTxRxConfig = _x select 1;
        {
            private _role = _x select 0;
            switch (_role select 0) do {
                case "driver": {
                    if (driver _vehicle == _unit) then {_functionality = _x select 1; _found = true;};
                };
                case "commander": {
                    if (commander _vehicle == _unit) then {_functionality = _x select 1; _found = true;};
                };
                case "gunner": {
                    if (gunner _vehicle == _unit) then {_functionality = _x select 1; _found = true;};
                };
                case "cargo": {
                    if (_vehicle getCargoIndex _unit == (_role select 1)) then {_functionality = _x select 1; _found = true;};
                };
                case "turret": {
                    if ((_vehicle turretUnit (_role select 1)) == _unit) then {_functionality = _x select 1; _found = true;};
                };
            };
            if (_found) exitWith {};
        } forEach _radioTxRxConfig;

        if (_found) exitWith {};
    };
} forEach (_vehicle getVariable [QGVAR(rackRxTxConfig), []]);

_functionality
