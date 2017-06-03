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
private _unitsCrewIntercom = _vehicle getVariable [QGVAR(unitsCrewIntercom), []];

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

    // Do not update for infantry phone
    if (_unit != ((_vehicle getVariable [QGVAR(unitInfantryPhone), [objNull, NO_INTERCOM]]) select 0)) then {
        // Update intercom connection status
        [_vehicle, _unit] call FUNC(setIntercomConnectionStatus);
    };
} else {
    // Connect to passenger intercom
    if ((_unit in _unitsCrewIntercom) || (!(_unit in _unitsCrewIntercom) && [_vehicle, acre_player, PASSENGER_INTERCOM] call FUNC(isIntercomAvailable) && _availableConnections > 0)) then {
        _unitsPassengerIntercom pushBackUnique _unit;
        if (!(_unit in _unitsCrewIntercom) && [_vehicle, acre_player, PASSENGER_INTERCOM] call FUNC(isIntercomAvailable) && (vehicle _unit == _vehicle)) then {
            _availableConnections = _availableConnections - 1;
            _vehicle setVariable [QGVAR(availablePassIntercomConn), _availableConnections, true];
            // Infantry phone does not use any connection
            _unit setVariable [QGVAR(usesPassengerIntercomConnection), true, true];
        };

        _unit setVariable [QGVAR(vehiclePassengerIntercom), _vehicle, true];
        _vehicle setVariable [QGVAR(unitsPassengerIntercom), _unitsPassengerIntercom, true];
        [localize LSTRING(passengerIntercomConnected), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);

        // Do not update for infantry phone
        if (_unit != ((_vehicle getVariable [QGVAR(unitInfantryPhone), [objNull, NO_INTERCOM]]) select 0)) then {
            // Update intercom connection status
            [_vehicle, acre_player] call FUNC(setIntercomConnectionStatus);
        };
    } else {
        if (_availableConnections == 0) then {
            [localize LSTRING(passengerIntercomNoConnections), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);

            // Update intercom connection status
            [_vehicle, acre_player] call FUNC(setIntercomConnectionStatus);
        };
    };
};
