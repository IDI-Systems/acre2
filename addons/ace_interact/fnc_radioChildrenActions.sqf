/*
 * Author: AUTHOR
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
_params params ["_radio","","_pttAssign"];

private _actions = [];

private _spatial = [_radio] call acre_api_fnc_getRadioSpatial;
private _txt = "Both Ears";
if (_spatial == "LEFT") then {
    _txt = "Left Ear";
};
if (_spatial == "RIGHT") then {
    _txt = "Right Ear";
};

private _action = ["acre_spatial_radio", _txt, "", {}, {true}, {_this call FUNC(generateSpatialChildrenActions);}, _params + [_spatial]] call ace_interact_menu_fnc_createAction;
_actions pushBack [_action, [], _target];
_action = ["acre_open_radio", "Open Radio", "", {[((_this select 2) select 0)] call acre_sys_radio_fnc_openRadio}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
_actions pushBack [_action, [], _target];
_action = ["acre_make_active", "Set as Active", "", {[(_this select 2) select 0] call acre_api_fnc_setCurrentRadio}, {!((_this select 2) select 1)}, {},_params] call ace_interact_menu_fnc_createAction;
_actions pushBack [_action, [], _target];

private _idx = _pttAssign find _radio;
_txt = "Bind Multi Push To Talk";
if (_idx > -1 and _idx < 3) then {
    _txt = format ["Multi Push To Talk-%1",(_idx+1)];
};

_action = ["acre_mptt_assign", _txt, "", {}, {true}, {_this call FUNC(radioPTTChildrenActions);}, _params] call ace_interact_menu_fnc_createAction;
_actions pushBack [_action, [], _target];


_actions
