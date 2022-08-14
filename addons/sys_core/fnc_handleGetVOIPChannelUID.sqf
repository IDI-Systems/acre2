#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Handler code for the VOIP channel UID.
 *
 * Arguments:
 * 0: VOIP Channel UID from the plugin <STRING>
 *
 * Example:
 * ["Chatroom 1"] call acre_sys_core_fnc_handleGetVOIPChannelUID
 *
 * Public: No
 */

params [["_channelUID", "", [""]]];
GVAR(iChannelUID) = _channelUID;