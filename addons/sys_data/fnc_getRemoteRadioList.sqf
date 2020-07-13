#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the a list of radio IDs that the given unit has.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Radio ID List <ARRAY>
 *
 * Example:
 * [_unit] call acre_sys_data_fnc_getRemoteRadioList
 *
 * Public: No
 */

params ["_unit"];

_unit getVariable [QGVAR(radioIdList), []]
