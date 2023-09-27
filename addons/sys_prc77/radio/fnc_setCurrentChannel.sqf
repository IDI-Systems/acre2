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
 * ["ACRE_PRC77_ID_1", "setCurrentChannel", 5, _radioData, false] call acre_sys_prc77_fnc_setCurrentChannel
 *
 * Public: No
 */

TRACE_1("", _this);

params ["_radioId", "", "_eventData", "_radioData", ""];

TRACE_1("SETTING CURRENT CHANNEL",_this);

private _currentBand = HASH_GET(_radioData,"band");
//Finding the MHz
//interpreting the band selector
private _baseMhzFrequency = 30;
if (_currentBand == 1) then {
    _baseMhzFrequency = 53;
};
//adding the value of the KnobPosition
private _MHz = _baseMhzFrequency + (_eventData select 0);
//Finding the kHz
private _kHz = (_eventData select 1)*0.05;
//Making it Arma-Float-Stable
_kHz = [_kHz, 1, 2] call CBA_fnc_formatNumber;
_kHz = parseNumber _kHz;
//Combining both
private _frequency = _MHz + _kHz;

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


HASH_SET(_radioData,"currentChannel",_eventData);
HASH_SET(_radioData,"frequencyTX",_frequency);
HASH_SET(_radioData,"frequencyRX",_frequency);
HASH_SET(_radioData,"power",_power);
