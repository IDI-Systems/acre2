#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the local player stop speaking event.
 *
 * Arguments:
 * 0: Voice peer ID <NUMBER>
 * 1: Language ID <NUMBER>
 * 2: Speaking type (SPEAKING_TYPE_*) <NUMBER>
 * 3: Radio ID ("" if none) <STRING>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_core_fnc_localStopSpeaking
 *
 * Public: No
 */

TRACE_1("LOCAL STOP SPEAKING ENTER",_this);
params ["", "", ["_speakingType", SPEAKING_TYPE_DIRECT], ["_radioId", ""]];
if (!(_speakingType isEqualType 0)) then { _speakingType = parseNumber _speakingType; };

["acre_stoppedSpeaking", [acre_player, ACRE_LOCAL_BROADCASTING]] call CBA_fnc_localEvent; // [unit, on radio]
ACRE_LOCAL_SPEAKING = false;
ACRE_LOCAL_BROADCASTING = false;

// The radio we transmitted on can receive again (half duplex). TeamSpeak used to echo our own
// stop back as a remote stop, which is what reset this; the voice extension only reports it
// here. A transmission already started again on the same radio (quick re-key) keeps it.
if (_speakingType == SPEAKING_TYPE_RADIO && {_radioId == ACRE_BROADCASTING_RADIOID} && {!GVAR(pttKeyDown)}) then {
    ACRE_BROADCASTING_RADIOID = "";
};

if (_speakingType == SPEAKING_TYPE_RADIO && {!isNull GVAR(hearingSelf)}) then {
    GVAR(hearingSelf) setVariable [QGVAR(currentSpeakingRadio), ""];
    GVAR(hearingSelf) = objNull;
    GVAR(speaking_cache_valid) = false;
};

// Reset lowered voice curve level when not using a custom voice curve
if (isNil "ACRE_CustomVolumeControl") then {
    EGVAR(sys_gui,volumeLevel) call EFUNC(sys_gui,setVoiceCurveLevel);
};

true
