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
private _rackRxTxConfig = [];



{

    private _intercoms = [_x] call EFUNC(sys_rack,getWiredIntercoms);
    private _intercomPos = [];
    systemChat format ["Configured Rack radios"];

    // Get intercom positions
    {
        systemChat format ["intercom pos %1", _forEachIndex];

        if (_x in _intercoms) then {
            private _allowedPositions = (_vehicle getVariable [QGVAR(allowedPositions), []]) select _forEachIndex;
            private _restrictedPositions = (_vehicle getVariable [QGVAR(restrictedPositions), []]) select _forEachIndex;

            private _intPos = _x;
            {
                _intercomPos pushBackUnique _x;
            } forEach (_allowedPositions + _restrictedPositions);
        };
    } forEach (_vehicle getVariable [QGVAR(intercomNames), []]);

    if (count _intercomPos > 0) then {
        private _rackFunctionality = [];
        {
            _rackfunctionality pushBackUnique [_x, RACK_NO_MONITOR];
        } forEach _intercomPos;

        _rackRxTxConfig pushBackUnique [_x, _rackFunctionality];
    };
} forEach _racks;

_vehicle setVariable [QGVAR(rackRxTxConfig), _rackRxTxConfig, true];
