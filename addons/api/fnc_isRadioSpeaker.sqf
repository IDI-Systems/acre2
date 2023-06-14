#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns true or false whether the provided radio ID has audio source set to speaker or not.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * Is Audio Source Speaker <BOOL>
 *
 * Example:
 * _isSpeaker = ["ACRE_PRC148_ID_123"] call acre_api_fnc_isRadioSpeaker
 *
 * Public: Yes
 */

params [
    ["_radioId", "", [""]]
];

private _radioType = [_radioId] call FUNC(getBaseRadio);
private _audioSource = [_radioId] call FUNC(getRadioAudioSource);

if (_radioType in ["ACRE_PRC148", "ACRE_PRC152"] && {_audioSource == "INTAUDIO"}) exitWith {
    true
};
if (_radioType in ["ACRE_SEM70", "ACRE_SEM52SL"] && {_audioSource == "INTSPEAKER"}) exitWith {
    true
};

false
