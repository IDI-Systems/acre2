#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Handler code for the VOIP channel UID.
 *
 * Arguments:
 * 0: VOIP Channel UID from the plugin <STRING>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * ["53!%wexg35"] call acre_sys_core_fnc_handleGetVOIPChannelUID
 *
 * Public: No
 */

params [["_channelUID", "", [""]]];
GVAR(voipChannelUID) = _channelUID;

true
