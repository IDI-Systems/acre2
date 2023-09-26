#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets the channel data. It consists of mode, transmitting and receiving frequencies and power
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getCurrentChannelData" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Hash with mode, transmitting and receiving frequencies and power <HASH>
 *
 * Example:
 * ["ACRE_PRC343_ID_1", "getCurrentChannelData", [], _radioData, false] call acre_sys_prc343_fnc_getCurrentChannelData
 *
 * Public: No
 */

params ["", "", "", "_radioData", ""];

private _currentChannelId = HASH_GET(_radioData,"currentChannel");
if (isNil "_currentChannelId") then {
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
