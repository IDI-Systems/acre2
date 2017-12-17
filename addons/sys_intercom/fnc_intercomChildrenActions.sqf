/*
 * Author: ACRE2Team
 * Generates a list of actions for the intercom network of a vehicle.
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
#include "script_component.hpp"

params ["_target"];

private _actions = [];

private _intercomNames = _target getVariable [QGVAR(intercomNames), []];

{
    (_intercomNames select _forEachIndex) params ["_intercomName", "_intercomDisplayName"];
    private _action = [
        format ["acre_intercom_%1", _intercomName],
        _intercomDisplayName,
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
