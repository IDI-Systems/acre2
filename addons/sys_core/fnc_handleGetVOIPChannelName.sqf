#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Handler code for the VOIP channel name.
 *
 * Arguments:
 * 0: VOIP Channel Name from the plugin <STRING>
 *
 * Example:
 * ["Chatroom 1"] call acre_sys_core_fnc_handleGetVOIPChannelName
 *
 * Public: No
 */

params [["_channelName", "", [""]]];
GVAR(iChannelName) = _channelName;
