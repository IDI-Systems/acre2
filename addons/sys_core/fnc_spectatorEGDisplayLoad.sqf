#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Enables spectator mode on Vanilla Spectator (EG Spectator) display load.
 *
 * Arguments:
 * Spectator Display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_spectatorEGDisplayLoad
 *
 * Public: No
 */

params ["_display"];

// Key handling compatibility for Vanilla Spectator (EG Spectator)
[_display] call FUNC(addDisplayPassthroughKeys);

[] call FUNC(spectatorOn);
