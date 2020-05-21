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
    if (IS_MUTED(acre_player)) then {
        _isMuted = 1;
    };
    if ((_isMuted != GVAR(oldMute)) || {diag_tickTime > GVAR(waitTime)}) then {
        GVAR(waitTime) = diag_tickTime + 3;
        ["localMute", (str _isMuted)] call EFUNC(sys_rpc,callRemoteProcedure);
    };

    GVAR(oldMute) = _isMuted;
}, 0, []] call CBA_fnc_addPerFrameHandler;
true
