#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the intercom switching keybind.
 *
 * Arguments:
 * 0: Intercom change amount (expected -1 or 1) <NUMBER>
 * 1: Disconnect others <BOOL>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [1, true] call acre_sys_intercom_fnc_switchIntercomFast
 *
 * Public: No
 */

params ["_dir", "_disconnectOthers"];

private _return = false;
private _vehicle = vehicle acre_player;

if (_vehicle == acre_player) exitWith {_return};

// Do nothing if the vehicle has one or less intercom networks
private _intercomCount = count (_vehicle getVariable [QGVAR(intercomNames), []]);
if (_intercomCount <= 1) exitWith {_return};

private _activeIntercom = -1;
private _hasAccessibleIntercoms = false;
// Get active intercom. If more than one, then the last intercom index is used
{
    private _hasAccess = [_vehicle, acre_player, _forEachIndex, INTERCOM_STATIONSTATUS_HASINTERCOMACCESS] call FUNC(getStationConfiguration);
    if (_hasAccess) then {
        _hasAccessibleIntercoms = true;
        private _functionality = [_vehicle, acre_player, _forEachIndex, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration);
        if (_functionality > INTERCOM_DISCONNECTED) then {
            _activeIntercom = _forEachIndex;
        };
    };
} forEach (_vehicle getVariable [QGVAR(intercomNames), []]);

// The seat has no accessible intercom networks
if (!_hasAccessibleIntercoms) exitWith {_return};

private _valid = false;
private _nextIntercom = _activeIntercom;

while {!_valid} do {
    _nextIntercom = _nextIntercom + _dir;
    if (_nextIntercom < 0 || _nextIntercom >= _intercomCount) then {
        if (_dir ==  1) then {
            _nextIntercom = 0;
        } else {
            _nextIntercom = _intercomCount - 1;
        };
    };

    _valid = [_vehicle, acre_player, _nextIntercom, INTERCOM_STATIONSTATUS_HASINTERCOMACCESS] call FUNC(getStationConfiguration);
};

// Disconnect the previous network and set the new to RX & TX
if (_nextIntercom != _activeIntercom) then {
    // Disconnect other intercoms
    if (_disconnectOthers) then {
        {
            if (_forEachIndex != _nextIntercom) then {
                [_vehicle, acre_player, _forEachIndex, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_DISCONNECTED] call FUNC(setStationConfiguration);
            };
        } forEach (_vehicle getVariable [QGVAR(intercomNames), []]);
    };

    [_vehicle, acre_player, _nextIntercom, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_RX_AND_TX] call FUNC(setStationConfiguration);
    _return = true;
};

_return
