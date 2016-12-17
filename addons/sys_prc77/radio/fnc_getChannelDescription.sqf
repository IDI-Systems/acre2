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

params ["_radioId"];

private _hashData = [_radioId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);

private _description = format["Frequency: %1 MHz", HASH_GET(_hashData,"frequencyTX")];

_description
