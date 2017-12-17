/*
 * Author: ACRE2Team
 * Configures the initial state (No use, TX Ony, RX only or TX/RX) of a rack that is connected to the intercom.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle player] call acre_sys_intercom_fnc_configRackRxTxCapabilities
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

private _racks = [_vehicle] call EFUNC(sys_rack,getVehicleRacks);

{
    private _rackRxTxConfig = [];
    private _stationName = _x;
    {
        private _rackId = _x;
        private _intercoms = [_rackId] call EFUNC(sys_rack,getWiredIntercoms);
        {
            private _seatHasIntercomAccess = [_vehicle, objNull, _forEachIndex, INTERCOM_STATIONSTATUS_HASINTERCOMACCESS, _stationName] call FUNC(getStationConfiguration);
            if (_seatHasIntercomAccess) then {
                _rackRxTxConfig pushBackUnique [_rackId, RACK_NO_MONITOR];
            }
        } forEach (_vehicle getVariable [QGVAR(intercomNames), []]);
    } forEach _racks;

    _vehicle setVariable [_x + "_rack", _rackRxTxConfig, true];
} forEach (_vehicle getVariable [QGVAR(intercomStations), []]);
