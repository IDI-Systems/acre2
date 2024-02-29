#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_initializeRadio
 *
 * Public: No
 */

params ["_radioId", "_event", "_eventData", "_radioData"];
_eventData params ["_baseName", "_preset"];

private _presetData = [_baseName, _preset] call EFUNC(sys_data,getPresetData);

private _channels = HASH_GET(_presetData,"channels");

private _currentChannels = HASH_GET(_radioData,"channels");
SCRATCH_SET(_radioId,"currentTransmissions",[]);

if (isNil "_currentChannels") then {
    _currentChannels = [];
    HASH_SET(_radioData,"channels",_currentChannels);
};

for "_i" from 0 to (count _channels)-1 do {
    private _channelData = HASH_COPY((_channels select _i));
    TRACE_1("Setting PRC-117F Init Channel Data",_channelData);
    PUSH(_currentChannels,_channelData);
};
HASH_SET(_radioData,"volume",EGVAR(sys_core,defaultRadioVolume));
HASH_SET(_radioData,"currentChannel",0);
HASH_SET(_radioData,"radioOn",1);
HASH_SET(_radioData,"pressedButton",-1);
HASH_SET(_radioData,"powerSource","BAT");
HASH_SET(_radioData,"pgm_pa_mode","ON");
