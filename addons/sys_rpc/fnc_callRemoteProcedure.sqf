/*
 * Author: ACRE2Team
 * Calls a procedure in the teamspeak plugin.
 *
 * Arguments:
 * 0: Procedure name <STRING>
 * 1: Arguments <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["getPluginVersion", ","] call acre_sys_rpc_fnc_callRemoteProcedure
 *
 * Public: No
 */

#include "script_component.hpp"

params ["_name","_params"];

if (IS_ARRAY(_params)) then {
    private _array = _params apply {
        private _element = _x;
        if (IS_ARRAY(_element)) then {
            (_element apply {
                [_x, parseNumber _x] select (IS_BOOL(_x));
            }) joinString ",";
        } else {
            [_element, parseNumber _element] select (IS_BOOL(_element));
        };
    };
    if (count _array > 0) then { _array pushBack ""; }; //Add empty element to add a trailing comma
    _params = _array joinString ",";
};
private _data = _name + ":" + _params;
TRACE_1("sendMessage ", _data);
_data call EFUNC(sys_io,sendMessage);
