#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if radio is for headset use.
 *
 * Arguments:
 * 0: Base radio classname <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC343"] call acre_sys_gesture_fnc_isHeadsetRadio
 *
 * Public: No
 */

params ["_radio"];

GVAR(vestRadioArr) = ["ACRE_PRC343","ACRE_PRC77","ACRE_SEM52SL"];
GVAR(headsetRadioArr) = ["ACRE_PRC148","ACRE_PRC152","ACRE_PRC117F","ACRE_SEM70"];

private _ret = true;

if (_radio in GVAR(vestRadioArr)) then {
    _ret = false;
};

_ret
