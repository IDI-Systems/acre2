//fnc_handlePTTDown.sqf
#include "script_component.hpp"

private ["_volume"];
params ["_radioId"];

_volume = [_radioId, "getVolume"] call EFUNC(sys_data,dataEvent);
[_radioId, "Acre_GenericBeep", [0,0,0], [0,1,0], _volume] call EFUNC(sys_radio,playRadioSound);
SCRATCH_SET(_radioId, "PTTDown", true);
true;