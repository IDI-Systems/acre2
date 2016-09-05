//#define DEBUG_MODE_FULL 

#include "script_component.hpp"

params["_player", "_unit", "_revealAmount"];

TRACE_1("onRevealUnit", _this);

if(!local _unit) exitWith { false };

_unit reveal [_player, _revealAmount];

true