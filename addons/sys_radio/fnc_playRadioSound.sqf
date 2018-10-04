#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Plays a radio sound.
 *
 * Arguments:
 * 0: Unique Radio ID <STRING>
 * 1: Sound classname <STRING>
 * 2: Position <ARRAY> (unused)
 * 3: Direction <ARRAY>
 * 4: Volume <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC343_ID_1", "Acre_GenericClickOff", [0,0,0], [0,1,0], 0.3] call acre_sys_radio_fnc_playRadioSound
 *
 * Public: No
 */

params ["_radioId", "_className", "", "_direction", "_volume"];

private _isWorld = false;
private _volumeModifier = 1;
private _on = [_radioId, "getOnOffState"] call EFUNC(sys_data,dataEvent);
if (_on == 0) then {
    _volumeModifier = 0;
};
private _attenuate = 1;
private _position = [0, 0, 0];

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
