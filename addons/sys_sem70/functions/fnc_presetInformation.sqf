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
 * [ARGUMENTS] call acre_sys_sem70_fnc_presetInformation
 *
 * Public: No
 */



///////////////////////
// Preset 1
///////////////////////
//30->39.375MHZ (25khz min spacing)
private _presetFrequencies = [];
private _networkID = 123;
private _basefrequency = 30;
for "_i" from 0 to 9 do {
    private _frequencies = [];
    for "_j" from 0 to 15 do {
        private _frequency = _basefrequency + _i*1 + _j*0.025;
        _frequencies pushBack _frequency;
    };
    _presetFrequencies pushBack _frequencies;
};
_presetFrequencies pushBack 30; // Manual


private _presetData = HASH_CREATE;
private _channels = [];
for "_i" from 0 to 10 do {
    private _channel = HASH_CREATE;

    if (_i < 10) then {
        HASH_SET(_channel,"networkID",_networkID);
        HASH_SET(_channel,"frequencies",_presetFrequencies param [_i]);
        HASH_SET(_channel,"frequencyTX",_basefrequency); // This just needs some default value
        HASH_SET(_channel,"mode","sem70AKW");
    } else {
        HASH_SET(_channel,"frequencyTX",_presetFrequencies param [_i]);
        HASH_SET(_channel,"frequencyRX",_presetFrequencies param [_i]);
        HASH_SET(_channel,"mode","singleChannel");
    };

    PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_SEM70","default",_presetData] call EFUNC(sys_data,registerRadioPreset);


///////////////////////
// Preset 2
///////////////////////
//40->49.375MHZ (25khz min spacing)
private _presetFrequencies = [];
private _networkID = 234;
private _basefrequency = 40;
for "_i" from 0 to 9 do {
    private _frequencies = [];
    for "_j" from 0 to 15 do {
        private _frequency = _basefrequency + _i*1 + _j*0.025;
        _frequencies pushBack _frequency;
    };
    _presetFrequencies pushBack _frequencies;
};
_presetFrequencies pushBack 40; // Manual


private _presetData = HASH_CREATE;
private _channels = [];
for "_i" from 0 to 10 do {
    private _channel = HASH_CREATE;

    if (_i < 10) then {
        HASH_SET(_channel,"networkID",_networkID);
        HASH_SET(_channel,"frequencies",_presetFrequencies param [_i]);
        HASH_SET(_channel,"frequencyTX",_basefrequency); // This just needs some default value
        HASH_SET(_channel,"mode","sem70AKW");
    } else {
        HASH_SET(_channel,"frequencyTX",_presetFrequencies param [_i]);
        HASH_SET(_channel,"frequencyRX",_presetFrequencies param [_i]);
        HASH_SET(_channel,"mode","singleChannel");
    };

    PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_SEM70","default2",_presetData] call EFUNC(sys_data,registerRadioPreset);


///////////////////////
// Preset 3
///////////////////////
//50->59.375MHZ (25khz min spacing)
private _presetFrequencies = [];
private _networkID = 345;
private _basefrequency = 50;
for "_i" from 0 to 9 do {
    private _frequencies = [];
    for "_j" from 0 to 15 do {
        private _frequency = _basefrequency + _i*1 + _j*0.025;
        _frequencies pushBack _frequency;
    };
    _presetFrequencies pushBack _frequencies;
};
_presetFrequencies pushBack 50; // Manual


private _presetData = HASH_CREATE;
private _channels = [];
for "_i" from 0 to 10 do {
    private _channel = HASH_CREATE;

    if (_i < 10) then {
        HASH_SET(_channel,"networkID",_networkID);
        HASH_SET(_channel,"frequencies",_presetFrequencies param [_i]);
        HASH_SET(_channel,"frequencyTX",_basefrequency); // This just needs some default value
        HASH_SET(_channel,"mode","sem70AKW");
    } else {
        HASH_SET(_channel,"frequencyTX",_presetFrequencies param [_i]);
        HASH_SET(_channel,"frequencyRX",_presetFrequencies param [_i]);
        HASH_SET(_channel,"mode","singleChannel");
    };

    PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_SEM70","default3",_presetData] call EFUNC(sys_data,registerRadioPreset);


///////////////////////
// Preset 4
///////////////////////
//60->69.375MHZ (25khz min spacing)
private _presetFrequencies = [];
private _networkID = 456;
private _basefrequency = 60;
for "_i" from 0 to 9 do {
    private _frequencies = [];
    for "_j" from 0 to 15 do {
        private _frequency = _basefrequency + _i*1 + _j*0.025;
        _frequencies pushBack _frequency;
    };
    _presetFrequencies pushBack _frequencies;
};
_presetFrequencies pushBack 60; // Manual


private _presetData = HASH_CREATE;
private _channels = [];
for "_i" from 0 to 10 do {
    private _channel = HASH_CREATE;

    if (_i < 10) then {
        HASH_SET(_channel,"networkID",_networkID);
        HASH_SET(_channel,"frequencies",_presetFrequencies param [_i]);
        HASH_SET(_channel,"frequencyTX",_basefrequency); // This just needs some default value
        HASH_SET(_channel,"mode","sem70AKW");
    } else {
        HASH_SET(_channel,"frequencyTX",_presetFrequencies param [_i]);
        HASH_SET(_channel,"frequencyRX",_presetFrequencies param [_i]);
        HASH_SET(_channel,"mode","singleChannel");
    };

    PUSH(_channels,_channel);
};
HASH_SET(_presetData,"channels",_channels);
["ACRE_SEM70","default4",_presetData] call EFUNC(sys_data,registerRadioPreset);
