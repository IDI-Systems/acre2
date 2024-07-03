#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_preset_information
 *
 * Public: No
 */

// channels information
private _presetData = HASH_CREATE;
private _channels = HASHLIST_CREATELIST(["frequencyTX"]);
private _usedPresetFrequencies = [];
for "_i" from 0 to 99 do {
    private _frequency = 0;
    _frequency = (950+(_i*2))*0.0625;
    if !(_frequency in _usedPresetFrequencies) then {
        private _ok = true;
        {
            if (abs(_x-_frequency) <= 0.25) exitWith {
                _ok = false;
            };
        } forEach _usedPresetFrequencies;
        if (_ok || (count _usedPresetFrequencies) == 0) then {
            PUSH(_usedPresetFrequencies,_frequency);
        };
    };
    // The above frequency generation is taken from the 148 so we match.

    private _channel = HASHLIST_CREATEHASH(_channels);
    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    HASH_SET(_channel,"power",20000);
    HASH_SET(_channel,"encryption",0);
    HASH_SET(_channel,"channelMode","BASIC");
    private _desc = format["NET%1",([_i+1, 2] call CBA_fnc_formatNumber)];
    HASH_SET(_channel,"name",_desc);
    HASH_SET(_channel,"CTCSSTx",250.3);
    HASH_SET(_channel,"CTCSSRx",250.3);
    HASH_SET(_channel,"modulation","FM");
    HASH_SET(_channel,"TEK",1);
    HASH_SET(_channel,"trafficRate",16);
    HASH_SET(_channel,"syncLength",256);

    // 117 specific channel settings
    HASH_SET(_channel,"squelch",3);
    HASH_SET(_channel,"deviation",8.0);
    HASH_SET(_channel,"optionCode",201);    // 200 for AM
    HASH_SET(_channel,"rxOnly",false);
    HASH_SET(_channel,"active",true);
    HASHLIST_PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_PRC117F","default",_presetData] call EFUNC(sys_data,registerRadioPreset);


_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);
_usedPresetFrequencies = [];
for "_i" from 0 to 99 do {
    private _frequency = 0;
    _frequency = (950+200+(_i*2))*0.0625;
    if (!(_frequency in _usedPresetFrequencies)) then {
        private _ok = true;
        {
            if (abs(_x-_frequency) <= 0.25) exitWith {
                _ok = false;
            };
        } forEach _usedPresetFrequencies;
        if (_ok || (count _usedPresetFrequencies) == 0) then {
            PUSH(_usedPresetFrequencies,_frequency);
        };
    };
    // The above frequency generation is taken from the 148 so we match.

    private _channel = HASHLIST_CREATEHASH(_channels);
    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    HASH_SET(_channel,"power",20000);
    HASH_SET(_channel,"encryption",0);
    HASH_SET(_channel,"channelMode","BASIC");
    private _desc = format["NET%1",([_i+1, 2] call CBA_fnc_formatNumber)];
    HASH_SET(_channel,"name",_desc);
    HASH_SET(_channel,"CTCSSTx",250.3);
    HASH_SET(_channel,"CTCSSRx",250.3);
    HASH_SET(_channel,"modulation","FM");
    HASH_SET(_channel,"TEK",1);
    HASH_SET(_channel,"trafficRate",16);
    HASH_SET(_channel,"syncLength",256);

    // 117 specific channel settings
    HASH_SET(_channel,"squelch",3);
    HASH_SET(_channel,"deviation",8.0);
    HASH_SET(_channel,"optionCode",201);    // 200 for AM
    HASH_SET(_channel,"rxOnly",false);
    HASH_SET(_channel,"active",true);
    HASHLIST_PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_PRC117F","default2",_presetData] call EFUNC(sys_data,registerRadioPreset);

_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);
_usedPresetFrequencies = [];
for "_i" from 0 to 99 do {
    private _frequency = 0;
    _frequency = (950+400+(_i*2))*0.0625;
    if (!(_frequency in _usedPresetFrequencies)) then {
        private _ok = true;
        {
            if (abs(_x-_frequency) <= 0.25) exitWith {
                _ok = false;
            };
        } forEach _usedPresetFrequencies;
        if (_ok || (count _usedPresetFrequencies) == 0) then {
            PUSH(_usedPresetFrequencies,_frequency);
        };
    };
    // The above frequency generation is taken from the 148 so we match.

    private _channel = HASHLIST_CREATEHASH(_channels);
    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    HASH_SET(_channel,"power",20000);
    HASH_SET(_channel,"encryption",0);
    HASH_SET(_channel,"channelMode","BASIC");
    private _desc = format["NET%1",([_i+1, 2] call CBA_fnc_formatNumber)];
    HASH_SET(_channel,"name",_desc);
    HASH_SET(_channel,"CTCSSTx",250.3);
    HASH_SET(_channel,"CTCSSRx",250.3);
    HASH_SET(_channel,"modulation","FM");
    HASH_SET(_channel,"TEK",1);
    HASH_SET(_channel,"trafficRate",16);
    HASH_SET(_channel,"syncLength",256);

    // 117 specific channel settings
    HASH_SET(_channel,"squelch",3);
    HASH_SET(_channel,"deviation",8.0);
    HASH_SET(_channel,"optionCode",201);    // 200 for AM
    HASH_SET(_channel,"rxOnly",false);
    HASH_SET(_channel,"active",true);
    HASHLIST_PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_PRC117F","default3",_presetData] call EFUNC(sys_data,registerRadioPreset);

_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);
_usedPresetFrequencies = [];
for "_i" from 0 to 99 do {
    private _frequency = 0;
    _frequency = (950+600+(_i*2))*0.0625;
    if !(_frequency in _usedPresetFrequencies) then {
        private _ok = true;
        {
            if (abs(_x-_frequency) <= 0.25) exitWith {
                _ok = false;
            };
        } forEach _usedPresetFrequencies;
        if (_ok || (count _usedPresetFrequencies) == 0) then {
            PUSH(_usedPresetFrequencies,_frequency);
        };
    };
    // The above frequency generation is taken from the 148 so we match.

    private _channel = HASHLIST_CREATEHASH(_channels);
    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    HASH_SET(_channel,"power",20000);
    HASH_SET(_channel,"encryption",0);
    HASH_SET(_channel,"channelMode","BASIC");
    private _desc = format["NET%1",([_i+1, 2] call CBA_fnc_formatNumber)];
    HASH_SET(_channel,"name",_desc);
    HASH_SET(_channel,"CTCSSTx",250.3);
    HASH_SET(_channel,"CTCSSRx",250.3);
    HASH_SET(_channel,"modulation","FM");
    HASH_SET(_channel,"TEK",1);
    HASH_SET(_channel,"trafficRate",16);
    HASH_SET(_channel,"syncLength",256);

    // 117 specific channel settings
    HASH_SET(_channel,"squelch",3);
    HASH_SET(_channel,"deviation",8.0);
    HASH_SET(_channel,"optionCode",201);    // 200 for AM
    HASH_SET(_channel,"rxOnly",false);
    HASH_SET(_channel,"active",true);
    HASHLIST_PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_PRC117F","default4",_presetData] call EFUNC(sys_data,registerRadioPreset);
