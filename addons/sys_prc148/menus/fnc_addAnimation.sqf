//fnc_addAnimation.sqf
#include "script_component.hpp"

private ["_id", "_animations"];
_animations = SCRATCH_GET_DEF(GVAR(currentRadioId), "animations", []);
params["_func", "_args"];

_id = (count _animations);
_animations set[_id, [_args, _id, _func]];

