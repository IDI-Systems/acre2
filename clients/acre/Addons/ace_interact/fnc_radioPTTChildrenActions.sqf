#include "script_component.hpp"

params ["_target","","_params"];
_params params ["_radio","","_pttAssign"];

private _actions  = [];
private _idx = _pttAssign find _radio;

if (_idx != 0) then {
	_action = ["acre_mptt_assign1", "Set as Multi PTT 1", "", {(_this + [0]) call FUNC(actionSetMTT)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], _target];
};
if (count _pttAssign > 1 and _idx != 1) then {
	_action = ["acre_mptt_assign2", "Set as Multi PTT 2", "", {(_this + [1]) call FUNC(actionSetMTT)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], _target];
};
if (count _pttAssign > 2 and _idx != 2) then {
	_action = ["acre_mptt_assign3", "Set as Multi PTT 3", "", {(_this + [2]) call FUNC(actionSetMTT)}, {true}, {}, _params] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], _target];
};

_actions