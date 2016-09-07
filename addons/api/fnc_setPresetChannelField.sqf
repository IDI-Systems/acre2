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

private["_channelNumber", "_channels", "_channel", "_ret"];

_ret = params [["_radioClass","",[""]],
    ["_presetName","",[""]],
    "_channelReference",
    ["_fieldName","",[""]],
    ["_value","",["",0,[]]]];

if (!_ret) exitWith { false };

//if(typeName _radioClass != "STRING") exitWith { false };
//if(typeName _presetName != "STRING") exitWith { false };
//if(typeName _fieldName != "STRING") exitWith { false };

// Just make sure its some valid type for now
//if(typeName _value != "STRING" && typeName _value != "SCALAR" && typeName _value != "ARRAY") exitWith { false };


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
TRACE_1("", _channelNumber);

//_channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
_presetData = [_radioClass, _presetName] call EFUNC(sys_data,getPresetData);
if(isNil "_presetData") exitWith { false };
TRACE_1("", _presetData);

_channels = HASH_GET(_presetData, "channels");
TRACE_1("", _channels);

_channel = HASHLIST_SELECT(_channels, _channelNumber);
TRACE_1("", _channel);

_newFieldName = [_radioClass, _fieldName] call FUNC(mapChannelFieldName);
TRACE_2("", _channel, _newFieldName);

if(!HASH_HASKEY(_channel, _newFieldName)) exitWith { false };
HASH_SET(_channel, _newFieldName, _value);

true
