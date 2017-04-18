/*
 * Author: ACRE2Team
 * Returns the configuration (No use, TX Ony, RX only or TX/RX) for the given unit of a radio that is connected to an intercom.
 *
 * Arguments:
 * 0: Radio configuration <ARRAY>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * Can transmit throught the radio <BOOL>
 *
 * Example:
 * [[[["driver"], 1], [["cargo", 1], 2]], acre_player] call acre_sys_intercom_fnc_getRxTxCapabilities
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

private _racks = [_vehicle] call EFUNC(sys_rack,getVehicleRacks);
private _rackTxRxConfig = [];

{
    private _intercoms = [_x] call EFUNC(sys_rack, getWiredIntercoms);
    private _intercomPos = [];

    // Get intercom positions
    if ("crew" in _intercoms) then {
        _intercomPos = _vehicle getVariable [QGVAR(crewIntercomPositions), []];
    };

    if ("passenger" in _intercoms) then {
        if (count _intercomPos > 0) then {
            {
                _intercomPos pushBackUnique _x;
            } forEach _vehicle getVariable [QGVAR(passengerIntercomPositions), []];
        } else {
            _intercomPos = _vehicle getVariable [QGVAR(passengerIntercomPositions), []];
        };
    };

    if (count _intercomPos > 0) then {
        private _rackFunctionality = [];
        {
            _rackfunctionality pushBackUnique [_x, RACK_RX_AND_TX];
        } forEach _intercomPos;

        _rackTxRxConfig pushBackUnique [_x, _rackFunctionality];
    };
} forEach _racks;

systemChat format ["%1", _rackTxRxConfig];

_vehicle setVariable [QGVAR(rackTxRxConfig), _rackTxRxConfig, true];
