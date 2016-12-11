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

TRACE_1("", _this);
params ["_radioId", "_event", "_eventData", "_radioData"];

private _currentChannelId = HASH_GET(_radioData,"currentChannel");
if (isNil "_currentChannelId") then {
    _currentChannelId = 0;
} else {
    if (_currentChannelId < 0) then {
        _currentChannelId = 0;
    };
};
private _radioChannels = HASH_GET(_radioData,"channels");
private _currentChannelData = HASHLIST_SELECT(_radioChannels, _currentChannelId);

private _optChannelId = HASH_GET(_radioData,"optChannelId");
private _opt = HASH_GET(_radioData,"optChannelData");

TRACE_4("", _currentChannelId, _currentChannelData, _optChannelId, _opt);

if (!(isNil "_optChannelId") && !(isNil "_opt")) then {
    if (_optChannelId == _currentChannelId) then {
        {
            private _key = _x;
            private _value = HASH_GET(_opt, _x);

            HASH_SET(_currentChannelData, _key, _value);
        } forEach HASH_KEYS(_opt);
    };
};

private _channelType = HASH_GET(_currentChannelData, "channelMode");
private _return = HASH_CREATE;
switch _channelType do {
    case "BASIC": {
        HASH_SET(_return, "mode", "singleChannel");
        HASH_SET(_return, "frequencyTX", HASH_GET(_currentChannelData, "frequencyTX"));
        HASH_SET(_return, "frequencyRX", HASH_GET(_currentChannelData, "frequencyRX"));
        HASH_SET(_return, "power", HASH_GET(_currentChannelData, "power"));
        HASH_SET(_return, "CTCSSTx", HASH_GET(_currentChannelData, "CTCSSTx"));
        HASH_SET(_return, "CTCSSRx", HASH_GET(_currentChannelData, "CTCSSRx"));
        HASH_SET(_return, "modulation", HASH_GET(_currentChannelData, "modulation"));
        HASH_SET(_return, "encryption", HASH_GET(_currentChannelData, "encryption"));
        HASH_SET(_return, "TEK", HASH_GET(_currentChannelData, "tek"));
        HASH_SET(_return, "trafficRate", HASH_GET(_currentChannelData, "trafficRate"));
        HASH_SET(_return, "syncLength", HASH_GET(_currentChannelData, "phase"));
    };
};
_return
