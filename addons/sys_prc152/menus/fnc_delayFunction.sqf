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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"
private ["_fnc"];

params["_radioId", "_endFunction", "_time"];

TRACE_1("Registering a delayed function!", _this);

_fnc = {

    params["_args"];
    _args params ["_time", "_radioId", "_function", "_funcArgs"];

    _onState = [_radioId, "getOnOffState"] call EFUNC(sys_data,dataEvent);
    if(_onState < 0.2) then {
        [(_this select 1)] call EFUNC(sys_sync,perFrame_remove);
    };
    if(diag_tickTime > _time) then {
        [(_this select 1)] call EFUNC(sys_sync,perFrame_remove);    // Remove the PFH first, in case the function errors

        [_radioId, _funcArgs] call _function;
    };
};
ADDPFH(_fnc, 0, ARR_3(diag_tickTime+_time, acre_sys_radio_currentRadioDialog, _endFunction));
