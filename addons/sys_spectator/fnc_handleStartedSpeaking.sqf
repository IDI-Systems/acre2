#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the remote started speaking event for the spectator display.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: On Radio <NUMBER>
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

params ["_unit", "_onRadio", "_radioId"];
_thisArgs params ["_display"];

// Only need to handle radios
if (_onRadio != 1) exitWith {};

// Add unit to current speakers if they are using a spectator radio
if (_radioId in ACRE_SPECTATOR_RADIOS) then {
    private _speakers = _display getVariable QGVAR(speakers);
    [_speakers, _unit, _radioId] call CBA_fnc_hashSet;

    // Refresh speaking list
    [_display] call FUNC(refreshSpeakingList);
};
