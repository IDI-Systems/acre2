#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Calls the RPC associated to the VOIP info.
 *
 * Arguments:
 * None
 *
 * Return:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_updateVOIPInfo
 *
 * Public: No
 */

["getPluginVersion", ","] call EFUNC(sys_rpc,callRemoteProcedure);

["getVOIPChannelName", ""] call EFUNC(sys_rpc,callRemoteProcedure);
["getVOIPChannelUID", ""] call EFUNC(sys_rpc,callRemoteProcedure);
["getVOIPServerName", ""] call EFUNC(sys_rpc,callRemoteProcedure);
["getVOIPServerUID", ""] call EFUNC(sys_rpc,callRemoteProcedure);
