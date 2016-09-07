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

TRACE_1("formatText", _this);
private["_hash", "_formatStringFunc", "_channelNumber", "_channel", "_channels", "_result", "_iter", "_dash", "_space", "_key", "_value", "_replacementValue"];
params ["_text"];

// If we got a format hash, use it
if(count _this > 1) then {
    _hash = _this select 1;
    {
        private["_repStr"];
        _repStr = "%"+_x;
        _text = [_text, _repStr, HASH_GET(_hash, _x)] call CBA_fnc_replace;
    } forEach HASH_KEYS(_hash);
};

// Check for channel number formats
_result = [_text, "$ch"] call LIB_fnc_find;
_iter = 0;
while { _result != -1 && _iter < 5} do {
    private["_channelString"];
    TRACE_2("FOUND CHANNEL VALUE REPLACE", _text, _result);

    _dash = [_text, "-", _result] call LIB_fnc_find;
    _space = [_text, " ", _result] call LIB_fnc_find;
    if(_dash == -1) exitWith {};
    if(_space == -1) then { _space = count (toArray _text); };

    TRACE_4("BALLS", _text, _result, _dash, _space);
    _channelNumber = (parseNumber ([_text, _result+3, (_dash - (_result+3))] call LIB_fnc_substring)) - 1;
    _key = [_text, _dash+1, (_space - _dash)] call LIB_fnc_substring;
    _replacementValue = [_text, _result, (_space - _result)] call LIB_fnc_substring;
    TRACE_3("Replacement index", _replacementValue, _channelNumber, _key);

    _channel = HASHLIST_SELECT(GET_STATE("channels"), _channelNumber);
    _value = HASH_GET(_channel, _key);

    TRACE_2("channel data", _channelNumber, _channel);
    TRACE_3("Performing replacement", _text, _key, _value);
    _text = [_text, _replacementValue,
    (
        [
            _key,
            _value
        ] call FUNC(formatChannelValue)
    )
    ] call CBA_fnc_replace;
    TRACE_1("DONE", _text);

    _iter = _iter + 1;
    _result = [_text, "$ch"] call LIB_fnc_find;
};

// Check for current channel formats
_result = [_text, "$cch"] call LIB_fnc_find;
if(_result != -1) then {
    // Do replacements from current channel next
    _channelNumber = ["getCurrentChannel"] call EFUNC(sys_data,guiDataEvent);
    _channel = [GVAR(currentRadioId), _channelNumber] call FUNC(getChannelDataInternal);

    // Replace channel number if its there
    _result = [_text, "$cch-number"] call LIB_fnc_find;
    if(_result != -1) then {
        _text = [_text, "$cch-number", ([_channelNumber+1, 2] call CBA_fnc_formatNumber)] call CBA_fnc_replace;
    };

    TRACE_2("channel data", _channelNumber, _channel);
    {
        private["_repStr"];
        _repStr = "$cch-" + _x;
        _value = [ _x, HASH_GET(_channel, _x) ] call FUNC(formatChannelValue);
        TRACE_3("Calling replace", _text, _repStr, _value);
        _result = [_text, _x] call LIB_fnc_find;
        if(_result != -1) then {
            _text = [_text, _repStr, _value] call CBA_fnc_replace;
        };
    } forEach HASH_KEYS(_channel);
};

// TODO: We need to find a way to replace icon shit.
TRACE_1("Returning", _text);
_text
