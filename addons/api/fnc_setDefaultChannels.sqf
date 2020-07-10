#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * DEPRECATED
 * Sets the preset data for a given radio base class.
 *
 * Arguments:
 * 0: Radio Base Class <STRING>
 * 1: Preset Name <STRING>
 *
 * Return Value:
 * True <BOOL>
 *
 * Example:
 * ["ACRE_PRC343","default"] call acre_api_fnc_setDefaultChannels;
 *
 * Public: No
 */

params [
    ["_baseClass", "", [""]],
    ["_presetName", "", [""]]
];

ACRE_DEPRECATED(QFUNC(setDefaultChannels),"2.5.0",QFUNC(setRadioPreset));

[_baseClass, _presetName] call EFUNC(sys_data,assignRadioPreset);

true
