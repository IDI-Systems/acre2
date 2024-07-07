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

TRACE_1("enter",_this);
if (!ACRE_IS_SPECTATOR) then {
    if (GVAR(lowered)) then {
        GVAR(lowered) = false;
        [[localize LSTRING(headsetRaised)], true] call CBA_fnc_notify;
    } else {
        GVAR(lowered) = true;
        [[localize LSTRING(headsetLowered)], true] call CBA_fnc_notify;
    };
} else {
    ACRE_MUTE_SPECTATORS = !ACRE_MUTE_SPECTATORS;
    ["acre_toggleHeadset", "Mute Spectators", format["Muted: %1", ACRE_MUTE_SPECTATORS], "", 1, EGVAR(sys_list,ToggleHeadsetColor)] call EFUNC(sys_list,displayHint);
};
true
