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

//COMPAT_diag_log format["%1", acre_sys_radio_currentRadioDialog];
if(isNil "acre_sys_radio_currentRadioDialog") then {
    _ok = createDialog QUOTE(GVAR(radioListDisplay));
    acre_sys_radio_currentRadioDialog = QUOTE(GVAR(radioList));
    [([] call EFUNC(sys_data,getPlayerRadioList))] call FUNC(populateList);
};
false
