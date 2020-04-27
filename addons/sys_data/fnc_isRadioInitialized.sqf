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
 * [ARGUMENTS] call acre_sys_data_fnc_isRadioInitialized
 *
 * Public: No
 */

params ["_radioId"];

private _dataCheck = HASH_GET(GVAR(radioData),_radioId);

!isNil "_dataCheck"
