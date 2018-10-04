#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the radio spatial configuration.
 *
 * Arguments:
 * 0: Unique radio ID <STRING>
 * 1: Spatial configuration <STRING>
 *
 * Return Value:
 * Radio spatial successfully updated <BOOL>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_radio_fnc_setRadioSpatial
 *
 * Public: No
 */

params ["_radio", "_side"];

if ((isNil "_radio") || {isNil "_side"}) exitWith {
    false
};

private _spatial = 0;
switch (_side) do {
    case "LEFT": {
        _spatial = -1;
    };
    case "RIGHT": {
        _spatial = 1;
    };
    case "CENTER": {
        _spatial = 0;
    };
    default {
        _spatial = 0;
    };
};

[_radio, "setSpatial", _spatial] call EFUNC(sys_data,dataEvent);

true
