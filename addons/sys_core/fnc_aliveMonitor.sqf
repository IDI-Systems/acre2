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
GVAR(_waitTime) = 0;
DFUNC(utility_aliveStatus) = {
    private _isMuted = 0;
    if (IS_MUTED(acre_player)) then {
        _isMuted = 1;
    };
    if ((_isMuted != GVAR(oldMute)) || (diag_tickTime > GVAR(_waitTime))) then {
        GVAR(_waitTime) = diag_tickTime + 3;
        ["localMute", (str _isMuted)] call EFUNC(sys_rpc,callRemoteProcedure);
    };

    GVAR(oldMute) = _isMuted;
};
GVAR(_waitTime) = diag_tickTime + 3;
ADDPFH(FUNC(utility_aliveStatus), 0, []);
true
