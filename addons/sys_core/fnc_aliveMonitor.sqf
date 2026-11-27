#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * This function is used to check the conditions to mute the local player to prevent the local player from chatting.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_aliveMonitor
 *
 * Public: No
 */

GVAR(oldMute) = 0;
GVAR(waitTime) = diag_tickTime + 3;
[{
    private _isMuted = 0;
    // Also muted by the mute keybind, and while the microphone test runs so test noises aren't
    // transmitted.
    if (GVAR(micMuted) || {IS_MUTED(acre_player)} || {GVAR(micTestActive)}) then {
        _isMuted = 1;
    };
    if ((_isMuted != GVAR(oldMute)) || {diag_tickTime > GVAR(waitTime)}) then {
        GVAR(waitTime) = diag_tickTime + 3;
        ["vox:mute", [_isMuted == 1]] call EFUNC(sys_io,ext);
    };

    GVAR(oldMute) = _isMuted;
}, 0, []] call CBA_fnc_addPerFrameHandler;
true
