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

private ["_beeped", "_txId", "_currentTransmissions", "_volume"];

params["_radioId", "_eventKind", "_eventData"];

_txId = _eventData select 0;
_currentTransmissions = SCRATCH_GET(_radioId, "currentTransmissions");
_currentTransmissions = _currentTransmissions - [_txId];

if((count _currentTransmissions) == 0) then {
    _beeped = SCRATCH_GET(_radioId, "hasBeeped");
    _pttDown = SCRATCH_GET_DEF(_radioId, "PTTDown", false);
    if(!_pttDown) then {
        if(!isNil "_beeped" && {_beeped}) then {
            _volume = [_radioId, "getVolume"] call EFUNC(sys_data,dataEvent);
            [_radioId, "Acre_GenericClickOff", [0,0,0], [0,1,0], _volume] call EFUNC(sys_radio,playRadioSound);
        };
    };
    SCRATCH_SET(_radioId, "hasBeeped", false);
};

true;
