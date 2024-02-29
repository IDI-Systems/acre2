#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initialisation function for default radios.
 *
 * Arguments:
 * 0: Unique Radio ID <STRING>
 * 1: Radio preset <STRING> (default: "default")
 *
 * Return Value:
 * None <TYPE>
 *
 * Example:
 * ["ACRE_PRC343_ID_1", "default2"] call acre_sys_radio_fnc_initDefaultRadio
 *
 * Public: No
 */

LOG("INITIALIZING DEFAULT RADIO");
TRACE_1("",_this);
params ["_radioId", ["_preset", "default"]];

private _baseName = BASECLASS(_radioId);
[_radioId, "initializeComponent", [_baseName, _preset]] call EFUNC(sys_data,dataEvent);

// External radio use
[_radioId] call EFUNC(sys_external,initRadio);

// External antenna
[_radioId] call EFUNC(sys_gsa,initRadio);

TRACE_1("",_baseName);
