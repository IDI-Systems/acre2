#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Toggles the local player's headset mode (lowered or raised). In spectator this toggles the spectator mute.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_core_fnc_toggleHeadset
 *
 * Public: No
 */

TRACE_1("enter", _this);
if (!ACRE_IS_SPECTATOR) then {
    if (GVAR(lowered) == 1) then {
        GVAR(lowered) = 0;
        [localize LSTRING(headsetRaised)] call FUNC(displayNotification);
    } else {
        GVAR(lowered) = 1;
        [localize LSTRING(headsetLowered)] call FUNC(displayNotification);
    };
} else {
    ACRE_MUTE_SPECTATORS = !ACRE_MUTE_SPECTATORS;
    ["Mute Spectators", format["Muted: %1", ACRE_MUTE_SPECTATORS], "", 1, ACRE_NOTIFICATION_PURPLE] call EFUNC(sys_list,displayHint);
};
true
