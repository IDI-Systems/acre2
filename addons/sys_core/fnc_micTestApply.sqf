#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Applies the microphone test's open/close levels (and push-to-talk if speech couldn't be told
 * apart from typing).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_micTestApply
 *
 * Public: No
 */

(GVAR(micTest) get "result") params [["_open", -45], ["_close", -50], ["_separable", true]];

[QGVAR(voiceThreshold), _open] call CBA_settings_fnc_set;
[QGVAR(voiceThresholdClose), _close] call CBA_settings_fnc_set;
if (!_separable) then {
    [QGVAR(voiceActivation), 1] call CBA_settings_fnc_set;
};

private _display = uiNamespace getVariable [QGVAR(micTestDisplay), displayNull];
(_display displayCtrl 111) ctrlEnable false;
[format [localize LSTRING(micTest_applied), _open, _close]] call CBA_fnc_notify;
