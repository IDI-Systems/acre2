/*
 * Author: Killerswin2
 * calls the rpc associated to the VOIP server info.
 *
 * Arguments:
 *  <none>
 *
 * Return:
 *  <none>
 *
 * Example:
 * [] call acre_sys_core_fnc_updateServerInfo;
 *
 * Public: no
 */

["getServerName", ","] call acre_sys_rpc_fnc_callRemoteProcedure;
["getChannelName", ","] call acre_sys_rpc_fnc_callRemoteProcedure;
["getUID", ","] call acre_sys_rpc_fnc_callRemoteProcedure;
