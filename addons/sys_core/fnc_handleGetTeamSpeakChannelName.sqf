/*
 * Author: Killerswin2
 * Handler code for Team Speak servername
 *
 * Arguments:
 * <string> teamspeak channel name from the plugin
 *
 * Example:
 * ["Chatroom 1"] call acre_sys_core_fnc_handleGetTeamSpeakChannelName;
 *
 * Public: [No]
 */
params [["_tsChannelName", "", [""]]];
GVAR( teamSpeakChannelName ) = _tsChannelName;