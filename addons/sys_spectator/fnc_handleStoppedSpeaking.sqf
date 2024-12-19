#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the remote stopped speaking event for the spectator display.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit] call acre_sys_spectator_fnc_handleStoppedSpeaking
 *
 * Public: No
 */

params ["_unit"];
_thisArgs params ["_display"]; //IGNORE_PRIVATE_WARNING ["_thisArgs"]

private _speakers = _display getVariable QGVAR(speakers);

// Remove unit from current speakers if they were using a spectator radio
if ([_speakers, _unit] call CBA_fnc_hashHasKey) then {
    [_speakers, _unit] call CBA_fnc_hashRem;

    // Refresh speaking list
    [_display] call FUNC(refreshSpeakingList);
};
