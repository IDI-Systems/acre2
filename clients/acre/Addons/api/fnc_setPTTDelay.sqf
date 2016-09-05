#include "script_component.hpp"
params ["_var"];

if(!( _var isEqualType "SCALAR")) exitWith { false };

if(_var > 1 || _var < 0) exitWith { false };

ACRE_PTT_RELEASE_DELAY = _var;

true