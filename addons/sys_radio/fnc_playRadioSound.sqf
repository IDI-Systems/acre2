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

params ["_radioId", "_className", "_position", "_direction", "_volume"];

private _isWorld = false;
private _volumeModifier = 1;
private _on = [_radioId, "getOnOffState"] call EFUNC(sys_data,dataEvent);
if (_on == 0) then {
    _volumeModifier = 0;
};
private _attenuate = 1;
if ([_radioId, "isExternalAudio"] call EFUNC(sys_data,dataEvent)) then {
    _position = [_radioId, "getExternalAudioPosition"] call EFUNC(sys_data,physicalEvent);
    _isWorld = true;
    private _args = [_position, ACRE_LISTENER_POS, acre_player];
    private _radioObject = [_radioId] call FUNC(getRadioObject);
    _attenuate = [_radioObject] call EFUNC(sys_attenuate,getUnitAttenuate);
    _attenuate = (1-_attenuate)^3;
    _volumeModifier = _args call EFUNC(sys_core,findOcclusion);
    _volumeModifier = _volumeModifier^3;
} else {
    private _ear = [_radioId, "getState", "ACRE_INTERNAL_RADIOSPATIALIZATION"] call EFUNC(sys_data,dataEvent);
    if (isNil "_ear") then {
        _ear = 0;
    };
    _position = [_ear*2, 0, 0];
};
[_className, _position, _direction, _volume*_volumeModifier*_attenuate, _isWorld] call EFUNC(sys_sounds,playSound);
