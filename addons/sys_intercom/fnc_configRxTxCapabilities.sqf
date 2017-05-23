/*
 * Author: ACRE2Team
 * Configures the initial state (No use, TX Ony, RX only or TX/RX) of a rack that is connected to intercom.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle player] call acre_sys_intercom_fnc_configRxTxCapabilities
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

private _racks = [_vehicle] call EFUNC(sys_rack,getVehicleRacks) apply {toLower _x};
private _rackRxTxConfig = _vehicle getVariable [QGVAR(rackRxTxConfig), []];
private _count = count _rackRxTxConfig;

{
    private _intercoms = [_x] call EFUNC(sys_rack,getWiredIntercoms);
    private _intercomPos = [];

    // Get intercom positions
    if ("crew" in _intercoms) then {
        _intercomPos = +(_vehicle getVariable [QGVAR(crewIntercomPositions), []]);
    };

    if ("passenger" in _intercoms) then {
        if (count _intercomPos > 0) then {
            {
                _intercomPos pushBackUnique _x;
            } forEach (_vehicle getVariable [QGVAR(passengerIntercomPositions), []]);
        } else {
            _intercomPos = +(_vehicle getVariable [QGVAR(passengerIntercomPositions), []]);
        };
    };

    if (count _intercomPos > 0) then {
        private _rackId = _x;
        private _rackFunctionality = [];
        {
            _rackfunctionality pushBackUnique [_x, RACK_NO_MONITOR];
        } forEach _intercomPos;

        if (_count > 0) then {
            // Check if rack was already configured
            private _found = false;
            {
                if (_x select 0 == _rackId) exitWith {
                    _found = true;
                };
            } forEach _rackRxTxConfig;

            if (!_found) then {
                _rackRxTxConfig pushBackUnique [_x, _rackFunctionality];
            };
        } else {
            _rackRxTxConfig pushBackUnique [_x, _rackFunctionality];
        };
    };
} forEach _racks;

_vehicle setVariable [QGVAR(rackRxTxConfig), _rackRxTxConfig, true];
