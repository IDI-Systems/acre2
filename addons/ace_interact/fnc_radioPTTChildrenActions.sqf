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
_params params ["_radio", "", "_pttAssign"];

private _actions = [];
private _idx = _pttAssign find _radio;

if (_idx != 0) then {
    private _action = ["acre_mptt_assign1", format [localize LSTRING(setAsMultiPTT), 1], "", {(_this + [0]) call FUNC(actionSetMTT)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};
if (count _pttAssign > 1 and _idx != 1) then {
    private _action = ["acre_mptt_assign2", format [localize LSTRING(setAsMultiPTT), 2], "", {(_this + [1]) call FUNC(actionSetMTT)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};
if (count _pttAssign > 2 and _idx != 2) then {
    private _action = ["acre_mptt_assign3", format [localize LSTRING(setAsMultiPTT), 3], "", {(_this + [2]) call FUNC(actionSetMTT)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
