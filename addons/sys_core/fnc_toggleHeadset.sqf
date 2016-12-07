/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

TRACE_1("enter", _this);
if (!ACRE_IS_SPECTATOR) then {
    if (GVAR(lowered) == 1) then {
        GVAR(lowered) = 0;
        hintSilent "Headset raised";
    } else {
        GVAR(lowered) = 1;
        hintSilent "Headset lowered";
    };
} else {
    ACRE_MUTE_SPECTATORS = !ACRE_MUTE_SPECTATORS;
    ["Mute Spectators",format["Muted: %1", ACRE_MUTE_SPECTATORS],"",1] call EFUNC(sys_list,displayHint);
};
true
