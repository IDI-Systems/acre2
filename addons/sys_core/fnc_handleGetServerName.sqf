/*
 * Author: Killerswin2
 * Handler code the VOIP servername 
 *
 * Arguments:
 * <string> VOIP server name from the plugin
 *
 * Example:
 * ["Antistasi Offical"] call acre_sys_core_fnc_handleGetServerName;
 *
 * Public: [No]
 */

params [["_serverName", "", [""]]];
GVAR(iServerName) = _serverName;