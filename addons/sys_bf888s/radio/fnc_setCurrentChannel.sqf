#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the desired channel as current.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "setCurrentChannel" <STRING> (Unused)
 * 2: Event data <NUMBER>
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_BF888S_ID_1", "setCurrentChannel", 5, _radioData, false] call acre_sys_BF888S_fnc_setCurrentChannel
 *
 * Public: No
 */

TRACE_1("", _this);
params ["_radioId", "", "_eventData", "_radioData", ""];

private _channelsCount = count ([_radioId, "getState", "channels"] call EFUNC(sys_data,dataEvent)) - 1;
_eventData = (0 max _eventData) min _channelsCount;

TRACE_1("SETTING CURRENT CHANNEL",_this);
HASH_SET(_radioData,"currentChannel",_eventData);
