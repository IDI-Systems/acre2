#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Get the VOIP channel name.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * VOIP Channel Name <STRING>
 *
 * Example:
 * [] call acre_api_fnc_getVOIPChannelName
 *
 * Public: Yes
 */

[] call EFUNC(sys_core,getVOIPChannelName)
