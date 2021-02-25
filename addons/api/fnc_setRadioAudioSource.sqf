#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the audio source on the provided radio ID.
 * Possible Values for ACRE_PRC148: ["INTAUDIO", "TOPAUDIO", "TOPSIDETON", "SIDEAUDIO", "SIDESIDETON"]
 * Possible Values for ACRE_PRC152: ["INTAUDIO", "TOPAUDIO"]
 * Possible Values for ACRE_SEM52SL: ["INTSPEAKER", "HEADSET"]
 * Possible Values for ACRE_SEM70: ["INTSPEAKER", "HEADSET"]
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Audio Source <STRING>
 *
 * Return Value:
 * Success <BOOLEAN>
 *
 * Example:
 * _success = ["ACRE_PRC148_ID_123", "INTAUDIO"] call acre_api_fnc_setRadioAudioSource
 *
 * Public: Yes
 */

params [
    ["_radioId", "", [""]],
    ["_audioSource", "", [""]]
];

private _radioType = [_radioId] call FUNC(getBaseRadio);

if (_radioType isEqualTo "ACRE_PRC148" && {_audioSource in ["INTAUDIO", "TOPAUDIO", "TOPSIDETON", "SIDEAUDIO", "SIDESIDETON"]}) exitWith {
    [_radioId, "setState", ["audioPath", _audioSource]] call EFUNC(sys_data,dataEvent)
};

if (_radioType isEqualTo "ACRE_PRC152" && {_audioSource in ["INTAUDIO", "TOPAUDIO"]}) exitWith {
    [_radioId, "setState", ["audioPath", _audioSource]] call EFUNC(sys_data,dataEvent)
};

if (_radioType isEqualTo "ACRE_SEM52SL" && {_audioSource in ["INTSPEAKER", "HEADSET"]}) exitWith {
    [_radioId, "setState", ["audioPath", _audioSource]] call EFUNC(sys_data,dataEvent)
};

if (_radioType isEqualTo "ACRE_SEM70" && {_audioSource in ["INTSPEAKER", "HEADSET"]}) exitWith {
    [_radioId, "setState", ["audioPath", _audioSource]] call EFUNC(sys_data,dataEvent)
};

false
