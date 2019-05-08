#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Generates a list of the intercom networks of a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_intercomChildrenActions
 *
 * Public: No
 */

params ["_target"];

private _actions = [];

private _intercomNames = _target getVariable [QGVAR(intercomNames), []];

{
    (_intercomNames select _forEachIndex) params ["_intercomName", "", "_intercomShortName"];
    private _action = [
        format [QGVAR(_intercom_%1), _intercomName],
        _intercomShortName,
        "",
        {true},
        {
            //USES_VARIABLES ["_target", "_player"];
            params ["_target", "_player", "_params"];
            _params params ["_intercomNetwork"];
            [_target, _player, _intercomNetwork, INTERCOM_STATIONSTATUS_HASINTERCOMACCESS] call FUNC(getStationConfiguration)
        },
        {_this call FUNC(intercomListChildrenActions)},
        _forEachIndex
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
} forEach _intercomNames;

_actions
