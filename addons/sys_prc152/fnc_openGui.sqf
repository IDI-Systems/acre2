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

TRACE_1("OPENING GUI", _this);

disableSerialization;

GVAR(currentRadioId) = _this select 0;
createDialog "PRC152_RadioDialog";

_onState = [GVAR(currentRadioId), "getOnOffState"] call EFUNC(sys_data,dataEvent);

TRACE_2("Opening 152", GVAR(currentRadioId), _onState);

if (_onState >= 1) then {
    _currentMenu = GET_STATE_DEF("currentMenu", GVAR(VULOSHOME));
    [_currentMenu] call FUNC(changeMenu);
} else {
    //[GVAR(LOADING)] call FUNC(changeMenu);
    [GVAR(OFF)] call FUNC(changeMenu);
};

//[11, "ABCDEFGHIJKLMNOPQRSTUVWXY", ALIGN_LEFT] call FUNC(setRowText);
//[12, "YXWVUTSRQPONMLKJIHGFEDCBA", ALIGN_LEFT] call FUNC(setRowText);
//[13, "                         ", ALIGN_LEFT] call FUNC(setRowText);
//[14, "ABCDEFGHIJKLMNOPQRSTUVWXY", ALIGN_LEFT] call FUNC(setRowText);
//[15, "1234567890098765432123456", ALIGN_LEFT] call FUNC(setRowText);


//[21, "XXXXXXXXXXXXXXXXXXXXX", ALIGN_LEFT] call FUNC(setRowText);
//[22, "XXXXXXX", ALIGN_CENTER] call FUNC(setRowText);
//[23, "XXXXXXXXXXXXXXXXXXXXX", ALIGN_RIGHT] call FUNC(setRowText);
//[24, "XXXXXXXXXXXXXXXXXXXXX", ALIGN_LEFT] call FUNC(setRowText);

true
