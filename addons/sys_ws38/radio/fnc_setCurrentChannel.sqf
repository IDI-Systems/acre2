#include "..\script_component.hpp"
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
 * ["ACRE_WS38_ID_1", "setCurrentChannel", 5, _radioData, false] call acre_sys_ws38_fnc_setCurrentChannel
 *
 * Public: No
 */

TRACE_1("", _this);

params ["_radioId", "", "_eventData", "_radioData", ""];

TRACE_1("SETTING CURRENT CHANNEL",_this);

private _frequencyData = [_eventData] call FUNC(getFrequencyForChannel);

HASH_SET(_radioData,"currentChannel",_frequencyData select 1);
HASH_SET(_radioData,"frequencyTX",_frequencyData select 0);
HASH_SET(_radioData,"frequencyRX",_frequencyData select 0);
HASH_SET(_radioData,"power",200);
