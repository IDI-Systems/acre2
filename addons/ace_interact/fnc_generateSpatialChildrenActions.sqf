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
_params params ["","","","_spatial"];
private _actions  = [];

if (_spatial != "RIGHT") then {
    private _action = ["acre_audio_right", localize LSTRING(setToRightEar), "", {(_this + [1]) call FUNC(actionSetSpatialAudio)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};
if (_spatial != "CENTER") then {
    private _action = ["acre_audio_center", localize LSTRING(setToBothEars), "", {(_this + [2]) call FUNC(actionSetSpatialAudio)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};
if (_spatial != "LEFT") then {
    private _action = ["acre_audio_left", localize LSTRING(setToLeftEar), "", {(_this + [0]) call FUNC(actionSetSpatialAudio)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions
