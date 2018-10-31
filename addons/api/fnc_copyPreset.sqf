#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Copies all parameters of the source preset to a new destination preset name.
 *
 * Arguments:
 * 0: Radio base type <STRING>
 * 1: Preset name to copy <STRING>
 * 2: Destination preset name <STRING>
 *
 * Return Value:
 * Copy preset successful <BOOLEAN>
 *
 * Example:
 * ["ACRE_PRC152", "default2", "balls"] call acre_api_fnc_copyPreset
 *
 * Public: Yes
 */

params [
    ["_radioClass", "", []],
    ["_srcPresetName", "", []],
    ["_dstPresetName", "", []]
];

if (_radioClass isEqualTo ""  || {_srcPresetName isEqualTo ""} || {_dstPresetName isEqualTo ""}) exitWith {false};

private _presetData = [_radioClass, _srcPresetName] call FUNC(getPresetData);
if (isNil "_presetData") exitWith { false };

private _presetCopy = HASH_COPY(_presetData);

[_radioClass,_dstPresetName,_presetCopy] call EFUNC(sys_data,registerRadioPreset);

true
