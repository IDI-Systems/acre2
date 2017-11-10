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

LOG("INITIALIZING DEFAULT RADIO");
TRACE_1("", _this);
params ["_radioId", ["_preset", "default"]];

private _baseName = BASECLASS(_radioId);
[_radioId, "initializeComponent", [_baseName, _preset]] call EFUNC(sys_data,dataEvent);

// External radio use
[_radioId] call EFUNC(sys_external,initRadio);

TRACE_1("", _baseName);
