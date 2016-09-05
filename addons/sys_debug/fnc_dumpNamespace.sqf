//fnc_dumpNamespace.sqf
#include "script_component.hpp"

private ["_val", "_x"];
diag_log text format["ACRE NAMESPACE DUMP ---------------------"];
{
    _val = missionNamespace getVariable _x;
    if(IS_ARRAY(_val)) then {
        diag_log text format["%1 = ARRAY(", _x];
        [_val, 0] call FUNC(dumpArray);
        diag_log text format[")"];
    } else {
        diag_log text format["%1 = %2", _x, [_val] call FUNC(formatVar)];
    };
} forEach ACRE_DEBUG_NAMESPACE;
