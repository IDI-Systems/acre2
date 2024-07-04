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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_changeMode
 *
 * Public: No
 */

TRACE_1("changeMode",_this);

private _mode = GET_STATE_DEF("knobPosition",1);

if (_mode == 0) then {
    TRACE_2("Turning radio off!",_mode,GVAR(currentRadioId));
    [GVAR(currentRadioId), "setOnOffState", 0] call EFUNC(sys_data,dataEvent);
    private _onOffState = [GVAR(currentRadioId), "getOnOffState"] call EFUNC(sys_data,dataEvent);
    TRACE_1("TEST",_onOffState);
    [GVAR(OFF)] call FUNC(changeMenu);
} else {
    private _onOffState = [GVAR(currentRadioId), "getOnOffState"] call EFUNC(sys_data,dataEvent);
    TRACE_2("State",_mode,_onOffState);
    if (_onOffState >= 1) then {
        switch _mode do {
            case 1: {
                [GVAR(VULOSHOME)] call FUNC(changeMenu);
            };
            default {
                [GVAR(INVALID_MODE)] call FUNC(changeMenu);
            };
        };
    } else {
        if (_onOffState == 0) then {
            [GVAR(currentRadioId), "setOnOffState", 0.2] call EFUNC(sys_data,dataEvent);
            [GVAR(LOADING)] call FUNC(changeMenu);
        };
    };
};
