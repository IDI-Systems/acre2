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
        _match = true;
};

_match
