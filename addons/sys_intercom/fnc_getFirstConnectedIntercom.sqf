#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the first connected intercom network.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Intercom network or -1 if no connected intercom network exist <NUMBER>
 *
 * Example:
 * [vehicle acre_player] call acre_sys_intercom_fnc_getFirstConnectedIntercom
 *
 * Public: No
 */

params ["_vehicle"];

private _intercomNames = _vehicle getVariable [QGVAR(intercomNames), []];

if (_vehicle isEqualTo acre_player || {_intercomNames isEqualTo []}) exitWith {-1};

private _activeIntercom = -1;
{
    private _connectionStatus = [_vehicle, acre_player, _forEachIndex, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration);
    if (_connectionStatus > INTERCOM_DISCONNECTED) exitWith {
        _activeIntercom = _forEachIndex;
    }
} forEach _intercomNames;

_activeIntercom
