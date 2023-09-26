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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_delayFunction
 *
 * Public: No
 */

params ["_radioId", "_endFunction", "_time"];

TRACE_1("Registering a delayed function!", _this);

[{
    params ["_args"];

    _args params ["_time", "_radioId", "_function", "_funcArgs"];
    private _onState = [_radioId, "getOnOffState"] call EFUNC(sys_data,dataEvent);
    if (_onState < 0.2) then {
        [_this select 1] call CBA_fnc_removePerFrameHandler;
    };
    if (diag_tickTime > _time) then {
        [_this select 1] call CBA_fnc_removePerFrameHandler;    // Remove the PFH first, in case the function errors

        [_radioId, _funcArgs] call _function;
    };
}, 0, [diag_tickTime + _time, EGVAR(sys_radio,currentRadioDialog), _endFunction]] call CBA_fnc_addPerFrameHandler;
