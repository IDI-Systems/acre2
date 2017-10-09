/*
 * Author: ACRE2Team
 * Configures the initial intercom connectivity (not connected, connected to crew intercom, connected to pax intercom or connected to both) for all allowed seats. *
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
    private _pos = _x;
    {
        _intercomPos pushBackUnique _x;
    } forEach _pos;
} forEach _allowedPositions;

{
    // Make a hard copy of the array otherwise when modifying the array, all items in the parent array will be changed
    private _temp = [];
    private _pos = _x;
    {
        if (_pos  in (_allowedPositions select _forEachIndex)) then {
            _temp pushBack _x;
        } else {
            _temp pushBack 0;
        };

    } forEach _initialConfiguration;

    _intercomStatus pushBackUnique [_x, _temp, INTERCOM_DEFAULT_VOLUME];

    _temp = []; // Reset the array
} forEach _intercomPos;

_vehicle setVariable [QGVAR(intercomStatus), _intercomStatus, true];
