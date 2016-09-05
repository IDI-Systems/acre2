//fnc_getClientIdLoop.sqf
#include "script_component.hpp"

DFUNC(getClientIdLoopFunc) = {
    if(!isNull player) then {
        private _netId = netId acre_player;
        ["getClientID", [_netId, (getPlayerUID player)]] call EFUNC(sys_rpc,callRemoteProcedure);
    };
};
ADDPFH(DFUNC(getClientIdLoopFunc), 3, []);
true
