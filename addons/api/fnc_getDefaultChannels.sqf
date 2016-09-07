/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

private["_preset", "_presetData"];
params["_radioClass"];

hintSilent "WARNING: ACRE API getDefaultChannels is depricated. Please use getPresetData";
diag_log text format ["WARNING: ACRE API getDefaultChannels is depricated. Please use getPresetData"];

_preset = [_radioClass] call EFUNC(sys_data,getRadioPresetName);
_presetData = [_radioClass, _preset] call EFUNC(sys_data,getPresetData);

_presetData
