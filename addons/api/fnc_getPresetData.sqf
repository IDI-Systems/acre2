/*
 * Author: ACRE2Team
 * Returns the full preset data of the specified preset name for the specified radio.
 *
 * Arguments:
 * 0: Radio base class <STRING>
 * 1: Preset Name <STRING>
 *
 * Return Value:
 * Preset data <HASH>
 *
 * Example:
 * _presetData = ["ACRE_PRC152", "default"] call acre_api_fnc_getPresetData;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_radioClass", "_preset"];

//_preset = [_radioClass] call EFUNC(sys_data,getRadioPresetName);
private _presetData = [_radioClass, _preset] call EFUNC(sys_data,getPresetData);

_presetData
