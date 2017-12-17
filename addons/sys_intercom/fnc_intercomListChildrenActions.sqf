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
 * [cursorTarget] call acre_sys_intercom_fnc_intercomListchildrenActions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target"];
private _actions = [];

private _intercomNames = _target getVariable [QGVAR(intercomNames), []];

{
    private _intercomDisplayName = (_intercomNames select _forEachIndex) select 1;
    if ([_target, acre_player, _forEachIndex, INTERCOM_STATIONSTATUS_HASINTERCOMACCESS] call FUNC(getStationConfiguration)) then {
        private _action = [
            format ["acre_connect_%1", _x],
            format [localize LSTRING(connect), "(" + _intercomDisplayName + ")"],
            "",
            {
                //USES_VARIABLES ["_target", "_player"];
                params ["_target", "_player", "_params"];
                _params params ["_intercomNetwork"];

                [_target, _player, _intercomNetwork, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_RECEIVE_AND_TRANSMIT] call FUNC(setStationConfiguration);
            },
            {
                //USES_VARIABLES ["_target", "_player"];
                params ["_target", "_player", "_params"];
                _params params ["_intercomNetwork"];
                INTERCOM_DISCONNECTED == [_target, _player, _intercomNetwork, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration)
            },
            {},
            _forEachIndex
        ] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];

        _action = [
            format ["acre_disconnect_%1", _x],
            format [localize LSTRING(disconnect), "(" + _intercomDisplayName + ")"],
            "",
            {
                 //USES_VARIABLES ["_target", "_player"];
                params ["_target", "_player", "_params"];
                _params params ["_intercomNetwork"];
                [_target, _player, _intercomNetwork, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_DISCONNECTED] call FUNC(setStationConfiguration)
            },
            {
                //USES_VARIABLES ["_target", "_player"];
                params ["_target", "_player", "_params"];
                _params params ["_intercomNetwork"];
                INTERCOM_DISCONNECTED < [_target, _player, _intercomNetwork, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration)
            },
            {},
            _forEachIndex
        ] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
} forEach _intercomNames;

_actions
