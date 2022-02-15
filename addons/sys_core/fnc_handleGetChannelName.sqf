/*
 * Author: Killerswin2
 * Handler code for VOIP servername
 *
 * Arguments:
 * <string> VOIP channel name from the plugin
 *
 * Example:
 * ["Chatroom 1"] call acre_sys_core_fnc_handleGetChannelName;
 *
 * Public: [No]
 */
#include "script_component.hpp"

params [["_channelName", "", [""]]];
GVAR(iChannelName) = _channelName;