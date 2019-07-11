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

private _intercomStations = _vehicle getVariable [QGVAR(intercomStations), []];
{
    private _stationName = _x;
    {
        private _seatHasIntercomAccess = [_vehicle, objNull, _forEachIndex, INTERCOM_STATIONSTATUS_HASINTERCOMACCESS, _stationName] call FUNC(getStationConfiguration);

        private _intercomStatus = (_vehicle getVariable [_stationName, [] call CBA_fnc_hashCreate]) select _forEachIndex;
        private _rackRxTxConfig = [_intercomStatus, INTERCOM_STATIONSTATUS_WIREDRACKS] call CBA_fnc_hashGet;

        {
            // RackID, MONITOR STATUS, Has access to rack. By default if seat has intercom access, the unit sitting in it can use the rack. This can be
            // changed using a master control station (MCS)
            _rackRxTxConfig set [_forEachIndex, [_x, RACK_NO_MONITOR, _seatHasIntercomAccess]];
        } forEach _racks;

        [_intercomStatus, INTERCOM_STATIONSTATUS_WIREDRACKS, _rackRxTxConfig] call CBA_fnc_hashSet;
    } forEach _intercoms;
} forEach _intercomStations;

_vehicle setVariable [QGVAR(intercomStations), _intercomStations, true];
