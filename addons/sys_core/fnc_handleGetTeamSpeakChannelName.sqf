/*
 * Author: Killerswin2
 * Handler code for Team Speak servername
 *
 * Arguments:
 * <string> teamspeak channel name from the plugin
 *
 * Example:
 * [] call acre_enf_fnc_getTeamSpeakChannelName;
 *
 * Public: [No]
 */
params [["_tsChannelName", "", [""]]];
GVAR( teamSpeakChannelName ) = _tsChannelName;