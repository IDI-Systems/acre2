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

params ["_target", "", "_params"];
_params params ["_radioID", "", "", "_spatial"];

private _actions  = [];

if (_spatial != "RIGHT") then {
    private _action = ["acre_audio_right", localize ELSTRING(sys_core,switchRadioEarRight), "", {(_this select 2) call EFUNC(sys_core,switchRadioEar)}, {true}, {}, [1, _radioID]] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};
if (_spatial != "CENTER") then {
    private _action = ["acre_audio_center", localize ELSTRING(sys_core,switchRadioEarBoth), "", {(_this select 2) call EFUNC(sys_core,switchRadioEar)}, {true}, {}, [0, _radioID]] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};
if (_spatial != "LEFT") then {
    private _action = ["acre_audio_left", localize ELSTRING(sys_core,switchRadioEarLeft), "", {(_this select 2) call EFUNC(sys_core,switchRadioEar)}, {true}, {}, [-1, _radioID]] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
