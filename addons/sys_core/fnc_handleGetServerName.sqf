/*
 * Author: Killerswin2
 * Handler code the Team Speak servername 
 *
 * Arguments:
 * <string> teamspeak server name from the plugin
 *
 * Example:
 * ["Antistasi Offical"] call acre_sys_core_fnc_handleGetServerName;
 *
 * Public: [No]
 */

params [["_tsServerName", "", [""]]];
GVAR( teamSpeakServerName ) = _tsServerName;