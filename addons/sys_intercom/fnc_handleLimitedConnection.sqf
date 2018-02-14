/*
 * Author: ACRE2Team
 * Sets the intercom connection status of a limited intercom station.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Intercom network <NUMBER>
 * 2: Connected <BOOL>
 *
 * Return Value:
 * Success <BOOL>
 *
 * Example:
 * [vehicle acre_player, acre_player, 1] call acre_sys_intercom_fnc_handleLimitedConnection
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_intercomNetwork", "_connected"];

private _numLimitedPositions = (_vehicle getVariable [QGVAR(numLimitedPositions), []]);
private _num = _numLimitedPositions select _intercomNetwork;

private _success = false;
if (_connected > INTERCOM_DISCONNECTED) then {
    if (_num > 0) then {
        _numLimitedPositions set [_intercomNetwork, _num - 1];
        _vehicle setVariable [QGVAR(numLimitedPositions), _numLimitedPositions, true];

        _success = true;
    } else {
        [localize LSTRING(maxConnections), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    };
} else {
    _numLimitedPositions set [_intercomNetwork, _num + 1];
    _vehicle setVariable [QGVAR(numLimitedPositions), _numLimitedPositions, true];
    _success = true;
};

_success
