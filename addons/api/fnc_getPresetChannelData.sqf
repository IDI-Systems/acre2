/*
 * Author: ACRE2Team
 * Returns the full ACRE2 channel Hash data of the specified preset name for the specified radio.
 * The channel number must be a valid channel for that type of radio.
 *
 * Arguments:
 * 0: Base radio class <STRING>
 * 1: Preset name <STRING>
 * 2: Channel number <STRING>
 *
 * Return Value:
 * Hash containing all the channel preset information <HASH>
 *
 * Example:
 * _presetData = ["ACRE_PRC152", "default", 4] call acre_api_fnc_getPresetChannelData;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_radioClass", "_presetName", "_channelReference"];

if(!(_radioClass isEqualType "")) exitWith { nil };
if(!(_presetName isEqualType "")) exitWith { nil };

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

//_channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
private _presetData = [_radioClass, _presetName] call EFUNC(sys_data,getPresetData);
if(isNil "_presetData") exitWith { nil };

private _channels = HASH_GET(_presetData, "channels");
private _channel = HASHLIST_SELECT(_channels, _channelNumber);

if(isNil "_channel") exitWith { nil };
_channel
