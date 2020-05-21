#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initializes ACRE spectator radios handling for the EG Spectator display.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [DISPLAY] call acre_sys_spectator_fnc_spectatorEGDisplayLoad
 *
 * Public: No
 */

params ["_display"];

[_display, {uiNamespace getVariable ["RscEGSpectator_focus", objNull]}] call FUNC(initDisplay);
