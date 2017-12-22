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

params ["_target", "_player", "_intercomNetwork"];
private _actions = [];

(_target getVariable [QGVAR(intercomNames), []] select _intercomNetwork) params ["_intercomName", "_intercomDisplayName"];

if ([_target, acre_player, _intercomNetwork, INTERCOM_STATIONSTATUS_HASINTERCOMACCESS] call FUNC(getStationConfiguration)) then {
    if (INTERCOM_DISCONNECTED == [_target, _player, _intercomNetwork, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration)) then {
        private _action = [
            format ["acre_connect_%1", _intercomName],
            localize LSTRING(connect),
            "",
            {
                //USES_VARIABLES ["_target", "_player"];
                params ["_target", "_player", "_intercomNetwork"];
                _intercomNetwork params ["_intercomNetwork"];

                [_target, _player, _intercomNetwork, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_RX_AND_TX] call FUNC(setStationConfiguration);
            },
            {true},
            {},
            _intercomNetwork
        ] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    } else {
        private _action = [
            format ["acre_disconnect_%1", _intercomName],
            localize LSTRING(disconnect),
            "",
            {
                 //USES_VARIABLES ["_target", "_player"];
                params ["_target", "_player", "_intercomNetwork"];
                _intercomNetwork params ["_intercomNetwork"];
                [_target, _player, _intercomNetwork, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_DISCONNECTED] call FUNC(setStationConfiguration)
            },
            {true},
            {},
            _intercomNetwork
        ] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];

        private _functionality = [_target, _player, _intercomNetwork, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration);
        switch (_functionality) do {
            case INTERCOM_DISCONNECTED: {
                WARNING_1("Entered no monitor in ace interaction menu for radio %1", _radio);
            };
            case INTERCOM_RX_ONLY: {
                _action = ["acre_trans_only", localize LSTRING(transOnly), "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_TX_ONLY] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
                _action = ["acre_rec_and_trans", localize LSTRING(recAndTrans), "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_RX_AND_TX] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
            };
            case INTERCOM_TX_ONLY: {
                _action = ["acre_rec_only", localize LSTRING(recOnly), "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_RX_ONLY] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
                _action = ["acre_rec_and_trans", localize LSTRING(recAndTrans), "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_RX_AND_TX] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
            };
            case INTERCOM_RX_AND_TX: {
                _action = ["acre_rec_only", localize LSTRING(recOnly), "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_RX_ONLY] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
                _action = ["acre_trans_only", localize LSTRING(transOnly), "", {[_target, _player, _this select 2, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_TX_ONLY] call FUNC(setStationConfiguration)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
                _actions pushBack [_action, [], _target];
            };
        };

        if ([_target, _player, _intercomNetwork, INTERCOM_STATIONSTATUS_MASTERSTATION] call FUNC(getStationConfiguration)) then {
            ((_target getVariable [QGVAR(broadcasting), [false, objNull]]) select _intercomNetwork) params ["_isBroadcasting", "_broadcastingUnit"];
            if (_isBroadcasting) then {
                _action = ["acre_stopBroadcast", localize LSTRING(stopBroadcast), "", {[_target, _player, _this select 2, false] call FUNC(handleBroadcasting)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
            } else {
                _action = ["acre_startBroadcast", localize LSTRING(startBroadcast), "", {[_target, _player, _this select 2, true] call FUNC(handleBroadcasting)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
            };
            _actions pushBack [_action, [], _target];
        };
    };
};

_actions
