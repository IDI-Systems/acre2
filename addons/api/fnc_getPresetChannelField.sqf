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
