#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initiates the signal calculation function for a transmission between two radios. This is done on the receiving client
 *
 * Arguments:
 * 0: Transmitter <OBJECT>
 * 1: Transmitter Radio ID <STRING>
 * 2: Receiver <OBJECT>
 * 3: Receiver Radio ID <STRING>
 *
 * Return Value:
 * Signal Calculation Paramteres <ARRAY>
 *
 * Example:
 * [unit1, "_txRadioId", acre_player, "_rxRadioId"] call acre_sys_modes_fnc_sc_speaking
 *
 * Public: No
 */

params ["", "_txRadioId", "", "_rxRadioId"];

private _txData = [_txRadioId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
private _txFreq = HASH_GET(_txData,"frequencyTX");
private _txPower = HASH_GET(_txData,"power");

private _maxSignal = [0, -993];

if (_rxRadioId != _txRadioId) then {
    _maxSignal = [_txFreq, _txPower, _rxRadioId, _txRadioId] call EFUNC(sys_signal,getSignal);
} else {
    if ((toLower _txRadioId) in ACRE_SPECTATOR_RADIOS) then {
        _maxSignal = [1, 0];
    };
};

private _return = [_txRadioId, _rxRadioId, _maxSignal select 0, _maxSignal select 1, 0];

_return
