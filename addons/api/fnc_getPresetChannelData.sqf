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
private["_channelNumber", "_channels", "_channel", "_fieldName", "_value"];

params ["_radioClass", "_presetName", "_channelReference"];

if(!(_radioClass isEqualType "")) exitWith { nil };
if(!(_presetName isEqualType "")) exitWith { nil };

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

//_channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
_presetData = [_radioClass, _presetName] call EFUNC(sys_data,getPresetData);
if(isNil "_presetData") exitWith { nil };

_channels = HASH_GET(_presetData, "channels");
_channel = HASHLIST_SELECT(_channels, _channelNumber);

if(isNil "_channel") exitWith { nil };
_channel
