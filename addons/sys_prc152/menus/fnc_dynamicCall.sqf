#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
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
 * [ARGUMENTS] call acre_sys_prc152_fnc_dynamicCall
 *
 * Public: No
 */

TRACE_1("dynamicCall",_this);
private ["_ret"];
params ["_funcName", "_var"];

if (_funcName isEqualType "") then {
    private _func = missionNamespace getVariable format["%1_fnc_%2", QUOTE(ADDON), _funcName];
    _ret = _var call CALLSTACK_NAMED(_func,_funcName);
} else {
    if (_funcName isEqualType {}) then {
        // Calling code
        _ret = _var call CALLSTACK(_funcName);
    };
};

if (isNil "_ret") then {
    nil
};

_ret
