//fnc_closeGui.sqf
#include "script_component.hpp"

[GVAR(PFHId)] call EFUNC(sys_sync,perFrame_remove);
GVAR(currentRadioId) = nil;
true
