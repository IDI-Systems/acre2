#include "script_component.hpp"
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

params ["_vehicle"];

private _racks = [_vehicle] call EFUNC(sys_rack,getVehicleRacks);
private _intercoms = (_vehicle getVariable [QGVAR(intercomNames), []]);

{
    private _rackRxTxConfig = [];
    private _stationName = _x;
    {
        private _seatHasIntercomAccess = [_vehicle, objNull, _forEachIndex, INTERCOM_STATIONSTATUS_HASINTERCOMACCESS, _stationName] call FUNC(getStationConfiguration);

        {
            // RackID, MONITOR STATUS, Has access to rack. By default if seat has intercom access, the unit sitting in it can use the rack. This can be
            // changed using a master control station (MCS)
            _rackRxTxConfig pushBack [_x, RACK_NO_MONITOR, _seatHasIntercomAccess];
        } forEach _racks;

        [_vehicle, objNull, _forEachIndex, "wiredRacks", _rackRxTxConfig] call FUNC(setStationConfiguration);
    } forEach _intercoms;
} forEach (_vehicle getVariable [QGVAR(intercomStations), []]);
