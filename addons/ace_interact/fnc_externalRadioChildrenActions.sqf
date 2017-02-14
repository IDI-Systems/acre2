/*
 * Author: ACRE2Team
 * Generates a list of actions for using a radio externaly
 *
 * Arguments:
 * 0: Unit with a shared radio <OBJECT>
 * 1: None <TYPE>
 * 2: Array with additional parameters: unique radio ID <ARRAY>
 *
 * Return Value:
 * Array of actions <ARRAY>
 *
 * Example:
 * [cursorTarget, "", ["ACRE_PRC343_ID_1"]] call acre_ace_interact_fnc_externalRadioChildrenActions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target","","_params"];
_params params ["_radio"];

private _actions = [];

private _action = ["acre_use_externalRadio", localize LSTRING(takeHeadset), "", {[(_this select 2) select 0, _target, acre_player] call EFUNC(sys_external,startUsingExternalRadio)}, {!([(_this select 2) select 0] call EFUNC(sys_external,isExternalRadioUsed))}, {}, _params] call ace_interact_menu_fnc_createAction;
_actions pushBack [_action, [], _target];

// Check if we are giving or returning the headset
if ([(_this select 2) select 0, _target] call FUNC(externalRadioCheckReturnGive)) then {
    private _action = ["acre_return_externalRadio", localize LSTRING(returnHeadset), "", {[(_this select 2) select 0, _target] call EFUNC(sys_external,stopUsingExternalRadio)}, {[(_this select 2) select 0] call EFUNC(sys_external,isExternalRadioUsed)}, {}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
} else {
    private _action = ["acre_give_externalRadio", localize LSTRING(giveHeadset), "", {[(_this select 2) select 0, _target] call EFUNC(sys_external,stopUsingExternalRadio)}, {[(_this select 2) select 0] call EFUNC(sys_external,isExternalRadioUsed)}, {}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
