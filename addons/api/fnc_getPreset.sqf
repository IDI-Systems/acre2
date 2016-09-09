/*
 * Author: ACRE2Team
 * Gets the preset name to utilize on the provided radio class during initialization.
 *
 * Arguments:
 * 0: Radio base type <STRING>
 *
 * Return Value:
 * The string name of the current preset <STRING>
 *
 * Example:
 * _currentPreset = ["ACRE_PRC152"] call acre_api_fnc_getPreset;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params["_radioClass"];

private _preset = [_radioClass] call EFUNC(sys_data,getRadioPresetName);

_preset
