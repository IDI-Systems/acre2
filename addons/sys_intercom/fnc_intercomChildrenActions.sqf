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

if ([_target, acre_player, CREW_INTERCOM] call FUNC(isIntercomAvailable)) then {
    private _action = [
        "acre_connect_crewIntercom",
        format [localize LSTRING(connect), "(" + localize CREW_STRING + ")"],
        "",
        {
            //USES_VARIABLES ["_target", "_player"];
            [_target, _player, 1] call FUNC(updateCrewIntercomStatus)
        },
        {
            //USES_VARIABLES ["_target", "_player"];
            !([_target, _player] call FUNC(isInCrewIntercom))
        },
        {},
        {}
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];

    _action = [
        "acre_disconnect_crewIntercom",
        format [localize LSTRING(disconnect), "(" + localize CREW_STRING + ")"],
        "",
        {
            //USES_VARIABLES ["_target", "_player"];
            [_target, _player, 0] call FUNC(updateCrewIntercomStatus)
        },
        {
            //USES_VARIABLES ["_target", "_player"];
            [_target, _player] call FUNC(isInCrewIntercom)
        },
        {},
        {}
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

if ([_target, acre_player, PASSENGER_INTERCOM] call FUNC(isIntercomAvailable)) then {
    private _action = [
        "acre_connect_passengerIntercom",
        format [localize LSTRING(connect), "(" + localize LSTRING(passenger) + ")"],
        "",
        {
            //USES_VARIABLES ["_target", "_player"];
            [_target, _player, 1] call FUNC(updatePassengerIntercomStatus)
        },
        {
            //USES_VARIABLES ["_target", "_player"];
            !([_target, _player] call FUNC(isInPassengerIntercom))
        },
        {},
        {}
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];

    _action = [
        "acre_disconnect_passengerIntercom",
        format [localize LSTRING(disconnect), "(" + localize LSTRING(passenger) + ")"],
        "",
        {
            //USES_VARIABLES ["_target", "_player"];
            [_target, _player, 0] call FUNC(updatePassengerIntercomStatus)
        },
        {
            //USES_VARIABLES ["_target", "_player"];
            [_target, _player] call FUNC(isInPassengerIntercom)
        },
        {},
        {}
    ] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
