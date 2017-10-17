/*
 * Author: ACRE2Team
 * Configures the initial intercom connectivity (disconnected/connected) for all allowed seats.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
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

params ["_vehicle"];

private _type = typeOf _vehicle;

private _intercomStatus = [];
private _intercomPos = [];

private _allowedPositions = _vehicle getVariable[QGVAR(allowedPositions), []];
private _initialConfiguration = +(_vehicle getVariable[QGVAR(connectByDefault), []]);

{
    {
        _intercomPos pushBackUnique _x;
    } forEach _x; // position
} forEach _allowedPositions;

{
    // Make a hard copy of the array otherwise when modifying the array, all items in the parent array will be changed
    private _stationConnected = [];
    private _pos = _x;
    {
        if (_pos in (_allowedPositions select _forEachIndex)) then {
            _stationConnected pushBack _x;
        } else {
            _stationConnected pushBack 0;
        };

    } forEach _initialConfiguration;

    _intercomStatus pushBackUnique [_x, _stationConnected, INTERCOM_DEFAULT_VOLUME];

    _stationConnected = []; // Reset the array
} forEach _intercomPos;

_vehicle setVariable [QGVAR(intercomStatus), _intercomStatus, true];
