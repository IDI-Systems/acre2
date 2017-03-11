/*
 * Author: ACRE2Team
 * Generates a list of actions for passenger intercom.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_passengerIntercomChildrenActions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target"];

private _actions = [];

private _action = ["acre_connect_passengerIntercom", localize LSTRING(connectPassengerIntercom), "", {[_target, _player, 1] call FUNC(updatePassengerIntercomStatus)}, {!([_target, _player] call FUNC(unitInPassengerIntercom))}, {}, {}] call ace_interact_menu_fnc_createAction;
_actions pushBack [_action, [], _target];

private _action = ["acre_disconnect_passengerIntercom", localize LSTRING(disconnectPassengerIntercom), "", {[_target, _player, 0] call FUNC(updatePassengerIntercomStatus)}, {[_target, _player] call FUNC(unitInPassengerIntercom)}, {}, {}] call ace_interact_menu_fnc_createAction;
_actions pushBack [_action, [], _target];

_actions
