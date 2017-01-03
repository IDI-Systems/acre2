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
