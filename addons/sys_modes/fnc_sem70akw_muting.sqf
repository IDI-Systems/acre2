#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if two radios in sem70AKW mode can "hear" eachother
 *
 * Arguments:
 * 0: Radio ID one <STRING>
 * 1: Radio ID two <STRING>
 *
 * Return Value:
 * TRUE if match <BOOL>
 *
 * Example:
 * ["_radioId1","_radioId2"] call acre_sys_modes_fnc_sem70akw_muting
 *
 * Public: No
 */

params ["_radioIdTX", "_radioIdRX"];

TRACE_1("SEM70AKWMuting",_this);

private _radioTxData = [_radioIdTX, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
private _radioRxData = [_radioIdRX, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);

private _modeTX = HASH_GET(_radioTxData,"mode");
private _modeRX = HASH_GET(_radioRxData,"mode");
private _match = false;

if (_modeTX == "sem70AKW" && {_modeRX == "sem70AKW"}) then {
    private _frequenciesTX = HASH_GET(_radioTxData,"frequencies");
    private _frequenciesRX = HASH_GET(_radioRxData,"frequencies");

    if (_frequenciesTX isEqualTo _frequenciesRX) then {
        _match = true;
    };
};

_match
