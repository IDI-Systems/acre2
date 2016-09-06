/*
 * Author: AUTHOR
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

params ["_radioId1","_radioId2"];

private _radioTxData = [_radioId1, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
private _radioRxData = [_radioId2, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);

private _mode1 = HASH_GET(_radioTxData, "mode");
private _mode2 = HASH_GET(_radioRxData, "mode");
private _match = false;
if(
    (_mode1 == "singleChannel" && _mode2 == "singleChannel") ||
    (_mode1 == "singleChannelPRR" && _mode2 == "singleChannelPRR")
) then {
    private _freq1 = HASH_GET(_radioTxData, "frequencyTX");
    private _freq2 = HASH_GET(_radioRxData, "frequencyRX");
    if(_freq1 == _freq2) then {
        _match = true;
    };
};

_match
