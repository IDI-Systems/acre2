/*
 * Author: ACRE2Team
 * Changes the spatial mode of the active radio.
 *
 * Arguments:
 * 0: Spatial mode (-1 = left, 0 = center, 1 = right) <NUMBER>
 *
 * Return Value:
 * Handled <BOOLEAN>
 *
 * Example:
 * [0] call acre_sys_core_fnc_switchRadioEar
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_ear"];

private _radioId = ACRE_ACTIVE_RADIO;

switch _ear do {
    case -1: {
        hintSilent "LEFT EAR";
    };
    case 0: {
        hintSilent "CENTER EAR";
    };
    case 1: {
        hintSilent "RIGHT EAR";
    };
};
//[_radioId, "setState", ["ACRE_INTERNAL_RADIOSPATIALIZATION", _ear]] call EFUNC(sys_data,dataEvent);
[_radioId, "setSpatial", _ear] call EFUNC(sys_data,dataEvent);

true
