/*
 * Author: ACRE2Team
 * Gets the preset data for a given radio base class.
 *
 * Arguments:
 * 0: Radio base class <STRING>
 *
 * Return Value:
 * Preset data <HASH>
 *
 * Example:
 * ["ACRE_PRC343"] call acre_api_fnc_getDefaultChannels
 *
 * Deprecated
 */
#include "script_component.hpp"

params["_radioClass"];

hintSilent "WARNING: ACRE API getDefaultChannels is depricated. Please use getPresetData";
diag_log text format ["WARNING: ACRE API getDefaultChannels is depricated. Please use getPresetData"];

private _preset = [_radioClass] call EFUNC(sys_data,getRadioPresetName);
private _presetData = [_radioClass, _preset] call EFUNC(sys_data,getPresetData);

_presetData
