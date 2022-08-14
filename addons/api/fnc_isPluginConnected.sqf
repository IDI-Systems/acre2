#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Check if the plugin is connected.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Connected Plugin <STRING>
 *
 * Example:
 * [] call acre_api_fnc_isPluginConnected
 *
 * Public: Yes
 */

[] call EFUNC(sys_core,isPluginConnected)