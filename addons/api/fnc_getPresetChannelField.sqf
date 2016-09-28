/*
 * Author: ACRE2Team
 * Returns the value of the channel field for the given radio preset.
 *
 * Arguments:
 * 0: Radio Base class <STRING>
 * 1: Preset name <STRING>
 * 2: Channel number <NUMBER>
 * 3: Field name <STRING>
 *
 * Return Value:
 * Value of the given field <ANY>
 *
 * Example:
 * ["ACRE_PRC148", "default", 2, "label"] call acre_api_fnc_getPresetChannelField;
 *
 * Public: Yes
 */
#include "script_component.hpp"

//TODO: remove comments? and from setPresetChannelField

private _ret = params [["_radioClass","",[""]],
    ["_presetName","",[""]],
    "_channelReference",
    ["_fieldName","",[""]]];

if (!_ret) exitWith { nil };

private _channelNumber = -1;
if(_channelReference isEqualType []) then {
    // its a group and channel
} else {
    if(_channelReference isEqualType "") then {
        _channelNumber = parseNumber _channelReference;
    } else {
        if(_channelReference isEqualType 0) then {
            _channelNumber = _channelReference;
        };
    };
};
// The API takes channel numbers as 1-
_channelNumber = _channelNumber - 1;

//_channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
private _presetData = [_radioClass, _presetName] call EFUNC(sys_data,getPresetData);
if(isNil "_presetData") exitWith { nil };

private _channels = HASH_GET(_presetData, "channels");
private _channel = HASHLIST_SELECT(_channels, _channelNumber);

private _fieldName = [_radioClass, _fieldName] call FUNC(mapChannelFieldName);

if(!HASH_HASKEY(_channel, _fieldName)) exitWith { nil };
private _value = HASH_GET(_channel, _fieldName);

if(isNil "_value") exitWith { nil };
_value
