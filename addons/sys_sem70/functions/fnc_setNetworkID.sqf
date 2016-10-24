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

private _knobPosition = ["getState", "MemorySlotKnobPosition"] call EFUNC(sys_data,dataEvent);
private "_newNetworkID";

_knobPosition params ["_hecto","_deca","_ones"];

_newNetworkID = 100*_hecto + 10*_deca + _ones;

["setState", ["networkID", _newNetworkID]] call EFUNC(sys_data,dataEvent);
