/*
 * Author: ACRE2Team
 * Generates a list of modes for the intercom network of a vehicle: receive, transmit or receive and transmit.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Arguments <ARRAY>
 *   0: Intercon Network <NUMBER>
 *   1: Functionality <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_intercomListRxTxActions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target", "_player", "_args"];
_args params ["_intercomNetwork", "_functionality"];

private _actions = [];
switch (_functionality) do {
    case INTERCOM_DISCONNECTED: {
        WARNING_1("Entered no monitor in ace interaction menu for radio %1", _radio);
    };
    case INTERCOM_RX_ONLY: {
        private _action = ["acre_trans_only", localize LSTRING(transOnly), "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_TX_ONLY] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
        _action = ["acre_rec_and_trans", localize LSTRING(recAndTrans), "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_RX_AND_TX] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
    case INTERCOM_TX_ONLY: {
        private _action = ["acre_rec_only", localize LSTRING(recOnly), "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_RX_ONLY] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
        _action = ["acre_rec_and_trans", localize LSTRING(recAndTrans), "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_RX_AND_TX] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
    case INTERCOM_RX_AND_TX: {
        private _action = ["acre_rec_only", localize LSTRING(recOnly), "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_RX_ONLY] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
        _action = ["acre_trans_only", localize LSTRING(transOnly), "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_TX_ONLY] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
};

_actions
