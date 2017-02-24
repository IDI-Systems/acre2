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
#include "script_component.hpp"

params ["_target", "", "_params"];
_params params ["", "", "", "_spatial"];
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
