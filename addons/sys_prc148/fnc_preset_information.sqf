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

private _usedPresetFrequencies = [];
private _presetData = HASH_CREATE;
private _channels = HASHLIST_CREATELIST(["power"]);

for "_i" from 0 to 31 do {
    _channel = HASHLIST_CREATEHASH(_channels);
    _find = true;
    _frequency = 0;
    _frequency = (950+(_i*2))*0.0625;
    if(!(_frequency in _usedPresetFrequencies)) then {
        _ok = true;
        {
            if(abs(_x-_frequency) <= 0.25) exitWith {
                _ok = false;
            };
        } forEach _usedPresetFrequencies;
        if(_ok || (count _usedPresetFrequencies) == 0) then {
            _find = false;
            PUSH(_usedPresetFrequencies, _frequency);
        };
    };
    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    HASH_SET(_channel,"power",5000);
    HASH_SET(_channel,"encryption",0);
    HASH_SET(_channel,"channelMode", "BASIC");
    HASH_SET(_channel,"label","CHAN " + str(_i+1));
    HASH_SET(_channel,"CTCSSTx", 250.3);
    HASH_SET(_channel,"CTCSSRx", 250.3);
    HASH_SET(_channel,"modulation","FM");
    HASH_SET(_channel,"trafficRate",16);
    HASH_SET(_channel,"TEK",1);
    HASH_SET(_channel,"RPTR",0.2);
    HASH_SET(_channel,"fade",2);
    HASH_SET(_channel,"phase",256);
    HASH_SET(_channel,"squelch",3);

    HASHLIST_PUSH(_channels, _channel);
};
HASH_SET(_presetData,"channels",_channels);
_groups = [
        ["G01", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]],
        ["G02", [16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]],
        ["G03", []],
        ["G04", []],
        ["G05", []],
        ["G06", []],
        ["G07", []],
        ["G08", []],
        ["G09", []],
        ["G11", []],
        ["G12", []],
        ["G13", []],
        ["G14", []],
        ["G15", []],
        ["G16", []]
];
HASH_SET(_presetData,"groups",_groups);


["ACRE_PRC148","default",_presetData] call EFUNC(sys_data,registerRadioPreset);

_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["power"]);

for "_i" from 0 to 31 do {
    _channel = HASHLIST_CREATEHASH(_channels);
    _find = true;
    _frequency = 0;
    _frequency = (950+200+(_i*2))*0.0625;
    if(!(_frequency in _usedPresetFrequencies)) then {
        _ok = true;
        {
            if(abs(_x-_frequency) <= 0.25) exitWith {
                _ok = false;
            };
        } forEach _usedPresetFrequencies;
        if(_ok || (count _usedPresetFrequencies) == 0) then {
            _find = false;
            PUSH(_usedPresetFrequencies, _frequency);
        };
    };
    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    HASH_SET(_channel,"power",5000);
    HASH_SET(_channel,"encryption",0);
    HASH_SET(_channel,"channelMode", "BASIC");
    HASH_SET(_channel,"label","CHAN " + str(_i+1));
    HASH_SET(_channel,"CTCSSTx", 250.3);
    HASH_SET(_channel,"CTCSSRx", 250.3);
    HASH_SET(_channel,"modulation","FM");
    HASH_SET(_channel,"trafficRate",16);
    HASH_SET(_channel,"TEK",1);
    HASH_SET(_channel,"RPTR",0.2);
    HASH_SET(_channel,"fade",2);
    HASH_SET(_channel,"phase",256);
    HASH_SET(_channel,"squelch",3);

    HASHLIST_PUSH(_channels, _channel);
};
HASH_SET(_presetData,"channels",_channels);
_groups = [
        ["G01", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]],
        ["G02", [16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]],
        ["G03", []],
        ["G04", []],
        ["G05", []],
        ["G06", []],
        ["G07", []],
        ["G08", []],
        ["G09", []],
        ["G11", []],
        ["G12", []],
        ["G13", []],
        ["G14", []],
        ["G15", []],
        ["G16", []]
];
HASH_SET(_presetData,"groups",_groups);


["ACRE_PRC148","default2",_presetData] call EFUNC(sys_data,registerRadioPreset);

_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["power"]);

for "_i" from 0 to 31 do {
    _channel = HASHLIST_CREATEHASH(_channels);
    _find = true;
    _frequency = 0;
    _frequency = (950+400+(_i*2))*0.0625;
    if(!(_frequency in _usedPresetFrequencies)) then {
        _ok = true;
        {
            if(abs(_x-_frequency) <= 0.25) exitWith {
                _ok = false;
            };
        } forEach _usedPresetFrequencies;
        if(_ok || (count _usedPresetFrequencies) == 0) then {
            _find = false;
            PUSH(_usedPresetFrequencies, _frequency);
        };
    };
    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    HASH_SET(_channel,"power",5000);
    HASH_SET(_channel,"encryption",0);
    HASH_SET(_channel,"channelMode", "BASIC");
    HASH_SET(_channel,"label","CHAN " + str(_i+1));
    HASH_SET(_channel,"CTCSSTx", 250.3);
    HASH_SET(_channel,"CTCSSRx", 250.3);
    HASH_SET(_channel,"modulation","FM");
    HASH_SET(_channel,"trafficRate",16);
    HASH_SET(_channel,"TEK",1);
    HASH_SET(_channel,"RPTR",0.2);
    HASH_SET(_channel,"fade",2);
    HASH_SET(_channel,"phase",256);
    HASH_SET(_channel,"squelch",3);

    HASHLIST_PUSH(_channels, _channel);
};
HASH_SET(_presetData,"channels",_channels);
_groups = [
        ["G01", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]],
        ["G02", [16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]],
        ["G03", []],
        ["G04", []],
        ["G05", []],
        ["G06", []],
        ["G07", []],
        ["G08", []],
        ["G09", []],
        ["G11", []],
        ["G12", []],
        ["G13", []],
        ["G14", []],
        ["G15", []],
        ["G16", []]
];
HASH_SET(_presetData,"groups",_groups);


["ACRE_PRC148","default3",_presetData] call EFUNC(sys_data,registerRadioPreset);

_presetData = HASH_CREATE;
_channels = HASHLIST_CREATELIST(["power"]);

for "_i" from 0 to 31 do {
    _channel = HASHLIST_CREATEHASH(_channels);
    _find = true;
    _frequency = 0;
    _frequency = (950+600+(_i*2))*0.0625;
    if(!(_frequency in _usedPresetFrequencies)) then {
        _ok = true;
        {
            if(abs(_x-_frequency) <= 0.25) exitWith {
                _ok = false;
            };
        } forEach _usedPresetFrequencies;
        if(_ok || (count _usedPresetFrequencies) == 0) then {
            _find = false;
            PUSH(_usedPresetFrequencies, _frequency);
        };
    };
    HASH_SET(_channel,"frequencyTX",_frequency);
    HASH_SET(_channel,"frequencyRX",_frequency);
    HASH_SET(_channel,"power",5000);
    HASH_SET(_channel,"encryption",0);
    HASH_SET(_channel,"channelMode", "BASIC");
    HASH_SET(_channel,"label","CHAN " + str(_i+1));
    HASH_SET(_channel,"CTCSSTx", 250.3);
    HASH_SET(_channel,"CTCSSRx", 250.3);
    HASH_SET(_channel,"modulation","FM");
    HASH_SET(_channel,"trafficRate",16);
    HASH_SET(_channel,"TEK",1);
    HASH_SET(_channel,"RPTR",0.2);
    HASH_SET(_channel,"fade",2);
    HASH_SET(_channel,"phase",256);
    HASH_SET(_channel,"squelch",3);

    HASHLIST_PUSH(_channels, _channel);
};
HASH_SET(_presetData,"channels",_channels);
_groups = [
        ["G01", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]],
        ["G02", [16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]],
        ["G03", []],
        ["G04", []],
        ["G05", []],
        ["G06", []],
        ["G07", []],
        ["G08", []],
        ["G09", []],
        ["G11", []],
        ["G12", []],
        ["G13", []],
        ["G14", []],
        ["G15", []],
        ["G16", []]
];
HASH_SET(_presetData,"groups",_groups);


["ACRE_PRC148","default4",_presetData] call EFUNC(sys_data,registerRadioPreset);


DGVAR(PFHId) = -1;

DGVAR(alpha) = [];
DGVAR(numeric) = [];

_alpha = " ABCDEFGHIJKLMNOPQRSTUVWXYZ";
_numeric = "1234567890";

_array = toArray _alpha;
{
    PUSH(GVAR(alpha), (toString [_x]));
} forEach _array;

_array = toArray _numeric;
{
    PUSH(GVAR(numeric), (toString [_x]));
} forEach _array;

DGVAR(alphaNumeric) = GVAR(numeric) + GVAR(alpha);

DGVAR(entryMap) = [];
DGVAR(currentMenu) = [];
DGVAR(editEntry) = false;

