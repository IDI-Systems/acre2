#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Handler code for the VOIP server UID.
 *
 * Arguments:
 * 0: VOIP Server UID from the plugin <STRING>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * ["u24m5t67&"] call acre_sys_core_fnc_handleGetVOIPServerUID
 *
 * Public: No
 */

params [["_serverUID", "", [""]]];
GVAR(voipServerUID) = _serverUID;

true
