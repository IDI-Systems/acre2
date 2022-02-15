/*
 * Author: Killerswin2
 * Handler code for the return from a rpc call about UIDs
 *
 * Arguments:
 * <string> VOIP UID name from the plugin
 *
 * Example:
 * ["u24m5t67&"] call acre_sys_core_fnc_handleGetUID;
 *
 * Public: [No]
 */

params [["_uidName", "", [""]]];
GVAR(iUIDName) = _uidName;
