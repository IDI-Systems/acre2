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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_formatText
 *
 * Public: No
 */

TRACE_1("formatText", _this);

params ["_text"];

// If we got a format hash, use it
if (count _this > 1) then {
    private _hash = _this select 1;
    {
        private _repStr = "%"+_x;
        _text = [_text, _repStr, HASH_GET(_hash, _x)] call CBA_fnc_replace;
    } forEach HASH_KEYS(_hash);
};

// Check for channel number formats
private _result = [_text, "$ch"] call CBA_fnc_find;
private _iter = 0;
while {_result != -1 && _iter < 5} do {
    TRACE_2("FOUND CHANNEL VALUE REPLACE", _text, _result);

    private _dash = [_text, "-", _result] call CBA_fnc_find;
    private _space = [_text, " ", _result] call CBA_fnc_find;
    if (_dash == -1) exitWith {};
    if (_space == -1) then { _space = count (toArray _text); };

    TRACE_4("BALLS", _text, _result, _dash, _space);
    private _channelNumber = (parseNumber ([_text, _result+3, (_dash - (_result+3))] call CBA_fnc_substr)) - 1;
    private _key = [_text, _dash+1, (_space - _dash)] call CBA_fnc_substr;
    private _replacementValue = [_text, _result, (_space - _result)] call CBA_fnc_substr;
    TRACE_3("Replacement index", _replacementValue, _channelNumber, _key);

    private _channel = HASHLIST_SELECT(GET_STATE("channels"), _channelNumber);
    private _value = HASH_GET(_channel, _key);

    TRACE_2("channel data", _channelNumber, _channel);
    TRACE_3("Performing replacement", _text, _key, _value);
    _text = [
        _text,
        _replacementValue,
        [_key, _value] call FUNC(formatChannelValue)
    ] call CBA_fnc_replace;
    TRACE_1("DONE", _text);

    _iter = _iter + 1;
    _result = [_text, "$ch"] call CBA_fnc_find;
};
_result = [_text, "$bat"] call CBA_fnc_find;
if(_result != -1) then {
    _text = [_text, "$bat", GET_STATE("powerSource")] call CBA_fnc_replace;
};
_result = [_text, "$transmitting"] call CBA_fnc_find;
if (_result != -1) then {
    private _transText = "R";
    if (ACRE_LOCAL_BROADCASTING && {ACRE_BROADCASTING_RADIOID isEqualTo GVAR(currentRadioId)}) then { _transText = "T"; };
    _text = [_text, "$transmitting", _transText] call CBA_fnc_replace;
};

// Check for current channel formats
_result = [_text, "$cch"] call CBA_fnc_find;
if (_result != -1) then {
    // Do replacements from current channel next
    private _channelNumber = ["getCurrentChannel"] call EFUNC(sys_data,guiDataEvent);
    private _channel = [GVAR(currentRadioId), _channelNumber] call FUNC(getChannelDataInternal);

    // Replace channel number if its there
    _result = [_text, "$cch-number"] call CBA_fnc_find;
    if (_result != -1) then {
        _text = [_text, "$cch-number", ([_channelNumber+1, 2] call CBA_fnc_formatNumber)] call CBA_fnc_replace;
    };

    TRACE_2("channel data", _channelNumber, _channel);
    {
        private _repStr = "$cch-" + _x;
        private _value = [ _x, HASH_GET(_channel, _x)] call FUNC(formatChannelValue);
        TRACE_3("Calling replace", _text, _repStr, _value);
        _result = [_text, _x] call CBA_fnc_find;
        if (_result != -1) then {
            _text = [_text, _repStr, _value] call CBA_fnc_replace;
        };
    } forEach HASH_KEYS(_channel);
};

// TODO: We need to find a way to replace icon shit.
TRACE_1("Returning", _text);
_text
