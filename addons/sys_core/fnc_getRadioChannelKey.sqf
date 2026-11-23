#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * The voice server channel a radio transmits or receives on. Radios only reach each other on
 * the same key; SQF still makes the final call (signal, availability) as before.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Transmitting (else receiving) <BOOL>
 *
 * Return Value:
 * Channel key, "" if the radio has no channel data <STRING>
 *
 * Example:
 * ["ACRE_PRC152_ID_1", true] call acre_sys_core_fnc_getRadioChannelKey
 *
 * Public: No
 */

params ["_radioId", "_transmit"];

private _data = [_radioId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
if (isNil "_data") exitWith {""};

private _mode = HASH_GET(_data,"mode");
if (isNil "_mode") exitWith {""};

switch (_mode) do {
    case "singleChannel";
    case "singleChannelPRR": {
        private _frequencyKey = ["frequencyRX", "frequencyTX"] select _transmit;
        private _frequency = HASH_GET(_data,_frequencyKey);
        if (isNil "_frequency") then {
            format ["radio:other:%1", _mode]
        } else {
            format ["radio:%1:%2", _mode, _frequency toFixed 5]
        };
    };
    case "sem70AKW": {
        // Frequency hopping: radios match on the whole frequency list.
        private _frequencies = HASH_GET(_data,"frequencies");
        format ["radio:%1:%2", _mode, hashValue _frequencies]
    };
    default {
        // Unknown modes (e.g. from other mods) share one channel per mode and let SQF decide.
        format ["radio:other:%1", _mode]
    };
};
