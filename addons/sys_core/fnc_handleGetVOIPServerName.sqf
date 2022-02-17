/*
 * Author: Killerswin2
 * Handler code the VOIP servername 
 *
 * Arguments:
 * 0: VOIP server name from the plugin <STRING>
 *
 * Example:
 * ["Antistasi Offical"] call acre_sys_core_fnc_handleGetVOIPServerName;
 *
 * Public: [No]
 */
#include "script_component.hpp"

params [["_serverName", "", [""]]];
GVAR(iServerName) = _serverName;