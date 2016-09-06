/*
 * Author: AUTHOR
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

#include "script_component.hpp"

TRACE_1("", _this);

params ["_radioId", "_functionName", "_args"];

private _sargs = [_radioId] + _args;
private _run = format["_this call CALLSTACK(acre_sys_radio_base_fnc_)%1", _functionName];
private _go = compile _run;
private _ret = _sargs call CALLSTACK(_go);

_ret
