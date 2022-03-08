#include "script_component.hpp"
/*
 * Author: Killerswin2
 * Handler code for the VOIP UID.
 *
 * Arguments:
 * 0: VOIP UID from the plugin <STRING>
 *
 * Example:
 * ["u24m5t67&"] call acre_sys_core_fnc_handleGetVOIPUID
 *
 * Public: No
 */

params [["_uidName", "", [""]]];
GVAR(iUIDName) = _uidName;
