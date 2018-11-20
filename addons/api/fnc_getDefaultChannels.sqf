#include "script_component.hpp"
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

ACRE_DEPRECATED(QFUNC(getDefaultChannels),"2.5.0",QFUNC(getPresetData));

params ["_radioClass"];

private _preset = [_radioClass] call EFUNC(sys_data,getRadioPresetName);
private _presetData = [_radioClass, _preset] call EFUNC(sys_data,getPresetData);

_presetData
