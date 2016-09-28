/*
 * Author: ACRE2Team
 * Sets the preset name to utilize on the provided radio class during initialization.
 *
 * Arguments:
 * 0: Radio base type <STRING>
 * 1: Preset name <STRING>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * _success = ["ACRE_PRC152", "default2"] call acre_api_fnc_setPreset;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params["_baseClass","_presetName"];

[_baseClass, _presetName] call EFUNC(sys_data,assignRadioPreset);

true
