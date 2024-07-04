#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns all information regarding the parsed radio channel.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getChannelData" <STRING> (Unused)
 * 2: Event data with the channel number <NUMBER>
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Mode, transmitting frequency, receiving frequency and power of the parsed channel <HASH>
 *
 * Example:
 * ["ACRE_PRC343_ID_1", "getChannelData", 2, _radioData, false] call acre_sys_prc343_fnc_getChannelData
 *
 * Public: No
 */

TRACE_1("343 getChannelData",_this);

params ["", "", "_eventData", "_radioData", ""];

private _channelNumber = _eventData;
private _channels = HASH_GET(_radioData,"channels");
private _channel = HASHLIST_SELECT(_channels,_channelNumber);

private _return = HASH_CREATE;
HASH_SET(_return,"mode","singleChannelPRR");
HASH_SET(_return,"frequencyTX",HASH_GET(_channel,"frequencyTX"));
HASH_SET(_return,"frequencyRX",HASH_GET(_channel,"frequencyRX"));
HASH_SET(_return,"power",100);
_return
