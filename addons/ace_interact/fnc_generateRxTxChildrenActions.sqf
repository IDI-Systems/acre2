#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Generates actions for controlling the spatial set-up of a radio
 *
 * Arguments:
 * 0: Unit with a radio <OBJECT>
 * 1: None <TYPE>
 * 2: Array with additional parameters: unused, unused, unused, current spatial configuration <ARRAY>
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [acre_player, "", ["", "", "", "LEFT"]] call acre_ace_interact_fnc_externalRadioVehicleListChildrenActions
 *
 * Public: No
 */

params ["_target", "", "_params"];
_params params ["_radioID", "", "", "_functionality"];

private _actions  = [];

switch (_functionality) do {
    case RACK_RX_ONLY: {
        private _action = [QGVAR(txOnly), localize ELSTRING(sys_intercom,transOnly), "", {[(_this select 2) select 0, vehicle acre_player, acre_player, RACK_TX_ONLY] call EFUNC(sys_intercom,setRackRxTxCapabilities)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
        _action = [QGVAR(rxAndTx), localize ELSTRING(sys_intercom,recAndTrans), "", {[(_this select 2) select 0, vehicle acre_player, acre_player, RACK_RX_AND_TX] call EFUNC(sys_intercom,setRackRxTxCapabilities)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
    case RACK_TX_ONLY: {
        private _action = [QGVAR(rxOnly), localize ELSTRING(sys_intercom,recOnly), "", {[(_this select 2) select 0, vehicle acre_player, acre_player, RACK_RX_ONLY] call EFUNC(sys_intercom,setRackRxTxCapabilities)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
        _action = [QGVAR(rxAndTx), localize ELSTRING(sys_intercom,recAndTrans), "", {[(_this select 2) select 0, vehicle acre_player, acre_player, RACK_RX_AND_TX] call EFUNC(sys_intercom,setRackRxTxCapabilities)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
    case RACK_RX_AND_TX: {
        private _action = [QGVAR(rxOnly), localize ELSTRING(sys_intercom,recOnly), "", {[(_this select 2) select 0, vehicle acre_player, acre_player, RACK_RX_ONLY] call EFUNC(sys_intercom,setRackRxTxCapabilities)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
        _action = [QGVAR(txOnly), localize ELSTRING(sys_intercom,transOnly), "", {[(_this select 2) select 0, vehicle acre_player, acre_player, RACK_TX_ONLY] call EFUNC(sys_intercom,setRackRxTxCapabilities)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action, [], _target];
    };
};

_actions
