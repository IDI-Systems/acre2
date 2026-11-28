#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Starts (or restarts) the microphone test: silence, then typing, then talking.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_micTestStart
 *
 * Public: No
 */

GVAR(micTest) set ["phase", 1];
GVAR(micTest) set ["phaseStart", diag_tickTime];
GVAR(micTest) set ["silent", []];
GVAR(micTest) set ["typing", []];
GVAR(micTest) set ["talking", []];
GVAR(micTest) set ["result", []];

private _display = uiNamespace getVariable [QGVAR(micTestDisplay), displayNull];
(_display displayCtrl 110) ctrlEnable false;
(_display displayCtrl 111) ctrlEnable false;
