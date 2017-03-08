/*
 * Author: ACRE2Team
 * Updates the status of the passenger intercom of a vehicle.
 *
 * Arguments:
 * 0: Vehicle with passenger intercom <OBJECT>
 * 1: Unit using the passenger intercom  <OBJECT>
 * 2: Type of action <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, player, 1] call acre_sys_intercom_updatePassengerIntercomStatus
 *
 * Public: No
 */

#include "script_component.hpp"

params ["_vehicle", "_unit", "_action"];

private _unitsPassengerIntercom = _vehicle getVariable [QGVAR(unitsPassengerIntercom), []];
private _availableConnections = _vehicle getVariable  [QGVAR(availablePassIntercomConn), 0];

private _crew = [driver _vehicle, gunner _vehicle, commander _vehicle];
{
    _crew pushBackUnique (_vehicle turretUnit _x);
} forEach (allTurrets [_vehicle, false]);
_crew = _crew - [objNull];

if (_action == 0) then {
    // Disconnect from passenger intercom
    _unitsPassengerIntercom = _unitsPassengerIntercom - [_unit];
    if (_unit getVariable [QGVAR(usesPassengerIntercomConnection), false]) then {
        _availableConnections = _availableConnections + 1;
        _vehicle setVariable [QGVAR(availablePassIntercomConn), _availableConnections, true];
    };

    _unit setVariable [QGVAR(vehiclePassengerIntercom), objNull, true];
    _vehicle setVariable [QGVAR(unitsPassengerIntercom), _unitsPassengerIntercom, true];
    [localize LSTRING(passengerIntercomDisconnected), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
} else {
    // Connect to passenger intercom
    if ((_unit in _crew) || (!(_unit in _crew) && _availableConnections > 0)) then {
        _unitsPassengerIntercom = _unitsPassengerIntercom + [_unit];
        if (!(_unit in _crew)) then {
            _availableConnections = _availableConnections - 1;
            _vehicle setVariable [QGVAR(availablePassIntercomConn), _availableConnections, true];
            _unit setVariable [QGVAR(usesPassengerIntercomConnection), true, true];
        };

        _unit setVariable [QGVAR(vehiclePassengerIntercom), _vehicle, true];
        _vehicle setVariable [QGVAR(unitsPassengerIntercom), _unitsPassengerIntercom, true];
        [localize LSTRING(passengerIntercomConnected), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    } else {
        if (_availableConnections == 0) then {
            [localize LSTRING(passengerIntercomNoConnections), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
        };
    };
};
