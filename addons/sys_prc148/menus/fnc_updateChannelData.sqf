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
 * [ARGUMENTS] call acre_sys_prc148_fnc_updateChannelData
 *
 * Public: No
 */

params ["_newVal", "_entry"];
_entry params ["_key", "_oldVal"];

private _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
private _channel = HASHLIST_SELECT(GET_STATE("channels"), _channelNumber);
if (_key == "frequencyRX" || {_key == "frequencyTX"}) then {
    _oldVal = (parseNumber _oldVal)/100000;
    // //diag_log text format["new freq: %1", _newVal];
    _newVal = parseNumber _newVal;
    // //diag_log text format["parse freq: %1", _newVal];
    private _modulation = HASH_GET(_channel, "modulation");
    private _spacing = 500;
    if (_modulation == "NB") then {
        _spacing = 625;
    };
    // //diag_log text format["check: %1 %2 %3", _newVal%_spacing, _newVal, _spacing];
    if (_newVal%_spacing != 0) then {
        // //diag_log text "!!!!!!!!!!! BAD FREQ!~!!!!!!!!!!!!!!";
        _newVal = _oldVal;
    } else {
        _newVal = _newVal/100000;
        if (_newVal > 512 || {_newVal < 30}) then {
            if (_key != "frequencyTX" && _newVal != 0) then {
                _newVal = _oldVal;
            };
        };
    };

    // //diag_log text format["final: %1", _newVal];
};
switch _key do {
    case "frequencyRX": {
        HASH_SET(_channel, "frequencyTX", _newVal);
    };
    case "CTCSSRx": {
        HASH_SET(_channel, "CTCSSTx", _newVal);
    };
    case "modulation": {
        if (_newVal == "AM") then {
            private _power = HASH_GET(_channel, "power");
            if (_power != 1000 && {_power != 5000}) then {
                HASH_SET(_channel, "power", 1000);
            };
            HASH_SET(_channel,"CTCSSTx", 0);
            HASH_SET(_channel,"CTCSSRx", 0);
        };
        if (_newVal == "NB") then {
            HASH_SET(_channel, "encryption", 0);
        };
    };
};
// //diag_log text format["old: %1 new: %2", typeName _oldVal, typeName _newVal];
if (_newVal != _oldVal) then {
    HASH_SET(_channel, _key, _newVal);
    ["setChannelData", [_channelNumber, _channel]] call GUI_DATA_EVENT;
};
