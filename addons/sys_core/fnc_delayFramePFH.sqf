//fnc_delayFramePFH.sqf
#include "script_component.hpp"

params ["_params"];
_params params ["_function", "_parameters", "_frameNo"];

if(_frameNo != diag_frameNo) then {
    _parameters call _function;
    [(_this select 1)] call EFUNC(sys_sync,perFrame_remove);
};
