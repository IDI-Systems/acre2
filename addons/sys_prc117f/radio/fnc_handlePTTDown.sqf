#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_handlePTTDown
 *
 * Public: No
 */

params ["_radioId"];

if !([_radioId] call EFUNC(sys_radio,canUnitTransmit)) exitWith {false};

private _channelNumber = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
private _channelData = [_radioId, _channelNumber] call FUNC(getChannelDataInternal);

private _rxOnly = HASH_GET(_channelData, "rxOnly");
TRACE_3("RX ONLY", _radioId, _channelNumber, _rxOnly);
if (_rxOnly) exitWith {
    TRACE_1("EXITING RX ONLY", _rxOnly);
    false;
};

private _volume = [_radioId, "getVolume"] call EFUNC(sys_data,dataEvent);
[_radioId, "Acre_GenericBeep", [0, 0, 0], [0, 1, 0], _volume] call EFUNC(sys_radio,playRadioSound);
SCRATCH_SET(_radioId, "PTTDown", true);
true
