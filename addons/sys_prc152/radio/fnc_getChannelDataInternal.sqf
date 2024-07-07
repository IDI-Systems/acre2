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
 * [ARGUMENTS] call acre_sys_prc152_fnc_getChannelDataInternal
 *
 * Public: No
 */

TRACE_1("",_this);

params ["_radioId"];
private _channels = [_radioId, "getState", "channels"] call EFUNC(sys_data,dataEvent);
private _optChannelId = [_radioId, "getState", "optChannelId"] call EFUNC(sys_data,dataEvent);
private _opt = [_radioId, "getState", "optChannelData"] call EFUNC(sys_data,dataEvent);

private _currentChannelId = -1;
if ((count _this) > 1) then {
    _currentChannelId = _this select 1;
} else {
    _currentChannelId = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
};

if (!(isNil "_optChannelId") && {!(isNil "_opt")}) then {
    if (_optChannelId != _currentChannelId) then {
        // The current channel is not the same as the operational channel so just return
        private _channel = HASHLIST_SELECT(_channels,_currentChannelId);
        _channel
    } else {
        // Get the actual channel data, then overlay it with the operational data
        private _channel = HASHLIST_SELECT(_channels,_currentChannelId);

        {
            private _key = _x;
            private _value = HASH_GET(_channel,_x);

            HASH_SET(_channel,_key,_value);
        } forEach HASH_KEYS(_opt);

        _channel
    };
} else {
    private _channel = HASHLIST_SELECT(_channels,_currentChannelId);
    _channel
};
