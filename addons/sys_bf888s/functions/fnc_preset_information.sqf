#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initialises and registers the default presets with the initial values of transmitting and receiving frequencies for each of the channels.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_bf888s_fnc_preset_information
 *
 * Public: No
 */

private _presetFrequencies = [];
for "_i" from 0 to 63 do {
    private _basefrequency = 400;
    private _frequencymodifier = _i * 0.01;
    private _frequency = _basefrequency + _frequencymodifier;
    PUSH(_presetFrequencies,_frequency);
};

// channels information
///Default
private _presetData = HASH_CREATE;
private _channels = HASHLIST_CREATELIST(["frequencyTX"]);
for "_i" from 0 to 15 do {
    private _frequency = _presetFrequencies select _i;
    private _channel = HASHLIST_CREATEHASH(_channels);

    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    HASH_SET(_channel,"power",5000);
    HASH_SET(_channel,"encryption",0);
    HASH_SET(_channel,"channelMode", "BASIC");
    HASH_SET(_channel,"CTCSSTx", 69.3);
    HASH_SET(_channel,"CTCSSRx", 69.3);
    HASH_SET(_channel,"modulation","FM");
    HASH_SET(_channel,"trafficRate",16);
    HASH_SET(_channel,"TEK","");
    HASH_SET(_channel,"RPTR",0.2);
    HASH_SET(_channel,"fade",2);
    HASH_SET(_channel,"phase",256);
    HASH_SET(_channel,"squelch",3);
    //HASH_SET(_channel,"channelNumber",_i);

    HASHLIST_PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_BF888S","default",_presetData] call EFUNC(sys_data,registerRadioPreset);

///Default2
_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);
for "_i" from 16 to 31 do {
    private _frequency = _presetFrequencies select _i;
    private _channel = HASHLIST_CREATEHASH(_channels);

    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    HASH_SET(_channel,"power",5000);
    HASH_SET(_channel,"encryption",0);
    HASH_SET(_channel,"channelMode", "BASIC");
    HASH_SET(_channel,"CTCSSTx", 69.3);
    HASH_SET(_channel,"CTCSSRx", 69.3);
    HASH_SET(_channel,"modulation","FM");
    HASH_SET(_channel,"trafficRate",16);
    HASH_SET(_channel,"TEK","");
    HASH_SET(_channel,"RPTR",0.2);
    HASH_SET(_channel,"fade",2);
    HASH_SET(_channel,"phase",256);
    HASH_SET(_channel,"squelch",3);
    //HASH_SET(_channel,"channelNumber",_i);

    HASHLIST_PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_BF888S","default2",_presetData] call EFUNC(sys_data,registerRadioPreset);

///Default3
_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);
for "_i" from 32 to 47 do {
    private _frequency = _presetFrequencies select _i;
    private _channel = HASHLIST_CREATEHASH(_channels);

    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    HASH_SET(_channel,"power",5000);
    HASH_SET(_channel,"encryption",0);
    HASH_SET(_channel,"channelMode", "BASIC");
    HASH_SET(_channel,"CTCSSTx", 69.3);
    HASH_SET(_channel,"CTCSSRx", 69.3);
    HASH_SET(_channel,"modulation","FM");
    HASH_SET(_channel,"trafficRate",16);
    HASH_SET(_channel,"TEK","");
    HASH_SET(_channel,"RPTR",0.2);
    HASH_SET(_channel,"fade",2);
    HASH_SET(_channel,"phase",256);
    HASH_SET(_channel,"squelch",3);

    HASHLIST_PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_BF888S","default3",_presetData] call EFUNC(sys_data,registerRadioPreset);

///Default4
_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);
for "_i" from 48 to 63 do {
    private _frequency = _presetFrequencies select _i;
    private _channel = HASHLIST_CREATEHASH(_channels);

    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    HASH_SET(_channel,"power",5000);
    HASH_SET(_channel,"encryption",0);
    HASH_SET(_channel,"channelMode", "BASIC");
    HASH_SET(_channel,"CTCSSTx", 69.3);
    HASH_SET(_channel,"CTCSSRx", 69.3);
    HASH_SET(_channel,"modulation","FM");
    HASH_SET(_channel,"trafficRate",16);
    HASH_SET(_channel,"TEK","");
    HASH_SET(_channel,"RPTR",0.2);
    HASH_SET(_channel,"fade",2);
    HASH_SET(_channel,"phase",256);
    HASH_SET(_channel,"squelch",3);
    //HASH_SET(_channel,"channelNumber",_i);

    HASHLIST_PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_BF888S","default4",_presetData] call EFUNC(sys_data,registerRadioPreset);
