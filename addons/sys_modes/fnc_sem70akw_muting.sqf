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

params ["_radioIdTX","_radioIdRX"];

private _radioTxData = [_radioIdTX, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
private _radioRxData = [_radioIdRX, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);

private _modeTX = HASH_GET(_radioTxData, "mode");
private _modeRX = HASH_GET(_radioRxData, "mode");
private _networkIDTX = HASH_GET(_radioTxData, "networkID");
private _networkIDRX = HASH_GET(_radioRxData, "networkID");
private _frequenciesTX = HASH_GET(_radioTxData, "frequencies");
private _frequenciesRX = HASH_GET(_radioRxData, "frequencies");
private _match = false;

if(
    (_modeTX == "sem70AKW" && _modeRX == "sem70AKW") &&
    (_networkIDTX isEqualTo _networkIDRX) &&
    (_frequenciesTX isEqualTo _frequenciesRX)
) then {
    private _freqTX = HASH_GET(_radioTxData, "frequencyTX");

    private _freqRX = _frequenciesRX find _freqTX;
    if!(_freqRX isEqualTo -1) then {
        private _radioRXData = HASH_GET(acre_sys_data_radioData, _radioIdRX);
        private _currentChannel = [_radioIdRX, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
        private _channels = HASH_GET(_radioRXData, "channels");
        private _channel = HASHLIST_SELECT(_channels, _currentChannel);
        HASH_SET(_channel, "frequencyTX", _freqTX);
        HASH_SET(_channel, "frequencyRX", _freqTX);
        _match = [_radioIdRX, "setChannelData", [_currentChannel, _channel]] call EFUNC(sys_data,dataEvent); // Will be true if successful

        //_match = true;
    };
};

_match
