#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_presetInformation
 *
 * Public: No
 */

// Any frequency larger than 70 is counted as noFreq.

//46->65.975MHZ (25khz min spacing)
private _presetFrequencies = [];
private _basefrequency = 46;
for "_i" from 0 to 11 do {
    private _frequencymodifier = _i*1;
    private _frequency = _basefrequency + _frequencymodifier;
    _presetFrequencies pushBack _frequency;
};
_presetFrequencies pushBack 100; // H


private _presetData = HASH_CREATE;
private _channels = [];
for "_i" from 0 to 12 do {
    private _frequency = _presetFrequencies select _i;
    private _channel = HASH_CREATE;

    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);

    PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_SEM52SL","default",_presetData] call EFUNC(sys_data,registerRadioPreset);


///////////////////////
// Preset 2
///////////////////////
private _presetFrequencies = [];
private _basefrequency = 46.250;

for "_i" from 0 to 11 do {
    private _frequencymodifier = _i*1;
    private _frequency = _basefrequency + _frequencymodifier;
    PUSH(_presetFrequencies,_frequency);
};
_presetFrequencies pushBack 100; // H

_presetData = HASH_CREATE;
_channels = [];
for "_i" from 0 to 12 do {
    private _frequency = _presetFrequencies select _i;
    private _channel = HASH_CREATE;

    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);

    PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_SEM52SL","default2",_presetData] call EFUNC(sys_data,registerRadioPreset);


///////////////////////
// Preset 3
///////////////////////
_presetFrequencies = [];
for "_i" from 0 to 11 do {
    private _basefrequency = 46.50;
    private _frequencymodifier = _i*1;
    private _frequency = _basefrequency + _frequencymodifier;
    PUSH(_presetFrequencies,_frequency);
};
_presetFrequencies pushBack 100; // H

_presetData = HASH_CREATE;
_channels = [];
for "_i" from 0 to 12 do {
    private _frequency = _presetFrequencies select _i;
    private _channel = HASH_CREATE;

    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);

    PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_SEM52SL","default3",_presetData] call EFUNC(sys_data,registerRadioPreset);


///////////////////////
// Preset 4
///////////////////////
_presetFrequencies = [];
for "_i" from 0 to 11 do {
    private _basefrequency = 46.750;
    private _frequencymodifier = _i*1;
    private _frequency = _basefrequency + _frequencymodifier;
    PUSH(_presetFrequencies,_frequency);
};
_presetFrequencies pushBack 100; // H

_presetData = HASH_CREATE;
_channels = [];
for "_i" from 0 to 12 do {
    private _frequency = _presetFrequencies select _i;
    private _channel = HASH_CREATE;

    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);

    PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_SEM52SL","default4",_presetData] call EFUNC(sys_data,registerRadioPreset);
