#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the audio source to speaker or back to default on the provided radio ID.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Speaker <BOOL>
 *
 * Return Value:
 * Success <BOOLEAN>
 *
 * Example:
 * _success = ["ACRE_PRC148_ID_123", true] call acre_api_fnc_setRadioSpeaker
 * _success = ["ACRE_PRC148_ID_123", false] call acre_api_fnc_setRadioSpeaker
 *
 * Public: Yes
 */

params [
    ["_radioId", "", [""]],
    ["_speaker", true, [true]]
];

private _radioType = [_radioId] call FUNC(getBaseRadio);

if (_radioType in ["ACRE_PRC148", "ACRE_PRC152"]) exitWith {
    private _audioSpeaker = ["TOPAUDIO", "INTAUDIO"] select _speaker;
    [_radioId, "setState", ["audioPath", _audioSpeaker]] call EFUNC(sys_data,dataEvent)
};

if (_radioType in ["ACRE_SEM70", "ACRE_SEM52SL"]) exitWith {
    private _audioSpeaker = ["HEADSET", "INTSPEAKER"] select _speaker;
    [_radioId, "setState", ["audioPath", _audioSpeaker]] call EFUNC(sys_data,dataEvent)
};

false
