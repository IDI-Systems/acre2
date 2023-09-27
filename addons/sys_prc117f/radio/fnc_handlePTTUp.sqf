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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_handlePTTUp
 *
 * Public: No
 */

params ["_radioId"];

private _channelNumber = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
private _channelData = [_radioId, _channelNumber] call FUNC(getChannelDataInternal);

private _rxOnly = HASH_GET(_channelData, "rxOnly");
if (_rxOnly) exitWith {
    false
};

private _volume = [_radioId, "getVolume"] call EFUNC(sys_data,dataEvent);
[_radioId, "Acre_GenericClickOff", [0, 0, 0], [0, 1, 0], _volume] call EFUNC(sys_radio,playRadioSound);
SCRATCH_SET(_radioId, "PTTDown", false);
true;
