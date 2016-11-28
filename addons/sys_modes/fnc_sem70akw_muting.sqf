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
 #define DEBUG_MODE_FULL
#include "script_component.hpp"

params ["_radioIdTX","_radioIdRX"];

TRACE_1("SEM70AKWMuting", _this);

private _radioTxData = [_radioIdTX, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
private _radioRxData = [_radioIdRX, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);

private _modeTX = HASH_GET(_radioTxData, "mode");
private _modeRX = HASH_GET(_radioRxData, "mode");
private _frequenciesTX = HASH_GET(_radioTxData, "frequencies");
private _frequenciesRX = HASH_GET(_radioRxData, "frequencies");
private _match = false;

TRACE_4("Modes and Frequencies", _modeTX, _modeRX, _frequenciesRX, _frequenciesTX);

if(
    (_modeTX == "sem70AKW" && _modeRX == "sem70AKW") &&
    (_frequenciesTX isEqualTo _frequenciesRX)
) then {
    private _freqTX = HASH_GET(_radioTxData, "frequencyTX");
    //private _freqTX = [_radioIdTX, "getState", "transmittingFrequency"] call EFUNC(sys_data,dataEvent);

    TRACE_1("TX FREQ", _freqTX);

    private _freqRXNumber = _frequenciesRX find _freqTX;

    private _freqRX = HASH_GET(_radioRxData, "frequencyRX");

    TRACE_1("RX FREQ", _freqRX);
    if(_freqRX isEqualTo _freqTx) exitWith {_match = true;};
    if!(_freqRXNumber isEqualTo -1) then {
        [_radioIdRX, "setState", ["transmittingFrequency",_freqTx]] call EFUNC(sys_data,dataEvent);


        private _currentChannel = [_radioIdRX, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);

        TRACE_1("Channel", _currentChannel);

        HASH_SET(_radioRxData, "frequencyTX", _freqTX);
        HASH_SET(_radioRxData, "frequencyRX", _freqTX);
        _match = [_radioIdRX, "setChannelData", [_currentChannel, _radioRxData]] call EFUNC(sys_data,dataEvent); // Will be true if successful*/

        TRACE_1("Match", _match);

        //_match = true;
    };
};

diag_log str _match;

_match
