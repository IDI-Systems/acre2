/*
 * Author: Killerswin2
 * Handler code for VOIP servername
 *
 * Arguments:
 * 0: VOIP channel name from the plugin <STRING>
 *
 * Example:
 * ["Chatroom 1"] call acre_sys_core_fnc_handleGetVOIPChannelName;
 *
 * Public: No
 */
#include "script_component.hpp"

params [["_channelName", "", [""]]];
GVAR(iChannelName) = _channelName;