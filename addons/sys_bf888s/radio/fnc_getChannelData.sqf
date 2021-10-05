#include "script_component.hpp"
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
 * ["ACRE_BF888S_ID_1", "getChannelData", 2, _radioData, false] call acre_sys_bf888s_fnc_getChannelData
 *
 * Public: No
 */

TRACE_1("888S getChannelData", _this);
params ["_radioId", "", "_eventData", "_radioData"];

private _cachedChannels = SCRATCH_GET_DEF(_radioId, "cachedFullChannels", []);
private _return = nil;
if (_eventData < (count _cachedChannels)) then {
    _return = _cachedChannels select _eventData;
} else {
    _return = [_eventData, _radioData] call FUNC(getChannelDataInternal);
};
_return
