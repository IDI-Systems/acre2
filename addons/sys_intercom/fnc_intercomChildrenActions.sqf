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
 * [cursorTarget] call acre_sys_intercom_fnc_childrenActions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target"];
private _actions = [];

private _intercomNames = _target getVariable [QGVAR(intercomNames), []];
private _intercomDisplayNames = _target getVariable [QGVAR(intercomDisplayNames), []];
systemChat format ["numIntercoms %1: %2", count _intercomNames, _intercomDisplayNames];
{
    if ([_target, acre_player, _forEachIndex] call FUNC(isIntercomAvailable)) then {
        private _action = [
            format ["acre_connect_%1", _x],
            format [localize LSTRING(connect), "(" + (_intercomDisplayNames select _forEachIndex) + ")"],
            "",
            {
                //USES_VARIABLES ["_target", "_player"];
                params ["_target", "_player", "_params"];
                _params params ["_intercomNetwork"];

                [_target, _player, _intercomNetwork, INTERCOM_CONNECTED] call FUNC(setSeatConnectionStatus)
            },
            {
                //USES_VARIABLES ["_target", "_player"];
                params ["_target", "_player", "_params"];
                _params params ["_intercomNetwork"];
                !([_target, _player, _intercomNetwork] call FUNC(isInIntercom))
            },
            {},
            _forEachIndex
        ] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];

        _action = [
            format ["acre_disconnect_%1", _x],
            format [localize LSTRING(disconnect), "(" + (_intercomDisplayNames select _forEachIndex) + ")"],
            "",
            {
                 //USES_VARIABLES ["_target", "_player"];
                params ["_target", "_player", "_params"];
                _params params ["_intercomNetwork"];

                [_target, _player, _intercomNetwork, INTERCOM_DISCONNECTED] call FUNC(setSeatConnectionStatus)
            },
            {
                //USES_VARIABLES ["_target", "_player"];
                params ["_target", "_player", "_params"];
                _params params ["_intercomNetwork"];
                ([_target, _player, _intercomNetwork] call FUNC(isInIntercom))
            },
            {},
            _forEachIndex
        ] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
} forEach _intercomNames;

_actions
