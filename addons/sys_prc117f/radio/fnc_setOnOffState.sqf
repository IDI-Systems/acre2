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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_setOnOffState
 *
 * Public: No
 */

params ["", "", "_eventData", "_radioData"];

HASH_SET(_radioData, "radioOn", _eventData);
/*if (_radioId == acre_sys_radio_currentRadioDialog) then {
    if (_eventData == 0) then {

    } else {

    };
};*/
