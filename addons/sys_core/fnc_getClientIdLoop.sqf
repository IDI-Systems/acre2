#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * This function exists to setup the process for sending our object and player ID to other clients to associate with our TeamSpeak ID.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <Boolean>
 *
 * Example:
 * [] call acre_sys_core_fnc_getClientIdLoop
 *
 * Public: No
 */

DFUNC(getClientIdLoopFunc) = {
    if (!isNull player) then {
        private _netId = netId acre_player;
        ["getClientID", [_netId, (getPlayerUID player)]] call EFUNC(sys_rpc,callRemoteProcedure);
    };
};
ADDPFH(FUNC(getClientIdLoopFunc), 3, []); // Send on regular interval for JIP etc.

["unit", {[] call FUNC(getClientIdLoopFunc);}] call CBA_fnc_addPlayerEventHandler; // Use EH for immediate sending on unit transfer

true
