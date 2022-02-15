#include "script_component.hpp"

/*
 * Author: Killerswin2
 * Get the VOIP channel name
 *
 * Arguments:
 * None
 *
 * Return Value:
 * 0: VOIP channel name <STRING>
 *
 * Example:
 * [] call acre_api_fnc_getChannelName
 *
 * Public: Yes
 */

[] call EFUNC(sys_core,getChannelName)
