//fnc_removeAnimation.sqf
#include "script_component.hpp"

private ["_animations", "_id"];
_id = _this select 0;
_animations set[_id, []];
