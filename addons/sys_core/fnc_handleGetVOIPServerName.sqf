#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Handler code for the VOIP server name.
 *
 * Arguments:
 * 0: VOIP Server Name from the plugin <STRING>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * ["Best ACRE Server"] call acre_sys_core_fnc_handleGetVOIPServerName
 *
 * Public: No
 */

params [["_serverName", "", [""]]];
GVAR(voipServerName) = _serverName;

true
