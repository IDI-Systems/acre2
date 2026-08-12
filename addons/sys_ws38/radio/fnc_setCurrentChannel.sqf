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

TRACE_1("",_this);

params ["_radioId", "", "_eventData", "_radioData", ""];

TRACE_1("SETTING CURRENT CHANNEL",_this);

private _frequencyData = [_eventData] call FUNC(getFrequencyForChannel);
private _frequency = _frequencyData select 0;

// we use the power of the AN/PRC-77 radio due to range problems with the frequency and the power of the WS-38 radio. 
// The WS-38 is a low power radio and has a very limited range. We use the power of the AN/PRC-77 to increase the range of the WS-38 radio.
private _power = 4000;
if (_frequency < 34 || _frequency > 50) then {
    _power = 3500;

    if (_frequency > 53) then {
        _power = 3000;
    };
    if (_frequency > 71) then {
        _power = 2600;
    };
};
HASH_SET(_radioData,"currentChannel",_frequencyData select 1);
HASH_SET(_radioData,"frequencyTX",_frequency);
HASH_SET(_radioData,"frequencyRX",_frequency);
HASH_SET(_radioData,"encryption",1);
HASH_SET(_radioData,"TEK",1);
HASH_SET(_radioData,"power",_power);
