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

params ["_radioId"];

private _isUsedExternally = ([_radioId, "getState", "isUsedExternally"] call EFUNC(sys_data,dataEvent)) select 0;

_isUsedExternally
