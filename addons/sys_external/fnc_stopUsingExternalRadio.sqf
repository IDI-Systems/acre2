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
 * [ARGUMENTS] call acre_sys_radio_allowExternalUse
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioID"];

[_radioId, "setState", ["isUsedExternally", [false, nil, nil]]] call EFUNC(sys_data,dataEvent);

ACRE_ACTIVE_EXTERNAL_RADIOS = ACRE_ACTIVE_EXTERNAL_RADIOS - [_radioId];
