#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the intercom connection status of a limited intercom station.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Intercom network <NUMBER>
 * 2: Connection status <NUMBER>
 * 3: Previous connection status <NUMBER>
 *
 * Return Value:
 * Success <BOOL>
 *
 * Example:
 * [vehicle acre_player, acre_player, 1, 0] call acre_sys_intercom_fnc_handleLimitedConnection
 *
 * Public: No
 */

params ["_vehicle", "_intercomNetwork", "_newConnectedStatus", "_oldConnectedStatus"];

private _numLimitedPositions = (_vehicle getVariable [QGVAR(numLimitedPositions), []]);
private _num = _numLimitedPositions select _intercomNetwork;

private _success = false;
if (_newConnectedStatus > INTERCOM_DISCONNECTED) then {
    if (_oldConnectedStatus > INTERCOM_DISCONNECTED) then {
        // Unit is already connected
        _success =  true;
    } else {
        // Unit is connecting. Check if there are still available connections
        if (_num > 0) then {
            _numLimitedPositions set [_intercomNetwork, _num - 1];
            _vehicle setVariable [QGVAR(numLimitedPositions), _numLimitedPositions, true];

            _success = true;
        } else {
            [localize LSTRING(maxConnections), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
        };
    };
} else {
    _numLimitedPositions set [_intercomNetwork, _num + 1];
    _vehicle setVariable [QGVAR(numLimitedPositions), _numLimitedPositions, true];
    _success = true;
};

_success
