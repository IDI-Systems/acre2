/*
 * Author: Killerswin2
 * Handler code for the return from a rpc call about UIDs
 *
 * Arguments:
 * 0: VOIP UID name from the plugin <STRING>
 *
 * Example:
 * ["u24m5t67&"] call acre_sys_core_fnc_handleGetVOIPUID;
 *
 * Public: [No]
 */
#include "script_component.hpp"

params [["_uidName", "", [""]]];
GVAR(iUIDName) = _uidName;
