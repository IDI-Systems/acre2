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
 * ["ACRE_PRC343","default"] call acre_api_fnc_setDefaultChannels;
 *
 * Deprecated
 */
#include "script_component.hpp"

params["_baseClass","_presetName"];

hintSilent "WARNING: ACRE API setDefaultChannels is depricated. Please use setRadioPreset";
diag_log text format ["WARNING: ACRE API setDefaultChannels is depricated. Please use setRadioPreset"];

[_baseClass, _presetName] call EFUNC(sys_data,assignRadioPreset);

true
