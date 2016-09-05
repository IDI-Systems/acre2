#include "script_component.hpp"

private _presetFrequencies = [];
for "_i" from 0 to 255 do {
    private ["_basefrequency","_frequencymodifier","_frequency"];
    _basefrequency = 2400;
    _frequencymodifier = _i*0.01;
    _frequency = _basefrequency + _frequencymodifier;
    PUSH(_presetFrequencies,_frequency);
};

// channels information
///Default
private _presetData = HASH_CREATE;
private _channels = HASHLIST_CREATELIST(["frequencyTX"]);
for "_i" from 0 to 255 do {
    private _frequency = _presetFrequencies select _i;
    private _channel = HASHLIST_CREATEHASH(_channels);

    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    //HASH_SET(_channel,"channelNumber",_i);

    HASHLIST_PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_PRC343","default",_presetData] call EFUNC(sys_data,registerRadioPreset);

///Default2
_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);
for "_i" from 0 to 79 do {
    private _frequency = _presetFrequencies select _i;
    private _channel = HASHLIST_CREATEHASH(_channels);

    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    //HASH_SET(_channel,"channelNumber",_i);

    HASHLIST_PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_PRC343","default2",_presetData] call EFUNC(sys_data,registerRadioPreset);

///Default3
_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);
for "_i" from 80 to 159 do {
    private _frequency = _presetFrequencies select _i;
    private _channel = HASHLIST_CREATEHASH(_channels);

    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    //HASH_SET(_channel,"channelNumber",_i);

    HASHLIST_PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_PRC343","default3",_presetData] call EFUNC(sys_data,registerRadioPreset);

///Default4
_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["frequencyTX"]);
for "_i" from 160 to 239 do {
    private _frequency = _presetFrequencies select _i;
    private _channel = HASHLIST_CREATEHASH(_channels);

    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    //HASH_SET(_channel,"channelNumber",_i);

    HASHLIST_PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_PRC343","default4",_presetData] call EFUNC(sys_data,registerRadioPreset);
