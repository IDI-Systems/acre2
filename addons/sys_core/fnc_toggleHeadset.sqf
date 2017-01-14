/*
 * Author: ACRE2Team
 * Toggles the local player's headset mode (lowered or raised). In spectator this toggles the spectator mute.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOLEAN>
 *
 * Example:
 * [] call acre_sys_core_fnc_toggleHeadset
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
