#include "script_component.hpp"

params ["_target","","_params"];
_params params ["","","","_spatial"];
private _actions  = [];

if (_spatial != "LEFT") then {
    private _action = ["acre_audio_left", "Set to Left Ear", "", {(_this + [0]) call FUNC(actionSetSpatialAudio)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};
if (_spatial != "RIGHT") then {
    private _action = ["acre_audio_right", "Set to Right Ear", "", {(_this + [1]) call FUNC(actionSetSpatialAudio)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};
if (_spatial != "CENTER") then {
    private _action = ["acre_audio_center", "Set to Both Ears", "", {(_this + [2]) call FUNC(actionSetSpatialAudio)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], _target];
};

_actions