/*
 * Author: AUTHOR
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
private["_channelNumber", "_channels", "_channel", "_value", "_ret"];

//TODO: remove comments? and from setPresetChannelField
//params["_radioClass", "_presetName", "_channelReference", "_fieldName"];

_ret = params [["_radioClass","",[""]],
    ["_presetName","",[""]],
    "_channelReference",
    ["_fieldName","",[""]]];

if (!_ret) exitWith { nil };


//if(typeName _radioClass != "STRING") exitWith { nil };
//if(typeName _presetName != "STRING") exitWith { nil };
//if(typeName _fieldName != "STRING") exitWith { nil };

_channelNumber = -1;
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
_presetData = [_radioClass, _presetName] call EFUNC(sys_data,getPresetData);
if(isNil "_presetData") exitWith { nil };

_channels = HASH_GET(_presetData, "channels");
_channel = HASHLIST_SELECT(_channels, _channelNumber);

_fieldName = [_radioClass, _fieldName] call FUNC(mapChannelFieldName);

if(!HASH_HASKEY(_channel, _fieldName)) exitWith { nil };
_value = HASH_GET(_channel, _fieldName);

if(isNil "_value") exitWith { nil };
_value
