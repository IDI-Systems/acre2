#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the remote started speaking event for the spectator display.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Speaking Type <NUMBER>
 * 2: Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit, 1, _radioId] call acre_sys_spectator_fnc_handleStartedSpeaking
 *
 * Public: No
 */

params ["_unit", "_speakingType", "_radioId"];
_thisArgs params ["_display"]; //IGNORE_PRIVATE_WARNING ["_thisArgs"]

// Only need to handle radios
if (_speakingType != SPEAKING_TYPE_RADIO) exitWith {};

// Add unit to current speakers if they are using a spectator radio
if (_radioId in ACRE_SPECTATOR_RADIOS) then {
    private _speakers = _display getVariable QGVAR(speakers);
    [_speakers, _unit, _radioId] call CBA_fnc_hashSet;

    // Refresh speaking list
    [_display] call FUNC(refreshSpeakingList);
};
