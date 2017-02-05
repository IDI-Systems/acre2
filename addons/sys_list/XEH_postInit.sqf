#include "script_component.hpp"
NO_DEDICATED;
LOG("ADDING KEY HANDLERS FOR LIST");

["ACRE2", "CycleRadio", (localize LSTRING(CycleRadio)), { [1] call FUNC(cycleRadios) }, "", [58, [true, false, true]]] call cba_fnc_addKeybind;
["ACRE2", "OpenRadio", (localize LSTRING(OpenRadio)), { [ACRE_ACTIVE_RADIO] call EFUNC(sys_radio,openRadio); false }, "", [58, [false, true, true]]] call cba_fnc_addKeybind;
