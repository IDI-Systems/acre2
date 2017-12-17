/*
 * Author: ACRE2Team
 * Configures the initial intercom connectivity (disconnected/connected) for all allowed seats.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Allowed positions <ARRAY>
 * 2: Forbidden positions <ARRAY>
 * 3: Positions with limited connectivity <ARRAY>
 * 4: Initial intercom configuration
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle player] call acre_sys_intercom_fnc_configIntercomStations
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_allowedPositions", "_forbiddenPositions", "_limitedPositions", "_initialConfiguration"];

private _type = typeOf _vehicle;

private _intercomStations = [];

{
    private _unit = _x select 0;
    private _role = toLower (_x select 1);
    if (_role in ["cargo", "turret"]) then {
        if (_role isEqualTo "cargo") then {
            _role = format ["%1_%2", _role, _x select 2];
        } else {
            _role = format ["%1_%2", _role, _x select 3];
        };
    };
    private _seatConfiguration = [];
    {
        // Array has the following format:
        // 0: Configuration array
        //   0: Has Intercom access <BOOL> (default: false)
        //   1: Connection status <NUMBER> (default: disconnected)
        //   2: Volume <NUMBER> (default: 1)
        //   3: This is a seat with limited connectivity <BOOL> (default: false)
        //   4: Turned out is allowed <BOOL> (default: true)
        //   5: Forced connection status <NUMBER> (default: Status not forced)
        //   6: Continuous transmission <BOOL> (default: true)
        // 1: Unit using intercom <OBJECT> (default: objNull)
        private _intercomStatus = [[false, INTERCOM_DISCONNECTED, INTERCOM_DEFAULT_VOLUME, false, true, false, true], objNull];

        if (_role in (_forbiddenPositions select _forEachIndex)) then {
            (_intercomStatus select 0) set [INTERCOM_STATIONSTATUS_HASINTERCOMACCESS, false];
        } else {
            if (_role in _x && {!(_role in (_forbiddenPositions select _forEachIndex))}) then {
                (_intercomStatus select 0) set [INTERCOM_STATIONSTATUS_HASINTERCOMACCESS, true];
                if ((_initialConfiguration select _forEachIndex) == 1) then {
                    (_intercomStatus select 0) set [INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_RECEIVE_AND_TRANSMIT];
                };
            };

            if (_role in (_limitedPositions select _forEachIndex)) then {
                (_intercomStatus select 0) set [INTERCOM_STATIONSTATUS_LIMITED, true];
            };

            // Handle turned out
            if ("turnedout_all" in (_forbiddenPositions select _forEachIndex) || {("turnedout" + _role) in (_forbiddenPositions select _forEachIndex)}) then {
                (_intercomStatus select 0) set [INTERCOM_STATIONSTATUS_TURNEDOUTALLOWED, false];
            };

            // Unit is configured at a later stage in order to avoid race conditions since this code is run on every machine in order to
            // reduce network traffic.
        };
        _seatConfiguration set [_forEachIndex, _intercomStatus];
    } forEach _allowedPositions;

    private _varName = QGVAR(station_);
    _varName = _varName + _role;
    _intercomStations pushBack _varName;  // List of seat variable names
    _vehicle setVariable [_varName, _seatConfiguration];
} forEach (fullCrew [_vehicle, "", true]);

_vehicle setVariable [QGVAR(intercomStations), _intercomStations, true];
