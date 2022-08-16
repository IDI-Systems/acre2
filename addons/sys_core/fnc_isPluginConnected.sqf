#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Check if the plugin is connected.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Plugin is connected <BOOL>
 *
 * Example:
 * [] call acre_sys_core_fnc_isPluginConnected
 *
 * Public: No
 */

// check that server started, no pipe errors, and no generally errors in io
GVAR(connectedPlugin) = (EGVAR(sys_io,pipeCode) == "1" && !EGVAR(sys_io,hasErrored) && EGVAR(sys_io,serverStarted));

GVAR(connectedPlugin)