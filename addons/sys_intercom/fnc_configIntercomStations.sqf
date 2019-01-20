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
        /* Hash has the following entries:
         * - "hasAccess": Has Intercom access <BOOL> (default: false)
         * - "connection": Connection status <NUMBER> (default: disconnected)
         * - "volume": Volume <NUMBER> (default: 1)
         * - "isLimited": This is a seat with limited connectivity <BOOL> (default: false)
         * - "turnedOutAllowed": Turned out is allowed <BOOL> (default: true)
         * - "forcedConnection": Forced connection status <NUMBER> (default: Status not forced)
         * - "voiceActivation": Voice activation active <BOOL> (default: true)
         * - "masterStation": This is a master station <BOOL> (default: false)
         * - "unit": Unit using intercom <OBJECT> (default: objNull)
         */
        private _intercomStatus = HASH_CREATE;

        // Unit is configured at a later stage in order to avoid race conditions since this code is run on every machine in order to
        // reduce network traffic.
        HASH_SET(_intercomStatus, "unit", objNull);

        HASH_SET(_intercomStatus,INTERCOM_STATIONSTATUS_VOLUME,INTERCOM_DEFAULT_VOLUME);

        private _allowed = (_role in _x || {_role in (_limitedPositions select _forEachIndex)}) && {!(_role in (_forbiddenPositions select _forEachIndex))};
        HASH_SET(_intercomStatus,INTERCOM_STATIONSTATUS_HASINTERCOMACCESS,_allowed);

        if ((_initialConfiguration select _forEachIndex) == 1) then {
            HASH_SET(_intercomStatus,INTERCOM_STATIONSTATUS_CONNECTION,INTERCOM_RX_AND_TX);
        } else {
            HASH_SET(_intercomStatus,INTERCOM_STATIONSTATUS_CONNECTION,INTERCOM_DISCONNECTED);
        };

        _allowed = _role in (_limitedPositions select _forEachIndex);
        HASH_SET(_intercomStatus,INTERCOM_STATIONSTATUS_LIMITED,_allowed);

        // Limited positions are by default configured without voice activation
        HASH_SET(_intercomStatus,INTERCOM_STATIONSTATUS_VOICEACTIVATION,!_allowed);

        // Handle turned out
        _allowed = "turnedout_all" in (_forbiddenPositions select _forEachIndex) || {format ["turnedout_%1", _role] in (_forbiddenPositions select _forEachIndex)};
        HASH_SET(_intercomStatus,INTERCOM_STATIONSTATUS_TURNEDOUTALLOWED,!_allowed);

        // Default not forced
        HASH_SET(_intercomStatus,INTERCOM_STATIONSTATUS_FORCEDCONNECTION,false);

        // Configure master station
        _allowed = _role in (_masterStation select _forEachIndex);
        HASH_SET(_intercomStatus,INTERCOM_STATIONSTATUS_MASTERSTATION,_allowed);

        _seatConfiguration set [_forEachIndex, _intercomStatus];
    } forEach _allowedPositions;

    private _varname = format [QGVAR(station_%1), _role];
    _intercomStations pushBack _varName;  // List of seat variable names
    _vehicle setVariable [_varName, _seatConfiguration];
} forEach (fullCrew [_vehicle, "", true]);

_vehicle setVariable [QGVAR(intercomStations), _intercomStations, true];
