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
 * [ARGUMENTS] call acre_sys_prc343_fnc_getCurrentChannelData;
 *
 * Public: No
 */
#include "script_component.hpp"

params["_radioId", "_event", "_eventData", "_radioData"];

private _currentChannelId = HASH_GET(_radioData,"currentChannel");
if(isNil "_currentChannelId") then {
    _currentChannelId = 0;
};
private _radioChannels = HASH_GET(_radioData,"channels");
private _currentChannelData = HASHLIST_SELECT(_radioChannels, _currentChannelId);

private _return = HASH_CREATE;
HASH_SET(_return, "mode", "singleChannelPRR");
HASH_SET(_return, "frequencyTX", HASH_GET(_currentChannelData, "frequencyTX"));
HASH_SET(_return, "frequencyRX", HASH_GET(_currentChannelData, "frequencyRX"));
HASH_SET(_return, "power", 100);
_return
