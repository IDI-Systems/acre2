/*
 * Author: AUTHOR
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

private ["_hashData", "_description"];
params["_radioId"];

_hashData = [_radioId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);

_description = format["Frequency: %1 MHz", HASH_GET(_hashData,"frequencyTX")];

_description
