#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if two radios in singleChannel or singleChannelPRR mode can "hear" eachother
 *
 * Arguments:
 * 0: Radio ID one <STRING>
 * 1: Radio ID two <STRING>
 *
 * Return Value:
 * TRUE if match <BOOL>
 *
 * Example:
 * ["_radioId1","_radioId2"] call acre_sys_modes_fnc_sc_muting
 *
 * Public: No
 */

params ["_radioId1", "_radioId2"];

private _radioTxData = [_radioId1, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
private _radioRxData = [_radioId2, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);

private _mode1 = HASH_GET(_radioTxData,"mode");
private _mode2 = HASH_GET(_radioRxData,"mode");
private _match = false;
private _modeIsSingleChannel = (_mode1 == "singleChannel") && {_mode1 == _mode2};
private _modeIsSingleChannelPRR = (_mode1 == "singleChannelPRR") && {_mode1 == _mode2};

if (_modeIsSingleChannel || {_modeIsSingleChannelPRR}) then {
    private _freq1 = HASH_GET(_radioTxData,"frequencyTX");
    private _freq2 = HASH_GET(_radioRxData,"frequencyRX");
    if (_freq1 == _freq2) then {
        _match = true;
    };
};

_match
