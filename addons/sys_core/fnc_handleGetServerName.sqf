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
#include "script_component.hpp"

params [["_serverName", "", [""]]];
GVAR(iServerName) = _serverName;