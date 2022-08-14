#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Calls the RPC associated to the VOIP server info.
 *
 * Arguments:
 * None
 *
 * Return:
 *  <none>
 *
 * Example:
 * [] call acre_sys_core_fnc_updateServerInfo
 *
 * Public: No
 */

["getPluginVersion", ","] call EFUNC(sys_rpc,callRemoteProcedure);
["getVOIPServerName", ""] call EFUNC(sys_rpc,callRemoteProcedure);
["getVOIPChannelName", ""] call EFUNC(sys_rpc,callRemoteProcedure);
["getVOIPChannelUID", ""] call EFUNC(sys_rpc,callRemoteProcedure);
["getVOIPUID", ""] call EFUNC(sys_rpc,callRemoteProcedure);
