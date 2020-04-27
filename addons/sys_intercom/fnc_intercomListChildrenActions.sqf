#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Generates a list of actions for the intercom network of a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Intercom network <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_intercomListChildrenActions
 *
 * Public: No
 */

params ["_target", "_player", "_intercomNetwork"];
private _actions = [];

// Params _intercomNames and _intercomDisplayNames
(_target getVariable [QGVAR(intercomNames), []] select _intercomNetwork) params ["_intercomName", ""];

if ([_target, acre_player, _intercomNetwork, INTERCOM_STATIONSTATUS_HASINTERCOMACCESS] call FUNC(getStationConfiguration)) then {
    if (INTERCOM_DISCONNECTED == [_target, _player, _intercomNetwork, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration)) then {
        private _action = [
            format [QGVAR(connect_%1), _intercomName],
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
            format [QGVAR(open_%1), _intercomName],
            localize LSTRING(open),
            "",
            {
                 //USES_VARIABLES ["_target", "_player"];
                params ["", "", "_intercomNetwork"];
                _intercomNetwork params ["_intercomNetwork"];
                [_intercomNetwork, false] call FUNC(openGui);
            },
            {true},
            {},
            _intercomNetwork
        ] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];

        _action = [
            format [QGVAR(disconnect_%1), _intercomName],
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

        if ([_target, _player, _intercomNetwork, INTERCOM_STATIONSTATUS_MASTERSTATION] call FUNC(getStationConfiguration)) then {
            // Params _isBroadcasting, _broadcastingUnit
            ((_target getVariable [QGVAR(broadcasting), [false, objNull]]) select _intercomNetwork) params ["_isBroadcasting", ""];
            if (_isBroadcasting) then {
                _action = [QGVAR(stopBroadcast), localize LSTRING(stopBroadcast), "", {[_target, _player, _this select 2, false] call FUNC(handleBroadcasting)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
            } else {
                _action = [QGVAR(acre_startBroadcast), localize LSTRING(startBroadcast), "", {[_target, _player, _this select 2, true] call FUNC(handleBroadcasting)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
            };
            _actions pushBack [_action, [], _target];

            private _accentActive = (_target getVariable [QGVAR(accent), [false]]) select _intercomNetwork;
            if (_accentActive) then {
                _action = [QGVAR(deactivateAccent), localize LSTRING(deactivateAccent), "", {[_target, _this select 2, false] call FUNC(handleAccent)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
            } else {
                _action = [QGVAR(activateAccent), localize LSTRING(activateAccent), "", {[_target, _this select 2, true] call FUNC(handleAccent)}, {true}, {}, _intercomNetwork] call ace_interact_menu_fnc_createAction;
            };
            _actions pushBack [_action, [], _target];
        };
    };
};

_actions
