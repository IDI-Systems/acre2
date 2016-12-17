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

DFUNC(getClientIdLoopFunc) = {
    if (!isNull player) then {
        private _netId = netId acre_player;
        ["getClientID", [_netId, (getPlayerUID player)]] call EFUNC(sys_rpc,callRemoteProcedure);
    };
};
ADDPFH(DFUNC(getClientIdLoopFunc), 3, []);
true
