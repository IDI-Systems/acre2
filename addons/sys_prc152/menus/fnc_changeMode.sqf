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
 * [ARGUMENTS] call acre_sys_prc152_fnc_changeMode
 *
 * Public: No
 */

TRACE_1("changeMode", _this);

private _knobPosition = GET_STATE_DEF("knobPosition", 1);

if (_knobPosition == 0) then {
    TRACE_2("Turning radio off!", _knobPosition, GVAR(currentRadioId));
    [GVAR(currentRadioId), "setOnOffState", 0] call EFUNC(sys_data,dataEvent);
    private _onOffState = [GVAR(currentRadioId), "getOnOffState"] call EFUNC(sys_data,dataEvent);
    TRACE_1("TEST", _onOffState);
    [GVAR(OFF)] call FUNC(changeMenu);
} else {
    private _onOffState = [GVAR(currentRadioId), "getOnOffState"] call EFUNC(sys_data,dataEvent);
    TRACE_2("State", _knobPosition, _onOffState);
    if (_onOffState >= 1) then {
        ["setCurrentChannel", _knobPosition - 1] call GUI_DATA_EVENT;
        private _currentMenu = GET_STATE_DEF("currentHome", GVAR(VULOSHOME));
        [_currentMenu] call FUNC(renderMenu);
    } else {
        if (_onOffState == 0) then {
            [GVAR(currentRadioId), "setOnOffState", 0.2] call EFUNC(sys_data,dataEvent);
            [GVAR(LOADING)] call FUNC(changeMenu);
        };
    };
};
