#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initialize volume control UI.
 *
 * Arguments:
 * Display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_missionDisplayLoad
 *
 * Public: No
 */

params ["_display"];

// Init the volume control
GVAR(MWheel) = _display displayAddEventHandler ["MouseZChanged", {call FUNC(onVolumeControlAdjust)}];
