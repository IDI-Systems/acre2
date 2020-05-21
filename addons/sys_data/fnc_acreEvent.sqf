#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_data_fnc_acreEvent
 *
 * Public: No
 */

TRACE_1("ACRE DATA EVENT",_this);
private _return = nil;

private _systemReturn = _this call FUNC(processSysEvent);
private _radioReturn = _this call FUNC(processRadioEvent);

TRACE_2("ACRE DATA EVENT RETURN",_systemReturn,_radioReturn);
if (isNil "_radioReturn" && {!isNil "_systemReturn"}) then {
    _return = _systemReturn;
} else {
    if (!isNil "_radioReturn") then {
        _return = _radioReturn;
    };
};

if (isNil "_return") exitWith { nil };
_return
