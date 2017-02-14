/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target","","_params"];
_params params ["_radio"];

private _actions = [];
diag_log format ["%1", _target];

private _action = ["acre_use_externalRadio", localize LSTRING(takeTransmitter), "", {[(_this select 2) select 0, _target, acre_player] call EFUNC(sys_external,startUsingExternalRadio)}, {!([(_this select 2) select 0] call EFUNC(sys_external,isExternalRadioUsed))}, {}, _params] call ace_interact_menu_fnc_createAction;
_actions pushBack [_action, [], _target];
private _action = ["acre_return_externalRadio", localize LSTRING(releaseTransmitter), "", {[(_this select 2) select 0] call EFUNC(sys_external,stopUsingExternalRadio)}, {[(_this select 2) select 0] call EFUNC(sys_external,isExternalRadioUsed)}, {}, _params] call ace_interact_menu_fnc_createAction;
_actions pushBack [_action, [], _target];

_actions
