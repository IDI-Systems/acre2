#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Configures the initial intercom connectivity (disconnected/connected, ...) for all allowed seats.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Allowed positions <ARRAY>
 * 2: Forbidden positions <ARRAY>
 * 3: Positions with limited connectivity <ARRAY>
 * 4: Initial intercom configuration <ARRAY>
 * 5: Master station configuration <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle player, _allowedPositions, _forbiddenPositions, _initialConfiguration, _masterStation] call acre_sys_intercom_fnc_configIntercomStations
 *
 * Public: No
 */

params ["_vehicle", "_allowedPositions", "_forbiddenPositions", "_limitedPositions", "_initialConfiguration", "_masterStation"];

private _intercomStations = [];

{
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
        //   6: Voice activation active <BOOL> (default: true)
        //   7: This is a master station <BOOL> (default: false)
        // 1: Unit using intercom <OBJECT> (default: objNull)
        private _intercomStatus = [[false, INTERCOM_DISCONNECTED, INTERCOM_DEFAULT_VOLUME, false, true, false, true, false], objNull];
        private _configurationArray = _intercomStatus select 0;
        if (_role in (_forbiddenPositions select _forEachIndex)) then {
            _configurationArray set [INTERCOM_STATIONSTATUS_HASINTERCOMACCESS, false];
        } else {
            if (_role in _x && {!(_role in (_forbiddenPositions select _forEachIndex))}) then {
                _configurationArray set [INTERCOM_STATIONSTATUS_HASINTERCOMACCESS, true];
                if ((_initialConfiguration select _forEachIndex) == 1) then {
                    _configurationArray set [INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_RX_AND_TX];
                };
            };

            if (_role in (_limitedPositions select _forEachIndex)) then {
                _configurationArray set [INTERCOM_STATIONSTATUS_HASINTERCOMACCESS, true];
                _configurationArray set [INTERCOM_STATIONSTATUS_LIMITED, true];

                // Limited positions are by default configured without voice activation
                _configurationArray set [INTERCOM_STATIONSTATUS_VOICEACTIVATION, false];
            };

            // Handle turned out
            if ("turnedout_all" in (_forbiddenPositions select _forEachIndex) || {format ["turnedout_%1", _role] in (_forbiddenPositions select _forEachIndex)}) then {
                _configurationArray set [INTERCOM_STATIONSTATUS_TURNEDOUTALLOWED, false];
            };

            // Configure master station
            if (_role in (_masterStation select _forEachIndex)) then {
                _configurationArray set [INTERCOM_STATIONSTATUS_MASTERSTATION, true];
            };

            // Unit is configured at a later stage in order to avoid race conditions since this code is run on every machine in order to
            // reduce network traffic.
        };
        _seatConfiguration set [_forEachIndex, _intercomStatus];
    } forEach _allowedPositions;

    private _varname = format [QGVAR(station_%1), _role];
    _intercomStations pushBack _varName;  // List of seat variable names
    _vehicle setVariable [_varName, _seatConfiguration];
} forEach (fullCrew [_vehicle, "", true]);

_vehicle setVariable [QGVAR(intercomStations), _intercomStations, true];
