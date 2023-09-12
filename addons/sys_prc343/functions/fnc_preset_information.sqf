#include "..\script_component.hpp"
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
 * [] call acre_sys_prc343_fnc_preset_information
 *
 * Public: No
 */

private _presetFrequencies = [];
for "_i" from 0 to 255 do {
    private _basefrequency = 2400;
    private _frequencymodifier = _i*0.01;
    private _frequency = _basefrequency + _frequencymodifier;
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
