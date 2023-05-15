#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Check if the VOIP plugin is connected.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Is VOIP Plugin Connected <BOOL>
 *
 * Example:
 * [] call acre_api_fnc_isVOIPConnected
 *
 * Public: Yes
 */

EGVAR(sys_io,pipeCode) == "1" && {!EGVAR(sys_io,hasErrored) && {EGVAR(sys_io,serverStarted)}}
